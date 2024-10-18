const Sequelize         = require('sequelize')
const path              = require('path')
const Permissions       = require(path.join(__dirname, `../Configuration/NSMConfiguration.json`)).Permissions
const Localization      = require(path.join(__dirname, `../Configuration/Localization-${process.env.LOCALE}.json`)).lookup
const Utils             = new (require(path.join(__dirname, '../Utils/Utils.js')))()
const { emitKeypressEvents } = require('readline')
const { Command }       = require(path.join(__dirname, `../Lib/Classes.js`))




class Plugin {
    constructor (Server, Manager, Managers) {
        //add the .pguid of players to grant them staff permissions (must be done on ClanTag, ZombiesBank, ZombiesStats, NativeCommands & the gsc script staff.gsc)
        this.staff_list_a = [564391]
        this.Server = Server
        this.Manager = Manager
        this.Managers = Managers
        this.Server.on('connect', this.onPlayerConnect.bind(this))
        this.zStats()
       // this.getKills()
    }
    async onPlayerConnect(Player) { 
        if ((await this.getZStats(Player.ClientId))) return
        await this.NSMZStats.build({
            ClientId: Player.ClientId
        }).save()
      }
    async createTable() {
        this.NSMZStats = this.Server.DB.Models.DB.define('NSMZStats', 
        {
            ClientId: {
                type: Sequelize.INTEGER,
                autoIncrement: true,
                allowNull: false,
                primaryKey: true,
                references: {
                    model: 'NSMClients',
                    key: 'ClientId'
                }
            },
            Kills: {
                type: Sequelize.INTEGER,
                defaultValue: 0,
                allowNull: false
            },
            Score: {
                type: Sequelize.INTEGER,
                defaultValue: 0,
                allowNull: false
            },
            Downs: {
                type: Sequelize.INTEGER,
                defaultValue: 0,
                allowNull: false
            },
            Revives: {
                type: Sequelize.INTEGER,
                defaultValue: 0,
                allowNull: false
            },
            Headshots: {
                type: Sequelize.INTEGER,
                defaultValue: 0,
                allowNull: false
            },
            HighestRound: {
                type: Sequelize.INTEGER,
                defaultValue: 0,
                allowNull: false
            },
            Event: {
                type: Sequelize.INTEGER,
                defaultValue: 0,
                allowNull: false
            }, 
            Easter: {
                type: Sequelize.INTEGER,
                defaultValue: 0,
                allowNull: false
            }, 
        }, {
            timestamps: false
        })
        this.NSMZStats.sync()
        this.Server.DB.Models.NSMZStats = this.NSMZStats
    }

    async getTopStats(page, limit) {
        var Stats = (await this.NSMZStats.findAll({
            limit: limit,
            offset: page * limit,
            attributes: ['ClientId', 'Kills', 'Downs', 'Revives', 'HighestRound', 'Headshots', 'Score', [Sequelize.literal('ROW_NUMBER() over (order by Score desc)'), 'Rank']],
            order: [
                ['Score', 'desc']
            ]
        })).map(x => x = x.dataValues)

        for (var i = 0; i < Stats.length; i++) {
            Stats[i].Name = await this.Server.DB.getName(Stats[i].ClientId)
        }

        return Stats
    }
    async updateStats(Client, Stats, Round = 0) {
        Object.entries(Stats).forEach(Stat => {
            if (!Client.previousStats) return
            if (Stat[1] < Client.previousStats[Stat[0]]) {
                Client.previousStats = null
            }
        })

        if (!Client.previousStats) {
            Client.previousStats = Stats
            return
        }

        var newStats = {
            Kills: Stats.Kills - Client.previousStats.Kills,
            Revives: Stats.Revives - Client.previousStats.Revives,
            Downs: Stats.Downs - Client.previousStats.Downs,
            Score: Stats.Score - Client.previousStats.Score,
            Headshots: Stats.Headshots - Client.previousStats.Headshots,
            HighestRound: Round
        }

        Client.previousStats = {...Stats, Round}

        this.NSMZStats.update({
            Kills: Sequelize.literal(`Kills + ${newStats.Kills}`),
            Downs: Sequelize.literal(`Downs + ${newStats.Downs}`),
            Revives: Sequelize.literal(`Revives + ${newStats.Revives}`),
            Score: Sequelize.literal(`Score + ${newStats.Score}`),
            Headshots: Sequelize.literal(`Headshots + ${newStats.Headshots}`)
        },
        {where: {ClientId: Client.ClientId}})

        if (Round) {
            this.NSMZStats.update({
                HighestRound: Round,
            }, { where: {
                ClientId: Client.ClientId,
                HighestRound: {
                    [Sequelize.Op.lt]: Round
                }
            }})
        }
    }
    async getKills(client)
    {
        //var ClientId = client.ClientId 
        var Stats = (await this.NSMZStats.findAll({where: client.ClientId})).map(x => x = x.dataValues)
        console.log(client.Name + " " + Stats.Kills); 
    }   
    async getZStats(ClientId) {
        var Stats = (await this.NSMZStats.findAll({where: ClientId})).map(x => x = x.dataValues)
        return Stats.length > 0 ? Stats[0] : false
    }
    async print_servers(manager, Player, delay)
    {
        await new Promise(resolve => setTimeout(resolve, delay * 500))
        if (manager && manager.Server.Hostname)
        {
            if(!(manager.Server.Hostname.includes('PRIVATE')))
            {
                Player.Tell(`^2.king^7 ^2${manager.Server.Hostname.split(" ")[2]} ^3`)
            }
        }
    }
    async king_lock_check(manager, Player)
    {
        var guild_quest = await this.Server.DB.metaService.getPersistentMeta('guild_quest', 12)
        if(guild_quest.Value.split(";")[1] == "gamemode_speedrun_quest_pia" && (manager.Server.Hostname.includes('PANZER'))
        || guild_quest.Value.split(";")[1] == "gamemode_speedrun_quest_titb" && (manager.Server.Hostname.includes('BUS'))
        || guild_quest.Value.split(";")[1] == "gamemode_speedrun_quest_botb" && (manager.Server.Hostname.includes('BRUTUS'))
        || guild_quest.Value.split(";")[1] == "ee_speedrun_quest_transit" && (manager.Server.Hostname.includes('TRANZIT2'))
        || guild_quest.Value.split(";")[1] == "ee_speedrun_quest_highrise" && (manager.Server.Hostname.includes('DIE RISE'))
        || guild_quest.Value.split(";")[1] == "ee_speedrun_quest_prison" && (manager.Server.Hostname.includes('MOTD'))
        || guild_quest.Value.split(";")[1] == "ee_speedrun_quest_buried" && (manager.Server.Hostname.includes('BURIED'))
        || guild_quest.Value.split(";")[1] == "ee_speedrun_quest_tomb" && (manager.Server.Hostname.includes('ORIGINS'))
        || manager.Server.Hostname.includes('RAID'))
        {
            Player.Tell("Cannot king a ^1Competitive Server^7.")
            return
        }
        if (await manager.Server.Rcon.getDvar(`king_lock`) == "1")
        {
            Player.Tell("This server is ^1too advanced^7 to ^3.king^7, please wait a few minutes.")
            await manager.Server.Rcon.setDvar('ln', "^5King^7 request ^1denied^7. Too far into the game.")
            return
        }
        if (await manager.Server.Rcon.getDvar(`is_first_room`) == "1")
        {
            Player.Tell("Cannot .king into a first room challenge.")
            await manager.Server.Rcon.setDvar('ln', "^5King^7 request ^1denied^7. First room protection")
            return;
        }
        Player.Data.lastKing = new Date()
        var king2 = await this.Server.DB.metaService.getPersistentMeta('king2', Player.ClientId)
        var king3 = await this.Server.DB.metaService.getPersistentMeta('king3', Player.ClientId)
        var king4 = await this.Server.DB.metaService.getPersistentMeta('king4', Player.ClientId)
        if (king4)
            await manager.Server.Rcon.executeCommandAsync(`set king ${Player.Name};${Player.ClientId};4`)    
        else if (king3)
            await manager.Server.Rcon.executeCommandAsync(`set king ${Player.Name};${Player.ClientId};3`)
        else if (king2)
            await manager.Server.Rcon.executeCommandAsync(`set king ${Player.Name};${Player.ClientId};2`)
        else 
            await manager.Server.Rcon.executeCommandAsync(`set king ${Player.Name};${Player.ClientId};1`)
        console.log("king dvar set")
    }

    async is_staff(Player)
    {
        for (var i = 0; i < this.staff_list_a.length; i++)
            if (this.staff_list_a[i] == Player.Guid)
                return true
        Player.Tell("hehe boi u tryna scam da kiels by using staff cmd?")
        return false
    }

    async zStats() {
        this.Manager.on('webfront-ready', (Webfront) => {
            Webfront.addHeaderHtml(`<a href='/zstats' class='wf-header-link'><i class="fas fa-skull"></i></a>`, 3)
        })

        await this.createTable()
        this.Manager.commands['king'] = {
            ArgumentLength: 0,
            inGame: false,
            logToAudit: false,
            Permission: Permissions.Commands.COMMAND_USER_CMDS,
            callback: async (Player, args) => {
                if (!args[1])
                {
                    Player.Tell("^3Usage^7 :  ")
                    await new Promise(resolve => setTimeout(resolve, 300))
                    var i = 0;
                    this.Managers.forEach(manager =>
                    {
                        this.print_servers(manager, Player, i);
                        i++
                    })
                    return
                }
                var king = await this.Server.DB.metaService.getPersistentMeta('king', Player.ClientId)
                var isServerFound = false;

                var king2 = await this.Server.DB.metaService.getPersistentMeta('king2', Player.ClientId)
                var king3 = await this.Server.DB.metaService.getPersistentMeta('king3', Player.ClientId)
                var king4 = await this.Server.DB.metaService.getPersistentMeta('king4', Player.ClientId)

                if (king4 && Player.Data && Player.Data.lastKing && (new Date() - Player.Data.lastKing) / 1000 < 60) {
                    Player.Tell("wait up to 1 min to use .king again")
                    return
                }
                else if (king3 && Player.Data && Player.Data.lastKing && (new Date() - Player.Data.lastKing) / 1000 < 180) {
                    Player.Tell("wait up to 3 mins to use .king again")
                    return
                }
                else if (king2 && Player.Data && Player.Data.lastKing && (new Date() - Player.Data.lastKing) / 1000 < 300) {
                    Player.Tell("wait up to 5 mins to use .king again")
                    return
                }
                else if (king && Player.Data && Player.Data.lastKing && (new Date() - Player.Data.lastKing) / 1000 < 900) {
                    Player.Tell("wait up to 15 mins to use .king again")
                    return
                }
                if (king || king2 || king3 || king4 || await this.is_staff(Player) == true) 
                {
                    this.Managers.forEach(manager =>
                    {
                        if (manager && manager.Server.Hostname)
                        {
                            if((manager.Server.Hostname.includes('ORIGIN'))) //event
                            {
                                Player.Tell("^3.king ^1temp disabled^7 on origins due to ^3ongoing event")
                                return
                            }
                            if(!(manager.Server.Hostname.includes('PRIVATE')))
                            {
                                var serverName = ""
                                if (manager.Server.Hostname.split(" ")[2])
                                {
                                    var serverName = manager.Server.Hostname.split(" ")[2].toLocaleLowerCase()
                                }
                                if (serverName == args[1].toLocaleLowerCase())
                                {
                                    isServerFound = true
                                    if (!king2 && !king3 && !king4 && serverName == this.Manager.Server.Hostname.split(" ")[2].toLocaleLowerCase())
                                    {
                                        Player.Tell("You are ^3already connected^7 to this ^3server.")
                                        return
                                    }
                                    if (manager.Server.getClients().length != manager.Server.MaxClients)
                                    {
                                        Player.Tell(`^3${args[1]} is not full`)
                                        return
                                    }
                                    this.king_lock_check(manager, Player);
                                    return

                                }
                            }
                        }
                    })
                    if (isServerFound == false)
                    {
                        Player.Tell("^3Server not found. use ^2.king ^3to see the ^5list of servers")
                        return
                    }
                }
                else
                {
                    Player.Tell("^1King^7 command only. Earn it in events")
                }         
            }
        }


        this.Manager.commands['zstats'] = {
            ArgumentLength: 0,
            inGame: false,
            logToAudit: false,
            Permission: Permissions.Commands.COMMAND_USER_CMDS,
            callback: async (Player, args) => {
                var Client = args[1] ? await this.Server.getClient(args[1]) : Player
                if (!Client) {
                    Player.Tell(Localization['COMMAND_CLIENT_NOT_FOUND'])
                    return
                }

                var Stats = await this.getZStats(Client.ClientId)
                if (!Stats) {
                    Player.Tell(Localization['STATS_NOT_EXIST'])
                    return
                }

                Stats.Player = Client.Name
                var formattedStats = Utils.formatString(Localization['COMMAND_ZSTATS_FORMAT'], Stats, '%');
                formattedStats.forEach(async line => {
                    await Player.Tell(line)
                })
            }
        }

        this.Server.on('connect', async (Client) => {
            Client.previousStats = null
            Client.on('round_start', async (Round, Stats) => {
                await this.updateStats(Client, Stats, Round)
            })
            Client.on('update_stats', async (Round, Stats) => {
                await this.updateStats(Client, Stats, Round)
            })
        })

        this.Server.on('line', async (data) => {
            data = data.trim().replace(new RegExp(/([0-9]+:[0-9]+)\s+/g), '')
            if (Utils.isJson(data) && JSON.parse(data).event) {
                var event = JSON.parse(data)
                switch (event.event) {
                    case 'round_start':
                        this.Server.emit('round_start', event.round)
                        this.roundNumber = event.round
                        event.players.forEach(Player => {
                            this.Server.Clients.forEach(async Client => {
                                if (!Client) return
                                if (Client.Guid == Player.Guid) {
                                    Client.emit('round_start', event.round, Player.Stats)
                                }
                            })
                        })
                    break
                    case 'player_downed':
                    case 'player_revived':
                    case 'update_stats':
                        this.Server.Clients.forEach(async Client => {
                            if (!Client) return
                            if (Client.Guid == event.player.Guid) {
                                Client.emit('update_stats', null, event.player.Stats)
                            }
                        })
                    break
                }
            }
        })
    }
}

module.exports = Plugin
