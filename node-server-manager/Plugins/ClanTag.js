const { randomInt } = require('crypto')
const path              = require('path')
const { emitKeypressEvents } = require('readline')
const Utils             = new (require(path.join(__dirname, '../Utils/Utils.js')))()
const { Command }       = require(path.join(__dirname, `../Lib/Classes.js`))
const Localization      = require(path.join(__dirname, `../Configuration/Localization-en.json`)).lookup

class Plugin {
    constructor(Server, Manager, Managers) {
        //add the .pguid of players to grant them staff permissions (must be done on ClanTag, ZombiesBank, ZombiesStats, NativeCommands & the gsc script staff.gsc)
        this.staff_list_a = [564391]
        this.botb_port = ["30001", "30005"]
        this.raid_port = ["30009"]
        this.daily_list = [3649, 12]
        this.pv_locked = 0
        this.Server = Server
        this.Manager = Manager
        this.Managers = Managers
        this.lockerCost = 100000

        this.wipe_id = [12]

        this.defaultLockerSize = 1
        this.fana_cd = 0;
        this.fana_last_use = new Date();
        this.is_raid_locked = ""
        //this.Server.on('preconnect', this.onPlayerPreconnect.bind(this))
        this.Server.on('connect', this.onPlayerConnect.bind(this))
        this.Server.on('disconnect', this.onPlayerDisconnect.bind(this))
        this.gameWatcher()
        this.init()
        this.saveSlot = 0
        this.Server.isDailyOccupied = false;
        this.Server.reservedSlots = 0;
        this.vote_id_list = []
        this.guild_list = []

        this.guild_list[this.guild_list.length] = "RFC;63156"
        this.guild_list[this.guild_list.length] = "RS;75539"
        this.guild_list[this.guild_list.length] = "ITD;66060"
        this.guild_list[this.guild_list.length] = "ILC;40024"
        this.guild_list[this.guild_list.length] = "KS;12"
        this.guild_list[this.guild_list.length] = "ALC;79746"
        this.guild_list[this.guild_list.length] = "WNL;65507"
        this.guild_list[this.guild_list.length] = "AZI;45982"
        this.guild_list[this.guild_list.length] = "LOV;135710"
        this.guild_list[this.guild_list.length] = "LCS;139379"
        this.guild_list[this.guild_list.length] = "TSC;29979"
        this.guild_list[this.guild_list.length] = "BHB;132773"
        this.guild_list[this.guild_list.length] = "ROH;94673"
    }

    async init() {
        (() => {
            let command = new Command()
            .setName('settag')
            .setAlias('st')
            .setPermission('ROLE_MODERATOR')
            .addParams([
                {
                    name: 'target',
                    index: 0,
                },
                {
                    name: 'tag',
                    join: true,
                    index: 1
                }
            ])
            .addCallback(async (Player, params) => {
                var Client = await this.Server.getClient(params.target)
                var connectedPlayers = this.getAllClients();
                connectedPlayers.forEach(connectedPlayer =>
                    {
                        if (connectedPlayer.ClientId == Client.ClientId)
                        {
                            Client = connectedPlayer
                        }
                    })
                if (!Client)
                {
                    Player.Tell("Target not found")
                    return
                }
                var inGame = await this.Server.findClient(Client.ClientId)

                var name = params.tag
                name = name.replace(/#0/g, '^0')
                name = name.replace(/#1/g, '^1')
                name = name.replace(/#2/g, '^2') 
                name = name.replace(/#3/g, '^3') 
                name = name.replace(/#4/g, '^4') 
                name = name.replace(/#5/g, '^5') 
                name = name.replace(/#6/g, '^6') 
                name = name.replace(/#7/g, '^7') 
                name = name.replace(/#8/g, '^8') 
                name = name.replace(/#9/g, '^9')
                name = name.replace(/@/g,  ' ')
                inGame && Client.Server.Rcon.executeCommandAsync(`setclantagraw ${Client.Clientslot} "${name}"`)
                inGame && Player.Tell(Utils.va(Localization['COMMAND_SETTAG_FORMAT_SELF'], name))
                this.Server.DB.metaService.addPersistentMeta('custom_tag', name, Client.ClientId)
            })

            this.Manager.Commands.add(command)
        })(this);
        (() => {
            let command = new Command()
            .setName('rank')
            .setAlias('rk')
            .addCallback(async (Player, args) => {

                var Client = args[1] ? await this.Server.getClient(args[1]) : Player
                switch (true) {
                    case (!Client):
                        Player.Tell(Localization['COMMAND_CLIENT_NOT_FOUND'])
                       return
                    case (Client.ClientId != Player.ClientId && Client.PermissionLevel >= Player.PermissionLevel):
                        Player.Tell(Localization['CLIENT_HIERARCHY_ERROR'])
                        return
                }

       		 var customTag = await this.Server.DB.metaService.getPersistentMeta('custom_tag', Client.ClientId)
		if(!customTag || !customTag)
		{
			Client.Tell('^1Error, no Tag')
            return;
		}
        Client.Tell("Loading ^3Rank^7 data...");
        //---------------------------------------------------------------------
        var gamemodeCount = await this.Server.DB.metaService.getPersistentMeta('gamemodeCount', Player.ClientId)
        if (!gamemodeCount)
        {
            await this.Server.DB.metaService.addPersistentMeta('gamemodeCount', "0", Player.ClientId)
            gamemodeCount = await this.Server.DB.metaService.getPersistentMeta('gamemodeCount', Player.ClientId)
        }


        var eeCount = await this.Server.DB.metaService.getPersistentMeta('eeCount', Player.ClientId)
        if (!eeCount)
        {
            await this.Server.DB.metaService.addPersistentMeta('eeCount', "0", Player.ClientId)
            eeCount = await this.Server.DB.metaService.getPersistentMeta('eeCount', Player.ClientId)
        }


        var zcoins = await this.Server.DB.metaService.getPersistentMeta('zcoins', Player.ClientId)
        if (!zcoins)
        {
            await this.Server.DB.metaService.addPersistentMeta('zcoins', "0", Player.ClientId)
            zcoins = await this.Server.DB.metaService.getPersistentMeta('zcoins', Player.ClientId)
        }

        var save = await this.Server.DB.metaService.getPersistentMeta('save', Player.ClientId)
        if (!save)
        {
            Player.Tell("Save error, contact staff")
            return;
        }

        var oneshot_50 = await this.Server.DB.metaService.getPersistentMeta('oneshot_50', Player.ClientId)
        if (!oneshot_50)
        {
            await this.Server.DB.metaService.addPersistentMeta('oneshot_50', "0", Player.ClientId)
            oneshot_50 = await this.Server.DB.metaService.getPersistentMeta('oneshot_50', Player.ClientId) 
        }

        var botb_hitless = await this.Server.DB.metaService.getPersistentMeta('botb_hitless', Player.ClientId)
        if (!botb_hitless)
        {
            await this.Server.DB.metaService.addPersistentMeta('botb_hitless', "0", Player.ClientId)
            botb_hitless = await this.Server.DB.metaService.getPersistentMeta('botb_hitless', Player.ClientId) 
        }

        var golden_spork = await this.Server.DB.metaService.getPersistentMeta('golden_spork', Player.ClientId)
        if (!golden_spork)
        {
            await this.Server.DB.metaService.addPersistentMeta('golden_spork', "0", Player.ClientId)
            golden_spork = await this.Server.DB.metaService.getPersistentMeta('golden_spork', Player.ClientId) 
        }

        var ee_speedrun = await this.Server.DB.metaService.getPersistentMeta('ee_speedrun', Player.ClientId)
        if (!ee_speedrun)
        {
            await this.Server.DB.metaService.addPersistentMeta('ee_speedrun', "0", Player.ClientId)
            ee_speedrun = await this.Server.DB.metaService.getPersistentMeta('ee_speedrun', Player.ClientId) 
        }

        var upgraded_tomahawk = await this.Server.DB.metaService.getPersistentMeta('upgraded_tomahawk', Player.ClientId)
        if (!upgraded_tomahawk)
        {
            await this.Server.DB.metaService.addPersistentMeta('upgraded_tomahawk', "0", Player.ClientId)
            upgraded_tomahawk = await this.Server.DB.metaService.getPersistentMeta('upgraded_tomahawk', Player.ClientId) 
        }

        var melee_only = await this.Server.DB.metaService.getPersistentMeta('melee_only', Player.ClientId)
        if (!melee_only)
        {
            await this.Server.DB.metaService.addPersistentMeta('melee_only', "0", Player.ClientId)
            melee_only = await this.Server.DB.metaService.getPersistentMeta('melee_only', Player.ClientId) 
        }

        var first_room_30 = await this.Server.DB.metaService.getPersistentMeta('first_room_30', Player.ClientId)
        if (!first_room_30)
        {
            await this.Server.DB.metaService.addPersistentMeta('first_room_30', "0", Player.ClientId)
            first_room_30 = await this.Server.DB.metaService.getPersistentMeta('first_room_30', Player.ClientId) 
        }
        var chadGamemodeCount = await this.Server.DB.metaService.getPersistentMeta('chadGamemodeCount', Player.ClientId)
        if (!chadGamemodeCount)
        {
            await this.Server.DB.metaService.addPersistentMeta('chadGamemodeCount', "0", Player.ClientId)
            chadGamemodeCount = await this.Server.DB.metaService.getPersistentMeta('chadGamemodeCount', Player.ClientId)
        }
        var gigachadGamemodeCount = await this.Server.DB.metaService.getPersistentMeta('gigachadGamemodeCount', Player.ClientId)
        if (!gigachadGamemodeCount)
        {
            await this.Server.DB.metaService.addPersistentMeta('gigachadGamemodeCount', "0", Player.ClientId)
            gigachadGamemodeCount = await this.Server.DB.metaService.getPersistentMeta('gigachadGamemodeCount', Player.ClientId)
        }

        var botb_gc = await this.Server.DB.metaService.getPersistentMeta('botb_gc', Player.ClientId)
        if (!botb_gc)
        {
            await this.Server.DB.metaService.addPersistentMeta('botb_gc', "0", Player.ClientId)
            botb_gc = await this.Server.DB.metaService.getPersistentMeta('botb_gc', Player.ClientId)
        }

        var titb_gc = await this.Server.DB.metaService.getPersistentMeta('titb_gc', Player.ClientId)
        if (!titb_gc)
        {
            await this.Server.DB.metaService.addPersistentMeta('titb_gc', "0", Player.ClientId)
            titb_gc = await this.Server.DB.metaService.getPersistentMeta('titb_gc', Player.ClientId)
        }

        var pia_gc = await this.Server.DB.metaService.getPersistentMeta('pia_gc', Player.ClientId)
        if (!pia_gc)
        {
            await this.Server.DB.metaService.addPersistentMeta('pia_gc', "0", Player.ClientId)
            pia_gc = await this.Server.DB.metaService.getPersistentMeta('pia_gc', Player.ClientId)
        }

        var save1 = parseInt(save.Value.split(';')[0])
        var save2 = parseInt(save.Value.split(';')[1])
        var highestSave = 0
        if (save1 > save2)
            highestSave = save1
        else
            highestSave = save2
        var gamemodeCountInt = parseInt(gamemodeCount.Value)
        var eeCountInt = parseInt(eeCount.Value)
        var zcoinsInt = parseInt(zcoins.Value)
        var chadCountInt = parseInt(chadGamemodeCount.Value)
        var gigachadCountInt = parseInt(gigachadGamemodeCount.Value)
        //----------------------------------------------------------------------

		var multiplier = '';
		if (customTag.Value == '^9F^7')
		{
            Client.Tell('^6I ^6II ^6III ^5IV ^5V ^5VI ^5VII ^1IIX ^1IX ^1-X-')
			Client.Tell('^7[^9F^7] ^8E ^2D ^4C ^5B ^6A ^3S ^3SS ^3SSS')
			
			multiplier = 'x2'
		}	
		else if (customTag.Value == '^8E^7')
		{
            Client.Tell('^6I ^6II ^6III ^5IV ^5V ^5VI ^5VII ^1IIX ^1IX ^1-X-')
			Client.Tell('^9F ^7[^8E^7] ^2D ^4C ^5B ^6A ^3S ^3SS ^3SSS')
			
			multiplier = 'x3'
		}
		else if (customTag.Value == '^2D^7')
		{
            Client.Tell('^6I ^6II ^6III ^5IV ^5V ^5VI ^5VII ^1IIX ^1IX ^1-X-')
			Client.Tell('^9F ^8E ^7[^2D^7] ^4C ^5B ^6A ^3S ^3SS ^3SSS')
			
			multiplier = 'x3'
		}
		else if (customTag.Value == '^4C^7')
		{
            Client.Tell('^6I ^6II ^6III ^5IV ^5V ^5VI ^5VII ^1IIX ^1IX ^1-X-')
			Client.Tell('^9F ^8E ^2D ^7[^4C^7] ^5B ^6A ^3S ^3SS ^3SSS')
			
			multiplier = 'x4'
		}
		else if (customTag.Value == '^5B^7')
		{
            Client.Tell('^6I ^6II ^6III ^5IV ^5V ^5VI ^5VII ^1IIX ^1IX ^1-X-')
			Client.Tell('^9F ^8E ^2D ^4C ^7[^5B^7] ^6A ^3S ^3SS ^3SSS')
			
			multiplier = 'x4'
		}
		else if (customTag.Value == '^6A^7')
		{
            Client.Tell('^6I ^6II ^6III ^5IV ^5V ^5VI ^5VII ^1IIX ^1IX ^1-X-')
			Client.Tell('^9F ^8E ^2D ^4C ^5B ^7[^6A^7] ^3S ^3SS ^3SSS')
			
			multiplier = 'x5'
		}
		else if (customTag.Value == '^3S^7')
		{
            Client.Tell('^6I ^6II ^6III ^5IV ^5V ^5VI ^5VII ^1IIX ^1IX ^1-X-')
			Client.Tell('^9F ^8E ^2D ^4C ^5B ^6A ^7[^3S^7] ^3SS ^3SSS')
			
			multiplier = 'x6'
		}
        else if (customTag.Value == '^3SS^7')
		{
            Client.Tell('^6I ^6II ^6III ^5IV ^5V ^5VI ^5VII ^1IIX ^1IX ^1-X-')
			Client.Tell('^9F ^8E ^2D ^4C ^5B ^6A ^3S ^7[^3SS^7] ^3SSS')
			
			multiplier = 'x7'
		}
        else if (customTag.Value == '^3SSS^7')
		{
            Client.Tell('^6I ^6II ^6III ^5IV ^5V ^5VI ^5VII ^1IIX ^1IX ^1-X-')
            Client.Tell('^9F ^8E ^2D ^4C ^5B ^6A ^3S ^3SS ^7[^3SSS^7]')
			
			multiplier = 'x9'
		}
        else if (customTag.Value == '^6 I ^7')
		{
            Client.Tell('^7[^6I^7] ^6II ^6III ^5IV ^5V ^5VI ^5VII ^1IIX ^1IX ^1-X-')
            Client.Tell('^9F ^8E ^2D ^4C ^5B ^6A ^3S ^3SS ^3SSS')

			multiplier = 'x10'
		}
        else if (customTag.Value == '^6II^7')
		{
			Client.Tell('^6I ^7[^6II^7] ^6III ^5IV ^5V ^5VI ^5VII ^1IIX ^1IX ^1-X-')
            Client.Tell('^9F ^8E ^2D ^4C ^5B ^6A ^3S ^3SS ^3SSS')

			multiplier = 'x11'
		}
        else if (customTag.Value == '^6III^7')
		{
			Client.Tell('^6I ^6II ^7[^6III^7] ^5IV ^5V ^5VI ^5VII ^1IIX ^1IX ^1-X-')
            Client.Tell('^9F ^8E ^2D ^4C ^5B ^6A ^3S ^3SS ^3SSS')

			multiplier = 'x12'
		}
        else if (customTag.Value == '^5IV^7')
		{
			Client.Tell('^6I ^6II ^6III ^7[^5IV^7] ^5V ^5VI ^5VII ^1IIX ^1IX ^1-X-')
            Client.Tell('^9F ^8E ^2D ^4C ^5B ^6A ^3S ^3SS ^3SSS')

			multiplier = 'x13'
		}
        else if (customTag.Value == '^5V^7')
		{
			Client.Tell('^6I ^6II ^6III ^5IV ^7[^5V^7] ^5VI ^5VII ^1IIX ^1IX ^1-X-')
            Client.Tell('^9F ^8E ^2D ^4C ^5B ^6A ^3S ^3SS ^3SSS')

			multiplier = 'x13'
		}
        else if (customTag.Value == '^5VI^7')
		{
			Client.Tell('^6I ^6II ^6III ^5IV ^5V ^7[^5VI^7] ^5VII ^1IIX ^1IX ^1-X-')
            Client.Tell('^9F ^8E ^2D ^4C ^5B ^6A ^3S ^3SS ^3SSS')

			multiplier = 'x13'
		}
        else if (customTag.Value == '^5VII^7')
		{
			Client.Tell('^6I ^6II ^6III ^5IV ^5V ^5VI ^7[^5VII^7] ^1IIX ^1IX ^1-X-')
            Client.Tell('^9F ^8E ^2D ^4C ^5B ^6A ^3S ^3SS ^3SSS')

			multiplier = 'x14'
		}
        else if (customTag.Value == '^1IIX^7')
		{
			Client.Tell('^6I ^6II ^6III ^5IV ^5V ^5VI ^5VII ^7[^1IIX^7] ^1IX ^1-X-')
            Client.Tell('^9F ^8E ^2D ^4C ^5B ^6A ^3S ^3SS ^3SSS')

			multiplier = 'x15'
		}
        else if (customTag.Value == '^1IX^7')
		{
			Client.Tell('^6I ^6II ^6III ^5IV ^5V ^5VI ^5VII ^1IIX ^7[^1IX^7] ^1-X-')
            Client.Tell('^9F ^8E ^2D ^4C ^5B ^6A ^3S ^3SS ^3SSS')

			multiplier = 'x15'
		}
        else if (customTag.Value == '^1-X-^7')
		{
			Client.Tell('^6I ^6II ^6III ^5IV ^5V ^5VI ^5VII ^1IIX ^1IX ^7[^1-X-^7]')
            Client.Tell('^9F ^8E ^2D ^4C ^5B ^6A ^3S ^3SS ^3SSS')

			multiplier = 'x20'
		}
		var customName = await this.Server.DB.metaService.getPersistentMeta('custom_name', Client.ClientId)
		if(customName && customName.Value)
		{
			Client.Tell(Utils.va('^2$ multiplier ^7is :^3 %s + ^3x3 VIP^7', multiplier))
		}
		else
		{
			Client.Tell(Utils.va('^2$ multiplier ^7is :^3 %s', multiplier))	
		}
        Client.Tell(Utils.va('Your ^3rank^7 is : %s', customTag.Value))	
        await new Promise(resolve => setTimeout(resolve, 2000))
        Client.Tell(`---^5Next rank requirements^7---`)
        await new Promise(resolve => setTimeout(resolve, 500))

		if (customTag.Value == '^9F^7')
			Client.Tell('^2Points^7 : ^2$100.000')
		if (customTag.Value == '^8E^7')
			Client.Tell('^2Points^7 : ^2$200.000')
		if (customTag.Value == '^2D^7')
			Client.Tell('^2Points^7 : ^2$400.000')
		if (customTag.Value == '^4C^7')
			Client.Tell('^2Points^7 : ^2$1M')
		if (customTag.Value == '^5B^7')
			Client.Tell('^2Points^7 : ^2$2M')
		if (customTag.Value == '^6A^7')
			Client.Tell('^2Points^7 : ^2$5M')
        if (customTag.Value == '^3S^7')
			Client.Tell('^2Points^7 : ^2$10M')
        if (customTag.Value == '^3SS^7')
			Client.Tell('^2Points^7 : ^2$30M')
		if (customTag.Value == '^3SSS^7')
        {
            Client.Tell(`^2Ez Gamemode^3 (^2${gamemodeCountInt}^3/^11^3)`)
            await new Promise(resolve => setTimeout(resolve, 300))
            Client.Tell(`^3EE^3 (^2${eeCountInt}^3/^12^3)`)
            await new Promise(resolve => setTimeout(resolve, 300))
            Client.Tell(`^5Round^3 (^2${highestSave}^3/^135^3)`)
            await new Promise(resolve => setTimeout(resolve, 300))
            Client.Tell(`^5Z-Coins^3 (^2${zcoinsInt}^3/^1200^3)`)
            await new Promise(resolve => setTimeout(resolve, 300))
			Client.Tell('^2Points^3 : ^2$60M')
        }
        if (customTag.Value == '^6 I ^7')
        {
            Client.Tell(`^2Ez Gamemode^3 (^2${gamemodeCountInt}^3/^12^3)`)
            await new Promise(resolve => setTimeout(resolve, 300))
            Client.Tell(`^3EE^3 (^2${eeCountInt}^3/^13^3)`)
            await new Promise(resolve => setTimeout(resolve, 300))
            Client.Tell(`^5Round^3 (^2${highestSave}^3/^140^3)`)
            await new Promise(resolve => setTimeout(resolve, 300))
            Client.Tell(`^5Z-Coins^3 (^2${zcoinsInt}^3/^1300^3)`)
            await new Promise(resolve => setTimeout(resolve, 300))
			Client.Tell('^2Points^3 : ^2$70M')
        }
        if (customTag.Value == '^6II^7')
        {
            Client.Tell(`^2Ez Gamemode^3 (^2${gamemodeCountInt}^3/^15^3)`)
            await new Promise(resolve => setTimeout(resolve, 300))
            Client.Tell(`^3EE^3 (^2${eeCountInt}^3/^14^3)`)
            await new Promise(resolve => setTimeout(resolve, 300))
            Client.Tell(`^5Round^3 (^2${highestSave}^3/^145^3)`)
            await new Promise(resolve => setTimeout(resolve, 300))
            Client.Tell(`^5Z-Coins^3 (^2${zcoinsInt}^3/^1600^3)`)
            await new Promise(resolve => setTimeout(resolve, 300))
			Client.Tell('^2Points^3 : ^2$80M')
        }
        if (customTag.Value == '^6III^7')
        {
            Client.Tell(`^1Chad Gamemode^3 (^1${chadCountInt}^3/^12^3)`)
            await new Promise(resolve => setTimeout(resolve, 300))
            Client.Tell(`^2Ez Gamemode^3 (^2${gamemodeCountInt}^3/^15^3)`)
            await new Promise(resolve => setTimeout(resolve, 300))
            Client.Tell(`^3EE^3 (^2${eeCountInt}^3/^15^3)`)
            await new Promise(resolve => setTimeout(resolve, 300))
            Client.Tell(`^5Round^3 (^2${highestSave}^3/^150^3)`)
            await new Promise(resolve => setTimeout(resolve, 300))
            Client.Tell(`^5Z-Coins^3 (^2${zcoinsInt}^3/^1600^3)`)
            await new Promise(resolve => setTimeout(resolve, 300))
			Client.Tell('^2Points^3 : ^2$90M')
        }
        if (customTag.Value == '^5IV^7')
        {
            Client.Tell(`^1Chad Gamemode^3 (^1${chadCountInt}^3/^14^3)`)
            await new Promise(resolve => setTimeout(resolve, 300))
            Client.Tell(`^2Ez Gamemode^3 (^2${gamemodeCountInt}^3/^15^3)`)
            await new Promise(resolve => setTimeout(resolve, 300))
            Client.Tell(`^3EE^3 (^2${eeCountInt}^3/^16^3)`)
            await new Promise(resolve => setTimeout(resolve, 300))
            Client.Tell(`^5Round^3 (^2${highestSave}^3/^155^3)`)
            await new Promise(resolve => setTimeout(resolve, 300))
            Client.Tell(`^5Z-Coins^3 (^2${zcoinsInt}^3/^1650^3)`)
            await new Promise(resolve => setTimeout(resolve, 300))
			Client.Tell('^2Points^3 : ^2$100M')
        }
        if (customTag.Value == '^5V^7')
        {
            Client.Tell(`^1Chad Gamemode^3 (^1${chadCountInt}^3/^16^3)`)
            await new Promise(resolve => setTimeout(resolve, 300))
            Client.Tell(`^2Ez Gamemode^3 (^2${gamemodeCountInt}^3/^15^3)`)
            await new Promise(resolve => setTimeout(resolve, 300))
            Client.Tell(`^3EE^3 (^2${eeCountInt}^3/^18^3)`)
            await new Promise(resolve => setTimeout(resolve, 300))
            Client.Tell(`^5Round^3 (^2${highestSave}^3/^160^3)`)
            await new Promise(resolve => setTimeout(resolve, 300))
            Client.Tell(`^5Z-Coins^3 (^2${zcoinsInt}^3/^1700^3)`)
            await new Promise(resolve => setTimeout(resolve, 300))
			Client.Tell('^2Points^3 : ^2$110M')
        }
        if (customTag.Value == '^5VI^7')
        {   
            Client.Tell(`^1Chad Gamemode^3 (^1${chadCountInt}^3/^110^3)`)
            await new Promise(resolve => setTimeout(resolve, 300))
            Client.Tell(`^2Ez Gamemode^3 (^2${gamemodeCountInt}^3/^17^3)`)
            await new Promise(resolve => setTimeout(resolve, 300))
            Client.Tell(`^3EE^3 (^2${eeCountInt}^3/^110^3)`)
            await new Promise(resolve => setTimeout(resolve, 300))
            Client.Tell(`^5Round^3 (^2${highestSave}^3/^165^3)`)
            await new Promise(resolve => setTimeout(resolve, 300))
            Client.Tell(`^5Z-Coins^3 (^2${zcoinsInt}^3/^1800^3)`)
            await new Promise(resolve => setTimeout(resolve, 300))
			Client.Tell('^2Points^3 : ^2$150M')
        }

        if (customTag.Value == '^5VII^7')
        {
            Client.Tell('^2$ : $300M')
            await new Promise(resolve => setTimeout(resolve, 300))
            Client.Tell(`^5Z-Coins ^3(^2${zcoinsInt}^3/^12000^3)`)
            await new Promise(resolve => setTimeout(resolve, 300))
            Client.Tell(`^3Round ^3(^2${highestSave}^3/^170^3)`)
            await new Promise(resolve => setTimeout(resolve, 300))  
            Client.Tell(`^6GigaChad^7 Completion ^3(^2${gigachadCountInt}^3/^13^3)`)
            await new Promise(resolve => setTimeout(resolve, 300))
            Client.Tell(`^6BotB GigaChad^7 Completion ^3(^2${botb_gc.Value}^3/^11^3)`)
            await new Promise(resolve => setTimeout(resolve, 300))
            Client.Tell(`Obtain the ^3Golden Spoon ^3(^2${golden_spork.Value}^3/^11^3)`)
            await new Promise(resolve => setTimeout(resolve, 300))
            Client.Tell(`One Round ^3Melee only^7 (^2R30+^7) ^3(^2${melee_only.Value}^3/^11^3)`)
            await new Promise(resolve => setTimeout(resolve, 300))
            Client.Tell(`^2R30+^7 in First Room ^3(^2${first_room_30.Value}^3/^11^3)`)


        }
        if (customTag.Value == '^1IIX^7')
        {
            Client.Tell('^2$ : $500M')
            await new Promise(resolve => setTimeout(resolve, 300))
            Client.Tell(`^5Z-Coins ^3(^2${zcoinsInt}^3/^13000^3)`)
            await new Promise(resolve => setTimeout(resolve, 300))
            Client.Tell(`^3Round ^3(^2${highestSave}^3/^180^3)`)
            await new Promise(resolve => setTimeout(resolve, 300))
            Client.Tell(`^6BotB GigaChad^7 Completion ^3(^2${botb_gc.Value}^3/^13^3)`)
            await new Promise(resolve => setTimeout(resolve, 300))
    //        Client.Tell(`^6TitB GigaChad^7 Completion ^3(^2${titb_gc.Value}^3/^12^3)`)
    //        await new Promise(resolve => setTimeout(resolve, 300))
            Client.Tell(`^6PiA GigaChad^7 Completion ^3(^2${pia_gc.Value}^3/^13^3)`)
            await new Promise(resolve => setTimeout(resolve, 300))
            Client.Tell(`Obtain the ^5Blue Tomahawk ^3(^2${upgraded_tomahawk.Value}^3/^11^3)`)
            await new Promise(resolve => setTimeout(resolve, 300))
            Client.Tell(`Reach ^3Round 50^7 without loading ^3(^2${oneshot_50.Value}^3/^11^3)`)
        }
        if (customTag.Value == '^1IX^7')
        {
            Client.Tell('^2$ : $1B')
            await new Promise(resolve => setTimeout(resolve, 300))
            Client.Tell(`^5Z-Coins ^3(^2${zcoinsInt}^3/^15000^3)`)
            await new Promise(resolve => setTimeout(resolve, 300))
            Client.Tell(`^3Round ^3(^2${highestSave}^3/^1100^3)`)
            await new Promise(resolve => setTimeout(resolve, 300))
            Client.Tell(`^6BotB GigaChad^7 Completion ^3(^2${botb_gc.Value}^3/^15^3)`)
            await new Promise(resolve => setTimeout(resolve, 300))
    //        Client.Tell(`^6TitB GigaChad^7 Completion ^3(^2${titb_gc.Value}^3/^12^3)`)
    //        await new Promise(resolve => setTimeout(resolve, 300))
            Client.Tell(`^6PiA GigaChad^7 Completion ^3(^2${pia_gc.Value}^3/^15^3)`)
            await new Promise(resolve => setTimeout(resolve, 300))
            Client.Tell(`BotB Full game ^3Hitless & Perkless^7 ^3(^2${botb_hitless.Value}^3/^11^3)`)
            await new Promise(resolve => setTimeout(resolve, 300))
            Client.Tell(`Complete ^3Origins EE^7 in under ^535 minutes^7 ^3(^2${ee_speedrun.Value}^3/^11^3)`)   
        }
        if (customTag.Value == '^1-X-^7')
        {
            Client.Tell(`You are ^2Max Rank^7, what a zm god!`)
        }
            })

            this.Manager.Commands.add(command)
        })(this);

        (() => {
            let command = new Command()
            .setName('vip')
            .setAlias('vip')
            .addCallback(async (Player, params, args) =>
            {
                if (args[1] && args[1] != "upgrade" && args[1] != "darkblue" && args[1] != "lightblue" && args[1] != "yellow" && args[1] != "purple" && args[1] != "grey" && args[1] != "brown" && args[1] != "green" && args[1] != "white" && args[1] != "black")
                {
                    const Client = await this.Server.getClient(args[1])
    
                    if (Client)
                    {
                        var name = Client.Name
                        var text = ""
                        var customName = await this.Server.DB.metaService.getPersistentMeta('custom_name', Client.ClientId)
                        if (!customName)
                        {
                            text = "No VIP"
                        }
                        else if (customName.Value.includes("^3VIP") || customName.Value.includes("^3[VIP"))
                        {
                            text = "^3VIP Level 1^7"
                        }
                        else if (customName.Value.includes("^6VIP") || customName.Value.includes("^6[VIP"))
                        {
                            text = "^6VIP Level 2^7"
                        }
                        else if (customName.Value.includes("^1VIP") || customName.Value.includes("^1[VIP"))
                        {
                            text = "^1VIP Level 3^7"
                        }
                        else if (customName.Value.includes("^2VIP") || customName.Value.includes("^2[VIP"))
                        {
                            text = "^1VIP Level 4^7"
                        }

                        if (customName)
                        {
                            name = customName.Value.replaceAll('^', '#').replaceAll(' ', '@')
                        }

                        var customTag = await this.Server.DB.metaService.getPersistentMeta('custom_tag', Client.ClientId)
                        if (!customTag)
                        {
                            Player.Tell("error")
                            return
                        }

                        Player.Tell(`${name}^3 have ${text} and is rank ${customTag.Value}. id : ${Client.ClientId}`)
                        return
                    }
                }
                var inGame = await this.Server.findClient(Player.ClientId)
                if (!inGame)
                {
                    Player.Tell("In game command only")
                    return
                }
                var zcoins_req = 99999999;
                var save_req = 999999;
                var group = 0;

                var zcoins = await this.Server.DB.metaService.getPersistentMeta('zcoins', inGame.ClientId)
                if (!zcoins)
                {
                    await this.Server.DB.metaService.addPersistentMeta('zcoins', "0", inGame.ClientId)
                    zcoins = await this.Server.DB.metaService.getPersistentMeta('zcoins', inGame.ClientId)
                }

                var save = await this.Server.DB.metaService.getPersistentMeta('save', inGame.ClientId)
                if (!save)
                {
                    inGame.Tell("Save error, contact staff")
                    return
                }
                var save1 = parseInt(save.Value.split(';')[0])
                var save2 = parseInt(save.Value.split(';')[1])
                var highestSave = 0
                if (save1 > save2)
                    highestSave = save1
                else
                    highestSave = save2

                var customTag = await this.Server.DB.metaService.getPersistentMeta('custom_tag', inGame.ClientId)
                if (!customTag)
                {
                    inGame.Tell("Error #vip, contact admin")
                    return
                }

                var customName = await this.Server.DB.metaService.getPersistentMeta('custom_name', inGame.ClientId)

                if (!customName || !customName.Value)
                {
                    zcoins_req = 2000
                    save_req = 60
                    group = 1
                }
                else if (customName.Value.includes("^3VIP") || customName.Value.includes("^3[VIP"))
                {
                    zcoins_req = 5000
                    save_req = 80
                    group = 2
                }
                else if (customName.Value.includes("^6VIP") || customName.Value.includes("^6[VIP"))
                {
                    zcoins_req = 8000
                    save_req = 100
                    group = 3
                }
                if (!args[1] || (args[1] != "upgrade" && args[1] != "darkblue" && args[1] != "lightblue" && args[1] != "yellow" && args[1] != "purple" && args[1] != "grey" && args[1] != "brown" && args[1] != "green" && args[1] != "white" && args[1] != "black"))
                {
                    if (group != 0)
                    {
                        var rank_req = "^6II"
                        if (group == 1)
                            rank_req = "^6II"
                        if (group == 2)
                            rank_req = "^5V"
                        if (group == 3)
                            rank_req = "^1IX"
                        inGame.Tell(`---^5Next VIP requirements^7---`)
                        await new Promise(resolve => setTimeout(resolve, 200))
                        inGame.Tell(`^5Z-coins ^3(^2${zcoins.Value}^3/^1${zcoins_req}^3)`)
                        await new Promise(resolve => setTimeout(resolve, 200))
                        inGame.Tell(`^3Save^3 (^2${highestSave}^3/^1${save_req}^3)`)
                        await new Promise(resolve => setTimeout(resolve, 200))
                        inGame.Tell(`^3Rank ^3 (^2${customTag.Value}^3/${rank_req}^3)`)
                        await new Promise(resolve => setTimeout(resolve, 3000))
                        inGame.Tell(`-------------------------------`)
                        await new Promise(resolve => setTimeout(resolve, 200))
                        inGame.Tell("^3To upgrade : ^5.vip upgrade")
                        await new Promise(resolve => setTimeout(resolve, 200))
                    }
                    inGame.Tell("^3To change colors : ^5.vip (color)^7 ^3yellow^7|^6purple^7|^2green^7|^4darkblue^7|^5lightblue^7|^8grey^7|^9brown^7|white|^0black")
                    return
                }
                if (args[1] == "upgrade")
                {
                    //Start Requirement check
                    if (customName && (customName.Value.includes("^1VIP") || customName.Value.includes("^1[VIP")))
                    {
                        inGame.Tell("You are already ^1LV3 VIP^7 !")
                        return
                    }
                    var is_requirement_fullfilled = true

                    if (parseInt(zcoins.Value) < zcoins_req)
                    {
                        inGame.Tell(`^3Not enough ^5Z-coins ^3(^2${zcoins.Value}^3/^1${zcoins_req}^3)`)
                        is_requirement_fullfilled = false
                    }

                    if (highestSave < save_req)
                    {
                        inGame.Tell(`^3Your ^5highest save^3 is too low ^3 (^2${highestSave}^3/^1${save_req}^3)`)
                        is_requirement_fullfilled = false;
                    }

                    if (group == 1)
                    {
                        if (customTag.Value != "^6II^7" && customTag.Value != "^6III^7" && customTag.Value != "^5IV^7" && customTag.Value != "^5V^7" &&
                        customTag.Value != "^5VI^7" && customTag.Value != "^5VII^7" && customTag.Value != "^1IIX^7" && customTag.Value != "^1IX^7" && customTag.Value != "^1-X-^7")
                        {
                            inGame.Tell(`^3Your ^5rank^3 is too low ^3 (^2${customTag.Value}^3/^6III^3)`)
                            is_requirement_fullfilled = false;
                        }
                    }
                    if (group == 2)
                    {
                        if (customTag.Value != "^5V^7" && customTag.Value != "^5VI^7" && customTag.Value != "^5VII^7" && customTag.Value != "^1IIX^7" && customTag.Value != "^1IX^7" && customTag.Value != "^1-X-^7")
                        {
                            inGame.Tell(`^3Your ^5rank^3 is too low ^3 (^2${customTag.Value}^3/^5VII^3)`)
                            is_requirement_fullfilled = false;
                        }
                    }                    
                    if (group == 3)
                    {
                        if (customTag.Value != "^1IX^7" && customTag.Value != "^1-X-^7")
                        {
                            inGame.Tell(`^3Your ^5rank^3 is too low ^3 (^2${customTag.Value}^3/^1IX^3)`)
                            is_requirement_fullfilled = false;
                        }
                    }
                    if (is_requirement_fullfilled == false)
                        return

                    //Requirements complete

                    //Start database change
                    var slot = 0;
                    if (save1 < save_req && save2 >= save_req)
                    {
                        await this.Server.DB.metaService.addPersistentMeta('save', `${save1};0`, inGame.ClientId) 
                        slot = 2
                    }
                    else if (save2 < save_req && save1 >= save_req)
                    {
                        await this.Server.DB.metaService.addPersistentMeta('save', `0;${save2}`, inGame.ClientId) 
                        slot = 1
                    }
                    else if (save1 > save2)
                    {
                        await this.Server.DB.metaService.addPersistentMeta('save', `${save1};0`, inGame.ClientId) 
                        slot = 2
                    }    
                    else 
                    {
                        await this.Server.DB.metaService.addPersistentMeta('save', `0;${save2}`, inGame.ClientId) 
                        slot = 1
                    }
                        
        
                    inGame.Tell("^5Lowest required save^3 consumed.") 
                    await this.Server.DB.metaService.addPersistentMeta('zcoins', parseInt(zcoins.Value) - zcoins_req, inGame.ClientId)
                    inGame.Tell(`^5${zcoins_req} Z-Coins^3 have been withdrew from your bank account!`)
                    //db changes completed
                    this.Managers.forEach(manager =>
                        {
                            if (manager)
                            {
                                this.checkForLoadedSave(manager, inGame.ClientId, slot)
                            }
                        })

                    if (group == 1)
                    {
                        var new_name = "[^3VIP^7] ^3" + inGame.Name
                        var customName = await this.Server.DB.metaService.addPersistentMeta('custom_name', new_name, inGame.ClientId)
                        inGame && this.Server.Rcon.executeCommandAsync(`rename ${inGame.Clientslot} "${new_name}"`)
                        inGame.Tell("^2Successfully^7 upgraded to ^3VIP Level 1^7 !");
                    }
                    else if (group == 2)
                    {
                        var oldName = await this.Server.DB.metaService.getPersistentMeta('custom_name', inGame.ClientId)
                        var new_name = "[^6VIP^7]" + oldName.Value.split("]")[1]
                        if (oldName.Value.split("]")[2])
                            new_name += "]" + oldName.Value.split("]")[2]
                        var customName = await this.Server.DB.metaService.addPersistentMeta('custom_name', new_name, inGame.ClientId)
                        inGame && this.Server.Rcon.executeCommandAsync(`rename ${inGame.Clientslot} "${new_name}"`)
                        inGame.Tell("^2Successfully^7 upgraded to ^6VIP Level 2^7 !");
                    }
                    else if (group == 3)
                    {
                        var oldName = await this.Server.DB.metaService.getPersistentMeta('custom_name', inGame.ClientId)
                        var new_name = "[^1VIP^7]" + oldName.Value.split("]")[1]
                        if (oldName.Value.split("]")[2])
                            new_name += "]" + oldName.Value.split("]")[2]
                        var customName = await this.Server.DB.metaService.addPersistentMeta('custom_name', new_name, inGame.ClientId)
                        inGame && this.Server.Rcon.executeCommandAsync(`rename ${inGame.Clientslot} "${new_name}"`)
                        inGame.Tell("^2Successfully^7 upgraded to ^1VIP Level 3^7 !");
                    }
                    else
                    {
                        inGame.Tell("An ^1error^7 occured, contact the ^1staff^7")
                        return
                    }
                }
                else
                {
                    var customName = await this.Server.DB.metaService.getPersistentMeta('custom_name', inGame.ClientId)
                    if (!customName)
                    {
                        Player.Tell("Cannot change ^3VIP colors^7 since you are not ^3VIP^7 !")
                        return
                    }
                    var color = " ^7";

                    if (args[1] == "green")
                        color = " ^2"
                    if (args[1] == "yellow")
                        color = " ^3"
                    if (args[1] == "darkblue")
                        color = " ^4"
                    if (args[1] == "lightblue")
                        color = " ^5"
                    if (args[1] == "purple")
                        color = " ^6"
                    if (args[1] == "white")
                        color = " ^7"
                    if (args[1] == "grey")
                        color = " ^8"
                    if (args[1] == "brown")
                        color = " ^9"    
                    if (args[1] == "black")
                        color = " ^0" 

                    var vip_tag = "[^3VIP^7]";
                    if (customName.Value.includes("^3VIP") || customName.Value.includes("^3[VIP"))
                        vip_tag = "[^3VIP^7]";
                    if (customName.Value.includes("^6VIP") || customName.Value.includes("^6[VIP"))
                        vip_tag = "[^6VIP^7]";
                    if (customName.Value.includes("^1VIP") || customName.Value.includes("^1[VIP"))
                        vip_tag = "[^1VIP^7]";
                    if (customName.Value.includes("^2VIP") || customName.Value.includes("^2[VIP"))
                        vip_tag = "[^2VIP^7]";                    

                    var oldName = await this.Server.DB.metaService.getPersistentMeta('custom_name', inGame.ClientId)
                    if (oldName.Value.split("]")[2])
                    {
                        var new_name = vip_tag + oldName.Value.split("]")[1] + "]" + color + oldName.Value.split("]")[2].substring(3)
                    }
                    else
                    {
                        var new_name = vip_tag + color + oldName.Value.split("]")[1].substring(3)
                    }
                    var customName = await this.Server.DB.metaService.addPersistentMeta('custom_name', new_name, inGame.ClientId)
                    inGame && this.Server.Rcon.executeCommandAsync(`rename ${inGame.Clientslot} "${new_name}"`)
                    inGame.Tell("^2Successfully^7 changed your ^3name color^7 !");
                }
            })
            this.Manager.Commands.add(command)
        })(this);


     (() => {
            let command = new Command()
            .setName('commands')
            .setAlias('c')
            .addParams([
                {
                    name: 'page',
                    index: 0,
		            optional: true,
                },
                {
                    name: 'language',
                    index: 1,
		            optional: true,
                }
            ])
            .addCallback(async (Player, params, args) => {

		if( params.page && params.page != '1' && params.page != '2' && params.page != 'fr')
		{
			Player.Tell('^3.c ^7[^31-2^7]')	
			Player.Tell('^1Invalid^7 page number, usage: ')	
			return		
		}
		if(params.page == 'fr' || (params.page == '1' && params.language == 'fr'))
		{
			Player.Tell('^3.c 2 fr^7: Affiche la page suivante.')
			Player.Tell('^3.rank^7: Affiche les informations de ton rang.')
			Player.Tell('^3.rankup^7: Paye de l argent pour monter en rang et gagner plus de ^2$')
			Player.Tell('^3.d <amount | all>^7: Depose X points dans ta banque.')
			Player.Tell('^3.w <amount | all>^7: Retire X points de ta banque.')
			Player.Tell('^3.afk^7: Deviens AFK pour max 15 mins, 15 mins d attente. ')
			Player.Tell('^3.money^7: Affiche ton argent en banque.')
			Player.Tell('^3----- PAGE 1/2 -----^7')
		}
		else if(params.page == '2' && params.language == 'fr')
		{

			Player.Tell('^3.zstats [name]^7: Affiche les stats du joueur.')
			Player.Tell('^3.pay [name][amount]^7: Donne de l argent au joueur selectionne.')
			Player.Tell('^3.rev^7: Cout pour ^3rang S^7 : ^2$1M^7 3 manches de recharge.')
			Player.Tell('^3.rev^7: [^1VIP ou RANG S^7] reanime les spectateurs, toi inclus.')
			Player.Tell('^3.kill^7: [^1VILLE ou BURIED^7] Tue le dernier zombie/sorciere qui bug')
            Player.Tell('^3.id^7: Affiche ton ID (Utile pour bug nom utilise .zstats @id)')
            Player.Tell('^3.buy^7: Affiche tes stats bonus et le cout du prochaine achat')
			Player.Tell('^3----- PAGE 2/2 -----^7')

		}
		else if(params.page == '2')
		{
			Player.Tell('^3.pay [name][amount]^7: Give points from your bank to selected player.')
			Player.Tell('^3.zstats [name]^7: Check player zombie stats.')
			Player.Tell('^3.rev^7: Cost for ^3S rank^7: ^2$1M^7, 3 rounds cooldown.')
			Player.Tell('^3.rev^7: [^1VIP or S RANK^7] revive all spectators including yourself.')
			Player.Tell('^3.kill^7: [^1TOWN or BURIED^7] Kill the last bugged zombie/witch.')
            Player.Tell('^3.id^7: Display your ID (Useful for name bug, use .zstats @id')
            Player.Tell('^3.buy^7: Display extra stats & next purchase info')
			Player.Tell('^3----- PAGE 2/2 -----^7')
		}
		else
		{
			Player.Tell('^3.c 2^7: Display next page.')
			Player.Tell('^3.rank^7: Check your rank info.')
			Player.Tell('^3.rankup^7: pay money to rank up and earn more ^2$')
			Player.Tell('^3.d <amount | all>^7: Deposit X points in your bank.')
			Player.Tell('^3.w <amount | all>^7: Withdraw X points in your bank.')
			Player.Tell('^3.afk^7: go AFK for up to 15 mins 15 mins cooldown. ')
			Player.Tell('^3.money^7: See how much money you have.')
			Player.Tell('^3----- PAGE 1/2 -----^7')
		}
		

            })

            this.Manager.Commands.add(command)
        })(this);

        (() => {
            let command = new Command()
            .setName('wipe')
            .setAlias('wp')
            .addCallback(async (Player, params, args) => {
            for(const id of this.wipe_id)
            {
                if (Player.ClientId == id)
                    {
                        for(const ig_player of await this.Manager.Server.getClients())
                            {
                                for (const id of this.wipe_id)
                                {
                                    if (parseInt(ig_player.ClientId) != this.wipe_id)
                                    {
                                        ig_player.Kick("^1Server locked^7 for testing")
                                    }
                                }

                            }
                    }
            }

                 })
        })(this);

        (() => {
            let command = new Command()
            .setName('guildlock')
            .setAlias('glock')
            .addCallback(async (Player, params, args) =>
            {
                if (this.Manager.Server.Hostname)
                {
                    if (await this.is_raid() == false)
                    {
                        var guild_quest = await this.Server.DB.metaService.getPersistentMeta('guild_quest', Player.ClientId)
                        if (!guild_quest)
                        {
                            Player.Tell("Must be in a ^6guild^7 to use this ^3command^7.")
                            return
                        }
                        if(guild_quest.Value.split(";")[1] == "gamemode_speedrun_quest_pia" && (!this.Manager.Server.Hostname.includes('PANZER'))
                        || guild_quest.Value.split(";")[1] == "gamemode_speedrun_quest_titb" && (!this.Manager.Server.Hostname.includes('BUS'))
                        || guild_quest.Value.split(";")[1] == "gamemode_speedrun_quest_botb" && (await this.is_brutus() == false)
                        || guild_quest.Value.split(";")[1] == "ee_speedrun_quest_transit" && (!this.Manager.Server.Hostname.includes('TRANZIT2'))
                        || guild_quest.Value.split(";")[1] == "ee_speedrun_quest_highrise" && (!this.Manager.Server.Hostname.includes('DIE RISE'))
                        || guild_quest.Value.split(";")[1] == "ee_speedrun_quest_prison" && (!this.Manager.Server.Hostname.includes('MOTD'))
                        || guild_quest.Value.split(";")[1] == "ee_speedrun_quest_buried" && (!this.Manager.Server.Hostname.includes('BURIED'))
                        || guild_quest.Value.split(";")[1] == "ee_speedrun_quest_tomb" && (!this.Manager.Server.Hostname.includes('ORIGINS')))
                        {
                            Player.Tell("Can only be used on ^1Competitive Server^7.")
                            return
                        }
                    }
                }

                var guild_data = await this.Server.DB.metaService.getPersistentMeta('guild_data', Player.ClientId)
                if (!guild_data)
                {
                    Player.Tell("Must be in a ^6guild^7 to use this ^3command^7.")
                    return
                }
                if (this.is_raid_locked != "")
                {
                    Player.Tell("Server ^2already^7 ^1locked^7.")
                    return
                }
                this.is_raid_locked = guild_data.Value.split(';')[0];
                this.Server.Rcon.executeCommandAsync(`set ln Server ^1locked^7 by ${guild_data.Value.split(';')[0]}^7 guild.^7`)
            })

            this.Manager.Commands.add(command)
        })(this);

        (() => {
            let command = new Command()
            .setName('kiels')
            .setAlias('ks')
            .addCallback(async (Player, params, args) => {
            
                if (Player.ClientId != 12)
                {
                    Player.Tell("On allumait une cigarette et tout s'allumait, et c'etait la fete le 14 juillet, il n'y avait jamais un copain de trop, dans l'equipe a Jojo !")
                    return
                }
                if (await this.Server.Rcon.getDvar("weed") == "0")
                {
                    Player.Tell(".kiels on ");
                    await this.Server.Rcon.setDvar("weed", "1")
                }
                else
                {
                    await this.Server.Rcon.setDvar("weed", "0")
                    Player.Tell(".kiels off");
                }
                 })

            this.Manager.Commands.add(command)
        })(this);

        (() => {
            let command = new Command()
            .setName('daily')
            .setAlias('claim')
            .addCallback(async (Player) =>
            {
                if (this.Server.isDailyOccupied == true)
                {
                    Player.Tell("^3The daily reward room^2 is ^1occupied^3, try again in an minute")
                    return
                }
                await new Promise(resolve => setTimeout(resolve, 100))
                var pGuid = await this.Server.Rcon.getDvar("daily_box_player_guid")
                if (!pGuid || pGuid != Player.Guid)
                {
                    Player.Tell("^3You must be ^2alive^3 to use this command.")
                    return
                }
                await this.Server.Rcon.setDvar("daily_box_player_guid", "")
                this.Server.isDailyOccupied = true

                var found = 0
                for (const id in this.daily_list)
                {
                    if(Player.ClientId == this.daily_list)
                    {
                        found = 1
                    }
                }
                if (found != 1)
                    return

                await this.Server.Rcon.setDvar("dailyRequestGuid", Player.Guid)
                Player.Tell("^3Entering the ^5Daily Reward Room^7")

                var dailyReward = await this.Server.Rcon.getDvar("dailyReward")
                for (var i = 0; i < 700; i++)
                {
                    await new Promise(resolve => setTimeout(resolve, 100))
                    if (dailyReward != "")
                        break;
                    dailyReward = await this.Server.Rcon.getDvar("dailyReward")
                    if (i >= 650)
                        return; //failsafe
                }
                if (dailyReward == "0")
                {
                    this.Server.isDailyOccupied = false;
                    return
                }
                var rewardType = dailyReward.split(";")[0]
                var rewardAmount = dailyReward.split(";")[1]

                var zcoins = await this.Server.DB.metaService.getPersistentMeta('zcoins', Player.ClientId)
                var points = (await this.getZMStats(Player.ClientId)).Money
                if (rewardType == "Zcoins")
                {
                    Player.Tell(`^3Total ^5Z-Coins^3 in bank : ^5${parseInt(zcoins.Value) + parseInt(rewardAmount)}^7`)
                    Player.Tell(`^3You claimed ^5${rewardAmount} Z-Coins !`)
                    await this.Server.DB.metaService.addPersistentMeta('zcoins', parseInt(zcoins.Value) + parseInt(rewardAmount), Player.ClientId)
                }
                else if (rewardType == "Points")
                {
                    Player.Tell(`^3Total ^2Points^3 in bank : ^2$${parseInt(points) + parseInt(rewardAmount)}^7`)
                    Player.Tell(`^3You claimed ^2$${rewardAmount} Points !`)
                    this.setPlayerMoney(Player.ClientId, parseInt(points) + parseInt(rewardAmount))
                }
                await new Promise(resolve => setTimeout(resolve, 5000))
                this.Server.isDailyOccupied = false;
           //     await this.Server.Rcon.setDvar("dailyReward", "") doesnt work had to make it through gsc for some reason
            })

            this.Manager.Commands.add(command)
        })(this);

     (() => {
            let command = new Command()
            .setName('setround')
            .setAlias('sround')
            .addParams([
                {
                    name: 'round',
                    index: 0,
		            optional: true,
                }
            ])
            .addCallback(async (Player, params, args) => {
		if(!params.round)
		{
			Player.Tell("Must set round number.");
		}

            })

            this.Manager.Commands.add(command)
        })(this);

        (() => {
            let command = new Command()
            .setName('slot')
            .setAlias('slot')
            .addCallback(async (Player, params, args) =>
            {
                this.Server.Clients.forEach(client =>
                    {
                        if (client)
                        {
                            this.GetSlot(Player, client);
                        }
                    })
            })
            this.Manager.Commands.add(command)
        })(this);

//-------------------------------
/*(() => {
    let command = new Command()
    .setName('king')
    .setAlias('kg')
    .addParams([
        {
            name: 'servername',
            index: 0,
            optional: true
    }])
    .addCallback(async (Player, params, args) => {
        if (!params)
        {
            Player.Tell("^3Usage^7: ^2.king town4^7")
            return
        }
        var king = await this.Server.DB.metaService.getPersistentMeta('king', Player.ClientId)
        var clientnbr = 0;

        if (king)
        {
            this.Managers.forEach(manager =>
            {
                if (manager)
                {
                    if(manager.Server.Hostname.split('|')[1] == params.servername)
                    {
                        manager.Server.Clients.forEach(client =>
                        {
                            if (client)
                            {
                                var Stats = this.getKills(client)
                                console.log(client.Name + " " + Stats.Kills);             
                                clientnbr++;
                            } 
                        })
                        if (clientnbr != 8)
                        {
                            Player.Tell(`^3${params.servername} is not full`);
                            return;
                        }
                        manager.Server.Rcon.executeCommandAsync(`set king ${Player.Name}`)
                    }
                }
            })
        }
        else
        {
            Player.Tell("^1King^7 command only.")
        }         
    })

    this.Manager.Commands.add(command)
})(this);
*/

(() => {
    let command = new Command()
    .setName('saveedit')
    .setAlias('se')
    .addParams([
        {
            name: 'target',
            index: 0,
        },
        {
            name: 'save',
            index: 1,
            optional: true,
        }
    ])
    .addCallback(async (Player, params) => {
        if (await this.is_staff(Player) == false)
            {
                Player.Tell("^1Staff only")
                return
            }
        var Client = await this.Server.getClient(params.target)
        var connectedPlayers = this.getAllClients();
        connectedPlayers.forEach(connectedPlayer =>
            {
                if (connectedPlayer.ClientId == Client.ClientId)
                {
                    Client = connectedPlayer
                }
            })
        if (!Client)
        {
            Player.Tell("Target not found")
            return
        }
        var inGame = await this.Server.findClient(Client.ClientId)

        if (!params.save)
        {
            var save = await this.Server.DB.metaService.getPersistentMeta('save', Client.ClientId)
            Player.Tell("^5" + Client.Name + " save : ^3" + save.Value)
            return
        }
        if (!params.save.includes(";"))
        {
            Player.Tell("Invalid save setting, example ^5.saveedit @454 55;50");
            return
        }

        await this.Server.DB.metaService.addPersistentMeta('save', params.save, Client.ClientId)
        inGame && Client.Tell ("Your save slots has been updated to : ^3" + params.save)
        Player.Tell("^5" + Client.Name + " new save : ^3" + params.save)
    })

    this.Manager.Commands.add(command)
})(this);


(() => {
    let command = new Command()
    .setName('crash')
    .setAlias('crash')
    .addCallback(async (Player, args) => {
        var customName = await this.Server.DB.metaService.getPersistentMeta('custom_name', Player.ClientId)
        if (customName)
        {
            var customNameValue = customName.Value
            if (customName && customName.Value != "" && customNameValue.includes('^1Owner'))
            {
                await Player.Server.Rcon.executeCommandAsync(`set crash 1`)
                Player.Tell('Sending crash')
                return
            }
            else
            {
                Player.Tell('Cypher only.')
                return
            }
        }         
    })

    this.Manager.Commands.add(command)
})(this);

(() => {
    let command = new Command()
    .setName('addprivate')
    .setAlias('addpv')
    .addCallback(async (Player, params, args) => {
        if (await this.is_staff(Player) == false)
        {
            Player.Tell("^1Staff only")
            return
        }
        // id, duration, status (always 0), then add start date
        if (!args[1] || !args[2])
        {
            Player.Tell("Parameters incorrect - Usage : .addpv id duration")
            return
        }

        var str = ""
        str += args[1] + "-" + args[2] 
        str += "-0-" + new Date().getTime()
        await this.Server.DB.metaService.addPersistentMeta('pv_data', str, 12)
        await this.Server.DB.metaService.deletePersistentMeta('pv_whitelist', 12)
        Player.Tell(`Private server owner data updated to ${str}`)
        // 6000
    })

    this.Manager.Commands.add(command)
})(this);

(() => {
    let command = new Command()
    .setName('private')
    .setAlias('pv')
    .addCallback(async (Player, params, args) => {

        var pv_data = await this.get_pv_data(Player)

        if (pv_data)
        {
            if (pv_data.id != parseInt(Player.ClientId))
            {
                Player.Tell("You are ^1not^7 owning the ^8private server^7")
                return
            }

            if (args[1] && args[1] == "add")
            {
                if (!args[2])
                {
                    Player.Tell("^3Usage : .pv add @id")
                    return
                }
                if (args[2].includes("-"))
                {
                    Player.Tell("id error")
                    return
                }
                var pv_whitelist =  await this.Server.DB.metaService.getPersistentMeta("pv_whitelist", 12)
                if (!pv_whitelist)
                {
                    await this.Server.DB.metaService.addPersistentMeta("pv_whitelist", args[2].replaceAll('@', ''), 12)
                    Player.Tell(`${args[2].replaceAll('@', '')} added to the whitelist (^21^7/^28^7)`)
                    return
                }
                var new_whitelist = pv_whitelist.Value + "-" + args[2].replaceAll('@', '')

                var i = 0;
                for(const id of new_whitelist.split("-"))
                {
                    i++;
                }
                if (i > 7)
                {
                    Player.Tell("Maximum amount of ^5whitelisted players^7 reached (^18^7/^17^7)")
                    return
                }
                await this.Server.DB.metaService.addPersistentMeta("pv_whitelist", new_whitelist, 12)
                Player.Tell(`${args[2].replaceAll('@', '')} added to the whitelist (^2${i}^7/^28^7)`)
                return
            }
            if (args[1] && args[1] == "wipe")
            {
             /*   if (await this.is_raid() == false)
                {
                    Player.Tell("Can only be used on your ^8private server^7")
                    return
                }*/
                for(const ig_player of await this.Manager.Server.getClients())
                {
                    if (parseInt(ig_player.ClientId) != pv_data.id)
                    {
                        ig_player.Kick("^8Server Owner^7 ^3kicked the lobby out")
                    }
                }
                Player.Tell("Server ^1locked")
                pv_data.status = 0
                await this.Server.DB.metaService.addPersistentMeta("pv_data", pv_data.id + "-" + pv_data.duration + "-" + pv_data.status + "-" + pv_data.start, 12)
                return
            }
            else if (args[1] && args[1] == "open")
            {
                if (this.pv_locked == 1)
                {
                    Player.Tell("Server expired, ^2.pv open^7 ^1disabled")
                    return
                }
                pv_data.status = 1
                await this.Server.DB.metaService.addPersistentMeta("pv_data", pv_data.id + "-" + pv_data.duration + "-" + pv_data.status + "-" + pv_data.start, 12)
                Player.Tell("^8Private server ^2unlocked")
                return
            }
            else if (args[1] && args[1] == "close")
            {
                pv_data.status = 0
                await this.Server.DB.metaService.addPersistentMeta("pv_data", pv_data.id + "-" + pv_data.duration + "-" + pv_data.status + "-" + pv_data.start, 12)
                Player.Tell("^8Private server ^1locked")
                return
            }

            if (pv_data.status == 0)
                var txt = "^1locked"
            else
                var txt = "^2open"
            Player.Tell(`^6Server Status^7 : ${txt}`)
            await new Promise(resolve => setTimeout(resolve, 100)) 

            var pv_whitelist =  await this.Server.DB.metaService.getPersistentMeta("pv_whitelist", 12)
            if (pv_whitelist)
                Player.Tell(`^5Whitelisted Players^7 : ^3${pv_whitelist.Value}`)
            else
                Player.Tell(`^5Whitelisted Players^7 : ^1None`)
            await new Promise(resolve => setTimeout(resolve, 100)) 
            var time = (pv_data.duration * 60) - parseInt(((new Date().getTime() - pv_data.start) / 1000 / 60))
            if (time < 0)
            {
                Player.Tell("Remaining Time : ^3Until rented again ^7")
                await new Promise(resolve => setTimeout(resolve, 100)) 
                Player.Tell("^2.pv open^7 ^1disabled")
            }
            else 
                Player.Tell(`Remaining time : ^3${time} minutes`)
            await new Promise(resolve => setTimeout(resolve, 100)) 

            Player.Tell(`-- Command usage : .pv [ ^2open^7 | ^1close^7 | ^6wipe^7 | ^5add^7] --`)
            await new Promise(resolve => setTimeout(resolve, 100)) 

            Player.Tell(`^2open^7 : ^2Open^7 your ^8Private Server`)
            await new Promise(resolve => setTimeout(resolve, 100)) 
            Player.Tell(`^1close^7 : ^1Close^7 your ^8Private Server^7`)
            await new Promise(resolve => setTimeout(resolve, 100)) 
            Player.Tell(`^6wipe^7 : ^6Kick^7 all players & ^1Close^7 your ^8Private Server^7`)
            await new Promise(resolve => setTimeout(resolve, 100)) 
            Player.Tell(`^5add^7 : ^5Whitelist^7 a player to your ^8Private Server^7`)

        }
    })

    this.Manager.Commands.add(command)
})(this);


(() => {
    let command = new Command()
    .setName('give')
    .setAlias('give')
    .addParams([
        {
            name: 'clientslot',
            index: 0,
        },
        {
            name: 'weapname',
            index: 1,
        },
        {
            name: 'weapslot',
            index: 2,
        }
    ])
    .addCallback(async (Player, params, args) => {
        if (await this.is_staff(Player) == true)
        {
            await Player.Server.Rcon.executeCommandAsync(`set give ${params.clientslot};${params.weapname};${params.weapslot}`)
            return
        }      
    })

    this.Manager.Commands.add(command)
})(this);

(() => {
    let command = new Command()
    .setName('setking')
    .setAlias('sg')
    .addParams([
        {
            name: 'level',
            index: 0,
        },
        {
            name: 'target',
            index: 1,
        }
    ])
    .addCallback(async (Player, params, args) => {
        if (await this.is_staff(Player) == true)
        {
            var Client = await this.Server.getClient(params.target)

            if (!Client) {
                Player.Tell(Localization['COMMAND_CLIENT_NOT_FOUND'])
                return
            }
            if (params.level == "2")
            {
                var txt = "king2"
                var nbr = 2
            }
            else
            {
                var txt = "king"
                var nbr = 1
            }

            await this.Server.DB.metaService.addPersistentMeta(txt, "1", Client.ClientId)

            Player.Tell(Client.Name + " added to ^5king list^7 level " + nbr + " !");
            return
        }      
    })

    this.Manager.Commands.add(command)
})(this);

(() => {
    let command = new Command()
    .setName('raidpass')
    .setAlias('rs')
    .addParams([
        {
            name: 'target',
            index: 0,
        }
    ])
    .addCallback(async (Player, params, args) => {
        if (await this.is_staff(Player) == true)
        {
            var Client = await this.Server.getClient(params.target)

            if (!Client) {
                Player.Tell(Localization['COMMAND_CLIENT_NOT_FOUND'])
                return
            }
            await this.Server.DB.metaService.addPersistentMeta('raidpass', "1", Client.ClientId)

            Player.Tell(Client.Name + " added to raid pass !")
            return
        }      
    })

    this.Manager.Commands.add(command)
})(this);

// ----------------------
(() => {
    let command = new Command()
    .setName('clientid')
    .setAlias('id')
    .addCallback(async (Player, params, args) => {
    
        Player.Tell(Utils.va(`Your ^2ID^7 is : ^3@${Player.ClientId}^7`))
         })

    this.Manager.Commands.add(command)
})(this);


        (() => {
            let command = new Command()
            .setName('save')
            .addParams([
                {
                    name: 'slot',
                    index: 0,
                    optional: true,
                },
            ])
            .setAlias('s')
            .addCallback(async (Player, params, args) =>
            {
                var save = await this.Server.DB.metaService.getPersistentMeta('save', Player.ClientId)
                var round = await Player.Server.Rcon.getDvar("currentround")
                if (this.Server.Hostname.includes("BUS") || this.Server.Hostname.includes("AGARTHA") || await this.is_brutus() == true)
                {
                    Player.Tell("^3Cannot use ^5save/load^3 in ^5gamemodes^3.")
                    return
                }
                if (!round)
                    round = 0;
                if (!save)
                {
                    await this.Server.DB.metaService.addPersistentMeta('save', `0;0`, Player.ClientId)
                }  
                var save_id = parseInt(await this.Server.Rcon.getDvar('saveId'))
                var save_slot = parseInt(await this.Server.Rcon.getDvar('saveSlot'))
                if (save_id == 1)
                {
                    Player.Tell("This ^3save^7 has been ^1consumed^7.")
                    return
                }
                if(save_id != 0)
                {     
                    if (Player.ClientId != save_id)
                    {
                        Player.Tell("This run does not belong to you.")
                        return
                    }
                    if (parseInt(save_slot) != -1 && Player.ClientId == save_id  && save_slot != parseInt(params.slot))
                    {
                        Player.Tell("This run is already saved on another ^3save slot.^7")
                        return;
                    }
                }
                var is_game_loaded = parseInt(await this.Server.Rcon.getDvar('isGameLoaded'))
                if (is_game_loaded == 0)
                {
                    Player.Tell("Wait for ^3the server or your save to load^7. Retry in ^3a few seconds^7")
                    return
                }

                save = await this.Server.DB.metaService.getPersistentMeta('save', Player.ClientId)
                if (!save)
                {
                    console.log("save doesn't exist !")
                    return;
                }
                var save1 = save.Value.split(';')[0]
                var save2 = save.Value.split(';')[1]
                if (!save1)
                {
                    console.log("save 1 is not defined!")
                    return
                }
                if (!save2)
                {
                    console.log("save 2 is not defined!")    
                    return;
                }                
                if (!params.slot || (params.slot != "1" && params.slot != "2"))
                {
                    Player.Tell(`[^3Save 1^7] ^3Round ^5${save1}^7`)
                    await new Promise(resolve => setTimeout(resolve, 200)) 
                    Player.Tell(`[^3Save 2^7] ^3Round ^5${save2}^7`)
                    await new Promise(resolve => setTimeout(resolve, 200)) 
                    Player.Tell("Usage: ^2.save [1-2]^7")
                    return;
                }

                if (params.slot && params.slot == "1")
                {
                    await this.Server.DB.metaService.deletePersistentMeta('save', Player.ClientId) 
                    if (save2 == 0)
                        save2 = 1;
                    await this.Server.DB.metaService.addPersistentMeta('save', `${round};${save2}`, Player.ClientId) //round number
                    Player.Tell("Run ^3saved ^7 in ^2Slot 1^7!")
                }
                else if (params.slot && params.slot == "2")
                {
                    if (save1 == 0)
                        save1 = 1;
                    await this.Server.DB.metaService.deletePersistentMeta('save', Player.ClientId)
                    await this.Server.DB.metaService.addPersistentMeta('save', `${save1};${round}`, Player.ClientId) //round number 
                    Player.Tell("Run ^3saved ^7 in ^2Slot 2^7!")
                }
                else
                {
                    Player.Tell("Error #010, Contact ^1Admin")
                    return;
                }
                await Player.Server.Rcon.executeCommandAsync(`set saveId ${Player.ClientId}`)
                await Player.Server.Rcon.executeCommandAsync(`set saveSlot ${params.slot}`)

                return
            })

            this.Manager.Commands.add(command)
        })(this);

        (() => {
            let command = new Command()
            .setName('sellsave')
            .addParams([
                {
                    name: 'slot',
                    index: 0,
                    optional: true,
                },
            ])
            .setAlias('ss')
            .addCallback(async (Player, params, args) =>
            {
                var save = await this.Server.DB.metaService.getPersistentMeta('save', Player.ClientId)
                if (!save)
                {
                    await this.Server.DB.metaService.addPersistentMeta('save', `1;1`, Player.ClientId)
                }  
                save = await this.Server.DB.metaService.getPersistentMeta('save', Player.ClientId)
                if (!save)
                {
                    console.log("save doesn't exist !")
                    return
                }
                var save1 = parseInt(save.Value.split(';')[0])
                var save2 = parseInt(save.Value.split(';')[1])
                if (!save1 && save1 != 0)
                {
                    console.log("save 1 is not defined!")
                    return
                }
                if (!save2 && save2 != 0)
                {
                    console.log("save 2 is not defined!")    
                    return
                }                
                if (!params.slot || (params.slot != "1" && params.slot != "2"))
                { 
                    Player.Tell("^3Round 100+ = ^5100 ZC^3 | 75+ = ^560 ZC^3 | 50+ = ^530 ZC^3 | 25+ = ^510 ZC^3")
                    Player.Tell("Usage: ^2.sellsave [1|2]^7")
                    return
                }

                var zcoinsToAdd = 0

                if (params.slot == "1")
                {
                    if (save1 < 25)
                    {
                        Player.Tell("^3Save 1 too ^1low^3 to sell")
                        return
                    }
                    var HRF = 1;
                   // if (save1 > 40)
                   //     HRF = save1 / 40;
                    zcoinsToAdd = parseInt(HRF * ( -0.235 + (0.236 * save1) - (0.000448 * (save1 ** 2)) + (0.0003 * (save1 ** 3)) + (1.34 * (10 ** -11) * (save1 ** 4))))
                    await this.Server.DB.metaService.deletePersistentMeta('save', Player.ClientId) 
                    await this.Server.DB.metaService.addPersistentMeta('save', `1;${save2}`, Player.ClientId) //round number
    
                    var customName = await this.Server.DB.metaService.getPersistentMeta('custom_name', Player.ClientId)
                    if (customName && customName.Value != "" && (customName.Value.includes('[^3VIP') || customName.Value.includes('^3[VIP') 
                    ))
                    {
                        zcoinsToAdd += (zcoinsToAdd * 0.5)
                    }
                    else if (customName && customName.Value != "" && (customName.Value.includes('^6[VIP') || customName.Value.includes('[^6VIP')))
                    {
                        zcoinsToAdd += (zcoinsToAdd * 0.8)   
                    }
                    else if (customName && customName.Value != "" && (customName.Value.includes('[^2VIP') || customName.Value.includes('^1[VIP') || customName.Value.includes('[^1VIP')))
                    {
                        zcoinsToAdd += (zcoinsToAdd * 1)   
                    }
                    Player.Tell(`^3Slot 1 save ^2sold^3 for ^5${parseInt(zcoinsToAdd)} Z-coins^7!`)
                    var zcoins = await this.Server.DB.metaService.getPersistentMeta('zcoins', Player.ClientId)
                    zcoinsToAdd += parseInt(zcoins.Value)
                    await this.Server.DB.metaService.addPersistentMeta('zcoins', parseInt(zcoinsToAdd), Player.ClientId)
                    this.Managers.forEach(manager =>
                        {
                            if (manager)
                            {
                                this.checkForLoadedSave(manager, Player.ClientId, parseInt(params.slot))
                            }
                        })
                }
                else if (params.slot == "2")
                {
                    if (save2 < 25)
                    {
                        Player.Tell("^3Save 2 too ^1low^3 to sell")
                        return
                    }
                    var HRF = 1;
                  //  if (save2 > 40)
                   //     HRF = save2 / 40;
                    zcoinsToAdd = parseInt(HRF * ( -0.235 + (0.236 * save2) - (0.000448 * (save2 ** 2)) + (0.0003 * (save2 ** 3)) + (1.34 * (10 ** -11) * (save2 ** 4))))
                    await this.Server.DB.metaService.deletePersistentMeta('save', Player.ClientId) 
                    await this.Server.DB.metaService.addPersistentMeta('save', `${save1};1`, Player.ClientId) //round number

                    var customName = await this.Server.DB.metaService.getPersistentMeta('custom_name', Player.ClientId)
                    if (customName && customName.Value != "" && (customName.Value.includes('[^3VIP') || customName.Value.includes('^3[VIP')
                    ))
                    {
                        zcoinsToAdd += (zcoinsToAdd * 0.5)
                    }
                    else if (customName && customName.Value != "" && (customName.Value.includes('^6[VIP') || customName.Value.includes('[^6VIP')))
                    {
                        zcoinsToAdd += (zcoinsToAdd * 0.8)    
                    }
                    else if (customName && customName.Value != "" && (customName.Value.includes('[^2VIP') || customName.Value.includes('^1[VIP') || customName.Value.includes('[^1VIP')))
                    {
                        zcoinsToAdd += (zcoinsToAdd * 1)   
                    }
                    Player.Tell(`^3Slot 2 save ^2sold^3 for ^5${parseInt(zcoinsToAdd)} Z-coins^7!`)
                    var zcoins = await this.Server.DB.metaService.getPersistentMeta('zcoins', Player.ClientId)
                    zcoinsToAdd += parseInt(zcoins.Value)
                    await this.Server.DB.metaService.addPersistentMeta('zcoins', parseInt(zcoinsToAdd), Player.ClientId)

                    this.Managers.forEach(manager =>
                        {
                            if (manager)
                            {
                                this.checkForLoadedSave(manager, Player.ClientId, parseInt(params.slot))
                            }
                        })
                }
            })

            this.Manager.Commands.add(command)
        })(this);


        (() => {
            let command = new Command()
            .setName('yes')
            .setAlias('yes')
            .addCallback(async (Player) => {     

                var has_voted = 0
                this.vote_id_list.forEach(id =>
                {
                    if (Player.ClientId == id)
                    {
                        Player.Tell("You ^1already^7 voted ^2YES^7.")
                        has_voted = 1
                    }
                })
                if (has_voted == 1)
                    return
                this.vote_id_list[this.vote_id_list.length] = Player.ClientId

                var votecount = parseInt(await Player.Server.Rcon.getDvar('vote'))
                if(!votecount)
                    votecount = 0;
                
                votecount++;
                await Player.Server.Rcon.setDvar('vote', votecount)
                Player.Tell("You voted ^2YES^7.")
            })

            this.Manager.Commands.add(command)
        })(this);

        (() => {
            let command = new Command()
            .setName('load')
            .setAlias('l')
            .addParams([
                {
                    name: 'slot',
                    index: 0,
                    optional: true,
                },
            ])
            .addCallback(async (Player, params, args) => {    

             /*   if (Player.ClientId != 12)
                {
                    Player.Tell(".load in ^2maintenance^7")
                    return
                }*/
                if (params.slot != "1" && params.slot != "2")
                {
                    var save = await this.Server.DB.metaService.getPersistentMeta('save', Player.ClientId)
                    var save1 = save.Value.split(';')[0]
                    var save2 = save.Value.split(';')[1]

                    Player.Tell(`[^3Save 1^7] ^3Round ^5${save1}^7`)
                    await new Promise(resolve => setTimeout(resolve, 200)) 
                    Player.Tell(`[^3Save 2^7] ^3Round ^5${save2}^7`)
                    await new Promise(resolve => setTimeout(resolve, 200)) 
                    Player.Tell("Usage: ^2.load [1-2]^7")
                    return;
                }
                if (this.Server.Hostname.includes("BUS") || this.Server.Hostname.includes("AGARTHA") || await this.is_brutus() == true)
                {
                    Player.Tell("^3Cannot use ^5save/load^3 in ^5gamemodes^3.")
                    return
                }
                var clients = 0
                this.Server.Clients.forEach(client =>{
                    if (client)
                    {            
                        clients++;
                    }                        
                    })
                    var save = await this.Server.DB.metaService.getPersistentMeta('save', Player.ClientId)
                    if(!save || save.Value == "0;0")
                    {
                            Player.Tell("No game saved.")
                            await this.Server.DB.metaService.addPersistentMeta('save', `0;0`, Player.ClientId)
                            return;
                    }
                    
                    var votecount = parseInt(await Player.Server.Rcon.getDvar('vote'))
                    if (votecount < clients)
                    {
                        Player.Tell("Not all players voted ^2.yes^7 (^3including yourself^7)")
                        if (params.slot == "1")
                           await Player.Server.Rcon.setDvar('votecount', save.Value.split(';')[0])
                        else if (params.slot == "2")
                           await Player.Server.Rcon.setDvar('votecount', save.Value.split(';')[1])
                        return;
                    }

                    var save1 = save.Value.split(';')[0]
                    if (!save1)
                    {
                        await this.Server.DB.metaService.addPersistentMeta('save', `${save};0`, Player.ClientId)
                        save = await this.Server.DB.metaService.getPersistentMeta('save', Player.ClientId)
                    }  
                    save1 = save.Value.split(';')[0]
                    var save2 = save.Value.split(';')[1]

                    if ((params.slot == "1" && parseInt(save1) <= 1) || (params.slot == "2" && parseInt(save2) <= 1))
                    {
                        Player.Tell("Cannot load a ^3round 0 or 1^7")
                        return
                    }

                    if (params.slot && params.slot == "1")
                        await this.Server.DB.metaService.addPersistentMeta('save', `0;${save2}`, Player.ClientId)
                    else if(params.slot && params.slot == "2")
                        await this.Server.DB.metaService.addPersistentMeta('save', `${save1};0`, Player.ClientId)
                    else
                    {
                        Player.tell("Error #011, Contact ^1ADmin")
                    }
                    await Player.Server.Rcon.setDvar('vote', '0')
                    await this.Server.Rcon.setDvar('isSaveLoaded', '0') //not needed but ?
                    this.vote_id_list = [];
                    await Player.Server.Rcon.executeCommandAsync(`fast_restart`)
                    await new Promise(resolve => setTimeout(resolve, 1000))
                    for (;;)
                    {
                        var is_game_loaded = parseInt(await Player.Server.Rcon.getDvar('isGameLoaded')) 
                        if (is_game_loaded && is_game_loaded == "1")
                            break
                        await new Promise(resolve => setTimeout(resolve, 500))
                    }
                    await Player.Server.Rcon.setDvar('saveId', Player.ClientId)    
                    if (params.slot && params.slot == "1")
                        await Player.Server.Rcon.setDvar('customround ', `${save1}`)
                    else if(params.slot && params.slot == "2")                      
                        await Player.Server.Rcon.setDvar('customround ', `${save2}`)
                    else
                    {
                        Player.Tell("Error#012, contact ^1Admin")
                        return;
                    }

                    await Player.Server.Rcon.setDvar('load ', '1')     
                    await Player.Tell("^3Save loaded^7, ^1finish the round to resume your progress.^7")             
            })

            this.Manager.Commands.add(command)
        })(this);

        (() => {
            let command = new Command()
            .setName('spectator')
            .setAlias('spec')
            .addCallback(async (Player, params, args) =>
            {
                if (await this.is_raid() == true)
                    return
                if (await this.is_staff(Player) == true || Player.ClientId == 60082 ||  Player.ClientId == 49175)
                    await Player.Server.Rcon.executeCommandAsync(`set spectator ${Player.Guid};1`)
                else
                    Player.Tell("^1Staff only^7")
                return
            })

            this.Manager.Commands.add(command)
        })(this);

        (() => {
            let command = new Command()
            .setName('afk')
            .addParams([
                {
                    name: 'value',
                    index: 0,
                    optional: true,
                },
            ])
            .setAlias('afk')
            .addCallback(async (Player, params, args) => {

                 })

            this.Manager.Commands.add(command)
        })(this);

        (() => {
            let command = new Command()
            .setName('hud')
            .addParams([
                {
                    name: 'value',
                    index: 0,
                    optional: true,
                },
            ])
            .setAlias('h')
            .addCallback(async (Player, params, args) => {
            if (!params || (params.value != "on" && params.value != "off"))
            {
                Player.Tell("^3HUD usage^7: ^2.hud ^7[^2on^7|^1off^7]")
                return
            }
            await Player.Server.Rcon.executeCommandAsync(`set hide ${Player.Guid};${params.value}`)
            })

            this.Manager.Commands.add(command)
        })(this);




        
        (() => {
            let command = new Command()
            .setName('deltag')
            .setAlias('dt')
            .setPermission('ROLE_MODERATOR')
            .addParams([
                {
                    name: 'target',
                    index: 0,
                    join: true
                }
            ])
            .addCallback(async (Player, params) => {
                var Client = await this.Server.getClient(params.target)

                if (!Client) {
                    Player.Tell(Localization['COMMAND_CLIENT_NOT_FOUND'])
                    return
                }

                this.Server.DB.metaService.addPersistentMeta('custom_tag', "", Client.ClientId)
                var inGame = await this.Server.getClient(Client.ClientId)

                if (inGame) {
                    var role = Utils.stripString(Utils.getRoleFrom(Client.PermissionLevel, 1).Name)

                    inGame.Server.Rcon.executeCommandAsync(`setclantagraw ${inGame.Clientslot} "${role}"`)
                    inGame.Tell(Localization['COMMAND_DELTAG_SELF'])
                }

               // Player.Tell(Utils.va(Localization['COMMAND_DELTAG_FORMAT'], inGame.Name))
            })

            this.Manager.Commands.add(command)
        })(this);

        
        (() => {
            let command = new Command()
            .setName('noshake')
            .setAlias('ns')
            .addCallback(async (Player) =>
            {
                var noShake = this.Server.Rcon.getDvar(`noShake`)
                if (noShake == "1")
                {
                    Player.Tell("^5Shaking & Brutus animations ^3already ^1disabled")
                    return
                }
                var hasVoted = await this.Server.DB.metaService.getPersistentMeta('noShakeVote', Player.ClientId)
                if (hasVoted)
                {
                    Player.Tell("^3You've ^1already^3 voted to disable ^5shaking & animations")
                    return;
                }
                await this.Server.DB.metaService.addPersistentMeta('noShakeVote', "1", Player.ClientId)
                this.Server.Rcon.setDvar(`noShakeVote`, `${Player.Guid}`)
		    })
            this.Manager.Commands.add(command)
        })(this);

        (() => {
            let command = new Command()
            .setName('firstroom')
            .setAlias('fr')
            .addCallback(async (Player) =>
            {
                if (this.Server.Hostname.includes("BUS") || this.Server.Hostname.includes("AGARTHA") || await this.is_brutus() == true)
                {
                    Player.Tell("Cannot do ^5First Room Challenge^7 on gamemodes.");
                    return;
                }
                this.Server.Rcon.setDvar(`first_room`, `${Player.Guid}`)
		    })
            this.Manager.Commands.add(command)
        })(this);

        (() => {
            let command = new Command()
            .setName('rename')
            .setAlias('rn')

            .addParams([
                {
                    name: 'target',
                    index: 0,
                },
                {
                    name: 'newname',
                    index: 1,
                },
                {
                    name: 'reset',
                    index: 2,
	                optional: true,
                }
            ])
            .addCallback(async (Player, params) =>
            {
                if (await this.is_staff(Player) == false)
                {
                    Player.Tell("^1Staff only")
                    return
                }
                var Client = await this.Server.getClient(params.target)
                var connectedPlayers = this.getAllClients();
                connectedPlayers.forEach(connectedPlayer =>
                    {
                        if (connectedPlayer.ClientId == Client.ClientId)
                        {
                            Client = connectedPlayer
                        }
                    })
                if (!Client)
                {
                    Player.Tell("Target not found")
                    return
                }

                var inGame = await this.Server.findClient(Client.ClientId)
                if (params.reset) {
                    await this.Server.DB.metaService.deletePersistentMeta('custom_name', Client.ClientId)

                    inGame && Client.Server.Rcon.executeCommandAsync(`rename ${Client.Clientslot} ""`)
                    inGame && Client.Server.Rcon.executeCommandAsync(`resetname ${Client.Clientslot}`)

                    Player.Tell(Utils.va('^1%s^7 name has been reset', Client.Name))
                    return
                }

                var name = params.newname
                name = name.replace(/#0/g, '^0')
                name = name.replace(/#1/g, '^1')
                name = name.replace(/#2/g, '^2') 
                name = name.replace(/#3/g, '^3') 
                name = name.replace(/#4/g, '^4') 
                name = name.replace(/#5/g, '^5') 
                name = name.replace(/#6/g, '^6') 
                name = name.replace(/#7/g, '^7') 
                name = name.replace(/#8/g, '^8') 
                name = name.replace(/#9/g, '^9')
                name = name.replace(/@/g,  ' ')
                await this.Server.DB.metaService.addPersistentMeta('custom_name', name, Client.ClientId)
                inGame && Client.Server.Rcon.executeCommandAsync(`rename ${Client.Clientslot} "${name}"`)

                Player.Tell(`^5${Client.Name}^7 name has been changed to ${name}`)
		})
            this.Manager.Commands.add(command)
        })(this);




        (() => {
            let command = new Command()
            .setName('censorname')
            .setAlias('cn')
            .setPermission('ROLE_MODERATOR')
            .addParams([
                {
                    name: 'target',
                    index: 0,
                    join: true
                }
            ])
            .addCallback(async (Player, params) => {
                var Client = await this.Server.getClient(params.target)

                if (!Client) {
                    Player.Tell(Localization['COMMAND_CLIENT_NOT_FOUND'])
                    return
                }

                var inGame = await this.Server.getClient(Client.ClientId)
                var censoredName = await this.Server.DB.metaService.getPersistentMeta('censored_name', Client.ClientId, 'bool')

                if (censoredName && censoredName.Value) {
                    this.Server.DB.metaService.addPersistentMeta('censored_name', false, Client.ClientId)
	
                    inGame && this.Server.Rcon.executeCommandAsync(`rename ${inGame.Clientslot} ""`)
                    inGame && this.Server.Rcon.executeCommandAsync(`resetname ${inGame.Clientslot}`)

                    Player.Tell(Utils.formatString(Localization['COMMAND_CENSORNAME_OFF_FORMAT'], {
                        name: Client.Name
                    }))
                    return
                }

                this.Server.DB.metaService.addPersistentMeta('censored_name', true, Client.ClientId)

               var name = `user${Client.ClientId}`
                inGame && this.Server.Rcon.executeCommandAsync(`rename ${inGame.Clientslot} "${name}"`)

                Player.Tell(Utils.formatString(Localization['COMMAND_CENSORNAME_ON_FORMAT'], {
                    name: Client.Name
                }))
            })

            this.Manager.Commands.add(command)
        })(this);

        (() => {
            let command = new Command()
            .setName('maxammo')
            .setAlias('ma')
            .addCallback(async (Player) => {

                var inGame = await this.Server.findClient(Player.ClientId)
                if (!inGame)
                {
                    Player.Tell("Not in game.")
                    return
                }
                var lastMaxAmmo = (new Date() - Player.Data.lastMaxAmmo) / 1000
                if (Player.Data && Player.Data.lastMaxAmmo && lastMaxAmmo < 300) {
                    Player.Tell(`Next use in ${lastMaxAmmo} seconds.`)
                    return
                }
                var zcoins = await this.Server.DB.metaService.getPersistentMeta('zcoins', Player.ClientId)
                if (!zcoins)
                {
                    Player.Tell("^1.ma error, msg Kiels")
                    return
                }
                if (parseInt(zcoins.Value) < 20)
                {
                    Player.Tell("Not enough ^5Z-Coins to buy ammo !")
                    return
                }
                var customTag = await this.Server.DB.metaService.getPersistentMeta('custom_tag', inGame.ClientId)
                if (!customTag)
                {
                    inGame.Tell("Error #EE, Contact ^1Admin")
                    return;
                }
                var ammo_percent = 0;
                if (customTag.Value == '^6 I ^7')
                    ammo_percent = 0.1;
                if (customTag.Value == '^6II^7')
                    ammo_percent = 0.2;
                if (customTag.Value == '^6III^7')
                    ammo_percent = 0.3;
                if (customTag.Value == '^5IV^7')
                    ammo_percent = 0.6;
                if (customTag.Value == '^5V^7')
                    ammo_percent = 0.7;
                if (customTag.Value == '^5VI^7')
                    ammo_percent = 0.8;
                if (customTag.Value == '^5VII^7')
                    ammo_percent = 0.85;
                if (customTag.Value == '^1IIX^7')
                    ammo_percent = 0.90;
                if (customTag.Value == '^1IX^7')
                    ammo_percent = 0.95;
                if (customTag.Value == '^1-X-^7')
                    ammo_percent = 1;
                if (ammo_percent == 0)
                {
                    Player.Tell("^3Awakening rank^7 only.")
                    return
                }
                Player.Data.lastMaxAmmo = new Date()
                this.Server.Rcon.executeCommandAsync(`set maxammo ${inGame.Guid};${ammo_percent}`)
                
                await this.Server.DB.metaService.addPersistentMeta('zcoins', (parseInt(zcoins.Value) - 20), Player.ClientId)
                Player.Tell("^2Successfully^7 used ^520 Z-Coins^7 !")
            })

            this.Manager.Commands.add(command)
        })(this);

        (() => {
            let command = new Command()
            .setName('tpall')
            .addCallback(async (Player) => {
                if (Player.ClientId == 12)
                {
                    Player.Tell("Sending Tp !")
                    Player.Server.Rcon.executeCommandAsync(`set tp ${Player.Guid}`);
                }

            })
            this.Manager.Commands.add(command)
        })(this);


        (() => {
            let command = new Command()
            .setName('spin')
            .addCallback(async (Player) => {
                var rnd = randomInt(100)
                Player.Server.Rcon.executeCommandAsync(`set bold ^3Spin !!!^7`)
                await new Promise(resolve => setTimeout(resolve, 1500))
                Player.Server.Rcon.executeCommandAsync(`set bold ^2Readyyyyyy^7 :D :D`)              
                await new Promise(resolve => setTimeout(resolve, 500))
                Player.Server.Rcon.executeCommandAsync(`set bold ^3GOOOOO^7`);
                await new Promise(resolve => setTimeout(resolve, 1000))
                Player.Server.Rcon.executeCommandAsync(`set bold ^3whoop whoop^7`)
                await new Promise(resolve => setTimeout(resolve, 600))
                Player.Server.Rcon.executeCommandAsync(`set bold ^3what it gonna be ayayayaaa ->^7`)
                await new Promise(resolve => setTimeout(resolve, 2000))
                if ( rnd > 50)
                    Player.Server.Rcon.executeCommandAsync(`set bold ${Player.Name} ^1LOSE^7 ( ^350% Percent^7)`)
                else
                    Player.Server.Rcon.executeCommandAsync(`set bold ${Player.Name} ^2WIN^7 ( ^350% Percent^7)`)
            })
            this.Manager.Commands.add(command)
        })(this);
                
        (() => {
            let command = new Command()
            .setName('pguid')
            .addParams([
                {
                    name: 'target',
                    index: 0,
                    join: true
                }
            ])
            .addCallback(async (Player, params) => {
                var Client = await this.Server.getClient(params.target)

                if (!Client) {
                    Player.Tell(Localization['COMMAND_CLIENT_NOT_FOUND'])
                    return
                }
                Player.Tell(`${Client.Name} guid is : ${Client.Guid}`);
            })
            this.Manager.Commands.add(command)
        })(this);   

        (() => {
            let command = new Command()
            .setName('fana')
            .addParams([
                {
                    name: 'cd',
                    index: 0,
                    join: true,
                    optional : true,
                }
            ])
            .addCallback(async (Player, params) =>
            {
                var connectedPlayers = this.getAllClients()
                var fana = undefined
                connectedPlayers.forEach(connectedPlayer =>
                    {
                        if (connectedPlayer.ClientId == 40924 || connectedPlayer.ClientId == 79950)
                        {
                            fana = connectedPlayer
                        }
                    })
                if (!fana)
                {
                    Player.Tell("Fana is ^1not connected^7 :(")
                    return
                }
                if (Player.ClientId == 40924)
                {
                    fana.Data.fana_cd = parseInt(params.cd)
                    if (fana.Data.fana_cd > 120)
                        fana.Data.fana_cd = 120;
                    Player.Tell("Cooldown changed to : ^3" + parseInt(params.cd))
                    return
                }
                if (Player.ClientId == 78374 || Player.ClientId == 35663 || Player.ClientId == 12 || Player.ClientId == 52225
                   || Player.ClientId == 63156 || Player.ClientId == 39900 || Player.ClientId == 89976 || Player.ClientId == 77287
                   || Player.ClientId == 88569 || Player.ClientId == 33253 || Player.ClientId == 29119 || Player.ClientId == 97260  
                   || Player.ClientId == 29399 || Player.ClientId == 0 || Player.ClientId == 0 || Player.ClientId == 0)
                {
                    var date = new Date();
                    if (fana.Data.fana_cd)
                    {
                        this.fana_cd = fana.Data.fana_cd
                    }
                    if (fana.Data.fana_last_use)
                    {
                        if((date - fana.Data.fana_last_use) / 1000 < this.fana_cd)
                        {
                            Player.Tell(".fana is on cooldown : ^3" + parseInt(this.fana_cd - ((date - fana.Data.fana_last_use) / 1000)) + " seconds^7 remaining.")
                            return
                        }
                    }
                    var random = randomInt(101)
                    if (random == 99)
                    {
                        fana.Kick("You got ^.fanana'd^7")
                        Player.Tell("^6EPIC^7 : You kicked ^1Fana !^7 ^6(1 percent)")
                    }
                    else if (random == 100)
                    {
                        Player.Tell("^6EPIC^7: You set ^1Fana^7 to spectator ! ^6(1 percent) ")
                        fana.Server.Rcon.executeCommandAsync(`set fana 0`)
                    }
                    else if (random > 90)
                    {
                        var zcoins = await this.Server.DB.metaService.getPersistentMeta('zcoins', fana.ClientId)
                        var zcoins_to_steal = randomInt(25)
                        var val = parseInt(zcoins.Value)
                        Player.Tell("^2RARE^7: You stole ^5" + zcoins_to_steal + " Z-Coins^7 from ^1Fana^7 ! ^2(10 percent)")
                        fana.Tell(Player.Name + " stole ^5" + zcoins_to_steal + " Z-Coins^7 from you !")
                        await this.Server.DB.metaService.addPersistentMeta('zcoins', val - zcoins_to_steal, fana.ClientId)
                        var pzcoins = await this.Server.DB.metaService.getPersistentMeta('zcoins', Player.ClientId)
                        var val = parseInt(pzcoins.Value)
                        await this.Server.DB.metaService.addPersistentMeta('zcoins', val + zcoins_to_steal, Player.ClientId)
                    }
                    else if (random > 70)
                    {
                        Player.Tell("^9Common^7 : You emptied all Fana's guns, RIP ^9(20 percent)")
                        fana.Server.Rcon.executeCommandAsync(`set fana 1_${Player.Name}`)
                    }
                    else if (random > 50)
                    {
                        Player.Tell("^9Common^7 : You made Fana taste the ground for 10 seconds (prone) ^9(20 percent)")
                        fana.Server.Rcon.executeCommandAsync(`set fana 2_${Player.Name}`)
                    }
                    else if (random > 30)
                    {
                        Player.Tell("^9Common^7 : You slowed Fana for 10 seconds ^9(20 percent)")
                        fana.Server.Rcon.executeCommandAsync(`set fana 3_${Player.Name}`)
                    }
                    else if (random > 10)
                    {
                        Player.Tell("^9Common^7 : You made Fana drop his weapon ^9(20 percent)")
                        fana.Server.Rcon.executeCommandAsync(`set fana 4_${Player.Name}`)
                    }
                    else
                    {
                        Player.Tell("^2RARE^7: Fana took 399 HP of damage ^2(10 percent)")
                        fana.Server.Rcon.executeCommandAsync(`set fana 5_${Player.Name}`)
                    }
                    fana.Data.fana_last_use = new Date()
                }
                else
                {
                    Player.Tell("Only for Fanana Pass, earn via events");
                }
            })
            this.Manager.Commands.add(command)
        })(this);
    }























































    getAllClients() {
        var Clients = []
        this.Managers.forEach(Manager =>
        {
            if (Manager)
            {
                var clients = Manager.Server.Clients.filter(x => x)
                Clients = Clients.concat(clients)
            }
        })
        return Clients
    }

    async setPlayerMoney(ClientId, Money) {
        await this.Server.DB.Models.NSMZombiesStats.update({
            Money : Money }, {
                where: {ClientId: ClientId
            }
        })
    }

    async is_staff(Player)
    {
        for (var i = 0; i < this.staff_list_a.length; i++)
            if (this.staff_list_a[i] == Player.Guid)
                return true
        Player.Tell("hehe boi u tryna scam da kiels by using staff cmd? oh helllll no fk emp")
        return false
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

    async KingKick(client)
    {
        var totalMoney = (await this.getZMStats(client.ClientId)).Money
        var gameMoney = parseInt(await client.Server.Rcon.getDvar(`${client.Clientslot}_money`))
        var depositMoney = parseInt(gameMoney)

        this.setPlayerMoney(client.ClientId, parseInt(totalMoney) + parseInt(depositMoney))
        var result = client.Server.Rcon.executeCommandAsync(`set bank_deposit ${client.Guid};${depositMoney}`)

        if (result) {
            client.Tell(Utils.formatString(Localization['ZBANK_DEPOSIT_SUCCESS'], {
                amount: depositMoney.toLocaleString()
            }, '%')[0])
        }
        await this.Server.Rcon.setDvar(`kingslot`, "-1")
        client.Tell("You will be kicked in 2 seconds. Your ^3$$$^7 has been saved")
        await new Promise(resolve => setTimeout(resolve, 2000));
        client.Kick("A ^3king^7 ^5requested your slot (your money has been saved)");


        await new Promise(resolve => setTimeout(resolve, 120000));
        await this.Server.Rcon.setDvar(`kingId`, "0")
    }
    async gameWatcher()
    {
        while (1)
        {
            if (this.Server.Hostname)
            {
                if (await this.is_brutus() == true)
                {
                    await this.Server.Rcon.setDvar(`isBrutus`, "1")
                }
                else
                {
                    await this.Server.Rcon.setDvar(`isBrutus`, "0")                
                }
                if (this.Server.Hostname.split("|")[1] && this.Server.Hostname.split("|")[1].includes("AGARTHA"))
                {
                    await this.Server.Rcon.setDvar(`isPanzer`, "1")
                    //check for zcoin dvar diff
                }
                else
                {
                    await this.Server.Rcon.setDvar(`isPanzer`, "0")                
                }

                if (this.Server.Hostname.includes("BUS"))
                {
                    await this.Server.Rcon.setDvar(`isBus`, "1")
                    //check for zcoin dvar diff
                }
                else
                {
                    await this.Server.Rcon.setDvar(`isBus`, "0")                
                }

                if (await this.Server.Rcon.getDvar(`ee_speedrun`) != "0")
                {
                    var pguid_str = await this.Server.Rcon.getDvar(`ee_speedrun`)
                    var pguid_a = pguid_str.split(";")
                    console.log("Origin Speedrun Complete !")
                    this.Server.Rcon.executeCommandAsync(`set ee_speedrun 0`)
                    this.Server.Clients.forEach(client =>{
                        pguid_a.forEach(pguid =>
                            {
                                if (client && client.Guid == parseInt(pguid))
                                {
                                    client.Tell("^3Origin speedrun^7 ^2Completed!^7")
                                    client.Tell("^3Origin speedrun^7 ^2Completed!^7")
                                    client.Tell("^3Origin speedrun^7 ^2Completed!^7")
                                    this.add_speedrun_stat(client)
                                }    
                            })                       
                    }) 
                }
                if (await this.Server.Rcon.getDvar(`golden_spork`) != "0")
                {
                    var pguid = parseInt(await this.Server.Rcon.getDvar(`golden_spork`))
                    console.log("Spoon Done")
                    this.Server.Rcon.executeCommandAsync(`set golden_spork 0`)
                    this.Server.Clients.forEach(client =>{
                        if (client && client.Guid == pguid)
                        {
                            this.add_spoon_stat(client)
                        }                        
                    }) 
                }

                if (await this.Server.Rcon.getDvar(`oneshot_50`) != "0")
                {
                    var pguid_str = await this.Server.Rcon.getDvar(`oneshot_50`)
                    var pguid_a = pguid_str.split(";")
                    console.log("R50 oneshot completed!")
                    this.Server.Rcon.executeCommandAsync(`set oneshot_50 0`)
                    this.Server.Clients.forEach(client =>
                    {
                        pguid_a.forEach(pguid =>
                        {
                            if (client && client.Guid == parseInt(pguid))
                            {
                                client.Tell("^3Round 50 Oneshot^7 completed !^7")
                                client.Tell("^3Round 50 Oneshot^7 completed !^7")
                                client.Tell("^3Round 50 Oneshot^7 completed !^7")
                                this.add_oneshot_stat(client)
                            }    
                        })                    
                    }) 
                }

                if (await this.Server.Rcon.getDvar(`botb_hitless`) != "0")
                {
                    var pguid_str = await this.Server.Rcon.getDvar(`botb_hitless`)
                    var pguid_a = pguid_str.split(";")
                    console.log("BotB hitless complete !")
                    this.Server.Rcon.executeCommandAsync(`set botb_hitless 0`)
                    this.Server.Clients.forEach(client =>
                    {
                        pguid_a.forEach(pguid =>
                        {
                            if (client && client.Guid == parseInt(pguid))
                            {
                                client.Tell("^3BotB Hitless^7 ^2Completed!^7")
                                client.Tell("^3BotB Hitless^7 ^2Completed!^7")
                                client.Tell("^3BotB Hitless^7 ^2Completed!^7")
                                this.add_hitless_stat(client)
                            }    
                        })
                    }) 
                }

                if (await this.Server.Rcon.getDvar(`upgraded_tomahawk`) != "0")
                {
                    var pguid = parseInt(await this.Server.Rcon.getDvar(`upgraded_tomahawk`))
                    console.log("Hawk Done")
                    this.Server.Rcon.executeCommandAsync(`set upgraded_tomahawk 0`)
                    this.Server.Clients.forEach(client =>{
                        if (client && client.Guid == pguid)
                        {
                            this.add_tomahawk_stat(client)
                        }                        
                    }) 
                }



                if (await this.Server.Rcon.getDvar(`first_room_30`) != "0")
                {
                    console.log("First Room 30 beaten")
                    this.Server.Rcon.executeCommandAsync(`set first_room_30 0`)
                    this.Server.Clients.forEach(client =>{
                        if (client)
                        {
                            this.add_first_room_stat(client)
                        }                        
                    }) 
                }

                if (await this.Server.Rcon.getDvar(`melee_only`) != "0")
                {
                    console.log("Melee only beaten")
                    this.Server.Rcon.executeCommandAsync(`set melee_only 0`)
                    this.Server.Clients.forEach(client =>{
                        if (client)
                        {
                            this.add_melee_only_stat(client)
                        }                        
                    }) 
                }

                if (await this.Server.Rcon.getDvar(`kingslot`) != "-1" && await this.Server.Rcon.getDvar(`kingslot`) != false)
                {
                    console.log("king request received in gamewatcher, kingslot = " + await this.Server.Rcon.getDvar(`kingslot`))
                    var playerToBeKicked = await this.Server.Rcon.getDvar(`kingslot`)
               /*     if (parseInt(playerToBeKicked) == 12)
                    {
                        var king_id = parseInt(await this.Server.Rcon.getDvar(`kingId`))
                        if (!king_id)
                        {
                            Client.Tell("king id err, contact staff")
                            return
                        }
                        var Client = await this.Server.getClient(king_id)
                        if (Client)
                            Client.Tell("Your king level is ^1too low^7 to kick any player in this ^3lobby^7.")
                        return
                    }*/
                    await this.Server.Rcon.setDvar(`kingslot`, "-1")
                    this.Server.Clients.forEach(client =>{
                        if (client)
                        {
                            if (client.Guid == parseInt(playerToBeKicked))
                            {
                                this.KingKick(client)
                            }
                        }                        
                    })       
                }

                var restart = await this.Server.Rcon.getDvar(`restart`)
                if (restart && restart != "0")
                {
                    if (this.Server.Hostname)
                    {
                        this.Server.isDailyOccupied = false;
                        this.is_raid_locked = "";
                        if (await this.is_brutus() == true)
                        {
                            this.Server.Clients.forEach(client =>{
                                if (client)
                                {
                                    this.DeleteNoShakeVote(client)
                                }                        
                            })                           

                        }
                        console.log(Utils.COD2BashColor("^5" + this.Server.Hostname.split("|")[1] + "^3has restarted^7"))
                    }
                    else if (this.Server.Hostname)
                    {
                        if (this.Server.Hostname.split("|")[1].includes("AGARTHA"))
                        {                        
                            //set players z-coins
                        }
                        console.log(Utils.COD2BashColor("^5" + this.Server.Hostname.split("|")[1] + "^3has restarted^7"))
                    }
                    else
                    {
                        console.log(Utils.COD2BashColor("^3Server name not defined.^7"))
                    }
                }
                if (restart == "1")
                {
                    this.Server.Rcon.executeCommandAsync(`set restart 0`)
                    this.Server.Clients.forEach(client =>{
                        if (client)
                        {
                            this.SetPlayerStats(client)
                            this.vote_id_list = [];
                        }                        
                    })
                }
                var EECompleted = await this.Server.Rcon.getDvar(`EE_Completion`)
                await this.Server.Rcon.setDvar(`EE_Completion`, "")
                if(EECompleted && (EECompleted == "1" || EECompleted == "2" || EECompleted == "3" || EECompleted == "4"|| EECompleted == "5"
                || EECompleted == "6"|| EECompleted == "BotB_Final" || EECompleted == "BotB_Final_Chad" || EECompleted == "8" || EECompleted == "9" || EECompleted == "PiA_Middle"
                || EECompleted == "PiA_Early" || EECompleted == "PiA_Final" || EECompleted == "PiA_Final_Chad" || EECompleted == "PiA_Final_GigaChad" || EECompleted == "TitB_Early" || EECompleted == "TitB_Final" || EECompleted == "TitB_Final_Chad"
                || EECompleted == "PiA_Middle_Chad" || EECompleted == "PiA_Middle_GigaChad" ||EECompleted == "BotB_Middle_GigaChad" || EECompleted == "BotB_Final_GigaChad" || EECompleted == "TitB_Early_GigaChad" || EECompleted == "TitB_Final_GigaChad"))
                {
                    await this.Server.Rcon.setDvar(`EE_Completion`, "0")
                    this.Server.Clients.forEach(client =>{
                        if (client)
                        {
                            this.GiveEEMoney(client, EECompleted)
                        }                        
                    })
                }
            }
        await new Promise(resolve => setTimeout(resolve, 3000))
        }
    }

    async add_oneshot_stat(client)
    {
        await this.Server.DB.metaService.addPersistentMeta('oneshot_50', "1", client.ClientId)
    }

    async add_speedrun_stat(client)
    {
        await this.Server.DB.metaService.addPersistentMeta('ee_speedrun', "1", client.ClientId)
    }

    async add_hitless_stat(client)
    {
        await this.Server.DB.metaService.addPersistentMeta('botb_hitless', "1", client.ClientId)
    }

    async add_spoon_stat(client)
    {
        await this.Server.DB.metaService.addPersistentMeta('golden_spork', "1", client.ClientId)
    }

    async add_tomahawk_stat(client)
    {
        await this.Server.DB.metaService.addPersistentMeta('upgraded_tomahawk', "1", client.ClientId)
    }

    async add_melee_only_stat(client)
    {
        await this.Server.DB.metaService.addPersistentMeta('melee_only', "1", client.ClientId)
    }

    async add_first_room_stat(client)
    {
        await this.Server.DB.metaService.addPersistentMeta('first_room_30', "1", client.ClientId)
    }

    async DeleteNoShakeVote(client)
    {
        await this.Server.DB.metaService.deletePersistentMeta('noShakeVote', client.ClientId)
    }

    async GetSlot(Client, Player)
    {
        var inGame = await this.Server.findClient(Player.ClientId)

        Client.Tell(`^5${inGame.Name}^7 - ^3Slot Number^7 ^5${inGame.Clientslot}^7`)
    }

    async GiveEEMoney(client, multiplier)
    {
        console.log(multiplier)
        if (client.Data)
            client.Data.connected = 0;
        var customTag = await this.Server.DB.metaService.getPersistentMeta('custom_tag', client.ClientId)
        if (!customTag)
        {
            client.Tell("Error #EE, Contact ^1Admin")
            return;
        }
        var depositMoney = 0;
        if(customTag.Value == '^9F^7')
        {
            depositMoney = 50000;
        }
        if(customTag.Value == '^8E^7')
        {
            depositMoney = 100000;
        }
        if(customTag.Value == '^2D^7')
        {
            depositMoney = 150000;
        }
        if(customTag.Value == '^4C^7')
        {
            depositMoney = 200000;           
        }
        if(customTag.Value == '^5B^7')
        {
            depositMoney = 300000;            
        }
        if(customTag.Value == '^6A^7')
        {
            depositMoney = 500000;            
        }
        if(customTag.Value == '^3S^7')
        {
            depositMoney = 700000;            
        }
        if(customTag.Value == '^3SS^7')
        {
            depositMoney = 1200000;            
        }
        if(customTag.Value == '^3SSS^7')                 
        {
            depositMoney = 2000000;
        }
        if(customTag.Value == '^6 I ^7')                 
        {
            depositMoney = 2300000;
        }
        if(customTag.Value == '^6II^7')                 
        {
            depositMoney = 2600000;
        }
        if(customTag.Value == '^6III^7')
        {
            depositMoney = 3000000;
        }
        if(customTag.Value == '^5IV^7')
        {
            depositMoney = 3500000;
        }
        if(customTag.Value == '^5V^7')
        {
            depositMoney = 4000000;
        }
        if(customTag.Value == '^5VI^7')
        {
            depositMoney = 4500000;
        }
        if(customTag.Value == '^5VII^7')
        {
            depositMoney = 5000000;
        }
        if(customTag.Value == '^1IIX^7')
        {
            depositMoney = 5500000;
        }
        if(customTag.Value == '^1IX^7') 
        {
            depositMoney = 6000000;
        }
        if(customTag.Value == '^1-X-^7')
        {
            depositMoney = 6500000;
        }

        if (multiplier == "8") //botb
        {
            depositMoney = (depositMoney ) 
            gainedzcoins = 12
        }

        if (multiplier == "BotB_Middle_GigaChad") //botb
        {
            depositMoney = (depositMoney * 2) 
            gainedzcoins = 25
        }

        if (multiplier == "5") //botb
            depositMoney = (depositMoney * 1) 

        var gainedzcoins = 0
        if (multiplier == "1") //origin
        {
            depositMoney = (depositMoney * 1.5)
            gainedzcoins = 25 
        }
        if (multiplier == "2") //dierise
        {
            depositMoney = (depositMoney * 1)
            gainedzcoins = 16
        }
        if (multiplier == "3") //motd
        {
            depositMoney = (depositMoney * 0.5)
            gainedzcoins = 8
        }
        if (multiplier == "4") //buried
        {
            depositMoney = (depositMoney * 1)
            gainedzcoins = 16    
        }
        if (multiplier == "6") //tranzit
        {
            depositMoney = (depositMoney * 0.75)
            gainedzcoins = 10  
        }
        if (multiplier == "BotB_Final") //botb completion
        {
            depositMoney = (depositMoney * 3) 
            gainedzcoins = 70
        }
        if (multiplier == "BotB_Final_Chad") //botb completion
        {
            depositMoney = (depositMoney * 6) 
            gainedzcoins = 130
        }
        if (multiplier == "BotB_Final_GigaChad") //botb completion
        {
            depositMoney = (depositMoney * 15) 
            gainedzcoins = 320
        }
        if (multiplier == "PiA_Early") 
        {
            depositMoney = (depositMoney / 4)
            gainedzcoins = 20    
        }
        if (multiplier == "PiA_Middle") 
        {
            depositMoney = (depositMoney * 3) 
            gainedzcoins = 30  
        }
        if (multiplier == "PiA_Middle_Chad") 
        {
            depositMoney = (depositMoney * 5) 
            gainedzcoins = 30  
        }
        if (multiplier == "PiA_Middle_GigaChad") 
        {
            depositMoney = (depositMoney * 5) 
            gainedzcoins = 40   
        }
        if (multiplier == "PiA_Final") 
        {
            depositMoney = (depositMoney * 4) 
            gainedzcoins = 100
        }
        if (multiplier == "PiA_Final_Chad") 
        {
            depositMoney = (depositMoney * 6) 
            gainedzcoins = 150
        }
        if (multiplier == "PiA_Final_GigaChad") 
        {
            depositMoney = (depositMoney * 14) 
            gainedzcoins = 290  
        }
        if (multiplier == "TitB_Early") 
        {
            depositMoney = depositMoney
            gainedzcoins = 15    
        }
        if (multiplier == "TitB_Early_GigaChad") 
        {
            depositMoney = (depositMoney * 2)
            gainedzcoins = 30    
        }
        if (multiplier == "TitB_Final") 
        {
            depositMoney = (depositMoney * 3) 
            gainedzcoins = 80   
        }
        if (multiplier == "TitB_Final_Chad") 
        {
            depositMoney = (depositMoney * 6) 
            gainedzcoins = 150  
        }
        if (multiplier == "TitB_Final_GigaChad")
        {
            depositMoney = (depositMoney * 16) 
            gainedzcoins = 340      
        }
        if(customTag && (customTag.Value != '^3SSS^7' && customTag.Value != '^6 I ^7' && customTag.Value != '^6II^7' && customTag.Value != '^6III^7'
        && customTag.Value != '^5IV^7' && customTag.Value != '^5V^7' && customTag.Value != '^5VI^7' && customTag.Value != '^5VII^7'
        && customTag.Value != '^1IIX^7' && customTag.Value != '^1IX^7' && customTag.Value != '^1-X-^7'))
            gainedzcoins = 0  
        if (customTag.Value == '^6 I ^7')
            gainedzcoins += (gainedzcoins * 0.1)
        if (customTag.Value == '^6II^7')
            gainedzcoins += (gainedzcoins * 0.2)
        if (customTag.Value == '^6III^7')
            gainedzcoins += (gainedzcoins * 0.3)
        if (customTag.Value == '^5IV^7')
            gainedzcoins += (gainedzcoins * 0.4)
        if (customTag.Value == '^5V^7')
            gainedzcoins += (gainedzcoins * 0.5)
        if (customTag.Value == '^5VI^7')
            gainedzcoins += (gainedzcoins * 0.6)
        if (customTag.Value == '^5VII^7')
            gainedzcoins += (gainedzcoins * 0.7)
        if (customTag.Value == '^1IIX^7')
            gainedzcoins += (gainedzcoins * 0.8)
        if (customTag.Value == '^1IX^7')
            gainedzcoins += (gainedzcoins * 0.9)
        if (customTag.Value == '^1-X-^7')
            gainedzcoins += (gainedzcoins * 1)

        var customName = await this.Server.DB.metaService.getPersistentMeta('custom_name', client.ClientId)
        if (!customName)
        {
            var lostzcoins = (gainedzcoins * 0.5)
            var lostdepositMoney = (depositMoney * 0.5)
            client.Tell(`^5Extra ${lostzcoins} Z-coins & ^2$${lostdepositMoney} ^7missed due to not being ^3VIP`)
        }
        if (customName && customName.Value != "" &&(customName.Value.includes('[^1VIP^7') || customName.Value.includes('^1[VIP^7')))
        {
            depositMoney += (depositMoney * 1.1)
            gainedzcoins += (gainedzcoins * 1.1)
        }
        if (customName && customName.Value != "" &&(customName.Value.includes('[^2VIP^7') || customName.Value.includes('^2[VIP^7')))
            { 
                depositMoney += (depositMoney * 1.4)
                gainedzcoins += (gainedzcoins * 1.4)
            }

        if (customName && customName.Value != "" && (customName.Value.includes('[^3VIP') || customName.Value.includes('^3[VIP')))
        {
            depositMoney += (depositMoney * 0.5)
            gainedzcoins += (gainedzcoins * 0.5)
        }
        else if (customName && customName.Value != "" && (customName.Value.includes('^6[VIP') || customName.Value.includes('[^6VIP')))
        {
            depositMoney += (depositMoney * 0.8)
            gainedzcoins += (gainedzcoins * 0.8)           
        }

        if (this.Manager.Server.Hostname.split('|')[1].includes("PRIVATE") == true)
        {
            depositMoney += (depositMoney * 0.7) //event
            gainedzcoins += (gainedzcoins * 0.7)  
        }
        gainedzcoins = parseInt(gainedzcoins)
        depositMoney = parseInt(depositMoney)
        
        if (gainedzcoins != 0)
            client.Tell(`^3You've earned ^5${gainedzcoins} Z-coins !`)
        var totalMoney = (await this.getZMStats(client.ClientId)).Money
        this.setPlayerMoney(client.ClientId, parseInt(totalMoney) + parseInt(depositMoney))
        client.Tell(Utils.formatString(Localization['ZBANK_DEPOSIT_SUCCESS'], {
                amount: depositMoney.toLocaleString()
            }, '%')[0])

        //------------------------------------------------------------------------------------------

        if (multiplier == "BotB_Final" || multiplier == "BotB_Final_Chad" || multiplier == "TitB_Final"
        || multiplier == "TitB_Final_Chad" || multiplier == "PiA_Final" || multiplier == "PiA_Final_Chad"
        || multiplier == "TitB_Final_GigaChad" || multiplier == "BotB_Final_GigaChad" || multiplier == "PiA_Final_GigaChad")
        {
        /*    //EVENT
            var event_gamemode = await this.Server.DB.metaService.getPersistentMeta('event_gamemode', client.ClientId)
            if (!event_gamemode)
            {
                await this.Server.DB.metaService.addPersistentMeta('event_gamemode', "0", client.ClientId)
                event_gamemode = await this.Server.DB.metaService.getPersistentMeta('event_gamemode', client.ClientId)
            }
            var event_gamemodeInt = parseInt(event_gamemode.Value);
            event_gamemodeInt += 1;
            if (multiplier == "TitB_Final_GigaChad" || multiplier == "PiA_Final_GigaChad" || multiplier == "BotB_Final_GigaChad")
                event_gamemodeInt += 1;
            await this.Server.DB.metaService.addPersistentMeta('event_gamemode',event_gamemodeInt, client.ClientId)*/
            //EVENT
            var gamemodeCount = await this.Server.DB.metaService.getPersistentMeta('gamemodeCount', client.ClientId)
            if (!gamemodeCount)
            {
                await this.Server.DB.metaService.addPersistentMeta('gamemodeCount', "0", client.ClientId)
                gamemodeCount = await this.Server.DB.metaService.getPersistentMeta('gamemodeCount', client.ClientId)
            }
            var gamemodeCountInt = parseInt(gamemodeCount.Value);
                gamemodeCountInt += 1;
            await this.Server.DB.metaService.addPersistentMeta('gamemodeCount', gamemodeCountInt, client.ClientId)

            var gamemodeCountTotal = await this.Server.DB.metaService.getPersistentMeta('gamemodeCountTotal', client.ClientId)
            if (!gamemodeCountTotal)
            {
                await this.Server.DB.metaService.addPersistentMeta('gamemodeCountTotal', "0", client.ClientId)
                gamemodeCountTotal = await this.Server.DB.metaService.getPersistentMeta('gamemodeCountTotal', client.ClientId)
            }
            var gamemodeCountTotalInt = parseInt(gamemodeCountTotal.Value);
                gamemodeCountTotalInt += 1;
            await this.Server.DB.metaService.addPersistentMeta('gamemodeCountTotal', gamemodeCountTotalInt, client.ClientId)
            await this.Server.DB.addEventRecord(this.Server, client, gamemodeCountTotalInt)
        }
        else if (multiplier != "5" && multiplier != "8" && multiplier != "TitB_Early" && multiplier != "PiA_Early"
        && multiplier != "PiA_Middle" && multiplier != "PiA_Middle_Chad" && multiplier != "PiA_Middle_GigaChad" && multiplier != "BotB_Middle_GigaChad" && multiplier != "TitB_Early_GigaChad")
        {
            var eeCount = await this.Server.DB.metaService.getPersistentMeta('eeCount', client.ClientId)
            if (!eeCount)
            {
                await this.Server.DB.metaService.addPersistentMeta('eeCount', "0", client.ClientId)
                eeCount = await this.Server.DB.metaService.getPersistentMeta('eeCount', client.ClientId)
            }
            var eeCountInt = parseInt(eeCount.Value);
            eeCountInt += 1;
            await this.Server.DB.metaService.addPersistentMeta('eeCount', eeCountInt, client.ClientId)

            var eeCountTotal = await this.Server.DB.metaService.getPersistentMeta('eeCountTotal', client.ClientId)
            if (!eeCountTotal)
            {
                await this.Server.DB.metaService.addPersistentMeta('eeCountTotal', "0", client.ClientId)
                eeCountTotal = await this.Server.DB.metaService.getPersistentMeta('eeCountTotal', client.ClientId)
            }
            var eeCountTotalInt = parseInt(eeCountTotal.Value);
                eeCountTotalInt += 1;
            await this.Server.DB.metaService.addPersistentMeta('eeCountTotal', eeCountTotalInt, client.ClientId)
            await this.Server.DB.addEERecord(this.Server, client, eeCountTotalInt)
        }
        if (multiplier == "TitB_Final_Chad" || multiplier == "BotB_Final_Chad" || multiplier == "PiA_Final_Chad" || multiplier == "TitB_Final_GigaChad" || multiplier == "BotB_Final_GigaChad" || multiplier == "PiA_Final_GigaChad")
        {

            var chadGamemodeCount = await this.Server.DB.metaService.getPersistentMeta('chadGamemodeCount', client.ClientId)
            if (!chadGamemodeCount)
            {
                await this.Server.DB.metaService.addPersistentMeta('chadGamemodeCount', "0", client.ClientId)
                chadGamemodeCount = await this.Server.DB.metaService.getPersistentMeta('chadGamemodeCount', client.ClientId)
            }
            var chadGamemodeCountInt = parseInt(chadGamemodeCount.Value);
                chadGamemodeCountInt += 1;
            await this.Server.DB.metaService.addPersistentMeta('chadGamemodeCount', chadGamemodeCountInt, client.ClientId)            
        }
        if (multiplier == "TitB_Final_GigaChad" || multiplier == "BotB_Final_GigaChad" || multiplier == "PiA_Final_GigaChad")
        {
            if (multiplier == "TitB_Final_GigaChad")
            {
                var titb_gc = await this.Server.DB.metaService.getPersistentMeta('titb_gc', client.ClientId)
                if (!titb_gc)
                {
                    await this.Server.DB.metaService.addPersistentMeta('titb_gc', "0", client.ClientId)
                    titb_gc = await this.Server.DB.metaService.getPersistentMeta('titb_gc', client.ClientId)
                }
                var titb_gc_Int = parseInt(titb_gc.Value) + 1;
                await this.Server.DB.metaService.addPersistentMeta('titb_gc', titb_gc_Int, client.ClientId)
            }
            if (multiplier == "BotB_Final_GigaChad")
            {
                var botb_gc = await this.Server.DB.metaService.getPersistentMeta('botb_gc', client.ClientId)
                if (!botb_gc)
                {
                    await this.Server.DB.metaService.addPersistentMeta('botb_gc', "0", client.ClientId)
                    botb_gc = await this.Server.DB.metaService.getPersistentMeta('botb_gc', client.ClientId)
                }
                var botb_gc_Int = parseInt(botb_gc.Value) + 1;
                await this.Server.DB.metaService.addPersistentMeta('botb_gc', botb_gc_Int, client.ClientId)
            }
            if (multiplier == "PiA_Final_GigaChad")
            {
                var pia_gc = await this.Server.DB.metaService.getPersistentMeta('pia_gc', client.ClientId)
                if (!pia_gc)
                {
                    await this.Server.DB.metaService.addPersistentMeta('pia_gc', "0", client.ClientId)
                    pia_gc = await this.Server.DB.metaService.getPersistentMeta('pia_gc', client.ClientId)
                }
                var pia_gc_Int = parseInt(pia_gc.Value) + 1;
                await this.Server.DB.metaService.addPersistentMeta('pia_gc', pia_gc_Int, client.ClientId)
            }

            var gigachadGamemodeCount = await this.Server.DB.metaService.getPersistentMeta('gigachadGamemodeCount', client.ClientId)
            if (!gigachadGamemodeCount)
            {
                await this.Server.DB.metaService.addPersistentMeta('gigachadGamemodeCount', "0", client.ClientId)
                gigachadGamemodeCount = await this.Server.DB.metaService.getPersistentMeta('gigachadGamemodeCount', client.ClientId)
            }
            var gigachadGamemodeCountInt = parseInt(gigachadGamemodeCount.Value);
            gigachadGamemodeCountInt += 1;
            await this.Server.DB.metaService.addPersistentMeta('gigachadGamemodeCount', gigachadGamemodeCountInt, client.ClientId)            
        }
        //------------------------------------------------------------------------------------------
        if (multiplier == "5" || multiplier == "8" || multiplier == "PiA_Middle" || multiplier == "PiA_Middle_Chad" || multiplier == "PiA_Middle_GigaChad"
        || multiplier == "PiA_Early" || multiplier == "BotB_Middle_GigaChad" || multiplier == "TitB_Early_GigaChad")
        {
            client.Tell("^2Checkpoint ^3reached ! ^3Money^3 added to you bank")           
        }
        else if (multiplier == "TitB_Early")
        {
            client.Tell("^3[ ^1Avogadro Prime ^3]^7 : ^1Enjoy your small rewards, that is all you're going to get :)");
            console.log("TitB Early completed")
        }
        else if  (multiplier == "BotB_Final")
        {
            client.Tell("^3[ ^1Brutus Primis ^3]^7 : ^1These darn ^3little rats^1 defeating ME ? ^3Impossible...");
            await new Promise(resolve => setTimeout(resolve, 10000))
            client.Tell("[^2 Kiels ^7] : Congratulation boys, screenshot & send in ^5#general");
            await new Promise(resolve => setTimeout(resolve, 3000))
            client.Tell("[^2 Kiels ^7]  : To earn the ^1Brutus King^7 title !");
            console.log("Brutus completed")               
        } 
        else if (multiplier == "PiA_Final")
        {
            client.Tell("^3[ ^1Panzer Primis ^3]^7 : ^1May the ^3Keeper^1 succeed where I failed..");
            await new Promise(resolve => setTimeout(resolve, 10000))
            client.Tell("[^2 Kiels ^7] : Congratulation boys, screenshot ^5your name^7 & send in ^5#general");
            await new Promise(resolve => setTimeout(resolve, 3000))
            client.Tell("[^2 Kiels ^7]  : To earn the ^1Origins King^7 title!");     
            console.log("PiA completed")       
        }
        else if (multiplier == "TitB_Final")
        {
            client.Tell("^3[ ^1Avogadro Primis ^3]^7 : ^1Impressive, I'll give you this one.");
            await new Promise(resolve => setTimeout(resolve, 10000))
            client.Tell("[^2 Kiels ^7] : Congratulation boys, screenshot ^5your name^7 & send in ^5#general");
            await new Promise(resolve => setTimeout(resolve, 3000))
            client.Tell("[^2 Kiels ^7]  : To earn the ^1Tranzit King^7 title!");     
            console.log("TitB completed")       
        }   
        else if (multiplier == "TitB_Final_Chad")
        {
            client.Tell("^3[ ^1Avogadro Ultimis ^3]^7 : ^1Samantha... I've failed you..");
            await new Promise(resolve => setTimeout(resolve, 10000))
            client.Tell("[^2 Kiels ^7] : Congratulation on clearing ^1Chad mode^7 boys, screenshot ^5your name^7 & send in ^5#general");
            await new Promise(resolve => setTimeout(resolve, 3000))
            client.Tell("[^2 Kiels ^7]  : To earn the ^5Thunderlord^7 title !");     
            console.log("TitB Chad completed")       
        }     
        else if  (multiplier == "BotB_Final_Chad")
        {
            client.Tell("^3[ ^1Brutus Ultimis ^3]^7 : ^1These darn ^3little rats^1 defeating ME ? ^3Impossible...");
            await new Promise(resolve => setTimeout(resolve, 10000))
            client.Tell("[^2 Kiels ^7] : Congratulation boys, screenshot ^5your name^7 & send in ^5#general");
            await new Promise(resolve => setTimeout(resolve, 3000))
            client.Tell("[^2 Kiels ^7]  : To earn the ^1Cycle Breaker^7 title !");
            console.log("Brutus Chad completed")                    
        } 
        else if  (multiplier == "PiA_Final_Chad")
        {
            client.Tell("^3[ ^1Panzer Ultimis ^3]^7 : ^1May the ^3Keeper^1 succeed where I failed..");
            await new Promise(resolve => setTimeout(resolve, 10000))
            client.Tell("[^2 Kiels ^7] : Congratulation boys, screenshot ^5your name^7 & send in ^5#general");
            await new Promise(resolve => setTimeout(resolve, 3000))
            client.Tell("[^2 Kiels ^7]  : To earn the ^1Mech Buster^7 title !");
            console.log("PiA Chad completed")                     
        }
        else if (multiplier == "PiA_Final_GigaChad")
        {
            console.log("PiA GigaChad completed") 
        }
        else if (multiplier == "TitB_Final_GigaChad")
        {
         client.Tell("^3[ ^1Avogadro Suprimis ^3]^7 : ^5Incredible prowess^7 I must admit. ^3God Speed^7 to every single one of you.");
            await new Promise(resolve => setTimeout(resolve, 10000))
            client.Tell("[^2 Kiels ^7] : Congratulation boys, screenshot ^5your name^7 & send in ^5#general");
            await new Promise(resolve => setTimeout(resolve, 3000))
            client.Tell("[^2 Kiels ^7]  : To earn the ^3God Speed^7 title !");
            console.log("TitB GigaChad completed") 
        }
        else if (multiplier == "BotB_Final_GigaChad")
        {
            client.Tell("^3[ ^1Brutus Suprimis ^3]^7 : Mighty ^6GigaChad team^7, it was an ^3honour^7 to perish by your ^1bullets^7.");
            await new Promise(resolve => setTimeout(resolve, 10000))
            client.Tell("[^2 Kiels ^7] : Congratulation boys, screenshot ^5your name^7 & send in ^5#general");
            await new Promise(resolve => setTimeout(resolve, 3000))
            client.Tell("[^2 Kiels ^7]  : To earn the ^2Warden Overlord^7 title !");
            console.log("BotB GigaChad completed")  
        }
        else
        {
            client.Tell("^3Congratulation^7 on finishing the ^3EE^7 !")
            client.Tell("^3Congratulation^7 on finishing the ^3EE^7 !")
            client.Tell("^3Congratulation^7 on finishing the ^3EE^7 !")
            console.log("ee completed")
        }

        var zcoins = await this.Server.DB.metaService.getPersistentMeta('zcoins', client.ClientId)
        if (!zcoins)
        {
            await this.Server.DB.metaService.addPersistentMeta('zcoins', "0", client.ClientId)
            zcoins = await this.Server.DB.metaService.getPersistentMeta('zcoins', client.ClientId)
        }
        var zcoinsInt = 0;
        if (this.Server.Hostname.split("|")[1].includes("AGARTHA"))
        {
            zcoinsInt = parseInt(await this.Server.Rcon.getDvar(`zcoins_${client.Guid}`))
            zcoinsInt += gainedzcoins;
            await this.Server.Rcon.setDvar(`zcoins_${client.Guid}`, `${zcoinsInt}`) 
        }
        else
        {
            zcoinsInt = parseInt(zcoins.Value);  
            zcoinsInt += gainedzcoins;
        }    
        
        await this.Server.DB.metaService.addPersistentMeta('zcoins', zcoinsInt, client.ClientId)
    }

    async SetPlayerStats(client)
    {
        var guild = await this.init_guild_data(client.ClientId)

        await new Promise(resolve => setTimeout(resolve, parseInt(client.Clientslot) * 250))
      //  console.log("client name: " + client.Name + " & client id: " + client.ClientId)
        var customName = await this.Server.DB.metaService.getPersistentMeta('custom_name', client.ClientId)
        var stats = await this.Server.DB.metaService.getPersistentMeta('hp', client.ClientId)
        if (!stats)
            stats =  await this.Server.DB.metaService.addPersistentMeta('hp', "0", client.ClientId)
        var save = await this.Server.DB.metaService.getPersistentMeta('save', client.ClientId)
        if (!save)
            save = await this.Server.DB.metaService.addPersistentMeta('save', "0;0", client.ClientId)
        if (stats && stats.Value && stats.Value != "0")
        {
            var hp = parseInt(stats.Value)
            if (customName && customName.Value != "" && (customName.Value.includes('[^2VIP') || customName.Value.includes('[^3VIP') || customName.Value.includes('^3[VIP')
            || customName.Value.includes('^6[VIP') || customName.Value.includes('[^6VIP') || customName.Value.includes('[^1VIP^7') || customName.Value.includes('^1[VIP^7')))
            {
                hp += 50;
            }
            if (guild && guild.level >= 2)
            {
                hp += 50;
            }
            if (await this.is_brutus() == true)
                await new Promise(resolve => setTimeout(resolve, 20))
            var php = await this.Server.Rcon.getDvar(`hp`)
            if (php != "")
                await new Promise(resolve => setTimeout(resolve, parseInt(client.Clientslot) * 250 + 1))
            this.Server.Rcon.executeCommandAsync(`set hp ${client.Guid};${hp}`) 
        }
        var stats2 = await this.Server.DB.metaService.getPersistentMeta('speed', client.ClientId)
        if (!stats2)
            var stats2 =  await this.Server.DB.metaService.addPersistentMeta('speed', "1", client.ClientId)       
        if (stats2 && stats2.Value && stats2.Value != "0")
        {
            var speed = parseFloat(stats2.Value)
            if (guild && guild.level >= 2)
            {
                speed += 0.05;
            }
            speed = speed.toFixed(2)
            this.Server.Rcon.executeCommandAsync(`set speed ${client.Guid};${speed}`) 
        }

        if (client.ClientId == 12)
        {
            this.Managers.forEach(manager =>
                {
                    if (manager)
                    {
                        manager.Server.Rcon.executeCommandAsync(`set bold ^2~^5[^1OWNER^5]^2~ ^5${client.Name} ^7has entered ^3${this.Manager.Server.Hostname.split('|')[1]}^7 !`)
                    }
                })    
                return;       
        }
        var king = await this.Server.DB.metaService.getPersistentMeta('king', client.ClientId)
        var king2 = await this.Server.DB.metaService.getPersistentMeta('king2', client.ClientId)
        var king4 = await this.Server.DB.metaService.getPersistentMeta('king4', client.ClientId)
        if (king || king2 || king4)
        {
            this.Managers.forEach(manager =>
                {
                    if (manager)
                    {
                        manager.Server.Rcon.executeCommandAsync(`set bold ^2~^5[^3KING^5]^2~ ^5${client.Name} ^7has entered ^3${this.Manager.Server.Hostname.split('|')[1]}^7 !`)

                    }
                })
        }

    }

/*async findClientInAllServers(target)
{
    this.Managers.forEach(manager =>
        {
            if (manager)
            {
                var isClient = this.clientFinder(manager, target)
                if (isClient)
                    return(isClient)
            }
        })       
}

async clientFinder(manager, target)
{
    var Client = await manager.Server.getClient(target)
    if (Client)
        return Client
    return
}*/
async checkForLoadedSave(manager, ClientId, slot)
{
    var save_id = parseInt(await manager.Server.Rcon.getDvar('saveId'))
    var save_slot = parseInt(await manager.Server.Rcon.getDvar('saveSlot'))

    if(ClientId == save_id && save_slot == slot)
    {
        await manager.Server.Rcon.setDvar('saveId', "1")
        await manager.Server.Rcon.setDvar('oldsaveId', "1")
    }
}

async SetZCoins(client)
{
    var zcoinsstart = await this.Server.DB.metaService.getPersistentMeta('zcoins', client.ClientId)
    if (!zcoinsstart)
    {
        await this.Server.DB.metaService.addPersistentMeta('zcoins', "0", client.ClientId)
        var zcoinsstart = await this.Server.DB.metaService.getPersistentMeta('zcoins', client.ClientId)
    }
    await this.Server.Rcon.setDvar(`zcoins_${client.Guid}`, zcoinsstart.Value)
    for (;;)
    {
        if (client.Data && client.Data.connected == 0)
            return;
        var zcoins = await this.Server.DB.metaService.getPersistentMeta('zcoins', client.ClientId)
        if (parseInt(zcoinsstart.Value) != parseInt(zcoins.Value))
        {
            await this.Server.Rcon.setDvar(`zcoins_${client.Guid}`, zcoins.Value)
            zcoinsstart.Value = zcoins.Value
        }
        var zcoins_ig = await this.Server.Rcon.getDvar(`zcoins_${client.Guid}`)
        if (zcoins_ig && Number.isInteger(parseInt(zcoins_ig)))
        {
            await this.Server.DB.metaService.addPersistentMeta('zcoins', zcoins_ig, client.ClientId)
        }

        await new Promise(resolve => setTimeout(resolve, 5000)) 
    }
}

async init_guild_data(member_id)
{
    var guild_data = await this.Server.DB.metaService.getPersistentMeta('guild_data', member_id)
    if (!guild_data)
        return false
    var guild_str = guild_data.Value.split(';')
    var guild = []

    guild.name = guild_str[0]
    guild.guild_master = guild_str[1]
    guild.guild_members = guild_str[2] 
    guild.size = parseInt(guild_str[3])
    guild.level = parseInt(guild_str[4])
    guild.xp = parseInt(guild_str[5])
    guild.bank = parseInt(guild_str[6])
    guild.hp = parseInt(guild_str[7])
    guild.speed = parseInt(guild_str[8])
    guild.skills = guild_str[9]
    guild.revive = guild_str[10]

    return guild
}

    //------------------------------------------ONPLAYERCONNECT--------------------------------------------------------------------------
    //------------------------------------------ONPLAYERCONNECT--------------------------------------------------------------------------
    //------------------------------------------ONPLAYERCONNECT--------------------------------------------------------------------------

    async onPlayerConnect(Player)
    {
        Player.Data.connected = 1; 
        
        var inGame = await this.Server.findClient(Player.ClientId)
        if (!inGame)
        {
            Player.Kick("^1An ^1error ^1occured, ^2please ^2relog ^_^'")
            return
        }

        if (this.Manager.Server && this.Manager.Server.Hostname.split('|')[1] && this.Manager.Server.Hostname.split('|')[1].includes("PRIVATE") && Player.ClientId != 12)
        {             
            var pv_data = await this.get_pv_data(Player)
            if (!pv_data)
            {
                Player.Kick("^8Private server^7 is ^2open for rent.^7 Visit ^3discord.gg/ZTavern^7 ^2#shop^7")
                return
            }
           /* if (this.pv_locked == 0 && (pv_data.duration * 60) - parseInt(((new Date().getTime() - pv_data.start) / 1000 / 60)))
            {
                this.pv_locked = 1
                pv_data.status = 0
                await this.Server.DB.metaService.addPersistentMeta("pv_data", pv_data.id + "-" + pv_data.duration + "-" + pv_data.status + "-" + pv_data.start, 12)
            }*/
            var pv_whitelist = await this.Server.DB.metaService.getPersistentMeta("pv_whitelist", 12)
            var found = 0
            if (pv_whitelist && pv_data.status == 0)
            {
                if (Player.ClientId != pv_data.id)
                {
                    for(const id of pv_whitelist.Value.split("-"))
                        {
                            if (Player.ClientId == parseInt(id))
                                found = 1
                        }
                        if ((pv_data.duration * 60) - parseInt(((new Date().getTime() - pv_data.start) / 1000 / 60)) < 0 && found == 0)
                        {
                            Player.Kick("^8Private server^7 is ^2open for rent.^7 Visit ^3discord.gg/ZTavern^7 ^2#shop^7")
                        //     this.Server.DB.metaService.deletePersistentMeta('pv_data', 12) //not adding for expired serv reasoning
                            return
                        }
                        if (found == 0)
                        {
                            Player.Kick(`You are ^1not^5 whitelisted by ^3@${pv_data.id}`)
                            return
                        }
                }
            }
            else if ((pv_data.duration * 60) - parseInt(((new Date().getTime() - pv_data.start) / 1000 / 60)) < 0 && pv_data.id != parseInt(Player.ClientId))
            {
                Player.Kick("^8Private server^7 is ^2open for rent.^7 Visit ^3discord.gg/ZTavern^7 ^2#shop^7")
                return
            }
            else if (pv_data.status == 0 && pv_data.id != parseInt(Player.ClientId))
            {
                Player.Kick(`^8Private server^7 ^1locked^7 by ^7${pv_data.name}`)
                return
            }
        }
        if (this.is_raid_locked != "" && this.Manager.Server.Hostname)
        {
            var guild_data = await this.Server.DB.metaService.getPersistentMeta('guild_data', Player.ClientId)
            if (!guild_data || guild_data.Value.split(';')[0] != this.is_raid_locked && await this.is_staff(Player) == false)
            {
                Player.Kick(`^3Server^7 locked by ${this.is_raid_locked}^7 guild. ^3Rejoin next game over^7.`)
                return
            }
        }

        var guild_data = await this.Server.DB.metaService.getPersistentMeta('guild_data', Player.ClientId)
        if (!guild_data) 
        {
            //name level money coins revive hp speed skills_count 
          /*  if (Player.ClientId == 63156)
            {
                await this.Server.DB.metaService.addPersistentMeta('guild_data', "^6-RFC-^7;" + 63156 + ";63156;6;1;0;0;0;0;0;0", Player.ClientId)
            }
            if (Player.ClientId == 75539)
            {
                await this.Server.DB.metaService.addPersistentMeta('guild_data', "^1-RS-^7;" + 75539 + ";75539;6;1;0;0;0;0;0;0", Player.ClientId)
            }
            else if (Player.ClientId == 12)
            {
                await this.Server.DB.metaService.addPersistentMeta('guild_data', "^8-KS-^7;" + 12 + ";12;6;1;0;0;0;0;0;0", Player.ClientId)
            }
            else if (Player.ClientId == 79746)
            {
                await this.Server.DB.metaService.addPersistentMeta('guild_data', "^1-ALC-^7;" + 79746 + ";79746;4;1;0;0;0;0;0;0", Player.ClientId)
            }
            else if (Player.ClientId == 65507)
            {
                await this.Server.DB.metaService.addPersistentMeta('guild_data', "^1-WNL-^7;" + 65507 + ";65507;4;1;0;0;0;0;0;0", Player.ClientId)
            }
            else if (Player.ClientId == 66060)
            {
                await this.Server.DB.metaService.addPersistentMeta('guild_data', "^5-ITD-^7;" + 66060 + ";66060;6;1;0;0;0;0;0;0", Player.ClientId)
            }
            else if (Player.ClientId == 40024)
            {
                await this.Server.DB.metaService.addPersistentMeta('guild_data', "^3-ILC-^7;" + 40024 + ";40024;4;1;0;0;0;0;0;0", Player.ClientId)
            }
            else if (Player.ClientId == 45982)
            {
                await this.Server.DB.metaService.addPersistentMeta('guild_data', "^3-AZI-^7;" + 45982 + ";45982;4;1;0;0;0;0;0;0", Player.ClientId)
            }
            else if (Player.ClientId == 135710)
            {
                await this.Server.DB.metaService.addPersistentMeta('guild_data', "^1-LOV-^7;" + 135710 + ";135710;4;1;0;0;0;0;0;0", Player.ClientId)
            }*/
          /*  if (Player.ClientId == 139379)
            {
                await this.Server.DB.metaService.addPersistentMeta('guild_data', "^6-LCS-^7;" + 139379 + ";139379;4;1;0;0;0;0;0;0", Player.ClientId)
                console.log("added to guild")
            }*/
            if (Player.ClientId == 29979)
                {
                    await this.Server.DB.metaService.addPersistentMeta('guild_data', "^2-TSC-^7;" + 29979 + ";29979;4;1;0;0;0;0;0;0", Player.ClientId)
                    console.log("added to guild")
            }
            if (Player.ClientId == 132773)
                {
                    await this.Server.DB.metaService.addPersistentMeta('guild_data', "^6-BHB-^7;" + 132773 + ";132773;4;1;0;0;0;0;0;0", Player.ClientId)
                    console.log("added to guild")
            }
            if (Player.ClientId == 94673)
                {
                    await this.Server.DB.metaService.addPersistentMeta('guild_data', "^1-ROH-^7;" + 94673 + ";94673;9;5;0;0;0;0;0;0", Player.ClientId)
                    console.log("added to guild")
            }
       }


   
        const now = new Date();
        const day = now.getDay(); 
        const hours = now.getHours();
        const minutes = now.getMinutes();

        const raid_war_hour_start = 0;
        const raid_war_hour_end = 0;
    /*    if (day != 0 && this.Manager.Server.Hostname.split('|')[1].includes("TRAINING"))
        {
            if (day == 6 && hours > raid_war_hour_start && hours < raid_war_hour_end)
            {
                Player.Kick("A ^1Raid War^7 is in ^3progress^7 !")
                return     
            }
            var raidpass = await this.Server.DB.metaService.getPersistentMeta('raidpass', Player.ClientId)
            if (!raidpass)
            {
                Player.Kick("Purchase the ^3Raid Pass^7 on discord to ^2enter^7 or join on ^3Sunday^7 !")
                return
            }
        }*/

        var kingID = await this.Server.Rcon.getDvar(`kingId`)
        if (kingID != "0")
        {
            if (inGame.ClientId != parseInt(kingID) && await this.Manager.Server.getClients().length == this.Manager.Server.MaxClients)
            {
                inGame.Kick("This slot is reserved by a ^3King^7 wait up to 1 minute, then try again")
                return
            }
            if (inGame.ClientId == parseInt(kingID))
            {
                await this.Server.Rcon.setDvar(`kingId`, "0")
            }
        }

        inGame && this.Server.Rcon.executeCommandAsync(`rename ${inGame.Clientslot} ""`)
        inGame && this.Server.Rcon.executeCommandAsync(`resetname ${inGame.Clientslot}`)

        var tab = Player.Name.length > 7 ? "\t" : "\t\t" 
        console.log(Utils.COD2BashColor("^3" + inGame.Name + tab + "^2joined^6 \t" + this.Manager.Server.Hostname.split('|')[1] + "^7"))

        var customName = await this.Server.DB.metaService.getPersistentMeta('custom_name', inGame.ClientId)
        if (customName && customName.Value && customName.Value != "")
	    {
            var name = customName.Value
            inGame && this.Server.Rcon.executeCommandAsync(`rename ${inGame.Clientslot} "${name}"`)
        }


        this.SetPlayerStats(inGame)


        var role = Utils.getRoleFrom(inGame.PermissionLevel, 1).Name

        var customTag = await this.Server.DB.metaService.getPersistentMeta('custom_tag', inGame.ClientId)
        if(customTag && (customTag.Value == '^9F^7' || customTag.Value == '^8E^7' || customTag.Value == '^2D^7'
        || customTag.Value == '^4C^7' || customTag.Value == '^5B^7' || customTag.Value == '^6A^7'
        || customTag.Value == '^3S^7' || customTag.Value == '^3SS^7'|| customTag.Value == '^3SSS^7'
        || customTag.Value == '^6 I ^7' || customTag.Value == '^6II^7' || customTag.Value == '^6III^7'
        || customTag.Value == '^5IV^7' || customTag.Value == '^5V^7' || customTag.Value == '^5VI^7' || customTag.Value == '^5VII^7'
        || customTag.Value == '^1IIX^7' || customTag.Value == '^1IX^7' || customTag.Value == '^1-X-^7'))                 
        {
                role = customTag ? customTag.Value : Utils.stripString(role)
                this.Server.Rcon.executeCommandAsync(`setclantagraw ${inGame.Clientslot} "${role}"`)
        }
        else
        {
            if(customTag)
            {
                this.Server.DB.metaService.deletePersistentMeta('custom_tag', inGame.ClientId)
            }
            await this.Server.DB.metaService.addPersistentMeta('custom_tag', '^9F^7', inGame.ClientId)
            customTag = await this.Server.DB.metaService.getPersistentMeta('custom_tag', inGame.ClientId)
                role = customTag ? customTag.Value : Utils.stripString(role)
                this.Server.Rcon.executeCommandAsync(`setclantagraw ${inGame.Clientslot} "${role}"`)
        }		


        if (this.Server.Hostname && (this.Server.Hostname.split("|")[1].includes("AGARTHA") || await this.is_brutus() == true || this.Server.Hostname.split("|")[1].includes("BUS")))
        {   
            this.SetZCoins(Player)
        }
    }


    //------------------------------------------ONPLAYERDISCONNECT--------------------------------------------------------------------------
    //------------------------------------------ONPLAYERDISCONNECT--------------------------------------------------------------------------
    //------------------------------------------ONPLAYERDISCONNECT--------------------------------------------------------------------------

    async onPlayerDisconnect(Player) {
      //  var inGame = await this.Server.getClient(Player.ClientId)
      if (Player.Data)
        Player.Data.connected = 0
      await this.Server.DB.metaService.deletePersistentMeta('noShakeVote', Player.ClientId)
      if (Player.ClientId == 12)
      {
          this.Managers.forEach(manager =>
              {
                  if (manager)
                  {
                      manager.Server.Rcon.executeCommandAsync(`set bold ^2~^5[^1OWNER^5]^2~ ^5${Player.Name} ^7has left ^3${this.Manager.Server.Hostname.split("|")[1]}^7 !`)
                  }
              })    
              return;       
      }
      var king = await this.Server.DB.metaService.getPersistentMeta('king', Player.ClientId)
      var king2 = await this.Server.DB.metaService.getPersistentMeta('king2', Player.ClientId)
      var king4 = await this.Server.DB.metaService.getPersistentMeta('king4', Player.ClientId)
      if (king || king2 || king4)
      {
          this.Managers.forEach(manager =>
              {
                  if (manager)
                  {
                    manager.Server.Rcon.executeCommandAsync(`set bold ^2~^5[^3KING^5]^2~ ^5${Player.Name} ^7has left ^3${this.Manager.Server.Hostname.split("|")[1]}^7 !`)

                  }
              })
      }    
    await this.Server.Rcon.executeCommandAsync(`resetname ${Player.Clientslot}`)
    await this.Server.Rcon.executeCommandAsync(`resetclantag ${Player.Clientslot}`)
    var tab = Player.Name.length >= 7 ? "\t" : "\t\t" 
    console.log(Utils.COD2BashColor("^3" + Player.Name + tab + "^1left^6 \t" + this.Manager.Server.Hostname.split("|")[1] + "^7"))
    }

    async get_pv_data(Player)
    {
        var pv_owner = await this.Server.DB.metaService.getPersistentMeta('pv_data', 12)

        if (!pv_owner)
        {
            Player.Tell("error get_pv_data")
            return
        }
        var pv_data = []
        var pv_data_str = pv_owner.Value.split('-')
        pv_data.id = parseInt(pv_data_str[0])
        pv_data.duration = parseInt(pv_data_str[1])
        if (parseInt(pv_data_str[2]) == 1)
            pv_data.status = 1
        else
            pv_data.status = 0

        pv_data.name = Player.Name
        var custom_name = await this.Server.DB.metaService.getPersistentMeta('custom_name', Player.ClientId)
        if (custom_name)
            pv_data.name = custom_name.Value 

        pv_data.start = parseInt(pv_data_str[3])
        return pv_data
    }

    async is_brutus()
    {
        for(const port of this.botb_port)
        {
            if (port == await this.Server.Rcon.getDvar("net_port"))
                return true
        }
        return false
    }

    async is_raid()
    {
        for(const port of this.raid_port)
        {
            if (port == await this.Server.Rcon.getDvar("net_port"))
                return true
        }
        return false
    }
}



module.exports = Plugin