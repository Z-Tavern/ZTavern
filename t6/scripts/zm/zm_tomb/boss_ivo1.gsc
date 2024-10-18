
/* 
 * Copyright 2023 K Mod. All rights reserved.
 *
 * This code, including any associated documentation or files, is the
 * intellectual property of K Mod. You may not
 * use, modify, reproduce, distribute, or disclose this code without
 * explicit written permission from the owner.
 *
 * Unauthorized use, reproduction, or distribution of this code or any
 * portion thereof is strictly prohibited and may result in severe legal
 * consequences. For licensing inquiries or permission requests, please
 * contact eizekiels@gmail.com.
 */

/* -------- STARTER GUIDE ----------

    --------- HOW TO MAKE THE BOSS LOOKS COOL, Spawn an object to a specific location --------- 

    model = "t6_wpn_zmb_staff_tip_lightning_world";

    self.fx = spawn( "script_model", self.origin ); // create objet
    self.fx linkto( self, "J_SpineLower", (0, -10, 15), (180, 90, 70)); // link to the boss (anchor)
    wait 0.05;
    self.fx setmodel( model );  // apply the model

    --------- HOW TO MAKE BOSS ATTACK SPECIAL EFFECTS, Spawn a FX on an fx ---------------------

    fx_origin = level.boss.origin; //set origin of effect 
    fx = spawn( "script_model", (fx_origin[0], fx_origin[1], -390)); // spawn object
    fx setmodel( "tag_origin" ); // set three D default object
    wait 0.05;
    playfxontag( level._effect["whirlwind"], fx, "tag_origin" ); // <- only thing to change is the level._effect, go search it in the stock script (ctrl + F)

    --------- HOW TO ADD SOUND TO ATTACKS -------------------------------------------------------

    self playsound( "evt_medal_acquired" ); // search playsound in stock script (CTRL + F)

    --------- HOW TO MAKE BOSS SHINY ------------------------------------------------------------

    (Pick one or more)
    level.boss.fx_element_glow = playfxontag( localclientnum, level._effect["fire_glow"], level.boss, "tag_origin" );
    level.boss.fx_element_glow = playfxontag( localclientnum, level._effect["air_glow"], level.boss, "tag_origin" );
    level.boss.fx_element_glow = playfxontag( localclientnum, level._effect["elec_glow"], level.boss, "tag_origin" );
    level.boss.fx_element_glow = playfxontag( localclientnum, level._effect["ice_glow"], level.boss, "tag_origin" );


    --------- USEFUL COORDINATES -----------------------------------------------------------------
    level.fire_spawn_origin = (9463, -8560, -398);
    level.ice_spawn_origin = (11211, -7058.7, -345.875);
    level.wind_spawn_origin = (11253, -8655, -408);
    level.lightning_spawn_origin = (9623.4, -7016.2, -345.875);
    level.pap_spawn_origin = (10760.4, -7980.47, -463.875);
    level.center_spawn_origin = (10314.5, -7889.91, -411.875);
    level.fire_puzzle_origin = (9891.5, -8764, -452);
    
*/
//BACKUP BEFORE PHASES !
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_magicbox;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\zombies\_zm_power;
#include maps\mp\zombies\_zm_pers_upgrades_functions;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\_demo;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_chugabud;
#include maps\mp\_visionset_mgr;
#include maps\mp\zombies\_zm_perks;
#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zombies\_zm_spawner;

#include Maps\Origins\clientscripts\mp\zm_tomb_tank;
#include maps\mp\zombies\_zm_ai_mechz;
#include clientscripts\mp\_utility;
#include clientscripts\mp\_fx;
#include clientscripts\mp\zombies\_zm_utility;
#include clientscripts\mp\zombies\_zm_weapons;
#include maps\mp\gametypes_zm\_weapon_utils;
#include Maps\Origins\clientscripts\mp\zombies\_zm_weap_beacon;
#include Maps\Origins\clientscripts\mp\zombies;
#include Maps\Tranzit\maps\mp\zombies\_zm_ai_avogadro;
#include maps\mp\gametypes_zm\_shellshock;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\zombies\_zm_ai_mechz_ffotd;
#include maps\mp\zombies\_zm_sidequests;
#include maps\mp\zm_tomb_ee_main;
#include maps\mp\zm_tomb_utility;
#include maps\mp\zm_tomb_vo;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_hud;
#include maps\mp\zm_tomb_chamber;
#include maps\mp\zm_tomb;
#include maps\mp\zm_spawner;
#include maps\zombie_alcatraz\fx_alcatraz_lightning_lg;
#include maps\mp\zombies\_zm_traps;

#include scripts\zm\zm_tomb\raid_boss;
/*
init()//delete
{
    flag_wait("initial_blackscreen_passed");
    level thread setup_boss_ivo1();
}
*/
init_levelvars()
{
    level.is_zombie_level = 1;
    level.laststandpistol = "m1911_zm";
    level.default_laststandpistol = "m1911_zm";
    level.default_solo_laststandpistol = "m1911_upgraded_zm";
    level.start_weapon = "m1911_zm";
    level.first_round = 1;
    level.start_round = getgametypesetting( "startRound" );
    level.round_number = level.start_round;
    level.enable_magic = getgametypesetting( "magic" );
    level.headshots_only = getgametypesetting( "headshotsonly" );
    level.player_starting_points = level.round_number * 500;
    level.round_start_time = 0;
    level.pro_tips_start_time = 0;
    level.intermission = 0;
    level.dog_intermission = 0;
    level.zombie_total = 0;
    level.total_zombies_killed = 0;
    level.hudelem_count = 0;
    level.zombie_spawn_locations = [];
    level.zombie_rise_spawners = [];
    level.current_zombie_array = [];
    level.current_zombie_count = 0;
    level.zombie_total_subtract = 0;
    level.destructible_callbacks = [];
    level.zombie_vars = [];

    foreach ( team in level.teams )
        level.zombie_vars[team] = [];

    difficulty = 1;
    column = int( difficulty ) + 1;
    set_zombie_var( "zombie_health_increase", 100, 0, column );
    set_zombie_var( "zombie_health_increase_multiplier", 0.1, 1, column );
    set_zombie_var( "zombie_health_start", 20000, 0, column );
    set_zombie_var( "zombie_spawn_delay", 0.05, 0, column );
    set_zombie_var( "zombie_new_runner_interval", 10, 0, column );
    set_zombie_var( "zombie_move_speed_multiplier", 8, 0, column );
    set_zombie_var( "zombie_move_speed_multiplier_easy", 2, 0, column );
    set_zombie_var( "zombie_max_ai", 24, 0, column );
    set_zombie_var( "zombie_ai_per_player", 6, 0, column );
    set_zombie_var( "below_world_check", -1000 );
    set_zombie_var( "spectators_respawn", 1 );
    set_zombie_var( "zombie_use_failsafe", 1 );
    set_zombie_var( "zombie_between_round_time", 10 );
    set_zombie_var( "zombie_intermission_time", 15 );
    set_zombie_var( "game_start_delay", 0, 0, column );
    set_zombie_var( "penalty_no_revive", 0.1, 1, column );
    set_zombie_var( "penalty_died", 0.0, 1, column );
    set_zombie_var( "penalty_downed", 0.05, 1, column );
    set_zombie_var( "starting_lives", 1, 0, column );
    set_zombie_var( "zombie_score_kill_4player", 50 );
    set_zombie_var( "zombie_score_kill_3player", 50 );
    set_zombie_var( "zombie_score_kill_2player", 50 );
    set_zombie_var( "zombie_score_kill_1player", 50 );
    set_zombie_var( "zombie_score_kill_4p_team", 30 );
    set_zombie_var( "zombie_score_kill_3p_team", 35 );
    set_zombie_var( "zombie_score_kill_2p_team", 45 );
    set_zombie_var( "zombie_score_kill_1p_team", 0 );
    set_zombie_var( "zombie_score_damage_normal", 10 );
    set_zombie_var( "zombie_score_damage_light", 10 );
    set_zombie_var( "zombie_score_bonus_melee", 80 );
    set_zombie_var( "zombie_score_bonus_head", 50 );
    set_zombie_var( "zombie_score_bonus_neck", 20 );
    set_zombie_var( "zombie_score_bonus_torso", 10 );
    set_zombie_var( "zombie_score_bonus_burn", 10 );
    set_zombie_var( "zombie_flame_dmg_point_delay", 500 );
    set_zombie_var( "zombify_player", 0 );

    if ( issplitscreen() )
        set_zombie_var( "zombie_timer_offset", 280 );

    level thread init_player_levelvars();
    level.gamedifficulty = getgametypesetting( "zmDifficulty" );

    if ( level.gamedifficulty == 0 )
        level.zombie_move_speed = level.round_number * level.zombie_vars["zombie_move_speed_multiplier_easy"];
    else
        level.zombie_move_speed = level.round_number * level.zombie_vars["zombie_move_speed_multiplier"];

    if ( level.round_number == 1 )
        level.zombie_move_speed = 1;
    else
    {
        for ( i = 1; i <= level.round_number; i++ )
        {
            timer = level.zombie_vars["zombie_spawn_delay"];

            if ( timer > 0.08 )
            {
                level.zombie_vars["zombie_spawn_delay"] = timer * 0.95;
                continue;
            }

            if ( timer < 0.08 )
                level.zombie_vars["zombie_spawn_delay"] = 0.08;
        }
    }

    level.speed_change_max = 0;
    level.speed_change_num = 0;
}

NoPowerups_Ivo1()
{
    for(;;)
    {
        if(flag("zombie_drop_powerups"))
        {
            flag_clear( "zombie_drop_powerups" );
          //  iPrintLn("Powerup Deleted");
        }
        

        wait 0.05;
    }
}

should_do_flamethrower_attack()//change put this whole function in
{
    assert( isdefined( self.favoriteenemy ) );
/#
    if ( getdvarint( #"_id_E7121222" ) > 1 )
        println( "\\n\\tMZ: Checking should flame\\n" );
#/

    if ( isdefined( self.disable_complex_behaviors ) && self.disable_complex_behaviors )
    {
/#
        if ( getdvarint( #"_id_E7121222" ) > 1 )
            println( "\\n\\t\\tMZ: Not doing flamethrower because doing force aggro\\n" );
#/
        return false;
    }

    if ( isdefined( self.not_interruptable ) && self.not_interruptable )
    {
/#
        if ( getdvarint( #"_id_E7121222" ) > 1 )
            println( "\\n\\t\\tMZ: Not doing flamethrower because another behavior has set not_interruptable\\n" );
#/
        return false;
    }

    if ( !self mechz_check_in_arc( 26 ) )
    {
/#
        if ( getdvarint( #"_id_E7121222" ) > 1 )
            println( "\\n\\t\\tMZ: Not doing flamethrower because target is not in front arc\\n" );
#/
        return false;
    }

    if ( isdefined( self.last_flamethrower_time ) && gettime() - self.last_flamethrower_time < level.mechz_flamethrower_cooldown_time )
    {
/#
        if ( getdvarint( #"_id_E7121222" ) > 1 )
            println( "\\n\\t\\tMZ: Not doing flamethrower because it is still on cooldown\\n" );
#/
        return false;
    }

    n_dist_sq = distancesquared( self.origin, self.favoriteenemy.origin );

    if ( n_dist_sq < 1444 || n_dist_sq > 160000 )
    {
/#
        if ( getdvarint( #"_id_E7121222" ) > 1 )
            println( "\\n\\t\\tMZ: Not doing flamethrower because target is not in range\\n" );
#/
        return false;
    }

    b_cansee = bullettracepassed( self.origin + vectorscale( ( 0, 0, 1 ), 36.0 ), self.favoriteenemy.origin + vectorscale( ( 0, 0, 1 ), 36.0 ), 0, undefined );

    if ( !b_cansee )
    {
/#
        if ( getdvarint( #"_id_E7121222" ) > 1 )
            println( "\\n\\t\\tMZ: Not doing flamethrower because cannot see target\\n" );
#/
        return false;
    }

    return true;
}

player_flame_damage()//Panzer Flamethrower Damage
{
    self endon( "zombified" );
    self endon( "death" );
    self endon( "disconnect" );
    n_player_dmg = 500;//Damage
    n_jugga_dmg = 500;//Damage
    n_burn_time = 1;//DamFunc

    if ( isdefined( self.is_zombie ) && self.is_zombie )
        return;

    self thread player_stop_burning();

    if ( !isdefined( self.is_burning ) && is_player_valid( self, 1, 0 ) )
    {
        self.is_burning = 1;
        maps\mp\_visionset_mgr::vsmgr_activate( "overlay", "zm_transit_burn", self, n_burn_time, level.zm_transit_burn_max_duration );
        self notify( "burned" );

        if ( !self hasperk( "specialty_armorvest" ) )
        {
            self dodamage_wrapper(n_player_dmg);
            wait 0.05;
            self shellshock( "lava_small", 0.1 );//DamFunc
        }
        else
        {
            self dodamage_wrapper(n_jugga_dmg);
            wait 0.05;
            self shellshock( "lava_small", 0.1 );//DamFunc
        }
            

        wait 0.25;
        self.is_burning = undefined;
    }
}

get_favorite_enemy_custom(origin, players)//Panzer Pathing Fix
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

dodamage_wrapper(damage)
{
    if (isdefined(self.shield) && self.shield > 0)
    {
        old_damage = damage;
        damage -= self.shield;
        if (old_damage < self.shield)
            self.shield -= old_damage;
        else
            self.shield = 0;
    }
    self dodamage(damage, self.origin);
}

setup_boss_ivo1()
{   
    setdvar( "g_ai", "1" );
    level.boss_name = "^1Panzer Lord";
    level thread Chat1_Ivo1();//change
    
    level.dead = 0;
    
    level.fire = (9458.41, -8561.4, -398);
    level.ice = (11233, -7047.87, -345.875);
    level.wind = (11256, -8661.66, -408);
    level.lightning = (9629, -7009.4, -345.875);
    level.pap_spawn_origin = (10760.4, -7980.47, -463.875);
    level.center_spawn_origin = (10341.6, -7907.17, -411.875);
    level.fire_puzzle_origin = (9891.5, -8764, -452);
    level.places = array( level.ice, level.fire, level.lightning, level.wind, level.center_spawn_origin);
    level.player_out_of_playable_area_monitor = false; //disable instant death when entering out of bound area
    //Variables
    level.phase = 0;
    //flag_set( "activate_zone_chamber" ); //activate Agartha zm spawn
    level.mechz_spawners[0].is_enabled = 1;
    //flag_wait("initial_blackscreen_passed");
    //wait 6.1;
    //wait 0.05;
    //wait 1;
    
    replaceFunc(maps\mp\zombies\_zm_ai_mechz::mechz_spawn, scripts\zm\zm_tomb\M\M_zm_ai_mechz::mechz_spawn);
    replaceFunc(maps\mp\zombies\_zm_ai_mechz_ft::player_flame_damage, ::player_flame_damage);
    replaceFunc(maps\mp\zombies\_zm_ai_mechz_claw::claw_grapple, scripts\zm\zm_tomb\M\M_zm_ai_mechz_claw::claw_grapple);
    replaceFunc(maps\mp\zombies\_zm_ai_mechz_claw::check_for_claw_move_complete, scripts\zm\zm_tomb\M\M_zm_ai_mechz_claw::check_for_claw_move_complete);
    replaceFunc(maps\mp\zombies\_zm_ai_mechz_claw::mechz_claw_cleanup, scripts\zm\zm_tomb\M\M_zm_ai_mechz_claw::mechz_claw_cleanup);
    replaceFunc(maps\mp\zombies\_zm_ai_mechz_claw::check_for_players_mid_grapple, scripts\zm\zm_tomb\M\M_zm_ai_mechz_claw::check_for_players_mid_grapple);
    replaceFunc(maps\mp\zombies\_zm_ai_mechz_claw::mechz_zombie_flamethrower_gib, scripts\zm\zm_tomb\M\M_zm_ai_mechz_claw::mechz_zombie_flamethrower_gib);
    replaceFunc(maps\mp\zombies\_zm_ai_mechz_claw::mechz_claw_shot_pain_reaction, scripts\zm\zm_tomb\M\M_zm_ai_mechz_claw::mechz_claw_shot_pain_reaction);
    replaceFunc(maps\mp\zombies\_zm_ai_mechz_claw::mechz_claw_detach, scripts\zm\zm_tomb\M\M_zm_ai_mechz_claw::mechz_claw_detach);
    replaceFunc(maps\mp\zombies\_zm_ai_mechz_claw::mechz_claw_damage_trigger_thread, scripts\zm\zm_tomb\M\M_zm_ai_mechz_claw::mechz_claw_damage_trigger_thread);
    replaceFunc(maps\mp\zombies\_zm_ai_mechz_ft::should_do_flamethrower_attack, ::should_do_flamethrower_attack);//change the flamethrower change above
    replaceFunc(maps\mp\zombies\_zm_ai_mechz_claw::should_do_claw_attack, scripts\zm\zm_tomb\M\M_zm_ai_mechz_claw::should_do_claw_attack);//change the hook distance change in the script its inside
    /*
    level waittill("start_of_round");//dont know if you need it//delete

    wait 0.1;
    */
   // replaceFunc(maps\mp\zombies\_zm::init_levelvars, ::init_levelvars);
    if (level.players.size < 3)//change added 3 player HP
    {
        level.zombie_health = 40000;//NOTES: they feel easy to kill somewhat
    } 
    else if (level.players.size == 3)
    {
        level.zombie_health = 100000;
    }  
    else
    {
        level.zombie_health = 150000;
    }

    wait 0.05;

    //foreach (player in level.players)
    //player playSound( "zmb_ai_mechz_incoming_alarm" );//Boss Summon Sound, these wait times fit well with the boss summon
    playsoundatposition( "zmb_ai_mechz_incoming_alarm", ( 0, 0, 0 ) );
    level thread SUPER_PANZERS_Ivo1();
    
    level thread NoPowerups_Ivo1();

    zombies = GetAIArray(level.zombie_team); // get the zombie array

    //transform the zm into the raid boss
    zombies[0].boss = 1;
    level.boss = zombies[0]; //set the raid boss as a global variable accessible from all code (no need to pass it as parameter)
    level.boss.name = "Panzer Lord";
    level.boss setcandamage( 0 );//prevent boss taking damage
    level.boss.candamage = 0;

    if (level.players.size < 3)//change added 3 player HP
    {
         level.boss.maxhealth = 5000000;//delete
    }
    else if (level.players.size == 3)
    {
        level.boss.maxhealth = 12000000;
    }
    else
    {
        level.boss.maxhealth = 15000000;
    }

    level.boss.health = level.boss.maxhealth;
    level.boss set_zombie_run_cycle("super_sprint");
    level.boss.meleedamage = 2000;//DamFunc
    level.is_boss_spawned = 1;
    level.boss.ignore_nuke = 1;

    level.boss.instakill_func = ::Boss_instakill_Ivo1;
    
    wait 0.05;
    //boss skin
    level.boss setmodel( "c_zom_mech_body", 1 );
    wait 0.05;

    helmet = spawn( "script_model", level.boss.origin );
    helmet linkto( level.boss, "J_Helmet", ( 4, 0, -5 ), ( -20, 0, 0 ));
    wait 0.05;
    helmet setmodel( "c_zom_mech_faceplate" );
    wait 0.05;
    helmet notSolid();

    claw = spawn( "script_model", level.boss.origin );
    claw linkto( level.boss, "J_Wrist_LE", ( 0, 0, 0 ), ( 180, 0, 0));
    wait 0.05;
    claw setmodel( "c_zom_mech_claw");

    level.boss attach( "c_zom_mech_armor_shoulder_right", "J_ShoulderArmor_RI", 0 );
    wait 0.05;

    level.boss attach( "c_zom_mech_armor_shoulder_left", "J_ShoulderArmor_LE", 0 );
    wait 0.05;

    level.boss attach( "c_zom_mech_armor_knee_right", "J_Knee_attach_RI", 0 );
    wait 0.05;

    level.boss attach( "c_zom_mech_armor_knee_left", "J_Knee_attach_LE", 0 );
    wait 0.5;

    playFXOnTag( level._effect["air_puzzle_smoke"], level.boss, "tag_origin");
    wait 0.05;
    
    level.boss thread boss_think_Ivo1(); //call the raid boss attacks loop

    level.boss thread Melee_Aura_ivo1(); //change added


    for (;;)//after killing boss effects and sound//change the working ending function
    {
        if (level.boss.health <= 0 && !level.intermission)//level.end != 0 )
        {
            iPrintLn("^3[ ^1" + level.boss_name + " ^7] : ^3Well done, you lived up to your reputation");
            playsoundatposition( "mus_zombie_game_over_ee", ( 0, 0, 0 ) );
            foreach(player in level.players)
            {
                player thread ending_ivo1();
            }
            wait 3.5;
            iPrintLn("^3[ ^1" + level.boss_name + " ^7] : ^3We will see each other again some other time...");
            for(i = 0; i <= 1000; i++) // find all zombies in the zombie array and kill
            {
                zombies = getaiarray(level.zombie_team);
                zombies[0] dodamage( zombies[0].health + 100, zombies[0].origin);
                wait 0.05;
            }
            break;
        }
        wait 0.05;
    }
}

Melee_Aura_ivo1()//change add
{
    self endon("death");

    for(;;)
    {
        foreach(player in level.players)
        {
            player thread Melee_Aura_Damage_Ivo1();     
        }
        wait 0.1;
    }
}
    

Melee_Aura_Damage_Ivo1()//change add
{
    if (distance(level.boss.origin, self.origin) <= 50) //if close to  //DamFunc
        {
            self dodamage_wrapper(600); // deal damage to self (you gotta run away !) //DamFunc
            vsmgr_activate( "overlay", "zm_transit_burn", self, 1, 1 );//visual burn effect      
            wait 0.05;
            self shellshock( "lava_small", 0.1 );//stun //DamFunc
       }
}

Chat1_ivo1()//change added
{
    iPrintLn("^3[  ???  ^7] : ^3Hmm...I see...");
    wait 3.5;
    iPrintLn("^3[  ???  ^7] : ^3The Keeper of Agartha told me about you...");//PIA Boss reference
    wait 3.5;
    iPrintLn("^3[ ^1" + level.boss_name + " ^7] : ^3Let us see if you are up for the challenge");
}

Boss_instakill_Ivo1()
{
	//iPrintLn("MORE DAMAGE");
	//self dodamage_wrapper(667);
}

ending_Ivo1()
{
    if (self.sessionstate == "playing")
    {
        //self playsound("mus_zombie_game_over_ee");
        //wait 0.05;
        self fadetoblackforxsec( 0, 1, 0.5, 0.5, "white" );
        end = 1;
        return end;
    }
    else //if (self.sessionstate == "spectator" || self.sessionstate == "dead" )
    {
        empty = 0;
    }  
}

SUPER_PANZERS_Ivo1()
{
    //flag_wait("initial_blackscreen_passed");
    
    //level waittill("start_of_round");
    //wait 0.1;
    //panzers health
    if (level.players.size < 3)//change added 3 player HP
    {
        level.mechz_max_health = 60000;//
        level.mechz_base_health = 60000;
    }
    else if (level.players.size == 3)
    {
        level.mechz_max_health = 180000;//
        level.mechz_base_health = 180000;
    }
    else
    {
        level.mechz_max_health = 250000;//
        level.mechz_base_health = 250000;
    }


    level.mechz_health = level.mechz_base_health;
    level.mechz_health_increase = 0;

    //to make sure that there is always room, used for the old way
    level.mechz_zombie_per_round = 1000;
    level.mechz_jump_delay = 0.05;
    //DamFunc
    level.mechz_meleedamage = 1000;//melee
    level.mechz_claw_cooldown_time = 3500;//hook cooldown
    level.mechz_flamethrower_cooldown_time = 2500;//flamethrower cooldown
    level.mechz_aggro_dist_sq = 1225;//change the aggro distance in which the melee gets activated and hook and flamethrower disabled
    level.mechz_flogger_stun_time = 0.1;
    level.mechz_powerplant_stun_time = 0.1;
    level.mechz_explosive_dmg_to_cancel_claw_percentage = 0.1;
}

spawn_panzer()
{
    ai = spawn_zombie( level.mechz_spawners[0] );
    ai.custom_origin = (10314.5, -7889.91, -411.875);
    ai.custom_angle = (0, 0, 0);
    ai thread mechz_spawn();
    return ai;
}


boss_think_Ivo1() // After boss spawned, start the attacks rotation
{
    self endon("death"); //on boss death, stop the script

    wait 10; // let the boss time to get to the middle//change instead of wait 7 its wait 5 and wait 2, 5 + 2 = 7
    level thread Chat2_Ivo1();//<--------//change
    wait 2;//change

    level thread Phase_check1_Ivo1();
    level.boss setcandamage( 1 );//now boss takes damage
    level.boss.candamage = 1;
    for(;;) //start the attack rotation loop
    {
        
        level.boss thread Flamethrower_Easy_Ivo1();//FLAMETHROWER/AURA, DONE.//change names
        wait 15;

        level Phase_Starter_Ivo1();
        
        level.boss thread Electric_Easy_Ivo1();//Electric shot, DONE.
        wait 22;

        level Phase_Starter_Ivo1();
            
        level.boss thread AirStrike_Easy_Ivo1();//ROCKETS Air Strike, DONE.
        wait 15; 

        level Phase_Starter_Ivo1();
                
        level.boss thread Wipe_Easy_Ivo1();//Wipe Attack DONE.
        wait 15;

        level Phase_Starter_Ivo1();
    }
}

Chat2_Ivo1()//change added more dialogue
{
    iPrintLn("^3[ ^1" + level.boss_name + " ^7] : ^3The flames consume ALL...");
    wait 15;
    iPrintLn("^3[ ^1" + level.boss_name + " ^7] : ^3Don't stop moving, Dance for me");
    wait 22;
    iPrintLn("^3[ ^1" + level.boss_name + " ^7] : ^3There is NO escaping the rockets");
    wait 15;
    iPrintLn("^3[ ^1" + level.boss_name + " ^7] : ^3Protect yourself or else...");
}

Flamethrower_Easy_Ivo1()
{
    self endon("death");
    //setting fire aura, might also add boss being set on flames too
    fire_aura = spawn( "script_model", level.boss.origin );
    fire_aura linkto( level.boss, "tag_origin" );
    fire_aura setmodel( "tag_origin" );    
    wait 0.05;

    playfxontag( level._effect["fire_sacrifice_flame"], fire_aura, "tag_origin" );
    playfxontag( level._effect["wagon_fire"], fire_aura, "tag_origin" );
    
    wait 1;

    level.boss playsound( "zmb_ai_mechz_flame_start" );//flame sounds to match panzer sounds
    level.boss playloopsound( "zmb_ai_mechz_flame_loop", 0.6 );
    //
    
    for (i = 0; i <= 7 ; i++)
    {
        //where the flames come from
        playfxontag( level._effect["wagon_fire"], fire_aura, "tag_origin" );
        playfxontag( level._effect["fire_sacrifice_flame"], fire_aura, "tag_origin" );
        playfxontag( level._effect["mech_wpn_flamethrower"], level.boss, "tag_origin" );
        playfxontag( level._effect["mech_wpn_flamethrower"], level.boss, "J_Root_Attach_LE" );
        playfxontag( level._effect["mech_wpn_flamethrower"], level.boss, "J_Root_Attach_RI" );
        playfxontag( level._effect["mech_wpn_flamethrower"], level.boss, "J_spinelower" );  

        foreach(player in level.players)
        {
            player thread BURN_ALL_Ivo1();     
        }
        wait 0.75;
    }
    
    level.boss StopLoopSound();
    wait 2;
    fire_aura delete();

}

BURN_ALL_Ivo1()
{
    if (distance(level.boss.origin, self.origin) <= 325) //if close to boss 
        {
            self dodamage_wrapper(400); // deal damage to self (you gotta run away !) //DamFunc
            vsmgr_activate( "overlay", "zm_transit_burn", self, 2, 2 );//visual burn effect      
            wait 0.05;
            self shellshock( "lava_small", 0.1 );//stun
       }
}


Electric_Easy_Ivo1()
{
    self endon("death");
    elec_aura = spawn( "script_model", level.boss.origin );
    elec_aura linkto( level.boss, "tag_origin" );
    elec_aura setmodel( "tag_origin" ); 
    //Electric aura
    playfxontag( level._effect["tesla_elec_kill"], elec_aura, "tag_origin" );
    playfxontag( level._effect["fx_tomb_probe_elec_on"], elec_aura, "tag_origin" );
    wait 0.05;
    playfxontag( level._effect["electric_cherry_explode"], elec_aura, "tag_origin" );
    level.boss playsound("zmb_cherry_explode");
    foreach(player in level.players)
        {
            player thread Cherry_Boom_Ivo1();
        }
    wait 0.05;
    playfxontag( level._effect["tesla_elec_kill"], elec_aura, "tag_origin" );
    wait 2;
    playfxontag( level._effect["electric_cherry_explode"], elec_aura, "tag_origin" );
    level.boss playsound("zmb_cherry_explode");
    foreach(player in level.players)
        {
            player thread Cherry_Boom_Ivo1();     
        }
    playfxontag( level._effect["tesla_elec_kill"], elec_aura, "tag_origin" );
    shoot_bolt_Ivo1();
    wait 0.3; //DamFunc for all shoot wait
    shoot_bolt_Ivo1();
    wait 0.3; 
    shoot_bolt_Ivo1();
    wait 0.3;
    shoot_bolt_Ivo1();
    wait 0.3;
    playfxontag( level._effect["tesla_elec_kill"], elec_aura, "tag_origin" );
    wait 1;
    playfxontag( level._effect["tesla_elec_kill"], elec_aura, "tag_origin" );
    playfxontag( level._effect["electric_cherry_explode"], elec_aura, "tag_origin" );
    level.boss playsound("zmb_cherry_explode");
    foreach(player in level.players)
        {
            player thread Cherry_Boom_Ivo1(); 
        }
    shoot_bolt_Ivo1();
    wait 0.3;
    shoot_bolt_Ivo1();
    wait 0.3;
    shoot_bolt_Ivo1();
    wait 0.3;
    shoot_bolt_Ivo1();
    wait 0.3;
    playfxontag( level._effect["tesla_elec_kill"], elec_aura, "tag_origin" );
    wait 1;
    playfxontag( level._effect["tesla_elec_kill"], elec_aura, "tag_origin" );
    playfxontag( level._effect["electric_cherry_explode"], elec_aura, "tag_origin" );
    level.boss playsound("zmb_cherry_explode");
    foreach(player in level.players)
        {
            player thread Cherry_Boom_Ivo1(); 
        }
    shoot_bolt_Ivo1();
    wait 0.3;
    shoot_bolt_Ivo1();
    wait 0.3;
    shoot_bolt_Ivo1();
    wait 0.3;
    shoot_bolt_Ivo1();
    wait 0.3;
    playfxontag( level._effect["tesla_elec_kill"], elec_aura, "tag_origin" );
    wait 1;
    playfxontag( level._effect["tesla_elec_kill"], elec_aura, "tag_origin" );
    playfxontag( level._effect["electric_cherry_explode"], elec_aura, "tag_origin" );
    level.boss playsound("zmb_cherry_explode");
    foreach(player in level.players)
        {
            player thread Cherry_Boom_Ivo1(); 
        }
    shoot_bolt_Ivo1();
    wait 0.3;
    shoot_bolt_Ivo1();
    wait 0.3;
    shoot_bolt_Ivo1();
    wait 0.3;
    shoot_bolt_Ivo1();
    wait 0.3;
    playfxontag( level._effect["tesla_elec_kill"], elec_aura, "tag_origin" );
    wait 1.5;
    elec_aura delete();
}

Cherry_Boom_Ivo1()
{
    if (distance(level.boss.origin, self.origin) < 330) //if close to boss
        {
            self dodamage_wrapper(1000); // deal damage to self (you gotta run away !) //DamFunc
            wait 0.05;
            self shellshock( "lava_small", 0.1 );//stun
        }
}

shoot_bolt_Ivo1()
{
    r = randomint(level.players.size);
    if (!level.players[r] maps\mp\zombies\_zm_laststand::player_is_in_laststand() && level.players[r].sessionstate == "playing")
    {
        target = level.players[r];
        //target add_to_player_score(100);
    }

    else //if (level.players[r] maps\mp\zombies\_zm_laststand::player_is_in_laststand())
    {
        return shoot_bolt_Ivo1();
    }
    

    source_pos = level.boss gettagorigin( "J_Helmet" );
    target_pos = target geteye();

    bolt = spawn( "script_model", source_pos );
    bolt setmodel( "tag_origin" );
    wait 0.1; //DamFunc

    fx = playfxontag( level._effect["qd_revive"], bolt, "tag_origin" );
    bolt moveto( target_pos, 0.2 );
    bolt waittill( "movedone" );
    bolt.owner = self;
    bolt check_bolt_impact( target );
    bolt delete();//wpn_revivestaff_revive_plr
}

check_bolt_impact( target )
{
    if ( is_player_valid( target ))
    {
        target_eye_pos = target geteye();
        dist_sq = distancesquared( self.origin, target_eye_pos );

        if ( dist_sq < 4096 )
        {
            passed = bullettracepassed( self.origin, target_eye_pos, 0, undefined );

            if ( passed )
            {
                target dodamage_wrapper(500); //DamFunc
                vsmgr_activate( "overlay", "zm_transit_burn", target, 1, 1 );
                wait 0.05;
                target shellshock( "lava_small", 0.1 );//stun
                target playsoundtoplayer( "wpn_revivestaff_proj_impact", target );
                
            }
        }
    }
}


AirStrike_Easy_Ivo1()
{
    self endon("death");
    LaunchPlace = spawn( "script_model", level.boss.origin );
    LaunchPlace linkto( level.boss, "tag_origin", (0, 0, 0), (-90, -90, -90));
    LaunchPlace setmodel( "tag_origin" ); 

    self playsound( "zmb_homingbeacon_missiile_alarm" );
    wait 0.05;

    foreach(player in level.players)
        {
            player thread BombStun_Ivo1();
        }
        
    playfxontag( level._effect["beacon_launch_fx"], LaunchPlace, ( "tag_origin" ) );//ROCKET LAUNCH fx, need to aim at at up
    self playsound( "zmb_homingbeacon_missile_fire" );
     
    wait 0.7;

    foreach(player in level.players) 
        {
            player thread BombStun_Ivo1();
        }

    playfxontag( level._effect["beacon_launch_fx"], LaunchPlace, ( "tag_origin" ) );//ROCKET LAUNCH
    self playsound( "zmb_homingbeacon_missile_fire" );
     
    wait 0.7;

    foreach(player in level.players) 
        {
            player thread BombStun_Ivo1();
        }

    playfxontag( level._effect["beacon_launch_fx"], LaunchPlace, ( "tag_origin" ) );//ROCKET LAUNCH
    self playsound( "zmb_homingbeacon_missile_fire" );
     
    wait 0.7;

    foreach(player in level.players) 
        {
            player thread BombStun_Ivo1();
        }

    playfxontag( level._effect["beacon_launch_fx"], LaunchPlace, ( "tag_origin" ) );//ROCKET LAUNCH
    self playsound( "zmb_homingbeacon_missile_fire" );
    
    
    waitrandom = randomFloatRange( 2.3 , 5.1 );
    //iPrintLn(waitrandom);
    wait waitrandom;

    foreach (player in level.players)
    {
        player thread BombBoom_Ivo1();
    }

}

BombStun_Ivo1()
{
    self shellshock( "lava_small", 0.8 );//stun for each rocket launch
}

BombBoom_Ivo1()
{
    if (!self maps\mp\zombies\_zm_laststand::player_is_in_laststand() && self.sessionstate == "playing")
        {
            self playsound( "zmb_homingbeacon_missile_incoming" );// small window to activate Tank effect
            wait 1;
            self dodamage_wrapper(1800); // Rocket Damage //DamFunc
            playfxontag( level._effect["beacon_shell_explosion"], self, "tag_origin" );//ROCKET BOOM
            self playsound( "zmb_homingbeacon_missile_impact" );
            wait 0.05;
            self shellshock( "frag_grenade_mp", 2 );//stun
        }
}


Wipe_Easy_Ivo1()
{
    self endon("death");

    //teleport boss to center and give immunity
    level.boss setanimstatefromasd("zm_idle");
    level.boss forceteleport(level.boss.origin + (0, 0, -500));
    wait 0.05;
    level.boss forceteleport(level.center_spawn_origin + (0, 0, -500));
    wait 0.05;
    level.boss forceteleport(level.center_spawn_origin);

    beam = spawn( "script_model", level.boss.origin );
    beam linkto( level.boss, "tag_origin" );
    beam setmodel( "tag_origin" ); 
    wait 0.05;
    playfxontag( level._effect["ee_beam"], beam, "tag_origin" );

    vortex = spawn( "script_model", level.boss.origin );
    vortex linkto( level.boss, "tag_origin", ( 0, 0, 225) );
    vortex setmodel( "tag_origin" ); 
    
    level.boss setanimstatefromasd("zm_idle");//so boss stay in center
    level.boss set_zombie_run_cycle("super_sprint");//so boss stay in center
    wait 0.05;
    level.boss setanimstatefromasd("zm_idle");
    playFXOnTag( level._effect["ee_vortex"], vortex, "tag_origin");
    level.boss setcandamage( 0 );//prevent boss taking damage
    level.boss.candamage = 0;
    level.boss setanimstatefromasd("zm_idle");
    wait 0.5;
    level.boss setanimstatefromasd("zm_idle");
    setdvar( "g_ai", "0" );
    level.boss thread Floating_Ivo1();

    foreach( player in level.players)
    {
        player playlocalsound( level.zmb_laugh_alias );//so they know the attack started
        player allowcrouch( 1 );//crouch and prone disabled for the entire boss fight,
        player allowprone( 1 );//only enabled during the attack.
        player thread Safe_Zone_Ivo1();
    }
    
    wait 7;//DamFunc
    foreach (player in level.players)//wipe or stay alive 
    {
        player Dead_or_Alive_Ivo1();
        if (level.dead != 0)
        {
            foreach (player in level.players)
            {
                player thread Dead_Ivo1();
            }
        }
    }
  //  if (level.dead != 0)
  //  wait 3;

    level.dead = 0;
    
    level.boss forceteleport(level.center_spawn_origin);
    setdvar( "g_ai", "1" );
    level.boss setcandamage( 1 );
    level.boss.candamage = 1;
    level.boss set_zombie_run_cycle("super_sprint");
    wait 0.05;

    vortex delete();
    beam delete();
    
    foreach( player in level.players)
    {
        player allowcrouch( 0 );//no crouch or prone allowed in my boss fight
        player allowprone( 0 );//they only get crouch and prone during wipe attack
        //vsmgr_deactivate( "overlay", "zm_powerup_zombie_blood_overlay", player);
    }
}

Safe_Zone_Ivo1()
{
    for (i = 0; i <= 140; i++)// Visual zombie blood effect to know you are in position //DamFunc
    {
        if ((distance(level.ice, self.origin) < 25) || (distance(level.fire, self.origin) < 25) || (distance(level.wind, self.origin) < 25) || (distance(level.lightning, self.origin) < 25))
            vsmgr_activate( "overlay", "zm_powerup_zombie_blood_overlay", self);
        else
            vsmgr_deactivate( "overlay", "zm_powerup_zombie_blood_overlay", self);
        wait 0.05;
    }
    vsmgr_deactivate( "overlay", "zm_powerup_zombie_blood_overlay", self);
}

Dead_or_Alive_Ivo1()
{
    //stance = self getstance();
    //if (stance == "prone")
        if (((distance(level.ice, self.origin) < 25) || (distance(level.fire, self.origin) < 25) || (distance(level.wind, self.origin) < 25) || (distance(level.lightning, self.origin) < 25)))
        {
            
            //iPrintLn("Alive!");
            //continue;
        }
        else if (self.sessionstate != "spectator" && !(self maps\mp\zombies\_zm_laststand::player_is_in_laststand()))
        {
            //iPrintLn("Dead...");
            level.dead++;
            //return dead;
        }
}

Dead_Ivo1()
{
    iPrintLnBold("^1Death Awaits...");
    playfxontag( level._effect["ee_beam"], self, "tag_origin" );
    wait 0.05;
    
    playFXOnTag( level._effect["ee_vortex"], self, "tag_origin");
    

    setdvar( "timescale", "0.6" );
    for (i = 0; i <= 2; i++)
    {
        self playlocalsound( level.zmb_laugh_alias );
        wait 0.7;
        self doDamage_wrapper(self.health + 10000);
        setdvar( "timescale", "1" );
    }
}

Floating_Ivo1()
{
    for(i=0;i<120;i++)
    {
        level.boss.origin = level.boss.origin + ( 0, 0, 1 );
        wait 0.05;
    }
    
}

//Phases
Phase_Starter_Ivo1()
{
    if (level.phase == 1)
    {
        level.boss thread IvoPhase1_H1_Ivo1();
        wait 0.05;
        level.boss setcandamage( 0 );
        level.boss.candamage = 0;
        level.phase++;
        for (;;)
        {
            if (isdefined(level.boss.should_return) && level.boss.should_return == 1)
                break;
            wait 0.5;
        }
        wait 3;
    }
}

IvoPhase1_H1_Ivo1()//60
{
    level.boss ForceTeleport(( 2754.93, 5402.57, -358.25 ));
    
    wait 1;

    level.zombie_total += 4;

    for(;;)
    {
        if (isdefined(level.inferno1) && isdefined(level.inferno2) && isdefined(level.electric1) && isdefined(level.electric2))
            break;
        zombies = GetAIArray(level.zombie_team);
        foreach(zombie in zombies)
        {
            if (isdefined(zombie.boss))
                continue;
            if (zombie && zombie.completed_emerging_into_playable_area == 1 && !isdefined(zombie.miniboss))
            {
                zombie.miniboss = 1;
                if (!isdefined(level.inferno1))
                {
                    level.inferno1 = zombie;
                    level.inferno1 thread Infernos1_Ivo1();
                }
                else if (!isdefined(level.inferno2))
                {
                    level.inferno2 = zombie;
                    level.inferno2 thread Infernos2_Ivo1();
                }
                else if (!isdefined(level.electric1))
                {
                    level.electric1 = zombie;
                    level.electric1 thread Electrics1_Ivo1();
                }
                else if (!isdefined(level.electric2))
                {
                    level.electric2 = zombie;
                    level.electric2 thread Electrics2_Ivo1();
                }
            }
        }
        wait 1;
    }
    
    wait 20;
    iPrintLn("^3[ ^1" + level.boss_name + " ^7] : ^3Helmets ON lads");// Botb Boss Reference
    wait 2;
    level thread spawn_panzer();
    level thread spawn_panzer();

    for(;;)//change added the panzer aura function
    {
        if (isdefined(level.Mechz_inferno1) && isdefined(level.Mechz_inferno2))
            break;
        zombies = GetAIArray(level.zombie_team);
        foreach(zombie in zombies)
        {
            if (isdefined(zombie.boss))
                continue;
            if (zombie && zombie.completed_emerging_into_playable_area == 1 && !isdefined(zombie.miniboss) && isDefined(zombie.is_mechz) && zombie.is_mechz)
            {
                zombie.miniboss = 1;
                if (!isdefined(level.Mechz_inferno1))
                {
                    level.Mechz_inferno1 = zombie;
                    level.Mechz_inferno1 thread Mechz_infernos1();
                }
                else if (!isdefined(level.Mechz_inferno2))
                {
                    level.Mechz_inferno2 = zombie;
                    level.Mechz_inferno2 thread Mechz_infernos2();
                }
            }
        }
        wait 1;
    }

    for(;;)
    {
        zombies = getaiarray(level.zombie_team);
        if (zombies.size == 1)
            break;
        wait 0.5;
    }
    level.boss.should_return = 1;
    random = level.places[randomint(level.places.size)];
    level.boss ForceTeleport(random);
    level.boss setcandamage( 1 );
    level.boss.candamage = 1;
    //iPrintLn("end phase 1");
}

Infernos1_Ivo1()
{
    self endon("death");
    iPrintLn("^3[ ^1" + level.boss_name + " ^7] : ^3INFERNOS COME FOURTH!");
    //self ForceTeleport(level.Ice);
    self set_zombie_run_cycle("super_sprint");
    //skin
    self setmodel( "c_zom_tomb_german_body_1a" );
    self.headmodel = codescripts\character::randomelement( xmodelalias\c_zom_tomb_german_head_als::main() );
    self attach( self.headmodel, "", 1 );
    self.hatmodel = "c_zom_tomb_german_hat_1";
    self attach( self.hatmodel );
    self.voice = "american";
    self.skeleton = "base";
    self.torsodmg1 = "c_zom_tomb_german_body_g_upclean_1a";
    self.torsodmg2 = "c_zom_tomb_german_body_g_rarm_1a";
    self.torsodmg3 = "c_zom_tomb_german_body_g_larm_1a";
    self.torsodmg5 = "c_zom_tomb_german_body_g_behead";
    self.legdmg1 = "c_zom_tomb_german_body_g_lowclean_1a";
    self.legdmg2 = "c_zom_tomb_german_body_g_rleg_1a";
    self.legdmg3 = "c_zom_tomb_german_body_g_lleg_1a";
    self.legdmg4 = "c_zom_tomb_german_body_g_legsoff_1a";
    self.gibspawn1 = "c_zom_buried_g_rarmspawn";
    self.gibspawntag1 = "J_Elbow_RI";
    self.gibspawn2 = "c_zom_buried_g_larmspawn";
    self.gibspawntag2 = "J_Elbow_LE";
    self.gibspawn3 = "c_zom_buried_g_rlegspawn";
    self.gibspawntag3 = "J_Knee_RI";
    self.gibspawn4 = "c_zom_buried_g_llegspawn";
    self.gibspawntag4 = "J_Knee_LE";
    self.gibspawn5 = "c_zom_tomb_german_hat_1";
    self.gibspawntag5 = "J_Head";
    self.custom_item_dmg = 100000;
    wait 3;
    for (;;)
    {
        self setclientfield( "fire_char_fx", 1 );
        playfxontag( level._effect["wagon_fire"], level.inferno1, "tag_origin" );

       // playfxontag( level._effect["fire_sacrifice_flame"], level.inferno1, "J_Wrist_LE" );

        playfxontag( level._effect["wagon_fire"], level.inferno1, "J_Wrist_RI" );

       // playfxontag( level._effect["fire_sacrifice_flame"], level.inferno1, "J_spinelower" );
        
        foreach(player in level.players)
        {
            player thread Inferno_BURN1_Ivo1();     
        }
        wait 1;
        self setclientfield( "fire_char_fx", 0 );
        wait 0.05;
    }
}

Inferno_BURN1_Ivo1()
{
    if (distance(level.inferno1.origin, self.origin) <= 210) //if close to boss //DamFunc
        {
            self dodamage_wrapper(600); // deal damage to self (you gotta run away !) //DamFunc
            vsmgr_activate( "overlay", "zm_transit_burn", self, 1, 1 );//visual burn effect      
            wait 0.05;
            self shellshock( "lava_small", 0.1 );//stun //DamFunc
       }
}

Infernos2_Ivo1()
{
    self endon("death");
    //self ForceTeleport(level.Fire);
    self set_zombie_run_cycle("super_sprint");
    //skin
    self setmodel( "c_zom_tomb_german_body_1b" );
    self.headmodel = codescripts\character::randomelement( xmodelalias\c_zom_tomb_german_head_als::main() );
    self attach( self.headmodel, "", 1 );
    self.hatmodel = "c_zom_tomb_german_hat_2";
    self attach( self.hatmodel );
    self.voice = "american";
    self.skeleton = "base";
    self.torsodmg1 = "c_zom_tomb_german_body_g_upclean_1b";
    self.torsodmg2 = "c_zom_tomb_german_body_g_rarm_1b";
    self.torsodmg3 = "c_zom_tomb_german_body_g_larm_1b";
    self.torsodmg5 = "c_zom_tomb_german_body_g_behead";
    self.legdmg1 = "c_zom_tomb_german_body_g_lowclean_1b";
    self.legdmg2 = "c_zom_tomb_german_body_g_rleg_1b";
    self.legdmg3 = "c_zom_tomb_german_body_g_lleg_1b";
    self.legdmg4 = "c_zom_tomb_german_body_g_legsoff_1b";
    self.gibspawn1 = "c_zom_buried_g_rarmspawn";
    self.gibspawntag1 = "J_Elbow_RI";
    self.gibspawn2 = "c_zom_buried_g_larmspawn";
    self.gibspawntag2 = "J_Elbow_LE";
    self.gibspawn3 = "c_zom_buried_g_rlegspawn";
    self.gibspawntag3 = "J_Knee_RI";
    self.gibspawn4 = "c_zom_buried_g_llegspawn";
    self.gibspawntag4 = "J_Knee_LE";
    self.gibspawn5 = "c_zom_tomb_german_hat_2";
    self.gibspawntag5 = "J_Head";
    self.custom_item_dmg = 100000;
    wait 3;
    for (;;)
    {
        self setclientfield( "fire_char_fx", 1 );
        playfxontag( level._effect["wagon_fire"], level.inferno2, "tag_origin" );

       // playfxontag( level._effect["fire_sacrifice_flame"], level.inferno2, "J_Wrist_LE" );

        playfxontag( level._effect["wagon_fire"], level.inferno2, "J_Wrist_RI" );

       // playfxontag( level._effect["fire_sacrifice_flame"], level.inferno2, "J_spinelower" );
        
        foreach(player in level.players)
        {
            player thread Inferno_BURN2_Ivo1();     
        }
        wait 1;
        self setclientfield( "fire_char_fx", 0 );
        wait 0.05;
    }
}

Inferno_BURN2_Ivo1()
{
    if (distance(level.inferno2.origin, self.origin) <= 210) //if close to boss //DamFunc
        {
            self dodamage_wrapper(600); // deal damage to self (you gotta run away !) //DamFunc
            vsmgr_activate( "overlay", "zm_transit_burn", self, 1, 1 );//visual burn effect      
            wait 0.05;
            self shellshock( "lava_small", 0.1 );//stun //DamFunc
       }
}


Electrics1_Ivo1()
{
    self endon("death");
    //self ForceTeleport(level.Ice);
    self set_zombie_run_cycle("super_sprint");
    //skin
    self setmodel( "c_zom_tomb_german_body_1a" );
    self.headmodel = codescripts\character::randomelement( xmodelalias\c_zom_tomb_german_head_als::main() );
    self attach( self.headmodel, "", 1 );
    self.hatmodel = "c_zom_tomb_german_hat_1";
    self attach( self.hatmodel );
    self.voice = "american";
    self.skeleton = "base";
    self.torsodmg1 = "c_zom_tomb_german_body_g_upclean_1a";
    self.torsodmg2 = "c_zom_tomb_german_body_g_rarm_1a";
    self.torsodmg3 = "c_zom_tomb_german_body_g_larm_1a";
    self.torsodmg5 = "c_zom_tomb_german_body_g_behead";
    self.legdmg1 = "c_zom_tomb_german_body_g_lowclean_1a";
    self.legdmg2 = "c_zom_tomb_german_body_g_rleg_1a";
    self.legdmg3 = "c_zom_tomb_german_body_g_lleg_1a";
    self.legdmg4 = "c_zom_tomb_german_body_g_legsoff_1a";
    self.gibspawn1 = "c_zom_buried_g_rarmspawn";
    self.gibspawntag1 = "J_Elbow_RI";
    self.gibspawn2 = "c_zom_buried_g_larmspawn";
    self.gibspawntag2 = "J_Elbow_LE";
    self.gibspawn3 = "c_zom_buried_g_rlegspawn";
    self.gibspawntag3 = "J_Knee_RI";
    self.gibspawn4 = "c_zom_buried_g_llegspawn";
    self.gibspawntag4 = "J_Knee_LE";
    self.gibspawn5 = "c_zom_tomb_german_hat_1";
    self.gibspawntag5 = "J_Head";
    self.custom_item_dmg = 100000;
    wait 3;
    for (;;)
    {
        self setclientfield( "lightning_arc_fx", 1 );
        playfxontag( level._effect["tesla_elec_kill"], level.electric1, "tag_origin" );

       // playfxontag( level._effect["fire_sacrifice_flame"], level.electric1, "J_Wrist_LE" );

        playfxontag( level._effect["electric_cherry_explode"], level.electric1, "tag_origin" );

       // playfxontag( level._effect["fire_sacrifice_flame"], level.electric1, "J_spinelower" );
        level.electric1 playsound("zmb_cherry_explode");
        foreach(player in level.players)
        {
            player thread Electric_Shot1_Ivo1();
            player thread Phase_Cherry1_Ivo1();   
        }
        wait 4;
        self setclientfield( "lightning_arc_fx", 0 );
        wait 0.05;
    }
}

Electric_Shot1_Ivo1()
{
    r = randomint(level.players.size);
    if (!level.players[r] maps\mp\zombies\_zm_laststand::player_is_in_laststand() && level.players[r].sessionstate == "playing")
    {
        target = level.players[r];
        //target add_to_player_score(100);
    }

    else //if (level.players[r] maps\mp\zombies\_zm_laststand::player_is_in_laststand())
    {
        return Electric_Shot1_Ivo1();
    }
    

    source_pos = level.electric1 gettagorigin( "J_Helmet" );
    target_pos = target geteye();

    bolt = spawn( "script_model", source_pos );
    bolt setmodel( "tag_origin" );
    wait 0.1; //DamFunc

    fx = playfxontag( level._effect["qd_revive"], bolt, "tag_origin" );
    bolt moveto( target_pos, 0.3 );
    bolt waittill( "movedone" );
    bolt.owner = self;
    bolt check_bolt_impactPhase_Ivo1( target );
    bolt delete();//wpn_revivestaff_revive_plr
}

Phase_Cherry1_Ivo1()
{
    if (distance(level.electric1.origin, self.origin) < 200) //if close to boss
        {
            self dodamage_wrapper(300); // deal damage to self (you gotta run away !)
            wait 0.05;
            self shellshock( "lava_small", 0.1 );//stun //DamFunc
        }
}

Electrics2_Ivo1()
{
    self endon("death");
    iPrintLn("^3[ ^1" + level.boss_name + " ^7] : ^3Let's up the voltage ^1:)");// Titb Boss reference
    //self ForceTeleport(level.Fire);
    self set_zombie_run_cycle("super_sprint");
    //skin
    self setmodel( "c_zom_tomb_german_body_1b" );
    self.headmodel = codescripts\character::randomelement( xmodelalias\c_zom_tomb_german_head_als::main() );
    self attach( self.headmodel, "", 1 );
    self.hatmodel = "c_zom_tomb_german_hat_2";
    self attach( self.hatmodel );
    self.voice = "american";
    self.skeleton = "base";
    self.torsodmg1 = "c_zom_tomb_german_body_g_upclean_1b";
    self.torsodmg2 = "c_zom_tomb_german_body_g_rarm_1b";
    self.torsodmg3 = "c_zom_tomb_german_body_g_larm_1b";
    self.torsodmg5 = "c_zom_tomb_german_body_g_behead";
    self.legdmg1 = "c_zom_tomb_german_body_g_lowclean_1b";
    self.legdmg2 = "c_zom_tomb_german_body_g_rleg_1b";
    self.legdmg3 = "c_zom_tomb_german_body_g_lleg_1b";
    self.legdmg4 = "c_zom_tomb_german_body_g_legsoff_1b";
    self.gibspawn1 = "c_zom_buried_g_rarmspawn";
    self.gibspawntag1 = "J_Elbow_RI";
    self.gibspawn2 = "c_zom_buried_g_larmspawn";
    self.gibspawntag2 = "J_Elbow_LE";
    self.gibspawn3 = "c_zom_buried_g_rlegspawn";
    self.gibspawntag3 = "J_Knee_RI";
    self.gibspawn4 = "c_zom_buried_g_llegspawn";
    self.gibspawntag4 = "J_Knee_LE";
    self.gibspawn5 = "c_zom_tomb_german_hat_2";
    self.gibspawntag5 = "J_Head";
    self.custom_item_dmg = 100000;
    wait 3;
    for (;;)
    {
        self setclientfield( "lightning_arc_fx", 1 );
        playfxontag( level._effect["tesla_elec_kill"], level.electric2, "tag_origin" );

       // playfxontag( level._effect["fire_sacrifice_flame"], level.electric2, "J_Wrist_LE" );

        playfxontag( level._effect["electric_cherry_explode"], level.electric2, "tag_origin" );

       // playfxontag( level._effect["fire_sacrifice_flame"], level.electric2, "J_spinelower" );
        level.electric2 playsound("zmb_cherry_explode");
        foreach(player in level.players)
        {
            player thread Electric_Shot2_Ivo1(); 
            player thread Phase_Cherry2_Ivo1();    
        }
        wait 4;
        self setclientfield( "lightning_arc_fx", 0 );
        wait 0.05;
    }
}

Electric_Shot2_Ivo1()
{
    r = randomint(level.players.size);
    if (!level.players[r] maps\mp\zombies\_zm_laststand::player_is_in_laststand() && level.players[r].sessionstate == "playing")
    {
        target = level.players[r];
        //target add_to_player_score(100);
    }

    else //if (level.players[r] maps\mp\zombies\_zm_laststand::player_is_in_laststand())
    {
        return Electric_Shot2_Ivo1();
    }
    

    source_pos = level.electric2 gettagorigin( "J_Helmet" );
    target_pos = target geteye();

    bolt = spawn( "script_model", source_pos );
    bolt setmodel( "tag_origin" );
    wait 0.1; //DamFunc

    fx = playfxontag( level._effect["qd_revive"], bolt, "tag_origin" );
    bolt moveto( target_pos, 0.3 );
    bolt waittill( "movedone" );
    bolt.owner = self;
    bolt check_bolt_impactPhase_Ivo1( target );
    bolt delete();//wpn_revivestaff_revive_plr
}

Phase_Cherry2_Ivo1()
{
    if (distance(level.electric2.origin, self.origin) < 200) //if close to boss
        {
            self dodamage_wrapper(300); // deal damage to self (you gotta run away !)
            wait 0.05;
            self shellshock( "lava_small", 0.1 );//stun //DamFunc
        }
}

check_bolt_impactPhase_Ivo1( target )
{
    if ( is_player_valid( target ))
    {
        target_eye_pos = target geteye();
        dist_sq = distancesquared( self.origin, target_eye_pos );

        if ( dist_sq < 4096 )
        {
            passed = bullettracepassed( self.origin, target_eye_pos, 0, undefined );

            if ( passed )
            {
                target dodamage_wrapper(400); //DamFunc
                vsmgr_activate( "overlay", "zm_transit_burn", target, 2, 2 );
                wait 0.05;
                target shellshock( "lava_small", 0.1 );//DamFunc
                target playsoundtoplayer( "wpn_revivestaff_proj_impact", target );
                
            }
        }
    }
}

Mechz_infernos1()//change add
{
    self endon("death");

    for(;;)
    {
        foreach(player in level.players)
        {
            player thread Mechz_BURN1_Ivo1();     
        }
        wait 0.1;
    }
}
    

Mechz_BURN1_Ivo1()//change add
{
    if (distance(level.Mechz_inferno1.origin, self.origin) <= 40) //if close to  //DamFunc
        {
            self dodamage_wrapper(600); // deal damage to self (you gotta run away !) //DamFunc
            vsmgr_activate( "overlay", "zm_transit_burn", self, 1, 1 );//visual burn effect      
            wait 0.05;
            self shellshock( "lava_small", 0.1 );//stun //DamFunc
       }
}

Mechz_infernos2()//change add
{
    self endon("death");

    for(;;)
    {
        foreach(player in level.players)
        {
            player thread Mechz_BURN2_Ivo1();     
        }
        wait 0.1;
    }
}
    

Mechz_BURN2_Ivo1()//change add
{
    if (distance(level.Mechz_inferno2.origin, self.origin) <= 40) //if close to  //DamFunc
        {
            self dodamage_wrapper(600); // deal damage to self (you gotta run away !) //DamFunc
            vsmgr_activate( "overlay", "zm_transit_burn", self, 1, 1 );//visual burn effect      
            wait 0.05;
            self shellshock( "lava_small", 0.1 );//stun //DamFunc
       }
}

Phase_check1_Ivo1()
{
    for (;;)
    {
        if (level.boss.health <= level.boss.maxhealth * 0.33)//33% HP
        {
            level.boss setcandamage( 0 );
            level.boss.candamage = 0;
            level.phase = 1;
            iPrintLn("^3[ ^1" + level.boss_name + " ^7] : ^3Let's see how you handle this !");// Botb Boss Reference
            break;
        } 
        wait 0.05;
    }
}
