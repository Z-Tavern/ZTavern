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

main()
{
	replaceFunc( maps\mp\zombies\_zm_score::player_add_points, ::disablerevivemoney);
}

disablerevivemoney(event, mod, hit_location, is_dog, zombie_team, damage_weapon)
{
    if ( level.intermission )
        return;

    if ( !is_player_valid( self ) )
        return;

    player_points = 0;
    team_points = 0;
    multiplier = get_points_multiplier( self );

    switch ( event )
    {
        case "death":
            player_points = get_zombie_death_player_points();
            team_points = get_zombie_death_team_points();
            points = self player_add_points_kill_bonus( mod, hit_location );

            if ( level.zombie_vars[self.team]["zombie_powerup_insta_kill_on"] == 1 && mod == "MOD_UNKNOWN" )
                points *= 2;

            player_points += points;

            if ( team_points > 0 )
                team_points += points;

            if ( mod == "MOD_GRENADE" || mod == "MOD_GRENADE_SPLASH" )
            {
                self maps\mp\zombies\_zm_stats::increment_client_stat( "grenade_kills" );
                self maps\mp\zombies\_zm_stats::increment_player_stat( "grenade_kills" );
            }

            break;
        case "ballistic_knife_death":
            player_points = get_zombie_death_player_points() + level.zombie_vars["zombie_score_bonus_melee"];
            self score_cf_increment_info( "death_melee" );
            break;
        case "damage_light":
            player_points = level.zombie_vars["zombie_score_damage_light"];
            self score_cf_increment_info( "damage" );
            break;
        case "damage":
            player_points = level.zombie_vars["zombie_score_damage_normal"];
            self score_cf_increment_info( "damage" );
            break;
        case "damage_ads":
            player_points = int( level.zombie_vars["zombie_score_damage_normal"] * 1.25 );
            self score_cf_increment_info( "damage" );
            break;
        case "rebuild_board":
        case "carpenter_powerup":
            player_points = mod;
            break;
        case "bonus_points_powerup":
            player_points = mod;
            break;
        case "nuke_powerup":
            player_points = mod;
            team_points = mod;
            break;
        case "thundergun_fling":
        case "riotshield_fling":
        case "jetgun_fling":
            player_points = mod;
            break;
        case "hacker_transfer":
            player_points = mod;
            break;
        case "reviver":
            player_points = 0;
            break;
        case "vulture":
            player_points = mod;
            break;
        case "build_wallbuy":
            player_points = mod;
            break;
        default:
            assert( 0, "Unknown point event" );
            break;
    }

    player_points = multiplier * round_up_score( player_points, 5 );
    team_points = multiplier * round_up_score( team_points, 5 );

    if ( ( event == "death" || event == "ballistic_knife_death" ) && isdefined( self.point_split_receiver ))
    {
        split_player_points = player_points - round_up_score( player_points * self.point_split_keep_percent, 10 );
        self.point_split_receiver add_to_player_score( split_player_points );
        player_points -= split_player_points;
    }

    if ( is_true( level.pers_upgrade_pistol_points ) )
        player_points = self maps\mp\zombies\_zm_pers_upgrades_functions::pers_upgrade_pistol_points_set_score( player_points, event, mod, damage_weapon );

    self add_to_player_score( player_points );
    self.pers["score"] = self.score;

    if ( isdefined( level._game_module_point_adjustment ) )
        level [[ level._game_module_point_adjustment ]]( self, zombie_team, player_points );
}

get_points_multiplier( player )
{
    multiplier = level.zombie_vars[player.team]["zombie_point_scalar"];

    if ( isdefined( level.current_game_module ) && level.current_game_module == 2 )
    {
        if ( isdefined( level._race_team_double_points ) && level._race_team_double_points == player._race_team )
            return multiplier;
        else
            return 1;
    }

    return multiplier;
}