#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_sidequests;
#include maps\mp\_visionset_mgr;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_buildables;
#include maps\mp\zombies\_zm;
#include maps\mp\zm_buried_sq;
#include maps\mp\zombies\_zm_weap_time_bomb;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zm_buried_buildables;


main()
{
    replaceFunc(maps\mp\zombies\_zm_sidequests::is_sidequest_allowed, ::is_sidequest_allowed_custom);
    replaceFunc(maps\mp\zm_buried_sq_tpo::_are_all_players_in_time_bomb_volume, ::_are_all_players_in_time_bomb_volume_custom);    
}

_are_all_players_in_time_bomb_volume_custom( e_volume )
{
    return 4;
}

is_sidequest_allowed_custom( a_gametypes )
{

    if ( isdefined( level.gamedifficulty ) && level.gamedifficulty == 0 )
        return 0;


    return 1;
    b_is_gametype_active = 0;

    if ( !isarray( a_gametypes ) )
        a_gametypes = array( a_gametypes );

    for ( i = 0; i < a_gametypes.size; i++ )
    {
        if ( getdvar( "g_gametype" ) == a_gametypes[i] )
            b_is_gametype_active = 1;
    }

    return b_is_gametype_active;
}