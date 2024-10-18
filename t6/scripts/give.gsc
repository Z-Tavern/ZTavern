
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
	setDvar("give", "");
    level thread giveCommand();
}

giveCommand()
{
    level endon("game_ended");
	for (;;)
    {
		if (getDvar("give") != "")
        {
            content = strTok(getDvar("give"), ";");
            setDvar("give", "");
            
            if (int(content[0]) == -1)
            {
                for (i = 0; i < level.players.size; i++)
                {
                    weapon_list = level.players[i] GetWeaponsListPrimaries();
                    level.players[i] TakeWeapon(weapon_list[int(content[2])]);         
                    level.players[i] GiveWeapon(content[1], int(content[2]));
                    level.players[i] SwitchToWeapon(content[1]);
                    level.players[i] IPrintLn("You have been given ^3" + content[1] + "^7");
                }
            }
            else
            {
                for (i = 0; i < level.players.size; i++)
                {
                    iprintln(level.players[i] getEntityNumber() + level.players[i].name);
                    if (level.players[i] getEntityNumber() == int(content[0]))
                    {
                        weapon_list = level.players[i] GetWeaponsListPrimaries();
                        level.players[i] TakeWeapon(weapon_list[int(content[2])]);         
                        level.players[i] GiveWeapon(content[1], int(content[2]));
                        level.players[i] SwitchToWeapon(content[1]);
                        level.players[i] IPrintLn("You have been given ^3" + content[1] + "^7");
                    }
                }
            }
		}
		wait 0.5;
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