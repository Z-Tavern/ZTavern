const Sequelize         = require('sequelize')
const bcrypt            = require('bcrypt')
const Models            = require('./DatabaseModels.js')
const path              = require('path')
const Permissions       = require(path.join(__dirname, `../Configuration/NSMConfiguration.json`)).Permissions

class MetaService {
    constructor(Models) {
        this.Models = Models
    }
    async addPersistentMeta(Key, Value, ClientId) {
        if (!ClientId) return null

        var meta = await this.Models.NSMMeta.findAll({
            where: {
                ClientId,
                Key
            },
            raw: true
        })

        if (!meta.length) {
            await this.Models.NSMMeta.build({
                ClientId,
                Key,
                Value
            }).save()
            return
        }

        await this.Models.NSMMeta.update(
            { Value: Value },
            { where: { ClientId, Key } })
    }
    async deletePersistentMeta(Key, ClientId) {
        if (!ClientId) return null

        return await this.Models.NSMMeta.destroy({
            where: {
                ClientId,
                Key
            }
        })
    }
    async reversePersistentMeta(Key, Value) {
        var meta = await this.Models.NSMMeta.findAll({
            where: {
                Value,
                Key
            },
            raw: true
        })

        return meta.length ? meta[0] : null
    }
    async getPersistentMeta(Key, ClientId, type = '') {
        if (!ClientId) return null
        
        var meta = await this.Models.NSMMeta.findAll({
            where: {
                ClientId,
                Key
            },
            raw: true
        })

        if (meta.length) {
            switch (type) {
                case 'bool':
                    meta[0].Value = parseInt(meta[0].Value) == 1
                    break
                case 'int':
                    meta[0].Value = parseInt(meta[0].Value)
                    break
                case 'float':
                    meta[0].Value = parseFloat(meta[0].Value)
                    break
                case 'json':
                    meta[0].Value = JSON.parse(meta[0].Value)
                    break
            }
        }

        return meta.length ? meta[0] : null
    }
}

class Database {
    constructor () {
        this.clientCache = []
        this.Models = Models
        this.cache = {}
        this.shortCache = {}
        this.metaService = new MetaService(Models)
        this.clientProfileMeta = [
            async (ClientId) => {
                var stats = await this.getPlayerStatsTotal(ClientId)
                if (!stats) return {}
                return  {
                        name: 'Stats',
                        data: {
                            'Kills': stats.Kills ? stats.Kills : 0,
                            'Deaths': stats.Deaths ? stats.Deaths : 0,
                            'KDR': (stats.Kills / Math.max(stats.Deaths, 1)).toFixed(2),
                            'Performance': stats.Performance.toFixed(2)
                        }
                    }
            }
        ]
        setInterval(() => {
            this.cache = {}
        }, 60 * 1000 * 30)

        setInterval(() => {
            this.shortCache = {}
        }, 60 * 1000 * 5)
    }

    async getClientProfileMeta(ClientId) {
        if (this.shortCache[`META_${ClientId}`]) return this.shortCache[`META_${ClientId}`]

        this.shortCache[`META_${ClientId}`] = []
        for (var i = 0; i < this.clientProfileMeta.length; i++) {
            this.shortCache[`META_${ClientId}`].push(await this.clientProfileMeta[i](ClientId))
        }

        return this.shortCache[`META_${ClientId}`]
    }

    async startTransaction() {
        if (this.transaction) return
        this.transaction = await Models.DB.transaction()
    }

    async addClient(Guid) {
        await this.startTransaction()

        var ClientId = await this.getClientId(Guid)
        if (ClientId) return ClientId

        if (!(await this.getClientId('Node'))) {
            try {
                await Models.NSMClients.build({
                    Guid: 'Node',
                    PermissionLevel: 6
                }, {transaction: this.transaction}).save()
            }
            catch (e) { }
        }

        if (!(await this.getClientSettings(1))) {
            await Models.NSMSettings.build({
                ClientId: 1
            }, {transaction: this.transaction}).save()
        }

        var Client = await Models.NSMClients.build({
            Guid: Guid
        }, {transaction: this.transaction}).save()

        return Client.dataValues.ClientId
    }

    async initializeStats(ClientId) {
        try {
            if (!(await this.getPlayerStatsTotal(ClientId))) {
                await Models.NSMPlayerStats.build({
                    ClientId: ClientId
                }, {transaction: this.transaction}).save()
            }
    
            if (!(await this.getClientSettings(ClientId))) {
                await Models.NSMSettings.build({
                    ClientId
                }, {transaction: this.transaction}).save()
            }
        }
        catch (e) {}
    }

    async setClientSetting(ClientId, Setting, Value) {
        await Models.NSMSettings.update(
            { [Setting]: Value },
            { where: { ClientId: ClientId } }, {transaction: this.transaction})
        // await this.transaction.commit()
    }

    async getClientSettings(ClientId) {

        var Settings = await Models.NSMSettings.findAll({
            where: {
                ClientId
            }
        }, {transaction: this.transaction})
        return Settings.length > 0 ? Settings[0].dataValues : false
    }

    async getMostUsedWeapon(ClientId) {
        var Weapon = await Models.NSMKills.findAll({
            attributes: ['BaseWeapon', [Sequelize.fn('count', Sequelize.col('BaseWeapon')), 'occurrence']],
            where: {
                ClientId: ClientId
            },
            limit: 1,
            order: [
                [Sequelize.literal('occurrence'), 'desc']
            ],
            group: ['BaseWeapon']
        }, {transaction: this.transaction})
        
        return Weapon.length > 0 ? Weapon[0].dataValues.BaseWeapon : false
    }

    async getMostCommonHitLoc(ClientId) {
        var HitLoc = await Models.NSMKills.findAll({
            attributes: ['HitLoc', [Sequelize.fn('count', Sequelize.col('HitLoc')), 'occurrence']],
            where: {
                ClientId: ClientId
            },
            limit: 1,
            order: [
                [Sequelize.literal('occurrence'), 'desc']
            ],
            group: ['HitLoc']
        }, {transaction: this.transaction})
        
        return HitLoc.length > 0 ? HitLoc[0].dataValues.HitLoc : false
    }

    async getTotalDamage(ClientId) {
        var Damage = await Models.NSMKills.findAll({
            attributes: [[Sequelize.fn('sum', Sequelize.col('Damage')), 'totalDamage']],
            where: {
                TargetId: ClientId
            },
            group: ['BaseWeapon']
        }, {transaction: this.transaction})
        
        return Damage.length > 0 ? Damage[0].dataValues.totalDamage : false
    }

    async getPlayerPersStats(ClientId, stat)
    {
        var Pers = (await Models.NSMZStats.findAll({
            where: {
                ClientId: ClientId
            },
            attributes: ['Easter', 'Event', 'ClientId', 'Kills', 'Downs', 'Revives', 'HighestRound', 'Headshots', 'Score', [Sequelize.literal('ROW_NUMBER() over (order by Kills desc)'), 'Rank']],
            order: [
                [stat, 'desc']
            ]
        })).map(x => x = x.dataValues)     
            Pers[0].Name = await this.getName(Pers[0].ClientId)
        return Pers
    }

    async getPlayerKills(ClientId) {
        var Kills = await Models.NSMKills.findAll({
            where: {
                ClientId: ClientId
            }
        }, {transaction: this.transaction})

        return Kills.length
    }

    async addEventRecord(Server, Client, Event) {
        Server.DB.Models.NSMZStats.update({
            Event: Event,
        },
        {where: {ClientId: Client.ClientId}}) 
    }

    async addEERecord(Server, Client, Easter) {
        Server.DB.Models.NSMZStats.update({
            Easter: Easter,
        },
        {where: {ClientId: Client.ClientId}}) 
    }    

    async getPlayerStatsLDB(stat)
    {
        var NSMZStats = await Models.DB.define('NSMZStats')

        if (stat == "Easter")
        {
            var Event = (await NSMZStats.findAll({
                limit: 5,
                offset: 0,
                where: {
                    Easter: {
                        [Sequelize.Op.gt]: 0
                    }
                },
                attributes: ['Easter', 'Event', 'ClientId', 'Kills', 'Downs', 'Revives', 'HighestRound', 'Headshots', 'Score', [Sequelize.literal('ROW_NUMBER() over (order by Kills desc)'), 'Rank']],
                order: [
                    [stat, 'desc']
                ]
            })).map(x => x = x.dataValues) 
        }
        else if (stat == "Event")
        {
            var Event = (await NSMZStats.findAll({
                limit: 5,
                offset: 0,
                where: {
                    Event: {
                        [Sequelize.Op.gt]: 0
                    }
                },
                attributes: ['Easter', 'Event', 'ClientId', 'Kills', 'Downs', 'Revives', 'HighestRound', 'Headshots', 'Score', [Sequelize.literal('ROW_NUMBER() over (order by Kills desc)'), 'Rank']],
                order: [
                    [stat, 'desc']
                ]
            })).map(x => x = x.dataValues)
        }
        else if (stat == "Kills")
        {
            var Event = (await NSMZStats.findAll({
                limit: 5,
                offset: 0,
                where: {
                    Kills: {
                        [Sequelize.Op.gt]: 0
                    }
                },
                attributes: ['Easter', 'Event', 'ClientId', 'Kills', 'Downs', 'Revives', 'HighestRound', 'Headshots', 'Score', [Sequelize.literal('ROW_NUMBER() over (order by Kills desc)'), 'Rank']],
                order: [
                    [stat, 'desc']
                ]
            })).map(x => x = x.dataValues)
        }
        else if (stat == "Downs")
        {
            var Event = (await NSMZStats.findAll({
                limit: 5,
                offset: 0,
                where: {
                    Downs: {
                        [Sequelize.Op.gt]: 0
                    }
                },
                attributes: ['Easter', 'Event', 'ClientId', 'Kills', 'Downs', 'Revives', 'HighestRound', 'Headshots', 'Score', [Sequelize.literal('ROW_NUMBER() over (order by Kills desc)'), 'Rank']],
                order: [
                    [stat, 'desc']
                ]
            })).map(x => x = x.dataValues)
        }
        else if (stat == "Revives")
        {
            var Event = (await NSMZStats.findAll({
                limit: 5,
                offset: 0,
                where: {
                    Revives: {
                        [Sequelize.Op.gt]: 0
                    }
                },
                attributes: ['Easter', 'Event', 'ClientId', 'Kills', 'Downs', 'Revives', 'HighestRound', 'Headshots', 'Score', [Sequelize.literal('ROW_NUMBER() over (order by Kills desc)'), 'Rank']],
                order: [
                    [stat, 'desc']
                ]
            })).map(x => x = x.dataValues)
        }
        else if (stat == "HighestRound")
        {
            var Event = (await NSMZStats.findAll({
                limit: 5,
                offset: 0,
                where: {
                    HighestRound: {
                        [Sequelize.Op.gt]: 0
                    }
                },
                attributes: ['Easter', 'Event', 'ClientId', 'Kills', 'Downs', 'Revives', 'HighestRound', 'Headshots', 'Score', [Sequelize.literal('ROW_NUMBER() over (order by Kills desc)'), 'Rank']],
                order: [
                    [stat, 'desc']
                ]
            })).map(x => x = x.dataValues)
        }
        else if (stat == "Headshots")
        {
            var Event = (await NSMZStats.findAll({
                limit: 5,
                offset: 0,
                where: {
                    Headshots: {
                        [Sequelize.Op.gt]: 0
                    }
                },
                attributes: ['Easter', 'Event', 'ClientId', 'Kills', 'Downs', 'Revives', 'HighestRound', 'Headshots', 'Score', [Sequelize.literal('ROW_NUMBER() over (order by Kills desc)'), 'Rank']],
                order: [
                    [stat, 'desc']
                ]
            })).map(x => x = x.dataValues)
        }
        else if (stat == "Score")
        {
            var Event = (await NSMZStats.findAll({
                limit: 5,
                offset: 0,
                where: {
                    Score: {
                        [Sequelize.Op.gt]: 0
                    }
                },
                attributes: ['Easter', 'Event', 'ClientId', 'Kills', 'Downs', 'Revives', 'HighestRound', 'Headshots', 'Score', [Sequelize.literal('ROW_NUMBER() over (order by Kills desc)'), 'Rank']],
                order: [
                    [stat, 'desc']
                ]
            })).map(x => x = x.dataValues)
        }







        for (var i = 0; i < Event.length; i++) {
            Event[i].Name = await this.getName(Event[i].ClientId)
        }
        return Event
    }
    async getPlayerDeaths(ClientId) {

        var Deaths = await Models.NSMKills.findAll({
            where: {
                TargetId: ClientId
            }
        }, {transaction: this.transaction})

        return Deaths.length
    }

    async getOwner() {

        var Owner = await Models.NSMClients.findAll({
            where: {
                PermissionLevel: 5
            }
        }, {transaction: this.transaction})
        
        return Owner.length > 0 ? Owner[0].dataValues : false
    }
    async getClientByName(Name, Limit = 50) {
        var _Clients = await Models.NSMConnections.findAll({
            group: ['ClientId'],
            order: [
                ['Date', 'desc']
            ],
            limit: Limit,
            where: {
                Name: {
                    [Sequelize.Op.like]: `%${Name.toLocaleLowerCase()}%`
                }
            }
        }, {transaction: this.transaction})
        var Clients = []
        for (var i = 0; i < _Clients.length; i++) {
            var Client = await this.getClient(_Clients[i].dataValues.ClientId)
            Client.Name = _Clients[i].dataValues.Name
            Client.IPAddress = _Clients[i].dataValues.IPAddress
            Clients.push(Client)
        }
        return Clients
    }

    async clearReports() {
        await Models.NSMReports.update(
            { Active: false },
            { where: {  } }, {transaction: this.transaction}
        )
    }

    async getActiveReports() {
        return await Models.NSMReports.findAll({
            where: {
                Active: true,
            },
        }, {transaction: this.transaction})
    }

    async addReport(OriginId, TargetId, Reason) {
        await Models.NSMReports.build({OriginId, TargetId, Reason}, {transaction: this.transaction}).save()
    }

    async logActivity(Origin, Type, Description) {
        await Models.NSMAudit.build({
            Origin,
            Type,
            Description
        }, {transaction: this.transaction}).save()
        // await this.transaction.commit()
    }

    async getAudit(pageNumber, limit) {
        var Audit = await Models.NSMAudit.findAll({
            order: [
                ['Date', 'desc']
            ],
            limit: limit,
            offset: pageNumber * limit,
        }, {transaction: this.transaction})
        Audit.map(x => x = x.dataValues)
        for (var i = 0; i < Audit.length; i++) {
            try {
                var Name = this.clientCache[parseInt(Audit[i].Origin.substr(1))] ? this.clientCache[parseInt(Audit[i].Origin.substr(1))].Name : (await this.getClient(Audit[i].Origin.substr(1))).Name
            }
            catch (e) {
                Audit[i] = null
                continue
            }
            Audit[i].Origin = {
                Name: Audit[i].Origin.match(/\@([0-9]+)/g) ? Name : Audit[i].Origin,
                ClientId: Audit[i].Origin.match(/\@([0-9]+)/g) ? Audit[i].Origin.substr(1) : null
            }
        }
        return Audit
    }

    async getClientLevel(ClientId) {

        var Level = await Models.NSMClients.findAll({
            arguments: ['PermissionLevel'],
            where: {
                ClientId: ClientId
            }
        }, {transaction: this.transaction})

        return Level[0].dataValues.PermissionLevel
    }

    async unbanClient(TargetId, OriginId, Reason) {
        var Aliases = [{ ClientId: TargetId, OriginId: TargetId }]

        Aliases = Aliases.concat(await this.getAliases(TargetId))

        var count = 0

        for (var i = 0; i < Aliases.length; i++) {
            var Alias = Aliases[i]

            var result = await Models.NSMPenalties.update(
                { Active: false },
                { where: {
                    [Sequelize.Op.or]: [
                        { TargetId: Alias.ClientId },
                        { TargetId: Alias.OriginId }
                    ],
                    Active: true, 
                    PenaltyType: { 
                        [Sequelize.Op.not]: 'PENALTY_UNBAN'
                    } 
                }, raw: true }, 
                {transaction: this.transaction}
            )

            count += parseInt(result[0])
        }

        count > 0 && await Models.NSMPenalties.build({
            TargetId,
            OriginId,
            PenaltyType: 'PENALTY_UNBAN',
            Duration: 0,
            Reason: Reason
        }, {transaction: this.transaction})

        return count
    }

    async getClient(ClientId) {
        if (!ClientId) return false

        if (ClientId == 1) {
            return {
                Name: 'Node Server Manager',
                ClientId: 1,
                PermissionLevel: Permissions.Levels['ROLE_MANAGER'],
                Guid: 'node',
                IPAddress: '127.0.0.1',
                Settings: await this.getClientSettings(1)
            }
        }

        var Client = await Models.NSMClients.findAll({
            where: {
                ClientId: ClientId
            }
        }, {transaction: this.transaction})

        var Connection = await Models.NSMConnections.findAll({
            order: [
                ['Date', 'desc']
            ],
            limit: 1,
            where: {
                ClientId: ClientId
            }
        }, {transaction: this.transaction})

        if (Connection.length == 0) return false

        delete Client[0].dataValues.Password
        
        var Client = {...Client[0].dataValues, ...Connection[0].dataValues}

        Client.Settings = await this.getClientSettings(ClientId)

        this.clientCache[parseInt(ClientId)] = Client

        return Client
    }

    async addPenalty(PenaltyMeta) {
        var Aliases = await this.getAliases(PenaltyMeta.TargetId)

        if (PenaltyMeta.PenaltyType != 'PENALTY_KICK') {
            Aliases.forEach(async Alias => {
                // terrible but need this asap
    
                if (Alias.OriginId != PenaltyMeta.TargetId) {
                    await Models.NSMPenalties.build({ ...PenaltyMeta, ...{ TargetId: Alias.OriginId }}, {transaction: this.transaction}).save()
                }
    
                if (Alias.ClientId != PenaltyMeta.TargetId) {
                    await Models.NSMPenalties.build({ ...PenaltyMeta, ...{ TargetId: Alias.ClientId }}, {transaction: this.transaction}).save()
                }
            })
        }

        var Penalty = await Models.NSMPenalties.build(PenaltyMeta, {transaction: this.transaction}).save() 

        return Penalty.dataValues
    }

    async setLevel(Player, Level) {
        Models.NSMClients.update(
            { PermissionLevel: Level },
            { where: { ClientId: Player.ClientId } }
            , {transaction: this.transaction})
        // await this.transaction.commit()
    }

    async getAllPenalties(ClientId = null) {
        var where = ClientId ? {
            where: {
                TargetId: ClientId,
            }
        } : null

        if (ClientId) {
            var Aliases = await this.getAliases(ClientId)
            var allPenalties = []

            Aliases.forEach(async Alias => {
                var Penalties = await Models.NSMPenalties.findAll({
                    where: Sequelize.or(
                        { TargetId: Alias.ClientId },
                        { TargetId: Alias.OriginId }
                    ),
                }, {transaction: this.transaction})

                for (var i = 0; i < Penalties.length; i++) {
                    Penalties[i] = Penalties[i].dataValues
                }

                allPenalties = allPenalties.concat(Penalties)
            })

            var Penalties = await Models.NSMPenalties.findAll({
                where: {
                    TargetId: ClientId 
                }
            }, {transaction: this.transaction})

            for (var i = 0; i < Penalties.length; i++) {
                Penalties[i] = Penalties[i].dataValues
            }

            allPenalties = allPenalties.concat(Penalties)

            return allPenalties
        }

        var Penalties = await Models.NSMPenalties.findAll(where, {transaction: this.transaction})

        for (var i = 0; i < Penalties.length; i++) {
            Penalties[i] = Penalties[i].dataValues
        }

        return Penalties
    }

    async getStats(pageNumber, limit, sort) {
        try {
            var Stats = await Models.NSMPlayerStats.findAll({
                limit: limit,
                order: [
                    [sort, 'desc']
                ],
                offset: limit * pageNumber
            }, {transaction: this.transaction})
        }
        catch (e) {
            var Stats = await Models.NSMPlayerStats.findAll({
                limit: limit,
                order: [
                    ['Kills', 'desc']
                ],
                offset: limit * pageNumber
            }, {transaction: this.transaction})
        }

        for (var i = 0;  i < Stats.length; i++) {
            Stats[i] = Stats[i].dataValues
            Stats[i].Client =  (await this.getClient(Stats[i].ClientId))
        }
        return Stats
    }

    async getClientMeta(ClientId) {
        var Meta = {
            MostUsed: await this.getMostUsedWeapon(ClientId),
            HitLoc: await this.getMostCommonHitLoc(ClientId),
            Damage: await this.getTotalDamage(ClientId)
        }
        return Meta
    }

    async getClientField(ClientId, Field) {
        var Fields = await Models.NSMClients.findAll({
            where: {
                ClientId: ClientId
            }
        }, {transaction: this.transaction})

        return Fields.length > 0 ? Fields[0].dataValues[Field] : false
    }

    async setClientField(ClientId, Field, Value) {
        Models.NSMClients.update(
            { [Field] : Value},
            {where: {ClientId: ClientId}}, {transaction: this.transaction})
        // await this.transaction.commit()
    }

    async getTokenHash(ClientId) {
        var Token = await Models.NSMTokens.findAll({
            where: {
                ClientId: ClientId
            }
        }, {transaction: this.transaction})
        return Token.length > 0 ? Token[0].dataValues : false
    }

    async createToken(ClientId, Token) {
        bcrypt.hash(Token, 10, async (err, hash) => {
            await Models.NSMTokens.destroy({
                where: {
                    ClientId: ClientId
                }
            }, {transaction: this.transaction})
            await Models.NSMTokens.build({
                ClientId: ClientId,
                Token: hash
            }, {transaction: this.transaction}).save()
            // await this.transaction.commit()
        })
    }

    async getPlayerStatsTotal(ClientId) {
        if (this.cache[`statsTotal_${ClientId}`]) return this.cache[`statsTotal_${ClientId}`]

        var Stats = await Models.NSMPlayerStats.findAll({
            attributes: ['Kills', 'Deaths', 'PlayedTime', [Sequelize.literal('max(Performance, 0)'), 'Performance'], 'TotalPerformance'],
            where: {
                ClientId: ClientId
            },
            raw: true
        }, {transaction: this.transaction})

        if (Stats.length) {
            this.cache[`statsTotal_${ClientId}`] = Stats[0]
            return Stats[0]
        }
        return Stats.length > 0 ? Stats[0].dataValues : false
    }

    async getGlobalStats() {
        if (this.cache[`globalStats`]) return this.cache[`globalStats`]

        var totalKills = (await Models.NSMPlayerStats.findAll({
            attributes: [[Sequelize.fn('sum', Sequelize.col('Kills')), 'totalKills']],
        }))[0].dataValues.totalKills

        var totalPlayedTime = (await Models.NSMPlayerStats.findAll({
            attributes: [[Sequelize.fn('sum', Sequelize.col('PlayedTime')), 'totalPlayedTime']],
        }))[0].dataValues.totalPlayedTime

        this.cache[`globalStats`] = {totalKills, totalPlayedTime}

        return this.cache[`globalStats`]
    }

    async getPlayerStats(ClientId) {
        if (this.cache[`stats_${ClientId}`]) return this.cache[`stats_${ClientId}`]

        var Player = await this.getClient(ClientId)
        if (!Player) return false

        var Stats = {
            Kills: await this.getPlayerKills(ClientId),
            Deaths: await this.getPlayerDeaths(ClientId),
            Player: Player
        }

        this.cache[`stats_${ClientId}`] = Stats
        return Stats
    }

    async addStatRecord(ClientId, TotalPerformance, Performance) {
        return await Models.NSMPlayerStatHistory.build({ ClientId, TotalPerformance, Performance }, {transaction: this.transaction}).save()
    }

    async getTopZStats(page, limit) {
        if (this.cache[`zstats_${page};${limit}`]) return this.cache[`zstats_${page};${limit}`]

        var NSMZStats = await Models.DB.define('NSMZStats')
        var Stats = (await NSMZStats.findAll({
            limit: limit,
            offset: page * limit,
            where: {
                HighestRound: {
                    [Sequelize.Op.gt]: 0
                }
            },
            attributes: ['ClientId', 'Kills', 'Downs', 'Revives', 'HighestRound', 'Headshots', 'Score', [Sequelize.literal('ROW_NUMBER() over (order by Kills desc)'), 'Rank']],
            order: [
                ['Kills', 'desc']
            ]
        })).map(x => x = x.dataValues)
        for (var i = 0; i < Stats.length; i++) {
            Stats[i].Name = await this.getName(Stats[i].ClientId)
        }
        this.cache[`zstats_${page};${limit}`] = Stats

        return Stats
    }

    async getStatHistory(page, limit) {
        if (this.cache[`statHistory_${page};${limit}`]) return this.cache[`statHistory_${page};${limit}`]

        var Stats = (await Models.NSMPlayerStats.findAll({
            limit: limit,
            attributes: ['ClientId', 'Kills', 'Deaths', [Sequelize.literal('max(Performance, 0)'), 'Performance'], 'TotalPerformance', 'PlayedTime', 'Id', [Sequelize.literal('ROW_NUMBER() over (order by Performance desc)'), 'Rank']],
            where: {
                [Sequelize.Op.and]: [
                    Sequelize.literal('Kills+Deaths >= 50')
                ],
                PlayedTime: {
                    [Sequelize.Op.gte]: 120
                }
            },
            order: [
                ['Performance', 'desc']
            ],
            offset: limit * page
        }, {transaction: this.transaction})).map(x => x = x.dataValues)

        for (var i = 0; i < Stats.length; i++) {
            Stats[i].History = (await Models.NSMPlayerStatHistory.findAll({
                where: {ClientId: Stats[i].ClientId},
                limit: 25,
                attributes: [[Sequelize.literal('max(Performance, 0)'), 'Performance'], 'Date'],
                order: [
                    ['Date', 'desc']
                ]
            })).map(s => s = {x: i, y: s.Performance})
        }
        
        this.cache[`statHistory_${page};${limit}`] = Stats

        return Stats
    }

    async getClientByGuid(Guid) {
        var result = await this.getClientId(Guid)
        return result ? await this.getClient(result) : false
    }

    async getClientId(Guid) {

        var result = await Models.NSMClients.findAll({
            attributes: ['ClientId'],
            where: {
                Guid: Guid
            }
        }, {transaction: this.transaction})

        return result.length > 0 ? result[0].dataValues.ClientId : false
    }

    async getAllClients() {
        return (await Models.NSMClients.findAll({
            attributes: [[Sequelize.fn('max', Sequelize.literal('_rowid_')), 'totalClients']],
        }))[0].dataValues.totalClients
    }

    async getLastConnections() {
        return await Models.NSMClients.findAll({
            where: {
                LastConnection: {
                    [Sequelize.Op.lt]: new Date(),
                    [Sequelize.Op.gt]: new Date(new Date().setDate(new Date().getDate() - 1))
                }
            },
            group: ['ClientId'],
            raw: true
        })
    }
    
    async getLastUniques() {
        return await Models.NSMClients.findAll({
            where: {
                FirstConnection: {
                    [Sequelize.Op.lt]: new Date(),
                    [Sequelize.Op.gt]: new Date(new Date().setDate(new Date().getDate() - 1))
                }
            },
            group: ['ClientId'],
            raw: true
        })
    }

    async getAllConnections(ClientId) {
        var Connections = await Models.NSMConnections.findAll({
            where: {
                ClientId
            }
        }, {transaction: this.transaction})

        return Connections.length > 0 ? Connections : false
    }

    async updateLastConnection(ClientId) {
        Models.NSMClients.update(
            { 'LastConnection' : Sequelize.literal(`datetime('now')`)},
            {where: {ClientId}}, {transaction: this.transaction})
    }

    async getClientsByIp(IPAddress) {
        if (!IPAddress) {
            return []
        }

        var Connections = await Models.NSMConnections.findAll({
            where: {
                IPAddress
            },
            group: ['ClientId'],
            raw: true
        })

        return Connections
    }

    async getAliases(ClientId) {
        var Aliases = await Models.NSMAliases.findAll({
            where: Sequelize.or(
                { ClientId: ClientId },
                { OriginId: ClientId }
            ),
            raw: true
        })

        return Aliases
    }

    async addAlias(OriginId, ClientId) {
        try {
            await Models.NSMAliases.build({
                OriginId,
                ClientId
            }, {transaction: this.transaction}).save()
        }
        catch (e) {}
    }

    async logConnection(ePlayer) {
        var IPAddress = ePlayer.IPAddress ? ePlayer.IPAddress.split(':')[0] : null

        var ClientId = await this.getClientId(ePlayer.Guid)

        var Connections = await this.getClientsByIp(IPAddress)
        Connections.forEach(Connection => {
            if (Connection.ClientId != ePlayer.ClientId) {
                this.addAlias(ePlayer.ClientId, Connection.ClientId)
            }
        })

        this.updateLastConnection(ClientId)
        
        var Connection = await Models.NSMConnections.build({
            ClientId: ClientId,
            IPAddress: IPAddress,
            Guid: ePlayer.Guid,
            Name: ePlayer.Name
        }, {transaction: this.transaction}).save()

        return Connection.dataValues
    }
    async logKill(AttackerId, TargetId, Attack) {
        var Kill = await Models.NSMKills.build({
            ClientId: AttackerId,
            TargetId: TargetId,
            Weapon: Attack.Weapon,
            MOD: Attack.MOD,
            HitLoc: Attack.HitLoc,
            Damage: Attack.Damage,
            BaseWeapon: Attack.BaseWeapon
        }, {transaction: this.transaction}).save()
        // await this.transaction.commit()
        return Kill.dataValues
    }

    async getAllMessages(From, page, limit) {
        if (From) {
            var Messages = await Models.NSMMessages.findAll({
                where: {
                    OriginId: From
                },
                order: [
                    ['Date', 'desc']
                ],
            }, {transaction: this.transaction})
        } else {
            var Messages = await Models.NSMMessages.findAll({
                order: [
                    ['Date', 'desc']
                ],
                limit: limit,
                offset: page * limit,
            }, {transaction: this.transaction})
        }
        for (var i = 0; i < Messages.length; i++) {
            Messages[i] = Messages[i].dataValues
        }
        return Messages
    }

    async isBanned(ClientId) {
        var playerPenalties = await this.getAllPenalties(ClientId)
        for (var i = 0; i < playerPenalties.length; i++) {
            if (!playerPenalties[i].Active) continue
            switch (playerPenalties[i].PenaltyType) {
                case 'PENALTY_PERMA_BAN':
                    return {
                        Banned: true,
                        Type: playerPenalties[i].PenaltyType,
                        Duration: playerPenalties[i].Duration,
                        Reason: playerPenalties[i].Reason
                    }
                case 'PENALTY_TEMP_BAN':
                    var dateDiff = (new Date(playerPenalties[i].Date) - new Date()) / 1000
                    if (dateDiff + playerPenalties[i].Duration > 0) {
                        return {
                            Banned: true,
                            Type: playerPenalties[i].PenaltyType,
                            Duration: playerPenalties[i].Duration,
                            Reason: playerPenalties[i].Reason
                        }
                    }
                break
            }
        }
        return {
            Banned: false
        }
    }

    async isMuted(ClientId) {
        var Penalties = await Models.NSMPenalties.findAll({
            where: {
                TargetId: ClientId,
                PenaltyType: 'PENALTY_MUTE',
                Active: true
            },
            raw: true
        })

        return Penalties
    }

    async getMessageCount(ClientId) {
        return await Models.NSMMessages.count({where: {OriginId: ClientId}})
    }

    async getMessages(From, pageNumber, limit) {
        if (From) {
            var Messages = await Models.NSMMessages.findAll({
                where: {
                    OriginId: From
                },
                order: [
                    ['Date', 'desc']
                ],
                limit: limit,
                offset: pageNumber * limit,
            }, {transaction: this.transaction})
            var Penalties = await Models.NSMPenalties.findAll({
                where: Sequelize.or({ TargetId: From}, {OriginId: From}),
                order: [
                    ['Date', 'desc']
                ],
                limit: limit,
                offset: pageNumber * limit,
            }, {transaction: this.transaction})
        } else {
            var Messages = await Models.NSMMessages.findAll({
                order: [
                    ['Date', 'desc']
                ],
                limit: limit,
                offset: pageNumber * limit,
            }, {transaction: this.transaction})
            var Penalties = await Models.NSMPenalties.findAll({
                order: [
                    ['Date', 'desc']
                ],
                limit: limit,
                offset: pageNumber * limit,
            }, {transaction: this.transaction})
        }
        
        for (var i = 0; i < Penalties.length; i++) {
            Penalties[i] = Penalties[i].dataValues
            Penalties[i].Type = 'Penalty'
            Penalties[i].Origin = { ClientId: Penalties[i].OriginId, Name: await this.getName(Penalties[i].OriginId) }
            Penalties[i].Target = { ClientId: Penalties[i].TargetId, Name: await this.getName(Penalties[i].TargetId) }
        }

        for (var i = 0; i < Messages.length; i++) {
            Messages[i] = Messages[i].dataValues
            Messages[i].Type = 'Message'
        }

        Messages = Messages.concat(Penalties)

        Messages.sort((a,b) => {
            return (new Date(b.Date) - new Date(a.Date))
        })

        return Messages
    }

    async getName(ClientId) {
        if (ClientId == 1) return 'Node Server Manager'
        if (this.clientCache.find(x => x && x.ClientId == ClientId))
            return this.clientCache.find(x => x && x.ClientId == ClientId).Name
        else {
            var Name = (await Models.NSMConnections.findAll({
                where: {
                    ClientId
                },
                order: [
                    ['Date', 'desc']
                ],
                attributes: ['Name']
            }))
            if (Name.length > 0) {
                this.clientCache[ClientId] = {ClientId: ClientId, Name: Name[0].dataValues.Name }
                return Name[0].dataValues.Name
            }
        }
    }

    async incrementStat(ClientId, Increment, Stat) {
        Models.NSMPlayerStats.update(
            { [Stat] : Sequelize.literal(`${Stat} + ${Increment}`)},
            {where: {ClientId: ClientId}}, {transaction: this.transaction})
        // await this.transaction.commit()
    }

    async editStat(ClientId, Value, Stat) {
        Models.NSMPlayerStats.update(
            { [Stat] : Value},
            {where: {ClientId: ClientId}}, {transaction: this.transaction})
        // await this.transaction.commit()
    }

    async editStats(ClientId, Stats) {
        Models.NSMPlayerStats.update(
            { 'Kills': Stats.Kills, 'Deaths': Stats.Deaths, 'Performance': Stats.Performance, 'TotalPerformance': Stats.TotalPerformance},
            {where: {ClientId: ClientId}}, {transaction: this.transaction})
    }

    async resetStats(ClientId) {
        await Models.NSMPlayerStats.update({
            'Kills': 0,
            'Deaths': 0,
            'Performance': 100,
            'TotalPerformance': 100
        },
        {
            where: {
                ClientId
            }
        }, { transaction: this.transaction })

        this.cache[`statsTotal_${ClientId}`] = undefined
    }

    async logMessage(ClientId, Name, Hostname, Message) {
        var Kill = await Models.NSMMessages.build({
            OriginId: ClientId,
            Message,
            Name,
            Hostname
        }, {transaction: this.transaction}).save()
        // await this.transaction.commit()
        return Kill.dataValues
    }
}

module.exports = Database