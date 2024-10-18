#include maps\mp\_visionset_mgr;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\_demo;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_pers_upgrades_functions;
#include maps\mp\zombies\_zm_power;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zombies\_zm_chugabud;
#include maps\mp\zombies\_zm_afterlife;
#include maps\mp\zombies\_zm_tombstone;
#include maps\mp\zombies\_zm_perk_vulture;
#include maps\mp\zombies\_zm_weap_time_bomb;

#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_gameobjects;
#include maps\mp\zombies\_zm_buildables;


#include maps\mp\zombies\_zm_perks;
#include maps\mp\zombies\_zm_clone;
#include maps\mp\zombies\_zm_weap_cymbal_monkey;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\zombies\_zm;


init()
{
    level thread onPlayerConnect();
}

onPlayerConnect()
{
	for (;;)
	{
		level waittill( "connected", player );
        player thread onPlayerSpawned();
	}
}

onPlayerSpawned()
{
	self endon( "disconnect" );
	level endon( "game_ended" );
    flag_wait( "initial_blackscreen_passed" );
    for (;;)
    {
        tag = strTok(self.name, "]");
        if(tag[1] == "[^3VIP^7" || tag[1] == "^3[VIP" || tag[0] == "[^3SSS^7" )
        {
            if(self.sessionstate != "spectator" && self HasPerk("specialty_armorvest") == 0 && self.afterlife != 1)
            {
                if (self player_is_in_laststand())
                {
                }
                else
                {
                    self thread maps\mp\zombies\_zm_perks::wait_give_perk("specialty_armorvest", 1);
                }
                wait 2;
            }
        }
        wait 0.5;
    }
}