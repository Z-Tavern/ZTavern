const Sequelize         = require('sequelize')
const path              = require('path')
const { randomInt } = require('crypto')
const { kill } = require('process')
const { totalmem } = require('os')
const Utils             = new (require(path.join(__dirname, '../Utils/Utils.js')))()
const Permissions       = require(path.join(__dirname, `../Configuration/NSMConfiguration.json`)).Permissions
const Localization      = require(path.join(__dirname, `../Configuration/Localization-${process.env.LOCALE}.json`)).lookup

const maxGameMoney = 1000000

class Plugin {
    constructor(Server, Manager, Managers) {
        //add the .pguid of players to grant them staff permissions (must be done on ClanTag, ZombiesBank, ZombiesStats, NativeCommands & the gsc script staff.gsc)
        this.staff_list_a = [564391]
        this.botb_port = ["30001", "30005"]
        this.raid_port = ["30009"]
        this.rate = 1
        this.lock = "0"
        this.cost = 100
        this.Server = Server
        this.Manager = Manager
        this.Managers = Managers
        this.Server.on('connect', this.onPlayerConnect.bind(this))
        this.Server.on('line', this.onLine.bind(this))
        this.init()
        this.competitive_r = -1
        this.basic_r = -1
        this.basic_r2 = -1
        this.ee_random = -1
        this.gamemode_random = -1 
        this.are_quest_randomized = true
        this.competitive_quest_count = 2
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
        this.guildWatcher()
        this.guildQuestWatcher()
        this.modifierWatcher()
    }
    async onLine(line) {
        line = line.trim().replace(new RegExp(/([0-9]+:[0-9]+)\s+/g), '')

        if (Utils.isJson(line)) {
            var bankAction = JSON.parse(line)
            switch (bankAction.event) {
                case 'bank_withdraw':
                    var Player = this.Server.Clients.find(Client => Client && Client.Guid == bankAction.player.Guid)
                    Player && (await this.addPlayerMoney(Player.ClientId, -1 * bankAction.amount))
                break
                case 'bank_deposit':
                    var Player = this.Server.Clients.find(Client => Client && Client.Guid == bankAction.player.Guid)
                    Player && (await this.addPlayerMoney(Player.ClientId, bankAction.amount))
                break
                case 'godmodeon':
                    var Player = this.Server.Clients.find(Client => Client && Client.Guid == bankAction.player.Guid)
                break
                case 'godmodeoff':
                    var Player = this.Server.Clients.find(Client => Client && Client.Guid == bankAction.player.Guid)
                break
            }
        }
    }
    async updatePlayerBalance() {
        this.Server.Clients.forEach(Client => {
            if (!Client || !Client.bankActionQueue.length) return

            this.addPlayerMoney(Client.ClientId, Utils.arraySum(Client.bankActionQueue))
        })
    }

    async onPlayerConnect(Player)
    {
        if (this.lock == "1")
        {
            if (await this.is_staff(Player) == false)
            {
                Player.Kick("^5Server is ^5locked ^5for ^3testing.^7")
            }           
        }
        if (!(await this.getZMStats(Player.ClientId))) {
            await this.Server.DB.Models.NSMZombiesStats.build({
                ClientId: Player.ClientId
            }).save()
        }

        Player.bankActonQueue = []
        this.setBalanceDvar(Player)
    }
    async createTable() {
        this.Server.DB.Models.NSMZombiesStats = this.Server.DB.Models.DB.define('NSMZombiesStats', 
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
            Money: {
                type: Sequelize.INTEGER,
                defaultValue: 0,
                allowNull: false
            },
            LockerWeapon: {
                type: Sequelize.TEXT,
                defaultValue: 'none',
                allowNull: false
            }   
        }, {
            timestamps: false
        })
        this.Server.DB.Models.NSMZombiesStats.sync()
    }
    async getZMStats(ClientId) {
     /*   if (!ClientId)
        {
            console.log("getZMStats ERROR: ClientId undefined")
            return false
        }*/
        if (!ClientId)
            return false
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
    async setPlayerMoney(ClientId, Money) {
        await this.Server.DB.Models.NSMZombiesStats.update({
            Money : Money }, {
                where: {ClientId: ClientId
            }
        })
    }
    async setBalanceDvar(Player) {
        if (!Player.Server) return
        var money = (await this.getZMStats(Player.ClientId)).Money
        if (money == undefined)
        {
            Player.Tell("Error, zm_stats")
            return
        }
        Player.Server.Rcon.setDvar(`${Player.Guid}_balance`, money)
    }
    async addPlayerMoney(ClientId, Money) {
        return await this.Server.DB.Models.NSMZombiesStats.update({ 
            Money : Sequelize.literal(`Money + ${Money}`) }, {
                where: {ClientId: ClientId
                }
            })
    }
    //trade
    async getTradeData(Player) {
        try {
        const tradeData = (await this.Server.DB.metaService.getPersistentMeta('trade_data_buyer', Player.ClientId)).Value;
        return tradeData && tradeData != "0" ? tradeData : null;
        } catch (error) {
            return null;
        }
    }
    async performTrade({sellerId, buyerId, money, zcoins, slot}) {
            await Promise.all([
                this.addZcoins(sellerId, zcoins),
                this.removeZcoins(buyerId, zcoins),
                this.addMoney(sellerId, money),
                this.subtractMoney(buyerId, money)
            ]);

        this.Managers.forEach(manager =>
            {
                if (manager)
                {
                    this.checkForLoadedSave(manager, sellerId, slot)
                }
            })
        await this.updateGameSlots({sellerId, buyerId, slot});
        await this.resetTradeData(sellerId, buyerId);
    }

    async checkForLoadedSave(manager, clientId, slot)
    {
        var save_id = parseInt(await manager.Server.Rcon.getDvar('saveId'))
        var save_slot = parseInt(await manager.Server.Rcon.getDvar('saveSlot'))

        if(clientId == save_id && save_slot == slot)
        {
            await manager.Server.Rcon.setDvar('saveId', "1")
        }
    }

    async updateGameSlots({sellerId, buyerId, slot}) {
        const [sellerSlot, buyerSlot] = await Promise.all([
            this.getGame(sellerId),
            this.getGame(buyerId)
        ]).then(results => results.map(result => result.split(';')));

        if (slot == 1 || slot == 2) {
            const sellerNewSlot = slot == 1 ? [0, sellerSlot[1]] : [sellerSlot[0], 0];

            if (parseInt(buyerSlot[0]) >= parseInt(buyerSlot[1]))
            {
                var buyerNewSlot = [buyerSlot[0], sellerSlot[slot - 1]]
            }
            else
            {
                var buyerNewSlot = [sellerSlot[slot - 1], buyerSlot[1]]   
            }
            await Promise.all([
                this.saveGame(sellerId, ...sellerNewSlot),
                this.saveGame(buyerId, ...buyerNewSlot)
            ]);
        }
    }

    async resetTradeData(sellerId, buyerId) {
        await Promise.all([
            this.Server.DB.metaService.addPersistentMeta('trade_date', (new Date() / 1000) - 61, sellerId),
            this.Server.DB.metaService.addPersistentMeta('trade_date', (new Date() / 1000) - 61, buyerId),
            this.Server.DB.metaService.addPersistentMeta('trade_data_seller', "0", sellerId),
            this.Server.DB.metaService.addPersistentMeta('trade_data_buyer', "0", buyerId)
        ]);
    }
    parseTradeData(tradeData) {
        const tradeInfo = tradeData.split(';');
        const tradeInfoParsed = tradeInfo[0].split('-');

        return [parseInt(tradeInfo[4]), parseInt(tradeInfo[3]), parseInt(tradeInfo[1]), parseInt(tradeInfo[2]), parseInt(tradeInfoParsed[0]), parseInt(tradeInfoParsed[1])]; ///////
    }
    async handleTradeTimeout(Seller, Buyer) {
        setTimeout(async () => {
            var [trade_data_seller, trade_data_buyer] = await Promise.all([
                this.Server.DB.metaService.getPersistentMeta('trade_data_seller', Seller.ClientId),
                this.Server.DB.metaService.getPersistentMeta('trade_data_buyer', Buyer.ClientId)
            ]);
    
            if (trade_data_seller.Value != "0" && trade_data_buyer.Value != "0")
            {
                await this.resetTradeData(Seller.ClientId, Buyer.ClientId);
                await Seller.Tell(`^2Trade offer^7 ^3timed out^7. Your ^2trade offer^7 has been cancelled.`);
                await Buyer.Tell(`^2Trade offer^7 ^3timed out^7. Your ^2trade offer^7 has been cancelled.`);
            }
        }, (60 * 1000)); // 60 seconds timeout
    }
    async initiateTrade(Seller, Buyer, saveSlot, money, zcoins) {

        const sellerSlot = await this.getSaveSlot(Seller, saveSlot)
        const tradeData = `${saveSlot}-${sellerSlot};${money};${zcoins};${Buyer.ClientId};${Seller.ClientId}` ///////
    
        await Promise.all([
            this.Server.DB.metaService.addPersistentMeta('trade_date', (new Date() / 1000), Seller.ClientId),
            this.Server.DB.metaService.addPersistentMeta('trade_date', (new Date() / 1000), Buyer.ClientId),
            this.Server.DB.metaService.addPersistentMeta('trade_data_seller', tradeData, Seller.ClientId),
            this.Server.DB.metaService.addPersistentMeta('trade_data_buyer', tradeData, Buyer.ClientId)
        ]);
        var seller_name = Seller.Name
        var buyer_name = Buyer.Name

        var seller_custom_name = await this.Server.DB.metaService.getPersistentMeta('custom_name', Seller.ClientId) 
        if (seller_custom_name)
            seller_name = seller_custom_name.Value
 
        var buyer_custom_name = await this.Server.DB.metaService.getPersistentMeta('custom_name', Buyer.ClientId) 
        if (buyer_custom_name)
            buyer_name = buyer_custom_name.Value

        await Seller.Tell(`^2Trade offer^7 sent to ${buyer_name}^7 for ^2${money} points^7 and ^5${zcoins} zcoins^7. ^3Save: ${sellerSlot}`);
        await Buyer.Tell(`^2Trade offer^7 received from ${seller_name}^7 for a ^3Save ${sellerSlot}^7. ^1Cost^7 : ^2${money} points^7 and ^5${zcoins} zcoins^7. `);
        await new Promise(resolve => setTimeout(resolve, 100))
        await Buyer.Tell(`^3Use ^2.trade accept^7 or ^1.trade refuse^7. `);
    }
    async canBuyerAfford(Seller, Buyer, money, zcoins) {

        const [buyerMoney, buyerZcoins] = await Promise.all([
            this.getMoney(Buyer.ClientId),
            this.getZcoins(Buyer.ClientId)
        ]);

        if(buyerMoney < money){
            await Buyer.Tell(`Buyer ^1does not have enough points^7. Buyer current balance is ^2${buyerMoney}^7. Buyer need ^2${money - buyerMoney}^7 more points.`);
            await Seller.Tell( `^1Trade failed^7. The ^3buyer^7 ^1does not have enough points^7.`);
            return false;
        }
    
    
        if (buyerZcoins < zcoins) {
            await Buyer.Tell(`Buyer ^1does not have enough zcoins^7. Buyer current balance is ^5${buyerZcoins} zcoins^7. Buyer need ^5${zcoins - buyerZcoins}^7 more zcoins.`);
            await Seller.Tell(`^1Trade failed^7. The buyer ^1does not have enough zcoins^7.`);
            return false;
        }
    
        return { canAfford: true };
    }
    async checkTradeStatus(Seller, Buyer) {
        var [seller_trade_date, buyer_trade_date] = await Promise.all([
            this.Server.DB.metaService.getPersistentMeta('trade_date', Seller.ClientId),
            this.Server.DB.metaService.getPersistentMeta('trade_date', Buyer.ClientId)
        ]);

        if (!seller_trade_date)
        {
            this.Server.DB.metaService.addPersistentMeta('trade_date', (new Date() / 1000) - 61 , Seller.ClientId),
            seller_trade_date = this.Server.DB.metaService.getPersistentMeta('trade_date', Seller.ClientId)
        }
        if (!buyer_trade_date)
        {
            this.Server.DB.metaService.getPersistentMeta('trade_date', (new Date() / 1000) - 61, Buyer.ClientId)
            buyer_trade_date = this.Server.DB.metaService.getPersistentMeta('trade_date', Buyer.ClientId)
        }
        const buyer_trade_date_val = parseInt(buyer_trade_date.Value) + 60
        const seller_trade_date_val = parseInt(seller_trade_date.Value) + 60

        if (seller_trade_date_val > new Date() / 1000 && buyer_trade_date_val > new Date() / 1000)
        {
            await Seller.Tell(`^1Trade failed^7. ^3Both you and the buyer already have a trade in progress.`);
            await Buyer.Tell(`^1Trade failed^7. ^3Both you and the seller already have a trade in progress.`);
            return true;
        }
        else if (seller_trade_date_val > new Date() / 1000)
        {
            await Seller.Tell(`^1Trade failed^7. ^3You already have a trade in progress.`);
            return true;
        }
        else if (buyer_trade_date_val > new Date() / 1000)
        {
            await Buyer.Tell(`^1Trade request failed^7. ^3You already have a trade in progress.`);
            await Seller.Tell(`^1Trade failed^7. ^3The buyer already has a trade in progress.`);
            return true;
        }
        return false;
    }
    async getSaveSlot(Player, slot) {
        const gameData = await this.getGame(Player.ClientId);
        return parseInt(gameData.split(';')[slot - 1]);
    }
    async acceptTrade(Player) {
        const tradeData = await this.getTradeData(Player);

        if (!tradeData) {
            await Player.Tell(`There is no trade offer for you to accept.`);
            return;
        }

        const [sellerId, buyerId, money, zcoins, slot, slotValue] = this.parseTradeData(tradeData); ///////
        const Seller = await this.Server.findClient(sellerId)
        if (!Seller)
        {
            Player.Tell("The seller ^disconnected^7, ^3trade cancelled.")
            await this.resetTradeData(sellerId, buyerId);
            return;
        }
        const Buyer = Player;
        const [canAfford, selleRSlotValue] = await Promise.all([
            this.canBuyerAfford(Seller, Buyer, money, zcoins),
            this.getSaveSlot(Seller, slot)
        ]);


        if(Player.ClientId != buyerId){
            await Player.Tell(`^1You cannot accept a trade as you are not the buyer.`);
            return;
        }

        if (!canAfford) {
            await Player.Tell(`^1Trade failed^7. You ^1don't have enough points or zcoins^7 to complete the trade.`);
            await this.resetTradeData(sellerId, buyerId);
            return;
        }

        if (selleRSlotValue != slotValue){  
            await Buyer.Tell(`^1Trade failed^7. ^3The seller ^1has changed the save slot.`);
            await Seller.Tell(`^1Trade failed^7. ^3You have ^1changed the save slot.`);
            await this.resetTradeData(sellerId, buyerId);
            return;
        }

        var seller_name = Seller.Name
        var buyer_name = Buyer.Name

        var seller_custom_name = await this.Server.DB.metaService.getPersistentMeta('custom_name', Seller.ClientId) 
        if (seller_custom_name)
            seller_name = seller_custom_name.Value
 
        var buyer_custom_name = await this.Server.DB.metaService.getPersistentMeta('custom_name', Buyer.ClientId) 
        if (buyer_custom_name)
            buyer_name = buyer_custom_name.Value

        await this.performTrade({sellerId, buyerId, money, zcoins, slot});
        await Buyer.Tell(`^2Trade accepted^7. You have successfully traded ^2${money} points^7 and ^5${zcoins} zcoins^7 with ${seller_name}^7 for ^3save ${selleRSlotValue}.`);
        await Seller.Tell(`^2Trade accepted^7. You have successfully traded ^3save ${selleRSlotValue}^7 with ${buyer_name}^7 for ^2${money}^7 points and ^5${zcoins} zcoins.`);
    }
    async refuseTrade(Player) {
        const tradeData = await this.getTradeData(Player);

        if (!tradeData) {
            await Player.Tell(`There is ^1no trade offer for you to refuse^7.`);
            return;
        }

        const [sellerId, buyerId, money, zcoins, slot, slotValue] = this.parseTradeData(tradeData);

        await this.resetTradeData(sellerId, buyerId);

        var seller_name = Player.Name
        var seller_custom_name = await this.Server.DB.metaService.getPersistentMeta('custom_name', Player.ClientId) 
        if (seller_custom_name)
            seller_name = seller_custom_name.Value 
        await Player.Tell(`You ^1refused^7 the ^3trade offer.`);
        var Seller = await this.Server.findClient(sellerId)
        if (Seller)
        {
            Seller.Tell(`${seller_name} ^1refused your ^3trade offer.`)
        }
    }

    async createTrade(Seller, Buyer, moneyAmount, zcoinsAmount, saveSlot) {
        const money = parseInt(moneyAmount, 10);
        const zcoins = parseInt(zcoinsAmount, 10);

        if (isNaN(money) || money < 0) {
            Seller.Tell(`^1Invalid amount of points^7. ^3Please specify a valid amount.`);
            return;
        }

        if (isNaN(zcoins) || zcoins < 0) {
            Seller.Tell(`^1Invalid amount of zcoins^7. ^3Please specify a valid amount.`);
            return;
        }

        const tradeStatus = await this.checkTradeStatus(Seller, Buyer);
        if (tradeStatus) {
            return;
        }

        const canAfford = await this.canBuyerAfford(Seller, Buyer, money, zcoins);
        if (!canAfford) {
            return;
        }

        await this.initiateTrade(Seller, Buyer, saveSlot, money, zcoins);
        this.handleTradeTimeout(Seller, Buyer);
    }

    async saveGame (PlayerId, slot1, slot2) {
        var saveValue = `${slot1};${slot2}`;
        await this.Server.DB.metaService.addPersistentMeta('save', saveValue, PlayerId);
        return this.getGame(PlayerId);
    }
    async getGame (PlayerId) {
        var savedData = await this.Server.DB.metaService.getPersistentMeta('save', PlayerId);
        if (!savedData)
        {
            await this.Server.DB.metaService.addPersistentMeta('save', '0;0' , PlayerId);
            savedData = await this.Server.DB.metaService.getPersistentMeta('save', PlayerId);
        }
        return savedData.Value;
    }

    async getMoney (ClientId) { 
        var money = (await this.getZMStats(ClientId)).Money 
       /* if (money == undefined)
        {
            Player.Tell("Error, zm_stats_getmoney")
            return false
        }*/
        return money
    }   
    async addMoney (ClientId, Money) {
        var newMoney = parseInt(await this.getMoney(ClientId)) + parseInt(Money);
        await this.Server.DB.Models.NSMZombiesStats.update({
          Money : newMoney.toString() }, {
            where: {ClientId: ClientId}
        });
      
        return newMoney
    }
    async subtractMoney (ClientId, Money) {
        var currentMoney = await this.getMoney(ClientId);

        if (currentMoney < parseInt(Money)) {
            return -1;
        }

        var newMoney = parseInt(await this.getMoney(ClientId)) - parseInt(Money);
        await this.Server.DB.Models.NSMZombiesStats.update({
          Money : newMoney.toString() }, {
            where: {ClientId: ClientId}
        });
      
        return newMoney;
    }
    async getZcoins(PlayerId) {
        var zcoins = await this.Server.DB.metaService.getPersistentMeta('zcoins', PlayerId);
        if (!zcoins)
        {
            await this.Server.DB.metaService.addPersistentMeta('zcoins', "0", PlayerId)
            zcoins = await this.Server.DB.metaService.getPersistentMeta('zcoins', PlayerId)
        }     
        return zcoins ? parseInt(zcoins.Value) : 0;
    }
      
    async addZcoins(PlayerId, Amount) {
        var currentZcoins = await this.getZcoins(PlayerId);
        var newZcoins = parseInt(currentZcoins) + parseInt(Amount);
        await this.Server.DB.metaService.addPersistentMeta('zcoins', newZcoins, PlayerId);
        return newZcoins;
    }
    async removeZcoins(PlayerId, Amount) {
        var currentZcoins = await this.getZcoins(PlayerId);

        if (currentZcoins < parseInt(Amount)) {
            return -1;
        }

        var newZcoins = parseInt(currentZcoins) - parseInt(Amount);

        await this.Server.DB.metaService.addPersistentMeta('zcoins', newZcoins, PlayerId);

        return newZcoins;
    }      
    //trade






// COMMANDS

    async init () {
        await this.createTable()








        this.Manager.commands['guild'] =
        {
            inGame: false,
            ArgumentLength: 0,
            Alias: 'gd',
            logToAudit: false,
            Permission: Permissions.Commands.COMMAND_USER_CMDS,
            callback: async (Player, args) =>
            {
                if (this.Server.tmp)
                    console.log(this.Server.tmp)
                for (const manager of this.Managers)
                {
                    if (manager.Server.tmp && manager.Server.tmp == 1)
                        {
                            Player.Tell("This command is ^1already in use^7, try again in ^5a few seconds^7")
                            return
                        }
                }
                for (const manager of this.Managers)
                {
                    if (manager && manager.Server)
                        manager.Server.tmp = 1;
                }

                if (args[1] && args[1] == "edit" && this.is_staff(Player))
                {
                    if (!args[2])
                    {
                        Player.Tell("^3Guild name^7 ^1missing^7.")
                        return
                    }
                    this.guild_list.forEach(guild =>
                    {
                        this.guild_staff(guild, args, Player)
                    })
                    for (const manager of this.Managers)
                    {
                        if (manager && manager.Server)
                            manager.Server.tmp = 0;
                    }
                    return
                }

                var guild_data = await this.Server.DB.metaService.getPersistentMeta('guild_data', Player.ClientId)
                if (!guild_data)
                {
                    Player.Tell("^1Not in a guild^7 ! Join a ^6Guild^7 or purchase a ^3Guild Core^7 on ^6Discord^7 !")
                    for (const manager of this.Managers)
                        {
                            if (manager && manager.Server)
                                manager.Server.tmp = 0;
                        }
                    return
                }
                
                var guild_str = guild_data.Value.split(";")
                var guild = []

                guild.name = guild_str[0]
                guild.guild_master = guild_str[1]
                guild.guild_members = guild_str[2] 
                guild.size = guild_str[3]
                guild.level = guild_str[4]
                guild.xp = guild_str[5]
                guild.bank = guild_str[6]
                guild.hp = guild_str[7]
                guild.speed = guild_str[8]
                guild.skills = guild_str[9]
                guild.revive = guild_str[10] 


                if (args[1] && args[1] == "info")
                {
                    Player.Tell("^6Guild^7 ^5Name : " + guild.name)
                    await new Promise(resolve => setTimeout(resolve, 100))
                    Player.Tell("^6Guild ^3GM^7 ID : " + guild.guild_master)
                    await new Promise(resolve => setTimeout(resolve, 100))
                    Player.Tell("^3Member ID list^7 : " + guild.guild_members)
                    await new Promise(resolve => setTimeout(resolve, 100))
                    Player.Tell("^6Guild^7 ^3Level : " + guild.level)
                    await new Promise(resolve => setTimeout(resolve, 100))
                    var xp_needed = 100;
                    if (guild.level > 8)
                        xp_needed = 200;
                    else if (guild.level > 7)
                        xp_needed = 150;
                    else if (guild.level > 5)
                        xp_needed = 120;
                    else if (guild.level >= 10)
                        xp_needed = "Max Lv"
                    Player.Tell("^6Guild^7 ^5XP : " + guild.xp + "/^1" + xp_needed + "^7 XP")
                    await new Promise(resolve => setTimeout(resolve, 100))
                    Player.Tell("^6Guild^7 ^3Size : " + guild.size + " Slots")
                    await new Promise(resolve => setTimeout(resolve, 100))
                    for (const manager of this.Managers)
                        {
                            if (manager && manager.Server)
                                manager.Server.tmp = 0;
                        }
                    return
                }
                else if (args[1] && args[1] == "list")
                {
                    var i = 0
                    for (const guild_name_id of this.guild_list)
                    {
                        var guild = await this.init_guild_data(parseInt(guild_name_id.split(";")[1]))
                        var guild_size = guild.guild_members.split('-').length
                        var gm = await this.Server.getClient("@" + guild_name_id.split(";")[1])
                        var gm_name = gm.Name
                        var customName = await this.Server.DB.metaService.getPersistentMeta('custom_name', gm.ClientId)
                        if (customName)
                            gm_name = customName.Value
                        Player.Tell(guild.name + " : ^3Led by^7 " + gm_name + "^7 - ^3Level " + guild.level + " - ^5" + guild_size + "/" + guild.size + " Members^7")
                        if ( i != 0 && i % 6 == 0)
                            await new Promise(resolve => setTimeout(resolve, 3000))
                        await new Promise(resolve => setTimeout(resolve, 100))
                        i++
                    }
                    for (const manager of this.Managers)
                        {
                            if (manager && manager.Server)
                                manager.Server.tmp = 0;
                        }
                    return
                }
                else if (args[1] && args[1] == "tree")
                {
                    var mystery = "???"
                    var txt = ""
                    var color = ""
                    if (args[2] && args[2] == "2")
                    {
                        Player.Tell("--- ^6Page [2/2]^7 ---")
                        await new Promise(resolve => setTimeout(resolve, 100))
                        txt = mystery
                        if (parseInt(guild.level) > 4)
                            txt = "+1 .rev"
                        if (parseInt(guild.level) >= 6)
                            color = "^2"
                        else
                            color = "^1"
                        Player.Tell("^3Lv6^7 - " + color + txt)
                        await new Promise(resolve => setTimeout(resolve, 100))
                        txt = mystery
                        if (parseInt(guild.level) > 5)
                            txt = ".up limit increased"
                        if (parseInt(guild.level) >= 7)
                            color = "^2"
                        else
                            color = "^1"
                        Player.Tell("^3Lv7^7 - " + color + txt)
                        await new Promise(resolve => setTimeout(resolve, 100))
                        txt = mystery
                        if (parseInt(guild.level) > 6)
                            txt = "+1 gamemode modifier"
                        if (parseInt(guild.level) >= 8)
                            color = "^2"
                        else
                            color = "^1"
                        Player.Tell("^3Lv8^7 - " + color + txt)
                        await new Promise(resolve => setTimeout(resolve, 100))
                        txt = mystery
                        if (parseInt(guild.level) > 7)
                            txt = "+1 guild size"
                        if (parseInt(guild.level) >= 9)
                            color = "^2"
                        else
                            color = "^1"
                        Player.Tell("^3Lv9^7 - " + color + txt)
                        await new Promise(resolve => setTimeout(resolve, 100))
                        txt = mystery
                        if (parseInt(guild.level) > 8)
                            txt = "Hat !" //TODO interaction with others would be best (endless botb that gives a lot of money, saves ?, cosmetics)
                        if (parseInt(guild.level) >= 10)
                            color = "^2"
                        else
                            color = "^1"
                        Player.Tell("^3Lv10^7 - " + color + txt)
                    }
                    else
                    {
                        Player.Tell("--- ^6Page [1/2]^7 ---")
                        await new Promise(resolve => setTimeout(resolve, 100))
                        txt = mystery
                        if (parseInt(guild.level) > 0)
                            txt = "[Classic] +50 HP & +5% Speed"
                        if (parseInt(guild.level) >= 2)
                            color = "^2"
                        else
                            color = "^1"
                        Player.Tell("^3Lv2^7 - " + color + txt)
                        await new Promise(resolve => setTimeout(resolve, 100))
                        txt = mystery
                        if (parseInt(guild.level) > 1)
                            txt = "[Raid boss] 33% skill haste"
                        if (parseInt(guild.level) >= 3)
                            color = "^2"
                        else
                            color = "^1"
                        Player.Tell("^3Lv3^7 - " + color + txt)
                        await new Promise(resolve => setTimeout(resolve, 100))
                        txt = mystery
                        if (parseInt(guild.level) > 2)
                            txt = "+1 guild size"
                        if (parseInt(guild.level) >= 4)
                            color = "^2"
                        else
                            color = "^1"
                        Player.Tell("^3Lv4^7 - " + color + txt)
                        await new Promise(resolve => setTimeout(resolve, 100))
                        txt = mystery
                        if (parseInt(guild.level) > 3)
                            txt = ".up limit increased"
                        if (parseInt(guild.level) >= 5)
                            color = "^2"
                        else
                            color = "^1"
                        Player.Tell("^3Lv5^7 - " + color + txt)
                        await new Promise(resolve => setTimeout(resolve, 100))
                        Player.Tell("^2.guild tree 2^7 for ^3next page")
                    }
                    for (const manager of this.Managers)
                        {
                            if (manager && manager.Server)
                                manager.Server.tmp = 0;
                        }
                    return
                }
                else if (args[1] && args[1] == "quest")
                {
                    Player.Tell("Loading ^3Quest data^7, please wait...\n")
                    var guild_quest = await this.Server.DB.metaService.getPersistentMeta('guild_quest', Player.ClientId)
                    if (!guild_quest)
                    {
                        Player.Tell("no quest data, wait for release !")
                        for (const manager of this.Managers)
                            {
                                if (manager && manager.Server)
                                    manager.Server.tmp = 0;
                            }
                        return
                    }
                    var quest_array = guild_quest.Value.split(";")
                    var guild = await this.init_guild_data(Player.ClientId)

                    var quest_count = 0;
                    for (const quest of quest_array)
                    {
                        if (quest == "raid_boss_quest")
                        {
                            await this.print_competitive_timed_quest(Player, quest, quest_count)
                        }
                        else if (quest.includes("ee_speedrun_quest"))
                        {
                            await this.print_competitive_timed_quest(Player, quest, quest_count)
                        }
                        
                        else if (quest.includes("gamemode_speedrun_quest"))
                        {
                            await this.print_competitive_timed_quest(Player, quest, quest_count)
                        }
                        /*        else if (quest == "first_room_hr_quest")
                        {
                         
                        }*/

                        //basic quests
                        else if (quest == "kill_quest")
                        {
                            for(const member_id of guild.guild_members.split('-'))
                            {
                                var Player_Stats = await this.Server.DB.getPlayerPersStats(parseInt(member_id), "Kills")
                                var kill_quest_start = await this.Server.DB.metaService.getPersistentMeta('kill_quest_start', parseInt(member_id))
                                var kill_quest = await this.Server.DB.metaService.getPersistentMeta('kill_quest', parseInt(member_id))
                                if (kill_quest && kill_quest.Value == "-1")
                                    break;
                                if (!kill_quest_start || !Player_Stats[0].Kills)
                                {
                                    //   Player.Tell("Err, no quest data, contact staff")
                                    continue;
                                }
                                await this.Server.DB.metaService.addPersistentMeta('kill_quest', parseInt(Player_Stats[0].Kills) - parseInt(kill_quest_start.Value), parseInt(member_id))
                            }
                            await this.print_basic_score_quest(Player, "kill_quest", quest_count, quest_array)
                        }
                        else if (quest == "headshot_quest")
                        {
                            for(const member_id of guild.guild_members.split('-'))
                            {
                                var Player_Stats = await this.Server.DB.getPlayerPersStats(parseInt(member_id), "Headshots")
                                var headshot_quest_start = await this.Server.DB.metaService.getPersistentMeta('headshot_quest_start', parseInt(member_id))
                                var headshot_quest = await this.Server.DB.metaService.getPersistentMeta('headshot_quest', parseInt(member_id))
                                if (headshot_quest && headshot_quest.Value == "-1")
                                    break;
                                if (!headshot_quest_start || !Player_Stats[0].Headshots)
                                {
                                    //   Player.Tell("Err, no quest data, contact staff")
                                    continue;
                                }
                                await this.Server.DB.metaService.addPersistentMeta('headshot_quest', parseInt(Player_Stats[0].Headshots) - parseInt(headshot_quest_start.Value), parseInt(member_id))
                            }
                            await this.print_basic_score_quest(Player, "headshot_quest", quest_count, quest_array)
                        }
                        else if (quest == "gamemode_completion_quest")
                        {
                            for(const member_id of guild.guild_members.split('-'))
                            {
                                var gamemode_count_start = await this.Server.DB.metaService.getPersistentMeta('gamemode_completion_quest_start', parseInt(member_id))
                                var gamemode_count = await this.Server.DB.metaService.getPersistentMeta('gamemodeCountTotal', parseInt(member_id))
                                var gamemode_quest = await this.Server.DB.metaService.getPersistentMeta('gamemode_completion_quest', parseInt(member_id))
                                if (gamemode_quest && gamemode_quest.Value == "-1")
                                    break;
                                if (!gamemode_count_start || !gamemode_count)
                                {
                                 //   Player.Tell("Err, no quest data, contact staff")
                                 continue;
                                }
                                await this.Server.DB.metaService.addPersistentMeta('gamemode_completion_quest', parseInt(gamemode_count.Value) - parseInt(gamemode_count_start.Value), parseInt(member_id))
                            }
                            await this.print_basic_score_quest(Player, "gamemode_completion_quest", quest_count, quest_array)
                        }
                        else if (quest == "ee_completion_quest")
                        {
                            for(const member_id of guild.guild_members.split('-'))
                            {
                                var ee_count_start = await this.Server.DB.metaService.getPersistentMeta('ee_completion_quest_start', parseInt(member_id))
                                var ee_count = await this.Server.DB.metaService.getPersistentMeta('eeCountTotal', parseInt(member_id))
                                var ee_quest = await this.Server.DB.metaService.getPersistentMeta('ee_completion_quest', parseInt(member_id))
                                if (ee_quest && ee_quest.Value == "-1")
                                    break;
                                if (!ee_count_start || !ee_count)
                                {
                                 //   Player.Tell("Err, no quest data, contact staff")
                                    continue;
                                }
                                await this.Server.DB.metaService.addPersistentMeta('ee_completion_quest', parseInt(ee_count.Value) - parseInt(ee_count_start.Value), parseInt(member_id))
                            }

                            await this.print_basic_score_quest(Player, "ee_completion_quest", quest_count, quest_array)
                        }
                        quest_count++;
                    }
                    for (const manager of this.Managers)
                        {
                            if (manager && manager.Server)
                                manager.Server.tmp = 0;
                        }
                    return
                }
                else if (args[1] && args[1] == "add")
                {
                    var is_gm = 0
                    this.guild_list.forEach(guild_name_id =>
                        {
                            if (parseInt(guild_name_id.split(";")[1]) == Player.ClientId)
                                is_gm = 1
                        })
                    if (is_gm == 0)
                    {
                        Player.Tell("You are ^1not^7 a ^5Guild Master")
                        for (const manager of this.Managers)
                            {
                                if (manager && manager.Server)
                                    manager.Server.tmp = 0;
                            }
                        return
                    }
                    if (!args[2])
                    {
                        Player.Tell("no ID parameter")
                        for (const manager of this.Managers)
                            {
                                if (manager && manager.Server)
                                    manager.Server.tmp = 0;
                            }
                        return
                    }
                    var client = await this.Server.getClient(args[2])
                    if (!client || !(args[2].includes("@")))
                    {
                        Player.Tell("Invalid player ID.")
                        for (const manager of this.Managers)
                            {
                                if (manager && manager.Server)
                                    manager.Server.tmp = 0;
                            }
                        return
                    }
                    var current_members = 0

                    if (guild.guild_members.split('-').length)
                    {
                        var current_members = guild.guild_members.split('-').length
                    }
                    if (parseInt(guild.size) > parseInt(current_members))
                    {
                        var members_array = guild.guild_members.split('-')
                        var err = 0;
                        members_array.forEach(member =>
                        {
                            if (member == args[2].replace('@', ''))
                            {
                                Player.Tell(args[2].replace('@', '') + " is ^3already^7 in your ^6guild !")
                                err = 1;
                            }                  
                        }) 
                        if (err && err == 1)
                        {
                            for (const manager of this.Managers)
                                {
                                    if (manager && manager.Server)
                                        manager.Server.tmp = 0;
                                }
                            return
                        }

                        var player_guild = await this.Server.DB.metaService.getPersistentMeta('guild_data', parseInt(args[2].replace('@', '')))
                        if (player_guild && player_guild.Value.split(";")[0] != guild.name)
                        {
                            Player.Tell("Player ^3" + args[2].replace('@', '') + "^7 belongs to " + player_guild.Value.split(";")[0])
                            for (const manager of this.Managers)
                                {
                                    if (manager && manager.Server)
                                        manager.Server.tmp = 0;
                                }
                            return
                        }
                            
                        if (guild.guild_members == "0" || guild.guild_members == "-" || guild.guild_members == "")
                            guild.guild_members = args[4].replace('@', '') //add guild member
                        else
                            guild.guild_members += "-" + args[2].replace('@', '') //add guild member

                        Player.Tell(args[2].replace('@', '') + " added to " + guild.name)
                    }
                    else
                    {
                        Player.Tell("Your ^6Guild^7 is ^1full^7 !")
                        for (const manager of this.Managers)
                            {
                                if (manager && manager.Server)
                                    manager.Server.tmp = 0;
                            }
                        return
                    }
                }
                else if (args[1] && args[1] == "remove")
                {
                    var is_gm = 0
                    this.guild_list.forEach(guild_name_id =>
                        {
                            if (parseInt(guild_name_id.split(";")[1]) == Player.ClientId)
                                is_gm = 1
                        })
                    if (is_gm == 0)
                    {
                        Player.Tell("You are ^1not^7 a ^5Guild Master")
                        for (const manager of this.Managers)
                            {
                                if (manager && manager.Server)
                                    manager.Server.tmp = 0;
                            }
                        return
                    }
                    var is_found = 0
                    var members_array = guild.guild_members.split('-')
                    if (Player.ClientId == parseInt(args[2].replace('@', '')))
                    {
                        Player.Tell("^1Cannot^7 remove yourself from your own ^6Guild^7")
                        for (const manager of this.Managers)
                            {
                                if (manager && manager.Server)
                                    manager.Server.tmp = 0;
                            }
                        return
                    }             
    
                    var client = await this.Server.getClient(args[2])
                    if (!client || !(args[2].includes("@")))
                    {
                        Player.Tell("Invalid player ID.")
                        for (const manager of this.Managers)
                            {
                                if (manager && manager.Server)
                                    manager.Server.tmp = 0;
                            }
                        return
                    }
                    var target_player_id = "";
                    members_array.forEach(member =>
                    {
                        if (member == args[2].replace('@', ''))
                        {
                            target_player_id = member
                            is_found = 1
                        }                  
                    }) 
                    if (is_found == 0)
                    {
                        Player.Tell("This player is ^1not^7 in " + guild.name)
                        for (const manager of this.Managers)
                            {
                                if (manager && manager.Server)
                                    manager.Server.tmp = 0;
                            }
                        return
                    }
    
                    var player_guild = await this.Server.DB.metaService.getPersistentMeta('guild_data', parseInt(target_player_id))
                    if (player_guild && player_guild.Value.split(";")[0] != guild.name)
                    {
                        Player.Tell("Player ^3" + target_player_id + "^7 belongs to " + player_guild.Value.split(";")[0])
                        for (const manager of this.Managers)
                            {
                                if (manager && manager.Server)
                                    manager.Server.tmp = 0;
                            }
                        return
                    }
                    guild.guild_members = guild.guild_members.replace("\-".toString() + target_player_id , "")
                    Player.Tell(args[2].replace('@', '') + " removed from " + guild.name)
                    await this.Server.DB.metaService.deletePersistentMeta('guild_data', parseInt(target_player_id))

                }
                else
                {
                    Player.Tell("^5Member^7 Usage : .guild [^2info^7 | ^5quest^7 | ^6tree^7 | ^8list^7] & ^1.glock^7")
                    await new Promise(resolve => setTimeout(resolve, 100))
                    Player.Tell("^3Guild Master^7 Usage : .guild [^2add^7 | ^1remove^7]")
                    for (const manager of this.Managers)
                        {
                            if (manager && manager.Server)
                                manager.Server.tmp = 0;
                        }
                    return
                }
                guild.guild_members.split("-").forEach(member_id => //update guild list
                    {
                        this.set_player_guild_stat(guild, member_id)
                    }) 
                    for (const manager of this.Managers)
                        {
                            if (manager && manager.Server)
                                manager.Server.tmp = 0;
                        }
            }
        }

        this.Manager.commands['lobbyid'] = {
            ArgumentLength: 0,
            Alias : 'lid',
            Permission: Permissions.Commands.COMMAND_USER_CMDS,
            inGame: true,
            callback: async (Player, args) =>
            {
                for (const client of await this.Manager.Server.getClients())
                {
                    var customName = await this.Server.DB.metaService.getPersistentMeta('custom_name', client.ClientId)
                    var name = client.Name
                    if (customName)
                        name = customName.Value
                    Player.Tell("^5" + name + "^7 id : ^3@" + client.ClientId)
                }
            }
        }

        
        this.Manager.commands['trade'] = {
            ArgumentLength: 0,
            Permission: Permissions.Commands.COMMAND_USER_CMDS,
            inGame: true,
            callback: async (Player, args) => {

                if(!args[1]) {
                    Player.Tell(`Usage : ^3.trade ^3ID^7 ^3points^7 ^5zcoins^7 ^3save_slot^7 `);
                    return;
                }

                if(args[1] == Player.ClientId || args[1] == `@${Player.ClientId}`) {
                    Player.Tell(`^1You cannot trade with yourself^7.`);
                    return;
                }
                if(args[1] == "accept")
                {
                    await this.acceptTrade(Player) 
                }
                else if(args[1] == "refuse")
                {
                    await this.refuseTrade(Player)
                }
                else
                {
                    if (!args[4])
                    {
                        Player.Tell(`^1Invalid parameters^7. Usage : ^3.trade ^3ID^7 ^3points^7 ^5zcoins^7 ^3save_slot^7 ^`);
                        return
                    }
                    if (args[4] != "1" && args[4] != "2")
                    {
                        Player.Tell("^1Save slot incorrect^7 Use 1 or 2")
                        return
                    }
                    var Buyer = await this.Server.findClient(args[1].replace('@', ''))
                        
                    if (!Buyer) {
                        Player.Tell(`^3The buyer with the ID ${args[1]} is ^1not online^7.`);
                        return;
                    }
                    await this.createTrade(Player, Buyer, parseInt(args[2]), parseInt(args[3]), parseInt(args[4]));
                }
            }
        }

        this.Manager.commands['withdraw'] = {
            ArgumentLength: 1,
            Alias: 'w',
            logToAudit: false,
            Permission: Permissions.Commands.COMMAND_USER_CMDS,
            callback: async (Player, args) => {
        /*        if (!this.Server.isZM()) {
                    Player.Tell(Localization['COMMAND_UNAVAILABLE_GAMETYPE'])
                    return
                }*/

                if (Player.Data && Player.Data.lastWithdraw && (new Date() - Player.Data.lastWithdraw) / 1000 < 5) {
                    Player.Tell(Localization['COMMAND_COOLDOWN'])
                    return
                }

                var totalMoney = (await this.getZMStats(Player.ClientId)).Money
                if (totalMoney == undefined)
                {
                    Player.Tell("Error, zm_stats")
                    return
                }
                var gameMoney = parseInt(await Player.Server.Rcon.getDvar(`${Player.Clientslot}_money`))
                const canUseBank = await Player.Server.Rcon.getDvar(`${Player.Clientslot}_can_use_bank`)
                if (canUseBank == "2")
                {
                    Player.Tell("Bank disabled for Tournament server");
                    return
                }
                if (canUseBank == "3") {
                    Player.Tell("Cannot withdraw in this gamemode.");
                    return	
                }
        //        if (canUseBank == "0") {
         //           Player.Tell(Localization['ZBANK_DISABLED']);
          //          return
          //      }

                var withdrawMoney = args[1].toLocaleLowerCase() == 'all' 
                    ? Math.min(parseInt(totalMoney), maxGameMoney - gameMoney) 
                    : Math.min(parseInt(args[1]), maxGameMoney - gameMoney)
            
                switch (true) {
                    case (!Number.isInteger(withdrawMoney) || withdrawMoney < 0):
                        Player.Tell(Localization['ZBANK_PARSE_ERROR'])
                    return
                    case (totalMoney < withdrawMoney):
                        Player.Tell(Localization['ZBANK_BALANCE_ERROR']);
                    return
                }
                var result = await Player.Server.Rcon.executeCommandAsync(`set bank_withdraw ${Player.Guid};${withdrawMoney}`)
                if (result) {
                    Player.Tell(Utils.formatString(Localization['ZBANK_WITHDRAW_SUCCESS'], {
                        amount: withdrawMoney.toLocaleString()
                    }, '%')[0])

                    Player.Data.lastWithdraw = new Date()
                    this.setPlayerMoney(Player.ClientId, parseInt(totalMoney) - parseInt(withdrawMoney))

                    return
                }

                Player.Tell(Localization['ZBANK_WITHDRAW_FAIL'])
            }
        }

        this.Manager.commands['rankup'] = {
            ArgumentLength: 0,
            Alias: 'rkup',
            logToAudit: false,
            Permission: Permissions.Commands.COMMAND_USER_CMDS,
            callback: async (Player, args) => {
               /* if (!this.Server.isZM()) {
                    Player.Tell(Localization['COMMAND_UNAVAILABLE_GAMETYPE'])
                    return
                }*/
                if (Player.Data && Player.Data.lastWithdraw && (new Date() - Player.Data.lastWithdraw) / 1000 < 5) {
                    Player.Tell(Localization['COMMAND_COOLDOWN'])
                    return
                }
                var totalMoney = (await this.getZMStats(Player.ClientId)).Money
                if (totalMoney == undefined)
                {
                    Player.Tell("Error, zm_stats")
                    return
                }

		var customTag = await this.Server.DB.metaService.getPersistentMeta('custom_tag', Player.ClientId)
        var zcoins = await this.Server.DB.metaService.getPersistentMeta('zcoins', Player.ClientId)
        if (!zcoins || zcoins.value == "")
        {
            await this.Server.DB.metaService.addPersistentMeta('zcoins', "0", Player.ClientId)
            zcoins = await this.Server.DB.metaService.getPersistentMeta('zcoins', Player.ClientId)
        }        
        if (!customTag)
        {
            Player.Tell("Error")
            return;
        }

		var withdrawMoney = 100000000;
        var zcoinsCost = 0;
        var gamemodeClearNeeded = 0;
        var chadGamemodeClearNeeded = 0;
        var eeClearNeeded = 0;
        var saveRoundNeeded = 0;
        var titb_completion = 0;
        var pia_completion = 0;
        var botb_completion = 0;
        var gc_completion = 0;
        var first_room = 0;
        var oneshot = 0;
        var speedrun = 0;
        var spoon = 0;
        var hawk = 0;
        var hitless = 0;
        var melee = 0;

		if (customTag.Value == '^9F^7')
			withdrawMoney = 100000
		if (customTag.Value == '^8E^7')
			withdrawMoney = 200000
		if (customTag.Value == '^2D^7')
			withdrawMoney = 400000
		if (customTag.Value == '^4C^7')
			withdrawMoney = 1000000
		if (customTag.Value == '^5B^7')
			withdrawMoney = 2000000
		if (customTag.Value == '^6A^7')
			withdrawMoney = 5000000
        if (customTag.Value == '^3S^7')
			withdrawMoney = 10000000
        if (customTag.Value == '^3SS^7')
			withdrawMoney = 30000000
        if (customTag.Value == '^3SSS^7')
        {
            gamemodeClearNeeded = 1;
            eeClearNeeded = 2;
            saveRoundNeeded = 35;
            zcoinsCost = 200;
            withdrawMoney = 60000000
        }
        if (customTag.Value == '^6 I ^7')
        {
            gamemodeClearNeeded = 2;
            eeClearNeeded = 3
            saveRoundNeeded = 40;
            zcoinsCost = 300;
            withdrawMoney = 70000000
        }
        if (customTag.Value == '^6II^7')
        {
            gamemodeClearNeeded = 5;
            eeClearNeeded = 4;
            saveRoundNeeded = 45;
            zcoinsCost = 600;
            withdrawMoney = 80000000
        }
		if (customTag.Value == '^6III^7')
		{
            chadGamemodeClearNeeded = 2;
            gamemodeClearNeeded = 5;
            eeClearNeeded = 5;
            saveRoundNeeded = 50;
            zcoinsCost = 600;
            withdrawMoney = 90000000
		}
        if (customTag.Value == '^5IV^7')
        {
            chadGamemodeClearNeeded = 4;
            gamemodeClearNeeded = 5;
            eeClearNeeded = 6;
            saveRoundNeeded = 55;
            zcoinsCost = 650;
            withdrawMoney = 100000000
        }
        if (customTag.Value == '^5V^7')
        {
            chadGamemodeClearNeeded = 6;
            gamemodeClearNeeded = 5;
            eeClearNeeded = 8;
            saveRoundNeeded = 60;
            zcoinsCost = 700;
            withdrawMoney = 110000000
        }
        if (customTag.Value == '^5VI^7')
        {
            chadGamemodeClearNeeded = 10;
            gamemodeClearNeeded = 7;
            eeClearNeeded = 10;
            saveRoundNeeded = 65;
            zcoinsCost = 800;
            withdrawMoney = 150000000
        }
        if (customTag.Value == '^5VII^7')
        {
            gc_completion = 3;
            botb_completion = 1;
            spoon = 1;
            first_room = 1;
            melee = 1;
            saveRoundNeeded = 70;
            zcoinsCost = 2000;
            withdrawMoney = 300000000
        }
        if (customTag.Value == '^1IIX^7')
        {
            botb_completion = 3;
            pia_completion = 3;
          //  titb_completion = 2;
            hawk = 1;
            oneshot = 1;
            saveRoundNeeded = 80;
            zcoinsCost = 3000;
            withdrawMoney = 500000000
        }
        if (customTag.Value == '^1IX^7')
        {
            botb_completion = 5;
            pia_completion = 5;
         //   titb_completion = 3;
            hitless = 1;
            speedrun = 1;
            saveRoundNeeded = 100;
            zcoinsCost = 5000;
            withdrawMoney = 1000000000
        }
        if (customTag.Value == '^1-X-^7')
        {
            
			Player.Tell('You are already ^3max rank, what a ^5gamer^7 !');
			return;
        }

//---------------------------------------
    var isRequirementFullfilled = true;

        if (hitless != 0)
        {
            var botb_hitless = await this.Server.DB.metaService.getPersistentMeta('botb_hitless', Player.ClientId)
            if (!botb_hitless)
            {
                await this.Server.DB.metaService.addPersistentMeta('botb_hitless', "0", Player.ClientId)
                botb_hitless = await this.Server.DB.metaService.getPersistentMeta('botb_hitless', Player.ClientId) 
            }
            if (botb_hitless.Value != "1")
            {
                Player.Tell("^3Must complete BotB without ^5getting hit^3.")
                isRequirementFullfilled = false;
            }
        }
        if (speedrun != 0)
        {
            var ee_speedrun = await this.Server.DB.metaService.getPersistentMeta('ee_speedrun', Player.ClientId)
            if (!ee_speedrun)
            {
                await this.Server.DB.metaService.addPersistentMeta('ee_speedrun', "0", Player.ClientId)
                ee_speedrun = await this.Server.DB.metaService.getPersistentMeta('ee_speedrun', Player.ClientId) 
            }
            if (ee_speedrun.Value != "1")
            {
                Player.Tell("^3Must complete Origin EE in ^5under 30 mins^3.")
                isRequirementFullfilled = false;
            }
        }
        if (oneshot != 0)
        {
            var oneshot_50 = await this.Server.DB.metaService.getPersistentMeta('oneshot_50', Player.ClientId)
            if (!oneshot_50)
            {
                await this.Server.DB.metaService.addPersistentMeta('oneshot_50', "0", Player.ClientId)
                oneshot_50 = await this.Server.DB.metaService.getPersistentMeta('oneshot_50', Player.ClientId) 
            }
            if (oneshot_50.Value != "1")
            {
                Player.Tell("^3Must reach ^5round 50^7 in a non-loaded lobby.")
                isRequirementFullfilled = false;
            }
        }
        if (spoon != 0)
        {
            var golden_spork = await this.Server.DB.metaService.getPersistentMeta('golden_spork', Player.ClientId)
            if (!golden_spork)
            {
                await this.Server.DB.metaService.addPersistentMeta('golden_spork', "0", Player.ClientId)
                golden_spork = await this.Server.DB.metaService.getPersistentMeta('golden_spork', Player.ClientId) 
            }
            if (golden_spork.Value != "1")
            {
                Player.Tell("^3Must obtain the ^5Golden spoon^3 in MotD.")
                isRequirementFullfilled = false;
            }
        }
        if (hawk != 0)
        {
            var upgraded_tomahawk = await this.Server.DB.metaService.getPersistentMeta('upgraded_tomahawk', Player.ClientId)
            if (!upgraded_tomahawk)
            {
                await this.Server.DB.metaService.addPersistentMeta('upgraded_tomahawk', "0", Player.ClientId)
                upgraded_tomahawk = await this.Server.DB.metaService.getPersistentMeta('upgraded_tomahawk', Player.ClientId) 
            }
            if (upgraded_tomahawk.Value != "1")
            {
                Player.Tell("^3Must obtain the ^5Blue Tomahawk^3 in MotD.")
                isRequirementFullfilled = false;
            }
        }
        if (melee != 0)
        {
            var melee_only = await this.Server.DB.metaService.getPersistentMeta('melee_only', Player.ClientId)
            if (!melee_only)
            {
                await this.Server.DB.metaService.addPersistentMeta('melee_only', "0", Player.ClientId)
                melee_only = await this.Server.DB.metaService.getPersistentMeta('melee_only', Player.ClientId) 
            }
            if (melee_only.Value != "1")
            {
                Player.Tell("^3Must complete a full round with ^5melee only^3 over ^5Round 30^3.")
                isRequirementFullfilled = false;
            }
        }
        if (first_room != 0)
        {
            var first_room_30 = await this.Server.DB.metaService.getPersistentMeta('first_room_30', Player.ClientId)
            if (!first_room_30)
            {
                await this.Server.DB.metaService.addPersistentMeta('first_room_30', "0", Player.ClientId)
                first_room_30 = await this.Server.DB.metaService.getPersistentMeta('first_room_30', Player.ClientId) 
            }
            if (first_room_30.Value != "1")
            {
                Player.Tell("^3Must reach ^5Round 30^3 in ^5first room^3. (.fr)")
                isRequirementFullfilled = false;
            }
        }
        if (gc_completion != 0)
        {
            var gigachadGamemodeCount = await this.Server.DB.metaService.getPersistentMeta('gigachadGamemodeCount', Player.ClientId)
            if (!gigachadGamemodeCount)
            {
                await this.Server.DB.metaService.addPersistentMeta('gigachadGamemodeCount', "0", Player.ClientId)
                gigachadGamemodeCount = await this.Server.DB.metaService.getPersistentMeta('gigachadGamemodeCount', Player.ClientId)
            }
            if (parseInt(gigachadGamemodeCount.Value) < gc_completion)
            {
                Player.Tell("^3Not enough ^6Gigachad completion^3.")
                isRequirementFullfilled = false;
            }
        } 
        if (botb_completion != 0)
        {
            var botb_gc = await this.Server.DB.metaService.getPersistentMeta('botb_gc', Player.ClientId)
            if (!botb_gc)
            {
                await this.Server.DB.metaService.addPersistentMeta('botb_gc', "0", Player.ClientId)
                botb_gc = await this.Server.DB.metaService.getPersistentMeta('botb_gc', Player.ClientId)
            }
            if (parseInt(botb_gc.Value) < botb_completion)
            {
                Player.Tell("^3Not enough ^6BotB Gigachad^3 completion.")
                isRequirementFullfilled = false;
            }
        } 
        if (titb_completion != 0)
        {
            var titb_gc = await this.Server.DB.metaService.getPersistentMeta('titb_gc', Player.ClientId)
            if (!titb_gc)
            {
                await this.Server.DB.metaService.addPersistentMeta('titb_gc', "0", Player.ClientId)
                titb_gc = await this.Server.DB.metaService.getPersistentMeta('titb_gc', Player.ClientId)
            }
            if (parseInt(titb_gc.Value) < titb_completion)
            {
                Player.Tell("^3Not enough ^6TitB Gigachad^3 completion.")
                isRequirementFullfilled = false;
            }
        } 
        if (pia_completion != 0)
        {
            var pia_gc = await this.Server.DB.metaService.getPersistentMeta('pia_gc', Player.ClientId)
            if (!pia_gc)
            {
                await this.Server.DB.metaService.addPersistentMeta('pia_gc', "0", Player.ClientId)
                pia_gc = await this.Server.DB.metaService.getPersistentMeta('pia_gc', Player.ClientId)
            }
            if (parseInt(pia_gc.Value) < pia_completion)
            {
                Player.Tell("^3Not enough ^6PiA Gigachad^3 completion.")
                isRequirementFullfilled = false;
            }
        } 

        if (gamemodeClearNeeded != 0)
        {
            var gamemodeCount = await this.Server.DB.metaService.getPersistentMeta('gamemodeCount', Player.ClientId)
            if (!gamemodeCount)
            {
                await this.Server.DB.metaService.addPersistentMeta('gamemodeCount', "0", Player.ClientId)
                gamemodeCount = await this.Server.DB.metaService.getPersistentMeta('gamemodeCount', Player.ClientId)
            }
            var gamemodeCountInt = parseInt(gamemodeCount.Value);
            if(gamemodeCountInt < gamemodeClearNeeded)
            {
                Player.Tell(`^3Not enough ^2 Ez Gamemode^3 completions to ^6rank up^3 (^2${gamemodeCountInt}^3/^1${gamemodeClearNeeded}^3)`)
                isRequirementFullfilled = false;
            }
        }
        if (chadGamemodeClearNeeded != 0)
        {
            var chadGamemodeCount = await this.Server.DB.metaService.getPersistentMeta('chadGamemodeCount', Player.ClientId)
            if (!chadGamemodeCount)
            {
                await this.Server.DB.metaService.addPersistentMeta('chadGamemodeCount', "0", Player.ClientId)
                chadGamemodeCount = await this.Server.DB.metaService.getPersistentMeta('chadGamemodeCount', Player.ClientId)
            }
            var chadGamemodeCountInt = parseInt(chadGamemodeCount.Value);
            if(chadGamemodeCountInt < chadGamemodeClearNeeded)
            {
                Player.Tell(`^3Not enough ^1 Chad Gamemode^3 completions to ^6rank up^3 (^2${chadGamemodeCountInt}^3/^1${chadGamemodeClearNeeded}^3)`)
                isRequirementFullfilled = false;
            }
        }        
        if (eeClearNeeded != 0)
        {
            var eeCount = await this.Server.DB.metaService.getPersistentMeta('eeCount', Player.ClientId)
            if (!eeCount)
            {
                await this.Server.DB.metaService.addPersistentMeta('eeCount', "0", Player.ClientId)
                eeCount = await this.Server.DB.metaService.getPersistentMeta('eeCount', Player.ClientId)
            }
            var eeCountInt = parseInt(eeCount.Value)
            if(eeCountInt < eeClearNeeded)
            {
                Player.Tell(`^3Not enough ^5EE completions^3 to ^6rank up^3 (^2${eeCountInt}^3/^1${eeClearNeeded}^3)`)
                isRequirementFullfilled = false;
            }
        }
        var save1 = 0
        var save2 = 0
        if (saveRoundNeeded != 0)
        {
            var save = await this.Server.DB.metaService.getPersistentMeta('save', Player.ClientId)
            if (!save)
            {
                Player.Tell("Save error, contact staff")
                return;
            }
            save1 = parseInt(save.Value.split(';')[0])
            save2 = parseInt(save.Value.split(';')[1])
            var highestSave = 0
            if (save1 >= save2)
                highestSave = save1
            else
                highestSave = save2
            if (highestSave < saveRoundNeeded)
            {
                Player.Tell(`^3Your ^5highest save^3 is too low to ^6rank up^3 (^2${highestSave}^3/^1${saveRoundNeeded}^3)`)
                isRequirementFullfilled = false;
            }
        }
        if (totalMoney < withdrawMoney)
		{
            Player.Tell(`^3Not enough ^2Money^3 in your bank to ^6rank up^3 (^2${totalMoney}^3/^1${withdrawMoney}^3)`)
            isRequirementFullfilled = false
		}
        if (parseInt(zcoins.Value) < zcoinsCost)
		{
            Player.Tell(`^3Not enough ^5Z-Coins^3 in your bank to ^6rank up^3 (^2${zcoins.Value}^3/^1${zcoinsCost}^3)`)
            isRequirementFullfilled = false
		}
        if (isRequirementFullfilled == false)
        {
            return;
        }

        await this.Server.DB.metaService.addPersistentMeta('eeCount', "0", Player.ClientId) 
        await this.Server.DB.metaService.addPersistentMeta('gamemodeCount', "0", Player.ClientId) 
        await this.Server.DB.metaService.addPersistentMeta('chadGamemodeCount', "0", Player.ClientId)
        await this.Server.DB.metaService.addPersistentMeta('gigachadGamemodeCount', "0", Player.ClientId)
        await this.Server.DB.metaService.addPersistentMeta('pia_gc', "0", Player.ClientId)
        await this.Server.DB.metaService.addPersistentMeta('titb_gc', "0", Player.ClientId)
        await this.Server.DB.metaService.addPersistentMeta('botb_gc', "0", Player.ClientId)
        await this.Server.DB.metaService.addPersistentMeta('golden_spork', "0", Player.ClientId)
        await this.Server.DB.metaService.addPersistentMeta('first_room_30', "0", Player.ClientId)
        await this.Server.DB.metaService.addPersistentMeta('upgraded_tomahawk', "0", Player.ClientId)
        await this.Server.DB.metaService.addPersistentMeta('melee_only', "0", Player.ClientId)
        
        if (saveRoundNeeded != 0)
        {
            var slot = 0
            if (save1 < saveRoundNeeded && save2 >= saveRoundNeeded)
            {
                await this.Server.DB.metaService.addPersistentMeta('save', `${save1};0`, Player.ClientId) 
                slot = 2
            }
            else if (save2 < saveRoundNeeded && save1 >= saveRoundNeeded)
            {
                await this.Server.DB.metaService.addPersistentMeta('save', `0;${save2}`, Player.ClientId) 
                slot = 1
            }
            else if (save1 > save2)
            {
                await this.Server.DB.metaService.addPersistentMeta('save', `${save1};0`, Player.ClientId) 
                slot = 2
            }
            else 
            {
                await this.Server.DB.metaService.addPersistentMeta('save', `0;${save2}`, Player.ClientId) 
                slot = 1
            }


            Player.Tell("^5Lowest required save^3 consumed.")     
        }


        Player.Tell(Utils.formatString(Localization['ZBANK_WITHDRAW_SUCCESS'], {
            amount: withdrawMoney.toLocaleString()
        }, '%')[0])

        Player.Data.lastWithdraw = new Date()
        this.setPlayerMoney(Player.ClientId, parseInt(totalMoney) - parseInt(withdrawMoney))

        await this.Server.DB.metaService.addPersistentMeta('zcoins', parseInt(zcoins.Value) - zcoinsCost, Player.ClientId)
        if (zcoinsCost != 0)
        {
            Player.Tell(`^5${zcoinsCost} Z-Coins^3 have been withdrew from your bank account!`)
        }

		await this.Server.DB.metaService.deletePersistentMeta('custom_tag', Player.ClientId)
		if (customTag.Value == '^9F^7')
		{
			await this.Server.DB.metaService.addPersistentMeta('custom_tag', "^8E^7", Player.ClientId)
			Player.Tell('Your ^3point multiplier^7 is now : ^3x3')
			Player.Tell('Successfully ^3ranked up^7 to : ^8E Rank^7 ! ^1GG')
		}
		else if (customTag.Value == '^8E^7')
		{
			await this.Server.DB.metaService.addPersistentMeta('custom_tag', "^2D^7", Player.ClientId)
			Player.Tell('Your ^3point multiplier^7 is now : ^3x3')
			Player.Tell('Successfully ^3ranked up^7 to : ^2D Rank^7 ! ^1GG')
		}
		else if (customTag.Value == '^2D^7')
		{
			await this.Server.DB.metaService.addPersistentMeta('custom_tag', "^4C^7", Player.ClientId)
			Player.Tell('Your ^3point multiplier^7 is now : ^3x4')
			Player.Tell('Successfully ^3ranked up^7 to : ^4C Rank^7 ! ^1GG')
		}
		else if (customTag.Value == '^4C^7')
		{
			await this.Server.DB.metaService.addPersistentMeta('custom_tag', "^5B^7", Player.ClientId)
			Player.Tell('Your ^3point multiplier^7 is now : ^3x4')
			Player.Tell('Successfully ^3ranked up^7 to : ^5B Rank^7 ! ^1GG')
		}
		else if (customTag.Value == '^5B^7')
		{
			await this.Server.DB.metaService.addPersistentMeta('custom_tag', "^6A^7", Player.ClientId)
			Player.Tell('Your ^3point multiplier^7 is now : ^3x5')
			Player.Tell('Successfully ^3ranked up^7 to : ^6A Rank^7 ! ^1GG')
		}
		else if (customTag.Value == '^6A^7')
		{
			await this.Server.DB.metaService.addPersistentMeta('custom_tag', "^3S^7", Player.ClientId)
			Player.Tell('Your ^3point multiplier^7 is now : ^3x6')
			Player.Tell('Successfully ^3ranked up^7 to : ^3S Rank^7 ! ^1GG')
		}
        else if (customTag.Value == '^3S^7')
		{
			await this.Server.DB.metaService.addPersistentMeta('custom_tag', "^3SS^7", Player.ClientId)
			Player.Tell('Your ^3point multiplier^7 is now : ^3x7')
			Player.Tell('Successfully ^3ranked up^7 to : ^3SS Rank^7 ! ^1GG')
		}
        else if (customTag.Value == '^3SS^7')
		{
			await this.Server.DB.metaService.addPersistentMeta('custom_tag', "^3SSS^7", Player.ClientId)
			Player.Tell('Your ^3point multiplier^7 is now : ^3x9')
			Player.Tell('Successfully ^3ranked up^7 to : ^3SSS Rank^7 ! ^1GG')
		}
        else if (customTag.Value == '^3SSS^7')
		{
			await this.Server.DB.metaService.addPersistentMeta('custom_tag', "^6 I ^7", Player.ClientId)
			Player.Tell('Your ^3point multiplier^7 is now : ^3x9')
			Player.Tell('Successfully ^3ranked up^7 to : ^6I^7 Rank^7 ! ^1GG')
		}
        else if (customTag.Value == '^6 I ^7')
		{
			await this.Server.DB.metaService.addPersistentMeta('custom_tag', "^6II^7", Player.ClientId)
			Player.Tell('Your ^3point multiplier^7 is now : ^3x10')
            Player.Tell('Your ^5z-coins multiplier^7 has increased !')
			Player.Tell('Successfully ^3ranked up^7 to : ^6II^7 Rank^7 ! ^1GG')
		}
        else if (customTag.Value == '^6II^7')
		{
			await this.Server.DB.metaService.addPersistentMeta('custom_tag', "^6III^7", Player.ClientId)
			Player.Tell('Your ^3point multiplier^7 is now : ^3x11')
            Player.Tell('Your ^5z-coins multiplier^7 has increased !')
			Player.Tell('Successfully ^3ranked up^7 to : ^6III^7 Rank^7 ! ^1GG')
		}
        else if (customTag.Value == '^6III^7')
		{
			await this.Server.DB.metaService.addPersistentMeta('custom_tag', "^5IV^7", Player.ClientId)
			Player.Tell('Your ^3point multiplier^7 is now : ^3x12')
            Player.Tell('Your ^5z-coins multiplier^7 has increased !')
			Player.Tell('Successfully ^3ranked up^7 to : ^5IV^7 Rank^7 ! ^1GG')
		}
        else if (customTag.Value == '^5IV^7')
		{
			await this.Server.DB.metaService.addPersistentMeta('custom_tag', "^5V^7", Player.ClientId)
			Player.Tell('Your ^3point multiplier^7 is now : ^3x13')
            Player.Tell('Your ^5z-coins multiplier^7 has increased !')
			Player.Tell('Successfully ^3ranked up^7 to : ^5V^7 Rank^7 ! ^1GG')
		}
        else if (customTag.Value == '^5V^7')
		{
			await this.Server.DB.metaService.addPersistentMeta('custom_tag', "^5VI^7", Player.ClientId)
			Player.Tell('Your ^3point multiplier^7 is now : ^3x13')
            Player.Tell('Your ^5z-coins multiplier^7 has increased !')
			Player.Tell('Successfully ^3ranked up^7 to : ^5VI^7 Rank^7 ! ^1GG')
		}
        else if (customTag.Value == '^5VI^7')
		{
			await this.Server.DB.metaService.addPersistentMeta('custom_tag', "^5VII^7", Player.ClientId)

			Player.Tell('Your ^3point multiplier^7 is now : ^3x13')
            Player.Tell('Your ^5z-coins multiplier^7 has increased !')
			Player.Tell('Successfully ^3ranked up^7 to : ^5VI^7 Rank^7 ! ^1GG')
		}
        else if (customTag.Value == '^5VII^7')
		{
			await this.Server.DB.metaService.addPersistentMeta('custom_tag', "^1IIX^7", Player.ClientId)
			Player.Tell('Your ^3point multiplier^7 is now : ^3x14')
            Player.Tell('Your ^5z-coins multiplier^7 has increased !')
			Player.Tell('Successfully ^3ranked up^7 to : "^1IIX^7" Rank^7 ! ^1GG')
		}
        else if (customTag.Value == '^1IIX^7')
		{
			await this.Server.DB.metaService.addPersistentMeta('custom_tag', "^1IX^7", Player.ClientId)
			Player.Tell('Your ^3point multiplier^7 is now : ^3x15')
            Player.Tell('Your ^5z-coins multiplier^7 has increased !')
			Player.Tell('Successfully ^3ranked up^7 to : "^1IX^7" Rank^7 ! ^1GG')
		}
        else if (customTag.Value == '^1IX^7')
		{
			await this.Server.DB.metaService.addPersistentMeta('custom_tag', "^1-X-^7", Player.ClientId)
			Player.Tell('Your ^3point multiplier^7 is now : ^3x15')
            Player.Tell('Your ^5z-coins multiplier^7 has increased !')
			Player.Tell('Successfully ^3ranked up^7 to : "^1-X-^7" Rank^7 ! ^1GG')
		}
        else if (customTag.Value == '^1-X-^7')
		{
            Player.Tell("This shouldn't happen")
		}
        
        this.Managers.forEach(manager =>
            {
                if (manager)
                {
                    this.checkForLoadedSave(manager, Player.ClientId, slot)
                }
            })
        
		var role = Utils.getRoleFrom(Player.PermissionLevel, 1).Name
       		var customTag = await this.Server.DB.metaService.getPersistentMeta('custom_tag', Player.ClientId)
       		role = customTag ? customTag.Value : Utils.stripString(role)
       		this.Server.Rcon.executeCommandAsync(`setclantagraw ${Player.Clientslot} "${role}"`)

            var val = await this.Server.DB.metaService.getPersistentMeta('custom_tag', Player.ClientId)
            this.Managers.forEach(manager =>
                {
                    if (manager)
                    {
                        manager.Server.Rcon.executeCommandAsync(`set bold ^1[Announcement] ^5${Player.Name}^7 Ranked up to ${customTag.Value}^7, use ^2.rank^7 `)
                    }
                })
            	
	}
}

this.Manager.commands['drop'] = {
    ArgumentLength: 0,
    Alias: 'dr',
    logToAudit: false,
    Permission: Permissions.Commands.COMMAND_USER_CMDS,
    callback: async (Player, args) => {
       /* if (!this.Server.isZM()) {
            Player.Tell(Localization['COMMAND_UNAVAILABLE_GAMETYPE'])
            return
        }*/
        if (Player.Data && Player.Data.lastDrop && (new Date() - Player.Data.lastDrop) / 1000 < 10) {
            Player.Tell(Localization['COMMAND_COOLDOWN'])
            return
        }

            Player.Data.lastDrop = new Date()
            var customName = await this.Server.DB.metaService.getPersistentMeta('custom_name', Player.ClientId)

            if (customName && customName.Value != "" && (customName.Value.includes('[^2VIP') || customName.Value.includes('[^3VIP') || customName.Value.includes('^3[VIP') || customName.Value.includes('^1')
            || customName.Value.includes('^6[VIP') || customName.Value.includes('[^6VIP^7')))
            {
                await Player.Server.Rcon.executeCommandAsync(`set drop ${Player.Guid};1`)
            }
            else
            {
                var customTag = await this.Server.DB.metaService.getPersistentMeta('custom_tag', Player.ClientId)
                if (customTag && (customTag.Value == "^9F^7" || customTag.Value == "^8E^7" || customTag.Value == "^2D^7"
                || customTag.Value == "^4C^7" || customTag.Value == "^5B^7"))
                {
                    Player.Tell("^6A+^7 rank only^7 command only.")
                    return
                }
                await Player.Server.Rcon.executeCommandAsync(`set drop ${Player.Guid};1`)
                return
            }
    }
}

this.Manager.commands['flex'] = {
    ArgumentLength: 0,
    Alias: 'flex',
    logToAudit: false,
    Permission: Permissions.Commands.COMMAND_USER_CMDS,
    callback: async (Player, args) => {
        /*if (!this.Server.isZM()) {
            Player.Tell(Localization['COMMAND_UNAVAILABLE_GAMETYPE'])
            return
        }*/
        if (Player.Data && Player.Data.lastFlex && (new Date() - Player.Data.lastFlex) / 1000 < 10) {
            Player.Tell(Localization['COMMAND_COOLDOWN'])
            return
        }
        var save = await this.Server.DB.metaService.getPersistentMeta('save', Player.ClientId)
        if (!save)
        {
            await this.Server.DB.metaService.addPersistentMeta('save', '0;0', Player.ClientId)
            zcoins = await this.Server.DB.metaService.getPersistentMeta('save', Player.ClientId)
        }
        if (Player.Data)
            Player.Data.lastFlex = new Date()
        var health = await this.Server.DB.metaService.getPersistentMeta('hp', Player.ClientId)
        var speed = await this.Server.DB.metaService.getPersistentMeta('speed', Player.ClientId)
        var customName = await this.Server.DB.metaService.getPersistentMeta('custom_name', Player.ClientId)
        var customTag = await this.Server.DB.metaService.getPersistentMeta('custom_tag', Player.ClientId)
        var zcoins = await this.Server.DB.metaService.getPersistentMeta('zcoins', Player.ClientId)
        if (!zcoins)
        {
            await this.Server.DB.metaService.addPersistentMeta('zcoins', '0', Player.ClientId)
            zcoins = await this.Server.DB.metaService.getPersistentMeta('zcoins', Player.ClientId)
        }
        var totalMoney = (await this.getZMStats(Player.ClientId)).Money
        if (totalMoney == undefined)
        {
            Player.Tell("Error, zm_stats")
            return
        }
        var hp = 250

        if (customName)
        {
            if (customName.Value.includes('[^2VIP') || customName.Value.includes('^3VIP') || customName.Value.includes('^3[VIP')
            || customName.Value.includes('^6[VIP') || customName.Value.includes('[^6VIP')
            || customName.Value.includes('^1[VIP') || customName.Value.includes('[^1VIP'))
                hp += 50
        }
        hp += parseInt(health.Value)
        var percentspeed = 0
        if (speed.Value == "1")
            percentspeed = 0
        else if (speed.Value == "1.01")
            percentspeed = 1
        else if (speed.Value == "1.02")
            percentspeed = 2
        else if (speed.Value == "1.03")
            percentspeed = 3
        else if (speed.Value == "1.04")
            percentspeed = 4
        else if (speed.Value == "1.05")
            percentspeed = 5
        else if (speed.Value == "1.06")
            percentspeed = 6
        else if (speed.Value == "1.07")
            percentspeed = 7
        else if (speed.Value == "1.08")
            percentspeed = 8
        else if (speed.Value == "1.09")
            percentspeed = 9
        else if (speed.Value == "1.10")
            percentspeed = 10
        
        var customName = await this.Server.DB.metaService.getPersistentMeta('custom_name', Player.ClientId)
        this.Managers.forEach(manager =>
            {
                if (manager)
                {
                    this.display_flex(manager, customTag, customName, totalMoney, zcoins, hp, percentspeed, save, Player)
                }

            })
    }
}

    this.Manager.commands['buy'] = {
        ArgumentLength: 0,
        Alias: 'buy',
        logToAudit: false,
        Permission: Permissions.Commands.COMMAND_USER_CMDS,
        callback: async (Player, args) => {
            /*if (!this.Server.isZM()) {
                Player.Tell(Localization['COMMAND_UNAVAILABLE_GAMETYPE'])
                return
            }*/
            if (Player.Data && Player.Data.lastWithdraw && (new Date() - Player.Data.lastWithdraw) / 1000 < 3) {
                Player.Tell(Localization['COMMAND_COOLDOWN'])
                return
            }

            //-----------------------------------HP-------------------------------------------------------------
            if (args[1] && args[1].toLocaleLowerCase() == 'hp')
            {
          /*      var customName = await this.Server.DB.metaService.getPersistentMeta('custom_name', Player.ClientId)
                if (customName)
                {
                    if (customName && customName.Value != "" && customName.Value.includes('^1'))
                    {
                    }
                    else
                    {
                        Player.Tell('Admins only.')
                        return
                    }
                }*/



                var totalMoney = (await this.getZMStats(Player.ClientId)).Money
                if (totalMoney == undefined)
                {
                    Player.Tell("Error, zm_stats")
                    return
                }

                var stats = await this.Server.DB.metaService.getPersistentMeta('hp', Player.ClientId)
                var customTag = await this.Server.DB.metaService.getPersistentMeta('custom_tag', Player.ClientId)
                if (!stats)
                {
                    Player.Tell("Error#005, contact admin")
                    return
                }
                var withdrawMoney = 99999999999
                console.log("stats value is %s", stats.Value )
                if (stats.Value == "0" && (customTag.Value == "^9F^7" || customTag.Value == "^8E^7" || customTag.Value == "^2D^7"
                || customTag.Value == "^4C^7" || customTag.Value == "^5B^7" || customTag.Value == "^6A^7"
                || customTag.Value == "^3S^7" || customTag.Value == "^3SS^7" || customTag.Value == "^3SSS^7"
                || customTag.Value == "^6 I ^7" || customTag.Value == "^6II^7" || customTag.Value == "^6III^7"
                || customTag.Value == "^5IV^7" || customTag.Value == "^5V^7" || customTag.Value == "^5VI^7" || customTag.Value == "^5VII^7"
                || customTag.Value == "^1IIX^7" || customTag.Value == "^1IX^7" || customTag.Value == "^1-X-^7"))
                    withdrawMoney = 10000
                else if (stats.Value == "10" && (customTag.Value == "^9F^7" || customTag.Value == "^8E^7" || customTag.Value == "^2D^7"
                || customTag.Value == "^4C^7" || customTag.Value == "^5B^7" || customTag.Value == "^6A^7"
                || customTag.Value == "^3S^7" || customTag.Value == "^3SS^7" || customTag.Value == "^3SSS^7"
                || customTag.Value == "^6 I ^7" || customTag.Value == "^6II^7" || customTag.Value == "^6III^7"
                || customTag.Value == "^5IV^7" || customTag.Value == "^5V^7" || customTag.Value == "^5VI^7" || customTag.Value == "^5VII^7"
                || customTag.Value == "^1IIX^7" || customTag.Value == "^1IX^7" || customTag.Value == "^1-X-^7"))
                    withdrawMoney = 50000                    
                else if (stats.Value == "20" && (customTag.Value == "^8E^7" || customTag.Value == "^2D^7"
                || customTag.Value == "^4C^7" || customTag.Value == "^5B^7" || customTag.Value == "^6A^7"
                || customTag.Value == "^3S^7" || customTag.Value == "^3SS^7" || customTag.Value == "^3SSS^7"
                || customTag.Value == "^6 I ^7" || customTag.Value == "^6II^7" || customTag.Value == "^6III^7"
                || customTag.Value == "^5IV^7" || customTag.Value == "^5V^7" || customTag.Value == "^5VI^7" || customTag.Value == "^5VII^7"
                || customTag.Value == "^1IIX^7" || customTag.Value == "^1IX^7" || customTag.Value == "^1-X-^7"))
                    withdrawMoney = 100000
                else if (stats.Value == "30" && (customTag.Value == "^2D^7"
                || customTag.Value == "^4C^7" || customTag.Value == "^5B^7" || customTag.Value == "^6A^7"
                || customTag.Value == "^3S^7" || customTag.Value == "^3SS^7" || customTag.Value == "^3SSS^7"
                || customTag.Value == "^6 I ^7" || customTag.Value == "^6II^7" || customTag.Value == "^6III^7"
                || customTag.Value == "^5IV^7" || customTag.Value == "^5V^7" || customTag.Value == "^5VI^7" || customTag.Value == "^5VII^7"
                || customTag.Value == "^1IIX^7" || customTag.Value == "^1IX^7" || customTag.Value == "^1-X-^7"))
                    withdrawMoney = 200000
                else if (stats.Value == "40" && (customTag.Value == "^4C^7" || customTag.Value == "^5B^7" || customTag.Value == "^6A^7"
                || customTag.Value == "^3S^7" || customTag.Value == "^3SS^7" || customTag.Value == "^3SSS^7"
                || customTag.Value == "^6 I ^7" || customTag.Value == "^6II^7" || customTag.Value == "^6III^7"
                || customTag.Value == "^5IV^7" || customTag.Value == "^5V^7" || customTag.Value == "^5VI^7" || customTag.Value == "^5VII^7"
                || customTag.Value == "^1IIX^7" || customTag.Value == "^1IX^7" || customTag.Value == "^1-X-^7"))
                    withdrawMoney = 1000000
                else if (stats.Value == "50" && (customTag.Value == "^5B^7" || customTag.Value == "^6A^7"
                || customTag.Value == "^3S^7" || customTag.Value == "^3SS^7" || customTag.Value == "^3SSS^7"
                || customTag.Value == "^6 I ^7" || customTag.Value == "^6II^7" || customTag.Value == "^6III^7"
                || customTag.Value == "^5IV^7" || customTag.Value == "^5V^7" || customTag.Value == "^5VI^7" || customTag.Value == "^5VII^7"
                || customTag.Value == "^1IIX^7" || customTag.Value == "^1IX^7" || customTag.Value == "^1-X-^7"))
                    withdrawMoney = 2000000
                else if (stats.Value == "60" && (customTag.Value == "^6A^7"
                || customTag.Value == "^3S^7" || customTag.Value == "^3SS^7" || customTag.Value == "^3SSS^7"
                || customTag.Value == "^6 I ^7" || customTag.Value == "^6II^7" || customTag.Value == "^6III^7"
                || customTag.Value == "^5IV^7" || customTag.Value == "^5V^7" || customTag.Value == "^5VI^7" || customTag.Value == "^5VII^7"
                || customTag.Value == "^1IIX^7" || customTag.Value == "^1IX^7" || customTag.Value == "^1-X-^7"))
                    withdrawMoney = 4000000
                else if (stats.Value == "70" && (customTag.Value == "^3S^7" || customTag.Value == "^3SS^7" || customTag.Value == "^3SSS^7"
                || customTag.Value == "^6 I ^7" || customTag.Value == "^6II^7" || customTag.Value == "^6III^7"
                || customTag.Value == "^5IV^7" || customTag.Value == "^5V^7" || customTag.Value == "^5VI^7" || customTag.Value == "^5VII^7"
                || customTag.Value == "^1IIX^7" || customTag.Value == "^1IX^7" || customTag.Value == "^1-X-^7"))
                    withdrawMoney = 8000000
                else if (stats.Value == "80" && (customTag.Value == "^3SS^7" || customTag.Value == "^3SSS^7"
                || customTag.Value == "^6 I ^7" || customTag.Value == "^6II^7" || customTag.Value == "^6III^7"
                || customTag.Value == "^5IV^7" || customTag.Value == "^5V^7" || customTag.Value == "^5VI^7" || customTag.Value == "^5VII^7"
                || customTag.Value == "^1IIX^7" || customTag.Value == "^1IX^7" || customTag.Value == "^1-X-^7"))
                    withdrawMoney = 16000000
                else if (stats.Value == "90" && (customTag.Value == "^3SSS^7"
                || customTag.Value == "^6 I ^7" || customTag.Value == "^6II^7" || customTag.Value == "^6III^7"
                || customTag.Value == "^5IV^7" || customTag.Value == "^5V^7" || customTag.Value == "^5VI^7" || customTag.Value == "^5VII^7"
                || customTag.Value == "^1IIX^7" || customTag.Value == "^1IX^7" || customTag.Value == "^1-X-^7"))
                    withdrawMoney = 32000000
                else
                {
                    Player.Tell("You do not have the required rank to make that purchase. use ^7.buy for info")
                    return;
                }
                if (stats.Value == "100")
                {
                    Player.Tell('Your ^1HP^7 is maxed out.');
                    return;
                }

                if (totalMoney < withdrawMoney)
                {
                    Player.Tell('Not enough money in bank to buy HP, use ^3.buy^7 to see buying cost.')
                    return
                }
   
                Player.Tell(Utils.formatString(Localization['ZBANK_WITHDRAW_SUCCESS'], {
                    amount: withdrawMoney.toLocaleString()
                }, '%')[0])

                this.setPlayerMoney(Player.ClientId, parseInt(totalMoney) - parseInt(withdrawMoney))
                Player.Data.lastWithdraw = new Date()

                if (stats.Value == "0")
                    stats.Value = "10"
                else if (stats.Value == "10")
                    stats.Value = "20"
                else if (stats.Value == "20")
                    stats.Value = "30"
                else if (stats.Value == "30")
                    stats.Value = "40"
                else if (stats.Value == "40")
                    stats.Value = "50"
                else if (stats.Value == "50")
                    stats.Value = "60"
                else if (stats.Value == "60")
                    stats.Value = "70"
                else if (stats.Value == "70")
                    stats.Value = "80"
                else if (stats.Value == "80")
                    stats.Value = "90"
                else if (stats.Value == "90")
                    stats.Value = "100"
                else
                {
                    Player.Tell("Error#006, Contact admin")
                }

                var hp = parseInt(stats.Value);
                if (customName && customName.Value != "" && (customName.Value.includes('[^2VIP') || customName.Value.includes('[^3VIP') || customName.Value.includes('^3[VIP')
                || customName.Value.includes('^6[VIP') || customName.Value.includes('[^6VIP')))
                {
                    hp += 50;
                }

                await Player.Server.Rcon.executeCommandAsync(`set hp ${Player.Guid};${hp}`)
                await this.Server.DB.metaService.deletePersistentMeta('hp', Player.ClientId)
                await this.Server.DB.metaService.addPersistentMeta('hp', stats.Value, Player.ClientId)
                this.Managers.forEach(manager =>
                    {
                        if (manager)
                        {
                            manager.Server.Rcon.executeCommandAsync(`set bold ^1[Announcement] ^5${Player.Name}^7 Leveled his ^1HP ^7to ^3${hp}^7, use ^2.buy^7 `)
                        }
    
                    })

                Player.Tell(`You now have ^3${hp} ^7extra ^1HP !`)
            }
            //-----------------------------------HP-------------------------------------------------------------
            //-----------------------------------SPEED-------------------------------------------------------------
            else if(args[1] && args[1].toLocaleLowerCase() == 'speed')
            {
                var totalMoney = (await this.getZMStats(Player.ClientId)).Money
                if (totalMoney == undefined)
                {
                    Player.Tell("Error, zm_stats")
                    return
                }
        
                var stats = await this.Server.DB.metaService.getPersistentMeta('speed', Player.ClientId)
                var customTag = await this.Server.DB.metaService.getPersistentMeta('custom_tag', Player.ClientId)
                if (!stats)
                {
                    Player.Tell("Error#005, contact admin")
                    return
                }
                var withdrawMoney = 100000000
                console.log("stats value is %s", stats.Value )
                if (stats.Value == "1" && (customTag.Value == "^9F^7" || customTag.Value == "^8E^7" || customTag.Value == "^2D^7"
                || customTag.Value == "^4C^7" || customTag.Value == "^5B^7" || customTag.Value == "^6A^7"
                || customTag.Value == "^3S^7" || customTag.Value == "^3SS^7" || customTag.Value == "^3SSS^7"
                || customTag.Value == "^6 I ^7" || customTag.Value == "^6II^7" || customTag.Value == "^6III^7"
                || customTag.Value == "^5IV^7" || customTag.Value == "^5V^7" || customTag.Value == "^5VI^7" || customTag.Value == "^5VII^7"
                || customTag.Value == "^1IIX^7" || customTag.Value == "^1IX^7" || customTag.Value == "^1-X-^7"))
                    withdrawMoney = 10000
                else if (stats.Value == "1.01" && (customTag.Value == "^9F^7" || customTag.Value == "^8E^7" || customTag.Value == "^2D^7"
                || customTag.Value == "^4C^7" || customTag.Value == "^5B^7" || customTag.Value == "^6A^7"
                || customTag.Value == "^3S^7" || customTag.Value == "^3SS^7" || customTag.Value == "^3SSS^7"
                || customTag.Value == "^6 I ^7" || customTag.Value == "^6II^7" || customTag.Value == "^6III^7"
                || customTag.Value == "^5IV^7" || customTag.Value == "^5V^7" || customTag.Value == "^5VI^7" || customTag.Value == "^5VII^7"
                || customTag.Value == "^1IIX^7" || customTag.Value == "^1IX^7" || customTag.Value == "^1-X-^7"))
                    withdrawMoney = 50000                    
                else if (stats.Value == "1.02" && (customTag.Value == "^8E^7" || customTag.Value == "^2D^7"
                || customTag.Value == "^4C^7" || customTag.Value == "^5B^7" || customTag.Value == "^6A^7"
                || customTag.Value == "^3S^7" || customTag.Value == "^3SS^7" || customTag.Value == "^3SSS^7"
                || customTag.Value == "^6 I ^7" || customTag.Value == "^6II^7" || customTag.Value == "^6III^7"
                || customTag.Value == "^5IV^7" || customTag.Value == "^5V^7" || customTag.Value == "^5VI^7" || customTag.Value == "^5VII^7"
                || customTag.Value == "^1IIX^7" || customTag.Value == "^1IX^7" || customTag.Value == "^1-X-^7"))
                    withdrawMoney = 100000
                else if (stats.Value == "1.03" && (customTag.Value == "^2D^7"
                || customTag.Value == "^4C^7" || customTag.Value == "^5B^7" || customTag.Value == "^6A^7"
                || customTag.Value == "^3S^7" || customTag.Value == "^3SS^7" || customTag.Value == "^3SSS^7"
                || customTag.Value == "^6 I ^7" || customTag.Value == "^6II^7" || customTag.Value == "^6III^7"
                || customTag.Value == "^5IV^7" || customTag.Value == "^5V^7" || customTag.Value == "^5VI^7" || customTag.Value == "^5VII^7"
                || customTag.Value == "^1IIX^7" || customTag.Value == "^1IX^7" || customTag.Value == "^1-X-^7"))
                    withdrawMoney = 200000
                else if (stats.Value == "1.04" && (customTag.Value == "^4C^7" || customTag.Value == "^5B^7" || customTag.Value == "^6A^7"
                || customTag.Value == "^3S^7" || customTag.Value == "^3SS^7" || customTag.Value == "^3SSS^7"
                || customTag.Value == "^6 I ^7" || customTag.Value == "^6II^7" || customTag.Value == "^6III^7"
                || customTag.Value == "^5IV^7" || customTag.Value == "^5V^7" || customTag.Value == "^5VI^7" || customTag.Value == "^5VII^7"
                || customTag.Value == "^1IIX^7" || customTag.Value == "^1IX^7" || customTag.Value == "^1-X-^7"))
                    withdrawMoney = 1000000
                else if (stats.Value == "1.05" && (customTag.Value == "^5B^7" || customTag.Value == "^6A^7"
                || customTag.Value == "^3S^7" || customTag.Value == "^3SS^7" || customTag.Value == "^3SSS^7" 
                || customTag.Value == "^6 I ^7" || customTag.Value == "^6II^7" || customTag.Value == "^6III^7"
                || customTag.Value == "^5IV^7" || customTag.Value == "^5V^7" || customTag.Value == "^5VI^7" || customTag.Value == "^5VII^7"
                || customTag.Value == "^1IIX^7" || customTag.Value == "^1IX^7" || customTag.Value == "^1-X-^7"))
                    withdrawMoney = 2000000
                else if (stats.Value == "1.06" && (customTag.Value == "^6A^7"
                || customTag.Value == "^3S^7" || customTag.Value == "^3SS^7" || customTag.Value == "^3SSS^7" 
                || customTag.Value == "^6 I ^7" || customTag.Value == "^6II^7" || customTag.Value == "^6III^7"
                || customTag.Value == "^5IV^7" || customTag.Value == "^5V^7" || customTag.Value == "^5VI^7" || customTag.Value == "^5VII^7"
                || customTag.Value == "^1IIX^7" || customTag.Value == "^1IX^7" || customTag.Value == "^1-X-^7"))
                    withdrawMoney = 4000000
                else if (stats.Value == "1.07" && (customTag.Value == "^3S^7" || customTag.Value == "^3SS^7" || customTag.Value == "^3SSS^7"
                || customTag.Value == "^6 I ^7" || customTag.Value == "^6II^7" || customTag.Value == "^6III^7"
                || customTag.Value == "^5IV^7" || customTag.Value == "^5V^7" || customTag.Value == "^5VI^7" || customTag.Value == "^5VII^7"
                || customTag.Value == "^1IIX^7" || customTag.Value == "^1IX^7" || customTag.Value == "^1-X-^7"))
                    withdrawMoney = 8000000
                else if (stats.Value == "1.08" && (customTag.Value == "^3SS^7" || customTag.Value == "^3SSS^7"
                || customTag.Value == "^6 I ^7" || customTag.Value == "^6II^7" || customTag.Value == "^6III^7"
                || customTag.Value == "^5IV^7" || customTag.Value == "^5V^7" || customTag.Value == "^5VI^7" || customTag.Value == "^5VII^7"
                || customTag.Value == "^1IIX^7" || customTag.Value == "^1IX^7" || customTag.Value == "^1-X-^7"))
                    withdrawMoney = 16000000
                else if (stats.Value == "1.09" && (customTag.Value == "^3SSS^7"
                || customTag.Value == "^6 I ^7" || customTag.Value == "^6II^7" || customTag.Value == "^6III^7"
                || customTag.Value == "^5IV^7" || customTag.Value == "^5V^7" || customTag.Value == "^5VI^7" || customTag.Value == "^5VII^7"
                || customTag.Value == "^1IIX^7" || customTag.Value == "^1IX^7" || customTag.Value == "^1-X-^7"))
                    withdrawMoney = 32000000
                else if (stats.Value == "1.10")
                {
                    Player.Tell('Your ^2Speed^7 is maxed out.');
                    return;
                }
                 
                if (totalMoney < withdrawMoney)
                {
                        Player.Tell("You do not have the required money/rank to make that purchase. use ^7.buy for info")
                        return;
                }
   
                Player.Tell(Utils.formatString(Localization['ZBANK_WITHDRAW_SUCCESS'], {
                    amount: withdrawMoney.toLocaleString()
                }, '%')[0])

                this.setPlayerMoney(Player.ClientId, parseInt(totalMoney) - parseInt(withdrawMoney))
   //             Player.Data.lastWithdraw = new Date()

                if (stats.Value == "1")
                    stats.Value = "1.01"
                else if (stats.Value == "1.01")
                    stats.Value = "1.02"
                else if (stats.Value == "1.02")
                    stats.Value = "1.03"
                else if (stats.Value == "1.03")
                    stats.Value = "1.04"
                else if (stats.Value == "1.04")
                    stats.Value = "1.05"
                else if (stats.Value == "1.05")
                    stats.Value = "1.06"
                else if (stats.Value == "1.06")
                    stats.Value = "1.07"
                else if (stats.Value == "1.07")
                    stats.Value = "1.08"
                else if (stats.Value == "1.08")
                    stats.Value = "1.09"
                else if (stats.Value == "1.09")
                    stats.Value = "1.10"
                else
                {
                    Player.Tell("Error#006, Contact admin")
                }

                var speed = parseFloat(stats.Value);
                await Player.Server.Rcon.executeCommandAsync(`set speed ${Player.Guid};${speed}`)
                await this.Server.DB.metaService.deletePersistentMeta('speed', Player.ClientId)
                await this.Server.DB.metaService.addPersistentMeta('speed', stats.Value, Player.ClientId)

                this.Managers.forEach(manager =>
                    {
                        if (manager)
                        {
                            manager.Server.Rcon.executeCommandAsync(`set bold ^1[Announcement] ^5${Player.Name}^7 Leveled his ^2Speed ^7to ^3${speed}^7, use ^2.buy^7 `)
                        }
    
                    })

                Player.Tell(`You now have ^3${speed} ^7extra ^2Speed !`)
            }
            //-----------------------------------SPEED-------------------------------------------------------------
            //-----------------------------------INFO-------------------------------------------------------------
            else
            {
                Player.Data.lastWithdraw = new Date()
                var health = await this.Server.DB.metaService.getPersistentMeta('hp', Player.ClientId)
                var speed = await this.Server.DB.metaService.getPersistentMeta('speed', Player.ClientId)

                Player.Tell("^3Usage: ^2[.buy hp] [.buy speed]")
                var customName = await this.Server.DB.metaService.getPersistentMeta('custom_name', Player.ClientId)

                if (customName && customName.Value != "" && (customName.Value.includes('[^2VIP') || customName.Value.includes('[^3VIP') || customName.Value.includes('^3[VIP')
                || customName.Value.includes('^6[VIP') || customName.Value.includes('[^6VIP')))
                {
                    Player.Tell(`^3Extra health : ^1${parseInt(health.Value) + 50} HP ^7(^1${health.Value} ^7+ ^150 ^3VIP^7)`)
                }   
                else
                {
                    Player.Tell(`^3Extra health : ^1${health.Value}) HP`)
                }
                //^9F ^8E ^2D ^4C ^5B ^6A ^3S ^3SS ^3SSS
                var nextPurchase = 0;
                var requiredRank = "";
                if (health.Value == "0")
                {
                    nextPurchase = 10000
                    requiredRank = "^9F^7"
                }
                else if (health.Value == "10")
                {
                    nextPurchase = 50000
                    requiredRank = "^9F^7"
                }
                else if (health.Value == "20")
                {
                    nextPurchase = 100000
                    requiredRank = "^8E^7"
                }
                else if (health.Value == "30")
                {
                    nextPurchase = 200000
                    requiredRank = "^2D^7"
                }
                else if (health.Value == "40")
                {
                    nextPurchase = 1000000
                    requiredRank = "^4C^7"
                }
                else if (health.Value == "50")
                {
                    nextPurchase = 2000000
                    requiredRank = "^5B^7"
                }
                else if (health.Value == "60")
                {
                    nextPurchase = 4000000
                    requiredRank = "^6A^7"
                }
                else if (health.Value == "70")
                {
                    nextPurchase = 8000000
                    requiredRank = "^3S^7"
                }
                else if (health.Value == "80")
                {
                    nextPurchase = 1600000
                    requiredRank = "^3SS^7"
                }
                else if (health.Value == "90")
                {
                    nextPurchase = 3200000
                    requiredRank = "^3SSS^7"
                }
                
                if (health.Value == "100") 
                {
                    Player.Tell("You are ^3Max ^1HP^7")
                }
                else
                {
                    Player.Tell(`Next ^1HP purchase^7 will cost : ^2$${nextPurchase}^7`)
                    Player.Tell(`^5Required rank for next ^1HP purchase^7 : ${requiredRank}^7`)
                }

              //  await new Promise(resolve => setTimeout(resolve, 5000))



                var customName = await this.Server.DB.metaService.getPersistentMeta('custom_name', Player.ClientId)

                Player.Tell(`^3Extra Speed : ^2${speed.Value} ^7`)
                //^9F ^8E ^2D ^4C ^5B ^6A ^3S ^3SS ^3SSS
                var nextPurchase = 0;
                var requiredRank = "";
                if (speed.Value == "1")
                {
                    nextPurchase = 10000
                    requiredRank = "^9F^7"
                }
                else if (speed.Value == "1.01")
                {
                    nextPurchase = 50000
                    requiredRank = "^9F^7"
                }
                else if (speed.Value == "1.02")
                {
                    nextPurchase = 100000
                    requiredRank = "^8E^7"
                }
                else if (speed.Value == "1.03")
                {
                    nextPurchase = 200000
                    requiredRank = "^2D^7"
                }
                else if (speed.Value == "1.04")
                {
                    nextPurchase = 1000000
                    requiredRank = "^4C^7"
                }
                else if (speed.Value == "1.05")
                {
                    nextPurchase = 2000000
                    requiredRank = "^5B^7"
                }
                else if (speed.Value == "1.06")
                {
                    nextPurchase = 4000000
                    requiredRank = "^6A^7"
                }
                else if (speed.Value == "1.07")
                {
                    nextPurchase = 8000000
                    requiredRank = "^3S^7"
                }
                else if (speed.Value == "1.08")
                {
                    nextPurchase = 1600000
                    requiredRank = "^3SS^7"
                }
                else if (speed.Value == "1.09")
                {
                    nextPurchase = 3200000
                    requiredRank = "^3SSS^7"
                }
                
                if (speed.Value == "1.10") 
                {
                    Player.Tell("You are ^2Max Speed^7")
                }
                else
                {
                    Player.Tell(`Next ^2Speed purchase^7 will cost : ^2$${nextPurchase}^7`)
                    Player.Tell(`^5Required rank for next ^2Speed purchase^7 : ${requiredRank}^7`)
                }
                //-----------------------------------INFO-------------------------------------------------------------                          
                return;
            }
        }
    }
        this.Manager.commands['inithp'] = {
            ArgumentLength: 0,
            Alias: 'inithp',
            logToAudit: false,
            Permission: Permissions.Commands.COMMAND_USER_CMDS,
            callback: async (Player, args) => {
              /*  if (!this.Server.isZM()) {
                    Player.Tell(Localization['COMMAND_UNAVAILABLE_GAMETYPE'])
                    return
                }*/
                var customName = await this.Server.DB.metaService.getPersistentMeta('custom_name', Player.ClientId)
                if (customName)
                {
                    var customNameValue = customName.Value
                    if (customName && customName.Value != "" && customNameValue.includes('^1'))
                    {
                        var stats = await this.Server.DB.metaService.getPersistentMeta('hp', Player.ClientId)
                        if (!stats)
                        {
                            await this.Server.DB.metaService.addPersistentMeta('hp', "0", Player.ClientId)
                        }
                        Player.Tell("hp created");
                        return
                    }
                    else
                    {
                        Player.Tell('Admins only.')
                        return
                    }
                }


        }
    }


    this.Manager.commands['remove'] = {
        ArgumentLength: 0,
        Alias: 'remove',
        logToAudit: false,
        inGame: false,
        Permission: Permissions.Commands.COMMAND_USER_CMDS,
        callback: async (Player, args) =>
        {
            if (await this.is_staff(Player) == false)
                return
            if (!args[2])
            {
                Player.Tell("specify metadata")
                return
            }
            const Client = await this.Server.getClient(args[1])

            if (!Client) {
                Player.Tell(Localization['COMMAND_CLIENT_NOT_FOUND'])
                return
            }

            await this.Server.DB.metaService.deletePersistentMeta(args[2], Client.ClientId)
            Player.Tell(Client.Name + " removed from " + args[2])
        }
}

    this.Manager.commands['add'] = {
        ArgumentLength: 0,
        Alias: 'add',
        logToAudit: false,
        inGame: false,
        Permission: Permissions.Commands.COMMAND_USER_CMDS,
        callback: async (Player, args) =>
        {
            if (Player.ClientId != 12)
            {
                Player.Tell("Not for staff")
                return
            }
            if (await this.is_staff(Player) == false)
                return
            if (!args[2])
            {
                Player.Tell("specify metadata")
                return
            }
            const Client = await this.Server.getClient(args[1])

            if (!Client) {
                Player.Tell(Localization['COMMAND_CLIENT_NOT_FOUND'])
                return
            }

            if (!args[3])
            {
                Player.Tell("missing value")
                return
            }
            await this.Server.DB.metaService.addPersistentMeta(args[2], args[3], Client.ClientId)
            Player.Tell(Client.Name + " added " + args[2] + "with value " + args[3])
        }
}

    this.Manager.commands['delhp'] = {
        ArgumentLength: 0,
        Alias: 'delhp',
        logToAudit: false,
        Permission: Permissions.Commands.COMMAND_USER_CMDS,
        callback: async (Player, args) => {
           /* if (!this.Server.isZM()) {
                Player.Tell(Localization['COMMAND_UNAVAILABLE_GAMETYPE'])
                return
            }*/
            var customName = await this.Server.DB.metaService.getPersistentMeta('custom_name', Player.ClientId)
            if (customName)
            {
                var customNameValue = customName.Value
                if (customName && customName.Value != "" && customNameValue.includes('^1'))
                {
                    await this.Server.DB.metaService.deletePersistentMeta('hp', Player.ClientId)
                    Player.Tell("hp deleted");

                }
                else
                {
                    Player.Tell('Admins only.')
                    return
                }
            }
        }
    }
    
    //Event', 'ClientId', 'Kills', 'Downs', 'Revives', 'HighestRound', 'Headshots', 'Score'
    this.Manager.commands['top'] = {
        ArgumentLength: 0,
        Alias: 'top',
        inGame: false,
        logToAudit: false,
        Permission: Permissions.Commands.COMMAND_USER_CMDS,
        callback: async (Player, args) => {
            if (!args[1])
            {
                Player.Tell("Usage: ^3.top^7 ^3gamemodes^7|^3ee^7|^3kills^7|^3rounds^7|^3headshots^7|^3score^7")
                return
            }
            if (args[1] && (args[1].toLocaleLowerCase() == "gamemodes" || args[1].toLocaleLowerCase() == "kills" || args[1].toLocaleLowerCase() == "rounds"
            || args[1].toLocaleLowerCase() == "headshots" || args[1].toLocaleLowerCase() == "score" || args[1].toLocaleLowerCase() == "ee"))
            {
                var extra_text = ""
                var selected_stat = ""
                var selected_pers_stat = ""

                var max_index = 5;
                if (args[1].toLocaleLowerCase() == "gamemodes")
                {
                    var Stats = await this.Server.DB.getPlayerStatsLDB("Event")
                    var Player_Stats = await this.Server.DB.getPlayerPersStats(Player.ClientId, "Event")
   //                 max_index = 10;
                }
                else if (args[1].toLocaleLowerCase() == "kills")
                {
                    var Stats = await this.Server.DB.getPlayerStatsLDB("Kills")
                    var Player_Stats = await this.Server.DB.getPlayerPersStats(Player.ClientId, "Kills")
                }

                else if (args[1].toLocaleLowerCase() == "deaths")
                {
                    var Stats = await this.Server.DB.getPlayerStatsLDB("Downs")
                    var Player_Stats = await this.Server.DB.getPlayerPersStats(Player.ClientId, "Downs")
                }

                else if (args[1].toLocaleLowerCase() == "revives")
                {
                    var Stats = await this.Server.DB.getPlayerStatsLDB("Revives")
                    var Player_Stats = await this.Server.DB.getPlayerPersStats(Player.ClientId, "Revives")
                }

                else if (args[1].toLocaleLowerCase() == "rounds")
                {
                    var Stats = await this.Server.DB.getPlayerStatsLDB("HighestRound")
                    var Player_Stats = await this.Server.DB.getPlayerPersStats(Player.ClientId, "HighestRound")
                }

                else if (args[1].toLocaleLowerCase() == "headshots")
                {
                    var Stats = await this.Server.DB.getPlayerStatsLDB("Headshots")
                    var Player_Stats = await this.Server.DB.getPlayerPersStats(Player.ClientId, "Headshots")
                }

                else if (args[1].toLocaleLowerCase() == "score")
                {
                    var Stats = await this.Server.DB.getPlayerStatsLDB("Score")
                    var Player_Stats = await this.Server.DB.getPlayerPersStats(Player.ClientId, "Score")
                }

                else if (args[1].toLocaleLowerCase() == "ee")
                {
                    var Stats = await this.Server.DB.getPlayerStatsLDB("Easter")
                    var Player_Stats = await this.Server.DB.getPlayerPersStats(Player.ClientId, "Easter")
                }

                for (var i = 0; i < max_index; i++)
                {
                    if (args[1].toLocaleLowerCase() == "gamemodes")
                    {
                        extra_text = "gamemodes completed"
                        selected_stat = Stats[i].Event
                        selected_pers_stat = Player_Stats[0].Event
                    }
                    if (args[1].toLocaleLowerCase() == "ee")
                    {
                        extra_text = "easter egg completed"
                        selected_stat = Stats[i].Easter
                        selected_pers_stat = Player_Stats[0].Easter
                    }    
                    else if (args[1].toLocaleLowerCase() == "kills")
                    {
                        extra_text = "zombies killed"
                        selected_stat = Stats[i].Kills
                        selected_pers_stat = Player_Stats[0].Kills
                    }
    
                    else if (args[1].toLocaleLowerCase() == "deaths")
                    {
                        extra_text = "downs"
                        selected_stat = Stats[i].Downs
                        selected_pers_stat = Player_Stats[0].Downs
                    }
    
                    else if (args[1].toLocaleLowerCase() == "revives")
                    {
                        extra_text = "players revived"
                        selected_stat = Stats[i].Revives
                        selected_pers_stat = Player_Stats[0].Revives
                    }
                    else if (args[1].toLocaleLowerCase() == "rounds")
                    {
                        extra_text = "rounds accomplished" 
                        selected_stat = Stats[i].HighestRound
                        selected_pers_stat = Player_Stats[0].HighestRound
                    }    
                    else if (args[1].toLocaleLowerCase() == "headshots")
                    {
                        extra_text = "headshots"         
                        selected_stat = Stats[i].Headshots 
                        selected_pers_stat = Player_Stats[0].Headshots
                    }
                    else if (args[1].toLocaleLowerCase() == "score")
                    {
                        extra_text = "points earned" 
                        selected_stat = Stats[i].Score
                        selected_pers_stat = Player_Stats[0].Score
                    }   
                    var name = Stats[i].Name
                    var customName = await this.Server.DB.metaService.getPersistentMeta('custom_name', Stats[i].ClientId)
                    if (customName)
                        name = customName.Value
                    Player.Tell(`^3Top ${i + 1}^7 - ^5${name}^7 ^2@${Stats[i].ClientId}^7 - ^3${selected_stat}^7 ${extra_text}`)
                    await new Promise(resolve => setTimeout(resolve, 100))
                    if (i == 4 && max_index == 10)
                        await new Promise(resolve => setTimeout(resolve, 3000))
                }
                var player_name = Player.Name
                var customName = await this.Server.DB.metaService.getPersistentMeta('custom_name', Player.ClientId)
                if (customName)
                    player_name = customName.Value
                Player.Tell(`^2Your score: ^5${player_name}^7 ^2@${Player.ClientId}^7 - ^3${selected_pers_stat}^7 ${extra_text}`)
                return
            }
            else
            {
                Player.Tell("^1Invalid category^7.")
                Player.Tell("Usage: ^3.top^7 ^3gamemodes^7|^3ee^7|^3kills^7|^3rounds^7|^3headshots^7|^3score^7")
            }
        }
    }
    this.Manager.commands['event'] =
    {
        ArgumentLength: 0,
        Alias: 'event',
        inGame: false,
        logToAudit: false,
        Permission: Permissions.Commands.COMMAND_USER_CMDS,
        callback: async (Player, args) =>
        {
            if (args[1])
            {
                const Client = await this.Server.getClient(args[1])

                if (!Client) {
                    Player.Tell(Localization['COMMAND_CLIENT_NOT_FOUND'])
                    return
                }
                var gm_count = await this.Server.DB.metaService.getPersistentMeta('event_gamemode', Client.ClientId)
                if (!gm_count)
                {
                    await this.Server.DB.metaService.addPersistentMeta('event_gamemode', "0", Client.ClientId)
                    var gm_count = await this.Server.DB.metaService.getPersistentMeta('event_gamemode', Client.ClientId)
                }
                var gm_count_int = parseInt(gm_count.Value)

                var extra_text = "";
                if (gm_count_int < 10)
                    extra_text = "^3Gonna need ^2more than that^3 for the ^2LDB^3 !"
                else if (gm_count_int > 300)
                    extra_text = "Blud ^5sacrificed everything^3 for the ^5Tavern^3 !"
                else if (gm_count_int > 200)
                    extra_text = "Absolutely ^2massive^3 !"
                else if (gm_count_int > 100)
                    extra_text = "A ^2proper Taverner^3 !"
                else if (gm_count_int > 75)
                    extra_text = "That's ^2a lot^3 of gamemodes !"
                else if (gm_count_int > 50)
                    extra_text = "^2Getting there^3 !"
                else if (gm_count_int > 25) 
                    extra_text = "A ^2moderate^3 amount !"
                else if (gm_count_int >= 10)
                    extra_text =  "Could do ^2better^3 !"
                
                


                Player.Tell(`${Client.Name} ^3completed ^5${gm_count_int}^3 gamemodes ! ${extra_text}`)
                return
            }
            var gm_count = await this.Server.DB.metaService.getPersistentMeta('event_gamemode', Player.ClientId)
            if (!gm_count)
            {
                await this.Server.DB.metaService.addPersistentMeta('event_gamemode', "0", Player.ClientId)
                var gm_count = await this.Server.DB.metaService.getPersistentMeta('event_gamemode', Player.ClientId)
            }
            var gm_count_int = parseInt(gm_count.Value)
    
            var extra_text = "";
            if (gm_count_int < 10)
            extra_text = "^3Gonna need ^2more than that^3 for the ^2LDB^3 !"
            else if (gm_count_int >= 10)
                extra_text =  "Could do ^2better^3 !"
            else if (gm_count_int > 20)
                extra_text = "A ^2moderate^3 amount !"
            else if (gm_count_int > 30)
                extra_text = "^2Getting there^3 !"
            else if (gm_count_int > 50)
                extra_text = "That's ^2a lot^3 of gamemodes !"
            else if (gm_count_int > 100)
                extra_text = "A ^2proper Taverner^3 !"
            else if (gm_count_int > 150)
                extra_text = "Absolutely ^2massive^3 !"
            else if (gm_count_int > 200)
                extra_text = "Blud ^5sacrificed everything^3 for the ^5Tavern^3 !"

            Player.Tell(`^3You completed ^5${gm_count_int}^3 gamemodes ! ${extra_text}`)
        }
    }    
        this.Manager.commands['setround'] = {
            ArgumentLength: 1,
            Alias: 'sround',
            logToAudit: false,
            Permission: Permissions.Commands.COMMAND_USER_CMDS,
            callback: async (Player, args) => {
                if (!args[1]) {
                    Player.Tell('Need round number')
                    return
                }
		var round = args[1];
		var customName = await this.Server.DB.metaService.getPersistentMeta('custom_name', Player.ClientId)
		if (customName)
		{
			var customNameValue = customName.Value
			if (customName && customName.Value != "" && customNameValue.includes('^1Owner'))
			{
				await Player.Server.Rcon.executeCommandAsync(`set customround ${round}`)
				Player.Tell(`set round to ${round}`)
				return
			}
		}
		else
		{
                        	Player.Tell('^1Error: You have no rank, contact admin')
				return				
		}
	}
}

this.Manager.commands['brutus'] = {
    ArgumentLength: 0,
    Alias: 'brutus',
    logToAudit: false,
    inGame: false,
    Permission: Permissions.COMMAND_USER_CMDS,
    callback: async (Player, args) => {

        if (Player.ClientId != 12 && Player.ClientId != 35663 && Player.ClientId != 62325 && Player.ClientId != 113080)
        {
            Player.Tell("^3You do ^1not^3 possess the power of the bat")
            return
        }

      /*  if (await this.is_staff(Player) == false)
        {
            Player.Tell("^3You do ^1not^3 possess the power of the bat")
            return
        }  */
         
        var spin = parseInt(await this.Server.Rcon.getDvar('spin'))

        if (spin == 0)
        {
            await this.Server.Rcon.setDvar('spin', '1')
            await this.Server.Rcon.setDvar('bold', '^3You ^2spin^3 me right round babe right round')
            Player.Tell("Spin time")
        }
        else if (spin == 1)
        {
            await this.Server.Rcon.setDvar('spin', '0')
            await this.Server.Rcon.setDvar('bold', '^3When you go ^1down^3, when you go ^1down down')
            Player.Tell("No more spin")
        }
    }
}

this.Manager.commands['god'] = {
    ArgumentLength: 0,
    Alias: 'g',
    logToAudit: false,
    Permission: Permissions.COMMAND_USER_CMDS,
    callback: async (Player, args) => {

        if (await this.is_staff(Player) == true)
        {
            await Player.Server.Rcon.executeCommandAsync(`set godmodeon ${Player.Guid}`)
            return
        }
        else
        {
            Player.Tell('Admins only.')
        }
    }
}

this.Manager.commands['godoff'] = {
    ArgumentLength: 0,
    Alias: 'goff',
    logToAudit: false,
    Permission: Permissions.Commands.COMMAND_USER_CMDS,
    callback: async (Player, args) => {
        if (await this.is_staff(Player) == true)
        {
            await Player.Server.Rcon.executeCommandAsync(`set godmodeoff ${Player.Guid}`)
            return
        }
        else
        {
            Player.Tell('Admins only.')
        }
    }
}

this.Manager.commands['lock'] = {
    ArgumentLength: 0,
    Alias: 'lock',
    logToAudit: false,
    Permission: Permissions.COMMAND_USER_CMDS,
    callback: async (Player, args) => {

        if (!args)
        {
            Player.Tell(`Usage: .lock [1|0] -- Lock = ${this.lock}`)
            
            return
        }
        if (await this.is_staff(Player))
        {
            this.lock = args[1];
            if (args[1] == "0")
                Player.Tell("Server ^1Locked")
            else
            {
                Player.Tell("Server ^2Unlocked")
            }
        }
        else
        {
            Player.Tell('Staff Manager only')
            return
        }
    }
}

this.Manager.commands['lock'] = {
    ArgumentLength: 0,
    Alias: 'lock',
    logToAudit: false,
    Permission: Permissions.COMMAND_USER_CMDS,
    callback: async (Player, args) => {

        if (!args)
        {
            Player.Tell(`Usage: .lock [1|0] -- Lock = ${this.lock}`)
            
            return
        }
        if (await this.is_staff(Player))
        {
            this.lock = args[1];
            if (args[1] == "1")
                Player.Tell("Server ^1Locked")
            else
                Player.Tell("Server ^2Unlocked")
        }
        else
        {
            Player.Tell('Staff Manager only')
            return
        }
    }
}

this.Manager.commands['song'] = {
    ArgumentLength: 0,
    Alias: 'song',
    inGame: true,
    logToAudit: false,
    Permission: Permissions.COMMAND_USER_CMDS,
    callback: async (Player, args) => {

        if (!(args[1]) || (args[1] != "1" && args[1] != "2" && args[1] != "3" && args[1] != "4"))
            {
                Player.Tell("Usage : ^3.song [1-4]")
                return
            }
            if (await Player.Server.Rcon.getDvar("song") != "0")
            {
                Player.Tell("A ^3Song^7 is currently playing")
                return
            }
            var map = await Player.Server.Rcon.getDvar("mapname")
            var error = 0
            if (args[1] == "4" && map != "zm_nuked")
                error = 1
            if (args[1] == "3" && map != "zm_nuked" && map != "zm_tomb")
                error = 1
            if (args[1] == "2" && (map == "zm_transit" || map == "zm_highrise" || map == "zm_buried"))
                error = 1
    
            if (error == 1)
            {
                Player.Tell(`Song ^3${args[1]}^7 does ^1not exist^7 for ^3this map`)
                return
            }
            Player.Tell(`Playing ^3Song ${args[1]}`)
            await Player.Server.Rcon.setDvar('song', args[1])
    }
}

this.Manager.commands['wipe'] = {
    ArgumentLength: 0,
    Alias: 'wp',
    logToAudit: false,
    Permission: Permissions.COMMAND_USER_CMDS,
    callback: async (Player, args) => {

    if (Player.ClientId == 12 || Player.ClientId == 3649)
        {
            for(const ig_player of await this.Manager.Server.getClients())
            {
                if (parseInt(ig_player.ClientId) != 12 && parseInt(ig_player.ClientId) != 3649)
                {
                    ig_player.Kick("^1Server locked^7 for testing")
                }
            }
            this.lock = args[1];
            Player.Tell("Wiped mon pooote :)")
        }
    }
}


        this.Manager.commands['revive'] = {
            ArgumentLength: 0,
            Alias: 'rev',
            logToAudit: false,
            Permission: Permissions.Commands.COMMAND_USER_CMDS,
            callback: async (Player, args) => {

                if (await this.is_raid() == true)
                    return

             var guild = await this.init_guild_data(Player.ClientId)
         
                var totalMoney = (await this.getZMStats(Player.ClientId)).Money
                if (totalMoney == undefined)
                {
                    Player.Tell("Error, zm_stats")
                    return
                }
                var commandCost = 1000000;
                var roundRevived = parseInt(await Player.Server.Rcon.getDvar(`${Player.Clientslot}_revivedRound`))
                var currentRound = parseInt(await Player.Server.Rcon.getDvar(`currentRound`))
                var customTag = await this.Server.DB.metaService.getPersistentMeta('custom_tag', Player.ClientId)

                var customName = await this.Server.DB.metaService.getPersistentMeta('custom_name', Player.ClientId)
                if (customName)
                {
                    var customNameValue = customName.Value
                    if (customName && customName.Value != "" && customNameValue.includes('^1Owner'))
                    {
                        await Player.Server.Rcon.executeCommandAsync(`set revive ${Player.Guid};1`)
                        Player.Tell(`^1Owner Access Override : ^3.reviveall^7`)
                        return;
                    }
                    if (customName && customName.Value != "" && (customName.Value.includes('[^2VIP') || customName.Value.includes('^2[VIP') || customName.Value.includes('[^3VIP') || customName.Value.includes('^3[VIP') 
                    || customName.Value.includes('^6[VIP') || customName.Value.includes('[^6VIP')
                    || customName.Value.includes('^1[VIP') || customName.Value.includes('[^1VIP') ))
                    {
                        if (currentRound >= roundRevived + 1 || this.Manager.Server.Hostname.split("|")[1].includes("BUS")
                        || this.Manager.Server.Hostname.split("|")[1].includes("AGARTHA") || await this.is_brutus() == true)
                        {
                            if (guild && guild.level >= 6)
                                await Player.Server.Rcon.executeCommandAsync(`set revive ${Player.Guid};guild`)
                            else 
                                await Player.Server.Rcon.executeCommandAsync(`set revive ${Player.Guid};1`)
                            roundRevived = currentRound
                            await Player.Server.Rcon.executeCommandAsync(`set ${Player.Clientslot}_revivedRound ${roundRevived}`)
                            roundRevived += 1
                            if (!(this.Manager.Server.Hostname.split("|")[1].includes("BUS")) && !(this.Manager.Server.Hostname.split("|")[1].includes("AGARTHA")) && 
                            !(this.Manager.Server.Hostname.split("|")[1].includes("AGARTHA")))
                            Player.Tell(`^3.revive^7 ^2used^7, next use : Round^2 ${roundRevived}^7`)
                            return
                        }
                        else
                        {
                            Player.Tell(`^3.revive^7 ^1on cooldown^7, next use : Round^2 ${roundRevived}^7`)
                            return
                        }
                    }
                }

            if(!customTag) 
            {
                Player.Tell('^1Error #002: contact admin')
                return				
            }
            else if (customTag.Value != "^3S^7" && customTag.Value != "^3SS^7" && customTag.Value != "^3SSS^7"
            && customTag.Value != "^6 I ^7" && customTag.Value != "^6II^7" && customTag.Value != "^6III^7"
            && customTag.Value != "^5IV^7" && customTag.Value != "^5V^7" && customTag.Value != "^5VI^7" && customTag.Value != "^5VII^7"
            && customTag.Value != "^1IIX^7" && customTag.Value != "^1IX^7" && customTag.Value != "^1-X-^7")
            {
                Player.Tell('Only ^3VIP^7 & ^3S+ Rank ^7can use this command.')
                return	
            }
            if (totalMoney < commandCost)
            {
                Player.Tell('Not enough ^3$^7 to use that command.')
                return
            }
            var roundDelay = 0
            var shouldgiveperk = 0
            if (customTag.Value == "^3S^7")
            {
                roundDelay = 5
            }
            if (customTag.Value == "^3SS^7")
            {
                roundDelay = 4
            }
            if (customTag.Value == "^3SSS^7" || customTag.Value == "^6 I ^7" || customTag.Value == "^6II^7" || customTag.Value == "^6III^7"
            || customTag.Value == "^5IV^7" || customTag.Value == "^5V^7" || customTag.Value == "^5VI^7")
            {
                roundDelay = 3
                shouldgiveperk = 1
            }
            if (customTag.Value == "^5VII^7" || customTag.Value == "^1IIX^7" || customTag.Value == "^1IX^7" || customTag.Value == "^1-X-^7")
            {
                roundDelay = 2
                shouldgiveperk = 1
            }

            if (roundDelay == 0)
            {
                Player.Tell("Error #001, please contact Admin")
                return
            }
            if (currentRound >= roundRevived + roundDelay)
            {
                Player.Tell(Utils.formatString(Localization['ZBANK_WITHDRAW_SUCCESS'], {
                    amount: commandCost.toLocaleString()
                    }, '%')[0])

                this.setPlayerMoney(Player.ClientId, parseInt(totalMoney) - parseInt(commandCost))	

				await Player.Server.Rcon.executeCommandAsync(`set revive ${Player.Guid};${shouldgiveperk}`)
                roundRevived = currentRound;
                await Player.Server.Rcon.executeCommandAsync(`set ${Player.Clientslot}_revivedRound ${roundRevived}`)
                roundRevived += roundDelay;
				Player.Tell(`^3.revive^7 ^2used^7, next use : Round^2 ${roundRevived}^7`)
				return
            }
            else
            {
                Player.Tell(`^3.revive^7 ^1on cooldown^7, next use : Round^2 ${roundRevived}^7`)
            }
			return
	    }
    }

    this.Manager.commands['reviveall'] =
    {
        ArgumentLength: 0,
        Alias: 'revall',
        logToAudit: false,
        Permission: Permissions.Commands.COMMAND_USER_CMDS,
        callback: async (Player, args) =>
        {
            /*if (!this.Server.isZM()) {
                Player.Tell(Localization['COMMAND_UNAVAILABLE_GAMETYPE'])
                return
            }*/
            var pass = await this.Server.DB.metaService.getPersistentMeta('pass', Player.ClientId)
            if (!pass)
            {
                Player.Tell("Purchase the ^5Premium Pass^7 in ^6Discord^7 to use this command.")
                return
            }
            if (!this.Manager.Server.Hostname.split("|")[1].includes("AGARTHA")
                && !this.Manager.Server.Hostname.split("|")[1].includes("BUS")
                && await this.is_brutus() == false)
            {
                Player.Tell("Available only in ^3Gamemodes^7.")
                return;
            }
            await Player.Server.Rcon.executeCommandAsync(`set revive ${Player.Guid};all`)
            return
        }
    }


        this.Manager.commands['deposit'] = {
            ArgumentLength: 1,
            Alias: 'd',
            logToAudit: false,
            Permission: Permissions.Commands.COMMAND_USER_CMDS,
            callback: async (Player, args) => {
               /* if (!this.Server.isZM()) {
                    Player.Tell(Localization['COMMAND_UNAVAILABLE_GAMETYPE'])
                    return
                }*/

                if (Player.Data && Player.Data.lastDeposit && (new Date() - Player.Data.lastDeposit) / 1000 < 5) {
                    Player.Tell(Localization['COMMAND_COOLDOWN'])
                    return
                }

                var totalMoney = (await this.getZMStats(Player.ClientId)).Money
                if (totalMoney == undefined)
                {
                    Player.Tell("Error, zm_stats")
                    return
                }
                var gameMoney = parseInt(await Player.Server.Rcon.getDvar(`${Player.Clientslot}_money`))
                var depositMoney = args[1] == 'all' ? parseInt(gameMoney) : parseInt(args[1])

                const canUseBank = await Player.Server.Rcon.getDvar(`${Player.Clientslot}_can_use_bank`)
                if (canUseBank == "0") {
                    Player.Tell("Cannot deposit when ^2Time Bomb ^7is active. ^1Nice try kid :)");
             //       Player.Tell(Localization['ZBANK_DISABLED']);
                    return
                }
		if (canUseBank == "1") {
                    Player.Tell("Cannot deposit when in ^2Afterlife ^1Nice try kid :)");
		    return	
		}
        if (canUseBank == "2")
        {
        Player.Tell("Bank disabled for Tournament server");
        return
         }

                switch (true) {
                    case (!Number.isInteger(depositMoney)):
                        Player.Tell(Localization['ZBANK_PARSE_ERROR'])
                    return
                    case (depositMoney <= 0):
                    case (!gameMoney || !Number.isInteger(gameMoney) || gameMoney < depositMoney):
                        Player.Tell(Localization['ZBANK_BALANCE_ERROR'])
                    return
                }

                var result = await Player.Server.Rcon.executeCommandAsync(`set bank_deposit ${Player.Guid};${depositMoney}`)

                if (result) {
                    Player.Tell(Utils.formatString(Localization['ZBANK_DEPOSIT_SUCCESS'], {
                        amount: depositMoney.toLocaleString()
                    }, '%')[0])
                
                    Player.Data.lastDeposit = new Date()
                    this.setPlayerMoney(Player.ClientId, parseInt(totalMoney) + parseInt(depositMoney))
                    return
                }

                Player.Tell(Localization['ZBANK_DEPOSIT_FAIL'])
            }
        }

    this.Manager.commands['killall'] =
    {
        ArgumentLength: 0,
        Alias: 'kill',
        logToAudit: false,
        Permission: Permissions.Commands.COMMAND_USER_CMDS,
        callback: async (Player, args) =>
        {
            if (await this.is_staff(Player))
            {
                await Player.Server.Rcon.setDvar('killzmadmin', Player.Guid)
                return
            }
            var mapname = await Player.Server.Rcon.getDvar('map_name')
            if (mapname && mapname != "zm_transit" && mapname != "zm_buried")
            {
                Player.Tell('^3.kill^7 can only be used in ^3Tranzit/Town/Buried servers^7')
                return
            }
            await Player.Server.Rcon.setDvar('killzm', Player.Guid)
        }
    }














        this.Manager.commands['pay'] = {
            ArgumentLength: 0,
            inGame: false,
            logToAudit: false,
            Permission: Permissions.Commands.COMMAND_USER_CMDS,
            callback: async (Player, args) => {
                if (Player.Data && Player.Data.lastpay && (new Date() - Player.Data.lastpay) / 1000 < 5) {
                    Player.Tell(Localization['COMMAND_COOLDOWN'])
                    return
                }
                if (Player.Data)
                    Player.Data.lastpay = new Date()
                var inGame = await this.Server.findClient(Player.ClientId)
                if (inGame)
                {                

                }

                if (this.Manager.Server.Hostname.split("|")[1].includes("AGARTHA"))
                {
                    Player.Tell("Cannot use ^3.pay^7 in ^5PiA^7")
                    return
                }
                if (!args[1] || !args[2])
                {
                    Player.Tell("^3To send ^2Points :^7 .pay <player|id> <amount>")
                    Player.Tell("^3To send ^5Z-Coins :^7 .pay <player|id> <amount> zcoins")
                    return
                }
                var Target = await this.Server.getClient(args[1])
                if (!Target) {
                    Player.Tell(Localization['COMMAND_CLIENT_NOT_FOUND'])
                    return
                }
                if (args[3] == "zcoins")
                {
                    var Pzcoins = await this.Server.DB.metaService.getPersistentMeta('zcoins', Player.ClientId)
                    var totalMoney = parseInt(Pzcoins.Value)
                    var moneyToGive = parseInt(args[2])  
                    if (!Number.isInteger(moneyToGive) || moneyToGive < 0)
                    {
                        Player.Tell(Localization['ZBANK_PARSE_ERROR'])
                        return
                    }
                    if (totalMoney < moneyToGive)
                    {
                        Player.Tell("^3Not enough ^5Z-Coins^3 to make that transaction")
                        return
                    }   
                    var targetZcoins = await this.Server.DB.metaService.getPersistentMeta('zcoins', Target.ClientId)
                    var targetres = parseInt(targetZcoins.Value) + moneyToGive
                    var playerres = parseInt(Pzcoins.Value) - moneyToGive
                    await this.Server.DB.metaService.addPersistentMeta('zcoins', targetres, Target.ClientId)
                    await this.Server.DB.metaService.addPersistentMeta('zcoins', playerres, Player.ClientId)
                    var customName = await this.Server.DB.metaService.getPersistentMeta('custom_name', Target.ClientId)
                    var name = Target.Name
                    if (customName)
                    {
                        name = customName.Value
                    }
                    Player.Tell(`^3Successfully sent ^5${moneyToGive} Z-coins ^3to ^7${name} !`)

                    Target.inGame = Utils.findClient(Target.ClientId, this.Managers)
                    Target.inGame && Target.inGame.Tell(`^3You received ^5${moneyToGive} Z-coins ^3from ^7${Player.Name} !`)
                    return
                }
                var totalMoney = (await this.getZMStats(Player.ClientId)).Money
                if (totalMoney == undefined)
                {
                    Player.Tell("Error, zm_stats")
                    console.log("err")
                    return
                }
                var moneyToGive = parseInt(args[2])

                switch (true) {
                    case (!Number.isInteger(moneyToGive) || moneyToGive < 0):
                        Player.Tell(Localization['ZBANK_PARSE_ERROR'])
                    return
                    case (!totalMoney):
                    case (totalMoney < parseInt(moneyToGive * 1.05) && Player.Guid != 'Node'):
                        Player.Tell(Localization['ZBANK_BALANCE_ERROR'])
                    return
                }

                await this.addPlayerMoney(Player.ClientId, -1 * parseInt(parseInt(moneyToGive) * 1.05))
                this.addPlayerMoney(Target.ClientId, parseInt(moneyToGive))

                var customName = await this.Server.DB.metaService.getPersistentMeta('custom_name', Target.ClientId)
                var name = Target.Name
                if (customName)
                {
                    name = customName.Value
                }
                Player.Tell(Utils.formatString(Localization['ZBANK_TRANSFER_FORMAT'], {
                    amount: moneyToGive.toLocaleString(), 
                    name: name, 
                    fee: parseInt(moneyToGive * 0.05), 
                    id: Utils.getRandomInt(10000000, 90000000)
                }, '%')[0])

                Target.inGame = Utils.findClient(Target.ClientId, this.Managers)

                Target.inGame && Target.inGame.Tell(Utils.formatString(Localization['ZBANK_RECEIVE_FORMAT'], {
                    amount: moneyToGive.toLocaleString(), 
                    name: Player.Name
                }, '%')[0])
            }
        }
        this.Manager.commands['setmoney'] = {
            ArgumentLength: 2,
            inGame: false,
            logToAudit: false,
            Permission: Permissions.Commands.COMMAND_USER_CMDS,
            callback: async (Player, args) => {
                var Target = await this.Server.getClient(args[1])

                if (!Target) {
                    Player.Tell(Localization['COMMAND_CLIENT_NOT_FOUND'])
                    return
                }

                if (await this.is_staff(Player) == false)
                    return

                const moneyToSet = parseInt(args[2])

                if (!Number.isInteger(moneyToSet))
                {
                    Player.Tell(Localization['ZBANK_PARSE_ERROR'])
                    return
                }

                await this.setPlayerMoney(Target.ClientId, moneyToSet)

                Player.Tell(Utils.formatString(Localization['ZBANK_SETMONEY_FORMAT'], {
                    amount: moneyToSet.toLocaleString(), 
                    name: Target.Name
                }, '%')[0])

                Target.inGame = Utils.findClient(Target.ClientId, this.Managers)
                Target.inGame && Target.inGame.Tell(Utils.formatString(Localization['ZBANK_NEWBALANCE_FORMAT'], {
                    amount: moneyToSet.toLocaleString()
                }, '%')[0])
            }
        }

        this.Manager.commands['setzcoins'] = {
            ArgumentLength: 2,
            inGame: false,
            logToAudit: false,
            Permission: Permissions.Commands.COMMAND_USER_CMDS,
            callback: async (Player, args) => {
                var Target = await this.Server.getClient(args[1])

                if (!Target) {
                    Player.Tell(Localization['COMMAND_CLIENT_NOT_FOUND'])
                    return
                }
                if (await this.is_staff(Player) == false)
                    return
                const zCoinsToSet = parseInt(args[2])

                if (!Number.isInteger(zCoinsToSet))
                {
                    Player.Tell(Localization['ZBANK_PARSE_ERROR'])
                    return
                }
                await this.Server.DB.metaService.addPersistentMeta('zcoins', zCoinsToSet, Target.ClientId)

                Player.Tell(Utils.formatString(Localization['ZBANK_SETMONEY_FORMAT'], {
                    amount: zCoinsToSet.toLocaleString(), 
                    name: Target.Name
                }, '%')[0])

                Target.inGame = Utils.findClient(Target.ClientId, this.Managers)
                Target.inGame && Target.inGame.Tell(Utils.formatString(Localization['ZBANK_NEWBALANCE_FORMAT'], {
                    amount: zCoinsToSet.toLocaleString()
                }, '%')[0])
            }
        }

        this.Manager.commands['upgrade'] =
        {
            ArgumentLength: 0,
            inGame: false,
            Alias: 'up',
            logToAudit: false,
            Permission: Permissions.Commands.COMMAND_USER_CMDS,
            callback: async (Player, args) =>
            {
               /* if (await Player.Server.Rcon.getDvar(`net_port`) == "30009")
                return
                if (args)
                {
                    if (args[1] && args[1] == "rate")
                    {

                    }
                    else if (args[1] && args[1] == "speed")
                    {
                        
                    }
                }*/
               
                var rate = parseFloat(await Player.Server.Rcon.getDvar(`fire_rate`))
                var cost = parseInt(await Player.Server.Rcon.getDvar(`cost`))
                var zcoins = await this.Server.DB.metaService.getPersistentMeta('zcoins', Player.ClientId)
                if(!zcoins)
                    return

                if (parseInt(zcoins.Value) < this.cost)
                {
                    Player.Tell("No ^5Z-Coins^7 left !")
                    return
                }
                var guild = await this.init_guild_data(Player.ClientId)
                if (guild)
                {
                    if (rate <= 0.2)
                    {
                        Player.Tell(`Team Fire rate ^2Over Maxed^7 ! No ^5Z-Coins^3 used`)
                        return
                    }
                    if (rate <= 0.25 && guild.level < 7)
                    {
                        Player.Tell("^6Guild^7 level ^1too low^7 to use extra ^5.up^7")
                        return
                    }
                    else if (rate <= 0.3 && guild.level < 5)
                    {
                        Player.Tell("^6Guild^7 level ^1too low^7 to use extra ^5.up^7")
                        return
                    }

                    if ((rate <= 0.25 && guild.level >= 7) || (rate <= 0.3 && guild.level >= 5) || this.Server.Hostname.split("|")[1].includes("PRIVATE")) //request
                    {
                        rate -= 0.05
                        Player.Tell("Guild ^5.up^7 used !")
                    }
                    else
                    {
                        rate -= 0.065
                        if (rate == 0.295)
                            rate = 0.3 //hard fix
                    }
                    Player.Server.Rcon.executeCommandAsync(`set upgrade ${rate}`)
    
                    Player.Tell(`Used ^5 ${parseInt(cost)} Z-Coins^7 !\nTeam Fire rate ^3Increased^7 !`)
                    await this.Server.DB.metaService.addPersistentMeta('zcoins', parseInt(zcoins.Value) - cost, Player.ClientId)
                    cost *= 1.3;
                    Player.Server.Rcon.executeCommandAsync(`set cost ${cost}`)
                }
                else     
                {
                    rate -= 0.065
                    if (rate == 0.295)
                        rate = 0.3 //hard fix
                    if (rate < 0.3)
                    {
                        Player.Tell(`Team Fire rate ^1Maxed^7 ! No ^5Z-Coins^3 used`)
                        return
                    }
        
                    Player.Server.Rcon.executeCommandAsync(`set upgrade ${rate}`)
    
                    Player.Tell(`Used ^5 ${parseInt(cost)} Z-Coins^7 !\nTeam Fire rate ^3Increased^7 !`)
                    await this.Server.DB.metaService.addPersistentMeta('zcoins', parseInt(zcoins.Value) - cost, Player.ClientId)
                    cost *= 1.3;
                    Player.Server.Rcon.executeCommandAsync(`set cost ${cost}`)
                }
            }
        }
    
        this.Manager.commands['money'] = {
            ArgumentLength: 0,
            inGame: false,
            Alias: 'balance',
            logToAudit: false,
            Permission: Permissions.Commands.COMMAND_USER_CMDS,
            callback: async (Player, args) => {
                if (args[1]) {
                    const Client = await this.Server.getClient(args[1])

                    if (!Client) {
                        Player.Tell(Localization['COMMAND_CLIENT_NOT_FOUND'])
                        return
                    }

                    const amount = (await this.getZMStats(Client.ClientId)).Money
                        
                    if (amount == undefined) {
                        Player.Tell(Localization['ZBANK_PLAYER_NO_ACCOUNT'])
                        return
                    }
                    var customName = await this.Server.DB.metaService.getPersistentMeta('custom_name', Client.ClientId)
                    var name = Client.Name
                    if (customName)
                    {
                        name = customName.Value
                    }
                    Player.Tell(Utils.formatString(Localization['ZBANK_MONEY_FORMAT'], {
                        name: name, 
                        amount: amount.toLocaleString()
                    }, '%')[0])

                    var zcoins = await this.Server.DB.metaService.getPersistentMeta('zcoins', Client.ClientId)
                    if (!zcoins)
                    {
                        await this.Server.DB.metaService.addPersistentMeta('zcoins', "0", Client.ClientId)
                        zcoins = await this.Server.DB.metaService.getPersistentMeta('zcoins', Client.ClientId)
                    }
                    Player.Tell(`^5${name} ^3Z-Coins : ^5${zcoins.Value}`)
                    return
                }

                const amount = (await this.getZMStats(Player.ClientId)).Money

                if (amount == undefined) {
                    Player.Tell(Localization['ZBANK_NO_ACCOUNT'])
                    return
                }

                Player.Tell(Utils.formatString(Localization['ZBANK_MONEY_FORMAT_SELF'], {
                    amount: amount.toLocaleString()
                }, '%')[0])

                var zcoins = await this.Server.DB.metaService.getPersistentMeta('zcoins', Player.ClientId)
                if (!zcoins)
                {
                    await this.Server.DB.metaService.addPersistentMeta('zcoins', "0", Player.ClientId)
                    zcoins = await this.Server.DB.metaService.getPersistentMeta('zcoins', Player.ClientId)
                }
                Player.Tell(`^3Z-Coins : ^5${zcoins.Value}`)
            }
        }
    }

    async display_flex(manager, customTag, customName, totalMoney, zcoins, hp, percentspeed, save, Player)
    {
        if (customName)
            manager.Server.Rcon.executeCommandAsync(`set ln [${customTag.Value}]${customName.Value}^7 flex his ^2$${totalMoney.toLocaleString("en-GB")}^7 - ^5${zcoins.Value} Z-Coins^7`)
        else
            manager.Server.Rcon.executeCommandAsync(`set ln [${customTag.Value}] ^8${Player.Name}^7 flex his ^2$${totalMoney.toLocaleString("en-GB")}^7 - ^5${zcoins.Value} Z-Coins^7`)
        await new Promise(resolve => setTimeout(resolve, 500))
        manager.Server.Rcon.executeCommandAsync(`set ln ^1${hp}/450 HP^7 - ^3${percentspeed}/15 Speed^7 - ^5${save.Value} save^7. Use ^5.flex^7`)
    }

    async is_staff(Player)
    {
        for (var i = 0; i < this.staff_list_a.length; i++)
            if (this.staff_list_a[i] == Player.Guid)
                return true
        return false
    }

    async guild_staff(guild_id, args, Player, lock)
    {
        var is_found = 0;
        var guild_name_id = guild_id.split(';')
        if (guild_name_id[0].toLocaleLowerCase() == args[2].toLocaleLowerCase())
        {
            var guild_data = await this.Server.DB.metaService.getPersistentMeta('guild_data', guild_name_id[1])
            if (!guild_data)
            {
                Player.Tell("err")
                return
            }
            var guild_str = guild_data.Value.split(';')
            var guild = []

            guild.name = guild_str[0]
            guild.guild_master = guild_str[1]
            guild.guild_members = guild_str[2] 
            guild.size = guild_str[3]
            guild.level = guild_str[4]
            guild.xp = guild_str[5]
            guild.bank = guild_str[6]
            guild.hp = guild_str[7]
            guild.speed = guild_str[8]
            guild.skills = guild_str[9]
            guild.revive = guild_str[10]

            if (args[3] && args[3] == "list")
            {
                Player.Tell("^6Guild ^3GM^7 : " + guild.guild_master)
                await new Promise(resolve => setTimeout(resolve, 500))
                Player.Tell("^3Member ID list^7 : " + guild.guild_members)
                return
            }
            else if (args[3] && args[3] == "add")
            {
                if (!args[4])
                {
                    Player.Tell("no ID parameter")
                    return
                }

                if (guild.guild_members.split('-'))
                {
                    var current_members = guild.guild_members.split('-')
                }
                else
                {
                    var current_members = 0
                }

                if (parseInt(guild.size) > parseInt(current_members))
                {
                    var members_array = guild.guild_members.split('-')
                    var err = 0;
                    members_array.forEach(member =>
                    {
                        if (member == args[4].replace('@', ''))
                        {
                            Player.Tell(args[4].replace('@', '') + " is ^3already^7 in your ^6guild !")
                            err = 1;
                        }                
                    }) 
                    if (err && err == 1)
                        return

                    var player_guild = await this.Server.DB.metaService.getPersistentMeta('guild_data', parseInt(args[4].replace('@', '')))
                    if (player_guild && player_guild.Value.split(";")[0] != guild.name)
                    {
                        Player.Tell("Player ^3" + args[4].replace('@', '') + "^7 belongs to " + player_guild.Value.split(";")[0])
                        return
                    }  

                    if (guild.guild_members == "0" || guild.guild_members == "-" || guild.guild_members == "")
                        guild.guild_members = args[4].replace('@', '') //add guild member
                    else
                        guild.guild_members += "-" + args[4].replace('@', '') //add guild member

                    Player.Tell(args[4].replace('@', '') + " added to " + guild.name)
                }
                else
                {
                    Player.Tell("Your ^6Guild^7 is ^1full^7 !")
                    return
                }
            }
            else if (args[3] && args[3] == "remove")
            {
                var members_array = guild.guild_members.split('-')
                var err = 0
                var is_found = 0
                members_array.forEach(member =>
                    {
                        if (member == guild_name_id[1])
                        {
                            Player.Tell("^6Guild Master^7")
                            err = 1;
                        }                  
                    }) 
                    if (err && err == 1)
                        return

                var target_player_id = "";
                members_array.forEach(member =>
                {
                    if (member == args[4].replace('@', ''))
                    {
                        target_player_id = member
                        is_found = 1
                    }                  
                }) 
                if (is_found == 0)
                {
                    Player.Tell("This player is ^1not^7 in " + guild.name)
                    return
                }

                var player_guild = await this.Server.DB.metaService.getPersistentMeta('guild_data', parseInt(target_player_id))
                if (player_guild && player_guild.Value.split(";")[0] != guild.name)
                {
                    Player.Tell("Player ^3" + target_player_id + "^7 belongs to " + player_guild.Value.split(";")[0])
                    return
                }
                guild.guild_members = guild.guild_members.replace("\-".toString() + target_player_id , "")
                Player.Tell(args[4].replace('@', '') + " removed from " + guild.name)
                await this.Server.DB.metaService.deletePersistentMeta('guild_data', parseInt(target_player_id))
            }
            else
            {
                Player.Tell("^3Action ^1missing^7. (add, remove, list)")
                return;
            }
            
            guild.guild_members.split("-").forEach(member_id =>
                {
                    this.set_player_guild_stat(guild, member_id)
                }) 
        }
    }

    async set_player_guild_stat(guild, member_id)
    {
        await this.Server.DB.metaService.addPersistentMeta('guild_data', (guild.name + ";" + guild.guild_master + ";" + guild.guild_members
        + ";" + guild.size + ";" + guild.level + ";" + guild.xp
        + ";" + guild.bank + ";" + guild.hp + ";" + guild.speed
        + ";" + guild.skills + ";" + guild.revive), member_id) 
    }

    async guildWatcher()
    {
        //return
        await new Promise(resolve => setTimeout(resolve, 5000)) //wait for NSM to tether servers

        if(!this.Manager.Server.Hostname || !(this.Manager.Server.Hostname.includes('BRUTUS'))) //make this code work 1 time instead of 15
        {
            return
        }

        while (1)
        {
            var now = new Date();
            var day = now.getDay(); 
            var hours = now.getHours();
            var minutes = now.getMinutes();
           // console.log(day + " " + hours + " " + minutes)
            if (day == 6 && hours == 18 && minutes == 0)
            {
                for (const manager of this.Managers)
                    {
                        if (manager && manager.Server)
                            manager.Server.tmp = 1;
                    }
                var lowest_competitive_time_raid = 1000000;
                var winner_id_raid = 0;

                var lowest_competitive_time_ee = 1000000;
                var winner_id_ee = 0;

                var lowest_competitive_time_gamemode = 1000000;
                var winner_id_gamemode = 0;

                var highest_fr_round = 0;
                var winner_id_fr = 0;
                
                for(const guild_name_id of this.guild_list)
                {
                    var gm_id = parseInt(guild_name_id.split(";")[1])
                    console.log("searching guild of " + gm_id)
                    var guild_data = await this.Server.DB.metaService.getPersistentMeta('guild_data', gm_id)
                    if (!guild_data)
                    {
                        console.log("guild_data undefined, skipping guild")
                        continue
                    }
                    
                    var members_array = guild_data.Value.split(";")[2].split('-')
            
                    for (const member_id of members_array) //foreach guildmate of all guilds
                    {
                        var guild_quest = await this.Server.DB.metaService.getPersistentMeta('guild_quest', parseInt(member_id))
                        if (guild_quest)
                        {
                            var quest_array = guild_quest.Value.split(";")
                            for (const quest of quest_array)
                            {
                                if (quest == "raid_boss_quest")
                                {
                                    var player_competitive_time = await this.Server.DB.metaService.getPersistentMeta(quest, parseInt(member_id))
                                    if (player_competitive_time && parseInt(player_competitive_time.Value) < lowest_competitive_time_raid && parseInt(player_competitive_time.Value) > 0)
                                    {
                                        lowest_competitive_time_raid = parseInt(player_competitive_time.Value)
                                        winner_id_raid = parseInt(member_id)
                                    }
                                }
                                else if (quest.includes("ee_speedrun_quest"))
                                {
                                    var player_competitive_time = await this.Server.DB.metaService.getPersistentMeta(quest, parseInt(member_id))
                                    if (player_competitive_time && parseInt(player_competitive_time.Value) < lowest_competitive_time_ee && parseInt(player_competitive_time.Value) > 0)
                                    {
                                        lowest_competitive_time_ee = parseInt(player_competitive_time.Value)
                                        winner_id_ee = parseInt(member_id)
                                    }
                                }
                                else if (quest.includes("gamemode_speedrun_quest"))
                                {
                                    var player_competitive_time = await this.Server.DB.metaService.getPersistentMeta(quest, parseInt(member_id))
                                    if (player_competitive_time && parseInt(player_competitive_time.Value) < lowest_competitive_time_gamemode && parseInt(player_competitive_time.Value) > 0)
                                    {
                                        lowest_competitive_time_gamemode = parseInt(player_competitive_time.Value)
                                        winner_id_gamemode = parseInt(member_id)
                                    }
                                }
                                else if (quest == "first_room_hr_quest")
                                {
                                    var player_highest_fr_round = await this.Server.DB.metaService.getPersistentMeta(quest, parseInt(member_id))
                                    if (player_highest_fr_round && parseInt(player_highest_fr_round) > highest_fr_round && parseInt(player_highest_fr_round) > 0)
                                    {
                                        highest_fr_round = parseInt(player_highest_fr_round)
                                        winner_id_fr = parseInt(member_id)
                                    }
                                }
                            }
                        }
                    }
                }
                for(const guild_name_id of this.guild_list)
                {
                    await this.give_new_quest(parseInt(guild_name_id.split(";")[1]))
                }

                if (lowest_competitive_time_raid != 1000000)
                {
                    console.log("raid xp given to " + winner_id_raid)
                    await this.add_guild_xp(winner_id_raid, 60)
                }
                if (lowest_competitive_time_ee != 1000000)
                {
                    console.log("ee sn xp given to " + winner_id_ee)
                    await this.add_guild_xp(winner_id_ee, 60)
                }
                if (lowest_competitive_time_gamemode != 1000000)
                {
                    console.log("gamemode sn xp given to " + winner_id_gamemode)
                    await this.add_guild_xp(winner_id_gamemode, 60)
                }
                if (highest_fr_round != 0)
                {
                    console.log("fr xp given to " + winner_id_fr)
                    await this.add_guild_xp(winner_id_fr, 60)
                }
                for (const manager of this.Managers)
                    {
                        if (manager && manager.Server)
                            manager.Server.tmp = 0;
                    }
                return
            }
            await new Promise(resolve => setTimeout(resolve, 20000))
        }
    }

    async add_guild_xp(member_id, xp_earned)
    {
        var guild = await this.init_guild_data(member_id)

        if (guild.level >= 10)
            return
        var extra_xp_percent = 1
        for (const guild_member_id of guild.guild_members.split("-"))
        {
            var customName = await this.Server.DB.metaService.getPersistentMeta('custom_name', parseInt(guild_member_id))

            if (customName && customName.Value != "" && (customName.Value.includes('[^2VIP') || customName.Value.includes('^2VIP')))
                extra_xp_percent += 0.2
        }
        var xp_needed = 100;
        if (guild.level > 8)
            xp_needed = 200;
        else if (guild.level > 7)
            xp_needed = 150;
        else if (guild.level > 5)
            xp_needed = 120;


        if (guild.xp + parseInt((xp_earned * extra_xp_percent)) >= xp_needed)
        {
            guild.level++;

            var xp_left_to_add = (guild.xp + parseInt((xp_earned * extra_xp_percent))) - xp_needed
            guild.xp = xp_left_to_add
            if (guild.level == 4 || guild.level == 9)
            {
               guild.size++;
            }
        }
        else
        {
            guild.xp += parseInt((xp_earned * extra_xp_percent))
        } 

        console.log("total xp : " + guild.xp)
        await this.edit_guildmate_guild_data(guild)
        console.log("added " + parseInt((xp_earned * extra_xp_percent)) + " xp")
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

    async give_new_quest(member_id)
    {
        while (1)
        {
            if (this.are_quest_randomized == true) //make every subsequent fn calls wait for the quest randomizer vars to be set
            {
                this.are_quest_randomized = false
                break
            }
            await new Promise(resolve => setTimeout(resolve, 100))
        }
        var guild = await this.init_guild_data(member_id)

        var quest_basic = []
        quest_basic[quest_basic.length] = "kill_quest"
        quest_basic[quest_basic.length] = "headshot_quest"
        quest_basic[quest_basic.length] = "gamemode_completion_quest"
        quest_basic[quest_basic.length] = "ee_completion_quest"

        var quest_competitive = []
        if (this.gamemode_random == -1) // make all guild have the same competitive quest
            this.gamemode_random = randomInt(3)
        if (this.gamemode_random == 0)
           quest_competitive[quest_competitive.length] = "gamemode_speedrun_quest_pia"
        else if (this.gamemode_random == 1)
           quest_competitive[quest_competitive.length] = "gamemode_speedrun_quest_titb"
        else if (this.gamemode_random == 2)
           quest_competitive[quest_competitive.length] = "gamemode_speedrun_quest_botb"

        if (this.ee_random == -1) // make all guild have the same competitive quest
            this.ee_random = randomInt(5)
        if (this.ee_random == 0)
           quest_competitive[quest_competitive.length] = "ee_speedrun_quest_transit"
        if (this.ee_random == 1)
           quest_competitive[quest_competitive.length] = "ee_speedrun_quest_highrise"
        if (this.ee_random == 2)
           quest_competitive[quest_competitive.length] = "ee_speedrun_quest_prison"
        if (this.ee_random == 3)
           quest_competitive[quest_competitive.length] = "ee_speedrun_quest_buried"
        if (this.ee_random == 4)
           quest_competitive[quest_competitive.length] = "ee_speedrun_quest_tomb"

      //  quest_competitive[quest_competitive.length] = "first_room_hr_quest"

        var player_old_quest = await this.Server.DB.metaService.getPersistentMeta('guild_quest', member_id)
        if (player_old_quest) 
        {
            var player_old_quest_array = player_old_quest.Value.split(';') //remove old quest from pool to prevent duplicate
        //    console.log(member_id + " old quest list " + player_old_quest.Value)
            for (const old_quest of player_old_quest_array)
            {
                for (const quest of quest_basic)
                {
                    if (old_quest == quest)
                    {
                        const index = quest_basic.indexOf(quest)
                        if (index > -1)
                            quest_basic.splice(index, 1)
                    }
                }
                for (const quest of quest_competitive)
                {
                    if (old_quest == quest || (old_quest.includes("ee_speedrun_quest") && quest.includes("ee_speedrun_quest")) || (old_quest.includes("gamemode_speedrun_quest") && quest.includes("gamemode_speedrun_quest")))
                    {
                        const index = quest_competitive.indexOf(quest)
                        if (index > -1)
                            quest_competitive.splice(index, 1)
                    }
                }
            }
            for (const old_quest of player_old_quest_array) //reset all quest datas
            {
                await this.edit_guildmate_metadata(guild, old_quest, "0")
            }
        }

        var quest_list = "raid_boss_quest"

        //COMPETITIVE QUEST
        if (this.competitive_r == -1) // make all guild have the same competitive quest
            this.competitive_r = randomInt(quest_competitive.length)
        quest_list += ";" + quest_competitive[this.competitive_r]

        //BASIC QUEST
    //    if (this.basic_r == -1)
        this.basic_r = randomInt(quest_basic.length)
        quest_list += ";" + quest_basic[this.basic_r] 


        if (quest_basic[this.basic_r] == "kill_quest")
        {
            await this.edit_guildmate_metadata(guild, "kill_quest_start", "0")
        }
        if (quest_basic[this.basic_r] == "headshot_quest")
        {
            await this.edit_guildmate_metadata(guild, "headshot_quest_start", "0")
        }
        if (quest_basic[this.basic_r] == "gamemode_completion_quest")
        {
            await this.edit_guildmate_metadata(guild, "gamemode_completion_quest_start", "0")
        }
        if (quest_basic[this.basic_r] == "ee_completion_quest")
        {
            await this.edit_guildmate_metadata(guild, "ee_completion_quest_start", "0")
        }
        
        const index = quest_basic.indexOf(quest_basic[this.basic_r]) //remove selected 1st basic quest & run it again for 2nd
        if (index > -1)
            quest_basic.splice(index, 1)

     //   if (this.basic_r2 == -1)
        this.basic_r2 = randomInt(quest_basic.length)
        quest_list += ";" + quest_basic[this.basic_r2]

        if (quest_basic[this.basic_r2] == "kill_quest")
        {
            await this.edit_guildmate_metadata(guild, "kill_quest_start", "0")
        }
        if (quest_basic[this.basic_r2] == "headshot_quest")
        {
            await this.edit_guildmate_metadata(guild, "headshot_quest_start", "0")
        }
        if (quest_basic[this.basic_r2] == "gamemode_completion_quest")
        {
            await this.edit_guildmate_metadata(guild, "gamemode_completion_quest_start", "0")
        }
        if (quest_basic[this.basic_r2] == "ee_completion_quest")
        {
            await this.edit_guildmate_metadata(guild, "ee_completion_quest_start", "0")
        }

        for (const quest of quest_competitive)
        {
            await this.edit_guildmate_metadata(guild, quest, "0")
        }

        this.are_quest_randomized = true

        console.log(member_id + " new quest list : " + quest_list)
        await this.edit_guildmate_metadata(guild, 'guild_quest', quest_list)
    }

    async edit_guildmate_metadata(guild, data, value)
    {
        for(const guildmate_id of guild.guild_members.split("-"))
        {
            if (value != "-1")
            {
                if (data == "kill_quest_start")
                    {
                        var Player_Stats = await this.Server.DB.getPlayerPersStats(parseInt(guildmate_id), "Kills")
                        value = Player_Stats[0].Kills
                    }
                    else if (data == "headshot_quest_start")
                    {
                        var Player_Stats = await this.Server.DB.getPlayerPersStats(parseInt(guildmate_id), "Headshots")
                        value = Player_Stats[0].Headshots
                    }
                    else if (data == "gamemode_completion_quest_start")
                    {
                        var gamemodeCountTotal = await this.Server.DB.metaService.getPersistentMeta('gamemodeCountTotal', parseInt(guildmate_id))
                        if (gamemodeCountTotal)
                            value = gamemodeCountTotal.Value
                        else
                            value = 0
                    }
                    else if (data == "ee_completion_quest_start")
                    {
                        var eeCountTotal = await this.Server.DB.metaService.getPersistentMeta('eeCountTotal', parseInt(guildmate_id))
                        if (eeCountTotal)
                            value = eeCountTotal.Value
                        else
                            value = 0
                    }
            }

            await this.Server.DB.metaService.addPersistentMeta(data, value, parseInt(guildmate_id))
        }
    }

    async edit_guildmate_guild_data(guild)
    {
        for (const guildmate_id of guild.guild_members.split("-"))
        {
            await this.Server.DB.metaService.addPersistentMeta('guild_data', (guild.name + ";" + guild.guild_master + ";" + guild.guild_members
            + ";" + guild.size + ";" + guild.level + ";" + guild.xp
            + ";" + guild.bank + ";" + guild.hp + ";" + guild.speed
            + ";" + guild.skills + ";" + guild.revive), parseInt(guildmate_id)) 
        }
    }

    async print_competitive_timed_quest(Player, quest, quest_count)
    {
        var lowest_time = 100000
        var lowest_time_id = 0
        var lowest_time_guild_name = ""
        var pers_time = 0

        for (const guild_info of this.guild_list)
        {
            var guild = await this.init_guild_data(parseInt(guild_info.split(';')[1]))
            for(const member_id of guild.guild_members.split('-'))
            {
                var raid_boss_quest = await this.Server.DB.metaService.getPersistentMeta(quest, parseInt(member_id))
                if (!raid_boss_quest)
                {
                    await this.Server.DB.metaService.addPersistentMeta(quest, "0", parseInt(member_id))
                    raid_boss_quest = await this.Server.DB.metaService.getPersistentMeta(quest, parseInt(member_id))
                }
                if (parseFloat(raid_boss_quest.Value) < lowest_time && parseFloat(raid_boss_quest.Value) != 0)
                {
                    lowest_time = parseFloat(raid_boss_quest.Value)
                    lowest_time_id = parseInt(member_id)
                    lowest_time_guild_name = guild.name
                }
                if (parseInt(member_id) == Player.ClientId)
                {
                    pers_time = parseFloat(raid_boss_quest.Value)
                }
            }
        }

        var customName = await this.Server.DB.metaService.getPersistentMeta('custom_name', lowest_time_id)
        var name = await this.Server.getClient("@" + lowest_time_id.toString()).Name
        if (customName)
            name = customName.Value
        var pers_time_txt = "^1No Data^7"
        if (pers_time != 0)
            pers_time_txt = pers_time

        var lowest_time_txt = "^1No Data^7"
        if(lowest_time != 100000)
            lowest_time_txt = lowest_time

        var index = 0

        if (!Player.competitive_quest_count || Player.competitive_quest_count == 0)
        {
            Player.competitive_quest_count = 1
        }
        else
        {
            Player.competitive_quest_count++
            index++
        }

      /*  while (1) //wait to load everything before printing
        {
            if (Player.competitive_quest_count && Player.competitive_quest_count >= 2)
            {
                if (index > 0)
                {
                    console.log("waiting")
                    await new Promise(resolve => setTimeout(resolve, 1500))
                }

                break;
            }
            await new Promise(resolve => setTimeout(resolve, 100))
        }*/

        if (quest_count == 0)
        {
            Player.Tell("[^1Competitive Quests^7]")
            await new Promise(resolve => setTimeout(resolve, 50))
        }

        var quest_txt = ""
        var map_txt = ""
        var maps = []
        maps[maps.length] = "transit"
        maps[maps.length] = "tomb"
        maps[maps.length] = "highrise"
        maps[maps.length] = "prison"
        maps[maps.length] = "buried"

        var gamemodes = []
        gamemodes[gamemodes.length] = "botb"
        gamemodes[gamemodes.length] = "titb"
        gamemodes[gamemodes.length] = "pia"


        if (quest == "raid_boss_quest")
            quest_txt = "^1Raid Boss^3 Quest^7"
        else if (quest.includes("ee_speedrun_quest"))
        {
            if (quest == "ee_speedrun_quest_transit")
                quest_txt = "^1Tranzit EE Speedrun^3 Quest^7"
            if (quest == "ee_speedrun_quest_buried")
                quest_txt = "^1Buried EE Speedrun^3 Quest^7"
            if (quest == "ee_speedrun_quest_tomb")
                quest_txt = "^1Origins EE Speedrun^3 Quest^7"
            if (quest == "ee_speedrun_quest_prison")
                quest_txt = "^1MOTD EE Speedrun^3 Quest^7"
            if (quest == "ee_speedrun_quest_highrise")
                quest_txt = "^1Die Rise EE Speedrun^3 Quest^7"
        }
        else if (quest.includes("gamemode_speedrun_quest"))
        {
            if (quest == "gamemode_speedrun_quest_pia")
                quest_txt = "^1PiA Speedrun^3 Quest (^6GigaChad^7)^7"
            if (quest == "gamemode_speedrun_quest_botb")
                quest_txt = "^1BotB Speedrun^3 Quest (^6GigaChad^7)^7"
            if (quest == "gamemode_speedrun_quest_titb")
                quest_txt = "^1TitB Speedrun^3 Quest (^6GigaChad^7)^7"
        }


        Player.Tell("---- " + map_txt + quest_txt + " ----")
        await new Promise(resolve => setTimeout(resolve, 50))
        if (lowest_time == 100000)
            Player.Tell("No ^6Guild^7 have set a record for this ^3quest^7 yet.")
        else 
            Player.Tell("^3Best time^7: ^2" + lowest_time_txt + "^7 minutes by " + name + "^7 from " + lowest_time_guild_name + " guild.")
        await new Promise(resolve => setTimeout(resolve, 50))
        if (lowest_time_id == Player.ClientId)
            Player.Tell("^3Poggy^7 ! You have the ^2lead^7 !")
        else if (pers_time == 0)
            Player.Tell("You did not complete this ^3quest^7 yet.")
        else
            Player.Tell("^3Your time^7: ^2" + pers_time_txt + "^7 minutes.")

        if (Player.competitive_quest_count && Player.competitive_quest_count >= 2) //start loading basic quest
        {
            Player.competitive_quest_count = 0
            Player.competitive_quest_ended = 1 
        } 
    }

    async print_basic_score_quest(Player, quest, quest_count, quest_array)
    {
        while (1)
        {
            if(Player.competitive_quest_ended && Player.competitive_quest_ended == 1)
                break;
            await new Promise(resolve => setTimeout(resolve, 100))
        }

        var inGame = Utils.findClient(Player.ClientId, this.Managers)
        var count = 0;
        var pers = 0;
        var guild = await this.init_guild_data(Player.ClientId)
        var is_quest_completed = false;
        for(const member_id of guild.guild_members.split('-'))
        {
            var quest_metadata = await this.Server.DB.metaService.getPersistentMeta(quest, parseInt(member_id))
            if (!quest_metadata)
            {
                await this.Server.DB.metaService.addPersistentMeta(quest, "0", parseInt(member_id))
                quest_metadata = await this.Server.DB.metaService.getPersistentMeta(quest, parseInt(member_id))
            }
            if (quest_metadata.Value == "-1")
            {
                console.log(quest + " already completed")
                is_quest_completed = true
                break
            }

            if (parseInt(member_id) == Player.ClientId)
                pers = parseInt(quest_metadata.Value)
            count += parseInt(quest_metadata.Value)
        }

        if (quest_count == 2)
        {
            if (inGame)
                await new Promise(resolve => setTimeout(resolve, 5000))
            Player.Tell("\n[^2Basic Quests^7]")
            await new Promise(resolve => setTimeout(resolve, 50))
        }

        var quest_txt = ""
        var type_txt = ""
        var req_txt = ""
        if (quest == "kill_quest")
        {
            quest_txt = "^2Kill ^3Quest^7"
            type_txt = "Kills"
            req_txt = 15000
        }
        else if (quest == "headshot_quest")
        {
            quest_txt = "^2Headshot ^3Quest^7"
            type_txt = "Headshots"
            req_txt = 5000
        }
        else if (quest == "gamemode_completion_quest")
        {
            quest_txt = "^2Gamemode Completion ^3Quest^7"
            type_txt = "Gamemodes completed"
            req_txt = 30
        }
        else if (quest == "ee_completion_quest")
        {
            quest_txt = "^2EE Completion ^3Quest^7"       
            type_txt = "EE completed"
            req_txt = 30
        }

        Player.Tell("---- " + quest_txt + " ----")
        await new Promise(resolve => setTimeout(resolve, 50))

        if (is_quest_completed == true)
        {
            Player.Tell("^2Quest completed !^7")
            return
        }

        if (count >= req_txt)
        {
            //give quest rewards
            await this.add_guild_xp(Player.ClientId, 25)
            await this.edit_guildmate_metadata(guild, quest, "-1")
            Player.Tell("^2Quest completed ! ^5XP granted ^7")
            return
        }

        Player.Tell("Your ^6Guild score^7 : ^2" + count + " ^7/ ^1" + req_txt + "^3 " + type_txt)
        await new Promise(resolve => setTimeout(resolve, 50))
        Player.Tell("Your ^6score^7 : ^2" + pers + "^3 " + type_txt)

        if (quest_count + 1 == quest_array.length) // if last quest, reset wait/load system
        {
            Player.competitive_quest_ended = 0
        }
    }

    async add_timed_quest_metadata(quest)
    {
        var highest_kill = 0
        var highest_kill_id = 0

        var ig_quest_dvar = await this.Server.Rcon.getDvar(`${quest}`)
        var ig_quest = ig_quest_dvar.split(';')

        await this.Server.Rcon.setDvar(`${quest}`, "0")
        console.log("quest completed ! " + quest )


        if (quest == "raid_boss_quest")
        {
            for (const client of await this.Manager.Server.getClients())
            {
                if (client)
                {
                    var guild_data = await this.Server.DB.metaService.getPersistentMeta('guild_data', client.ClientId)
                    if (!guild_data)
                    {
                        continue
                    }
                    var quest_data = await this.Server.DB.metaService.getPersistentMeta(quest, client.ClientId)
                    if (quest_data && (parseFloat(ig_quest[0]) < parseFloat(quest_data.Value) || parseFloat(quest_data.Value) == 0))
                        await this.Server.DB.metaService.addPersistentMeta(quest, ig_quest[0], client.ClientId)
                }
            }
            return
        }
        for (const client of await this.Manager.Server.getClients())
        {
            if (client)
            {
                var guild_data = await this.Server.DB.metaService.getPersistentMeta('guild_data', client.ClientId)
                if (!guild_data)
                {
                    continue
                }

                for (const p_data of ig_quest)
                {
                    if (client.Guid == parseInt(p_data.split('-')[0])) //works cuz 1st value is the completion time and does not have a '-', hence [0] exist
                    {
                        if (highest_kill < parseInt(p_data.split('-')[1]))
                        {
                            highest_kill = parseInt(p_data.split('-')[1])
                            highest_kill_id = client.ClientId
                        }
                    }
                }
            }
        }
        if (highest_kill_id == 0)
        {
            this.Server.Rcon.executeCommandAsync(`set bold ^1Error, please contact staff.`) 
            await new Promise(resolve => setTimeout(resolve, 6000))
            console.log("run invalid")
            return
        }
        console.log("winner id  : " + highest_kill_id + " winner kills : " + highest_kill)
        var quest_data = await this.Server.DB.metaService.getPersistentMeta(quest, highest_kill_id)
        if (quest_data && (parseFloat(ig_quest[0]) < parseFloat(quest_data.Value) || parseFloat(quest_data.Value) == 0))
            await this.Server.DB.metaService.addPersistentMeta(quest, ig_quest[0], highest_kill_id)
    }

    /*async add_round_quest_metadata(quest)
    {
        var ig_quest = await this.Server.Rcon.getDvar(`${quest}`)
        var ig_quest = ig_quest_dvar.split(";")
        await this.Server.Rcon.setDvar(`${quest}`, "0")
        for (const client of await this.Manager.Server.getClients())
        {
            if (client)
            {
                var quest_data = await this.Server.DB.metaService.getPersistentMeta(quest, client.ClientId)
                if (quest_data && (parseFloat(ig_quest[0]) > parseFloat(quest_data.Value) || parseInt(quest_data.Value) == 0))
                    await this.Server.DB.metaService.addPersistentMeta(quest, ig_quest[0], client.ClientId)
            }

        }
    }*/

    async guildQuestWatcher()
    {
        var maps = []
        maps[maps.length] = "transit"
        maps[maps.length] = "tomb"
        maps[maps.length] = "highrise"
        maps[maps.length] = "prison"
        maps[maps.length] = "buried"

        var gamemodes = []
        gamemodes[gamemodes.length] = "botb"
        gamemodes[gamemodes.length] = "titb"
        gamemodes[gamemodes.length] = "pia"
        await new Promise(resolve => setTimeout(resolve, 5000))
        while (1)
        {
            if (await this.Server.Rcon.getDvar(`raid_boss_quest`) != "0")
            {
                await this.add_timed_quest_metadata("raid_boss_quest")
            }
            for (const map of maps)
            {
                if (await this.Server.Rcon.getDvar(`ee_speedrun_quest_${map}`) != "0")
                {
                    await this.add_timed_quest_metadata("ee_speedrun_quest_" + map)
                }
            }
            for (const gamemode of gamemodes)
            {
                if (await this.Server.Rcon.getDvar(`gamemode_speedrun_quest_${gamemode}`) != "0")
                {
                    await this.add_timed_quest_metadata("gamemode_speedrun_quest_" + gamemode)
                }
            }

        /*    if (await this.Server.Rcon.getDvar(`first_room_hr_quest`) != "0")
            {
                await this.add_round_quest_metadata("first_room_hr_quest")
            }*/
            await new Promise(resolve => setTimeout(resolve, 3000))
        }
    }

    async modifierWatcher()
    {
        await new Promise(resolve => setTimeout(resolve, 5000))
        if(!(this.Manager.Server.Hostname) || this.Manager.Server.Hostname.includes('BURIED') || this.Manager.Server.Hostname.includes('NUKETOWN') || this.Manager.Server.Hostname.includes('RISE'))
        {
            return
        }

        for(;;)
        {
            var modif = 0
            var restart = await this.Server.Rcon.getDvar(`restart1`)
            if (restart && restart != "0")
            {
                await this.Server.Rcon.setDvar(`restart1`, "0")
                for (const client of await this.Manager.Server.getClients())
                    {
                        if (client)
                        {
                            var guild = await this.init_guild_data(client.ClientId)
                            if (guild && guild.level >= 8)
                            {
                                if(this.Manager.Server.Hostname && (await this.is_brutus() == true || this.Manager.Server.Hostname.includes('PANZER')
                                    || this.Manager.Server.Hostname.includes('BUS')))
                                {
                                    await this.Server.Rcon.setDvar(`guild_modifier`, "1")
                                    this.Server.Rcon.executeCommandAsync(`set ln ^2+1 modifier^7 from ^6Guild ${guild.name}^7`)
                                    modif = 1
                                }
                            }
                            if (guild && guild.level >= 3)
                            {
                                if(this.Manager.Server.Hostname && this.is_raid() == true)
                                {
                                    await this.Server.Rcon.setDvar(`skill_cooldown`, "1")
                                    this.Server.Rcon.executeCommandAsync(`set ln ^2+33% Skill Haste^7 from ^6Guild ${guild.name}^7`)    
                                }

                            }
                            if (guild && guild.level >= 10)
                            {
                                await new Promise(resolve => setTimeout(resolve, parseInt(client.Clientslot) * 250))
                                await this.Server.Rcon.executeCommandAsync(`set hat ${client.Guid}`)
                            }
                                
                        }
                    }
                if (modif == 0)
                    await this.Server.Rcon.setDvar(`guild_modifier`, "2")
            }
            await new Promise(resolve => setTimeout(resolve, 1000))
        }
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