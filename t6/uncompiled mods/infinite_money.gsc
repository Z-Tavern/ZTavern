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
	level._game_module_point_adjustment = ::doublepoints;
}

doublepoints(player, zombie_team, player_points){
	player maps/mp/zombies/_zm_score::add_to_player_score( player_points * 1000);
	player.pers[ "score" ] = player.score;
}