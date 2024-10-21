# ZTavern Bo2 Mods & Server setup
## Install
- Setup a Bo2 Server
https://plutonium.pw/docs/server/t6/setting-up-a-server/

- Install Fed's Node Server Manager
https://github.com/alicealys/node-server-manager

### Copy & paste all folder contents
- node-server-manager -> **node-server-manager installed folder**
- bo2 -> **your bo2 server root directory**
- t6 -> **%localappdata%\Plutonium\storage\t6**

### Server keys
- Make sure to add your Plutonium server keys in all **bo2/!start_zm_serverxxx.bat** files
- Change the **gamelogs path** for each server according to yours in **node-server-manager/Configuration/NSMConfiguration.json**
- Server key name must be named as follow :
**(Your server name) | BRUTUS ON THE BRIDGE | (extra txt)**

### Server name list 
- PRIVATE SERVER
- RAID BOSS
- BRUTUS ON THE BRIDGE
- TRANZIT IN THE BUS
- PANZER IN AGARTHA
- ORIGINS
- ORIGINS2
- BURIED
- TRANZIT2
- DIE RISE
- TOWN
- TOWN2
- TOWN3
- MOTD
- NUKETOWN

### Auto server restart .bat file
- Depending on where you installed **node-server-manager folder**, edit the path used in **bo2/!restart_servers.bat**

## How to run
- **bo2/!restart_servers.bat** start and restart all servers along with NSM every 6 hours

## Misc.
### Where to look in NSM folders ?
- 99% of my work on the NodeJS side is located in **node-server-manager/Plugin** : **ZombieBank.js**, **ClanTag.js** & **ZombieStats.js**

### Add moderator permissions
- Add the **.id** of target in staff.gsc (**t6/scripts** directory)
- Add the **.pguid** of target in **ZombieBank.js**, **ClanTag.js**, **ZombieStats.js**, **NativeCommands.js**

### Use Bo2 command on Discord

- Go to https://discord.com/developers/applications and create a bot
- In **node-server-manager/Configuration/NSMConfiguration.json** Fill in the discord : hookurl, secret, clientid, bot token
- For discordOAuth2Url use the following format : http://[server_ip]:8000/api/discord/callback without bracket
- In discord dev website, go to your bot, OAuth2, and paste the same address in Redirects


### Database
- If you wish to keep the progress of all previous players, download the database (personal data removed):
https://drive.google.com/file/d/1bHtH4IWqbwneiGNMQ11JdKcxjzqn8j40/view?usp=sharing
- Place it in **node-server-manager/Database** folder

## Server Spec
- Each server takes up to 1gb of ram with the 6 hours restart
- You will need a minimum of 16gb available ram to run all 15 servers
- I recommend BuyVM using the Quake3 application filter for a strong DDoS protection