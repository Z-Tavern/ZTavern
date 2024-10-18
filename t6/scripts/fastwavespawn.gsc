#include maps\mp\gametypes_zm\_globallogic_player;
#include maps\mp\gametypes_zm\_spawning;
#include maps\mp\gametypes_zm\_globallogic_audio;
#include maps\mp\gametypes_zm\_globallogic_utils;
#include maps\mp\gametypes_zm\_globallogic;
#include maps\mp\gametypes_zm\_hud_message;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_globallogic_ui;
#include maps\mp\gametypes_zm\_globallogic_defaults;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\gametypes_zm\_globallogic_score;
#include maps\mp\gametypes_zm\_hostmigration;
#include maps\mp\gametypes_zm\_globallogic_spawn;
#include maps\mp\gametypes_zm\_spectating;
#include maps\mp\_demo;
#include maps\mp\gametypes_zm\_weapons;
#include maps\mp\gametypes_zm\_spawnlogic;
#include maps\mp\_challenges;
#include maps\mp\gametypes_zm\_tweakables;

#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_ffotd;
#include maps\mp\zombies\_zm;
#include maps\mp\_visionset_mgr;
#include maps\mp\zombies\_zm_devgui;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_blockers;
#include maps\mp\zombies\_zm_bot;
#include maps\mp\zombies\_zm_clone;
#include maps\mp\zombies\_zm_buildables;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\zombies\_zm_magicbox;
#include maps\mp\zombies\_zm_perks;
#include maps\mp\zombies\_zm_playerhealth;
#include maps\mp\zombies\_zm_power;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\zombies\_zm_gump;
#include maps\mp\zombies\_zm_timer;
#include maps\mp\zombies\_zm_traps;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_tombstone;
#include maps\mp\zombies\_zm_pers_upgrades;
#include maps\mp\gametypes_zm\_zm_gametype;
#include maps\mp\zombies\_zm_pers_upgrades_functions;
#include maps\mp\zombies\_zm_melee_weapon;
#include maps\mp\zombies\_zm_ai_dogs;
#include maps\mp\zombies\_zm_pers_upgrades_system;
#include maps\mp\zombies\_zm_ai_basic;
#include maps\mp\zombies\_zm_game_module;

init()
{
        //level.zombie_vars["zombie_between_round_time"] = 1;
        //level.zombie_vars["zombie_intermission_time"] = 1;
      //  level.zombie_vars["zombie_move_speed_multiplier"] = 3600; 
        level thread SpawnRate(); 
    if (level.script == "zm_transit")
    {
        level.zombie_vars["riotshield_hit_points"] = 30000;
    }

}

SpawnRate()
{
    level endon("game_ended");
    level.zombie_vars["zombie_spawn_delay"] = 1.5;

    lock = 0;
    for (;;)
    {
        if (lock == 2 && level.round_number >= 15)
        {
            level.zombie_vars["zombie_spawn_delay"] = 0;
            iPrintLn("^3The zombies are ^1REALLY angry ^7! Spawn rate ^1maxed out^7");
            wait 5;
            iPrintLn("^3The zombies are ^1REALLY angry ^7! Spawn rate ^1maxed out^7");
            lock = 3;
        } 
        if (lock == 1 && level.round_number >= 10)
        {
            level.zombie_vars["zombie_spawn_delay"] = 0.5;
            lock = 2;
            iPrintLn("^3The zombies are ^1angry ^7! Spawn rate ^3increased^7");
            wait 5;
            iPrintLn("^3The zombies are ^1angry ^7! Spawn rate ^3increased^7");           
        }  
        if (lock == 0 && level.round_number >= 5)
        {
            level.zombie_vars["zombie_spawn_delay"] = 1;
            lock = 1;
            iPrintLn("^3The zombies are ^1pissed ^7! Spawn rate ^3increased^7");
            wait 5;
            iPrintLn("^3The zombies are ^1pissed ^7! Spawn rate ^3increased^7");
        }
        wait 1;
    }
}