#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zm_buried_gamemodes;
#include maps\mp\zombies\_zm_banking;
#include maps\mp\zm_buried_sq;
#include maps\mp\zombies\_zm_weapon_locker;
#include maps\mp\zm_buried_distance_tracking;
#include maps\mp\zm_buried_fx;
#include maps\mp\zm_buried_ffotd;
#include maps\mp\zm_buried_buildables;
#include maps\mp\zombies\_zm;
#include maps\mp\animscripts\zm_death;
#include maps\mp\zm_buried_amb;
#include maps\mp\zombies\_zm_ai_ghost;
#include maps\mp\zombies\_zm_ai_sloth;
#include maps\mp\zombies\_load;
#include maps\mp\teams\_teamset_cdc;
#include maps\mp\gametypes_zm\_spawning;
#include maps\mp\zombies\_zm_perk_divetonuke;
#include maps\mp\zombies\_zm_perk_vulture;
#include maps\mp\zm_buried_jail;
#include maps\mp\zombies\_zm_weap_bowie;
#include maps\mp\zombies\_zm_weap_cymbal_monkey;
#include maps\mp\zombies\_zm_weap_claymore;
#include maps\mp\zombies\_zm_weap_ballistic_knife;
#include maps\mp\zombies\_zm_weap_slowgun;
#include maps\mp\zombies\_zm_weap_tazer_knuckles;
#include maps\mp\zombies\_zm_weap_time_bomb;
#include maps\mp\zm_buried_achievement;
#include maps\mp\zm_buried_maze;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\zm_buried_classic;
#include maps\mp\zombies\_zm_pers_upgrades_functions;
#include maps\mp\zombies\_zm_devgui;
#include maps\mp\zombies\_zm_buildables;
#include character\c_transit_player_farmgirl;
#include character\c_transit_player_oldman;
#include character\c_transit_player_engineer;
#include character\c_buried_player_reporter_dam;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zombies\_zm_ai_faller;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_equip_headchopper;
#include maps\mp\zm_buried;

main ()
{
    replaceFunc(maps\mp\zm_buried::include_weapons, ::include_weapons_buried_custom);
}

include_weapons_buried_custom()
{
    gametype = getdvar( "ui_gametype" );
    include_weapon( "knife_zm", 0 );
    include_weapon( "frag_grenade_zm", 0 );
    include_weapon( "claymore_zm", 0 );
    include_weapon( "m1911_zm", 0 );
    include_weapon( "m1911_upgraded_zm", 1 );
    include_weapon( "rnma_zm" );
    include_weapon( "rnma_upgraded_zm", 0 );
    include_weapon( "judge_zm" );
    include_weapon( "judge_upgraded_zm", 0 );
    include_weapon( "kard_zm" );
    include_weapon( "kard_upgraded_zm", 0 );
    include_weapon( "fiveseven_zm" );
    include_weapon( "fiveseven_upgraded_zm", 0 );
    include_weapon( "beretta93r_zm", 0 );
    include_weapon( "beretta93r_upgraded_zm", 0 );
    include_weapon( "fivesevendw_zm" );
    include_weapon( "fivesevendw_upgraded_zm", 0 );
    include_weapon( "ak74u_zm", 0 );
    include_weapon( "ak74u_upgraded_zm", 0 );
    include_weapon( "mp5k_zm", 0 );
    include_weapon( "mp5k_upgraded_zm", 0 );

    if ( gametype == "zcleansed" )
        include_weapon( "qcw05_zm" );

    include_weapon( "870mcs_zm", 0 );
    include_weapon( "870mcs_upgraded_zm", 0 );
    include_weapon( "rottweil72_zm", 0 );
    include_weapon( "rottweil72_upgraded_zm", 0 );
    include_weapon( "saiga12_zm" );
    include_weapon( "saiga12_upgraded_zm", 0 );
    include_weapon( "srm1216_zm" );
    include_weapon( "srm1216_upgraded_zm", 0 );
    include_weapon( "m14_zm", 0 );
    include_weapon( "m14_upgraded_zm", 0 );
    include_weapon( "saritch_zm" );
    include_weapon( "saritch_upgraded_zm", 0 );
    include_weapon( "m16_zm", 0 );
    include_weapon( "m16_gl_upgraded_zm", 0 );
    include_weapon( "tar21_zm" );
    include_weapon( "tar21_upgraded_zm", 0 );
    include_weapon( "galil_zm" );
    include_weapon( "galil_upgraded_zm", 0 );
    include_weapon( "fnfal_zm" );
    include_weapon( "fnfal_upgraded_zm", 0 );
    include_weapon( "dsr50_zm" );
    include_weapon( "dsr50_upgraded_zm", 0 );
    include_weapon( "barretm82_zm" );
    include_weapon( "barretm82_upgraded_zm", 0 );
    include_weapon( "svu_zm", 0 );
    include_weapon( "svu_upgraded_zm", 0 );
    include_weapon( "lsat_zm", 1 );
    include_weapon( "lsat_upgraded_zm", 0 );
    include_weapon( "hamr_zm" );
    include_weapon( "hamr_upgraded_zm", 0 );
    include_weapon( "pdw57_zm", 0 );
    include_weapon( "pdw57_upgraded_zm", 0 );
    include_weapon( "usrpg_zm" );
    include_weapon( "usrpg_upgraded_zm", 0 );
    include_weapon( "m32_zm" );
    include_weapon( "m32_upgraded_zm", 0 );
    include_weapon( "an94_zm", 0 );
    include_weapon( "an94_upgraded_zm", 0 );
    include_weapon( "cymbal_monkey_zm" );
    include_weapon( "ray_gun_zm" );
    include_weapon( "ray_gun_upgraded_zm", 0 );
    include_weapon( "raygun_mark2_zm", 1 );
    include_weapon( "raygun_mark2_upgraded_zm", 0 );
    include_weapon( "slowgun_zm", 1 );
    include_weapon( "slowgun_upgraded_zm", 0 );
    include_weapon( "tazer_knuckles_zm", 0 );
    include_weapon( "knife_ballistic_no_melee_zm", 0 );
    include_weapon( "knife_ballistic_no_melee_upgraded_zm", 0 );
    include_weapon( "knife_ballistic_zm" );
    include_weapon( "knife_ballistic_upgraded_zm", 0 );
    include_weapon( "knife_ballistic_bowie_zm", 0 );
    include_weapon( "knife_ballistic_bowie_upgraded_zm", 0 );
    level._uses_retrievable_ballisitic_knives = 1;
    add_weapon_to_content( "raygun_mark2_zm", "dlc3" );
    add_weapon_locker_mapping( "python_zm", "rnma_zm" );
    add_weapon_locker_mapping( "qcw05_zm", "pdw57_zm" );
    add_weapon_locker_mapping( "xm8_zm", "tar21_zm" );
    add_weapon_locker_mapping( "type95_zm", "tar21_zm" );
    add_weapon_locker_mapping( "rpd_zm", "galil_zm" );
    add_weapon_locker_mapping( "python_upgraded_zm", "rnma_upgraded_zm" );
    add_weapon_locker_mapping( "qcw05_upgraded_zm", "pdw57_upgraded_zm" );
    add_weapon_locker_mapping( "xm8_upgraded_zm", "tar21_upgraded_zm" );
    add_weapon_locker_mapping( "type95_upgraded_zm", "tar21_upgraded_zm" );
    add_weapon_locker_mapping( "rpd_upgraded_zm", "galil_upgraded_zm" );
}