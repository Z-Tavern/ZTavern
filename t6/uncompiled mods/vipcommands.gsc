
#include maps\mp\_visionset_mgr;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\_demo;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_power;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zombies\_zm_chugabud;
#include maps\mp\zombies\_zm_afterlife;
#include maps\mp\zombies\_zm_tombstone;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\zombies\_zm_perk_vulture;
#include maps\mp\zombies\_zm_weap_time_bomb;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_pers_upgrades_functions;
#include maps\mp\gametypes_zm\_gameobjects;
#include maps\mp\zombies\_zm_buildables;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_perks;
#include maps\mp\zombies\_zm_clone;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_weap_cymbal_monkey;
#include maps\mp\zombies\_zm;

init()
{
	setDvar("revive", "");
    setDvar("0_revivedRound", -10);
    setDvar("1_revivedRound", -10);
    setDvar("2_revivedRound", -10);
    setDvar("3_revivedRound", -10);
    setDvar("4_revivedRound", -10);
    setDvar("5_revivedRound", -10);
    setDvar("6_revivedRound", -10);
    setDvar("7_revivedRound", -10);
    setDvar("currentRound", 0);
    level thread playerReviveCommand();
}

playerReviveCommand()
{
    level endon("game_ended");

	for (;;)
    {
        if (getdvar("currentRound") != level.round_number)
            setdvar("currentRound", level.round_number);
		if (getDvar("revive") != "")
        {
            content = strTok(getDvar("revive"), ";");
            setDvar("revive", "");
            revivePlayers(content);
            iPrintLn(getPlayerByGuid(content[0]).name + "^7 has ^3revived everyone ^7!");
            if (content[1] == "1")
                iPrintLn("^1Juggernog^7 granted to the fallens !");

		}
		wait 0.5;
	}	
}

revivePlayers(content)
{
    	for (i = 0; i < level.players.size; i++)
        {
            if(level.players[i] maps\mp\zombies\_zm_laststand::player_is_in_laststand())
            {
                level.players[i] thread maps\mp\zombies\_zm_laststand::auto_revive(level.players[i]);
                level.players[i] thread PlayerTempInvulnerability();
                if (content[1] == "1" && level.players[i] HasPerk("specialty_armorvest") == 0)
                    level.players[i] thread maps\mp\zombies\_zm_perks::wait_give_perk("specialty_armorvest", 1);
            }
		    else if(level.players[i].sessionstate == "spectator")
		    {
			    level.players[i] [[ level.spawnplayer ]]();
                level.players[i] thread PlayerTempInvulnerability();
                if (content[1] == "1"  && level.players[i] HasPerk("specialty_armorvest") == 0)
                    level.players[i] thread maps\mp\zombies\_zm_perks::wait_give_perk("specialty_armorvest", 1);
		    } 
    	}
        if (level.script != "zm_tomb" || level.script != "zm_prison" || !is_classic())
	    {
		    thread maps\mp\zombies\_zm::refresh_player_navcard_hud();
	    }
}

PlayerTempInvulnerability()
{
    level endon("game_ended");
    self endon("player_disconnected");
    self EnableInvulnerability();
    self.ignoreme = true;
    self iPrintln("Invincibility ^2ON^7 for ^35 seconds^7");
    wait 5;
    self iPrintln("Invincibility ^1OFF^7");
    self DisableInvulnerability();
    self.ignoreme = false;
    self Destroy();
}

getPlayerByGuid(guid) {
    	for (i = 0; i < level.players.size; i++) {
        	if (isAlive(level.players[i]) && int(level.players[i] getGuid()) == int(guid)) {
            	return level.players[i];
        	} 
    	}
    	return false;
}