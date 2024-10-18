#include maps\mp\zombies\_zm_magicbox;
#include maps\mp\zombies\_zm_zonemgr;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\animscripts\zm_utility;
#include maps\mp\zombies\_zm_ai_brutus;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\animscripts\zm_shared;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zm_alcatraz_utility;
#include maps\mp\zombies\_zm_ai_basic;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\animscripts\shared;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zombies\_zm_weap_riostshield_prison;
#include maps\mp\animscripts\zm_death;
#include maps\mp\zombies\_zm_perks;
#include maps\mp\zombies\_zm_craftables;
#include maps\mp\zm_alcatraz_sq;
#include maps\mp\gametypes_zm\_zm_gametype;

#include maps\mp\_ambientpackage;
#include maps\mp\zombies\_zm_sidequests;

#include maps\_utility;
#include maps\_vehicle;
#include maps\mp\zombies\_zm_afterlife;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_hud;

#include maps\mp\zombies\_zm_pers_upgrades_system;
#include maps\mp\zombies\_zm_pers_upgrades;
#include maps\mp\zombies\_zm_pers_upgrades_functions;
#include scripts\AATs_Perks;
#include maps\mp\_visionset_mgr;
#include character\c_zom_cellbreaker;
#include maps\mp\zombies\_zm;

#include maps\mp\zm_tomb;
#include maps\mp\zm_tomb_distance_tracking;
#include maps\mp\zombies\_zm_perk_electric_cherry;

#include scripts\zm\zm_tomb\boss_kiels1;
#include scripts\zm\zm_tomb\boss_ivo1;
main()
{
    replacefunc(maps\mp\zombies\_zm_laststand::revive_do_revive, ::revive_do_revive_custom);
    replacefunc(maps\mp\zm_tomb::tomb_round_spawn_failsafe, ::tomb_round_spawn_failsafe_custom);
    replacefunc(maps\mp\zombies\_zm_spawner::zombie_damage_failsafe, ::zombie_damage_failsafe_custom);
    replacefunc(maps\mp\zm_tomb_distance_tracking::delete_zombie_noone_looking , ::delete_zombie_noone_looking_custom);
    replacefunc(maps\mp\zombies\_zm_perk_electric_cherry::electric_cherry_stun, ::electric_cherry_stun_custom);
}

electric_cherry_stun_custom()
{
    self endon( "death" );
    self notify( "stun_zombie" );
    self endon( "stun_zombie" );

    if (check_for_raid_port() == true) //disabled for raid boss
        return;
    if ( self.health <= 0 )
    {
/#
        iprintln( "trying to stun a dead zombie" );
#/
        return;
    }

    if ( self.ai_state != "find_flesh" )
        return;

    self.forcemovementscriptstate = 1;
    self.ignoreall = 1;

    for ( i = 0; i < 2; i++ )
    {
        self animscripted( self.origin, self.angles, "zm_afterlife_stun" );
        self maps\mp\animscripts\shared::donotetracks( "stunned" );
    }

    self.forcemovementscriptstate = 0;
    self.ignoreall = 0;
    self setgoalpos( self.origin );
    self thread maps\mp\zombies\_zm_ai_basic::find_flesh();
}

delete_zombie_noone_looking_custom( how_close, how_high )
{
    self endon( "death" );

    if (check_for_raid_port() == true)
        return;

    if ( !isdefined( how_close ) )
        how_close = 1500;

    if ( !isdefined( how_high ) )
        how_high = 600;

    distance_squared_check = how_close * how_close;
    too_far_dist = distance_squared_check * 3;

    if ( isdefined( level.zombie_tracking_too_far_dist ) )
        too_far_dist = level.zombie_tracking_too_far_dist * level.zombie_tracking_too_far_dist;

    self.inview = 0;
    self.player_close = 0;
    n_distance_squared = 0;
    n_height_difference = 0;
    players = get_players();

    for ( i = 0; i < players.size; i++ )
    {
        if ( players[i].sessionstate == "spectator" )
            continue;

        if ( isdefined( level.only_track_targeted_players ) )
        {
            if ( !isdefined( self.favoriteenemy ) || self.favoriteenemy != players[i] )
                continue;
        }

        can_be_seen = self player_can_see_me( players[i] );

        if ( can_be_seen && distancesquared( self.origin, players[i].origin ) < too_far_dist )
            self.inview++;

        n_modifier = 1.0;

        if ( isdefined( players[i].b_in_tunnels ) && players[i].b_in_tunnels )
            n_modifier = 2.25;

        n_distance_squared = distancesquared( self.origin, players[i].origin );
        n_height_difference = abs( self.origin[2] - players[i].origin[2] );

        if ( n_distance_squared < distance_squared_check * n_modifier && n_height_difference < how_high )
            self.player_close++;
    }

    if ( self.inview == 0 && self.player_close == 0 )
    {
        if ( !isdefined( self.animname ) || self.animname != "zombie" && self.animname != "mechz_zombie" )
            return;

        if ( isdefined( self.electrified ) && self.electrified == 1 )
            return;

        if ( isdefined( self.in_the_ground ) && self.in_the_ground == 1 )
            return;

        zombies = getaiarray( "axis" );

        if ( ( !isdefined( self.damagemod ) || self.damagemod == "MOD_UNKNOWN" ) && self.health < self.maxhealth )
        {
            if ( !( isdefined( self.exclude_distance_cleanup_adding_to_total ) && self.exclude_distance_cleanup_adding_to_total ) && !( isdefined( self.isscreecher ) && self.isscreecher ) )
            {
                level.zombie_total++;
                level.zombie_respawned_health[level.zombie_respawned_health.size] = self.health;
            }
        }
        else if ( zombies.size + level.zombie_total > 24 || zombies.size + level.zombie_total <= 24 && self.health >= self.maxhealth )
        {
            if ( !( isdefined( self.exclude_distance_cleanup_adding_to_total ) && self.exclude_distance_cleanup_adding_to_total ) && !( isdefined( self.isscreecher ) && self.isscreecher ) )
            {
                level.zombie_total++;

                if ( self.health < level.zombie_health )
                    level.zombie_respawned_health[level.zombie_respawned_health.size] = self.health;
            }
        }

        self maps\mp\zombies\_zm_spawner::reset_attack_spot();
        self notify( "zombie_delete" );

        if ( isdefined( self.is_mechz ) && self.is_mechz )
        {
            self notify( "mechz_cleanup" );
            level.mechz_left_to_spawn++;
            wait_network_frame();
            level notify( "spawn_mechz" );
        }

        self delete();
        recalc_zombie_array();
    }
}

zombie_damage_failsafe_custom()
{
    self endon( "death" );
    continue_failsafe_damage = 0;

    if (check_for_raid_port() == true)
        return;

    while ( true )
    {
        wait 0.5;

        if ( !isdefined( self.enemy ) || !isplayer( self.enemy ) )
            continue;

        if ( self istouching( self.enemy ) )
        {
            old_org = self.origin;

            if ( !continue_failsafe_damage )
                wait 5;

            if ( !isdefined( self.enemy ) || !isplayer( self.enemy ) || self.enemy hasperk( "specialty_armorvest" ) )
                continue;

            if ( self istouching( self.enemy ) && !self.enemy maps\mp\zombies\_zm_laststand::player_is_in_laststand() && isalive( self.enemy ) )
            {
                if ( distancesquared( old_org, self.origin ) < 3600 )
                {
                    self.enemy dodamage( self.enemy.health + 1000, self.enemy.origin, self, self, "none", "MOD_RIFLE_BULLET" );
                    continue_failsafe_damage = 1;
                }
            }
        }
        else
            continue_failsafe_damage = 0;
    }
}

tomb_round_spawn_failsafe_custom()
{
    self endon( "death" );
    prevorigin = self.origin;

    if (check_for_raid_port() == true)
        return;

    while ( true )
    {
        if ( isdefined( self.ignore_round_spawn_failsafe ) && self.ignore_round_spawn_failsafe )
            return;

        wait 15;

        if ( isdefined( self.is_inert ) && self.is_inert )
            continue;

        if ( isdefined( self.lastchunk_destroy_time ) )
        {
            if ( gettime() - self.lastchunk_destroy_time < 8000 )
                continue;
        }

        if ( self.origin[2] < -3000 )
        {
            if ( isdefined( level.put_timed_out_zombies_back_in_queue ) && level.put_timed_out_zombies_back_in_queue && !flag( "dog_round" ) && !( isdefined( self.isscreecher ) && self.isscreecher ) )
            {
                level.zombie_total++;
                level.zombie_total_subtract++;
            }

            self dodamage( self.health + 100, ( 0, 0, 0 ) );
            break;
        }

        if ( distancesquared( self.origin, prevorigin ) < 576 )
        {
            if ( isdefined( level.put_timed_out_zombies_back_in_queue ) && level.put_timed_out_zombies_back_in_queue && !flag( "dog_round" ) )
            {
                if ( !self.ignoreall && !( isdefined( self.nuked ) && self.nuked ) && !( isdefined( self.marked_for_death ) && self.marked_for_death ) && !( isdefined( self.isscreecher ) && self.isscreecher ) && ( isdefined( self.has_legs ) && self.has_legs ) && !( isdefined( self.is_brutus ) && self.is_brutus ) )
                {
                    level.zombie_total++;
                    level.zombie_total_subtract++;
                }
            }

            level.zombies_timeout_playspace++;
            self dodamage( self.health + 100, ( 0, 0, 0 ) );
            break;
        }

        prevorigin = self.origin;
    }
}

init()
{
    level.net_port_raid = [];
    level.net_port_raid[level.net_port_raid.size] = "30009"; //raid
//    level.net_port_raid[level.net_port_raid.size] = "30005"; //pv

    if (check_for_raid_port() == false)
        return;

    setdvar("class", "0");
    setdvar("fire_rate", "0.4");
    setdvar("cost", "75");
    setdvar("upgrade", "");
    setdvar("perk_weapRateMultiplier", "0.4");
    level.firewall_duration = 7;
    level.fx = [];
    level.is_dps_skill_active = 0;
    level.boss_hp = 5000000;
    level.player_base_maxhealth = 3000;
    level.healer_maxhealth = 2000;
    level.dps_maxhealth = 2500;
    level.tank_maxhealth = 4000;

   /* level.tank_maxhealth = 999000;
    level.dps_maxhealth = 999000;
        level.healer_maxhealth = 999000;*/
    level.playerhealth_regularregendelay = 9999999;
    level.zombie_vars["riotshield_hit_points"] = 1000;
    level thread on_player_connect();
    flag_wait("initial_blackscreen_passed");
    flag_set( "activate_zone_chamber" );

    level thread check_player_count();
    level thread spawn_boss();
    level thread wait_for_dvar();
    level thread boss_hp_watcher();
    level thread random_custom_perk();
    level thread on_boss_death();
}

check_player_count()
{
    level.player_count = 0;
    wait 1;
    foreach(player in level.players)
    {
        if(player.sessionstate != "spectator")
            level.player_count++;
    }
}

on_boss_death()
{
    for (;;)
    {
        if (isdefined(level.boss))
            break;
        wait 0.1;
    }
    level.boss thread on_boss_death2();
}

on_boss_death2()
{
    self waittill("death");

    foreach(player in level.players)
    {
        if (player && player.sessionstate != "spectator" && !(player maps\mp\zombies\_zm_laststand::player_is_in_laststand()))
        {
            foreach(player in level.players)
                player thread FinalMsg();
            return;
        }
    }

}

fade_in(duration)
{
    self endon("disconnect");

    i = 0;
    for(;;)
    {
        if (i >= 1)
            break;
        self.alpha += 0.05;
        wait 0.05;
        i += 0.05;
    }
}

fade_out(duration)
{
    self endon("disconnect");

    i = 1;
    for(;;)
    {
        if (i <= 0)
            break;
        self.alpha -= 0.05;
        wait 0.05;
        i -= 0.05;
    }
}
preload_msg()
{   
    self.preload_hud = maps\mp\gametypes_zm\_hud_util::createFontString ("hudsmall", 5);
    self.preload_hud maps\mp\gametypes_zm\_hud_util::setPoint( "TOP", "CENTER", 0, -100);
    self.preload_hud settext(" ^3Welcome to the ^1Z-Tavern DLC^7 - ^3Raid Server ^7!\n\n ^3Bind^7 ^1Previous Scorestreak^7 ^3to use your ^1skill^7");
    self.preload_hud.hidewheninmenu = 1;
    self.preload_hud.alpha = 0;
    self.preload_hud thread fade_in(1);
    wait 8;
    self.preload_hud thread fade_out(1);
    wait 5;
    for (;;)
    {
        if(isdefined(self.class))
        {
            if (self.class == "tank")
                res = "^5TANK";
            if (self.class == "healer")
                res = "^2Healer";
            if (self.class == "dps")
                res = "^1DPS";
            break;
        }
        wait 0.1;
    }

    self.preload_hud settext("Your Class : " + res);
    self.preload_hud thread fade_in(1);
    wait 3;
    self.preload_hud thread fade_out(1);
    wait 3;
    self.preload_hud delete();
}

random_custom_perk()
{
    flag_wait("initial_blackscreen_passed");

    wait 5;
    iprintln("^5+Perk^7");
    level.perk_list = [];

    for (;;)
    {
        r = randomint(4);
        if (r == 0)
        {
            origin = level.fireRadiusOrigin + (0, 0, 0);
        }
        else if(r == 1)
        {
            origin = level.iceRadiusOrigin + (0, 0, 0);
        }
        else if(r == 2)
        {
            origin = level.lightningRadiusOrigin + (0, 0, 0);
        }
        else if(r == 3)
        {
            origin = level.windRadiusOrigin + (0, 0, 0);
        }
        maps\mp\zombies\_zm_powerups::specific_powerup_drop( "free_perk", origin);
        wait 40;
    }

       /* // give random perk
        foreach(player in level.players)
        {
            r = randomint(10);
            if (r > 80)
            {
                perk = "Dying_Wish";
            }
            else if (r > 60)
            {
                perk = "Momentum_Mocha"; 
            }
            else if (r > 40)
            {
                perk = "Bandolier_Bandit"; 
            }
            else if (r > 20)
            {
                perk = "Downers_Delight"; 
            }
            else
            {
                perk = "Momentum_Mocha"; 
            }
            player.has_timeslip = 1;
            player thread scripts\AATs_Perks::drawshader_and_shadermove( perk, 1, 1, "custom" );*/
            

}

boss_hp_watcher()
{
    for (;;)
    {
        if (isdefined(level.boss.health) && level.boss.health < 200000)
            level.true_death = 1;  
        wait 0.1;
    }
  
}

ammoRegen()
{
    self endon("disconnect");
    level endon ("game_ended");

    if (check_for_raid_port() == false)
        return;
    for (;;)
    {
        if (!(self.sessionstate == "spectator"))
        {
            stockcount = self getweaponammostock( self GetCurrentWeapon() );
            self setWeaponAmmostock( self GetCurrentWeapon(), stockcount + 500 );    
        }
        wait 3;
    }
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

on_player_connect()
{
    if (check_for_raid_port() == false)
        return;

    for (;;)
    {
        level waittill("connected", player);
        id = player getEntityNumber();
        player thread TpToCenter(id);
        player thread shield_hud();
        player thread healthBarBoss();
        player thread load_class();
        player thread use_skill();
        player thread raid_init();
        player thread ammoregen();
        player thread downed_watcher();
        player thread perma_no_regen();
        player thread give_dtap();
        player thread health_hud();
        player thread preload_msg();
        //if (player.sessionstate != "spectator")
          //  player thread blessingselector();
     //   player thread pers_timer();
    }
}


pers_timer()
{
    self.timer = maps\mp\gametypes_zm\_hud_util::createFontString ("hudsmall", 1);
    self.timer maps\mp\gametypes_zm\_hud_util::setPoint ("TOP", "RIGHT", 35, -220);
    self.timer.hidewheninmenu = 1;
    self.timer.alpha = 0.4;
}

health_hud()
{
    flag_wait("initial_blackscreen_passed");
    self endon("disconnect");


        self.p1_hud = maps\mp\gametypes_zm\_hud_util::createFontString ("hudsmall", 1);
        self.p1_hud maps\mp\gametypes_zm\_hud_util::setPoint ("BOTTOM", "CENTER", -40, 190);
        self.p1_hud.label = &"^5Tank\n^2Healer\n^1DPS\nDPS";
        self.p1_hud.hidewheninmenu = 1;
        level.primaryprogressbarwidth = 60;
        level.primaryprogressbarheight = 10;
        self.p1_bar = self createprimaryprogressbar();
        self.p1_bar.bar.color = (1, 1, 1);
        self.p1_bar setpoint(undefined, "BOTTOM", 15, -20);
        self.p1_bar.hidewheninmenu = 1;
        self.p1_bar.bar.hidewheninmenu = 1;
        self.p1_bar.barframe.hidewheninmenu = 1;
        level.primaryprogressbarwidth = 400;
        level.primaryprogressbarheight = 15;
        self thread track_hp(self.p1_bar, 0);

        level.primaryprogressbarwidth = 60;
        level.primaryprogressbarheight = 10;
        self.p2_bar = self createprimaryprogressbar();
        self.p2_bar setpoint(undefined, "BOTTOM", 15, -8);
        self.p2_bar.hidewheninmenu = 1;
        self.p2_bar.bar.hidewheninmenu = 1;
        self.p2_bar.bar.color = (1, 1, 1);
        self.p2_bar.barframe.hidewheninmenu = 1;
        level.primaryprogressbarwidth = 400;
        level.primaryprogressbarheight = 15;
        self thread track_hp(self.p2_bar, 1);

        level.primaryprogressbarwidth = 60;
        level.primaryprogressbarheight = 10;
        self.p3_bar = self createprimaryprogressbar();
        self.p3_bar setpoint(undefined, "BOTTOM", 15, 4);
        self.p3_bar.hidewheninmenu = 1;
        self.p3_bar.bar.hidewheninmenu = 1;
        self.p3_bar.barframe.hidewheninmenu = 1;
        self.p3_bar.bar.color = (1, 1, 1);
        level.primaryprogressbarwidth = 400;
        level.primaryprogressbarheight = 15;
        self thread track_hp(self.p3_bar, 2);

        level.primaryprogressbarwidth = 60;
        level.primaryprogressbarheight = 10;
        self.p4_bar = self createprimaryprogressbar();
        self.p4_bar.bar.color = (1, 1, 1);
        self.p4_bar setpoint(undefined, "BOTTOM", 15, 16);
        self.p4_bar.hidewheninmenu = 1;
        self.p4_bar.bar.hidewheninmenu = 1;
        self.p4_bar.barframe.hidewheninmenu = 1;
        level.primaryprogressbarwidth = 400;
        level.primaryprogressbarheight = 15;
        self thread track_hp(self.p4_bar, 3);

  /*  for(;;)
    {

        wait 0.1;
    }*/
}

track_hp(bar, id)
{
    for (;;)
    {
        foreach(player in level.players)
        {
            pid = player GetEntityNumber();
            if (id == pid)
            {
                if (player.sessionstate == "spectator" || player maps\mp\zombies\_zm_laststand::player_is_in_laststand())
                {
                    bar.bar.color = (1, 0, 0);
                    if (player.sessionstate == "spectator")
                        player.health = 1;
                }
                else
                {
                    bar.bar.color = (0, 1, 0);
                    if (player.health < player.maxhealth * 0.66)
                    {
                        bar.bar.color = (1, 1, 0);
                    }
                    if (player.health < player.maxhealth * 0.33)
                    {
                        bar.bar.color = (1, 0, 0);
                    }
                }
                if (isdefined(player.health) && isdefined(player.maxhealth))
                    bar updatebar(player.health / player.maxhealth);
            }
        }
        wait .05;
    }
}


perma_no_regen()
{
    self endon("disconnect");

    for (;;)
    {
        level.playerhealth_regularregendelay = 9999999;
        wait .05;
    }
}

downed_watcher()
{
    self endon("disconnect");

    for (;;)
    {
        if(self maps\mp\zombies\_zm_laststand::player_is_in_laststand())
        {
            self.got_downed = 1;
            self.health = 0;
        }
        else if (isdefined(self.got_downed))
        {     
            self.got_downed = undefined;
            wait 3;
            if (self.class == "tank")
                self.health = 2000;
            else 
                self.health = 1000;
        }
        wait 0.1;
    }
}

raid_init()
{
    for(;;)
    {
        if (isdefined(self.class))
            break;
        wait 1;
    }

    if (self.class == "tank")
    {
      //  guid = self getguid();
      //  if (guid != 564391)
       // {
            wait 0.1;
            r = randomint(3);
            if (r == 0)
                self thread give_pap_weapon("type95_upgraded_zm");
            if (r == 1)
                self thread give_pap_weapon("beretta93r_extclip_upgraded_zm");
            if (r == 2)
                self thread give_pap_weapon("ak74u_extclip_upgraded_zm");
    //    }

        self thread give_shield();
    }
    else if (self.class == "dps")
    {
        r = randomint(4);
        if (r == 0)
            self thread give_pap_weapon("scar_upgraded_zm");
        if (r == 1)
            self thread give_pap_weapon("galil_upgraded_zm");
        if (r == 2)
            self thread give_pap_weapon("mg08_upgraded_zm");
        if (r == 3)
            self thread give_pap_weapon("hamr_upgraded_zm");
    }
    else if (self.class == "healer")
    {
        r = randomint(5);
        if (r == 0)
            self thread give_pap_weapon("thompson_upgraded_zm");
        if (r == 1)
            self thread give_pap_weapon("qcw05_upgraded_zm");
        if (r == 2)
            self thread give_pap_weapon("evoskorpion_upgraded_zm");
        if (r == 3)  
            self thread give_pap_weapon("pdw57_upgraded_zm");
        if (r == 4)  
            self thread give_pap_weapon("mp40_stalker_upgraded_zm");
    }
}

give_dtap()
{
    self endon("disconnect");

    flag_wait("initial_blackscreen_passed");
    for (;;)
    {
        if (self HasPerk("specialty_rof") == 0)
            self thread maps\mp\zombies\_zm_perks::wait_give_perk("specialty_rof", 1); 
        wait 3;
    }
}

give_shield()
{
    self endon("disconnect");

    for (;;)
    {
        self.shielddamagetaken = 0;
        level.zombie_vars["riotshield_hit_points"] = 1000;
        self maps\mp\zombies\_zm_equipment::equipment_give( "tomb_shield_zm" );
        level.zombie_vars["riotshield_hit_points"] = 1000;
        wait 300;
    }
}
shield_hud()
{
    self endon("disconnect");

    flag_wait("initial_blackscreen_passed");
    self.shield = 0;
	self.shield_hud = maps\mp\gametypes_zm\_hud_util::createFontString ("hudsmall", 1.5);
	self.shield_hud maps\mp\gametypes_zm\_hud_util::setPoint ("CENTER", "CENTER", -100, 220);
	self.shield_hud.label = &"Shield: ^8";
    for (;;)
    {
        self.shield_hud setValue(self.shield);
        wait 0.1;
    }

}

use_skill()
{
    self endon("disconnect");

    for(;;)
    {
        if (self actionslottwobuttonpressed() && self.skill_cooldown_timer == self.skill_cooldown && self.sessionstate != "spectator")
        {
            self thread cooldown();
            if (self.class == "tank")
            {
                iprintln("^8Hold the Line^7 Skill ^3activated!");
                foreach(player in level.players)
                {
                    player thread shield_skill();
                }
            }
            if (self.class == "dps" && level.is_dps_skill_active == 0)
            {
                iprintln("^1Gunslinger Skill ^3activated !");
                foreach(player in level.players)
                {
                    player thread crit_skill();
                }
            }
            if (self.class == "healer")
            {
                iprintln("^2Zone Heal Skill ^3activated !");
                self thread heal_skill();
            }
        }
        wait 0.05;
    }

}

shield_skill()
{
    self endon("disconnect");
    self.shield = 2200;

    diff = 0;
    for (;;)
    {
        if (self.shield + 100 != old_shield)
        {
            diff = (self.shield + 100) - old_shield;
            self iprintln("^1Damage ^8Absorbed ! : " + diff);
        }
        old_shield = self.shield;
        self.shield = self.shield - 100;
        if (self.shield <= 0)
        {
            self.shield = 0;
            break;
        }
        wait 0.2;
    }
}

heal_skill()
{
    healer_pos = self.origin;
    tick = 14;

    for (i = 0; i < tick ; i++)
    {
        foreach(player in level.players)
        {
            player thread check_heal_dist(healer_pos);
        }
        wait 0.25;
    }
}

check_heal_dist(healer_pos)
{
    if (distance(healer_pos, self.origin) < 1300)
    {
        if (distance(healer_pos, self.origin) < 1)
        {
            healer = self;
            self iprintln("Healed for : ^2" + 50 + " HP^7 !");
        }
        if (isdefined(healer))
            healer iprintln("Healing " + self.name + "for : ^3" + 50 + " HP^7 !");
        if (self.health + 50 > self.maxhealth)
            self.health = self.maxhealth;
        else
        {
            self.health += 50;
        }
    }
}

crit_skill()
{
    self endon ("disconnect");
    level.is_dps_skill_active = 1;
    old_ms = self GetMoveSpeedScale();
    self SetMoveSpeedScale(1.6);
    setdvar("fire_rate", 0.2);
    setdvar("perk_weapRateMultiplier", 0.2);
    self thread infinite_ammo();
    wait 5;
    setdvar("fire_rate", 0.4);
    setdvar("perk_weapRateMultiplier", 0.4);
    self SetMoveSpeedScale(old_ms);
    level.is_dps_skill_active = 0;
}

infinite_ammo()
{
    self endon("disconnect");

    for (i = 0; i < 40; i++)
    {
        self SetWeaponAmmoClip(self GetCurrentWeapon(), 100);
        wait .1;
    }
}

cooldown()
{
    self endon("disconnect");

    self.skill_cooldown_timer = 0;

    for (i = 0; i < self.skill_cooldown; i++)
    {
        self.skill_cooldown_timer++;
        wait 1;
    }
}

skill_cooldown()
{
	self endon("disconnect");
	level endon("game_ended");

    level.primaryprogressbarwidth = 60;
    level.primaryprogressbarheight = 5;
    self.cd_bar = self createprimaryprogressbar();
    self.cd_bar setpoint(undefined, "BOTTOM", 219, 20);
    self.cd_bar.hidewheninmenu = 1;
    self.cd_bar.bar.hidewheninmenu = 1;
    self.cd_bar.barframe.hidewheninmenu = 1;

    level.primaryprogressbarwidth = 400;
    level.primaryprogressbarheight = 15;

	for (;;)
	{
		self.cd_bar updatebar(self.skill_cooldown_timer / self.skill_cooldown);
        if (self.skill_cooldown_timer == self.skill_cooldown)
        {
            self.notifyiconb2.color = (0, 1, 0);
            self.notifyiconb2.alpha = 1;
            self.cd_bar.color = ( 0, 1, 0 );
        }
        else
        {
            self.notifyiconb2.color = (1, 0, 0);
            self.notifyiconb2.alpha = 0.8;
            self.cd_bar.color = ( 1, 0, 0 );
        }

		if(isdefined(self.cd_bar.color))
			self.cd_bar.bar.color = self.cd_bar.color;
		wait .05;
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
    hud setparent(self.guild_menu );
	hud setshader( shader, width, height );
	hud.x = x;
	hud.y = y;
    hud.foreground = 0;
	return hud;
}


load_class()
{
    flag_wait("initial_blackscreen_passed");
    wait 4;
    guid = self getguid();
    id = self GetEntityNumber();
    if (id == 0)
    {
        self.class = "tank";
    }

    if (id == 1)
    {
        self.class = "healer"; 
    }
    if (id >= 2)
    {
        self.class = "dps";
    }
  /*  if (guid == 3968479)
    {
        foreach(player in level.players)
        {
            if (player.class == "healer")
                player.class = "dps";
        }
        self.class = "healer";
    }*/

   /* if (guid == 564391)
    {
        foreach(player in level.players)
        {
            if (player.class == "tank")
            {
                wait 0.1;
                foreach (playerr in level.players)
                {
                    if (playerr.class == "tank")
                    {
                        playerr.class = "dps";
                        break;
                    }
                    if (playerr.class == "healer")
                    {
                        is_healer_free = 0;
                        playerr.class = "healer";
                        break;
                    }
                    is_healer_free = 1;
                }
                self iprintln("[^1Kiels Bot^7] : Login ^1Kiels^7 detected.. Access ^2granted^. Please wait ^5a few seconds. Beep boop i'm a ^8bot^7");
                wait 1.5;        
                self iprintln("[^1Kiels Bot^7] : Custom AK ^2Granted !^7");


               
                
                wait 0.2;

        self maps\mp\zombies\_zm_equipment::equipment_give( "tomb_shield_zm" );
            }

        }
        self.class = "tank";
    }*/

    if (self.class == "healer")
    {
        self thread load_healer_class();
    }
    else if (self.class == "dps")
    {        
        self thread load_dps_class();
    }
    else if (self.class == "tank")
    {
        self thread load_tank_class();
    }
    else
    {
        self thread perma_hp_change(2000); //failsafe
    }


    shader = "zombies_rank_3";
    self.notifyiconb = self drawshader(shader, 580, 165, 50, 50, (0, 0, 0));
    self.notifyiconb.alpha = 1;
    self.notifyiconb2 = self drawshader(shader, 580, 168, 45, 45, (0, 1, 0));
    self.notifyiconb2.alpha = 1;
    self.hidewheninmenu = 1;
    if (getdvar("skill_cooldown") == "1")
        self.skill_cooldown = 10;
    else
        self.skill_cooldown = 15;
    self.skill_cooldown_timer = self.skill_cooldown;
    self thread skill_cooldown();
}

give_pap_weapon(upgrade_name)
{
    self giveweapon( upgrade_name, 0, self maps\mp\zombies\_zm_weapons::get_pack_a_punch_weapon_options( upgrade_name ) );
    self SwitchToWeapon(upgrade_name);
}

load_healer_class()
{
    self thread perma_hp_change(level.healer_maxhealth);
}

load_dps_class()
{
    self thread perma_hp_change(level.dps_maxhealth);
}

load_tank_class()
{
    self thread perma_hp_change(level.tank_maxhealth);
}

perma_hp_change(maxhp)
{
    self.maxhealth = maxhp;
    old_maxhealth = self.maxhealth;
    self.health = self.maxhealth;
    for (;;)
    {
        if (isdefined(self.maxhealth) && self.maxhealth != old_maxhealth)
        {
            self.maxhealth = maxhp;
            self.health = self.maxhealth;
        }
        wait 0.1;
    }
}

wait_for_dvar()
{
    for (;;)
    {
        if (getdvar("class") != "0")
        {
            break;
        }
        wait 0.1;
    }
    class_list = StrTok(getdvar("class"), ";");
    foreach(player in level.players)
    {
        if (player getGuid() == int(class_list[0]))
        {
            player.class = class_list[1];
        }
        if (player getGuid() == int(class_list[2]))
        {
            player.class = class_list[3];
        }
        if (player getGuid() == int(class_list[4]))
        {
            player.class = class_list[5];
        }
        if (player getGuid() == int(class_list[6]))
        {
            player.class = class_list[7];
        }
    }

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

spawn_boss()
{
    for (;;)
    {
        if (level.zombie_total != 0)
            break;
        wait 0.1;
    }
    zombies = getaiarray(level.zombie_team);
    foreach(zombie in zombies)
    {
        zombie DoDamage(zombie.health + 1, zombie.origin);
    }
    level.zombie_total = 1;
    wait 2;
   // if (getdvar("boss_type") == "1")
  //      level thread setup_boss_kiels1();
  //  else if (getdvar("boss_type") == "2")
        level thread setup_boss_ivo1();
  //  else if (getdvar("boss_type") == "3")
  //      level thread setup_boss_kong1();
}

FinalMsg()
{
    level endon("game_ended");
    self endon("disconnect");
    level endon( "intermission" );

    if (!isdefined(level.true_death))
    {
        self iprintln("[^1Kiels Bot^7] ^3Bugged Boss^7 detected, I will ^5restart^7 the server ! ^2#Donate^7 to help fix bugs ^1<3^7");
        wait 5;
        executeCommand("fast_restart");
        return;
    }

    foreach(player in level.players)
    {
        player enableInvulnerability();
    }
    
    setdvar("raid_boss_quest", ((GetTime() - level.start_time) / 1000 / 60));
    iprintln("^3Raid completed^7 in : ^2" + ((GetTime() - level.start_time) / 1000 / 60) + "^7 minutes !");

    setDvar("EE_Completion", "PiA_Final_GigaChad");  
    self.zombieTextXx = maps\mp\gametypes_zm\_hud_util::createFontString( "hudsmall" , 4 );
    self.zombieTextXx maps\mp\gametypes_zm\_hud_util::setPoint( "CENTER", "CENTER", 0, -160 );
    self.zombieTextXx.label = &"^5CONGRATULATIONS !";
    self.zombieTextXx.alpha = 0.8;
    for (i = 0; i < 20; i++)
    {
        self.zombieTextXx.label = &"^1Raid Cleared !";
        wait 1;
        self.zombieTextXx.label = &"^3Raid Cleared !";
    }
    executeCommand("fast_restart");
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
        origin = (10672.6, -7778.6, -419.875);
        angle = (0, 225, 0);
        self setOrigin(origin);
        self SetPlayerAngles(angle);
    }
    else if (id == 5)
    {
        origin = (10272.6, -7778.6, -419.875);
        angle = (0, 225, 0);
        self setOrigin(origin);
        self SetPlayerAngles(angle);
    }
}

generateInvisiblePerk(pos, angles)
{
    iWall = spawn( "script_model", pos );
	iWall setmodel( "zm_collision_perks1" );
	iWall.angles = angles;

	/*col = spawn( "script_model", pos);
	col setmodel( "zombie_vending_jugg_on" );
	col.angles = angles;*/
}

healthBarBoss()
{
    level endon("end_game");
    self endon("disconnect");

    flag_wait("initial_blackscreen_passed");
    for (;;)
    {
        if (isdefined(level.is_boss_spawned))
            break;
        wait 0.1;
    }
    level.primaryprogressbarwidth = 400;
    level.primaryprogressbarheight = 15;
    boss_bar = self createprimaryprogressbar();
    boss_bar setpoint(undefined, "TOP", 0, 0);
    boss_bar.bar.color = (0, 1, 0);

    boss_bar.hidewheninmenu = 1;
    boss_bar.bar.hidewheninmenu = 1;
    boss_bar.barframe.hidewheninmenu = 1;

    boss_name_text = createprimaryprogressbartext();
    
    boss_health_text = createprimaryprogressbartext();

    boss_name_text setpoint(undefined, "TOP", 0, -25);

    boss_health_text setpoint(undefined, "TOP", 0, 0);

    boss_name_text.fontscale = 1.5;
    txt = "^1Raid Boss " + level.boss.name;
    boss_name_text settext(txt);

    boss_health_text.hidewheninmenu = 1;
    while (1)
    {
        if (!level.boss.health || level.boss.health < 0)
        {
            boss_bar.barframe destroy();
            boss_bar.bar destroy();
            boss_bar destroy();
            boss_name_text destroy();
            boss_health_text destroy();
            return;
        }
        if (level.boss.health / level.boss.maxhealth > 0.5)
        { 
            boss_bar.bar.color = ( level.boss.maxhealth / level.boss.health - 1, 1, 0 );
        }

        if (level.boss.health / level.boss.maxhealth == 0.5)
        {
            boss_bar.bar.color = ( 1, 1, 0 );
        }
        
        if (level.boss.health / level.boss.maxhealth < 0.5)
        {
            boss_bar.bar.color = ( 1, (level.boss.health / level.boss.maxhealth) * 2, 0 );
        }

        if (level.boss.health == 0)
        {
            return;
        }

        boss_bar updatebar(level.boss.health / level.boss.maxhealth);
        if (isdefined(level.boss.candamage) && level.boss.candamage == 0)
        {
            boss_bar.bar.color = ( 1, 1, 1 );
        }
        if (level.boss.health > 10000000)
            boss_health_text settext("^715M");
        else if (level.boss.health > 5000000)
            boss_health_text settext("^710M");
        else if (level.boss.health > 3000000)
            boss_health_text settext("^75M");
        else if (level.boss.health > 2000000)
            boss_health_text settext("^73M");
        else if (level.boss.health > 1000000)
            boss_health_text settext("^72M");
        else 
        {
            boss_health_text settext("");
            boss_health_text setvalue(level.boss.health);
        }
        wait 0.3;
    }
}

revive_do_revive_custom( playerbeingrevived, revivergun )
{
    assert( self is_reviving( playerbeingrevived ) );
    revivetime = 3;

    if ( self hasperk( "specialty_quickrevive" ) )
        revivetime /= 2;

    if ( self maps\mp\zombies\_zm_pers_upgrades_functions::pers_revive_active() )
        revivetime *= 0.5;

    if (check_for_raid_port() == true)
    {
        if (!isdefined(self.class) || self.class != "healer")
            revivetime = 15;
        else    
            revivetime = 1;

    timer = 0;
    revived = 0;
    playerbeingrevived.revivetrigger.beingrevived = 1;
    playerbeingrevived.revive_hud settext( &"ZOMBIE_PLAYER_IS_REVIVING_YOU", self );
    playerbeingrevived revive_hud_show_n_fade( 3.0 );
    playerbeingrevived.revivetrigger sethintstring( "" );

    if ( isplayer( playerbeingrevived ) )
        playerbeingrevived startrevive( self );

    if ( !isdefined( self.reviveprogressbar ) )
        self.reviveprogressbar = self createprimaryprogressbar();

    if ( !isdefined( self.revivetexthud ) )
        self.revivetexthud = newclienthudelem( self );

    self thread laststand_clean_up_on_disconnect( playerbeingrevived, revivergun );

    if ( !isdefined( self.is_reviving_any ) )
        self.is_reviving_any = 0;

    self.is_reviving_any++;
    self thread laststand_clean_up_reviving_any( playerbeingrevived );
    self.reviveprogressbar updatebar( 0.01, 1 / revivetime );
    self.revivetexthud.alignx = "center";
    self.revivetexthud.aligny = "middle";
    self.revivetexthud.horzalign = "center";
    self.revivetexthud.vertalign = "bottom";
    self.revivetexthud.y = -113;

    if ( self issplitscreen() )
        self.revivetexthud.y = -347;

    self.revivetexthud.foreground = 1;
    self.revivetexthud.font = "default";
    self.revivetexthud.fontscale = 1.8;
    self.revivetexthud.alpha = 1;
    self.revivetexthud.color = ( 1, 1, 1 );
    self.revivetexthud.hidewheninmenu = 1;

    if ( self maps\mp\zombies\_zm_pers_upgrades_functions::pers_revive_active() )
        self.revivetexthud.color = ( 0.5, 0.5, 1.0 );

    self.revivetexthud settext( &"ZOMBIE_REVIVING" );
    self thread check_for_failed_revive( playerbeingrevived );

    while ( self is_reviving( playerbeingrevived ) )
    {
        wait 0.05;
        timer += 0.05;

        if ( self player_is_in_laststand() )
            break;

        if ( isdefined( playerbeingrevived.revivetrigger.auto_revive ) && playerbeingrevived.revivetrigger.auto_revive == 1 )
            break;

        if ( timer >= revivetime )
        {
            revived = 1;
            break;
        }
    }

    if ( isdefined( self.reviveprogressbar ) )
        self.reviveprogressbar destroyelem();

    if ( isdefined( self.revivetexthud ) )
        self.revivetexthud destroy();

    if ( isdefined( playerbeingrevived.revivetrigger.auto_revive ) && playerbeingrevived.revivetrigger.auto_revive == 1 )
    {

    }
    else if ( !revived )
    {
        if ( isplayer( playerbeingrevived ) )
            playerbeingrevived stoprevive( self );
    }

    playerbeingrevived.revivetrigger sethintstring( &"ZOMBIE_BUTTON_TO_REVIVE_PLAYER" );
    playerbeingrevived.revivetrigger.beingrevived = 0;
    self notify( "do_revive_ended_normally" );
    self.is_reviving_any--;

    if ( !revived )
        playerbeingrevived thread checkforbleedout( self );

    return revived;
}}


blessingArray(x, gunslinger, extraLife, magicWeapon, speedRunner, quickRevive, juggernautPlus)
{
    blessingArray = [];
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
    return blessingArray;
}

blessingSelector()
{
    self endon("disconnect");
    level endon ("game_ended");

    self FreezeControlsAllowLook(1);

    selector = "left";
    tag = strTok(self.name, "]");

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

    for (;;)
    {
        x = randomintrange(0, 6);   
        if ((x == 4 || x == 1) && (tag[1] == "^6[VIP" || tag[1] == "[^6VIP^7" || tag[1] == "^1[VIP" || tag[1] == "[^1VIP^7" || tag[1] == "[^2VIP^7"))
            continue;
        break;
    }
    for (;;)
    {
        y = randomintrange(0, 6);
        if (y != x)
        {
            if ((y == 4 || y == 1) && (tag[1] == "^6[VIP" || tag[1] == "[^6VIP^7" || tag[1] == "^1[VIP" || tag[1] == "[^1VIP^7" || tag[1] == "[^2VIP^7"))
                continue;
            break;
        }
    }
    blessingArrayLeft = blessingArray(x, gunslinger, extraLife, magicWeapon, speedRunner, quickRevive, juggernautPlus);
    blessingArrayRight = blessingArray(y, gunslinger, extraLife, magicWeapon, speedRunner, quickRevive, juggernautPlus);    

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
                x = randomintrange(0, 5);
                if ((x == 4 || x == 1) && (tag[1] == "^6[VIP" || tag[1] == "[^6VIP^7" || tag[1] == "[^1VIP^7" || tag[1] == "[^1VIP^7" || tag[1] == "[^2VIP^7"))
                    continue;
                break;
            }
            for (;;)
            {
                y = randomintrange(0, 5);
                if (y != x)
                {
                    if ((y == 4 || y == 1) && (tag[1] == "^6[VIP" || tag[1] == "[^6VIP^7" || tag[1] == "[^1VIP^7" || tag[1] == "[^1VIP^7"|| tag[1] == "[^2VIP^7" ))
                        continue;
                    break;
                }
            }

            blessingArrayLeft = blessingArray(x, gunslinger, extraLife, magicWeapon, speedRunner, quickRevive, juggernautPlus);
            blessingArrayRight = blessingArray(y, gunslinger, extraLife, magicWeapon, speedRunner, quickRevive, juggernautPlus);  
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
    self FreezeControlsAllowLook(0);
}

applyBlessing(blessingNumber)
{
    self endon("disconnect");
    level endon ("game_ended");

    if (blessingNumber == 0)
    {
        self thread permaDoubleTap();
        self iPrintln("^3A Mighty beer for the finest ^5Gunslinger");   
    }
    else if (blessingNumber == 1)
    {
        self thread scripts\AATs_Perks::drawshader_and_shadermove( "Dying_Wish", 1, 1, "custom" );
        self iPrintln("^3It feels like ^5a guardian angel^3 is watching you^7 !");
    }
    else if (blessingNumber == 2)
    {
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
         self.extrams = 1;
         self thread permaSpeedRunner();
         self iPrintln("^3You feel as ^5light as a feather!^7");
    }
    else if (blessingNumber == 4)
    {
        self thread permaQuickRevive();
        self iPrintln("^3No team survives without a ^5Medic");   
    }
    else if (blessingNumber == 5)
    {
        self.extrahp = 1;
        self iPrintln("^3You feel ^1bulkier^7");   
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
                player dodamage_wrapper(800);
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
                    player dodamage_wrapper(1000);
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
                    player dodamage_wrapper(1000);
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
                    player dodamage_wrapper(100);
                else if(player.ignoreme != true)
                    player dodamage_wrapper(100);
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
                player dodamage_wrapper(1000);
        }
        wait 0.1;
    }
    fx delete();
}

check_for_raid_port()
{
    found = 0;
	if (isdefined(level.net_port_raid))
	{
		foreach(port in level.net_port_raid)
		{
			if (getdvar("net_port") == port)
				found = 1;
		}
	}
    if (found == 0)
        return false;
    return true;
}