#include maps\mp\_utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\_busing;
#include common_scripts\utility;
#include maps\mp\gametypes_zm\_tweakables;
#include maps\mp\gametypes_zm\_globallogic_ui;
#include maps\mp\gametypes_zm\_globallogic_audio;
#include maps\mp\gametypes_zm\_globallogic_spawn;
#include maps\mp\gametypes_zm\_globallogic_score;
#include maps\mp\gametypes_zm\_globallogic_defaults;
#include maps\mp\gametypes_zm\_hud_message;
#include maps\mp\gametypes_zm\_globallogic_utils;
#include maps\mp\_demo;
#include maps\mp\gametypes_zm\_globallogic_player;
#include maps\mp\gametypes_zm\_weapons;
#include maps\mp\_music;
#include maps\mp\_challenges;
#include maps\mp\gametypes_zm\_hud;
#include maps\mp\gametypes_zm\_serversettings;
#include maps\mp\gametypes_zm\_clientids;
#include maps\mp\gametypes_zm\_weaponobjects;
#include maps\mp\gametypes_zm\_scoreboard;
#include maps\mp\gametypes_zm\_shellshock;
#include maps\mp\gametypes_zm\_spectating;
#include maps\mp\gametypes_zm\_gameobjects;
#include maps\mp\gametypes_zm\_spawnlogic;
#include maps\mp\gametypes_zm\_dev;
#include maps\mp\gametypes_zm\_hostmigration;
#include maps\mp\gametypes_zm\_globallogic;


init()
{
    setDvar("spectator", "");
        level thread playerSpectator();
}

playerSpectator() {
	for (;;) {
		if (getDvar("spectator") != "") {
			spectator = strTok(getDvar("spectator"), ";");
			setDvar("spectator", "");
            if (isAlive(getPlayerByGuid(spectator[0])))
            {
                getPlayerByGuid(spectator[0]) maps\mp\gametypes_zm\_globallogic_spawn::respawn_asspectator(0, 0);
			    getPlayerByGuid(spectator[0]) iPrintLn("^3Spectator mode set.^7");
            }
		}
		wait 0.05;
	}
}

getPlayerByGuid(guid) {
    	for (i = 0; i < level.players.size; i++) {
        	if (isAlive(level.players[i]) && int(level.players[i] getGuid()) == int(guid)) {
            	return level.players[i];
        	} 
    	}
    	return false;
}