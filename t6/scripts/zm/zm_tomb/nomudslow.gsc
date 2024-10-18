#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_net;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\zombies\_zm_craftables;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\zm_tomb_teleporter;
#include maps\mp\zm_tomb_vo;
#include maps\mp\zombies\_zm_ai_basic;
#include maps\mp\animscripts\zm_shared;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\zm_tomb_chamber;
#include maps\mp\zombies\_zm_challenges;
#include maps\mp\zm_tomb_challenges;
#include maps\mp\zm_tomb_tank;
#include maps\mp\zm_tomb_craftables;

#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zm_tomb_utility;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\gametypes_zm\_globallogic_score;



main()
{
	replaceFunc(maps\mp\zm_tomb_utility::player_slow_movement_speed_monitor, ::noMudSlow);
}

noMudSlow()
{
    self endon( "disconnect" );
    n_movescale_delta_no_perk = 0.4 / 4.0;
    n_movescale_delta_staminup = 0.3 / 6.0;
    n_new_move_scale = 1.0;
    n_move_scale_delta = 1.0;
    self.n_move_scale = n_new_move_scale;

    while ( true )
    {
        is_player_slowed = 0;
        self.is_player_slowed = 0;

        foreach ( area in level.a_e_slow_areas )
        {
            if ( self istouching( area ) )
            {
                self setclientfieldtoplayer( "sndMudSlow", 1 );
                is_player_slowed = 1;
                self.is_player_slowed = 1;

                if ( !( isdefined( self.played_mud_vo ) && self.played_mud_vo ) && !( isdefined( self.dontspeak ) && self.dontspeak ) )
                    self thread maps\mp\zm_tomb_vo::struggle_mud_vo();

                if ( self hasperk( "specialty_longersprint" ) )
                {
                    n_new_move_scale = 0.7;
                    n_move_scale_delta = n_movescale_delta_staminup;
                }
                else
                {
                    n_new_move_scale = 0.6;
                    n_move_scale_delta = n_movescale_delta_no_perk;
                }

                break;
            }
        }

        if ( !is_player_slowed )
        {
            self setclientfieldtoplayer( "sndMudSlow", 0 );
            self notify( "mud_slowdown_cleared" );
            n_new_move_scale = 1.0;
        }

        if ( self.n_move_scale != n_new_move_scale )
        {
            if ( self.n_move_scale > n_new_move_scale + n_move_scale_delta )
                self.n_move_scale -= n_move_scale_delta;
            else
                self.n_move_scale = n_new_move_scale;

           // self setmovespeedscale( self.n_move_scale );
        }
        wait 0.1;
    }
}