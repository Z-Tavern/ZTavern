# ZTavern Bo2 Mods & Server setup
## Install
- Setup a Bo2 Server
https://plutonium.pw/docs/server/t6/setting-up-a-server/

- Install Fed's Node Server Manager
https://github.com/alicealys/node-server-manager

- Copy & paste all folder contents
node-server-manager -> node-server-manager installed folder
bo2 -> your bo2 server root directory
t6 -> %localappdata%\Plutonium\storage\t6

### Server keys
- Make sure to add your Plutonium server keys in all "!start_zm_serverxxx.bat"
- Change the gamelogs path for each server according to yours in node-server-manager/Configuration/NSMConfiguration.json

**Server name**
- Server key name must be named as follow :
(Your server name) | BRUTUS ON THE BRIDGE | (extra txt)

- Server name list :
PRIVATE SERVER
RAID BOSS
BRUTUS ON THE BRIDGE
TRANZIT IN THE BUS
PANZER IN AGARTHA
ORIGINS
ORIGINS2
BURIED
TRANZIT2
DIE RISE
TOWN
TOWN2
TOWN3
MOTD
NUKETOWN

### Auto server restart .bat file
- Depending on where you installed node-server-manager folder, edit the path used in bo2/!restart_servers.bat

## How to run
- bo2/!restart_servers.bat start and restart all servers along with NSM every 6 hours

## Misc.
### Where to look in NSM folders ?
- 99% of my work on the NodeJS side is located in the Plugin folder : ZombieBank.js, ClanTag.js & ZombieStats.js

### Add moderator permissions
- Add the .id of target in staff.gsc (t6/scripts directory)
- Add the .pguid of target in ZombieBank.js, ClanTag.js, ZombieStats.js, NativeCommands.js
