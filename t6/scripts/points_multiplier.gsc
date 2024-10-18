#include maps\mp\zombies\_zm_power;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zombies\_zm_chugabud;
#include maps\mp\zombies\_zm_afterlife;
#include maps\mp\zombies\_zm_tombstone;
#include maps\mp\zombies\_zm_perk_vulture;
#include maps\mp\zombies\_zm_weap_time_bomb;
#include maps\mp\_demo;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_pers_upgrades_functions;
#include maps\mp\gametypes_zm\_gameobjects;
#include maps\mp\zombies\_zm_buildables;
#include maps\mp\zombies\_zm_perks;
#include maps\mp\zombies\_zm_clone;
#include maps\mp\zombies\_zm_weap_cymbal_monkey;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\zombies\_zm;
#include maps\mp\_visionset_mgr;
//motd
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_craftables;
#include maps\mp\zm_alcatraz_utility;
#include maps\mp\zm_alcatraz_gamemodes;
#include maps\mp\zm_prison_fx;
#include maps\mp\zm_prison_ffotd;
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


//timebomb
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\zombies\_zm_weapon_locker;
#include maps\mp\zombies\_zm_magicbox;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_spawner;

init()
{
	level._game_module_point_adjustment = ::doublepoints;
		level.is_private = 0;
	if (getdvar("net_port") == "30005")
		level.is_private = 1;
}

doublepoints(player, zombie_team, player_points)
{
	if (player_points != 0)
	{
		tag = strTok(player.name, "]");
		if (tag[0] == "[^9F^7")
		{
			player maps\mp\zombies\_zm_score::add_to_player_score( player_points );
			player.pers[ "score" ] = player.score;
		}
		else if (tag[0] == "[^8E^7")
		{
			player maps\mp\zombies\_zm_score::add_to_player_score( player_points * 3);
			player.pers[ "score" ] = player.score;
		}
		else if (tag[0] == "[^2D^7")
		{
			player maps\mp\zombies\_zm_score::add_to_player_score( player_points * 3);
			player.pers[ "score" ] = player.score;
		}
		else if (tag[0] == "[^4C^7")
		{
			player maps\mp\zombies\_zm_score::add_to_player_score( player_points * 4);
			player.pers[ "score" ] = player.score;
		}
		else if (tag[0] == "[^5B^7")
		{
			player maps\mp\zombies\_zm_score::add_to_player_score( player_points * 4);
			player.pers[ "score" ] = player.score;
		}
		else if (tag[0] == "[^6A^7")
		{
			player maps\mp\zombies\_zm_score::add_to_player_score( player_points * 5);
			player.pers[ "score" ] = player.score;
		}
		else if (tag[0] == "[^3S^7")
		{
			player maps\mp\zombies\_zm_score::add_to_player_score( player_points * 6);
			player.pers[ "score" ] = player.score;
		}
		else if (tag[0] == "[^3SS^7")
		{
			player maps\mp\zombies\_zm_score::add_to_player_score( player_points * 7);
			player.pers[ "score" ] = player.score;
		}
		else if (tag[0] == "[^3SSS^7")
		{
			player maps\mp\zombies\_zm_score::add_to_player_score( player_points * 9);
			player.pers[ "score" ] = player.score;
		}
		else if (tag[0] == "[^6 I ^7")
		{
			player maps\mp\zombies\_zm_score::add_to_player_score( player_points * 10);
			player.pers[ "score" ] = player.score;
		}
		else if (tag[0] == "[^6II^7")
		{
			player maps\mp\zombies\_zm_score::add_to_player_score( player_points * 11);
			player.pers[ "score" ] = player.score;
		}
		else if (tag[0] == "[^6III^7")
		{
			player maps\mp\zombies\_zm_score::add_to_player_score( player_points * 12);
			player.pers[ "score" ] = player.score;
		}
		else if (tag[0] == "[^5IV^7")
		{
			player maps\mp\zombies\_zm_score::add_to_player_score( player_points * 13);
			player.pers[ "score" ] = player.score;
		}
		else if (tag[0] == "[^5V^7")
		{
			player maps\mp\zombies\_zm_score::add_to_player_score( player_points * 13);
			player.pers[ "score" ] = player.score;
		}
		else if (tag[0] == "[^5VI^7")
		{
			player maps\mp\zombies\_zm_score::add_to_player_score( player_points * 13);
			player.pers[ "score" ] = player.score;
		}
		else if (tag[0] == "[^5VII^7")
		{
			player maps\mp\zombies\_zm_score::add_to_player_score( player_points * 14);
			player.pers[ "score" ] = player.score;
		}
		else if (tag[0] == "[^1IIX^7")
		{
			player maps\mp\zombies\_zm_score::add_to_player_score( player_points * 15);
			player.pers[ "score" ] = player.score;
		}
		else if (tag[0] == "[^1IX^7")
		{
			player maps\mp\zombies\_zm_score::add_to_player_score( player_points * 15);
			player.pers[ "score" ] = player.score;
		}
		else if (tag[0] == "[^1-X-^7")
		{
			player maps\mp\zombies\_zm_score::add_to_player_score( player_points * 20);
			player.pers[ "score" ] = player.score;
		}
		if (tag[1])
		{
			if(tag[1] == "[^3VIP^7" || tag[1] == "^3[VIP" || tag[1] == "^6[VIP" || tag[1] == "[^6VIP^7" || tag[1] == "^1[VIP" || tag[1] == "[^1VIP^7")
			{	
				player maps\mp\zombies\_zm_score::add_to_player_score( player_points * 3);
				player.pers[ "score" ] = player.score;
			}
		}
		if (level.is_private == 1)
		{
			player maps\mp\zombies\_zm_score::add_to_player_score( player_points * 7);
			player.pers[ "score" ] = player.score;
		}
	}
}