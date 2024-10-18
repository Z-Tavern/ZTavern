#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_zm_perks;
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
#include maps\mp\zombies\_zm_stats;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zombies\_zm_chugabud;
#include maps\mp\zombies\_zm_afterlife;
#include maps\mp\zombies\_zm_tombstone;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\zombies\_zm_perk_vulture;
#include maps\mp\zombies\_zm_weap_time_bomb;

#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\_demo;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_pers_upgrades_functions;
#include maps\mp\gametypes_zm\_gameobjects;
#include maps\mp\zombies\_zm_buildables;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\zombies\_zm_chugabud;
#include maps\mp\zombies\_zm_perks;


#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\zombies\_zm_chugabud;
#include maps\mp\zombies\_zm_perks;
#include maps\mp\zombies\_zm_clone;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_weap_cymbal_monkey;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\zombies\_zm;
#include maps\mp\_visionset_mgr;

//motd
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_craftables;
#include maps\mp\zm_alcatraz_utility;
#include maps\mp\zm_alcatraz_gamemodes;
#include maps\mp\zm_prison_fx;
#include maps\mp\zm_prison_ffotd;
#include maps\mp\zombies\_zm;
#include maps\mp\animscripts\zm_death;
#include maps\mp\zm_alcatraz_amb;
#include maps\mp\zombies\_load;
#include maps\mp\zm_prison_achievement;
#include maps\mp\gametypes_zm\_spawning;
#include maps\mp\zombies\_zm_perk_electric_cherry;
#include maps\mp\zombies\_zm_perk_divetonuke;
#include maps\mp\zm_alcatraz_distance_tracking;
#include maps\mp\zm_alcatraz_traps;
#include maps\mp\zm_alcatraz_travel;
#include maps\mp\zombies\_zm_magicbox_prison;
#include maps\mp\zombies\_zm_ai_basic;
#include maps\mp\zombies\_zm_weap_claymore;
#include maps\mp\zombies\_zm_weap_riotshield_prison;
#include maps\mp\zombies\_zm_weap_blundersplat;
#include maps\mp\zombies\_zm_weap_tomahawk;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\zm_alcatraz_weap_quest;
#include maps\mp\zm_alcatraz_grief_cellblock;
#include maps\mp\_visionset_mgr;
#include maps\mp\zm_prison;
#include character\c_zom_arlington;
#include character\c_zom_deluca;
#include character\c_zom_handsome;
#include character\c_zom_oleary;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_blockers;

//points
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_pers_upgrades_functions;


//timebomb
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\_visionset_mgr;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_blockers;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\zombies\_zm_weapon_locker;
#include maps\mp\zombies\_zm_magicbox;
#include maps\mp\zombies\_zm_perks;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\animscripts\zm_death;
#include maps\mp\zombies\_zm_ai_basic;
#include maps\mp\zombies\_zm_weap_time_bomb;


init() {
	setDvar("killzm", "0");
	setDvar("killzmadmin", "0");
	setDvar("customround", "0");
	level thread killZm();
	if(level.script != "zm_highrise")
		level thread setZmCount();
//	level thread setRound();

}


/*setRound()
{
	for(;;)
	{
		if (getDvar("customround") != "0")
		{
			customround = int(getDvar("customround"));
			level.round_number = customround;
			if(customround == level.round_number)
				setDvar("customround", "0");
		}
		wait 3;
	}
}*/

setZmCount()
{
	saveRound = 0;

	for (;;)
	{
/*		if (level.round_number == 1 && level.round_number != saveRound)
		{
			saveRound = level.round_number;
			wait 20;
			level.zombie_total = 4;			
		}*/
		if (level.round_number == 2 && level.round_number != saveRound)
		{
			saveRound = level.round_number;
			wait 16;
			level.zombie_total = 6;			
		}
		if (level.round_number == 3 && level.round_number != saveRound)
		{
			saveRound = level.round_number;
			wait 16;
			level.zombie_total = 12;			
		}
		if (level.round_number == 4 && level.round_number != saveRound)
		{
			saveRound = level.round_number;
			wait 16;
			level.zombie_total = 18;			
		}
		if (level.round_number == 5 && level.round_number != saveRound)
		{
			saveRound = level.round_number;
			wait 16;
			level.zombie_total = 23;			
		}
		if (level.round_number == 6 && level.round_number != saveRound)
		{
			saveRound = level.round_number;
			wait 16;
			level.zombie_total = 28;			
		}
		if (level.round_number == 7 && level.round_number != saveRound)
		{
			saveRound = level.round_number;
			wait 16;
			level.zombie_total = 29;			
		}
		if (level.round_number == 8 && level.round_number != saveRound)
		{
			saveRound = level.round_number;
			wait 16;
			level.zombie_total = 30;			
		}
		if (level.round_number == 9 && level.round_number != saveRound)
		{
			saveRound = level.round_number;
			wait 16;
			level.zombie_total = 31;			
		}
		if (level.round_number == 10 && level.round_number != saveRound)
		{
			saveRound = level.round_number;
			wait 16;
			level.zombie_total = 34;			
		}
		if (level.round_number > 10 && level.round_number != saveRound)
		{
			saveRound = level.round_number;
			wait 16;
			intval = int((0.0896 * (saveRound * saveRound)) + (0.0115 * saveRound) + 23.518);
			level.zombie_total = intval;
		}
		if (level.zombie_total < 0)
			level.zombie_total = 0;
		wait 1;
	}
}

killZm()
{
	for(;;)
	{
		if (getDvar("killzmadmin") == "1")
		{
			zombies = getaiarray( level.zombie_team );
			if (zombies && zombies.size > 0)
			{
				for ( i = 0; i < zombies.size; i++ )
				{
					zombies[i] dodamage( zombies[i].health + 666, zombies[i].origin );
				}
				iPrintLn("^1Admin Access Code^7: Killing all ^1spawned zombies^7.");
			}
			setDvar("killzmadmin", "0");
		}
		else if (level.script == "zm_transit" || level.script == "zm_buried")
		{
			if(getDvar("killzm") == "1")
			{
				zombies = getaiarray( level.zombie_team );
				if (zombies && zombies.size > 0)
				{
					if(zombies.size == 1 || zombies.size == 2 )
					{
						zombies[0] dodamage( zombies[0].health + 666, zombies[0].origin );
						iPrintLn("^1Killing^7 last zombie.");
					}
					else
					{
						iPrintLn("Can only use ^3.kill command^7 when ^11/2 zombie/witch is left.");
					}
				}
				setDvar("killzm", "0");
			}
		}
		wait 1;
	}
}