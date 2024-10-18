const path          = require('path')
const configName    = path.join(__dirname, `../../Configuration/NSMConfiguration.json`)
const config        = require(path.join(__dirname, `../../Configuration/NSMConfiguration.json`))
const Discord       = require('discord.js')
const bot           = new Discord.Client()
const Utils         = new (require(path.join(__dirname, '../../Utils/Utils.js')))()
const token         = config.discordBotToken
const fs            = require('fs')
const wait          = require('delay')
const moment        = require('moment')

const Permissions   = require(path.join(__dirname, `../../Configuration/NSMConfiguration.json`)).Permissions
const Localization  = require(path.join(__dirname, `../../Configuration/Localization-${process.env.LOCALE}.json`)).lookup

const clamp = (num, min, max) => Math.min(Math.max(num, min), max)

const colors = ['#FF3131', '#86C000', '#FFAD22', '#0082BA', '#25BDF1', '#9750DD']

var databaseCache = {}

const color = () => colors[Utils.getRandomInt(0, colors.length)]

const stringInsert = (string, index, length, substr) => {
    var left = string.slice(0, index)
    var right = string.slice(index + length, string.length)

    left += substr
    left += right

    return left
}

const trySend = async (channel, msg) => {
    try {
        return await channel.send(msg)
    }
    catch (e) {}
}

const getAllClients = (Managers) => {
    var Clients = []

    Managers.forEach(Manager => {
        Clients = Clients.concat(Manager.Server.getClients())
    })

    return Clients
}

const formatColors = (string) => {
    var open = false

    for (var i = 0; i < string.length; i++) {
        if (string[i] == '^' && string[i + 1] && string[i + 1].match(/[0-9]/g)) {
            if (string[i + 1] == '7') {
                open = false

                string = stringInsert(string, i, 2, '\u200B**\u200B')

                continue
            }

            string = stringInsert(string, i, 2, open ? '\u200B**\u200B**\u200B' : '\u200B**\u200B')

            open = true
        }
    }
    
    if (open) {
        string += '\u200B**\u200B'
    }

    return string
}

const pagedMessage = async (original, callback, options) => {
    var defaultOptions = {timeout: 60 * 1000, max: 0}
    options = {...defaultOptions, ...options}

    var page = 0

    var msg = await trySend(original.channel, callback(page))

    if (!msg) {
        return
    }

    const backward = '⬅'
    const forward = '➡'

    const fastforward = '⏩'
    const rewind = '⏪'

    await msg.react(rewind)

    await msg.react(backward)
    await msg.react(forward)

    await msg.react(fastforward)

    var onReaction = async (reaction, user) => {
        if (user.id == bot.user.id) {
            return
        }

        if (reaction.message.id != msg.id) {
            return
        }

        if (user.id != original.author.id) {
            reaction.users.remove(user.id)
            return
        }

        switch (reaction.emoji.name) {
            case (fastforward):
                previous = page
                page = options.max

                previous != page && msg.edit(callback(page))
            break
            case (rewind):
                previous = page
                page = 0

                previous != page && msg.edit(callback(page))
            break
            case (backward):
                previous = page
                page = clamp(--page, 0, options.max)

                previous != page && msg.edit(callback(page))
            break
            case (forward):
                previous = page
                page = clamp(++page, 0, options.max)

                previous != page && msg.edit(callback(page))
            break
        }

        reaction.users.remove(user.id)
    }

    bot.on('messageReactionAdd', onReaction)

    setTimeout(() => {
        bot.removeListener('messageReactionAdd', onReaction)
    }, options.timeout)

    return msg
}

var discordUsers = {}

class Plugin {
    constructor(Managers) {
        this.Managers = Managers
        this.Manager = Managers[0]
        this.Server = this.Manager.Server
        this.clientCache = {}

        this.commands = {
            'help': async (msg, user, args) => {
                var commands = Object.entries({...this.Manager.commands, ...this.Manager.Commands.Commands})
                .filter(command => { 
                    return !command[1].isMiddleware && (Permissions.Levels[command[1].Permission] == 0 || command[1].PermissionLevel == 0)
                })
        
                var chunkedCommands = Utils.chunkArray(commands, 5)
        
                pagedMessage(msg, (page) => {
                    let embed = new Discord.MessageEmbed()
                    .setTitle(`Page ${page + 1} / ${chunkedCommands.length}`)
                    .setColor(color())
        
                    for (var i = 0; i < chunkedCommands[page].length; i++) {
                        embed.addField(
                            chunkedCommands[page][i][0],
                            Localization[`COMMAND_${chunkedCommands[page][i][0].toLocaleUpperCase()}`],
                            false
                        )
                    }
        
                    return embed
                }, {max: chunkedCommands.length - 1})
            },
            'find': async (msg, user, args) => {
                var name = args.splice(1).join(' ')
                var matches = await this.Server.DB.getClientByName(name, 20)
        
                if (matches.length <= 0) { 
                    msg.author.tell(Localization['COMMAND_CLIENT_NOT_FOUND'])
                    return 
                }
        
                user.lastMatches = matches
        
                var chunkedMatches = Utils.chunkArray(matches, 5)
        
                pagedMessage(msg, (page) => {
                    let embed = new Discord.MessageEmbed()
                    .setTitle(`Page ${page + 1} / ${chunkedMatches.length}`)
                    .setColor(color())

                    for (var i = 0; i < chunkedMatches[page].length; i++) {
                        var text = formatColors(Utils.formatString(Localization['COMMAND_FIND_FORMAT'], {
                            index: page * 5 + i + 1,
                            Name: chunkedMatches[page][i].Name,
                            ClientId: chunkedMatches[page][i].ClientId,
                            Role: Utils.stripString(Utils.getRoleFrom(chunkedMatches[page][i].PermissionLevel, 1).Name),
                            Active: moment(chunkedMatches[page][i].LastConnection).calendar(),
                            Joined: moment(chunkedMatches[page][i].FirstConnection).calendar()
                        }, '%')[0])
        
                        embed.addField(
                            '\u200B',
                            text,
                            false
                        )
                    }
        
                    return embed
                }, {max: chunkedMatches.length - 1})
            },
            'servers': async (msg, user, args) => {
                if (this.Managers.length <= 0) {
                    return
                }
        
                var chunkedManagers = Utils.chunkArray(this.Managers.concat().filter(m => m.Server.dvarsLoaded), 5)
        
                pagedMessage(msg, (page) => {
                    let embed = new Discord.MessageEmbed()
                    .setTitle(`Page ${page + 1} / ${chunkedManagers.length}`)
                    .setColor(color())

                    for (var i = 0; i < chunkedManagers[page].length; i++) {
                        embed.addField(
                            `${Utils.stripString(chunkedManagers[page][i].Server.Hostname)} - ${chunkedManagers[page][i].Server.externalIP}`,
                            `${chunkedManagers[page][i].Server.getMapname().Alias} - ${chunkedManagers[page][i].Server.getClients().length} / ${chunkedManagers[page][i].Server.Clients.length}`,
                            false
                        )
                    }
        
                    return embed
                }, {max: chunkedManagers.length - 1})
            },
            'players': async (msg, user, args) => {
                var allClients = getAllClients(this.Managers)

                user.lastMatches = allClients

                if (!allClients.length) {
                    msg.author.tell(Localization['NO_PLAYERS_ONLINE'])
                    return
                }

                var chunkedClients = Utils.chunkArray(allClients, 10)

                pagedMessage(msg, (page) => {
                    let embed = new Discord.MessageEmbed()
                    .setTitle(`Page ${page + 1} / ${chunkedClients.length}`)
                    .setColor(color())

                    var buffer = []
        
                    var i = 0; chunkedClients[page].forEach(Client => {
                        const role = Utils.stripString(Utils.getRoleFrom(Client.PermissionLevel, 1).Name)
                        const hostname = formatColors(Client.Server.Hostname)

                        buffer.push(`#${page * 10 + i++ + 1} - [[${role}] **${Client.Name}**](${process.env.webfrontUrl}/id/${Client.ClientId}) - ${hostname}`)
                    })

                    embed.addField(`\u200B`, buffer.join('\n').substr(0, 1020), false)
        
                    return embed
                }, {max: chunkedClients.length - 1})
            }
        }

        this.commands['f'] = this.commands['find']

        if (!token) return
        this.discordBot()
    }
    async updateActivity() {
        bot.user.setStatus('online')

        bot.user.setActivity(Utils.formatString(Localization['DISCORD_BOT_ACTIVITY'], {
            totalSlots: this.Managers.reduce((a, {Server}) => a + Server.Clients.length, 0),
            onlineClients: this.Managers.reduce((a, {Server}) => a + Server.getClients().length, 0),
            totalServers: this.Managers.filter(m => m.Server.Rcon.isRunning).length
        }, '%')[0], { 
            type: 'WATCHING',
            url: process.env.webfrontUrl
        })
    }
    discordBot() {
        bot.login(token)

        bot.on('shardError', (e) => {})

        bot.on('ready', async () => {
            var guilds = bot.guilds.cache.map(guild => guild)
            guilds.forEach(async (guild) => {
                this.guildInit(guild)
            })

        bot.on('message', async (msg) => {
                if (msg.author.bot) return
                var Manager = this.Managers.find(Manager => Manager && Manager.Server.channel && Manager.Server.channel.id == msg.channel.id)
                if (msg.content.includes("Bruh"))
                    await msg.react('1081765884588212274')
                if (msg.content.includes("Turbo tastic"))
                    await msg.react('1081767190237294632')
                if (msg.channel.id == "1072133169811296357") //Claim Rank
                {
                    if (msg.content.includes('@'))
                    {
                        msg.content = msg.content.replace('@', '')
                        var client = await this.Server.DB.getClient(msg.content)
                        if (!client)
                        {
                            await msg.react("❌")
                            trySend(msg.channel, "ID not found. Type **.id** in game and write it here with the **@**. Example : *@25478*")
                            return
                        }
                        else
                        {
                            this.RankClaim(msg, msg.content)
                        }
                        return
                    }
                    var matches = await this.Server.DB.getClientByName(msg.content, 3)
        
                    if (matches.length <= 0) { 
                        await msg.react("❌")
                        trySend(msg.channel, "**Invalid name** / Never connected to Z-Tavern. You can also type **.id** in game and paste it in a new message. Example : *@25478*")
                        return 
                    }
                    if (matches.length > 1)
                    {
                        await msg.react("❌")
                        trySend(msg.channel, "Problem with your account, type **.id** in game and write it in a new message with the **@**. Example : **@25478**")
                        return
                    }
                    this.RankClaim(msg, matches[0].ClientId)                  
                    return                    
                }
                if (msg.channel.id == "1047317564264550530") //Claim 200k
                {
                    if (msg.content.includes('@'))
                    {
                        msg.content = msg.content.replace('@', '')
                        var client = await this.Server.DB.getClient(msg.content)
                        if (!client)
                        {
                            await msg.react("❌")
                            trySend(msg.channel, "ID not found. Type **.id** in game and write it here with the **@**. Example : *@25478*")
                            return
                        }
                        else
                        {
                            this.isClaimed(msg, msg.content)
                        }
                        return
                    }
                    var matches = await this.Server.DB.getClientByName(msg.content, 3)
        
                    if (matches.length <= 0) { 
                        await msg.react("❌")
                        trySend(msg.channel, "**Invalid name** / Never connected to Z-Tavern. You can also type **.id** in game and paste it in a new message. Example : *@25478*")
                        return 
                    }
                    if (matches.length > 1)
                    {
                        await msg.react("❌")
                        trySend(msg.channel, "Problem with your account, type **.id** in game and write it in a new message with the **@**. Example : **@25478**")
                        return
                    }
                    this.isClaimed(msg, matches[0].ClientId)                  
                    return
                }


                if (!Manager && config.commandPrefixes.includes(msg.content[0]) && (msg.channel.id == "1082001659691016372" || msg.channel.id == "1137834755950399679"))  {
                    this.onCommand(msg)
                    return
                }
                Manager && Manager.Server.emit('discord_message', msg)
            })

            setInterval(() => {
                this.updateActivity()
            }, 5000)

            setInterval(() => {
                databaseCache = {}
            }, 60 * 1000 * 5)
        })
    }
    async RankClaim(msg, clientId)
    {
        var fRank = msg.guild.roles.cache.find(role => role.name === "F Rank")
        var eRank = msg.guild.roles.cache.find(role => role.name === "E Rank")
        var dRank = msg.guild.roles.cache.find(role => role.name === "D Rank")        
        var cRank = msg.guild.roles.cache.find(role => role.name === "C Rank")
        var bRank = msg.guild.roles.cache.find(role => role.name === "B Rank")
        var aRank = msg.guild.roles.cache.find(role => role.name === "A Rank")
        var sRank = msg.guild.roles.cache.find(role => role.name === "S Rank")
        var ssRank = msg.guild.roles.cache.find(role => role.name === "SS Rank")
        var sssRank = msg.guild.roles.cache.find(role => role.name === "SSS Rank")
        var iRank = msg.guild.roles.cache.find(role => role.name === "Awakened I")
        var iiRank = msg.guild.roles.cache.find(role => role.name === "Awakened II")
        var iiiRank = msg.guild.roles.cache.find(role => role.name === "Awakened III")
        var ivRank = msg.guild.roles.cache.find(role => role.name === "Awakened IV")
        var vRank = msg.guild.roles.cache.find(role => role.name === "Awakened V")
        var viRank = msg.guild.roles.cache.find(role => role.name === "Awakened VI")
        var viiRank = msg.guild.roles.cache.find(role => role.name === "Awakened VII")
        var iixRank = msg.guild.roles.cache.find(role => role.name === "Awakened IIX")
        var ixRank = msg.guild.roles.cache.find(role => role.name === "Awakened IX")
        var xRank = msg.guild.roles.cache.find(role => role.name === "Awakened X")

        msg.guild.members.cache.get(msg.author.id).roles.remove(fRank)
        msg.guild.members.cache.get(msg.author.id).roles.remove(eRank)
        msg.guild.members.cache.get(msg.author.id).roles.remove(dRank)
        msg.guild.members.cache.get(msg.author.id).roles.remove(cRank)
        msg.guild.members.cache.get(msg.author.id).roles.remove(bRank)
        msg.guild.members.cache.get(msg.author.id).roles.remove(aRank)
        msg.guild.members.cache.get(msg.author.id).roles.remove(sRank)
        msg.guild.members.cache.get(msg.author.id).roles.remove(ssRank)
        msg.guild.members.cache.get(msg.author.id).roles.remove(sssRank)
        msg.guild.members.cache.get(msg.author.id).roles.remove(iRank)
        msg.guild.members.cache.get(msg.author.id).roles.remove(iiRank)
        msg.guild.members.cache.get(msg.author.id).roles.remove(iiiRank)
        msg.guild.members.cache.get(msg.author.id).roles.remove(ivRank)
        msg.guild.members.cache.get(msg.author.id).roles.remove(vRank)
        msg.guild.members.cache.get(msg.author.id).roles.remove(viRank)
        msg.guild.members.cache.get(msg.author.id).roles.remove(viiRank)
        msg.guild.members.cache.get(msg.author.id).roles.remove(iixRank)
        msg.guild.members.cache.get(msg.author.id).roles.remove(ixRank)
        msg.guild.members.cache.get(msg.author.id).roles.remove(xRank)

        var customTag = await this.Server.DB.metaService.getPersistentMeta('custom_tag', clientId)
        if (!customTag)
        {
            await msg.react("❌")
            trySend(msg.channel, "Error, please contact Admin")
            return
        }
        if (customTag.Value.includes("F"))
        {
            var role = msg.guild.roles.cache.find(role => role.name === "F Rank")
            msg.guild.members.cache.get(msg.author.id).roles.add(role)
            await msg.react("✅")
            return
        }
        if (customTag.Value.includes("E"))
        {
            var role = msg.guild.roles.cache.find(role => role.name === "E Rank")
            msg.guild.members.cache.get(msg.author.id).roles.add(role)
            await msg.react("✅")
            return
        }
        if (customTag.Value.includes("D"))
        {
            var role = msg.guild.roles.cache.find(role => role.name === "D Rank")
            msg.guild.members.cache.get(msg.author.id).roles.add(role)
            await msg.react("✅")
            return
        }
        if (customTag.Value.includes("C"))
        {
            var role = msg.guild.roles.cache.find(role => role.name === "C Rank")
            msg.guild.members.cache.get(msg.author.id).roles.add(role)
            await msg.react("✅")
            return
        }
        if (customTag.Value.includes("B"))
        {
            var role = msg.guild.roles.cache.find(role => role.name === "B Rank")
            msg.guild.members.cache.get(msg.author.id).roles.add(role)
            await msg.react("✅")
            return
        }
        if (customTag.Value.includes("A"))
        {
            var role = msg.guild.roles.cache.find(role => role.name === "A Rank")
            msg.guild.members.cache.get(msg.author.id).roles.add(role)
            await msg.react("✅")
            return
        }
        if (customTag.Value.includes("SSS"))
        {
            var role = msg.guild.roles.cache.find(role => role.name === "SSS Rank")
            msg.guild.members.cache.get(msg.author.id).roles.add(role)
            await msg.react("✅")
            return
        }
        if (customTag.Value.includes("SS"))
        {
            var role = msg.guild.roles.cache.find(role => role.name === "SS Rank")
            msg.guild.members.cache.get(msg.author.id).roles.add(role)
            await msg.react("✅")
            return
        }
        if (customTag.Value.includes("S"))
        {
            var role = msg.guild.roles.cache.find(role => role.name === "S Rank")
            msg.guild.members.cache.get(msg.author.id).roles.add(role)
            await msg.react("✅")
            return
        }
        if (customTag.Value == "^6 I ^7")
        {
            var role = msg.guild.roles.cache.find(role => role.name === "Awakened I")
            msg.guild.members.cache.get(msg.author.id).roles.add(role)
            await msg.react("✅")
            return
        }
        if (customTag.Value == "^6II^7")
        {
            var role = msg.guild.roles.cache.find(role => role.name === "Awakened II")
            msg.guild.members.cache.get(msg.author.id).roles.add(role)
            await msg.react("✅")
            return
        }
        if (customTag.Value == "^6III^7")
        {
            var role = msg.guild.roles.cache.find(role => role.name === "Awakened III")
            msg.guild.members.cache.get(msg.author.id).roles.add(role)
            await msg.react("✅")
            return
        }
        if (customTag.Value == "^5IV^7")
        {
            var role = msg.guild.roles.cache.find(role => role.name === "Awakened IV")
            msg.guild.members.cache.get(msg.author.id).roles.add(role)
            await msg.react("✅")
            return
        }
        if (customTag.Value == "^5V^7")
        {
            var role = msg.guild.roles.cache.find(role => role.name === "Awakened V")
            msg.guild.members.cache.get(msg.author.id).roles.add(role)
            await msg.react("✅")
            return
        }
        if (customTag.Value == "^5VI^7")
        {
            var role = msg.guild.roles.cache.find(role => role.name === "Awakened VI")
            msg.guild.members.cache.get(msg.author.id).roles.add(role)
            await msg.react("✅")
            return
        }
        if (customTag.Value == "^5VII^7")
        {
            var role = msg.guild.roles.cache.find(role => role.name === "Awakened VII")
            msg.guild.members.cache.get(msg.author.id).roles.add(role)
            await msg.react("✅")
            return
        }
        if (customTag.Value == "^1IIX^7")
        {
            var role = msg.guild.roles.cache.find(role => role.name === "Awakened IIX")
            msg.guild.members.cache.get(msg.author.id).roles.add(role)
            await msg.react("✅")
            return
        }
        if (customTag.Value == "^1IX^7")
        {
            var role = msg.guild.roles.cache.find(role => role.name === "Awakened IX")
            msg.guild.members.cache.get(msg.author.id).roles.add(role)
            await msg.react("✅")
            return
        }
        if (customTag.Value == "^1-X-^7")
        {
            var role = msg.guild.roles.cache.find(role => role.name === "Awakened X")
            msg.guild.members.cache.get(msg.author.id).roles.add(role)
            await msg.react("✅")
            return
        }
    }
    async isClaimed(msg, clientId)
    {
        var claimed = await this.Server.DB.metaService.getPersistentMeta('claimed', clientId)
        if (!claimed)
        {
           await this.Server.DB.metaService.addPersistentMeta('claimed', '200000', clientId)
           var totalMoney = (await this.getZMStats(clientId)).Money
           this.setPlayerMoney(clientId, parseInt(totalMoney) + 200000)
           await msg.react("✅")
        }
        else
        {
            await msg.react("❌")
            trySend(msg.channel, "One claim only.")    
        }
    }
    async setPlayerMoney(ClientId, Money) {
        await this.Server.DB.Models.NSMZombiesStats.update({
            Money : Money }, {
                where: {ClientId: ClientId
            }
        })
    }
    async getZMStats(ClientId) {
        if (ClientId == 1) {
            return {
                Money: Infinity,
                LockerWeapon: 'none'
            }
        }

        var ZMStats = await this.Server.DB.Models.NSMZombiesStats.findAll({
            where: {
                ClientId: ClientId
            }
        })
        return ZMStats.length > 0 ?ZMStats[0].dataValues : false
    }





    async saveConfig() {
        fs.writeFile(configName, JSON.stringify(config, null, 4), (err) => {
            if (err) {
                console.log(err)
                return
            }
        })
    }
    stripMentions(string) {
        return string.replace(new RegExp(/((<@(.*?)>)|(@(.*?)))/g), '(@)')
    }
    getServerIcon(Server) {
        var imgPath = path.join(__dirname, `../../Webfront/Public/img/maps/${Server.Gamename.toLocaleLowerCase()}/${Server.Mapname}.jpg`)
        
        return fs.existsSync(imgPath) ? imgPath : path.join(__dirname, `../../Webfront/Public/img/maps/default.png`)
    }
    getServerIconName(Server) {
        var imgPath = path.join(__dirname, `../../Webfront/Public/img/maps/${Server.Gamename.toLocaleLowerCase()}/${Server.Mapname}.jpg`)
        
        return fs.existsSync(imgPath) ? `${Server.Mapname}.jpg` : `default.png`
    }
    async serverLogger(category, guild, Server) {
        this.updateActivity()

        Server.on('message', async (Player, Message) => {
            var discordUser = await this.getDiscordUser(Player.ClientId)

            var msg = Utils.stripString(this.stripMentions(Message))
            if (!msg.length) return

            Server.channel.webhook.send(msg, {
                username: Player.Name,
                avatarURL: discordUser ? `https://cdn.discordapp.com/avatars/${discordUser.id}/${discordUser.avatar}.png` : `https://cdn.discordapp.com/embed/avatars/0.png`
            })
        })

        Server.on('penalty', async (Type, Target, Reason, Origin, Duration = -1) => {
            if (`${Utils.stripString(this.stripMentions(Reason))}` == "VPN detected")
            {
                return;
            }
            if (Reason.includes("rank"))
                return;
            let embed = new Discord.MessageEmbed()
            .setTitle(`:hammer: Penalty`)
            .setDescription(Utils.formatString(Localization['DISCORD_BOT_PENALTY'], {
                target: Target.Name,
                targetUrl: `${process.env.webfrontUrl}/id/${Target.ClientId}`,
                penaltyName: `**${Localization[Type].toLocaleLowerCase()}**`,
                origin: Origin.Name,
                originUrl: `${process.env.webfrontUrl}/id/${Origin.ClientId}`,
                duration: Duration > 0 ? `(${Utils.time2str(Duration)})` : '',
                reason: `**${Utils.stripString(this.stripMentions(Reason))}**`
            }))
            .addField('Target', `[${Target.Name}](${process.env.webfrontUrl}/id/${Target.ClientId})`, true)
            .addField('Origin', `[${Origin.Name}](${process.env.webfrontUrl}/id/${Origin.ClientId})`, true)
            .addField('Reason', Utils.stripString(Reason), true)
            .setTimestamp()
            .setColor(colors[Utils.getRandomInt(0, colors.length)])

            Duration > 0 && embed.addField('Duration', Utils.time2str(Duration), true)

            trySend(guild.eventChannel, embed)
        })

        Server.on('report', async (Origin, Target, Reason) => {
            var modRoles = config[guild.id]['modRoles'].map(role => `<@&${role}>`)

            let embed = new Discord.MessageEmbed()
            .setTitle(':triangular_flag_on_post: Report')
            .setDescription(Utils.formatString(Localization['DISCORD_BOT_REPORT'], {
                target: Target.Name,
                targetUrl: `${process.env.webfrontUrl}/id/${Target.ClientId}`,
                origin: Origin.Name,
                originUrl: `${process.env.webfrontUrl}/id/${Origin.ClientId}`,
                reason: `**${Utils.stripString(this.stripMentions(Reason))}**`
            }))
            .addField('Target', `[${Target.Name}](${process.env.webfrontUrl}/id/${Target.ClientId})`, true)
            .addField('Origin', `[${Origin.Name}](${process.env.webfrontUrl}/id/${Origin.ClientId})`, true)
            .addField('Reason', Utils.stripString(Reason), true)
            .addField('Server', Utils.stripString(Server.Hostname), true)
            .setTimestamp()
            .setColor(colors[Utils.getRandomInt(0, colors.length)])

            modRoles.join(' ').length && await guild.eventChannel.send(modRoles.join(' '))

            var r_text = new Array ();
            r_text[0] = "<@&1128454277686374471> DEFCON 5! DEFCON 5!";
            r_text[1] = "<@&1128454277686374471>  That's gotta be a yellow card at least";
            r_text[2] = "<@&1128454277686374471>  I swear if its another dood who box emp..";
            r_text[3] = "<@&1128454277686374471>  Fun fact, someone send a report because he couldnt get a spin at the box :skull:";
            r_text[4] = "<@&1128454277686374471>  He have brought malice and dishonor to this battlefield. In turn, you shall bring him justice. Justice with well maintained six-pack abs and toned biceps. You shall strike him down where he stand.";
            r_text[5] = "<@&1128454277686374471>  These messages are a great use of my time, no cap";
            r_text[6] = "<@&1128454277686374471>  Just how many of these messages are there? Man could've fixed .afk & MOTD & release the RPG update in half that time!";
            var i = Math.floor(7*Math.random())
            
            trySend(guild.eventChannel, r_text[i]) 
            trySend(guild.eventChannel, embed)           
        })

        Server.on('round_start', async (roundNumber) => {
            let embed = new Discord.MessageEmbed()
            .setTitle('Round started')
            .addField(roundNumber, '\u200B', true)
            .setColor(colors[Utils.getRandomInt(0, colors.length)])
            .attachFiles([this.getServerIcon(Server)])
            .setThumbnail(`attachment://${this.getServerIconName(Server)}`)
            .setTimestamp()
            .setFooter(`${Server.getClients().length} / ${Server.Clients.length}`)

            trySend(Server.channel, embed)
        })

        Server.on('disconnect', async (Player) => {
            var discordUser = await this.getDiscordUser(Player.ClientId)

            let embed = new Discord.MessageEmbed()
            .setURL(`${process.env.webfrontUrl}/id/${Player.ClientId}`)
            .setColor(colors[Utils.getRandomInt(0, colors.length)])
            .setTimestamp()
            .setAuthor(`${Player.Name} disconnected`, discordUser ? `https://cdn.discordapp.com/avatars/${discordUser.id}/${discordUser.avatar}.png` : `https://cdn.discordapp.com/embed/avatars/0.png`)
            .setFooter(`${Server.getClients().length} / ${Server.Clients.length}`)

            trySend(Server.channel, embed)

            this.updateActivity()
        })

        Server.on('connect', async (Player) => {
            var discordUser = await this.getDiscordUser(Player.ClientId)

            let embed = new Discord.MessageEmbed()
            .setURL(`${process.env.webfrontUrl}/id/${Player.ClientId}`)
            .setColor(colors[Utils.getRandomInt(0, colors.length)])
            .setTimestamp()
            .setAuthor(`${Player.Name} connected`, discordUser ? `https://cdn.discordapp.com/avatars/${discordUser.id}/${discordUser.avatar}.png` : `https://cdn.discordapp.com/embed/avatars/0.png`)
            .setFooter(`${Server.getClients().length} / ${Server.Clients.length}`)

            trySend(Server.channel, embed)

            this.updateActivity()
        })

        Server.on('map_loaded', () => {
            let embed = new Discord.MessageEmbed()
            .setTitle('Map rotated')
            .addField('Mapname', `${Server.getMapname().Alias}`, true)
            .addField('Gametype', `${Server.getGametype().Alias}`, true)
            .setColor(colors[Utils.getRandomInt(0, colors.length)])
            .attachFiles([this.getServerIcon(Server)])
            .setThumbnail(`attachment://${this.getServerIconName(Server)}`)
            .setTimestamp()
            .setFooter(`${Server.getClients().length} / ${Server.Clients.length}`)

            trySend(Server.channel, embed)

            this.updateActivity()
        })

        Server.on('discord_message', async (msg) => {
            if (msg.channel.id == "1137834755950399679")
            {
                msg.reply("Link your account [here](http://149.202.93.80:8000)")
                return
            }
            if (!Server.channel
                || msg.channel.id != Server.channel.id
                || msg.author.id == bot.user.id
                || msg.author.bot) return

            var Client = await this.getClientByDiscord(msg.author.id)
            if (!Client.Name) {
                msg.reply(Utils.formatString(Localization['DISCORD_ACC_NOT_CONNECTED'], {
                    url: process.env.webfrontUrl
                }, '%'))
                return
            }
            Server.Broadcast(Utils.formatString(Localization['SOCKET_MSG_FORMAT'], {
                name: Client.Name,
                message: msg.content
            }))
        })
    }
    async initServer(category, guild, Server) {
        var channel = guild.channels.cache.find(channel => config.Servers[Server.Id][guild.id] && channel.id == config.Servers[Server.Id][guild.id].channelId)

        if (!channel) {
            await wait(500)
            var channel = await guild.channels.create(Utils.stripString(Server.Hostname))
            config.Servers[Server.Id][guild.id] = { ...config.Servers[Server.Id][guild.id], channelId: channel.id }
            this.saveConfig()
        }

        channel.setParent(category.id)

        var webhook = await channel.fetchWebhooks()

        webhook = webhook.first()

        if (!webhook) {
            var webhook = await channel.createWebhook('NSM Bot')
        }

        channel.webhook = webhook
        Server.channel = channel

        Server.emit('discord_ready')

        this.serverLogger(category, guild, Server)

    }
    async guildInit(guild) {
        var category = guild.channels.cache.find(channel => config[guild.id] && channel.type == 'category' && channel.id == config[guild.id].categoryId)

        if (!category) {
            var category = await guild.channels.create('Game-Servers', {
                type: 'category'
            })

            config[guild.id] = { categoryId: category.id }
            this.saveConfig()
        }

        var eventChannel = guild.channels.cache.find(channel => config[guild.id]['eventChannelId'] && channel.type == 'text' && channel.id == config[guild.id]['eventChannelId'])

        !config[guild.id]['modRoles'] && (config[guild.id]['modRoles'] = [], this.saveConfig())

        if (!eventChannel) {
            var eventChannel = await guild.channels.create('Events')
            eventChannel.setParent(category.id)
            eventChannel.setPosition(0, 0)
            eventChannel.updateOverwrite(guild.roles.everyone, { SEND_MESSAGES: false })

            eventChannel.overwritePermissions([
                {
                    id: guild.id,
                    deny: ['SEND_MESSAGES'],
                }
            ])

            config[guild.id]['eventChannelId'] = eventChannel.id
            this.saveConfig()
        }

        guild.eventChannel = eventChannel

        for (var i = 0; i < this.Managers.length; i++) {
            if (Utils.stripString(this.Managers[i].Server.Hostname).includes("PRIVATE") == false)
            {       
                    if (this.Managers[i].Server.dvarsLoaded) {
                        this.initServer(category, guild, this.Managers[i].Server)
                        continue
                    }

                    this.Managers[i].Server.on('dvars_loaded', async (Server) => {
                        this.initServer(category, guild, Server)
                    
                        console.log()
                    })
            }
        }
    }
    async getDiscordUser(ClientId) {
        if (databaseCache[ClientId]) return databaseCache[ClientId]

        var discordUser = await this.Server.DB.metaService.getPersistentMeta('discord_user', ClientId)
        databaseCache[ClientId] = discordUser ? JSON.parse(discordUser.Value) : false

        return databaseCache[ClientId]
    }
    async getClientByDiscord(clientId) {
        var ClientId = await this.Server.DB.metaService.reversePersistentMeta('discord_id', clientId)
        var discordUser = ClientId ? await this.Server.DB.metaService.getPersistentMeta('discord_user', ClientId) : false
        var Client = ClientId ? await this.Server.DB.getClient(ClientId.ClientId) : false

        return {...discordUser, ...Client}
    }
    censorIp(string) {
        return string.replace(new RegExp(/([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})\:?([0-9]{1,5})?/g), '**[redacted]**')
        .replace(new RegExp(/\b((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\.|$)){4}\b/g), '**[redacted]**')
    }
    async onCommand(msg) {
        try {
            var ClientId = await this.Server.DB.metaService.reversePersistentMeta('discord_id', msg.author.id)
            var Client = ClientId ? await this.Server.DB.getClient(ClientId.ClientId) : false

            if (!discordUsers[msg.author.id.toString()]) {
                discordUsers[msg.author.id.toString()] = {}
            }

            var user = discordUsers[msg.author.id.toString()]

            if (user.lastMatches) {
                msg.content = msg.content.replace(new RegExp(/#([0-9]+)/g), (n) => {
                    var num = Math.max(parseInt(n.substr(1)), 1) - 1

                    if (user.lastMatches[num]) {
                        return `@${user.lastMatches[num].ClientId}`
                    }

                    return n
                })
            }

            var args = msg.content.substr(1).split(/\s+/g)

            var buffer = []

            if (this.commands[args[0].toLocaleLowerCase()]) {
                msg.author.tell = (text) => {
                    let embed = new Discord.MessageEmbed()
                    .setColor(colors[Utils.getRandomInt(0, colors.length)])
                    .addField('\u200B', `${text.substr(0, 1000)}`, true)

                    trySend(msg.channel, embed)
                }

                this.commands[args[0].toLocaleLowerCase()](msg, user, args)
                return
            }

            var Player = {
                PermissionLevel: 0,
                discordUser: msg.author.id,
                ClientId: 0,
                inGame: false,
                Tell: (msg) => {
                    buffer.push(this.censorIp(Utils.stripString(msg.toString())))
                }
            }

            Client && (Player = {...Player, ...Client})

            var end = () => {
                try {
                    let embed = new Discord.MessageEmbed()
                    .setColor(colors[Utils.getRandomInt(0, colors.length)])
                    .addField('\u200B', `${buffer.join('\n').substr(0, 1000)}`, true)

                    trySend(msg.channel, embed)
                }
                catch (e) {}
            }

            var executedMiddleware = await this.Manager.Commands.executeMiddleware(args[0], Player, args)
            if (await this.Manager.Commands.execute(args[0], Player, args)) {
                end()
                return
            }

            var command = Utils.getCommand(this.Manager.commands, args[0])

            switch (true) {
                case (!this.Manager.commands[command]):
                case (this.Manager.commands[command].gameTypeExclusions && this.Manager.commands[command].gameTypeExclusions.includes(this.Server.Gametype)):
                    !executedMiddleware && Player.Tell(Localization['COMMAND_NOT_FOUND'])
                    end()
                return
                case (this.Manager.commands[command].inGame || this.Manager.commands[command].inGame == undefined):
                    Player.Tell(Localization['COMMAND_ENV_ERROR'])
                    end()
                return
                case (Player.PermissionLevel < Permissions.Levels[this.Manager.commands[command].Permission]):
                    Player.Tell(Localization['COMMAND_FORBIDDEN'])
                    end()
                return
                case (args.length - 1 < this.Manager.commands[command].ArgumentLength):
                    Player.Tell(Localization['COMMAND_ARGUMENT_ERROR'])
                    Player.Tell(Utils.formatString(Localization['COMMAND_COMMAND_USAGE'], {
                        prefix: config.commandPrefixes[0],
                        usage: Localization[`USAGE_${command.toLocaleUpperCase()}`]
                    }))
                    end()
                return
            }

            await this.Manager.commands[command].callback(Player, args, false)
            end()
        }
        catch (e) {}
    }
}

module.exports = Plugin
