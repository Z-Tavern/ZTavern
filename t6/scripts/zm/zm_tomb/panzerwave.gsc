#include maps\mp\zombies\_zm_magicbox;
#include maps\mp\zombies\_zm_zonemgr;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\animscripts\zm_utility;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\animscripts\zm_shared;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_ai_basic;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\animscripts\shared;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zombies\_zm_weap_riostshield_prison;
#include maps\mp\animscripts\zm_death;
#include maps\mp\zombies\_zm_perks;
#include maps\mp\zombies\_zm_craftables;
#include maps\mp\gametypes_zm\_zm_gametype;

#include maps\mp\_ambientpackage;
#include maps\mp\zombies\_zm_sidequests;

#include maps\_utility;
#include maps\_vehicle;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_hud;

#include maps\mp\zombies\_zm_pers_upgrades_system;
#include maps\mp\zombies\_zm_pers_upgrades;
#include maps\mp\zombies\_zm_pers_upgrades_functions;
#include scripts\AATs_Perks;
#include maps\mp\_visionset_mgr;
#include character\c_zom_cellbreaker;

#include maps\mp\zombies\_zm_net;
#include maps\mp\zm_tomb_tank;
#include maps\mp\zombies\_zm_ai_mechz_dev;
#include maps\mp\zombies\_zm_ai_mechz_claw;
#include maps\mp\zombies\_zm_ai_mechz_ft;
#include maps\mp\zombies\_zm_ai_mechz_booster;
#include maps\mp\zombies\_zm_ai_mechz_ffotd;
#include maps\mp\zombies\_zm_ai_mechz;
#include maps\mp\zm_tomb_chamber;
#include maps\mp\zm_tomb;
#include maps\mp\zm_tomb_capture_zones;

#include maps\mp\zombies\_zm;
#include maps\mp\_demo;
#include maps\mp\zombies\_zm_power;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_weap_staff_lightning;
#include maps\mp\gametypes_zm\_hostmigration;
#include maps\mp\zm_tomb_distance_tracking;
#include maps\mp\zm_tomb_quest_air;
#include maps\mp\zm_tomb_quest_fire;
#include maps\mp\zm_tomb_quest_ice;
#include maps\mp\zm_tomb_quest_elec;

#include maps\mp\zm_tomb_utility;
#include maps\mp\zm_tomb_teleporter;

#include maps\mp\animscripts\traverse\shared;
#include maps\mp\animscripts\traverse\zm_shared;
#include maps\mp\zm_tomb_amb;
#include maps\mp\gametypes_zm\_globallogic_score;
// raycast for boss wipe aoe attack (zm_ai_mech_ft l464)
// b_cansee = bullettracepassed( self.origin + vectorscale( ( 0, 0, 1 ), 36.0 ), self.favoriteenemy.origin + vectorscale( ( 0, 0, 1 ), 36.0 ), 0, undefined );

main()
{
    replaceFunc(maps\mp\zm_tomb_capture_zones::pack_a_punch_init, ::pack_a_punch_init_custom);
    replaceFunc(maps\mp\zombies\_zm_ffotd::main_start, ::modified_main_start);
    replaceFunc(maps\mp\zombies\_zm_pers_upgrades::is_pers_system_active, ::always_pers_system_active);   
    replaceFunc(maps\mp\zombies\_zm_pers_upgrades::is_pers_system_disabled, ::never_pers_system_disabled);
    replaceFunc(maps\mp\zombies\_zm_ai_mechz::mechz_spawn, ::mechz_spawn_custom);

    //Freeing vars
    replaceFunc(maps\mp\zombies\_zm_stats::initializematchstats, ::initializematchstats_custom);
    replaceFunc(maps\mp\gametypes_zm\_hostmigration::waitlongdurationwithhostmigrationpause, ::waitlongdurationwithhostmigrationpause_custom);
    replaceFunc(maps\mp\zombies\_zm_ai_mechz::mechz_setup_armor_pieces, ::mechz_setup_armor_pieces_custom);

    //replaceFunc(maps\mp\zombies\_zm_ai_mechz::get_favorite_enemy, ::get_favorite_enemy_custom);
    replaceFunc(maps\mp\zm_tomb_quest_ice::process_gem_shooting, ::process_gem_shooting_custom);
    replaceFunc(maps\mp\zm_tomb_quest_ice::ceiling_tile_process_damage, ::ceiling_tile_process_damage_custom);
    replaceFunc(maps\mp\zm_tomb_quest_ice::change_ice_gem_value, ::change_ice_gem_value_custom);
    replaceFunc(maps\mp\zm_tomb_quest_elec::piano_keys_stop,  ::piano_keys_stop_custom);
    replaceFunc(maps\mp\zm_tomb_quest_elec::electric_puzzle_watch_staff,  ::electric_puzzle_watch_staff_custom);
    replaceFunc(maps\mp\zombies\_zm_utility::get_closest_valid_player, ::get_closest_valid_player_custom);
    replaceFunc(maps\mp\zm_tomb_amb::sndmaelstrom, ::sndmaelstrom_custom);
 //   replaceFunc(maps\mp\zombies\_zm_zonemgr::make_zone_adjacent, ::make_zone_adjacent_custom);
//    replacefunc(maps\mp\zombies\_zm_powerups::powerup_hud_monitor, ::powerup_hud_monitor_custom);
 //   replacefunc(maps\mp\zombies\_zm_weap_staff_lightning::init, ::init_staff_lightning_custom);
    replaceFunc(maps\mp\zombies\_zm_ai_mechz::mechz_find_flesh, ::mechz_find_flesh_custom);

 //   replaceFunc(maps\mp\zombies\_zm_spawner::zombie_pathing, ::zombie_pathing_custom);
 //   replaceFunc(maps\mp\zombies\_zm_spawner::zombie_follow_enemy, ::zombie_follow_enemy_custom);
  //  replaceFunc(maps\mp\zombies\_zm_ai_basic::find_flesh, ::find_flesh_custom);

    replaceFunc(maps\mp\zombies\_zm_ai_mechz_ft::player_flame_damage, ::player_flame_damage_custom);
    replaceFunc(maps\mp\zombies\_zm_ai_mechz::mechz_damage_override, ::mechz_damage_override_custom);
}

init()
{ 
    setDvar("lock", "0");
    setDvar("EE_Completion", "0");
    setDvar("isPanzer", "");
    setDvar("game_end", "0");
    setDvar("panzer_trap", "0");
    setDvar("wave", "0");
    setDvar("color", "");
    setDvar("boss_hp", "150000");
    setDvar("king_lock", "0");
    level.blessing_count = 7;
    level.net_port_pia = [];
    level.net_port_pia[level.net_port_pia.size] = "30010";
    level.is_miniboss = 0;
    level.is_midboss = 0;
    level.votes = 0;  

    level.zombie_ai_limit = 32;
    level.zombie_actor_limit = 40;


    level.extra_hp = 0;
    level.extra_panzer = 0;
    level.extra_speed = 0;
    level.is_boss_casting = 0;
    level.primaryprogressbarwidth = 400;
    level.primaryprogressbarheight = 15;
    level.primaryprogressbarfontsize = 1;

    level.player_out_of_playable_area_monitor = false; // wtf bruh
    level.panzer_helmet_on = 0;
    level.is_trap_down = 0;
    level.simon_is_showing = 0;
    level.staff_player_id = -1;
    level.fireRadiusOrigin = (9463, -8560, -398);
    level.iceRadiusOrigin = (11211, -7058.7, -345.875);
    level.windRadiusOrigin = (11253, -8655, -408);
    level.lightningRadiusOrigin = (9623.4, -7016.2, -345.875);
    level.papRadiusOrigin = (10760.4, -7980.47, -463.875);
    level.centerRadiusOrigin = (10314.5, -7889.91, -411.875);
    level.firePuzzleRadiusOrigin =(9891.5, -8764, -452);
    level.panzer_hp = 500;
    level.isStamOn = false;
    level.isJuggOn = false;
    level.isQuickOn = false;
    level.isReloadOn = false;
    level.wave_modifier = 1.5;
    level.firewall_duration = 15;
    level.mechz_reset_dist_sq = 16385;
    level.mechz_aggro_dist_sq = 16384;

    level.panzer_faster_pull = 0;
    level.flamethrower_damage = 30;
    level.panzer_hook_speed = 1200;
    level.panzer_hook_max_range = 800000;
    level.panzer_hook_min_range = 90000;
    level.panzer_hook_bad_retract_time = 1000;
    level.panzer_hook_good_retract_time = 200;    
    level.panzer_hp_increase = 85;

    level.fireKillCount = 0;
    level.iceKillCount = 0;
    level.windKillCount = 0;
    level.lightningKillCount = 0;
    level.panzerKillCount = 0;
    level.area_completed = 0;   

    level.final_wave = 0;

    level.boss_name = "^1Panzer Primis^3";
    level.game_started = 0;
    level.difficulty_selected = 0;
    level.ez_difficulty_vote_count = 0;
    level.chad_difficulty_vote_count = 0;
    level.gigachad_difficulty_vote_count = 0;
    level.gamemode_difficulty = "^2Ez^7";
    level.vote_required = 8;

    level.round_number = 0;
    level thread onPlayerConnect();
    level thread story();
    level thread spawnPanzer();
    level thread zmWatcher();
    level thread perk_machine_spawn_init_customized();
    level thread papGenWatcher();
    level.zombie_vars["riotshield_hit_points"] = level.zombie_vars["riotshield_hit_points"] * 20;
    level thread enable_panzer_spawner();
    level thread change_puzzles_solutions();
    level thread puzzle_watcher();
    level thread init_staff_player();
    level thread difficulty_watcher();
    level thread player_spawn_watcher();
    level thread headshot_watcher();
    level thread team_buff();
}

mechz_damage_override_custom( inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, shitloc, poffsettime, boneindex )
{
    if (isdefined(attacker.slayer_multiplier))
    {
        damage *= (1 + float(attacker.kills / 100));
    }
    num_tiers = level.mechz_armor_info.size + 1;
    old_health_tier = int( num_tiers * self.health / self.maxhealth );
    bonename = getpartname( "c_zom_mech_body", boneindex );

    if ( isdefined( attacker ) && isalive( attacker ) && isplayer( attacker ) && ( level.zombie_vars[attacker.team]["zombie_insta_kill"] || isdefined( attacker.personal_instakill ) && attacker.personal_instakill ) )
    {
        n_mechz_damage_percent = 1.0;
        n_mechz_headshot_modifier = 2.0;
    }
    else
    {
        n_mechz_damage_percent = level.mechz_damage_percent;
        n_mechz_headshot_modifier = 1.0;
    }

    if ( isdefined( weapon ) && is_weapon_shotgun( weapon ) )
    {
        n_mechz_damage_percent *= level.mechz_shotgun_damage_mod;
        n_mechz_headshot_modifier *= level.mechz_shotgun_damage_mod;
    }

    if ( damage <= 10 )
        n_mechz_damage_percent = 1.0;

    if ( is_explosive_damage( meansofdeath ) || issubstr( weapon, "staff" ) )
    {
        if ( n_mechz_damage_percent < 0.5 )
            n_mechz_damage_percent = 0.5;

        if ( !( isdefined( self.has_helmet ) && self.has_helmet ) && issubstr( weapon, "staff" ) && n_mechz_damage_percent < 1.0 )
            n_mechz_damage_percent = 1.0;

        final_damage = damage * n_mechz_damage_percent;

        if ( !isdefined( self.explosive_dmg_taken ) )
            self.explosive_dmg_taken = 0;

        self.explosive_dmg_taken += final_damage;
        self.helmet_dmg += final_damage;

        if ( isdefined( self.explosive_dmg_taken_on_grab_start ) )
        {
            if ( isdefined( self.e_grabbed ) && self.explosive_dmg_taken - self.explosive_dmg_taken_on_grab_start > level.mechz_explosive_dmg_to_cancel_claw )
            {
                if ( isdefined( self.has_helmet ) && self.has_helmet && self.helmet_dmg < self.helmet_dmg_for_removal || !( isdefined( self.has_helmet ) && self.has_helmet ) )
                    self thread mechz_claw_shot_pain_reaction();

                self thread ent_released_from_claw_grab_achievement( attacker, self.e_grabbed );
                self thread mechz_claw_release();
            }
        }
    }
    else if ( shitloc != "head" && shitloc != "helmet" )
    {
        if ( bonename == "tag_powersupply" )
        {
            final_damage = damage * n_mechz_damage_percent;

            if ( !( isdefined( self.powerplant_covered ) && self.powerplant_covered ) )
                self.powerplant_dmg += final_damage;
            else
                self.powerplant_cover_dmg += final_damage;
        }

        if ( isdefined( self.e_grabbed ) && ( shitloc == "left_hand" || shitloc == "left_arm_lower" || shitloc == "left_arm_upper" ) )
        {
            if ( isdefined( self.e_grabbed ) )
                self thread mechz_claw_shot_pain_reaction();

            self thread ent_released_from_claw_grab_achievement( attacker, self.e_grabbed );
            self thread mechz_claw_release( 1 );
        }

        final_damage = damage * n_mechz_damage_percent;
    }
    else if ( !( isdefined( self.has_helmet ) && self.has_helmet ) )
        final_damage = damage * n_mechz_headshot_modifier;
    else
    {
        final_damage = damage * n_mechz_damage_percent;
        self.helmet_dmg += final_damage;
    }

    if ( !isdefined( weapon ) || weapon == "none" )
    {
        if ( !isplayer( attacker ) )
            final_damage = 0;
    }

    new_health_tier = int( num_tiers * ( self.health - final_damage ) / self.maxhealth );

    if ( old_health_tier > new_health_tier )
    {
        while ( old_health_tier > new_health_tier )
        {
/#
            if ( getdvarint( _hash_E7121222 ) > 0 )
                println( "\\nMZ: Old tier: " + old_health_tier + "   New Health Tier: " + new_health_tier + "   Launching armor piece" );
#/
            if ( old_health_tier < num_tiers )
                self mechz_launch_armor_piece();

            old_health_tier--;
        }
    }

    if ( isdefined( self.has_helmet ) && self.has_helmet && self.helmet_dmg >= self.helmet_dmg_for_removal )
    {
        self.has_helmet = 0;
        self detach( "c_zom_mech_faceplate", "J_Helmet" );

        if ( sndmechzisnetworksafe( "destruction" ) )
            self playsound( "zmb_ai_mechz_destruction" );

        if ( sndmechzisnetworksafe( "angry" ) )
            self playsound( "zmb_ai_mechz_vox_angry" );

        self.fx_field |= 1024;
        self.fx_field &= ~2048;
        self setclientfield( "mechz_fx", self.fx_field );

        if ( !( isdefined( self.not_interruptable ) && self.not_interruptable ) && !( isdefined( self.is_traversing ) && self.is_traversing ) )
        {
            self mechz_interrupt();
            self animscripted( self.origin, self.angles, "zm_pain_faceplate" );
            self maps\mp\animscripts\zm_shared::donotetracks( "pain_anim_faceplate" );
        }

        self thread shoot_mechz_head_vo();
    }

    if ( isdefined( self.powerplant_covered ) && self.powerplant_covered && self.powerplant_cover_dmg >= self.powerplant_cover_dmg_for_removal )
    {
        self.powerplant_covered = 0;
        self detach( "c_zom_mech_powersupply_cap", "tag_powersupply" );
        cap_model = spawn( "script_model", self gettagorigin( "tag_powersupply" ) );
        cap_model.angles = self gettagangles( "tag_powersupply" );
        cap_model setmodel( "c_zom_mech_powersupply_cap" );
        cap_model physicslaunch( cap_model.origin, anglestoforward( cap_model.angles ) );
        cap_model thread mechz_delayed_item_delete();

        if ( sndmechzisnetworksafe( "destruction" ) )
            self playsound( "zmb_ai_mechz_destruction" );

        if ( !( isdefined( self.not_interruptable ) && self.not_interruptable ) && !( isdefined( self.is_traversing ) && self.is_traversing ) )
        {
            self mechz_interrupt();
            self animscripted( self.origin, self.angles, "zm_pain_powercore" );
            self maps\mp\animscripts\zm_shared::donotetracks( "pain_anim_powercore" );
        }
    }
    else if ( !( isdefined( self.powerplant_covered ) && self.powerplant_covered ) && ( isdefined( self.has_powerplant ) && self.has_powerplant ) && self.powerplant_dmg >= self.powerplant_dmg_for_destroy )
    {
        self.has_powerplant = 0;
        self thread mechz_stun( level.mechz_powerplant_stun_time );

        if ( sndmechzisnetworksafe( "destruction" ) )
            self playsound( "zmb_ai_mechz_destruction" );
    }
/#
    if ( getdvarint( _hash_E7121222 ) > 0 )
    {
        println( "\\nMZ: Doing " + final_damage + " damage to mechz,   Health Remaining: " + self.health );

        if ( self.helmet_dmg < self.helmet_dmg_for_removal )
            println( "\\nMZ: Current helmet dmg: " + self.helmet_dmg + "    Required helmet dmg: " + self.helmet_dmg_for_removal );
    }
#/
    return final_damage;
}

player_flame_damage_custom()
{
    self endon( "zombified" );
    self endon( "death" );
    self endon( "disconnect" );
    n_player_dmg = 30;
    n_jugga_dmg = 45;
    n_burn_time = 1.5;

    if ( isdefined( self.is_zombie ) && self.is_zombie )
        return;

    self thread player_stop_burning();

    if ( !isdefined( self.is_burning ) && is_player_valid( self, 1, 0 ) )
    {
        self.is_burning = 1;
        maps\mp\_visionset_mgr::vsmgr_activate( "overlay", "zm_transit_burn", self, n_burn_time, level.zm_transit_burn_max_duration );
        self notify( "burned" );

        if (getdvar("net_port") == "30010" && self.ignoreme != true)
        {
                self dodamage( level.flamethrower_damage, self.origin );
        }
        else
        {
            if ( !self hasperk( "specialty_armorvest" ) && self.ignoreme != true)
                self dodamage( n_player_dmg, self.origin );
            else if (self.ignoreme != true)
                self dodamage( n_jugga_dmg, self.origin );
        }


        wait 0.5;
        self.is_burning = undefined;
    }
}


donotetracksfortimeproc_custom( donotetracksforeverfunc, time, flagname, customfunction, ent, var1 )
{
    ent endon( "stop_notetracks" );
    [[ donotetracksforeverfunc ]]( flagname, undefined, customfunction, var1 );
}

powerup_hud_monitor_custom()
{
    if (getdvar("net_port") == "30010")
    return;
    flag_wait( "start_zombie_round_logic" );


    if ( isdefined( level.current_game_module ) && level.current_game_module == 2 )
        return;

    flashing_timers = [];
    flashing_values = [];
    flashing_timer = 10;
    flashing_delta_time = 0;
    flashing_is_on = 0;
    flashing_value = 3;
    flashing_min_timer = 0.15;

    while ( flashing_timer >= flashing_min_timer )
    {
        if ( flashing_timer < 5 )
            flashing_delta_time = 0.1;
        else
            flashing_delta_time = 0.2;

        if ( flashing_is_on )
        {
            flashing_timer = flashing_timer - flashing_delta_time - 0.05;
            flashing_value = 2;
        }
        else
        {
            flashing_timer -= flashing_delta_time;
            flashing_value = 3;
        }

        flashing_timers[flashing_timers.size] = flashing_timer;
        flashing_values[flashing_values.size] = flashing_value;
        flashing_is_on = !flashing_is_on;
    }

    client_fields = [];
    powerup_keys = getarraykeys( level.zombie_powerups );

    for ( powerup_key_index = 0; powerup_key_index < powerup_keys.size; powerup_key_index++ )
    {
        if ( isdefined( level.zombie_powerups[powerup_keys[powerup_key_index]].client_field_name ) )
        {
            powerup_name = powerup_keys[powerup_key_index];
            client_fields[powerup_name] = spawnstruct();
            client_fields[powerup_name].client_field_name = level.zombie_powerups[powerup_name].client_field_name;
            client_fields[powerup_name].solo = level.zombie_powerups[powerup_name].solo;
            client_fields[powerup_name].time_name = level.zombie_powerups[powerup_name].time_name;
            client_fields[powerup_name].on_name = level.zombie_powerups[powerup_name].on_name;
        }
    }

    client_field_keys = getarraykeys( client_fields );

    while ( true )
    {
        wait 0.05;
        waittillframeend;
        players = get_players();

        for ( playerindex = 0; playerindex < players.size; playerindex++ )
        {
            for ( client_field_key_index = 0; client_field_key_index < client_field_keys.size; client_field_key_index++ )
            {
                player = players[playerindex];
/#
                if ( isdefined( player.pers["isBot"] ) && player.pers["isBot"] )
                    continue;
#/
                if ( isdefined( level.powerup_player_valid ) )
                {
                    if ( ![[ level.powerup_player_valid ]]( player ) )
                        continue;
                }

                client_field_name = client_fields[client_field_keys[client_field_key_index]].client_field_name;
                time_name = client_fields[client_field_keys[client_field_key_index]].time_name;
                on_name = client_fields[client_field_keys[client_field_key_index]].on_name;
                powerup_timer = undefined;
                powerup_on = undefined;

                if ( client_fields[client_field_keys[client_field_key_index]].solo )
                {
                    if ( isdefined( player._show_solo_hud ) && player._show_solo_hud == 1 )
                    {
                        powerup_timer = player.zombie_vars[time_name];
                        powerup_on = player.zombie_vars[on_name];
                    }
                }
                else if ( isdefined( level.zombie_vars[player.team][time_name] ) )
                {
                    powerup_timer = level.zombie_vars[player.team][time_name];
                    powerup_on = level.zombie_vars[player.team][on_name];
                }
                else if ( isdefined( level.zombie_vars[time_name] ) )
                {
                    powerup_timer = level.zombie_vars[time_name];
                    powerup_on = level.zombie_vars[on_name];
                }

                if ( isdefined( powerup_timer ) && isdefined( powerup_on ) )
                {
                    player set_clientfield_powerups( client_field_name, powerup_timer, powerup_on, flashing_timers, flashing_values );
                    continue;
                }

                player setclientfieldtoplayer( client_field_name, 0 );
            }
        }
    }
}

make_zone_adjacent_custom( main_zone_name, adj_zone_name, flag_name )
{
    if (getdvar("net_port") == "30010")
    return;
    main_zone = level.zones[main_zone_name];

    if ( !isdefined( main_zone.adjacent_zones[adj_zone_name] ) )
    {
        main_zone.adjacent_zones[adj_zone_name] = spawnstruct();
        adj_zone = main_zone.adjacent_zones[adj_zone_name];
        adj_zone.is_connected = 0;
        adj_zone.flags_do_or_check = 0;

        if ( isarray( flag_name ) )
            adj_zone.flags = flag_name;
        else
            adj_zone.flags[0] = flag_name;
    }
    else
    {
        assert( !isarray( flag_name ), "make_zone_adjacent: can't mix single and arrays of flags" );
        adj_zone = main_zone.adjacent_zones[adj_zone_name];
        size = adj_zone.flags.size;
        adj_zone.flags_do_or_check = 1;
        adj_zone.flags[size] = flag_name;
    }
}

sndmaelstrom_custom()
{
  //  if (getdvar("net_port") == "30010")
        return;
  /*  trig = getent( "sndMaelstrom", "targetname" );

    if ( !isdefined( trig ) )
        return;

    while ( true )
    {
        trig waittill( "trigger", who );

        if ( isplayer( who ) && !is_true( who.sndmaelstrom ) )
        {
            who.sndmaelstrom = 1;
            level setclientfield( "sndMaelstromPlr" + who getentitynumber(), 1 );
        }

        who thread sndmaelstrom_timeout();
        wait 0.1;
    }*/
}

find_flesh_custom()
{
    self endon( "death" );
    level endon( "intermission" );
    self endon( "stop_find_flesh" );

    if ( level.intermission )
        return;

    self.ai_state = "find_flesh";
    self.helitarget = 1;
    self.ignoreme = 0;
    self.nododgemove = 1;
    self.ignore_player = [];
    self maps\mp\zombies\_zm_spawner::zombie_history( "find flesh -> start" );
    self.goalradius = 32;

    if ( isdefined( self.custom_goalradius_override ) )
        self.goalradius = self.custom_goalradius_override;

    while ( true )
    {
        wait 0.1;
        zombie_poi = undefined;

        if ( isdefined( level.zombietheaterteleporterseeklogicfunc ) )
            self [[ level.zombietheaterteleporterseeklogicfunc ]]();

        if ( isdefined( level._poi_override ) )
            zombie_poi = self [[ level._poi_override ]]();

        if ( !isdefined( zombie_poi ) )
            zombie_poi = self get_zombie_point_of_interest( self.origin );

        players = get_players();

        if ( !isdefined( self.ignore_player ) || players.size == 1 )
            self.ignore_player = [];
        else if ( !isdefined( level._should_skip_ignore_player_logic ) || ![[ level._should_skip_ignore_player_logic ]]() )
        {
            i = 0;

            while ( i < self.ignore_player.size )
            {
                if ( isdefined( self.ignore_player[i] ) && isdefined( self.ignore_player[i].ignore_counter ) && self.ignore_player[i].ignore_counter > 3 )
                {
                    self.ignore_player[i].ignore_counter = 0;
                    self.ignore_player = arrayremovevalue( self.ignore_player, self.ignore_player[i] );

                    if ( !isdefined( self.ignore_player ) )
                        self.ignore_player = [];

                    i = 0;
                    continue;
                }

                i++;
            }
        }

        player = get_closest_valid_player( self.origin, self.ignore_player );

        if ( !isdefined( player ) && !isdefined( zombie_poi ) )
        {
            self maps\mp\zombies\_zm_spawner::zombie_history( "find flesh -> can't find player, continue" );

            if ( isdefined( self.ignore_player ) )
            {
                if ( isdefined( level._should_skip_ignore_player_logic ) && [[ level._should_skip_ignore_player_logic ]]() )
                {
                    wait 1;
                    continue;
                }

                self.ignore_player = [];
            }

            wait 1;
            continue;
        }

        if ( !isdefined( level.check_for_alternate_poi ) || ![[ level.check_for_alternate_poi ]]() )
        {
            self.enemyoverride = zombie_poi;
            self.favoriteenemy = player;
        }

        self thread zombie_pathing();

        if ( players.size > 1 )
        {
            for ( i = 0; i < self.ignore_player.size; i++ )
            {
                if ( isdefined( self.ignore_player[i] ) )
                {
                    if ( !isdefined( self.ignore_player[i].ignore_counter ) )
                    {
                        self.ignore_player[i].ignore_counter = 0;
                        continue;
                    }

                    self.ignore_player[i].ignore_counter += 1;
                }
            }
        }

        self thread attractors_generated_listener();

        if ( isdefined( level._zombie_path_timer_override ) )
            self.zombie_path_timer = [[ level._zombie_path_timer_override ]]();
        else
            self.zombie_path_timer = gettime() + randomfloatrange( 1, 3 ) * 1000;

        while ( gettime() < self.zombie_path_timer )
            wait 0.1;

        self notify( "path_timer_done" );
        self maps\mp\zombies\_zm_spawner::zombie_history( "find flesh -> bottom of loop" );
        debug_print( "Zombie is re-acquiring enemy, ending breadcrumb search" );
        self notify( "zombie_acquire_enemy" );
      //  iprintln("target acquired");
    }
}

zombie_pathing_custom()
{
    self endon( "death" );
    self endon( "zombie_acquire_enemy" );
    level endon( "intermission" );
    assert( isdefined( self.favoriteenemy ) || isdefined( self.enemyoverride ) );
    self._skip_pathing_first_delay = 1;
    self thread zombie_follow_enemy();

    self waittill( "bad_path" );
    
    level.zombie_pathing_failed++;

    if ( isdefined( self.enemyoverride ) )
    {
        debug_print( "Zombie couldn't path to point of interest at origin: " + self.enemyoverride[0] + " Falling back to breadcrumb system" );

        if ( isdefined( self.enemyoverride[1] ) )
        {
            self.enemyoverride = self.enemyoverride[1] invalidate_attractor_pos( self.enemyoverride, self );
            self.zombie_path_timer = 0;
            return;
        }
    }
    else if ( isdefined( self.favoriteenemy ) )
        debug_print( "Zombie couldn't path to player at origin: " + self.favoriteenemy.origin + " Falling back to breadcrumb system" );
    else
        debug_print( "Zombie couldn't path to a player ( the other 'prefered' player might be ignored for encounters mode ). Falling back to breadcrumb system" );

    if ( !isdefined( self.favoriteenemy ) )
    {
        self.zombie_path_timer = 0;
        return;
    }
    else
        self.favoriteenemy endon( "disconnect" );

    players = get_players();
    valid_player_num = 0;

    for ( i = 0; i < players.size; i++ )
    {
        if ( is_player_valid( players[i], 1 ) )
            valid_player_num += 1;
    }

    if ( players.size > 1 )
    {
        if ( isdefined( level._should_skip_ignore_player_logic ) && [[ level._should_skip_ignore_player_logic ]]() )
        {
            self.zombie_path_timer = 0;
            return;
        }

        if ( array_check_for_dupes( self.ignore_player, self.favoriteenemy ) )
            self.ignore_player[self.ignore_player.size] = self.favoriteenemy;

        if ( self.ignore_player.size < valid_player_num )
        {
            self.zombie_path_timer = 0;
            return;
        }
    }

    crumb_list = self.favoriteenemy.zombie_breadcrumbs;
    bad_crumbs = [];

    while ( true )
    {
        wait 0.1;
        if ( !is_player_valid( self.favoriteenemy, 1 ) )
        {
            self.zombie_path_timer = 0;
            return;
        }

        goal = zombie_pathing_get_breadcrumb( self.favoriteenemy.origin, crumb_list, bad_crumbs, randomint( 100 ) < 20 );

        if ( !isdefined( goal ) )
        {
            debug_print( "Zombie exhausted breadcrumb search" );
            level.zombie_breadcrumb_failed++;
            goal = self.favoriteenemy.spectator_respawn.origin;
        }

        debug_print( "Setting current breadcrumb to " + goal );
        self.zombie_path_timer += 100;
        self setgoalpos( goal );

        self waittill( "bad_path" );

        debug_print( "Zombie couldn't path to breadcrumb at " + goal + " Finding next breadcrumb" );

        for ( i = 0; i < crumb_list.size; i++ )
        {
            if ( goal == crumb_list[i] )
            {
                bad_crumbs[bad_crumbs.size] = i;
                break;
            }
        }
    }
}

zombie_follow_enemy_custom()
{
    self endon( "death" );
    self endon( "zombie_acquire_enemy" );
    self endon( "bad_path" );
    level endon( "intermission" );

    if ( !isdefined( level.repathnotifierstarted ) )
    {
        level.repathnotifierstarted = 1;
        level thread zombie_repath_notifier();
    }

    if ( !isdefined( self.zombie_repath_notify ) )
        self.zombie_repath_notify = "zombie_repath_notify_" + self getentitynumber() % 4;

    while ( true )
    {
        wait 0.1;
        if ( !isdefined( self._skip_pathing_first_delay ) )
            level waittill( self.zombie_repath_notify );
        else
            self._skip_pathing_first_delay = undefined;

        if ( !( isdefined( self.ignore_enemyoverride ) && self.ignore_enemyoverride ) && isdefined( self.enemyoverride ) && isdefined( self.enemyoverride[1] ) )
        {
            if ( distancesquared( self.origin, self.enemyoverride[0] ) > 1 )
                self orientmode( "face motion" );
            else
                self orientmode( "face point", self.enemyoverride[1].origin );

            self.ignoreall = 1;
            goalpos = self.enemyoverride[0];

            if ( isdefined( level.adjust_enemyoverride_func ) )
                goalpos = self [[ level.adjust_enemyoverride_func ]]();

            self setgoalpos( goalpos );
        }
        else if ( isdefined( self.favoriteenemy ) )
        {
            self.ignoreall = 0;
            self orientmode( "face default" );
            goalpos = self.favoriteenemy.origin;

            if ( isdefined( level.enemy_location_override_func ) )
                goalpos = [[ level.enemy_location_override_func ]]( self, self.favoriteenemy );

            self setgoalpos( goalpos );

            if ( !isdefined( level.ignore_path_delays ) )
            {
                distsq = distancesquared( self.origin, self.favoriteenemy.origin );

                if ( distsq > 10240000 )
                    wait( 2.0 + randomfloat( 1.0 ) );
                else if ( distsq > 4840000 )
                    wait( 1.0 + randomfloat( 0.5 ) );
                else if ( distsq > 1440000 )
                    wait( 0.5 + randomfloat( 0.5 ) );
            }
        }

        if ( isdefined( level.inaccesible_player_func ) )
            self [[ level.inaccessible_player_func ]]();
    }
}




get_closest_valid_player_custom(origin, players)
{
    closest_dist = 9999999;
    closest_player = undefined;
    foreach(player in level.players)
    {
        if ( player.sessionstate == "intermission" )
            return undefined;
        if ( isdefined( player.intermission ) && player.intermission )
            return undefined;
        if (player.sessionstate == "spectator" || player maps\mp\zombies\_zm_laststand::player_is_in_laststand() )
            continue;
        dist = distancesquared(origin, player.origin);
        if (dist < closest_dist)
        {
            closest_dist = dist;
            closest_player = player;
        }
    }
    return closest_player;
}

headshot_watcher()
{
    flag_wait("initial_blackscreen_passed");
    if (getdvar("net_port") != "30010")
        return;

    for (;;)
    {
        foreach(player in level.players)
        {
            if (player.headshots >= 50 && player.sessionstate != "spectator")
            {
                weapon_loadout = player GetWeaponsListPrimaries();
                if (weapon_loadout.size >= 2)
                    player TakeWeapon(player GetCurrentWeapon());
                player GiveWeapon("evoskorpion_upgraded_zm");
                player SwitchToWeapon("evoskorpion_upgraded_zm");
                player iprintln("The ^1SMG God^7 gave you his ^5blessing");
                return;
            }
        }
        wait 2;
    }
}

get_favorite_enemy_custom(origin, players)
{
    closest_distance = 999999999;
    closest_player = undefined;
    foreach (player in level.players)
    {
        if ( player.sessionstate == "intermission" )
            return undefined;
        if ( isdefined( player.intermission ) && player.intermission )
            return undefined;
        if(player.sessionstate == "spectator" || player maps\mp\zombies\_zm_laststand::player_is_in_laststand())
            continue;
        p_dist = distancesquared(origin, player.origin);
        if (p_dist < closest_distance)
        {
            closest_player = player;
            closest_distance = p_dist;
        }
    }
    return closest_player;
}

get_favorite_enemy_custom2(origin, players)
{
    closest_distance = 999999999;
    closest_player = undefined;
    foreach (player in level.players)
    {
        if ( player.sessionstate == "intermission" )
            return undefined;
        if ( isdefined( player.intermission ) && player.intermission )
            return undefined;
        if(player.sessionstate == "spectator" || player maps\mp\zombies\_zm_laststand::player_is_in_laststand())
            continue;
        p_dist = distancesquared(self.origin, player.origin);
        if (p_dist < closest_distance)
        {
            closest_player = player;
            closest_distance = p_dist;
        }
    }
    return closest_player;
}

player_spawn_watcher()
{
    flag_wait("initial_blackscreen_passed");

    if (getdvar("net_port") != "30010")
        return;

    second = 0;
    wait 5;
    for (;;)
    {
        for (i = 0; i < level.players.size; i++)
        {
            if(level.players[i] maps\mp\zombies\_zm_laststand::player_is_in_laststand())
            {
                level.players[i] thread maps\mp\zombies\_zm_laststand::auto_revive(level.players[i]);
            }
        }
        second++;
        if (second >= 10) //15s
            break;
        wait 1.5;
    }
}

team_buff()
{
    if (getdvar("net_port") != "30010")
        return;

    m_id = 0;
    r = randomint(100);
    r2 = randomint(100);
    flag_wait("initial_blackscreen_passed");
    wait 3;
    foreach (player in level.players)
    {
        level.isStamOn = true;
        level.isReloadOn = true;
        level.isQuickOn = true;
        level.isJuggOn = true;

        level.perk_machine SetModel("p6_zm_tm_vending_revive_on");
        level.perk_machine thread perk_fx( "revive_light" );

        if (r > 90)
        {
            m_id = 1;
            level.str1 = "^2Agarthan power^7\n- All players receive a random staff"; 
                if (isAlive(player))
                {
                    weapon_loadout = player GetWeaponsListPrimaries();
                    if (weapon_loadout.size >= 2)
                        player TakeWeapon(player GetCurrentWeapon());
                    random = randomint(4);
                    if (random == 0)
                        staff_elem = "lightning";
                    if (random == 1)
                        staff_elem = "air";
                    if (random == 2)
                        staff_elem = "fire";
                    if (random == 3)
                        staff_elem = "water"; 
                    weapon_loadout = self GetWeaponsListPrimaries();
                    if (weapon_loadout.size >= 2)
                        self TakeWeapon(self GetCurrentWeapon());               
                    player GiveWeapon("staff_" + staff_elem + "_zm");
                    player SwitchToWeapon("staff_" + staff_elem + "lightning_zm");
                }
        }
        else if (r > 80)
        {
            m_id = 2;
            level.str1 = "^2Mechanic^7\n- All generators are turned on";
            level.isStamOn = true;
            level.isReloadOn = true;
            level.isQuickOn = true;
            level.isJuggOn = true;

            level.perk_machine SetModel("p6_zm_tm_vending_revive_on");
            level.perk_machine thread perk_fx( "revive_light" );
            for (i = 0; i < 7; i++)
            {
                turn_gen_on(i);
                wait 0.3;
            }
        }
        else if (r > 70)
        {
            m_id = 3;
            level.str1 = "^2Drone Swarm^7\n- All players receive a pet drone\n- ^3Melee^7 to activate drone skill";
            has_drone = 0;
            foreach(guid in level.drone_pass_list)
            {
                if (player getguid() == guid)
                    has_drone = 1;
            }  
            if (has_drone == 0)
                player thread scripts\zm\zm_tomb\pet_drones::on_player_spawned();
        }
        else if (r > 55)
        {
            m_id = 4;
            level.str1 = "^2Running in the 90s^7\n- Your team is zooming";
            level.extra_speed = 0.4;
            player SetMoveSpeedScale(1.45);
        }
        else if (r > 0)
        {
            m_id = 5;
            level.str1 = "^2Double Tap 3.0^7\n- Grant an empowered Double Tap\n- Lost if downed";
            setdvar("perk_weapRateMultiplier", "0.5");
            setdvar("fire_rate", "0.5");
            if (player HasPerk("specialty_rof") == 0)
                player thread maps\mp\zombies\_zm_perks::wait_give_perk("specialty_rof", 1); 
        }
        else if (r > 20)
        {
            m_id = 6;
            level.str1 = "^2Medic Squad^7\n- Increased revive speed";
            level.faster_revive = 1;
        }
        else if (r > 0)
        {
            m_id = 7;
            level.str1 = "^2Panzer Slayer^7\n- Each kill grant 6 permanent HP";
            level.hp_stack = 1;
        }
        //ENEMY BUFF
        if (r2 > 80)
        {
            level.str2 = "^1Lock out^7\n- The walls drops earlier";
            level.lockout = 1;
        }
        else if (r2 > 60)
        {
            level.str2 = "^1Juggernauts^7\n- Panzers are beefy";
            level.panzer_hp = level.panzer_hp * 1.25;
            level.panzer_hp_increase = level.panzer_hp_increase * 1.25;
        }
        else if (r2 > 40)
        {
            level.str2 = "^1Roadhog time^7\n- Panzer hook cooldown decreased";
            level.mechz_claw_cooldown_time = 3000;
        }
        else if (r2 > 20)
        {
            level.str2 = "^1Endless Horde^7\n- More Panzer spawns";
            level.extra_panzer = 4;
        }
        else if (r2 > 0)
        {
            level.str2 = "^2None^7\n- You lucky nugget !";
        }
    }
    for (;;)
    {
        if (getdvar("guild_modifier") == "1")
        {
            break;
        }
        else if (getdvar("guild_modifier") == "2")
            break;
        wait 0.5;
    }

    if (getdvar("guild_modifier") == "1")
    {
        for (;;)
        {
            r = randomint(100);
            if (r > 90 && m_id != 1)
                break;
            else if (r > 80 && m_id != 2)
                break;
            else if (r > 70 && m_id != 3)
                break;
            else if (r > 55 && m_id != 4)
                break;
            else if (r > 35 && m_id != 5)
                break;
            else if (r > 20 && m_id != 6)
                break;
            else if (r > 0 && m_id != 7)
                break;
            wait 0.05;
        }

        foreach (player in level.players)
        {
            level.str1 += "\n ^6[GUILD]^7 ";
            if (r > 90)
            {
                level.str1 += "^2Agarthan power^7\n- All players receive a random staff"; 
                    if (isAlive(player))
                    {
                        weapon_loadout = player GetWeaponsListPrimaries();
                        if (weapon_loadout.size >= 2)
                            player TakeWeapon(player GetCurrentWeapon());
                        random = randomint(4);
                        if (random == 0)
                            staff_elem = "lightning";
                        if (random == 1)
                            staff_elem = "air";
                        if (random == 2)
                            staff_elem = "fire";
                        if (random == 3)
                            staff_elem = "water"; 
                        weapon_loadout = self GetWeaponsListPrimaries();
                        if (weapon_loadout.size >= 2)
                            self TakeWeapon(self GetCurrentWeapon());               
                        player GiveWeapon("staff_" + staff_elem + "_zm");
                        player SwitchToWeapon("staff_" + staff_elem + "lightning_zm");
                    }
            }
            else if (r > 80)
            {
                level.str1 += "^2Mechanic^7\n- All generators are turned on";
                level.isStamOn = true;
                level.isReloadOn = true;
                level.isQuickOn = true;
                level.isJuggOn = true;

                level.perk_machine SetModel("p6_zm_tm_vending_revive_on");
                level.perk_machine thread perk_fx( "revive_light" );
                for (i = 0; i < 7; i++)
                {
                    turn_gen_on(i);
                    wait 0.3;
                }
            }
            else if (r > 70)
            {
                level.str1 += "^2Drone Swarm^7\n- All players receive a pet drone\n- ^3Melee^7 to activate drone skill";
                has_drone = 0;
                foreach(guid in level.drone_pass_list)
                {
                    if (player getguid() == guid)
                        has_drone = 1;
                }  
                if (has_drone == 0)
                    player thread scripts\zm\zm_tomb\pet_drones::on_player_spawned();
            }
            else if (r > 55)
            {
                level.str1 += "^2Running in the 90s^7\n- Your team is zooming";
                level.extra_speed = 0.4;
                player SetMoveSpeedScale(1.45);
            }
            else if (r > 35)
            {
                level.str1 += "^2Double Tap 3.0^7\n- Grant an empowered Double Tap\n- Lost if downed";
                setdvar("perk_weapRateMultiplier", "0.5");
                setdvar("fire_rate", "0.5");
                level waittill("start_of_round");
                if (player HasPerk("specialty_rof") == 0)
                    player thread maps\mp\zombies\_zm_perks::wait_give_perk("specialty_rof", 1); 
            }
            else if (r > 20)
            {
                level.str1 += "^2Medic Squad^7\n- Increased revive speed";
                level.faster_revive = 1;
            }
            else if (r > 0)
            {
                level.str1 += "^2Panzer Slayer^7\n- Each kill grant 6 permanent HP";
                level.hp_stack = 1;
            }
        }
    }
    level.modif_lock = 1;
}

init_staff_player()
{
    flag_wait("initial_blackscreen_passed");
    level.staff_player_id = randomintrange(0, level.players.size);
}

piano_keys_stop_custom()
{
    if (getdvar("net_port") == "30010")
        return;
    level notify( "piano_keys_stop" );
    level.a_piano_keys_playing = [];
}

electric_puzzle_watch_staff_custom()
{
    self endon( "disconnect" );

    if (getdvar("net_port") == "30010")
    {
        while ( true )
        {
            self waittill( "projectile_impact", str_weap_name, v_explode_point, n_radius, e_projectile, n_impact );

            if (level.simon_is_showing == 0)
            {
                if ( !flag( "electric_puzzle_1_complete" ) && maps\mp\zm_tomb_chamber::is_chamber_occupied() )
                {
                    n_index = get_closest_index( v_explode_point, level.a_piano_keys, 20.0 );

                    if ( isdefined( n_index ) )
                    {
                        if (level.a_piano_keys[n_index] == level.key_to_hit)
                        {
                            level.a_piano_keys[n_index].e_fx.origin = level.a_key_origin[n_index];
                            level notify ("simon_hit");
                        }
                        else
                        {
                            foreach(player in level.players)
                            {
                                if (distancesquared(level.lightningRadiusOrigin, player.origin ) < 65000 && player.ignoreme != true)
                                    player dodamage(player.maxhealth + 666, player.origin);
                            }
                            level thread piano_fail_flash();
                        }

                    }
                }
            }
        }       
    }
    else
    {
        a_piano_keys = getstructarray( "piano_key", "script_noteworthy" );
        while ( true )
        {
            self waittill( "projectile_impact", str_weap_name, v_explode_point, n_radius, e_projectile, n_impact );

            if ( str_weap_name == "staff_lightning_zm" )
            {
                if ( !flag( "electric_puzzle_1_complete" ) && maps\mp\zm_tomb_chamber::is_chamber_occupied() )
                {
                    n_index = get_closest_index( v_explode_point, a_piano_keys, 20.0 );

                    if ( isdefined( n_index ) )
                    {
                        a_piano_keys[n_index] notify( "piano_key_shot" );
                        a_players = getplayers();

                        foreach ( e_player in a_players )
                        {
                            if ( e_player hasweapon( "staff_lightning_zm" ) )
                                level notify( "vo_try_puzzle_lightning1", e_player );
                        }
                    }
                }
            }
        }
    }

}

change_ice_gem_value_custom()
{
    ice_gem = getent( "ice_chamber_gem", "targetname" );

    if (getdvar("net_port") == "30010")
    {
        if ( level.unsolved_tiles.size != 0 )
        {
            for (;;)
            {
                correct_tile = random( level.unsolved_tiles );
                if (correct_tile == level.ice_puzzle_order[level.index])
                {
                    ice_gem.value = correct_tile.value;
                    level.index++;
                    break;
                }
                wait 0.1;
            }
            level notify( "update_ice_chamber_digits", -1 );
        }
        else
            level notify( "update_ice_chamber_digits", -1 );       
    }
    else
    {
        if ( level.unsolved_tiles.size != 0 )
        {
            correct_tile = random( level.unsolved_tiles );
            ice_gem.value = correct_tile.value;
            level notify( "update_ice_chamber_digits", ice_gem.value );
        }
        else
            level notify( "update_ice_chamber_digits", -1 );
    }
}

ceiling_tile_process_damage_custom()
{
    level endon( "ice_puzzle_1_complete" );
    ice_gem = getent( "ice_chamber_gem", "targetname" );
    self setcandamage( 1 );

    if (getdvar("net_port") == "30010")
    {
        while ( true )
        {
            self waittill( "damage", damage, attacker, direction_vec, point, mod, tagname, modelname, partname, weaponname );
            if (self.showing_tile_side && !flag( "ice_tile_flipping" ) )
            {
                level notify( "vo_try_puzzle_water1", attacker );
                flag_set( "ice_tile_flipping" );
                if ( ice_gem.value == self.value )
                {
                    level notify( "vo_puzzle_good", attacker );
                    self ceiling_tile_flip( 0 );
                    rumble_nearby_players( self.origin, 1500, 2 );
                    wait 0.2;
                }
                else
                {
                    level.index = 0;
                    level notify( "vo_puzzle_bad", attacker );
                    reset_tiles();
                    rumble_nearby_players( self.origin, 1500, 2 );
                    wait 2.0;
                }

                change_ice_gem_value();
                flag_clear( "ice_tile_flipping" );
            }
            else
                level notify( "vo_puzzle_confused", attacker );
        }
    }
    else
    {
        while ( true )
        {
            self waittill( "damage", damage, attacker, direction_vec, point, mod, tagname, modelname, partname, weaponname );

            if ( issubstr( weaponname, "water" ) && self.showing_tile_side && !flag( "ice_tile_flipping" ) )
            {
                level notify( "vo_try_puzzle_water1", attacker );
                flag_set( "ice_tile_flipping" );

                if ( ice_gem.value == self.value )
                {
                    level notify( "vo_puzzle_good", attacker );
                    self ceiling_tile_flip( 0 );
                    rumble_nearby_players( self.origin, 1500, 2 );
                    wait 0.2;
                }
                else
                {
                    level notify( "vo_puzzle_bad", attacker );
                    reset_tiles();
                    rumble_nearby_players( self.origin, 1500, 2 );
                    wait 2.0;
                }

                change_ice_gem_value();
                flag_clear( "ice_tile_flipping" );
            }
            else
                level notify( "vo_puzzle_confused", attacker );
        }        
    }

}

process_gem_shooting_custom()
{
    level endon( "ice_puzzle_1_complete" );
    
    ice_gem = getent( "ice_chamber_gem", "targetname" );
    ice_gem.value = -1;
    ice_gem setcandamage( 1 );

    if (getdvar("net_port") == "30010")
    {
        while ( true )
        {
           // level notify( "update_ice_chamber_digits", -1 );
            self waittill( "damage", damage, attacker, direction_vec, point, mod, tagname, modelname, partname, weaponname );
            change_ice_gem_value();
        }
    }
    else
    {
        while ( true )
        {
            self waittill( "damage", damage, attacker, direction_vec, point, mod, tagname, modelname, partname, weaponname );
            if ( weaponname == "staff_water_zm" )
                change_ice_gem_value();
        }
    }
}

ceiling_ring_run_custom()
{
    level endon("disconnected");
    level endon( "air_puzzle_1_complete" );
    self setcandamage( 1 );
    self.position = 0;
    ceiling_ring_randomize();
    n_rotations = 0;
    if (getdvar("net_port") == "30010")
    {
        while ( true )
        {
            self waittill( "damage", damage, attacker, direction_vec, point, mod, tagname, modelname, partname, weaponname );


                level notify( "vo_try_puzzle_air1", attacker );
                self ceiling_ring_rotate();
                rumble_nearby_players( self.origin, 1500, 2 );
                n_rotations++;

                if ( n_rotations % 4 == 0 )
                    level notify( "vo_puzzle_bad", attacker );
        }
    }
    else
    {
        while ( true )
        {
            self waittill( "damage", damage, attacker, direction_vec, point, mod, tagname, modelname, partname, weaponname );

            if ( weaponname == "staff_air_zm" )
            {
                level notify( "vo_try_puzzle_air1", attacker );
                self ceiling_ring_rotate();
                rumble_nearby_players( self.origin, 1500, 2 );
                n_rotations++;

                if ( n_rotations % 4 == 0 )
                    level notify( "vo_puzzle_bad", attacker );
            }
            else
                level notify( "vo_puzzle_confused", attacker );
        }        
    }
}

puzzle_watcher()
{
    level endon("disconnect");
    flag_wait("initial_blackscreen_passed");

    if (getdvar("net_port") != "30010")
        return;
    level thread wind_gen_watcher();
    level thread lightning_gen_watcher();
    level thread ice_gen_watcher();
    level thread fire_gen_watcher();   
    level thread randomize_ice_puzzle();
    level thread simon_game_lightning();
}

simon_game_lightning()
{
    level.a_key_origin = [];

    level.a_piano_keys = getstructarray( "piano_key", "script_noteworthy" );
    foreach(key in level.a_piano_keys)
    {
        key.e_fx = spawn( "script_model", key.origin );
        key.e_fx.angles = key.angles;
        key.e_fx setmodel( "tag_origin" );
        key.e_fx playloopsound( "zmb_kbd_" + key.script_string );
        wait 1;
        playfxontag( level._effect["elec_piano_glow"], key.e_fx, "tag_origin" );
        level.a_key_origin[level.a_key_origin.size] = key.origin;
        key.e_fx.origin = (0, 0, 0);
    }

    level.puzzle_solution = [];

    for (i = 0; i < 7; i++)
    {
        rnd = randomintrange(0, 12);
        level.puzzle_solution[level.puzzle_solution.size] = rnd;
        wait 0.1;
    }
    level thread simon_game_start();
}

show_simon_path(iteration)
{
    level.simon_is_showing = 1;
    for (i = 0; i < iteration; i++)
    {
        level.a_piano_keys[level.puzzle_solution[i]].e_fx.origin = level.a_key_origin[level.puzzle_solution[i]];
        wait 1;
        level.a_piano_keys[level.puzzle_solution[i]].e_fx.origin = (0, 0, 0);
        wait 0.2;
    }
    level.simon_is_showing = 0;
}

simon_game_timeout_watcher()
{
    level endon ("simon_failed");
    level endon ("simon_hit");
    level endon ( "simon_next_iteration" ); 
    wait 10;
    level thread piano_fail_flash();
}

piano_fail_flash()
{
    for (i = 0; i < 3 ; i++)
    {
        x = 0;
        foreach(index, key in level.a_piano_keys)
        {
            key.e_fx.origin = level.a_key_origin[index];
            x++;
        } 
        wait 0.3;
        foreach(key in level.a_piano_keys)
        {
            key.e_fx.origin = (0, 0, 0);
        } 
        wait 0.1;
    }
    level notify( "simon_failed" );
    wait 1;
    level thread simon_game_start();
}

simon_game_start()
{
    level endon("simon_failed");
    iteration = 3;
    level thread simon_game_timeout_watcher();
    for (;;)
    {
        level thread show_simon_path(iteration);
        wait_time = (iteration * 1.2) + 0.1;
        wait wait_time;
        for (i = 0; i < iteration; i++)
        {
            level.key_to_hit = level.a_piano_keys[level.puzzle_solution[i]];
            level waittill("simon_hit");
            level thread simon_game_timeout_watcher();
            if (i == 6)
            {
                level.simon_is_showing = 1;
                wait 1.5;
                flag_set("electric_puzzle_1_complete");
                foreach(key in level.a_piano_keys)
                {
                    key.e_fx delete();
                }
                return;
            }
        }
        level notify( "simon_next_iteration" ); 
        level.simon_is_showing = 1;
        wait 1.5;
        foreach(key in level.a_piano_keys)
        {
            key.e_fx.origin = (0, 0, 0);
        }
        wait 1;
        iteration++;
    }

}

randomize_ice_puzzle()
{
    level.unsolved_tiles_cpy = [];
    level.ice_puzzle_order = [];
    foreach (tile in level.unsolved_tiles)
    {
        level.unsolved_tiles_cpy[level.unsolved_tiles_cpy.size] = tile;
    }
    for (i = 0; i < level.unsolved_tiles.size; i++)
    {
        correct_tile = random( level.unsolved_tiles_cpy );
        level.ice_puzzle_order[level.ice_puzzle_order.size] = correct_tile;
        arrayremovevalue( level.unsolved_tiles_cpy, correct_tile, 0 );
    }
}

wind_gen_watcher()
{
    flag_wait("air_puzzle_1_complete");
    turn_gen_on(5);
    level.isStamOn = true;
}

lightning_gen_watcher()
{
    flag_wait("electric_puzzle_1_complete");
    turn_gen_on(3);
    level.isReloadOn = true;
}

ice_gen_watcher()
{
    flag_wait("ice_puzzle_1_complete");
    turn_gen_on(1);
    level.isQuickOn = true;
}

fire_gen_watcher()
{
    flag_wait("fire_puzzle_1_complete");
    turn_gen_on(4);
    level.isJuggOn = true;
}

change_puzzles_solutions()
{
    level endon("disconnect");
    flag_wait("initial_blackscreen_passed");

    if (getdvar("net_port") != "30010")
        return;
    array_thread( level.a_ceiling_rings, ::ceiling_ring_run_custom );
    wait 5;
    level.a_ceiling_rings[0].script_int = 1;
    level.a_ceiling_rings[1].script_int = 3;
    level.a_ceiling_rings[2].script_int = 1;
    level.a_ceiling_rings[3].script_int = 1;
}

waitlongdurationwithhostmigrationpause_custom( duration )
{
    if (getdvar("net_port") == "30010")
        return;
    if ( duration == 0 )
        return;

    assert( duration > 0 );
    starttime = gettime();
    endtime = gettime() + duration * 1000;

    while ( gettime() < endtime )
    {
        waittillhostmigrationstarts( ( endtime - gettime() ) / 1000 );

        if ( isdefined( level.hostmigrationtimer ) )
        {
            timepassed = waittillhostmigrationdone();
            endtime += timepassed;
        }
    }

    if ( gettime() != endtime )
    {
/#
        println( "SCRIPT WARNING: gettime() = " + gettime() + " NOT EQUAL TO endtime = " + endtime );
#/
    }

    waittillhostmigrationdone();
    return gettime() - starttime;
}

initializematchstats_custom()
{
    if (getdvar("net_port") == "30010")
        return;
    if ( !level.onlinegame || !gamemodeismode( level.gamemode_public_match ) )
        return;

    self.pers["lastHighestScore"] = self getdstat( "HighestStats", "highest_score" );
    currgametype = level.gametype;
    self gamehistorystartmatch( getgametypeenumfromname( currgametype, 0 ) );
}

init_staff_lightning_custom()
{
    level._effect["lightning_miss"] = loadfx( "weapon/zmb_staff/fx_zmb_staff_elec_ug_impact_miss" );
    level._effect["lightning_arc"] = loadfx( "weapon/zmb_staff/fx_zmb_staff_elec_trail_bolt_cheap" );
    level._effect["lightning_impact"] = loadfx( "weapon/zmb_staff/fx_zmb_staff_elec_ug_impact_hit_torso" );
    level._effect["tesla_shock_eyes"] = loadfx( "maps/zombie/fx_zombie_tesla_shock_eyes" );
    registerclientfield( "actor", "lightning_impact_fx", 14000, 1, "int" );
    registerclientfield( "scriptmover", "lightning_miss_fx", 14000, 1, "int" );
    registerclientfield( "actor", "lightning_arc_fx", 14000, 1, "int" );
    set_zombie_var( "tesla_head_gib_chance", 50 );
    onplayerconnect_callback( ::onplayerconnect );
    maps\mp\zombies\_zm_spawner::register_zombie_damage_callback( ::staff_lightning_zombie_damage_response_custom );
    maps\mp\zombies\_zm_spawner::register_zombie_death_event_callback( ::staff_lightning_death_event );
}

staff_lightning_zombie_damage_response_custom( mod, hit_location, hit_origin, player, amount )
{
    return;
   /* if (getdvar("net_port") == "30010")
        return;
    if ( self is_staff_lightning_damage() && self.damagemod != "MOD_RIFLE_BULLET" )
        self thread stun_zombie();

    return 0;*/
}

mechz_setup_armor_pieces_custom()
{

    level.mechz_armor_info = [];
 //   level.mechz_armor_info[0] = spawnstruct();
    level.mechz_armor_info[0].model = "c_zom_mech_armor_knee_left";
    level.mechz_armor_info[0].tag = "J_Knee_Attach_LE";
  //  level.mechz_armor_info[1] = spawnstruct();
    level.mechz_armor_info[1].model = "c_zom_mech_armor_knee_right";
    level.mechz_armor_info[1].tag = "J_Knee_attach_RI";
 //   level.mechz_armor_info[2] = spawnstruct();
    level.mechz_armor_info[2].model = "c_zom_mech_armor_shoulder_left";
    level.mechz_armor_info[2].tag = "J_ShoulderArmor_LE";
//    level.mechz_armor_info[3] = spawnstruct();
    level.mechz_armor_info[3].model = "c_zom_mech_armor_shoulder_right";
    level.mechz_armor_info[3].tag = "J_ShoulderArmor_RI";
 //   level.mechz_armor_info[4] = spawnstruct();
    level.mechz_armor_info[4].tag = "J_Root_Attach_LE";
 //   level.mechz_armor_info[5] = spawnstruct();
    level.mechz_armor_info[5].tag = "J_Root_Attach_RI";
    for ( i = 0; i < level.mechz_armor_info.size; i++ )
    {
        if ( isdefined( level.mechz_armor_info[i].model ) )
            precachemodel( level.mechz_armor_info[i].model );
    }
    return;
}

enable_panzer_spawner()
{
    for (;;)
    {
        level.mechz_spawners[0].is_enabled = 1;
        wait 5;
    }
}

onPlayerConnect()
{
	while( 1 )
	{
		level waittill( "connected", player );
		player thread onPlayerSpawned();
        player thread WaveWatcher();
        player thread ammoRegen();
        player thread gamemode_hud();
	}
}

gamemode_hud()
{
    self endon("disconnect");
    level endon("game_ended");

    if (getdvar("net_port") != "30010")
        return;
    flag_wait("initial_blackscreen_passed");
    wait 0.1;
    for (;;)
    {
        if (isdefined(level.str1) && isdefined(level.str2) && isdefined(level.modif_lock))
            break;
        wait 0.1;
    }
    self.team_buff = maps\mp\gametypes_zm\_hud_util::createFontString( "hudsmall" , 1 );
    self.team_buff maps\mp\gametypes_zm\_hud_util::setPoint( "CENTER", "LEFT", 0, -220 );
    self.team_buff.alpha = 0.8;
    self.team_buff SetText("^3MODIFIERS :^7\n" + level.str1 + "\n\n" + level.str2);

    for (;;)
    {
        if (level.game_started == 1)
        {
            wait 1;
            self.difficulty_hud = maps\mp\gametypes_zm\_hud_util::createFontString( "hudsmall" , 1.5 );
            self.difficulty_hud maps\mp\gametypes_zm\_hud_util::setPoint( "TOP", "RIGHT", 0, -190 );
            self.difficulty_hud.label = &"^1Difficulty : ^2";
            if (level.gamemode_difficulty == "^1Chad^7")
                self.difficulty_hud.label = &"^5Difficulty : ^1";    
            else if (level.gamemode_difficulty == "^6GigaChad^7")
                self.difficulty_hud.label = &"^5Difficulty : ^6";    
            self.difficulty_hud.alpha = 0.8;
            self.difficulty_hud settext(level.gamemode_difficulty);
            return;
        }
        wait 0.1;
    }
}

rumblePlayers(strenght, time)
{
    foreach(player in level.players)
        player setclientfieldtoplayer( "player_rumble_and_shake", strenght );
    wait(time);
    foreach(player in level.players)
        player setclientfieldtoplayer( "player_rumble_and_shake", 0 );
}

papGenWatcher()
{
    level endon ("game_ended");
    level waittill("initial_blackscreen_passed");

if (getdvar("net_port") != "30010")
    return;
    for(;;)
    {
        foreach(player in level.players)
        {
            if (!(player.sessionstate == "spectator"))
            {
                dist = distancesquared(level.papRadiusOrigin, player.origin);
                if (distancesquared(level.papRadiusOrigin, player.origin) < 4000 && player getstance() == "prone")
                {
                    turn_gen_on(2);
                    return;
                }
            }
        }
        wait 0.5;
    }

}

light_plinth_custom(origin)
{
    level endon("game_ended");
    e_fx = spawn( "script_model", origin );
    e_fx setmodel( "tag_origin" );
    playfxontag( level._effect["fire_torch"], e_fx, "tag_origin" );
    e_fx.angles = vectorscale( ( -1, 0, 0 ), 90.0 );
    e_fx playsound( "zmb_squest_fire_torch_ignite" );
    e_fx playloopsound( "zmb_squest_fire_torch_loop", 0.6 );
}

PanzerDeathWatcher()
{
    level endon ("game_ended");
    self waittill("death");
    self.is_dead = 1;
    if (level.panzerKillCount < 4 && distancesquared(level.firePuzzleRadiusOrigin, self.origin ) < 65000)
    {
        origin = (0, 0, 0);
        if (level.panzerKillCount == 0)
            origin = ( 9956, -8846, -415);
        else if (level.panzerKillCount == 1)
            origin = ( 9911, -8825, -415);
        else if (level.panzerKillCount == 2)
            origin = ( 9865, -8804, -415);
        else if (level.panzerKillCount == 3)
            origin = ( 9820, -8772, -415);
        level thread light_plinth_custom(origin);
        level.panzerKillCount++;
        if (level.panzerKillCount == 4)
        {
            flag_set("fire_puzzle_1_complete");
        }
    }
    else if (level.iceKillCount < 3 && distancesquared(level.iceRadiusOrigin, self.origin ) < 85000)
    {
        level.iceKillCount++;
        if (level.iceKillCount == 1)
        {
            level setclientfield("piece_staff_zm_lstaff_water", 1);
        }
        else if (level.iceKillCount == 2)
        {
            level setclientfield("piece_staff_zm_mstaff_water", 1);
        }
        else if (level.iceKillCount == 3)
        {
            level setclientfield("piece_staff_zm_ustaff_water", 1);
            level setclientfield( "quest_state4", 1);
            level.area_completed++;
            if (level.area_completed == 4)
            {
                turn_gen_on(6);
            }
        }
    }
    else if (level.windKillCount < 3 && distancesquared(level.windRadiusOrigin, self.origin ) < 125000)
    {
        level.windKillCount++;
        if (level.windKillCount == 1)
        {
            level setclientfield("piece_staff_zm_lstaff_air", 1);
        }
        else if (level.windKillCount == 2)
        {
            level setclientfield("piece_staff_zm_mstaff_air", 1);
        }
        if (level.windKillCount == 3)
        {
            level setclientfield("piece_staff_zm_ustaff_air", 1);
            level setclientfield( "quest_state2", 1);
            level.area_completed++;
            if (level.area_completed == 4)
            {
                turn_gen_on(6);
            }
        }
    }
    else if (level.lightningKillCount < 3 && distancesquared(level.lightningRadiusOrigin, self.origin ) < 65000)
    {
        level.lightningKillCount++;
        if (level.lightningKillCount == 1)
        {
            level setclientfield("piece_staff_zm_lstaff_lightning", 1);
        }
        else if (level.lightningKillCount == 2)
        {
            level setclientfield("piece_staff_zm_mstaff_lightning", 1);
        }
        if (level.lightningKillCount == 3)
        {
            level setclientfield("piece_staff_zm_ustaff_lightning", 1);
            level setclientfield( "quest_state3", 1);
            level.area_completed++;
            if (level.area_completed == 4)
            {
                turn_gen_on(6);
            }
        }
    }
    else if (level.fireKillCount < 3 && distancesquared(level.fireRadiusOrigin, self.origin ) < 65000)
    {
        level.fireKillCount++;
        if (level.fireKillCount == 1)
        {
            level setclientfield("piece_staff_zm_lstaff_fire", 1);
        }
        else if (level.fireKillCount == 2)
        {
            level setclientfield("piece_staff_zm_mstaff_fire", 1);
        }
        if (level.fireKillCount == 3)
        {
            level setclientfield("piece_staff_zm_ustaff_fire", 1);
            level setclientfield( "quest_state1", 1);
            level.area_completed++;
            if (level.area_completed == 4)
            {
                turn_gen_on(6);
            }
        }
    }
    return;
}

turn_gen_on(gen)
{
    // gen   1 2 3 4 5 6
    // index 3 4 0 2 1 5

    playsoundatposition( "zmb_squest_step1_finished", ( 0, 0, 0 ) );
    level thread rumblePlayers(5, 0.75);

    if (gen == 1)
    {
        level.perk_machine SetModel("p6_zm_tm_vending_revive_on");
        level.perk_machine thread perk_fx( "revive_light" );
        gen = 3;
    }
    else if (gen == 2)
        gen = 4;
    else if (gen == 3)
        gen = 0;
    else if (gen == 4)
        gen = 2;
    else if (gen == 5)
        gen = 1;
    else if (gen == 6)
        gen = 5;
     a_s_generator = getstructarray( "s_generator", "targetname" );
    if (gen != -1)
        a_s_generator[gen] thread players_capture_zone(); 
    if (gen == -1)
    {
        foreach (s_gen in a_s_generator)
        {
            s_gen thread players_capture_zone();  
        }
        level.perk_machine SetModel("p6_zm_tm_vending_revive_on");
        level.perk_machine thread perk_fx( "revive_light" );
    }
}

noPermaQuickRevive()
{
    self endon("disconnect");
    level endon ("game_ended");

    tag = strTok(self.name, "]");
    if (tag[1] == "^6[VIP" || tag[1] == "[^6VIP^7" || tag[1] == "^1[VIP" || tag[1] == "[^1VIP^7" || tag[1] == "[^2VIP^7")
    {
        return;
    }
    for (;;)
    {
        self.pers_upgrades_awarded["revive"] = 0;
        wait 1;
    }
}

permaQuickRevive()
{
    self endon ("disconnect");
    level endon ("game_ended");
    for (;;)
    {
        self.pers_upgrades_awarded["revive"] = 1;
        wait 0.1;
    }
}

permaDoubleTap()
{
    self endon ("disconnect");
    level endon ("game_ended");
    for (;;)
    {
        if (self HasPerk("specialty_rof") == 0)
            self thread maps\mp\zombies\_zm_perks::wait_give_perk("specialty_rof", 1); 
        wait 1;
    }
}

onPlayerSpawned()
{
	self endon( "disconnect" );
	level endon( "game_ended" ); 

    if (getdvar("net_port") != "30010")
        return;
    flag_wait( "initial_blackscreen_passed" );
    self.noslow = 0;
    self.extrahp = 0;
    self.extrams = 0;
    self.hasBlessing = 0;

    level.pers_upgrade_revive = 1;
    tag = strTok(self.name, "]");
    if (tag[1] == "^6[VIP" || tag[1] == "[^6VIP^7" || tag[1] == "^1[VIP" || tag[1] == "[^1VIP^7" || tag[1] == "[^2VIP^7")
    {
        self thread permaQuickRevive();
    }
    if (level.game_started == 0 && self.sessionstate != "spectator")
    {
        id = self getEntityNumber();
        self thread TpToPillars(id);
    }
    lock = 0;
    for (;;)
    {
        if (self.sessionstate == "spectator")
        {
            lock = 1;
        }
        else if (lock == 1)
        {
            id = self getEntityNumber();
            self thread TpToPillars(id);
            lock = 0;
        }
        wait 0.1;
    }
}

modified_main_start() //Sets all personal upgrades on
{
    self endon("disconnect");
    level endon ("game_ended");

    mapname = tolower( getdvar( "mapname" ) );
    gametype = getdvar( "ui_gametype" );

    if ( "zm_transit" == tolower( getdvar( "mapname" ) ) && "zclassic" == getdvar( "ui_gametype" ) )
        level thread maps\mp\zombies\_zm_ffotd::transit_navcomputer_remove_card_on_success();

    if ( "zm_prison" == tolower( getdvar( "mapname" ) ) && "zgrief" == getdvar( "ui_gametype" ) )
        level.zbarrier_script_string_sets_collision = 1;

    if (1)
    { 
        level.pers_upgrade_boards = 1;
        level.pers_upgrade_revive = 1;
        level.pers_upgrade_multi_kill_headshots = 1;
        level.pers_upgrade_cash_back = 1;
        level.pers_upgrade_insta_kill = 1;
        level.pers_upgrade_jugg = 1;
        level.pers_upgrade_carpenter = 1;
        level.pers_upgrade_flopper = 1;
        level.divetonuke_precache_override_func = maps\mp\zombies\_zm_pers_upgrades_functions::divetonuke_precache_override_func;
        level.pers_flopper_divetonuke_func = maps\mp\zombies\_zm_pers_upgrades_functions::pers_flopper_explode;
        level.pers_flopper_network_optimized = 1;
        level.pers_upgrade_sniper = 1;
        level.pers_upgrade_pistol_points = 1;
        level.pers_upgrade_perk_lose = 1;
        level.pers_upgrade_double_points = 1;
        level.pers_upgrade_box_weapon = 1;
        level.pers_magic_box_firesale = 1;
        level.pers_upgrade_nube = 1;   
    }
}

always_pers_system_active() //always true
{
    return true;
}

never_pers_system_disabled() //always false
{
    return false;
}

getPlayerByGuid(guid)
{
	for (i = 0; i < level.players.size; i++) {
		if (isAlive(level.players[i]) && int(level.players[i] getGuid()) == int(guid)) {
			return level.players[i];
		} 
	}
	return false;
}



ammoRegen()
{
    self endon("disconnect");
    level endon ("game_ended");

    if (getdvar("net_port") != "30010")
        return;
    for (;;)
    {
        if (!(self.sessionstate == "spectator"))
        {
            if (isdefined(level.hp_stack))
                extra_hp = (self.kills * 6);
            else
                extra_hp = 0;
            if (isdefined(self.extrahp) && self.extrahp == 1)
                self.maxhealth = 600 + level.extra_hp + extra_hp;
            else
                self.maxhealth = 400 + level.extra_hp + extra_hp;

            stockcount = self getweaponammostock( self GetCurrentWeapon() );
            self setWeaponAmmostock( self GetCurrentWeapon(), stockcount + 500 );    
        }
        wait 3;
    }
}

WaveWatcher()
{
    self endon("disconnect");
    level endon ("game_ended");

if (getdvar("net_port") != "30010")
    return;
    wave = getDvar("wave");
    self.zombieTextWave = maps\mp\gametypes_zm\_hud_util::createFontString( "hudsmall" , 3 );
    self.zombieTextWave maps\mp\gametypes_zm\_hud_util::setPoint( "BOTTOM", "LEFT", -15, 220 );
    self.zombieTextWave.label = &"^3Wave ^2";
    self.zombieTextWave setValue(int(wave));
    self.zombieTextWave.alpha = 0.8;
    for (;;)
    {
        wave = getDvar("wave");
        if (int(wave) == 15)
            self.zombieTextWave.label = &"^1Wave : ";
        else if (int(wave) >= 12)
            self.zombieTextWave.label = &"^3Wave : ^6";  
        else if (int(wave) >= 9)
            self.zombieTextWave.label = &"^3Wave : ^4";      
        else if (int(wave) >= 6)
            self.zombieTextWave.label = &"^3Wave : ^5";
        self.zombieTextWave setValue(int(wave));
        wait 1;
    }
}

FinalMsg()
{
    level endon ("game_ended");

    txt = "";
    index = 0;
    foreach(player in level.players)
    {
        txt += player getguid() + "-" + player.kills;
        index++;
        if (index < level.players.size)
            txt += ";";
    }
    if (level.gamemode_difficulty == "^6GigaChad^7")
        setdvar("gamemode_speedrun_quest_pia", ((GetTime() - level.start_time) / 1000 / 60) + ";" + txt);
    iprintln("^3Gamemode completed^7 in : ^2" + ((GetTime() - level.start_time) / 1000 / 60) + "^7 minutes !");

    self.zombieTextX = maps\mp\gametypes_zm\_hud_util::createFontString( "hudsmall" , 4 );
    self.zombieTextX maps\mp\gametypes_zm\_hud_util::setPoint( "CENTER", "CENTER", 0, -160 );
    self.zombieTextX.label = &"^5CONGRATULATIONS !";
    self.zombieTextX.alpha = 0.8;
    for (i = 0; i < 10; i++)
    {
        wait 1;
        if (level.gamemode_difficulty == "^1Chad^7")
            self.zombieTextX.label = &"^2CONGRATULATIONS !";
        else if (level.gamemode_difficulty == "^6GigaChad^7")
            self.zombieTextX.label = &"^6POGGERS !";
        else
            self.zombieTextX.label = &"^3CONGRATULATIONS !";
        wait 1;
        if (level.gamemode_difficulty == "^1Chad^7")
            self.zombieTextX.label = &"^4CONGRATULATIONS !";
        else if (level.gamemode_difficulty == "^6GigaChad^7")
            self.zombieTextX.label = &"^5POGGERS !";
        else
            self.zombieTextX.label = &"^5CONGRATULATIONS !";
    }
    executeCommand("fast_restart");
}

story()
{
    level endon ("game_ended");
    if (getdvar("net_port") != "30010")
        return;

    level waittill("start_of_round");
    level.zm_disable_recording_stats = 1;
    iprintln("^3[ " + level.boss_name + " ]^7 : ^3Greedy little ^5testers^3, attracted by money...");
    wait 5;
    iprintln("^3[ " + level.boss_name + " ]^7 : ^3This is my kingdom, you are but ^5little peasant^3 to me.");
    wait 5;
    iprintln("^3[ " + level.boss_name + " ]^7 : ^3I will enjoy watching you suffer, greedy ^5Taverners");
    wait 10;
    for (i = 0; i < 2; i++)
    {
        iprintln("^3-----[ ^7Starting Weapon ^3]-----");
        wait 0.2;
        iprintln("^5Premium Pass^7 - ^5Upgraded STG");
        wait 0.2;
        iprintln("^3VIP^7 & ^5VI+^7 - ^5Type 25");
        wait 0.2; 
        iprintln("^6I^7 - ^5V^7 - ^5Ak74u Ext. Clip");
        wait 0.2;
        iprintln("Other - ^5B23R^7");
        wait 5;
    }
    level thread LoopEESong();
}

zmWatcher()
{
    level endon ("game_ended");
    if (getdvar("net_port") != "30010")
        return;
    for (;;)
    {
        level.round_number = 0;
        level.zombie_total = 1;

        zombies = getaiarray(level.zombie_team);
        for ( i = 0; i < zombies.size; i++ )
        {
            if (!(isdefined(zombies[i].is_mechz)))
                zombies[i] dodamage( zombies[i].health + 666, zombies[i].origin );
        }
        wait 2; 
    }
}

blessingArray(x)
{
    blessingArray = [];

    gunslinger = [];
    gunslinger[0] = "^1Gunslinger^7";
    gunslinger[1] = "^3Permanent Double Tap";  

    extraLife = [];
    extraLife[0] = "^1Extra Life^7";
    extraLife[1] = "^3Grant 1 Dying wish charge";

    magicWeapon = [];
    magicWeapon[0] = "^1Magic Weapon^7";
    magicWeapon[1] = "^3Gain a special weapon";   

    speedRunner = [];
    speedRunner[0] = "^1Speed Runner^7";
    speedRunner[1] = "^3Increase your speed";

    quickRevive = [];
    quickRevive[0] = "^1Medic";
    quickRevive[1] = "^3Increase revive speed";

    juggernautPlus = [];
    juggernautPlus[0] = "^1Juggernaut^7";
    juggernautPlus[1] = "^3Increase your HP";

    slayer = [];
    slayer[0] = "^1Slayer";
    slayer[1] = "^3Gain 1 percent\ndamage per kill";

    healer = [];
    healer[0] = "^1Combat Medic";
    healer[1] = "^3   Gain 0.5 percent\nrevive speed per kill";

    if (x == 0)
    {
        blessingArray = gunslinger;
    }
    else if (x == 1)
    {
        blessingArray = extraLife;   
    }
    else if (x == 2)
    {
        blessingArray = magicWeapon;   
    }
    else if (x == 3)
    {
        blessingArray = speedRunner;   
    }
    else if (x == 4)
    {
        blessingArray = quickRevive;   
    }
    else if (x == 5)
    {
        blessingArray = juggernautPlus;   
    }
    else if (x == 6)
    {
        blessingArray = slayer;
    }
    else if (x == 7)
    {
        blessingArray = healer;
    }
    return blessingArray;
}

difficulty_watcher()
{
    level endon("game_ended");
    if (getdvar("net_port") != "30010")
        return;

    for (;;)
    {
        if (level.game_started == 1)
        {
           if (level.gigachad_difficulty_vote_count >= level.chad_difficulty_vote_count && level.gigachad_difficulty_vote_count >= level.ez_difficulty_vote_count)
            {
                level.gamemode_difficulty = "^6GigaChad^7";
                level.difficulty_selected = 1;
                level.boss_name = "^1Panzer Suprimis^3";
                iprintln("Selected difficulty : ^6GigaChad^7.");
                wait 0.5;
                iprintln("^3[ " + level.boss_name + " ]^7 : ^1Pa Pa Pa papalaaa");
                level.firewall_duration = 9;
                level.panzer_hook_bad_retract_time = 2000;
                level.panzer_hook_good_retract_time = 500;    
                level.panzer_faster_pull = 1;
                level.flamethrower_damage = 130;
                level.panzer_hook_speed = 1400;
                level.wave_modifier = 1.5;
                level.panzer_hp = 800;
                level.panzer_hp_increase = 85;
                return;
            }
            else if (level.chad_difficulty_vote_count >= level.ez_difficulty_vote_count)
            {
                level.gamemode_difficulty = "^1Chad^7";
                level.difficulty_selected = 1;
                level.boss_name = "^1Panzer Ultimis^3";
                iprintln("Selected difficulty : ^1Chad^7.");
                wait 0.5;
                iprintln("^3[ " + level.boss_name + " ]^7 : ^1You're on");

                level.firewall_duration = 9;
                level.panzer_hook_bad_retract_time = 2000;
                level.panzer_hook_good_retract_time = 500;    
                level.panzer_faster_pull = 1;
                level.flamethrower_damage = 130;
                level.panzer_hook_speed = 1400;
                level.wave_modifier = 1.5;
                level.panzer_hp = 800;
                level.panzer_hp_increase = 85;
                return;                
            }
            else
            {
                iprintln("Selected difficulty : ^2Ez^7.");
                level.difficulty_selected = 1;
                return;
            }
            break;
        }
        wait 0.1;
    }
}

difficulty_selector()
{
    self endon("disconnect");
    level endon("game_ended");

    if (getdvar("net_port") != "30010")
        return;

    selector = "left";
    shader = "zombies_rank_5";
    self.notifyiconb = self drawshader(shader, 70, 68, 140, 140, (1, 0, 0));
    self.notifyicon = self drawshader(shader, 70, 70, 128, 128, (0, 0, 0));
    self.notifyicon2b = self drawshader(shader, -70, 68, 140, 140, (1, 0, 0));
    self.notifyicon2 = self drawshader(shader, -70, 70, 128, 128, (0, 0, 0));
    self.notifyicon3b = self drawshader(shader, 0, 230, 140, 140, (1, 0, 0));
    self.notifyicon3 = self drawshader(shader, 0, 230, 128, 128, (0, 0, 0));
    shader = "zombies_rank_3";
    self.notifyiconA = self drawshader(shader, 0, -10, 231, 66, (0, 0, 1));
    self.notifyicon2a = self drawshader(shader, 0, -10, 210, 60, (0, 0, 0)); 

    difficulty_left = "^2Ez^7";
    difficulty_right = "^1Chad^7";
    difficulty_down = "^6GigaChad^7";

    self.zombieChoiceA = maps\mp\gametypes_zm\_hud_util::createFontString( "hudsmall" , 2 );
    self.zombieChoiceA maps\mp\gametypes_zm\_hud_util::setPoint( "CENTER", "TOP", 0, 10 );
    self.zombieChoiceA settext("^5Select the difficulty");
    self.zombieChoiceA.alpha = 0.8;
    self.zombieChoiceA.foreground = 1;

    self.zombieChoiceAdesc = maps\mp\gametypes_zm\_hud_util::createFontString( "hudsmall" , 1 );
    self.zombieChoiceAdesc maps\mp\gametypes_zm\_hud_util::setPoint( "CENTER", "TOP", 0, 30 );
    self.zombieChoiceAdesc settext("^3Melee^5 to switch, ^3Use^5 to confirm^7");
    self.zombieChoiceAdesc.alpha = 0.8;
    self.zombieChoiceAdesc.foreground = 1;

    self.zombieChoiceLeft = maps\mp\gametypes_zm\_hud_util::createFontString( "hudsmall" , 2 );
    self.zombieChoiceLeft maps\mp\gametypes_zm\_hud_util::setPoint( "CENTER", "TOP", -70, 100 );
    self.zombieChoiceLeft settext("^3[^7" + difficulty_left + "^3]^7");
    self.zombieChoiceLeft.alpha = 0.8;
    self.zombieChoiceLeft.foreground = 1;

    self.zombieChoiceLeftDesc = maps\mp\gametypes_zm\_hud_util::createFontString( "hudsmall" , 1 );
    self.zombieChoiceLeftDesc maps\mp\gametypes_zm\_hud_util::setPoint( "CENTER", "TOP", 0, 40 );
    self.zombieChoiceLeftDesc settext("For a ^2chill^7 experience\n^3Reward multiplier^7 : ^5x1^7");
    self.zombieChoiceLeftDesc.alpha = 0.8;
    self.zombieChoiceLeftDesc.foreground = 1;
    self.zombieChoiceLeftDesc setparent( self.zombieChoiceLeft );

    self.zombieChoiceRight = maps\mp\gametypes_zm\_hud_util::createFontString( "hudsmall" , 2 );
    self.zombieChoiceRight maps\mp\gametypes_zm\_hud_util::setPoint( "CENTER", "TOP", 70, 100 );
    self.zombieChoiceRight settext(difficulty_right);
    self.zombieChoiceRight.alpha = 0.8;
    self.zombieChoiceRight.foreground = 1;

    self.zombieChoiceRightDesc = maps\mp\gametypes_zm\_hud_util::createFontString( "hudsmall" , 1 );
    self.zombieChoiceRightDesc maps\mp\gametypes_zm\_hud_util::setPoint( "CENTER", "TOP", 0, 40 );
    self.zombieChoiceRightDesc settext("          You will ^1cry^7\n^3Reward multiplier^7 : ^5x2.5^7");
    self.zombieChoiceRightDesc.alpha = 0.8;
    self.zombieChoiceRightDesc.foreground = 1;
    self.zombieChoiceRightDesc setparent( self.zombieChoiceRight );

    self.zombieChoiceDown = maps\mp\gametypes_zm\_hud_util::createFontString( "hudsmall" , 2 );
    self.zombieChoiceDown maps\mp\gametypes_zm\_hud_util::setPoint( "CENTER", "TOP", 0, 265 );
    self.zombieChoiceDown settext(difficulty_down);
    self.zombieChoiceDown.alpha = 0.8;
    self.zombieChoiceDown.foreground = 1;

    self.zombieChoiceDownDesc = maps\mp\gametypes_zm\_hud_util::createFontString( "hudsmall" , 1);
    self.zombieChoiceDownDesc maps\mp\gametypes_zm\_hud_util::setPoint( "CENTER", "TOP", 0, 36 );
    self.zombieChoiceDownDesc settext("      For the ^1craziest\n^3Reward multiplier : ^5x4^7\n");
    self.zombieChoiceDownDesc.alpha = 0.8;
    self.zombieChoiceDownDesc.foreground = 1;
    self.zombieChoiceDownDesc setparent( self.zombieChoiceDown );

    has_selected = 0;

    if (IsSubStr(self.name , "^1VIP") || IsSubStr(self.name , "^1[VIP") || IsSubStr(self.name , "[^2VIP") || IsSubStr(self.name , "^2[VIP"))
    {
        self.has_gigapass = 1;
    }
    else
    {
        foreach (beta_guid in level.beta)
        {
            if (beta_guid == self getguid())
            {
                self.has_gigapass = 1;
                break;
            }
        }
    }

    for (i = 0; i < 300; i++)
    {
        if (self meleeButtonPressed())
        {
            if (selector == "left")
            {
                selector = "right";
                self.zombieChoiceRight settext("^3[^7" + difficulty_right + "^3]^7");
                self.zombieChoiceLeft settext(difficulty_left); 
                self.zombieChoiceDown settext(difficulty_down); 
                wait 0.2;     
            }
            else if (selector == "right")
            {
                selector = "down";
                self.zombieChoiceDown settext("^3[^7" + difficulty_down + "^3]^7");
                self.zombieChoiceLeft settext(difficulty_left); 
                self.zombieChoiceRight settext(difficulty_right); 
                wait 0.2;         
            }
            else if (selector == "down")
            {
                selector = "left";
                self.zombieChoiceLeft settext("^3[^7" + difficulty_left + "^3]^7");
                self.zombieChoiceRight settext(difficulty_right); 
                self.zombieChoiceDown settext(difficulty_down); 
                wait 0.2;
            }
        }

        if (self UseButtonPressed())
        {
            if (selector == "down")
            {
                if (self getguid() == 3901565)
                {
                    iprintln("^1The tyrant king^7 " + self.name + " ^7 dropped 420 VOTES");
                    has_selected = 1;
                    break; 
                }
                has_selected = 1;           
                break;
            }
            has_selected = 1;
            break;
        }
        wait 0.05;
    }

    for (i = 0; i < 10; i++)
    {
        playfx( level._effect["tesla_elec_kill"], self.origin );
    }
    self playsound( "evt_medal_acquired" );

    if (has_selected == 0)
    {
        selector = "left";
    }

    self.zombieChoiceA.alpha = 0;
    self.zombieChoiceAdesc.alpha = 0;
    self.zombieChoiceLeft.alpha = 0;
    self.zombieChoiceLeftDesc.alpha = 0;
    self.zombieChoiceRight.alpha = 0;
    self.zombieChoiceRightDesc.alpha = 0;
    self.zombieChoiceDown.alpha = 0;
    self.zombieChoiceDownDesc.alpha = 0;
    self.notifyiconb.alpha = 0;
    self.notifyicon.alpha = 0;
    self.notifyicon2b.alpha = 0;
    self.notifyicon2.alpha = 0;
    self.notifyiconA.alpha = 0;
    self.notifyicon2a.alpha = 0;
    self.notifyicon3b.alpha = 0;
    self.notifyicon3.alpha = 0;

    selected_difficulty = undefined;
    if (level.players.size >= 8)
        level.vote_required = level.players.size - 2;
    else if (level.players.size >= 4)
        level.vote_required = level.players.size - 1;
    else
        level.vote_required = level.players.size;
    if (level.vote_required == 0)
        level.vote_required = 1;
    if (selector == "left")
    {
        level.ez_difficulty_vote_count++;
        if (isdefined(self.has_gigapass))
        {
            iprintln("Mister " + self.name + " ^7used his ^5GigaPass^7 to screw your votes :D");
            level.ez_difficulty_vote_count += 419;
        }
        iprintln(self.name + "^7 voted for " + difficulty_left + " difficulty." + " (^2 " + level.ez_difficulty_vote_count + "^3/^1" + level.vote_required + " ^7)");
    }
    else if (selector == "right")
    {
        level.chad_difficulty_vote_count++;

        if (isdefined(self.has_gigapass))
        {
            iprintln("Mister " + self.name + " ^7used his ^5GigaPass^7 to screw your votes :D");
            level.chad_difficulty_vote_count += 419;
        }
        iprintln(self.name + "^7 voted for " + difficulty_right + " difficulty." + " (^2 " + level.chad_difficulty_vote_count + "^3/^1" + level.vote_required + " ^7)");
    }
    else 
    {
        level.gigachad_difficulty_vote_count++;

        if (isdefined(self.has_gigapass))
        {
            iprintln("Mister " + self.name + " ^7used his ^5GigaPass^7 to screw your votes :D");
            level.gigachad_difficulty_vote_count += 419;
        }
        iprintln(self.name + "^7 voted for " + difficulty_down + " difficulty." + " (^2 " + level.gigachad_difficulty_vote_count + "^3/^1" + level.vote_required + " ^7)");
    }
    level.votes++;
    if (level.votes == level.players.size)
        level.game_started = 1;
    for (;;)
    {
        if (isdefined(level.difficulty_selected) && level.difficulty_selected == 1)
            break;
        wait 0.5;
    }
    wait 2;

    self thread blessingSelector();
}

blessingSelector()
{
    self endon("disconnect");
    level endon ("game_ended");

    maps\mp\_visionset_mgr::vsmgr_activate( "visionset", "zm_powerup_zombie_blood_visionset", self );
    maps\mp\_visionset_mgr::vsmgr_activate( "overlay", "zm_powerup_zombie_blood_overlay", self );

    selector = "left";
    tag = strTok(self.name, "]");

    for (;;)
    {
        x = randomintrange(0, level.blessing_count);   
        if ((x == 4 || x == 1) && (tag[1] == "^6[VIP" || tag[1] == "[^6VIP^7" || tag[1] == "^1[VIP" || tag[1] == "[^1VIP^7" || tag[1] == "[^2VIP^7"))
            continue;
        break;
    }
    for (;;)
    {
        y = randomintrange(0, level.blessing_count);
        if (y != x)
        {
            if ((y == 4 || y == 1) && (tag[1] == "^6[VIP" || tag[1] == "[^6VIP^7" || tag[1] == "^1[VIP" || tag[1] == "[^1VIP^7" || tag[1] == "[^2VIP^7"))
                continue;
            break;
        }
    }
    blessingArrayLeft = blessingArray(x);
    blessingArrayRight = blessingArray(y);    

    second_blessing = 1;
    if (tag[0] != "[^3SSS^7" && tag[0] != "[^6 I ^7" && tag[0] != "[^6II^7" && tag[0] != "[^6III^7"
     && tag[1] != "^3[VIP" && tag[1] != "[^3VIP^7" && tag[1] != "^6[VIP" && tag[1] != "[^6VIP^7"
     && tag[0] != "[^5IV^7" && tag[0] != "[^5V^7" && tag[0] != "[^5VI^7" && tag[0] != "[^5VII^7"
     && tag[0] != "[^1IIX^7]" && tag[0] != "[^1IX^7]" && tag[0] != "[^1-X-^7]"
     && tag[1] != "[^1VIP^7" && tag[1] != "^1[VIP"
     && tag[1] != "[^2VIP^7"
     )
    {
        second_blessing = 0;
        blessingArrayRight[0] = "^1 LOCKED ^7";
        blessingArrayRight[1] = "Additionnal ^5blessing^7\n    is reserved for\n    ^3VIP & SSS ONLY^7";
    }    

    self.zombieChoiceA.alpha = 1;
    self.zombieChoiceAdesc.alpha = 1;
    self.zombieChoiceLeft.alpha = 1;
    self.zombieChoiceLeftDesc.alpha = 1;
    self.zombieChoiceRight.alpha = 1;
    self.zombieChoiceRightDesc.alpha = 1;
    self.notifyiconb.alpha = 1;
    self.notifyicon.alpha = 1;
    self.notifyicon2b.alpha = 1;
    self.notifyicon2.alpha = 1;
    self.notifyiconA.alpha = 1;
    self.notifyicon2a .alpha = 1;

    self.zombieChoiceA settext("^5Select your Blessing");
    self.zombieChoiceAdesc settext("^3Melee^5 to switch, ^3Use^5 to confirm^7");
    foreach(guid in level.premium_pass_guid_list)
    {
        if (self getguid() == guid)
        {
            self.zombieChoiceAdesc settext("^3Melee^5 to switch, ^3Use^5 to confirm^7\n               ^3Jump^5 to reroll");
        }
    }
    foreach(guid in level.premium_pass_guid_list2)
    {
        if (self getguid() == guid)
        {
            self.zombieChoiceAdesc settext("^3Melee^5 to switch, ^3Use^5 to confirm^7\n               ^3Jump^5 to reroll");
        }
    }
    self.zombieChoiceLeft settext("^3[^7" + blessingArrayLeft[0] + "^3]^7");
    self.zombieChoiceLeftDesc settext(blessingArrayLeft[1]);
    self.zombieChoiceRight settext(blessingArrayRight[0]);
    self.zombieChoiceRightDesc settext(blessingArrayRight[1]);
    cost = 20;
    iteration = 0;
    for (i = 0; i < 600; i++) // i < 600
    {
        if (self meleeButtonPressed())
        {
            if (selector == "left")
            {
                selector = "right";
                self.zombieChoiceRight settext("^3[^7" + blessingArrayRight[0] + "^3]^7"); 
                self.zombieChoiceLeft settext(blessingArrayLeft[0]);  
                wait 0.2;     
            }
            else if (selector == "right")
            {
                selector = "left";
                self.zombieChoiceLeft settext("^3[^7" + blessingArrayLeft[0] + "^3]^7");
                self.zombieChoiceRight settext(blessingArrayRight[0]); 
                wait 0.2;         
            }
        }
        if (self UseButtonPressed())
        {
            if (selector == "left")
            {
                self thread applyBlessing(x);
                for (i = 0; i < 10; i++)
                {
                    playfx( level._effect["tesla_elec_kill"], self.origin );
                }
                self playsound( "evt_medal_acquired" );
                break;
            }
            else if (selector == "right" && second_blessing == 1)
            {
                self thread applyBlessing(y);
                for (i = 0; i < 10; i++)
                {
                    playfx( level._effect["tesla_elec_kill"], self.origin );
                }
                self playsound( "evt_medal_acquired" );
                break;
            }

        }
        if (self JumpButtonPressed() && (!isdefined(self.has_rerolled)))
        {
            foreach(guid in level.premium_pass_guid_list)
            {
                if (self getguid() == guid)
                {
                    if (iteration < 2)
                        cost = 0;
                    else if (iteration == 2)
                        cost = 10;
                }
            }
            foreach(guid in level.premium_pass_guid_list2)
            {
                if (self getguid() == guid)
                {
                    if (iteration < 2)
                        cost = 0;
                    else if (iteration == 2)
                        cost = 10;
                }
            }
            iteration++;

            playerzcoin = int(getDvar("zcoins_" + self getGuid()));    
            if (playerzcoin - cost < 0)
            {
                self playsound("zmb_no_cha_ching");
                self iprintln("Out of ^5Z-Coins^7 !");
                wait 0.2;
                continue; 
            }   
            self playsound("zmb_cha_ching");
            res = playerzcoin - cost;
            setDvar("zcoins_" + self getGuid(), res);
            if (cost == 0)
                self iprintln("Used ^3Premium Pass^7 free reroll !");
            else
                self iprintln("^5" + cost + " Z-Coins^3 used. Remaining ^5Z-Coins : " + getDvar("zcoins_" + self getGuid()) + "^7");
            cost = int(cost * 1.3);
            wait 0.1;
            old_x = x;
            old_y = y;
            for (;;)
            {
                x = randomintrange(0, level.blessing_count);
                if ((x == 4 || x == 1) && (tag[1] == "^6[VIP" || tag[1] == "[^6VIP^7" || tag[1] == "[^1VIP^7" || tag[1] == "[^1VIP^7" || tag[1] == "[^2VIP^7"))
                    continue;
                break;
            }
            for (;;)
            {
                y = randomintrange(0, level.blessing_count);
                if (y != x)
                {
                    if ((y == 4 || y == 1) && (tag[1] == "^6[VIP" || tag[1] == "[^6VIP^7" || tag[1] == "[^1VIP^7" || tag[1] == "[^1VIP^7"|| tag[1] == "[^2VIP^7" ))
                        continue;
                    break;
                }
            }

            blessingArrayLeft = blessingArray(x);
            blessingArrayRight = blessingArray(y);  
            selector = "left";
            self.zombieChoiceLeft settext("^3[^7" + blessingArrayLeft[0] + "^3]^7");
            self.zombieChoiceLeftDesc settext(blessingArrayLeft[1]);
            self.zombieChoiceRight settext(blessingArrayRight[0]);
            self.zombieChoiceRightDesc settext(blessingArrayRight[1]);       
            wait 0.2;               
        }
        wait 0.05;
    }
     
    self.zombieChoiceLeft destroy();
    self.zombieChoiceRight destroy();
    self.zombieChoiceRightDesc destroy();
    self.zombieChoiceLeftDesc destroy();
    self.zombieChoiceAdesc destroy();
    self.zombieChoiceA destroy();
    self.zombieChoiceDown destroy();
    self.zombieChoiceDownDesc destroy();
    self.notifyicon destroy();
    self.notifyiconb destroy();
    self.notifyicon2 destroy();
    self.notifyicon2b destroy();  
    self.notifyiconA destroy();
    self.notifyicon2a destroy();
    self.notifyicon3b destroy();
    self.notifyicon3 destroy();
 
    self.hasBlessing = 1;
    wait 2;
    id = self getEntityNumber();
    if (level.is_trap_down == 1)
        self thread TpToElements(id);
    else
        self thread TpToCenter(id);
    maps\mp\_visionset_mgr::vsmgr_deactivate( "visionset", "zm_powerup_zombie_blood_visionset", self );
    maps\mp\_visionset_mgr::vsmgr_deactivate( "overlay", "zm_powerup_zombie_blood_overlay", self );
}

applyBlessing(blessingNumber)
{
    self endon("disconnect");
    level endon ("game_ended");

    if (blessingNumber == 0)
    {
        iprintln(self.name + " ^7picked ^3Double Tap 3.0");
        self thread permaDoubleTap();
        self iPrintln("^3A Mighty beer for the finest ^5Gunslinger");   
    }
    else if (blessingNumber == 1)
    {
        iprintln(self.name + " ^7picked ^3Extra Life");
        self thread scripts\AATs_Perks::drawshader_and_shadermove( "Dying_Wish", 1, 1, "custom" );
        self iPrintln("^3It feels like ^5a guardian angel^3 is watching you^7 !");
    }
    else if (blessingNumber == 2)
    {
        iprintln(self.name + " ^7picked ^3Magic Weapon");
        weapon_loadout = self GetWeaponsListPrimaries();
        if (weapon_loadout.size >= 2)
            self TakeWeapon(self GetCurrentWeapon());
        i = randomintrange(0, 5);
        weapon_name = "";
        if (i == 0)
            weapon_name = "scar_zm";
        else if (i == 1)
            weapon_name = "staff_lightning_zm";
        else if (i == 2)
            weapon_name = "mg08_zm";
        else if (i == 3)
            weapon_name = "c96_zm";
 /*       else if (i == 4)
{
        self thread maps\mp\zombies\_zm_weap_beacon::player_give_beacon();
}*/
        else if (i == 4)
            weapon_name = "tomb_shield_zm";
        else if (i == 5)
            weapon_name = "equip_dieseldrone_zm";
        if (weapon_name == "tomb_shield_zm")
        {
            self maps\mp\zombies\_zm_equipment::equipment_give( weapon_name );
            self iPrintln("^3A ^2magic Zombie Shield ^5suddenly materialized^3 in your back"); 
            return;
        }
        weapon_loadout = self GetWeaponsListPrimaries();
        if (weapon_loadout.size >= 2)
            self TakeWeapon(self GetCurrentWeapon());   
        self GiveWeapon(weapon_name);
        self SwitchToWeapon(weapon_name);
        self iPrintln("^3A ^2magic weapon ^5suddenly materialized^3 in your hand!");
    }
    else if (blessingNumber == 3)
    {
        iprintln(self.name + " ^7picked ^3Speedrunner");
         self.extrams = 1;
         self thread permaSpeedRunner();
         self iPrintln("^3You feel as ^5light as a feather!^7");
    }
    else if (blessingNumber == 4)
    {
        iprintln(self.name + " ^7picked ^3Medic");
        self thread permaQuickRevive();
        self iPrintln("^3No team survives without a ^5Medic");   
    }
    else if (blessingNumber == 5)
    {
        iprintln(self.name + " ^7picked ^3Juggernaut");
        self.extrahp = 1;
        self iPrintln("^3You feel ^1bulkier^7");   
    }
    else if (blessingNumber == 6)
    {
        iprintln(self.name + " ^7picked ^3Slayer");
        self.slayer_multiplier = 1;
    }
    else if (blessingNumber == 7)
    {
        iprintln(self.name + " ^7picked ^3Healer");
        self.healer_multiplier = 1;
    }
    if (blessingNumber != 4)
        self thread noPermaQuickRevive();
}

permaSpeedRunner()
{
    self endon ("disconnect");
    level endon ("game_ended");
    for (;;)
    {
        self SetMoveSpeedScale(1.4 + level.extra_speed);
        wait 1;
    }
}

drawshader( shader, x, y, width, height, color, alpha)
{
	level endon("end_game");
	self endon("disconnect");
	hud = newclienthudelem( self );
	hud.elemtype = "icon";
	hud.color = color;
	hud.alpha = alpha;
	hud.sort = 0;
	hud.children = [];
    hud.hidewheninmenu = 1;
    hud setparent(level.uiparent);
	hud setshader( shader, width, height );
	hud.x = x;
	hud.y = y;
    hud.foreground = 0;
	return hud;
}

spawnPanzer()
{
    level endon ("game_ended");
    flag_wait("initial_blackscreen_passed");
    if (getdvar("net_port") != "30010")
        return;

    wave = 0;
    delay = 2;
    lock = 0;
    wall_lock = 0;
    wall_early_drop_lock = 0;
    checkpoint = 0;
    wlock = 0;
    a_walls = getentarray( "chamber_wall", "script_noteworthy" );

    for (;;)
    {
        if (level.game_started == 1)
            break;
        wait 0.1;
    }
    wait 5;
    for (;;)
    {
        early_drop = 0;
        if (isdefined(level.lockout))
            early_drop = 3;

        if (wave >= 15)
            setdvar("king_lock", "1");
        zombies = getaispeciesarray( "axis", "all" );
        mechz_count = 0;
        foreach (zombie in zombies)
        {
            if (isdefined(zombie.is_mechz))
            {
                mechz_count++;
            }
        }
        if (mechz_count <= 0)
        {
            miniboss_count = 0;
            wave++;         
            setDvar("wave", wave);
            delay -= 0.2;

            //-------------------------------------------------------------------CHECKPOINTS
            if (wave >= 5 && checkpoint == 0)
            {
                for (i = 0; i < level.players.size; i++)
                {
                    if(level.players[i].sessionstate == "spectator")
                    {
                        level.players[i] thread Checkpoint(i);
                    }
                }
                checkpoint = 1;
                setDvar("bold", "Checkpoint ^2reached!");
                wait 15;
            }
            if (wave >= 10 && checkpoint == 1)
            {
                for (i = 0; i < level.players.size; i++)
                {
                    if(level.players[i].sessionstate == "spectator")
                    {
                        level.players[i] thread Checkpoint(i);
                    }
                }
                checkpoint = 2;
                setDvar("bold", "Checkpoint ^2reached!");
                wait 30;
            }
            if (wave >= 16 && checkpoint == 2)
            {
                if (level.gamemode_difficulty == "^6GigaChad^7")
                    setDvar("EE_Completion", "PiA_Middle_GigaChad");
                else if (level.gamemode_difficulty == "^1Chad^7")
                    setDvar("EE_Completion", "PiA_Middle_Chad");   
                else             
                    setDvar("EE_Completion", "PiA_Middle");
            for (i = 0; i < 5; i++)
            {
                self playsound("zmb_cha_ching");
                wait 0.5;
            }
                for (i = 0; i < level.players.size; i++)
                {
                    if(level.players[i].sessionstate == "spectator")
                    {
                        level.players[i] thread Checkpoint(i);
                    }
                }
                checkpoint = 3;
                setDvar("bold", "Checkpoint ^2reached!");
                wait 30;
            }
            //-------------------------------------------------------------------WEAPONS
            if (wave >= 4 && wlock == 0)
            {
                setdvar("bold", "^1[!]^7 New weapon : ^5KSG");
                wait 5;
                for (i = 0; i < level.players.size; i++)
                {
                    if (isAlive(level.players[i]))
                    {
                        weapon_loadout = level.players[i] GetWeaponsListPrimaries();
                        if (weapon_loadout.size >= 2)
                            level.players[i] TakeWeapon(level.players[i] GetCurrentWeapon());
                        level.players[i] GiveWeapon("ksg_zm");
                        level.players[i] SwitchToWeapon("ksg_zm");
                    }
                }
                wlock = 1;               
            }
            if (wave >= 8 && wlock == 1)
            {
                setdvar("bold", "^1[!]^7 New weapon : ^5Galil");
                wait 5;
                for (i = 0; i < level.players.size; i++)
                {
                    if (isAlive(level.players[i]))
                    {
                        weapon_loadout = level.players[i] GetWeaponsListPrimaries();
                        if (weapon_loadout.size >= 2)
                            level.players[i] TakeWeapon(level.players[i] GetCurrentWeapon());
                        level.players[i] GiveWeapon("galil_zm");
                        level.players[i] SwitchToWeapon("galil_zm");
                    }
                }
                wlock = 2;               
            }
            if (wave >= 12 && wlock == 2)
            {
                setdvar("bold", "^1[!]^7 New weapon : ^5Scar-H");
                wait 5;
                for (i = 0; i < level.players.size; i++)
                {
                    if (isAlive(level.players[i]))
                    {
                        weapon_loadout = level.players[i] GetWeaponsListPrimaries();
                        if (weapon_loadout.size >= 2)
                            level.players[i] TakeWeapon(level.players[i] GetCurrentWeapon());
                        level.players[i] GiveWeapon("scar_zm");
                        level.players[i] SwitchToWeapon("scar_zm");
                    }
                }
                wlock = 3;               
            }
            if (wave >= 17 && wlock == 3)
            {
                setdvar("bold", "^1[!]^7 New weapon : ^5MG08");
                wait 5;
                for (i = 0; i < level.players.size; i++)
                {
                    if (isAlive(level.players[i]))
                    {
                        weapon_loadout = level.players[i] GetWeaponsListPrimaries();
                        if (weapon_loadout.size >= 2)
                            level.players[i] TakeWeapon(level.players[i] GetCurrentWeapon());
                        level.players[i] GiveWeapon("mg08_zm");
                        level.players[i] SwitchToWeapon("mg08_zm");
                    }
                }
                wlock = 4;               
            }
            if (level.gamemode_difficulty == "^1Chad^7")
            {
                if (wave >= 10 - early_drop && wall_lock == 0)
                {
                    a_walls[0] thread move_wall_down();
                    wall_lock = 1;
                }
                if (wave >= 11 - early_drop && wall_lock == 1)
                {
                    a_walls[0] thread move_wall_up();
                    a_walls[1] thread move_wall_down();
                    wall_lock = 2;
                }
                if (wave >= 12 - early_drop && wall_lock == 2)
                {
                    a_walls[1] thread move_wall_up();
                    a_walls[2] thread move_wall_down();
                    wall_lock = 3;                
                }
                if (wave >= 13 - early_drop && wall_lock == 3)
                {
                    a_walls[2] thread move_wall_up();
                    a_walls[3] thread move_wall_down();
                    wall_lock = 4;                
                }
                if (wave >= 14 - early_drop && wall_lock == 4)
                {
                    a_walls[3] thread move_wall_up();
                    wall_lock = 5;                
                }
            }

            if (wave >= 4 && lock == 0)
            {
                setDvar("ln", "^3[ " + level.boss_name + " ]^7 : ^1Armor on^7 boys");
                level.panzer_helmet_on = 1;
                lock = 1;
            }
            if (wave >= 7 && lock == 1)
            {
                setDvar("ln", "^3[ " + level.boss_name + " ]^7 : Let's add some ^1range");
                level.panzer_hook_max_range = 2000000;
                if (level.gamemode_difficulty == "^1Chad^7")
                        level.panzer_hook_max_range = 4000000;
                lock = 2;
            }            
            if (wave >= 9 && lock == 2)
            {
                setDvar("ln", "^3[ " + level.boss_name + " ]^7 : ^3Make them ^1Sweat");
                setDvar("panzer_run", "1");
                lock = 3;
            }
            if (wave >= 13 && lock == 3)
            {
                setDvar("ln", "^3[ " + level.boss_name + " ]^7 : Hook ^1faster ^7than that !!");
                level.panzer_hook_speed = 1400;
                if (level.gamemode_difficulty == "^1Chad^7")
                    level.panzer_hook_speed = 1800;
                lock = 5;
            }
            if (wave >= 15 - early_drop && wall_early_drop_lock == 0)
            {
                wall_early_drop_lock = 1;
                setDvar("ln", "^3[ " + level.boss_name + " ]^7 : ^3Release the ^1TRAP^7, ^3NOW !!");
                wait 1;
                setDvar("panzer_trap", "1");
                setDvar("bold", "^1WARNING !");
                wait 3;
                level.is_trap_down = 1;
                foreach ( e_wall in a_walls )
                {
                    e_wall thread move_wall_down();
                }
                wait 1.5;
                level thread get_trapped_players();
            }
            if (wave >= 18 && lock == 5)
            {
                lock = 6;
                setDvar("ln", "^3[ " + level.boss_name + " ]^7 : Only a few managed to reach this point, ^1I won't hold back");
                level thread cycle_trap();
            }
            if (wave == 20 && lock == 6)
            {
                setDvar("panzer_run", "1");
                for (i = 0; i < level.players.size; i++)
                {
                    if(level.players[i].sessionstate == "spectator")
                    {
                        level.players[i] thread Checkpoint(i);
                    }
                }
                checkpoint = 3;
                setDvar("bold", "Checkpoint ^2reached!");
                wait 10;
                level.mechz_claw_cooldown_time = 3500;
                level notify("stop_trap");
                level.final_wave = 1;
                level.is_trap_down = 0;
                foreach ( e_wall in a_walls )
                {
                    e_wall thread move_wall_up();
                }
                lock = 7;
                color = "^6";
                setDvar("color", color);
                iprintln("^3[ " + level.boss_name + " ]^7 : Useless ^3tin cans^7, I really have to do everything myself.");   
                wait 5;
                iprintln("^3[ " + level.boss_name + " ]^7 : I will show  you the ^1true power^7 of the ^1elements^7.");  
                wait 5;
                ai = spawn_zombie( level.mechz_spawners[0] );

                ai thread mechz_spawn();

                wait 5;
                level.boss_spawned = 1;
                ai.is_boss = true;
                level.panzer_boss = ai;
                level.panzer_boss.is_boss = true;
                wait 1;
                foreach(player in level.players)
                {
                    player thread healthBarBoss();
                }
                wait 3;

                for (;;)
                {
                    if (level.intermission == 1)
                    {
                        return;
                    }
                    if (!isdefined(level.panzer_boss))
                    {
                        if (level.gamemode_difficulty == "^6GigaChad^7")
                            setDvar("EE_Completion", "PiA_Final_GigaChad");  
                        else if (level.gamemode_difficulty == "^1Chad^7")
                            setDvar("EE_Completion", "PiA_Final_Chad");   
                        else    
                            setDvar("EE_Completion", "PiA_Final");
                        for (i = 0; i < 5; i++)
                        {
                            self playsound("zmb_cha_ching");
                            wait 0.5;
                        }
                        level notify("stop_trap");
                        foreach(player in level.players)
                        {
                            player thread FinalMsg();
                        }
                        return;
                    }
                    wait 1;
                }
            }
/*
        origin = (10463.8, -8036.59, -419.875);
        origin = ;
        origin = ;
        origin = ;
        origin = ;
        origin = ;
        origin = ;
        origin = ;
*/
            if (wave == 1  && level.gamemode_difficulty == "^6GigaChad^7")
            {
                circle_spawn_a = [];
                circle_spawn_a[circle_spawn_a.size] = (10463.8, -8036.59, -419.875);
                circle_spawn_a[circle_spawn_a.size] = (10216, -7776.28, -419.875);
                circle_spawn_a[circle_spawn_a.size] = (10212.8, -8044.76, -419.875);
                circle_spawn_a[circle_spawn_a.size] = (10472.6, -7778.6, -419.875);
                circle_spawn_a[circle_spawn_a.size] = (10157.3, -7916.38, -419.875);
                circle_spawn_a[circle_spawn_a.size] = (10513.7, -7888.41, -419.875);
                circle_spawn_a[circle_spawn_a.size] = (10329.6, -7718.96, -419.875);
                circle_spawn_a[circle_spawn_a.size] = (10344.7, -8093.75, -419.875);

                wait 10;
                for (i = 0; i < 8; i++)
                {
                    level.is_miniboss = 1;
                    ai = spawn_zombie( level.mechz_spawners[0] );
                    ai.custom_origin = circle_spawn_a[i];
                    ai thread mechz_spawn();
                    wait 0.05;
                }
            }
            else if (wave == 10 && level.gamemode_difficulty == "^6GigaChad^7")
            {
                for (i = 0; i < 4; i++)
                {
                    level.is_midboss = 1;
                    ai = spawn_zombie( level.mechz_spawners[0] );
                    ai thread mechz_spawn();
                    wait 0.1;
                }
            }
            else if (wave == 14 && level.gamemode_difficulty == "^6GigaChad^7")
            {
                for (i = 0; i < 4; i++)
                {
                    level.is_midboss = 1;
                    ai = spawn_zombie( level.mechz_spawners[0] );
                    ai thread mechz_spawn();
                    wait 0.1;
                }
            }
            else if (wave == 19 && level.gamemode_difficulty == "^6GigaChad^7")
            {
                for (i = 0; i < 5; i++)
                {
                    level.is_midboss = 1;
                    ai = spawn_zombie( level.mechz_spawners[0] );
                    ai thread mechz_spawn();
                    wait 0.1;
                }
            }
            else
            {
                for (i = 0; i < int((wave * level.wave_modifier) + 1 + level.extra_panzer); i++)
                {
                    level.panzer_hp += level.panzer_hp_increase;       
                    for (;;)
                    {
                        zombies = getaispeciesarray( "axis", "all" );
                        if (level.gamemode_difficulty == "^6GigaChad^7")
                        {
                            if (zombies.size < 30)
                                break;
                        }
                        else
                        {
                            if (zombies.size < 18)
                                break;
                        }

                        wait 1;
                    }
                    delay -= 0.2;
                    if (delay < 0.4)
                        delay = 0.4;
                    if(level.gamemode_difficulty == "^6GigaChad^7" && miniboss_count < 4 && (wave < 15 - early_drop || wave >= 18) )
                    {
                        level.is_miniboss = 1;
                        miniboss_count++;
                    }

                    
                    ai = spawn_zombie( level.mechz_spawners[0] );
                    ai thread mechz_spawn();
                    wait delay;
                }
            }

        }
        wait 5;
    }
}

healthBarBoss()
{
    level endon("end_game");
    self endon("disconnect");

    boss_bar = self createprimaryprogressbar();
    boss_bar setpoint(undefined, "TOP", 0, -10);
    boss_bar.bar.color = (0, 1, 0);

    boss_bar.hidewheninmenu = 1;
    boss_bar.bar.hidewheninmenu = 1;
    boss_bar.barframe.hidewheninmenu = 1;

    boss_name_text = createprimaryprogressbartext();
    
    boss_health_text = createprimaryprogressbartext();

    boss_name_text setpoint(undefined, "TOP", 0, -25);

    boss_health_text setpoint(undefined, "TOP", 0, -10);

    boss_name_text.fontscale = 1.5;
    if (level.gamemode_difficulty == "^1Chad^7")
        boss_name_text settext("^1Panzer Ultimis");
    else
        boss_name_text settext("^1Panzer Primis");
    //boss_bar_text setvalue(self.health);

    boss_health_text.hidewheninmenu = 1;
    while (1)
    {
        if (!level.panzer_boss.health)
        {
            boss_bar.barframe destroy();
            boss_bar.bar destroy();
            boss_bar destroy();
            boss_name_text destroy();
            boss_health_text destroy();
            return;
        }
        if (level.panzer_boss.health / level.panzer_boss.maxhealth > 0.5)
        {
            boss_bar.bar.color = ( level.panzer_boss.maxhealth / level.panzer_boss.health - 1, 1, 0 );
        }

        if (level.panzer_boss.health / level.panzer_boss.maxhealth == 0.5)
        {
            boss_bar.bar.color = ( 1, 1, 0 );
        }
        
        if (level.panzer_boss.health / level.panzer_boss.maxhealth < 0.5)
        {
            boss_bar.bar.color = ( 1, (level.panzer_boss.health / level.panzer_boss.maxhealth) * 2, 0 );
        }

        if (level.panzer_boss.health == 0)
        {
            return;
        }

        boss_bar updatebar(level.panzer_boss.health / level.panzer_boss.maxhealth);
        if (isdefined(level.boss_invu) && level.boss_invu == 1)
        {
            boss_bar.bar.color = ( 1, 1, 1 );
        }
        boss_health_text setvalue(level.panzer_boss.health);
        wait 0.3;
    }
}

cycle_trap()
{
    level endon("game_ended");
    level endon("stop_trap");
    a_walls = getentarray( "chamber_wall", "script_noteworthy" );

    for (;;)
    {
        foreach ( e_wall in a_walls )
        {
            e_wall thread move_wall_up();
        }
        level.is_trap_down = 0;
        wait 20;
        setDvar("ln", "^1WARNING !");
        wait 3;
        foreach ( e_wall in a_walls )
        {
            e_wall thread move_wall_down();
        }
        level.is_trap_down = 1;
        wait 2.5;
        level thread get_trapped_players();
        wait 15;
    }
}

cycle_trap_boss()
{
    level endon("game_ended");
    level endon("stop_trap");
    a_walls = getentarray( "chamber_wall", "script_noteworthy" );

    for (;;)
    {
        level.is_trap_down = 0;
        setDvar("ln", "^1WARNING !");
        wait 5;
        foreach ( e_wall in a_walls )
        {
            e_wall thread move_wall_down();
        }
        level.is_trap_down = 1;
        wait 1.5;
        level thread get_trapped_players();
        foreach ( e_wall in a_walls )
        {
            e_wall thread move_wall_up();
        }
        wait 30;
    }
}

get_trapped_players()
{
    level endon ("game_ended");
    setdvar( "player_lastStandBleedoutTime", "0" );
    wait 0.1;
    foreach(player in level.players)
    {
        dist = distancesquared(level.centerRadiusOrigin, player.origin);
        if (dist < 300000 && player.ignoreme != true)
        {
            player iprintln("^3[ " + level.boss_name + " ]^7 : ^3Looks like I caught some rats !");
            player.dying_wish_on_cooldown = 1;
			player.perk10back.alpha = 0;
			player.perk10front.alpha = 0;
            player.bleedout_time = 0;
            player dodamage( player.health + 666, player.origin );
        }
    }
    wait 2;
    setdvar( "player_lastStandBleedoutTime", "45" );
}

LoopEESong()
{
    level endon ("game_ended");
    for (;;)
    {
        level thread PlayEESong("mus_zmb_secret_song_a7x");
        wait 352;

        wait 30;
        level thread PlayEESong("mus_zmb_secret_song");
        wait 310;

        wait 30;
        level thread PlayEESong("mus_zmb_secret_song_aether");
        wait 135;
    }
}

PlayEESong(song)
{
    level endon ("game_ended");
    level.music_override = 1;
    playsoundatposition( song, ( 0, 0, 0 ) );
    wait 140;
    level.music_override = 0;
}

CheckPoint(i)
{
    self endon("disconnect");
    level endon ("game_ended");
    self.origin = (10000, 10000, 10000 + 100 * i);
    self [[ level.spawnplayer ]]();
    wait 0.1;
    self thread TpToPillars(i);
    self TakeAllWeapons();
}

TpToCenter(id)
{
    level endon ("game_ended");
    self endon("disconnect");

    if (id == 0)
    {
        origin = (10463.8, -8036.59, -419.875);
        angle =  (0, 135, 0);
        self setOrigin(origin);
        self SetPlayerAngles(angle);
    }
    else if (id == 1)
    {
        origin = (10216, -7776.28, -419.875);
        angle = (0, 315, 0);
        self setOrigin(origin);
        self SetPlayerAngles(angle);
    }
    else if (id == 2)
    {
        origin = (10212.8, -8044.76, -419.875);
        angle = (0, 45, 0);
        self setOrigin(origin);
        self SetPlayerAngles(angle);
    }
    else if (id == 3)
    {
        origin = (10472.6, -7778.6, -419.875);
        angle = (0, 225, 0);
        self setOrigin(origin);
        self SetPlayerAngles(angle);
    }
    else if (id == 4)
    {
        origin = (10157.3, -7916.38, -419.875);
        angle = (0, 0, 0);
        self setOrigin(origin);
        self SetPlayerAngles(angle);
    }
    else if (id == 5)
    {
        origin = (10513.7, -7888.41, -419.875);
        angle = (0, 185, 0);
        self setOrigin(origin);
        self SetPlayerAngles(angle);
    }
    else if (id == 6)
    {
        origin = (10329.6, -7718.96, -419.875);
        angle = (0, 271.171, 0);
        self setOrigin(origin);
        self SetPlayerAngles(angle);
    }
    else if (id == 7)
    {
        origin = (10344.7, -8093.75, -419.875);
        angle = (0, 92.3129, 0);
        self setOrigin(origin);
        self SetPlayerAngles(angle);
    }

    self noclip();
    wait 0.1;
    self FreezeControls(0);
    wait 3;
    tag = strTok(self.name, "]");
    if (!isdefined(self.got_dw) && (tag[1] == "^6[VIP" || tag[1] == "[^6VIP^7" || tag[1] == "^1[VIP" || tag[1] == "[^1VIP^7" || tag[1] == "[^2VIP^7") )
    {
        self iprintln("Enjoy a ^3nice^7 little ^5refreshing drink ! ^6<3 u perma vip's");
        self thread scripts\AATs_Perks::drawshader_and_shadermove( "Dying_Wish", 1, 1, "custom" );
        self.got_dw = 1;
    }
}

TpToElements(id)
{
    level endon ("game_ended");
    self endon("disconnect");

    wait 5;
    if (id == 0)
    {
        origin = level.fireRadiusOrigin + (0, -50, 0);
        angle =  (0, 135, 0);
        self setOrigin(origin);
        self SetPlayerAngles(angle);
    }
    else if (id == 1)
    {
        origin = level.fireRadiusOrigin + (0, 50, 0);
        angle = (0, 315, 0);
        self setOrigin(origin);
        self SetPlayerAngles(angle);
    }
    else if (id == 2)
    {
        origin = level.iceRadiusOrigin + (0, -50, 0);
        angle = (0, 45, 0);
        self setOrigin(origin);
        self SetPlayerAngles(angle);
    }
    else if (id == 3)
    {
        origin = level.iceRadiusOrigin + (0, 50, 0);
        angle = (0, 225, 0);
        self setOrigin(origin);
        self SetPlayerAngles(angle);
    }
    else if (id == 4)
    {
        origin = level.lightningRadiusOrigin + (0, -50, 0);
        angle = (0, 0, 0);
        self setOrigin(origin);
        self SetPlayerAngles(angle);
    }
    else if (id == 5)
    {
        origin = level.lightningRadiusOrigin + (0, 50, 0);
        angle = (0, 185, 0);
        self setOrigin(origin);
        self SetPlayerAngles(angle);
    }
    else if (id == 6)
    {
        origin = level.windRadiusOrigin + (0, -50, 0);
        angle = (0, 271.171, 0);
        self setOrigin(origin);
        self SetPlayerAngles(angle);
    }
    else if (id == 7)
    {
        origin = level.windRadiusOrigin + (0, 50, 0);
        angle = (0, 92.3129, 0);
        self setOrigin(origin);
        self SetPlayerAngles(angle);
    }

    self noclip();
    self FreezeControls(0);

    wait 3;
    tag = strTok(self.name, "]");
}

TpToPillars(id)
{
    level endon ("game_ended");
    self endon("disconnect");

    self TakeAllWeapons();
    wait 0.1;
    lock = 0;
   /* for (;;)
    {
        if (isdefined(level.difficulty_selected) && level.difficulty_selected == 1)
            break;
        wait 0.5;
    }*/
    foreach(guid in level.premium_pass_guid_list)
    {
        if (self getguid() == guid)
        {
            weapon_loadout = self GetWeaponsListPrimaries();
            if (weapon_loadout.size >= 2)
                self TakeWeapon(self GetCurrentWeapon());
            weapon_loadout = self GetWeaponsListPrimaries();
            if (weapon_loadout.size >= 2)
                self TakeWeapon(self GetCurrentWeapon());   
            self thread give_weapon();
            lock = 1;   
        }
    }
    foreach(guid in level.premium_pass_guid_list2)
    {
        if (self getguid() == guid)
        {
            weapon_loadout = self GetWeaponsListPrimaries();
            if (weapon_loadout.size >= 2)
                self TakeWeapon(self GetCurrentWeapon());
            weapon_loadout = self GetWeaponsListPrimaries();
            if (weapon_loadout.size >= 2)
                self TakeWeapon(self GetCurrentWeapon());   
            self thread give_weapon();
            lock = 1;   
        }
    }
    if (id == level.staff_player_id)
    {
                weapon_loadout = self GetWeaponsListPrimaries();
                if (weapon_loadout.size >= 2)
                    self TakeWeapon(self GetCurrentWeapon());
        level.staff_player_id = -1;
            weapon_loadout = self GetWeaponsListPrimaries();
            if (weapon_loadout.size >= 2)
                self TakeWeapon(self GetCurrentWeapon());   
        self GiveWeapon("staff_lightning_zm");
        self SwitchToWeapon("staff_lightning_zm");
        self iPrintln("You can feel the ^5Agarthan power^7 running through your veins");
    }
    else
    {
        if (lock == 0)
        {
            group = 0;
            tag = strTok(self.name, "]");
            if (tag[0] == "[^1IIX^7]" || tag[0] == "[^1IX^7]" || tag[0] == "[^1-X-^7]" || tag[0] == "[^5VI^7" || tag[0] == "[^5VII^7" || tag[1] == "[^3VIP^7" || tag[1] == "^3[VIP" || tag[1] == "^6[VIP" || tag[1] == "[^6VIP^7" || tag[1] == "^1[VIP" || tag[1] == "[^1VIP^7" || tag[1] == "[^2VIP^7")
            {
                group = 1;
            }
            else if (tag[0] == "[^6I^7" || tag[0] == "[^6II^7" || tag[0] == "[^6III^7" || tag[0] == "[^5IV^7" || tag[0] == "[^5V^7")
            {
                group = 2;
            }

            if (group == 1)
            {
                weapon_loadout = self GetWeaponsListPrimaries();
                if (weapon_loadout.size >= 2)
                    self TakeWeapon(self GetCurrentWeapon());   
                self GiveWeapon("type95_zm");
                self SwitchToWeapon("type95_zm");
            }
            else if (group == 2)
            {
                weapon_loadout = self GetWeaponsListPrimaries();
                if (weapon_loadout.size >= 2)
                    self TakeWeapon(self GetCurrentWeapon());   
                self GiveWeapon("ak74u_extclip_zm");
                self SwitchToWeapon("ak74u_extclip_zm");
            }
            else
            {
                weapon_loadout = self GetWeaponsListPrimaries();
                if (weapon_loadout.size >= 2)
                    self TakeWeapon(self GetCurrentWeapon());   
                self GiveWeapon("beretta93r_zm");
                self SwitchToWeapon("beretta93r_zm");
            }
        }
    }

    angle = (3.12681, 134.879, 0);
    origin = (10576.5, -8142.22, -193.506);
    if (id == 0)
    {
        angle = (3.12681, 134.879, 0);
        origin = (10576.5, -8142.22, -193.506);
    }
    else if (id == 1)
    {
        angle = (0.372314, 315.209, 0);
        origin = (10106, -7674.86, -194.791);
    }
    else if (id == 2)
    {
        angle = (2.09717, 43.9728, 0);
        origin = (10105.2, -8138.72, -194.33);
    }
    else if (id == 3)
    {
        angle = (359.307, 224.973, 0);
        origin = (10576.7, -7668.97, -194.667);
    }
    else if (id == 4)
    {
        origin = (10811.9,-7851.14, -356.405);
        angle =  (0, 185, 0);
    }
    else if (id == 5)
    {
        origin = (9874.12, -7907.39, -334.706);
        angle = (0, 359.714, 0);
    }
    else if (id == 6)
    {
        origin = (10260.6, -7356.09, -367.117);
        angle = (0, 277.85, 0);
    }
    else if (id == 7)
    {
        origin = (10437, -8262.72, -355.361);
        angle = (0, 103.859, 0);
    }
    a_s_teleporters = getstructarray( "trigger_teleport_pad", "targetname" );
    stargate_teleport_player( a_s_teleporters[0].target, self);
    self SetOrigin(origin);
    self SetPlayerAngles(angle);
    self SetMoveSpeedScale(1.05);
    self FreezeControls(1);
    self noclip();
    wait 0.2;
    if (level.final_wave == 1)
    {
        if (level.is_trap_down == 1)
            self thread TpToElements(id);
        else
            self thread TpToCenter(id);
        return;   
    }
    wait 2;
    if (level.game_started == 0)
    {
        self thread difficulty_selector();
    }
    else
    {
        self iprintln("^3[ ^2Kiels^3 ]^7 : It is ^3too soon^7 for you to die, ^5get ready soldier");
        wait 5;
        if (level.is_trap_down == 1)
            self thread TpToElements(id);
        else
            self thread TpToCenter(id);
    }
}

give_weapon()
{
    for (;;)
    {
        if (isdefined(level.difficulty_selected) && level.difficulty_selected == 1)
            break;
        wait 0.5;
    }
    if (level.gamemode_difficulty == "^6GigaChad^7")
    {
        self giveweapon("mp44_upgraded_zm", 0, self maps\mp\zombies\_zm_weapons::get_pack_a_punch_weapon_options( "mp44_upgraded_zm" ) );
        self SwitchToWeapon("mp44_upgraded_zm");  
    }
    else
    {
        self giveweapon("mp44_upgraded_zm", 0, self maps\mp\zombies\_zm_weapons::get_pack_a_punch_weapon_options( "mp44_upgraded_zm" ) );
        self SwitchToWeapon("mp44_upgraded_zm");
    }
}

death_cleanup()
{
    self waittill("death");
    wait 1;
    self.staff_m delete();
    self.staff_u delete();
    self.fx delete();

    if (isdefined(self.fx2))
        self.fx2 delete();
    if (isdefined(self.staff_m2))
        self.staff_m2 delete();
    if (isdefined(self.staff_u2))
        self.staff_u2 delete();
}

mechz_spawn_custom()
{
    self endon("disconnect");
    level endon ("game_ended");
    self endon( "death" );
    level endon( "intermission" );    

    if (getdvar("net_port") == "30010")
    {
        self.not_interruptable = 1;
        self mechz_attach_objects();
        self mechz_set_starting_health();
        self mechz_setup_fx();
        self mechz_setup_snd();
        level notify( "sam_clue_mechz", self );
        
        self.closest_player_override = ::get_favorite_enemy_custom2;
        self.animname = "mechz_zombie";
        self.maxhealth = level.panzer_hp;
        self.health = self.maxhealth;

        if (level.is_midboss == 1)
        {
            self.is_midboss = 1;
            self.maxhealth = level.panzer_hp * 6;
            self.health = self.maxhealth;
            rnd = randomint(4);
            if (rnd == 0)
            {
                model_m = "t6_wpn_zmb_staff_stem_bolt_part";
                model_u = "t6_wpn_zmb_staff_tip_lightning_world";
                model_fx = level._effect["elec_glow"];
                self thread miniboss_lightning_think(1);
            }
            else if (rnd == 1)
            {
                model_m = "t6_wpn_zmb_staff_stem_air_part";
                model_u = "t6_wpn_zmb_staff_tip_air_world";
                model_fx = level._effect["air_glow"];  
                self thread miniboss_wind_think(1); 
            }
            else if (rnd == 2)
            {
                model_m = "t6_wpn_zmb_staff_stem_water_part";
                model_u = "t6_wpn_zmb_staff_tip_water_world";
                model_fx = level._effect["ice_glow"];   
                self thread miniboss_ice_think(1); 
            }
            else if (rnd == 3)
            {
                model_m = "t6_wpn_zmb_staff_stem_fire_part";
                model_u = "t6_wpn_zmb_staff_tip_fire_world";
                model_fx = level._effect["fire_glow"];
                self thread miniboss_fire_think(1);
            }
            for(;;)
            {
                rnd2 = randomint(4);
                if (rnd2 == rnd)
                    continue;
                break;
            }
            if (rnd2 == 0)
            {
                model_m2 = "t6_wpn_zmb_staff_stem_bolt_part";
                model_u2 = "t6_wpn_zmb_staff_tip_lightning_world";
                model_fx2 = level._effect["elec_glow"];
                self thread miniboss_lightning_think(1);
            }
            else if (rnd2 == 1)
            {
                model_m2 = "t6_wpn_zmb_staff_stem_air_part";
                model_u2 = "t6_wpn_zmb_staff_tip_air_world";
                model_fx2 = level._effect["air_glow"];  
                self thread miniboss_wind_think(1); 
            }
            else if (rnd2 == 2)
            {
                model_m2 = "t6_wpn_zmb_staff_stem_water_part";
                model_u2 = "t6_wpn_zmb_staff_tip_water_world";
                model_fx2 = level._effect["ice_glow"];   
                self thread miniboss_ice_think(1); 
            }
            else if (rnd2 == 3)
            {
                model_m2 = "t6_wpn_zmb_staff_stem_fire_part";
                model_u2 = "t6_wpn_zmb_staff_tip_fire_world";
                model_fx2 = level._effect["fire_glow"];
                self thread miniboss_fire_think(1);
            }

            level.is_midboss = 0;
            self.staff_m = spawn( "script_model", self.origin );
            self.staff_m linkto( self, "J_SpineLower", (45, -15, 4), (-15, 0, 0));
            wait 0.1;
            self.staff_m setmodel( model_m );  

            self.staff_u = spawn( "script_model", self.origin );
            self.staff_u linkto( self, "J_SpineLower", (80, -15, 15), (0, 90, 70));
            wait 0.1;
            self.staff_u setmodel( model_u ); 


            self.fx = spawn( "script_model", self.staff_u.origin );
            wait 0.1;
            self.fx setmodel( "tag_origin" );
            playfxontag( model_fx, self.staff_u, "tag_origin" );
            self.fx linkto( self, "J_SpineLower", self.staff_u.origin, (0, 0, 0));

            self.staff_m2 = spawn( "script_model", self.origin );
            self.staff_m2 linkto( self, "J_SpineLower", (45, -15, -4), (15, 0, 0));
            wait 0.1;
            self.staff_m2 setmodel( model_m2 );  

            self.staff_u2 = spawn( "script_model", self.origin );
            self.staff_u2 linkto( self, "J_SpineLower", (80, -15, -15), (0, 90, 110));
            wait 0.1;
            self.staff_u2 setmodel( model_u2 ); 


            self.fx2 = spawn( "script_model", self.staff_u2.origin );
            wait 0.1;
            self.fx2 setmodel( "tag_origin" );
            playfxontag( model_fx2, self.staff_u2, "tag_origin" );
            self.fx2 linkto( self, "J_SpineLower", self.staff_u2.origin, (0, 0, 0));
            self thread death_cleanup();

        }
        if (level.is_miniboss == 1)
        {
            self.maxhealth = level.panzer_hp * 2;
            self.health = self.maxhealth;
            level.is_miniboss = 0;
            self.staff_m = spawn( "script_model", self.origin );
            self.staff_m linkto( self, "J_SpineLower", (40, -15, 0), (0, 0, 0));
            
            r = randomint(4);
            if (r == 0)
            {
                model_m = "t6_wpn_zmb_staff_stem_bolt_part";
                model_u = "t6_wpn_zmb_staff_tip_lightning_world";
                model_fx = level._effect["elec_glow"];
                self thread miniboss_lightning_think(0);
            }
            else if (r == 1)
            {
                model_m = "t6_wpn_zmb_staff_stem_air_part";
                model_u = "t6_wpn_zmb_staff_tip_air_world";
                model_fx = level._effect["air_glow"];  
                self thread miniboss_wind_think(0); 
            }
            else if (r == 2)
            {
                model_m = "t6_wpn_zmb_staff_stem_water_part";
                model_u = "t6_wpn_zmb_staff_tip_water_world";
                model_fx = level._effect["ice_glow"];   
                self thread miniboss_ice_think(0); 
            }
            else if (r == 3)
            {
                model_m = "t6_wpn_zmb_staff_stem_fire_part";
                model_u = "t6_wpn_zmb_staff_tip_fire_world";
                model_fx = level._effect["fire_glow"];
                self thread miniboss_fire_think(0);
            }
            self.staff_m setmodel( model_m );    
            self.staff_u = spawn( "script_model", self.origin );
            self.staff_u linkto( self, "J_SpineLower", (65, -15, 0), (0, 90, 90));
            self.staff_u setmodel( model_u ); 

            self.fx = spawn( "script_model", self.staff_u.origin );
            wait 0.1;
            self.fx setmodel( "tag_origin" );
            playfxontag( model_fx, self.staff_u, "tag_origin" );
            self.fx linkto( self, "J_SpineLower", self.staff_u.origin, (0, 0, 0));
            self thread death_cleanup();
        }
        if (level.final_wave == 1 && !(isdefined(level.boss_spawned)))
        {
                self.maxhealth = 666666;
            if (level.gamemode_difficulty == "^1Chad^7")
                self.maxhealth = 999999;
            if (level.gamemode_difficulty == "^6GigaChad^7")
                self.maxhealth = 1200000;
            self.health = self.maxhealth;
            self.staff_lightning_m = spawn( "script_model", self.origin );
            self.staff_lightning_m linkto( self, "J_SpineLower", (40, -15, -7), (45, 0, 0));
            self.staff_lightning_m setmodel( "t6_wpn_zmb_staff_stem_bolt_part" );        

            self.staff_wind_m = spawn( "script_model", self.origin );
            self.staff_wind_m linkto( self, "J_SpineLower", (40, -15, 7), (-45, 0, 0));
            self.staff_wind_m setmodel( "t6_wpn_zmb_staff_stem_air_part" ); 

            self.staff_ice_m = spawn( "script_model", self.origin );
            self.staff_ice_m linkto( self, "J_SpineLower", (45, -15, 2), (-15, 0, 0));
            self.staff_ice_m setmodel( "t6_wpn_zmb_staff_stem_water_part" );  

            self.staff_fire_m = spawn( "script_model", self.origin );
            self.staff_fire_m linkto( self, "J_SpineLower", (45, -15, -2), (15, 0, 0));
            self.staff_fire_m setmodel( "t6_wpn_zmb_staff_stem_fire_part" );  

            self.elem_fx = spawn( "script_model", self.origin );
            self.elem_fx linkto( self, "J_SpineLower", (0, 0, 0), (0, 0, 0));
            self.elem_fx setmodel( "t6_wpn_zmb_staff_tip_air_world" );

            self.staff_lightning_u = spawn( "script_model", self.origin );
            self.staff_lightning_u linkto( self, "J_SpineLower", (65, -15, -36), (0, 90, 135));
            self.staff_lightning_u setmodel( "t6_wpn_zmb_staff_tip_lightning_world" ); 

            self.staff_wind_u = spawn( "script_model", self.origin );
            self.staff_wind_u linkto( self, "J_SpineLower", (65, -15, 36), (0, 90, 45));
            self.staff_wind_u setmodel( "t6_wpn_zmb_staff_tip_air_world" );

            self.staff_ice_u = spawn( "script_model", self.origin );
            self.staff_ice_u linkto( self, "J_SpineLower", (80, -15, 12), (0, 90, 70));
            self.staff_ice_u setmodel( "t6_wpn_zmb_staff_tip_water_world" );   

            self.staff_fire_u = spawn( "script_model", self.origin );
            self.staff_fire_u linkto( self, "J_SpineLower", (80, -15, -12), (0, 90, 110));
            self.staff_fire_u setmodel( "t6_wpn_zmb_staff_tip_fire_world" );    






            self.fire_fx = spawn( "script_model", self.staff_lightning_u.origin );
            self.fire_fx.angles = self.staff_lightning_u.angles;
            self.fire_fx setmodel( "tag_origin" );
            playfxontag( level._effect["fire_glow"], self.staff_fire_u, "tag_origin" );
            self.fire_fx linkto( self, "J_SpineLower", self.staff_fire_u.origin, (0, 0, 0));

            self.ice_fx = spawn( "script_model", self.staff_ice_u.origin );
            self.ice_fx.angles = self.staff_lightning_u.angles;
            self.ice_fx setmodel( "tag_origin" );
            playfxontag( level._effect["ice_glow"], self.staff_ice_u, "tag_origin" );
            self.ice_fx linkto( self, "J_SpineLower", self.staff_ice_u.origin, (0, 0, 0));

            self.lightning_fx = spawn( "script_model", self.staff_lightning_u.origin );
            self.lightning_fx.angles = self.staff_lightning_u.angles;
            self.lightning_fx setmodel( "tag_origin" );
            playfxontag( level._effect["elec_glow"], self.staff_lightning_u, "tag_origin" );
            self.lightning_fx linkto( self, "J_SpineLower", self.staff_lightning_u.origin, (0, 0, 0));

            self.wind_fx = spawn( "script_model", self.staff_wind_u.origin );
            self.wind_fx.angles = self.staff_wind_u.angles;
            self.wind_fx setmodel( "tag_origin" );
            playfxontag( level._effect["air_glow"], self.staff_wind_u, "tag_origin" );
            self.wind_fx linkto( self, "J_SpineLower", self.staff_wind_u.origin, (0, 0, 0));

            level thread boss_think();
        }
        if (level.panzer_helmet_on == 0)
            self detach( "c_zom_mech_faceplate", "J_Helmet" );
        self.has_legs = 1;
        self.no_gib = 1;
        self.ignore_all_poi = 1;
        self.is_mechz = 1;
        self.ignore_enemy_count = 1;
        self.no_damage_points = 1;
        self.melee_anim_func = ::melee_anim_func;
        self.meleedamage = 350;
        if (level.gamemode_difficulty == "^1Chad^7")
        {
            self.meleedamage = 475;
        }
        if (level.gamemode_difficulty == "^6GigaChad^7")
        {
            self.meleedamage = 475;
        }
        self.custom_item_dmg = 6000;
        recalc_zombie_array();
        self setphysparams( 20, 0, 80 );
        self setcandamage( 0 );
        self.zombie_init_done = 1;
        self notify( "zombie_init_done" );
        self.allowpain = 0;
        self animmode( "normal" );
        self orientmode( "face enemy" );
        self maps\mp\zombies\_zm_spawner::zombie_setup_attack_properties();
        self.completed_emerging_into_playable_area = 1;
        self notify( "completed_emerging_into_playable_area" );
        self.no_powerups = 0;
        self setfreecameralockonallowed( 0 );
   //     self notsolid();

        self thread maps\mp\zombies\_zm_spawner::zombie_eye_glow();
        level thread maps\mp\zombies\_zm_spawner::zombie_death_event( self );
        self thread maps\mp\zombies\_zm_spawner::enemy_death_detection();
        origin = (10314.5, -7889.91, -411.875);
        x = randomintrange(0, 6);
        for (;;)
        {
            if (getdvar("panzer_trap") == "1" && (x == 0 || x == 5))
            {
                x = randomintrange(0, 6);
            }
            else
            {
                break;
            }
            wait 0.1;
        }
        if (x == 0)
            origin = (10314.5, -7889.91, -411.875);
        else if (x == 1)
            origin = (11245.4, -8653.65, -407.875);      
        else if (x == 2)
            origin = (9466.23, -8550.97, -397.875);   
        else if (x == 3)
            origin = (9627.23, -7010.64, -345.875);   
        else if (x == 4)
            origin = (11199.2, -7047.59, -345.875);  
        else if (x == 5)
            origin = (10314.5, -7889.91, -411.875); 

        if (isdefined(self.custom_origin))
            origin = self.custom_origin;
        angles = ( 0, 0, 0 );
                      
        self thread mechz_death();
        self forceteleport(origin, angles );
        self playsound( "zmb_ai_mechz_incoming_alarm" );

        self animscripted( origin, angles, "zm_spawn" );
        self maps\mp\animscripts\zm_shared::donotetracks( "jump_anim" );
        self setfreecameralockonallowed( 1 );
     //   self solid();
        if (getDvar("panzer_run") == "1" || (isdefined(level.is_miniboss) && level.is_miniboss == 1))
            self set_zombie_run_cycle( "run" );
        else 
            self set_zombie_run_cycle( "walk" );


        if ( isdefined( level.mechz_find_flesh_override_func ) )
            level thread [[ level.mechz_find_flesh_override_func ]]();
        else
            self thread mechz_find_flesh_custom();

        self thread mechz_jump_think( spawn_pos );
        self init_anim_rate();
        self.not_interruptable = 0;
        self thread PanzerDeathWatcher();
        self notify("spawned");
        wait 1;
        self setcandamage( 1 );
    }
    else
    {
        self maps\mp\zombies\_zm_ai_mechz_ffotd::spawn_start();
        self endon( "death" );
        level endon( "intermission" );
        self mechz_attach_objects();
        self mechz_set_starting_health();
        self mechz_setup_fx();
        self mechz_setup_snd();
        level notify( "sam_clue_mechz", self );
        self.closest_player_override = maps\mp\zombies\_zm_ai_mechz::get_favorite_enemy;
        self.animname = "mechz_zombie";
        self.has_legs = 1;
        self.no_gib = 1;
        self.ignore_all_poi = 1;
        self.is_mechz = 1;
        self.ignore_enemy_count = 1;
        self.no_damage_points = 1;
        self.melee_anim_func = ::melee_anim_func;
        self.meleedamage = 75;
        self.custom_item_dmg = 2000;
        recalc_zombie_array();
        self setphysparams( 20, 0, 80 );
        self setcandamage( 0 );
        self.zombie_init_done = 1;
        self notify( "zombie_init_done" );
        self.allowpain = 0;
        self animmode( "normal" );
        self orientmode( "face enemy" );
        self maps\mp\zombies\_zm_spawner::zombie_setup_attack_properties();
        self.completed_emerging_into_playable_area = 1;
        self notify( "completed_emerging_into_playable_area" );
        self.no_powerups = 0;
        self setfreecameralockonallowed( 0 );
        self notsolid();
        self thread maps\mp\zombies\_zm_spawner::zombie_eye_glow();
        level thread maps\mp\zombies\_zm_spawner::zombie_death_event( self );
        self thread maps\mp\zombies\_zm_spawner::enemy_death_detection();

        if ( level.zombie_mechz_locations.size )
            spawn_pos = self get_best_mechz_spawn_pos();

        if ( !isdefined( spawn_pos ) )
        {
    /#
            println( "ERROR: Tried to spawn mechz with no mechz spawn_positions!\\n" );
            iprintln( "ERROR: Tried to spawn mechz with no mechz spawn_positions!" );
    #/
            self delete();
            return;
        }

        if ( isdefined( level.mechz_force_spawn_pos ) )
        {
            spawn_pos = level.mechz_force_spawn_pos;
            level.mechz_force_spawn_pos = undefined;
        }

        if ( !isdefined( spawn_pos.angles ) )
            spawn_pos.angles = ( 0, 0, 0 );

        self thread mechz_death();
        self forceteleport( spawn_pos.origin, spawn_pos.angles );
        self playsound( "zmb_ai_mechz_incoming_alarm" );

        if ( !isdefined( spawn_pos.angles ) )
            spawn_pos.angles = ( 0, 0, 0 );

        self animscripted( spawn_pos.origin, spawn_pos.angles, "zm_spawn" );
        self maps\mp\animscripts\zm_shared::donotetracks( "jump_anim" );
        self setfreecameralockonallowed( 1 );
        self solid();
        self set_zombie_run_cycle( "walk" );

        if ( isdefined( level.mechz_find_flesh_override_func ) )
            level thread [[ level.mechz_find_flesh_override_func ]]();
        else
            self thread mechz_find_flesh();

        self thread mechz_jump_think( spawn_pos );
        self setcandamage( 1 );
        self init_anim_rate();
        self maps\mp\zombies\_zm_ai_mechz_ffotd::spawn_end();
        return;
    }
}

miniboss_ice_think(is_midboss)
{
    level endon ("game_ended");

    self thread miniboss_ice_spawn_mine(is_midboss);
    fx = spawn( "script_model", self.origin);
    fx linkto( self, "J_SpineLower", (0, 0, 0), (90, 0, 0));
    wait .1;
    fx setmodel( "tag_origin" );
    for (;;)
    {
        playfxontag( level._effect["staff_water_blizzard"], fx, "tag_origin" );
        for(i = 0; i < 100; i++)
        {
            if (isdefined(self.is_dead))
            {
                fx delete();
                return;
            }
            wait 0.1;
        }
    }
}

miniboss_lightning_think(is_midboss)
{
    level endon("game_ended");

    self thread miniboss_lightning_spawn_orbs(is_midboss);
}

miniboss_wind_think(is_midboss)
{
    level endon("game_ended");

    angles = self.angles;
    self thread miniboss_tornado(angles, is_midboss);
    wait 0.1;
    self thread miniboss_tornado(angles + (0, 180, 0), is_midboss);
}

miniboss_fire_think(is_midboss)
{
    level endon("game_ended");
    self waittill("spawned");

    for (;;)
    {
        self set_zombie_run_cycle("sprint");
        fx = spawn( "script_model", self.origin);
        wait .1;
        fx linkto( self, "J_SpineLower", (0, 0, -15), (0, 0, 0));
        fx setmodel( "tag_origin" );
        playfxontag( level._effect["fx_tomb_fire_lg"], fx, "tag_origin" );
        for (i = 1; i < 50; i++)
        {
            if (isdefined(self.is_dead))
            {
                fx delete();
                return;
            }
            wait 0.1;
        }
        fx delete();
        playfx( level._effect["biplane_explode"], self.origin);
        foreach(player in level.players)
        {
            if (distancesquared(self.origin, player.origin) < 60000 && player.ignoreme != true)
            {
                player dodamage(666, player.origin);
                direction_forward = anglestoforward( flat_angle( self.angles ) + vectorscale( ( -1, 0, 0 ), 60.0 ) );
                direction_vector = vectorscale( direction_forward, 3000 );
                player yeet_player(player.origin + vectorscale( ( 0, 0, 1 ), 30.0 ), player.angles, direction_vector);
            }
        }
        self set_zombie_run_cycle("run");
        cooldown = 5;
        if(is_midboss)
            cooldown = 2;
        for (i = 1; i < cooldown * 10; i++)
        {
            if (isdefined(self.is_dead))
            {
                fx delete();
                return;
            }
            wait 0.1;
        }

    }
}

yeet_player(origin, angles, velocity)
{
    torigin = ( self.origin[0], self.origin[1], origin[2] );
    aorigin = ( origin + torigin ) * 0.5;
    trace = physicstrace( origin, torigin, vectorscale( ( -1, -1, 0 ), 15.0 ), ( 15, 15, 30 ), self );

    self setorigin( aorigin );
    wait_network_frame();
    self setvelocity( velocity );
}

miniboss_ice_spawn_mine(is_midboss)
{
    level endon("game_ended");

    direction = (0, 0, 0);

    for (i = 0; i < 4; i++)
    {
        self thread miniboss_ice_mine_think(direction, is_midboss);
        direction += (0, 90, 0);
    }
    wait 5;
}

miniboss_ice_mine_think(direction, is_midboss)
{
    self waittill("spawned");

    fx = spawn( "script_model", self.origin);
    wait 0.1;
    fx setmodel( "tag_origin" );
    playfxontag( level._effect["ee_beam"], fx, "tag_origin" );

    if (is_midboss == 1)
        travel_time = 2;
    else 
        travel_time = 3;
    for(;;)
    {
        for (i = 1; i < travel_time * 10; i++)
        {
            if (isdefined(self.is_dead))
            {
                fx delete();
                return;
            }
            offset = vectorscale( anglestoforward(direction), (600 / (travel_time * 10)) * i);
            fx moveto(self.origin + offset, 0.1);
            foreach(player in level.players)
            {
                if (distancesquared(fx.origin, player.origin) < 1700 && player.ignoreme != true)
                    player dodamage(580, player.origin);
            }

            wait 0.1;
        }
        for (i = travel_time * 10; i >= 0; i--)
        {
            if (isdefined(self.is_dead))
            {
                fx delete();
                return;
            }
            offset = vectorscale( anglestoforward(direction), (600 / (travel_time * 10)) * i);
            fx moveto(self.origin + offset, 0.1);
            foreach(player in level.players)
            {
                if (distancesquared(fx.origin, player.origin) < 1700 && player.ignoreme != true)
                    player dodamage(580, player.origin);
            }
            wait 0.1;
        }
    }
}

miniboss_tornado(angles, is_midboss)
{
    level endon("game_ended");
    self waittill("spawned");

    offset = vectorscale( anglestoforward(angles), 400 );
    fx = spawn( "script_model", self.origin + offset + (0, 0, 50));
    wait 0.1;
    fx setmodel( "tag_origin" );
    level thread refresh_tornado_anim(fx);
    
    for (;;)
    {
        if (isdefined(self.is_dead))
        {
            fx delete();
            return;
        }
        foreach(player in level.players)
        {
            if (distancesquared(fx.origin, player.origin) < 30000)
            {
                player shellshock( "explosion", 1 );
                if (is_midboss == 1 && player.ignoreme != true)
                    player dodamage(15, player.origin);
                else if(player.ignoreme != true)
                    player dodamage(10, player.origin);
            }

        }
        if (is_midboss == 1)
            angles += (0, 5.25, 0);
        else
            angles += (0, 3.5, 0);
        offset = vectorscale( anglestoforward(angles), 400 );
        fx moveto(self.origin + offset + (0, 0, 50), 0.1);
        wait 0.1;
    }
    fx delete();
}
//level._effect["ee_beam"] good fx flex
//level._effect["staff_water_blizzard"]
//level._effect["fx_tomb_chamber_glow_blue"]




refresh_tornado_anim(fx)
{
    level endon("game_ended");
    self endon("death");
    for (;;)
    {
        playfxontag( level._effect["whirlwind"], fx, "tag_origin" );
        playfxontag( level._effect["whirlwind"], fx, "tag_origin" );
        wait 10;
    }

}



miniboss_lightning_spawn_orbs(is_midboss)
{
    level endon("game_ended");
    self endon("death");
    self waittill("spawned");

    for(;;)
    {
        self thread shoot_lightning_orb(self.angles, is_midboss);
        wait .05;
        self thread shoot_lightning_orb(self.angles + (0, 30, 0), is_midboss);
        wait .05;
        self thread shoot_lightning_orb(self.angles + (0, -30, 0), is_midboss);
        if (is_midboss)
            wait 1.5;
        else
            wait 2;
    }
}

shoot_lightning_orb(angles, is_midboss)
{
    offset = vectorscale( anglestoforward(angles ), 900 );
    fx = spawn( "script_model", self.origin + (0, 0, 50));
    wait .1;
    fx setmodel( "tag_origin" );
    playfxontag( level._effect["elec_piano_glow"], fx, "tag_origin" );
    if (is_midboss)
        travel_time = 3;
    else
        travel_time = 4;
    fx moveto( self.origin + offset + (0, 0, 50), travel_time);
    for (i = 0; i < travel_time * 10; i++)
    {
        foreach(player in level.players)
        {
            stance = player GetStance();
            player_origin_offset = 0;
            if (stance == "prone")
                player_origin_offset = 30;
            if (distancesquared((fx.origin), (player.origin - (0, 0, player_origin_offset))) < 1700 && player.ignoreme != true)
                player dodamage(580, player.origin);
        }
        wait 0.1;
    }
    fx delete();
}

boss_hp_watcher()
{
    level endon("game_ended");

    delay_multiplier = 1;
    boss_base_attacks_cooldown = 24;
    lock = 0;
    for (;;)
    {
        if (!level.panzer_boss.health)
            return;


        if (lock == 0 && level.panzer_boss.health < ((level.panzer_boss.maxhealth) * 0.75))
        {
            delay_multiplier = 0.9;
            lock = 1;

            if (level.gamemode_difficulty == "^1Chad^7" || level.gamemode_difficulty == "^6GigaChad^7")
            {
                level.boss_invu = 1;
                level.panzer_boss SetCanDamage(0);
                iprintln("^3[ " + level.boss_name + " ]^7 : How about a little ^1company ?");
                if (level.gamemode_difficulty == "^6GigaChad^7")
                    self thread spawn_panzers(10);   
                else 
                    self thread spawn_panzers(9); 
            }
            else
            {
                iprintln("^3[ " + level.boss_name + " ]^7 : Your bullets are ^1barely leaving me scratches");
            }
        }
        if (lock == 1 && level.panzer_boss.health < ((level.panzer_boss.maxhealth) * 0.50))
        {
            delay_multiplier = 0.75;
            lock = 2;

            if (level.gamemode_difficulty == "^1Chad^7" || level.gamemode_difficulty == "^6GigaChad^7")
            {
                level.boss_invu = 1;
                level.panzer_boss SetCanDamage(0);
                iprintln("^3[ " + level.boss_name + " ]^7 : Have it your way.");
                if (level.gamemode_difficulty == "^6GigaChad^7")
                    self thread spawn_panzers(12);   
                else 
                    self thread spawn_panzers(12); 
            }
            else
            {
                iprintln("^3[ " + level.boss_name + " ]^7 : I will show you what the ^1elements are capable of !");
            }
        }
        if ( lock == 2 && level.panzer_boss.health < ((level.panzer_boss.maxhealth) * 0.25))
        {
            delay_multiplier = 0.6;
            lock = 3;

            if (level.gamemode_difficulty == "^1Chad^7")
            {
                iprintln("^3[ " + level.boss_name + " ]^7 : ^1PANZERS !^7 Make them scream !");
                self thread spawn_panzers(6);   
            }
            else
            {
                iprintln("^3[ " + level.boss_name + " ]^7 : ^5Agartha^7 is MY kingdom, ^1I will NOT let you release the ^3girl");
            }
        }
        level.boss_attacks_cooldown = int(boss_base_attacks_cooldown * delay_multiplier);
        wait 1;
    }
}

spawn_panzers(amount)
{
    for (i = 0; i < amount ; i++)
    {
        ai = spawn_zombie( level.mechz_spawners[0] );
        if (level.gamemode_difficulty == "^6GigaChad^7" && i < amount / 2)
            level.is_miniboss = 1;
        ai thread mechz_spawn();
        wait 0.2;
        level.is_miniboss = 0;
    }
    wait 1;
    level thread adds_watcher();
}

adds_watcher()
{
    level endon("game_ended");
    
    for(;;)
    {
        mechz_count = 0;
        zombies = getaiarray(level.zombie_team);
        for ( i = 0; i < zombies.size; i++ )
        {
            if (isdefined(zombies[i].is_mechz))
                mechz_count++;
        }
        if (mechz_count == 1)
        {
            level.boss_invu = 0;
            level.panzer_boss SetCanDamage(1);
            return;
        }
        wait 1;
    }
}

boss_think()
{
    level endon("game_ended");

    wait 9;
    level.boss_attacks_cooldown = 60;
    level thread boss_hp_watcher();
    level.panzer_hook_speed = 2500;
    level thread trap_think();
    for (;;)
    {
        if (!level.panzer_boss || !level.panzer_boss.health || level.panzer_boss.health < 1)
            return;
        level.panzer_boss.elem_fx setclientfield( "element_glow_fx", 3 );
        wait 3;
        level thread do_lightning_attack();
        level.panzer_boss.elem_fx setclientfield( "element_glow_fx", 0 );
        wait level.boss_attacks_cooldown;
        level.panzer_boss.elem_fx setclientfield( "element_glow_fx", 1 );
        wait 3;
        level thread do_fire_attack();
        level.panzer_boss.elem_fx setclientfield( "element_glow_fx", 0 );
        wait level.boss_attacks_cooldown;
        level.panzer_boss.elem_fx setclientfield( "element_glow_fx", 2 );
        wait 3;
        level thread do_wind_attack();
        level.panzer_boss.elem_fx setclientfield( "element_glow_fx", 0 );
        wait level.boss_attacks_cooldown;
    }
}

trap_think()
{
    for (;;)
    {
        if (level.panzer_boss.health < (level.panzer_boss.maxhealth * 0.33))
        {
            level thread cycle_trap_boss();
            return;
        }
        wait 1;
    }

}

do_fire_attack()
{
    level endon("game_ended");
    
    lock = 0;
    for (h = 0; h < 2; h++)
    {
        x = randomintrange(0, 2);
        if (x == 0 && lock != 1)
        {
            z = -20;
            iteration = 3;
            lock = 1;
        }
        else
        {
            z = -70;
            iteration = 2;
        }
        for (j = 0; j < iteration; j++)
        {
            x = 75;
            z += 50;
            for (i = 0; i < 35; i++)
            {
                level thread spawn_firewall(x, z);
                x += 75;
            }
            wait 0.1;
        }
        wait 1;
        level notify("firewall_setup");
        wait 5;
    }
}
//9211, -6277, -355
spawn_firewall(x_offset, z_offset)
{
    level endon("game_ended");

    fx_origin = ((8895 + x_offset), -9270, (-450 + z_offset));
    fx_destination_origin = ((8895 + x_offset), -5600, (-450 + z_offset));
    fx = spawn( "script_model", fx_origin);
    fx setmodel( "tag_origin" );
    wait 1;
    playfxontag( level._effect["fx_tomb_fire_lg"], fx, "tag_origin" );
    level waittill("firewall_setup");
    fx moveto( fx_destination_origin, level.firewall_duration );
    for (i = 0; i < 100; i++)
    {
        foreach(player in level.players)
        {
            stance = player GetStance();
            player_origin_offset = 0;
            if (stance == "prone")
                player_origin_offset = 30;
            if (distancesquared((fx.origin), (player.origin - (0, 0, player_origin_offset))) < 1700 && player.ignoreme != true)
                player dodamage(666, player.origin);
        }
        wait 0.1;
    }
    fx delete();
    level notify("fire_attack_end");
}

do_wind_attack()
{
    level endon("game_ended");

    level.is_boss_casting = 1;
    a_aoe = [];
    offset = 300;
    for (i = 0; i < 8; i++)
    {
        a_aoe[0] = (offset, 0, 0);
        a_aoe[1] = (0, offset, 0); 
        a_aoe[2] = (0, -(offset), 0); 
        a_aoe[3] = (-(offset), 0, 0); 
        foreach (aoe in a_aoe)     
            level thread spawn_tornado(aoe); 
        offset += 300;
    }
    level thread rumbleplayers(2, 1);
    wait 1.1;
    level thread rumbleplayers(2, 1);    
    wait 1.1;
    level thread rumbleplayers(2, 1);
    wait 1.1;
    level thread rumbleplayers(2, 1);    
    wait 1.1;
    foreach(player in level.players)
    {
        b_cansee = bullettracepassed( level.panzer_boss.origin + vectorscale( ( 0, 0, 1 ), 36.0 ), player.origin + vectorscale( ( 0, 0, 1 ), 36.0 ), 0, undefined );
        if (b_cansee && player.ignoreme != true)
            player dodamage(666, player.origin);
    }
    level thread rumbleplayers(5, 2);
    fadetowhite = newhudelem();
    fadetowhite.x = 0;
    fadetowhite.y = 0;
    fadetowhite.alpha = 0;
    fadetowhite.horzalign = "fullscreen";
    fadetowhite.vertalign = "fullscreen";
    fadetowhite.foreground = 1;
    fadetowhite setshader( "white", 640, 480 );
    fadetowhite fadeovertime( 0.2 );
    fadetowhite.alpha = 0.3;
    wait 0.5;
    fadetowhite fadeovertime( 0.5 );
    fadetowhite.alpha = 0;
    wait 1.1;
    fadetowhite destroy();
    level.is_boss_casting = 0;
}

do_lightning_attack()
{
    level endon("game_ended");
    
    a_aoe = [];
  
    delay = 1;
    for (j = 0; j < 5; j++)
    {
        offset = 100;
        for(i = 0; i < 20; i++)
        {
            a_aoe[0] = (offset, 0, 0);
            a_aoe[1] = (offset, offset, 0);   
            a_aoe[2] = (0, offset, 0); 
            a_aoe[3] = (offset, offset, 0);
            a_aoe[4] = (0, -(offset), 0); 
            a_aoe[5] = (-(offset), -(offset), 0); 
            a_aoe[6] = (offset, -(offset), 0);
            a_aoe[7] = (-(offset), 0, 0);   
            a_aoe[8] = (-(offset), offset, 0); 
            foreach(aoe in a_aoe)
            {
                level thread spawn_orb(aoe);
            }
            offset += 100;
            wait 0.1;
        }   
        wait delay;
        delay = delay / 2;
    }
}



spawn_tornado(target_origin)
{
    level endon("game_ended");

    fx_origin = level.panzer_boss.origin + target_origin;
    fx = spawn( "script_model", (fx_origin[0], fx_origin[1], -390));
    fx setmodel( "tag_origin" );
    wait 0.1;
    playfxontag( level._effect["whirlwind"], fx, "tag_origin" );
    wait 4.6;
    fx delete();
}

spawn_orb(target_origin)
{
    level endon("game_ended");

    fx_origin = level.panzer_boss.origin + target_origin;
    fx = spawn( "script_model", (fx_origin[0], fx_origin[1], -390));
    fx setmodel( "tag_origin" );
    wait 0.1;
    playfxontag( level._effect["elec_piano_glow"], fx, "tag_origin" );
    for (i = 0; i < 10; i++)
    {
        foreach(player in level.players)
        {
            if (distancesquared(fx_origin, player.origin) < 7000)
                player shellshock( "explosion", 0.5 );
        }
        wait 0.1;
    }
    fx delete();
    fx = spawn( "script_model", (fx_origin[0], fx_origin[1], -390));
    fx setmodel( "tag_origin" );
    wait 0.1;
    playfxontag( level._effect["ice_explode"], fx, "tag_origin" );  
    foreach(player in level.players)
    {
        if (distancesquared(fx_origin, player.origin) < 7000 && player.ignoreme != true)
            player dodamage(666, player.origin);
    }
    wait 0.5; 
    fx delete();
}

mechz_find_flesh_custom2()
{
    self endon( "death" );
    level endon( "intermission" );

    if ( level.intermission )
        return;

    self.helitarget = 1;
    self.ignoreme = 0;
    self.nododgemove = 1;
    self.ignore_player = [];
    self.goalradius = 32;
    self.ai_state = "spawning";

    while ( true )
    {
        if (level.is_boss_casting == 1)
        {
            self.goal_pos = self.origin;
            self setgoalpos( self.goal_pos );
            self.ai_state = "idle";
            self setanimstatefromasd( "zm_idle" );
            wait 0.5;
            continue;
        }
        player = [[ self.closest_player_override ]]();
        self mechz_set_locomotion_speed();

        if ( !isdefined( player ) )
        {
/#
            if ( getdvarint( _hash_E7121222 ) > 1 )
                println( "\\n\\tMZ: No Enemy, idling\\n" );
#/
            self.goal_pos = self.origin;
            self setgoalpos( self.goal_pos );
            self.ai_state = "idle";
            self setanimstatefromasd( "zm_idle" );
            wait 0.5;
            continue;
        }

        self.favoriteenemy = player;
        self.disable_complex_behaviors = 0; 
        if ( distancesquared( self.origin, player.origin ) < level.mechz_aggro_dist_sq )
        {
            self.disable_complex_behaviors = 1;
        }
        else if ( self should_do_claw_attack() )
        {
            self mechz_do_claw_grab();
            continue;
        }
        else if ( self should_do_flamethrower_attack() )
        {
            self mechz_do_flamethrower_attack();
            continue;
        }
        self.goal_pos = player.origin;

        if ( isdefined( level.damage_prone_players_override_func ) )
            level thread [[ level.damage_prone_players_override_func ]]();
        else
            self thread damage_prone_players();
        self setgoalpos( self.goal_pos );
        mechz_start_basic_find_flesh();
        wait 0.5;
    }
}

mechz_find_flesh_custom()
{
    self endon( "death" );
    level endon( "intermission" );

    if ( level.intermission )
        return;

    self.helitarget = 1;
    self.ignoreme = 0;
    self.nododgemove = 1;
    self.ignore_player = [];
    self.goalradius = 32;
    self.ai_state = "spawning";
    self thread watch_for_player_dist();

    while ( true )
    {
        if (level.is_boss_casting == 1 && isdefined(level.boss) && self == level.boss)
        {
            self.goal_pos = self.origin;
            self setgoalpos( self.goal_pos );
            self.ai_state = "idle";
            self setanimstatefromasd( "zm_idle" );
            wait 0.5;
            continue;
        }
/#
        if ( isdefined( self.force_behavior ) && self.force_behavior )
        {
            wait 0.05;
            continue;
        }
#/
        if ( isdefined( self.not_interruptable ) && self.not_interruptable )
        {
/#
            if ( getdvarint( _hash_E7121222 ) > 1 )
                println( "\\nMZ: Not thinking since a behavior has set not_interruptable\\n" );
#/
            wait 0.05;
            continue;
        }

        if ( isdefined( self.is_traversing ) && self.is_traversing )
        {
/#
            if ( getdvarint( _hash_E7121222 ) > 1 )
                println( "\\nMZ: Not thinking since mech is traversing\\n" );
#/
            wait 0.05;
            continue;
        }

        player = [[ self.closest_player_override ]]();
        //self mechz_set_locomotion_speed();
/#
        if ( getdvarint( _hash_E7121222 ) > 1 )
            println( "\\nMZ: Doing think\\n" );
#/
        self.favoriteenemy = player;

        if ( !isdefined( player ) )
        {
/#
            if ( getdvarint( _hash_E7121222 ) > 1 )
                println( "\\n\\tMZ: No Enemy, idling\\n" );
#/
            self.goal_pos = self.origin;
            self setgoalpos( self.goal_pos );
            self.ai_state = "idle";
            self setanimstatefromasd( "zm_idle" );
            wait 0.5;
            continue;
        }

        if ( player entity_on_tank() )
        {
            if ( level.vh_tank ent_flag( "tank_moving" ) )
            {
                if ( isdefined( self.jump_pos ) && self mechz_in_range_for_jump() )
                {
/#
                    if ( getdvarint( _hash_E7121222 ) > 1 )
                        println( "\\n\\tMZ: Enemy on moving tank, do jump out and jump in when tank is stationary\\n" );
#/
                    self mechz_do_jump( 1 );
                }
                else
                {
/#
                    if ( getdvarint( _hash_E7121222 ) > 1 )
                        println( "\\n\\tMZ: Enemy on moving tank, Jump Requested, going to jump pos\\n" );
#/
                    if ( !isdefined( self.jump_pos ) )
                        self.jump_pos = get_closest_mechz_spawn_pos( self.origin );

                    if ( isdefined( self.jump_pos ) )
                    {
                        self.goal_pos = self.jump_pos.origin;
                        self setgoalpos( self.goal_pos );
                    }

                    wait 0.5;
                    continue;
                }
            }
            else
            {
/#
                if ( getdvarint( _hash_E7121222 ) > 1 )
                    println( "\\n\\tMZ: Enemy on tank, targetting a tank pos\\n" );
#/
                self.disable_complex_behaviors = 0;
                self mechz_stop_basic_find_flesh();
                self.ai_state = "tracking_tank";
                self.goalradius = level.mechz_custom_goalradius;
                self.custom_goalradius_override = level.mechz_custom_goalradius;
                closest_tank_tag = level.vh_tank get_closest_mechz_tag_on_tank( self, self.origin );

                if ( !isdefined( closest_tank_tag ) )
                {
/#
                    if ( getdvarint( _hash_E7121222 ) > 1 )
                        println( "\\n\\tMZ: Enemy on tank, no closest tank pos found, continuing\\n" );
#/
                    wait 0.5;
                    continue;
                }

                closest_tank_tag_pos = level.vh_tank gettagorigin( closest_tank_tag );

                if ( abs( self.origin[2] - closest_tank_tag_pos[2] ) >= level.mechz_custom_goalradius || distance2dsquared( self.origin, closest_tank_tag_pos ) >= level.mechz_custom_goalradius_sq )
                {
/#
                    if ( getdvarint( _hash_E7121222 ) > 1 )
                        println( "\\n\\tMZ: Enemy on tank, setting tank pos as goal\\n" );
#/
                    self.goal_pos = closest_tank_tag_pos;
                    self setgoalpos( self.goal_pos );
                    self waittill_any_or_timeout( 0.5, "goal", "bad_path" );

                    if ( !player entity_on_tank() )
                    {
/#
                        if ( getdvarint( _hash_E7121222 ) > 1 )
                            println( "\\n\\tMZ: Enemy got off tank by the time we reached our goal, continuing\\n" );
#/
                        continue;
                    }
                }

                if ( abs( self.origin[2] - closest_tank_tag_pos[2] ) < level.mechz_custom_goalradius && distance2dsquared( self.origin, closest_tank_tag_pos ) < level.mechz_custom_goalradius_sq )
                {
/#
                    if ( getdvarint( _hash_E7121222 ) > 1 )
                        println( "\\n\\tMZ: Enemy on tank, reached tank pos, doing flamethrower sweep\\n" );
#/
                    self.angles = vectortoangles( level.vh_tank.origin - self.origin );
                    self mechz_do_flamethrower_attack( 1 );
                    self notify( "tank_flamethrower_attack_complete" );
                }
            }

            continue;
        }
        else if ( isdefined( self.jump_requested ) && self.jump_requested || isdefined( self.force_jump ) && self.force_jump )
        {
            if ( self mechz_in_range_for_jump() )
                self mechz_do_jump();
            else
            {
/#
                if ( getdvarint( _hash_E7121222 ) > 1 )
                    println( "\\n\\tMZ: Jump Requested, going to jump pos\\n" );
#/
                self.goal_pos = self.jump_pos.origin;
                self setgoalpos( self.goal_pos );
                wait 0.5;
                continue;
            }
        }
        else if ( self.zombie_move_speed == "sprint" && isdefined( player ) )
        {
/#
            if ( getdvarint( _hash_E7121222 ) > 1 )
                println( "\\n\\tMZ: Sprinting\\n" );
#/
            self.goal_pos = player.origin;
            self setgoalpos( self.goal_pos );
            wait 0.5;
            continue;
        }
        else if ( distancesquared( self.origin, player.origin ) < level.mechz_aggro_dist_sq )
        {
/#
            if ( getdvarint( _hash_E7121222 ) > 1 )
                println( "\\n\\tMZ: Player very close, switching to melee only\\n" );
#/
            self.disable_complex_behaviors = 1;
        }
        else if ( self should_do_claw_attack() )
        {
            self mechz_do_claw_grab();
            continue;
        }
        else if ( self should_do_flamethrower_attack() )
        {
            self mechz_do_flamethrower_attack();
            continue;
        }
/#
        if ( getdvarint( _hash_E7121222 ) > 1 )
            println( "\\n\\tMZ: No special behavior valid, heading after player\\n" );
#/
        self.goal_pos = player.origin;

        if ( isdefined( level.damage_prone_players_override_func ) )
            level thread [[ level.damage_prone_players_override_func ]]();
        else
            self thread damage_prone_players();

        mechz_start_basic_find_flesh();
        wait 0.5;
    }
}

perk_machine_spawn_init_customized()
{
    self endon("disconnect");
    level endon ("game_ended");
if (getdvar("net_port") != "30010")
    return;

    match_string = "";
    location = level.scr_zm_map_start_location;

    if ( ( location == "default" || location == "" ) && isdefined( level.default_start_location ) )
        location = level.default_start_location;

    match_string = level.scr_zm_ui_gametype + "_perks_" + location;
    pos = [];

    if ( isdefined( level.override_perk_targetname ) )
        structs = getstructarray( level.override_perk_targetname, "targetname" );
    else
        structs = getstructarray( "zm_perk_machine", "targetname" );
        
    foreach ( struct in structs )
    {
        if ( isdefined( struct.script_string ) )
        {
            tokens = strtok( struct.script_string, " " );

            foreach ( token in tokens )
            {
                if ( token == match_string )
                    pos[pos.size] = struct;
            }

            continue;
        }

        pos[pos.size] = struct;
    }
    if ( !isdefined( pos ) || pos.size == 0 )
        return;

    for ( i = 0; i < pos.size; i++ )
    {
        perk = pos[i].script_noteworthy;
        if (perk == "specialty_longersprint")
        {
            origin = ( 10853.9, -8289.79, -447.75 );
            angles = ( 0, 178, 0 );
            MovePerk(origin, angles, perk);
        }
        else if (perk == "specialty_quickrevive")
        {
            origin = ( 10728, -7107, -443.75 );
            angles = ( 0, 27, 0 );
			level.perk_machine = Spawn( "script_model", origin );
			level.perk_machine.angles = angles;
			level.perk_machine SetModel("p6_zm_tm_vending_revive");

            MovePerk(origin, angles, perk);
        }
        else if (perk == "specialty_fastreload")
        {
            origin = ( 9519.64, -7785.12, -463.25 );
            angles = ( 0, 54.5, 0 );
            MovePerk(origin, angles, perk);
        }
        else if (perk == "specialty_armorvest")
        {
            origin = ( 9986, -8815.25, -451.75 );
            angles = ( 0, 194, 0 );
            MovePerk(origin, angles, perk);
        }
        wait 0.1;
    }
}

MovePerk(origin, angles, perk)
{
    level endon ("game_ended");
    perkEnt = getent( perk, "script_noteworthy" );
    perkEnt.machine.origin = origin;
    perkEnt.machine.angles = angles;
    perkEnt.clip.origin = origin;
    perkEnt.clip.angles = angles;           
    perkEnt.bump.origin = origin;
    perkEnt.bump.angles = angles;     
    Trigger = spawn( "trigger_radius", perkEnt.machine.origin, 1, 70, 90 );
    Trigger enableLinkTo();
    Trigger linkto(perkEnt.machine);

    Trigger.targetname = "zombie_vending";			
    Trigger.script_noteworthy = perk;
    Trigger TriggerIgnoreTeam();
    Trigger.script_sound = "mus_perks_revive_jingle";
    Trigger.script_string = "revive_perk";
    Trigger.script_label = "mus_perks_revive_sting";
    Trigger.target = "vending_sleight";
    Trigger.machine = perkEnt.machine;
    Trigger SetCursorHint( "HINT_NOICON" );
    Trigger thread vending_trigger_think_customized();

 /*   vending_triggers = getentarray( "zombie_vending", "targetname" );
    for ( i = 0; i < vending_triggers.size; i++ )
    {
        if ( isdefined( vending_triggers[i].script_noteworthy ) && vending_triggers[i].script_noteworthy == perk )
        {
         //   vending_triggers[i].origin = origin;
         //   vending_triggers[i].angles = angles;
            vending_triggers[i] destroy();

           vending_triggers[i] = spawn( "trigger_radius", perkEnt.machine.origin, 1, 60, 80 );
            vending_triggers[i] enableLinkTo();
            vending_triggers[i] linkto(perkEnt.machine);
            vending_triggers[i] SetCursorHint( "HINT_NOICON" );
            vending_triggers[i] sethintstring( "			Hold ^3&&1^7 for Pack-a-Punch [Cost: 5000] \n Weapons can be pack a punched multiple times" );
        }
    }*/
}

pack_a_punch_init_custom()
{
    level endon ("game_ended");

    vending_weapon_upgrade_trigger = getentarray( "specialty_weapupgrade", "script_noteworthy" );
    level.pap_triggers = vending_weapon_upgrade_trigger;
    
    t_pap = getent( "specialty_weapupgrade", "script_noteworthy" );

    for (;;)
    {
        if (getdvar("net_port") == "30010")
        {
            t_pap.machine.origin = (10760.4, -7980.47, -463.875);
            t_pap.machine.angles = (358.801, 260, 0);
            t_pap.clip.origin = (10760.4, -7980.47, -463.875);       
            t_pap.clip.angles = (358.801, 260, 0);  
            t_pap.bump enablelinkto();
            t_pap.bump linkto( t_pap );
            level thread pack_a_punch_think();
            vending_triggers = getentarray( "zombie_vending", "targetname" );
            for ( i = 0; i < vending_triggers.size; i++ )
            {
                if ( isdefined( vending_triggers[i].script_noteworthy ) && vending_triggers[i].script_noteworthy == "specialty_weapupgrade" )
                {
                    vending_triggers[i].origin = (10760.4, -7980.47, -463.875);
                    vending_triggers[i].angles = (358.801, 260, 0);
                }
            }
            return;
        }
        else
        {
            t_pap.machine ghost();
            t_pap.machine notsolid();
            t_pap.bump enablelinkto();
            t_pap.bump linkto( t_pap );
            level thread pack_a_punch_think();
            return;
        }
        wait 0.5;
    }
}

vending_trigger_think_customized()
{
    self endon( "death" );
    level endon( "game_ended" );
    wait 0.01;
    perk = self.script_noteworthy;
    solo = 0;
    start_on = 0;
    level.revive_machine_is_solo = 0;

    if ( isdefined( perk ) && ( perk == "specialty_quickrevive" || perk == "specialty_quickrevive_upgrade" ) )
    {
        flag_wait( "start_zombie_round_logic" );
        solo = use_solo_revive();
        self endon( "stop_quickrevive_logic" );
        level.quick_revive_trigger = self;

        if ( solo )
        {
            if ( !is_true( level.revive_machine_is_solo ) )
            {
                start_on = 1;
                players = get_players();

                foreach ( player in players )
                {
                    if ( !isdefined( player.lives ) )
                        player.lives = 0;
                }

                level maps\mp\zombies\_zm::set_default_laststand_pistol( 1 );
            }
            level.revive_machine_is_solo = 1;
        }
    }

    self sethintstring( &"ZOMBIE_NEED_POWER" );
    self setcursorhint( "HINT_NOICON" );
    self usetriggerrequirelookat();
    cost = level.zombie_vars["zombie_perk_cost"];

    zcoinCost = 9999999;
    cost = 9999999;
    switch ( perk )
    {
        case "specialty_armorvest":
            perkname = "^1Juggernog^7";
            cost = 100000;
            costString = "100K";
            zcoinCost = 0;
            break;
        case "specialty_quickrevive":
            perkname = "^5Quick Revive^7";
            cost = 300000;
            costString = "300K";
            zcoinCost = 5;
            break;
        case "specialty_fastreload":
            perkname = "^2Speed Cola^7";
            cost = 100000;
            costString = "100K";
            zcoinCost = 1;
            break;
        case "specialty_rof":
            perkname = "^3Double Tap^7";
            cost = 200000;
            costString = "200K";
            zcoinCost = 5;
            break;
        case "specialty_longersprint":
            perkname = "^3Stamin'Up^7";
            cost = 200000;
            costString = "200K";
            zcoinCost = 3;
            break;
        case "specialty_deadshot":
        case "specialty_additionalprimaryweapon":
        case "specialty_scavenger":
        case "specialty_finalstand":
        default:
            self sethintstring( "error :)" );
    }
    self sethintstring("^3Some ^5steps^7 ^3must be completed...");

    if ( isdefined( level._custom_perks[perk] ) && isdefined( level._custom_perks[perk].cost ) )
        cost = level._custom_perks[perk].cost;

    self.cost = cost;

    notify_name = perk + "_power_on";
    level waittill( notify_name );


    if ( !isdefined( level._perkmachinenetworkchoke ) )
        level._perkmachinenetworkchoke = 0;
    else
        level._perkmachinenetworkchoke++;

    for ( i = 0; i < level._perkmachinenetworkchoke; i++ )
        wait_network_frame();

    self thread maps\mp\zombies\_zm_audio::perks_a_cola_jingle_timer();
    self thread check_player_has_perk( perk );

    if ( isdefined( level._custom_perks[perk] ) && isdefined( level._custom_perks[perk].hint_string ) )
        self sethintstring( level._custom_perks[perk].hint_string, cost );

    perkStamName = "specialty_longersprint";
    perkJuggName = "specialty_armorvest";
    perkQuickName = "specialty_quickrevive";
    perkReloadName = "specialty_fastreload";   

    stamLock = 0;
    juggLock = 0;
    quickLock = 0;
    reloadLock = 0;

    for (;;)
    {  
        if (stamLock == 0 && level.isStamOn == true && perkStamName == perk)
        {
            self sethintstring("Hold ^3Use^7 for " + perkname + " [^3Cost^7: ^2" + costString + "^7 & ^5" + zcoinCost + " Z-Coins^7]");
            stamLock = 1;
        }
        if (juggLock == 0 && level.isJuggOn == true && perkJuggName == perk)
        {
            self sethintstring("Hold ^3Use^7 for " + perkname + " [^3Cost^7: ^2" + costString + "^7 & ^5" + zcoinCost + " Z-Coins^7]");
            juggLock = 1;
        }
        if (quickLock == 0 && level.isQuickOn == true && perkQuickName == perk)
        {
            self sethintstring("Hold ^3Use^7 for " + perkname + " [^3Cost^7: ^2" + costString + "^7 & ^5" + zcoinCost + " Z-Coins^7]");
            quickLock = 1;
        }
        if (reloadLock == 0 && level.isReloadOn == true && perkReloadName == perk)
        {
            self sethintstring("Hold ^3Use^7 for " + perkname + " [^3Cost^7: ^2" + costString + "^7 & ^5" + zcoinCost + " Z-Coins^7]");
            reloadLock = 1;
        }
        wait 0.1;
        self waittill( "trigger", player );
        if (player UseButtonPressed())
        {
            index = maps\mp\zombies\_zm_weapons::get_player_index( player );

            if (level.isStamOn != true && perkStamName == perk)
            {
                wait 0.1;
                continue;
            }
            if (level.isJuggOn != true && perkJuggName == perk)
            {
                wait 0.1;
                continue;
            }
            if (level.isQuickOn != true && perkQuickName == perk)
            {
                wait 0.1;
                continue;
            }
            if (level.isReloadOn != true && perkReloadName == perk)
            {
                wait 0.1;
                continue;
            }

            if ( player maps\mp\zombies\_zm_laststand::player_is_in_laststand() || isdefined( player.intermission ) && player.intermission )
                continue;

            if ( player in_revive_trigger() )
                continue;

            if ( !player maps\mp\zombies\_zm_magicbox::can_buy_weapon() )
            {
                wait 0.1;
                continue;
            }

            if ( player isthrowinggrenade() )
            {
                wait 0.1;
                continue;
            }

            if ( player isswitchingweapons() )
            {
                wait 0.1;
                continue;
            }

            if ( player.is_drinking > 0 )
            {
                wait 0.1;
                continue;
            }

            if ( player hasperk( perk ) || player has_perk_paused( perk ) )
            {
                cheat = 0;
    /#
                if ( getdvarint( _hash_FA81816F ) >= 5 )
                    cheat = 1;
    #/
                if ( cheat != 1 )
                {
                    self playsound( "deny" );
                    player maps\mp\zombies\_zm_audio::create_and_play_dialog( "general", "perk_deny", undefined, 1 );
                    continue;
                }
            }

        /*  if ( isdefined( level.custom_perk_validation ) )
            {
                valid = self [[ level.custom_perk_validation ]]( player );

                if ( !valid )
                    continue;
            }*/
            
            current_cost = cost;
            playerzcoin = int(getDvar("zcoins_" + player getGuid()));
            if ( player maps\mp\zombies\_zm_pers_upgrades_functions::is_pers_double_points_active() )
                current_cost = player maps\mp\zombies\_zm_pers_upgrades_functions::pers_upgrade_double_points_cost( current_cost );

            if (playerzcoin < zcoinCost)
            {
                self playsound( "evt_perk_deny" );
                player maps\mp\zombies\_zm_audio::create_and_play_dialog( "general", "perk_deny", undefined, 0 );
                player iPrintln("Not enough ^5Z-Coins^7 to make that purchase");
                wait 2;
                continue;
            }
            if ( player.score < current_cost )
            {
                self playsound( "evt_perk_deny" );
                player maps\mp\zombies\_zm_audio::create_and_play_dialog( "general", "perk_deny", undefined, 0 );
                player iPrintln("Not enough ^2Points^7 to make that purchase");
                wait 2;
                continue;
            }

            if ( player.num_perks >= player get_player_perk_purchase_limit() )
            {
                self playsound( "evt_perk_deny" );
                player maps\mp\zombies\_zm_audio::create_and_play_dialog( "general", "sigh" );
                continue;
            }

            sound = "evt_bottle_dispense";
            playsoundatposition( sound, self.origin );
            player maps\mp\zombies\_zm_score::minus_to_player_score( current_cost, 1 );
            setDvar("zcoins_" + player getGuid(), playerzcoin - zcoinCost);
            player iprintln("^5" + zcoinCost + " Z-Coins^3 used. Remaining ^5Z-Coins : " + getDvar("zcoins_" + player getGuid()) + "^7");
            player.perk_purchased = perk;
            self thread maps\mp\zombies\_zm_audio::play_jingle_or_stinger( self.script_label );
            self thread vending_trigger_post_think( player, perk );
            wait 5;
        }
    }
}

check_for_pia_port()
{
    found = 0;
    if (isdefined(level.net_port_pia))
    {
        foreach(port in level.net_port_pia)
        {
            if (getdvar("net_port") == port)
                found = 1;
        }
    }
    if (found == 0)
        return false;
    return true;
}