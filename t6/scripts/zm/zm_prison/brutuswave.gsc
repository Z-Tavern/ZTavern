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
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_melee_weapon;
#include maps\mp\zombies\_zm_weap_tomahawk;


main()
{
    replaceFunc(maps\mp\zombies\_zm_ai_brutus::brutus_spawn, ::brutus_spawn_custom);
    replaceFunc(maps\mp\zombies\_zm_ai_brutus::brutus_stuck_teleport, ::brutus_stuck_teleport_custom);

    replaceFunc(maps\mp\zombies\_zm_ffotd::main_start, ::modified_main_start);
    replaceFunc(maps\mp\zombies\_zm_pers_upgrades::is_pers_system_active, ::always_pers_system_active);   
    replaceFunc(maps\mp\zombies\_zm_pers_upgrades::is_pers_system_disabled, ::never_pers_system_disabled);
    replaceFunc(maps\mp\zombies\_zm_ai_brutus::brutus_fire_teargas_when_possible, ::brutus_fire_teargas_when_possible_custom);
    replaceFunc(maps\mp\zombies\_zm_spawner::zombie_damage, ::zombie_damage_custom);
    replaceFunc(maps\mp\zombies\_zm_ai_brutus::brutus_damage_override, ::brutus_damage_override_custom);
    replaceFunc(maps\mp\zombies\_zm_weap_tomahawk::tomahawk_return_player, ::tomahawk_return_player_custom);
    replaceFunc(maps\mp\zombies\_zm_weap_tomahawk::tomahawk_thrown, ::tomahawk_thrown_custom);
    replaceFunc(maps\mp\zombies\_zm_weap_tomahawk::watch_for_tomahawk_throw, ::watch_for_tomahawk_throw_custom);
    replaceFunc(maps\mp\zombies\_zm_weap_tomahawk::tomahawk_attack_zombies, ::tomahawk_attack_zombies_custom);    
    replaceFunc(maps\mp\zombies\_zm_weap_tomahawk::tomahawk_hit_zombie, ::tomahawk_hit_zombie_custom);  
    replaceFunc(maps\mp\zombies\_zm_weap_tomahawk::play_charge_fx, ::play_charge_fx_custom);  
    replaceFunc(maps\mp\zombies\_zm_weap_tomahawk::calculate_tomahawk_damage, ::calculate_tomahawk_damage_custom);    
}

calculate_tomahawk_damage_custom( n_target_zombie, n_tomahawk_power, tomahawk )
{
    if(isdefined(n_target_zombie.is_boss))
        return 20000;
    
    if ( n_tomahawk_power > 2 )
    {
        if (n_target_zombie.fakeHat)
            n_target_zombie.fakeHat delete();
        if (n_target_zombie.fakeBrutus)
            n_target_zombie.fakeBrutus delete();
        n_target_zombie dodamage(n_target_zombie.health + 666, n_target_zombie.origin);
        return n_target_zombie.health + 1;
    }

    else if ( level.round_number >= 10 && level.round_number < 13 && tomahawk.low_level_instant_kill_charge <= 3 )
    {
        tomahawk.low_level_instant_kill_charge += 1;
        return n_target_zombie.health + 1;
    }
    else if ( level.round_number >= 13 && level.round_number < 15 && tomahawk.low_level_instant_kill_charge <= 2 )
    {
        tomahawk.low_level_instant_kill_charge += 1;
        return n_target_zombie.health + 1;
    }
    else
        return 1000 * n_tomahawk_power;
}

play_charge_fx_custom()
{
    self endon( "death" );
    self endon( "disconnect" );
    self endon( "grenade_fire" );
    waittillframeend;
    time_to_pulse = 1000;

    if (check_for_botb_port() == true)
        self.n_tomahawk_cooking_time -= 900;
    while ( true )
    {
        time = gettime() - self.n_tomahawk_cooking_time;
        self.current_tactical_grenade = self get_player_tactical_grenade();

        if ( time >= time_to_pulse )
        {
            if ( self.current_tactical_grenade == "upgraded_tomahawk_zm" )
                playfxontag( level._effect["tomahawk_charge_up_ug"], self, "tag_origin" );
            else
                playfxontag( level._effect["tomahawk_charge_up"], self, "tag_origin" );

            time_to_pulse += 1000;
            self playrumbleonentity( "reload_small" );
            self.n_tomahawk_cooking_time -= 900;
        }

        if ( time_to_pulse > 2400 && self.current_tactical_grenade != "upgraded_tomahawk_zm" )
            break;

        if ( time_to_pulse >= 3400 )
            break;

        wait 0.05;
    }
}


tomahawk_hit_zombie_custom( ai_zombie, grenade )
{
    self endon( "disconnect" );

    if ( isdefined( ai_zombie ) && isalive( ai_zombie ) )
    {
        tag = "J_Head";

        if ( ai_zombie.isdog )
            tag = "J_Spine1";

        v_target = ai_zombie gettagorigin( tag );
        if (check_for_botb_port() == true)
            grenade moveto( v_target, 0.3 * self.hawk_cd );
        else 
            grenade moveto( v_target, 0.3 );

        grenade waittill( "movedone" );

        if ( isdefined( ai_zombie ) && isalive( ai_zombie ) )
        {
            if ( self.current_tactical_grenade == "upgraded_tomahawk_zm" )
                playfxontag( level._effect["tomahawk_impact_ug"], ai_zombie, tag );
            else
                playfxontag( level._effect["tomahawk_impact"], ai_zombie, tag );

            ai_zombie setclientfield( "play_tomahawk_hit_sound", 1 );
            n_tomahawk_damage = calculate_tomahawk_damage( ai_zombie, grenade.n_grenade_charge_power, grenade );
            if (n_tomahawk_damage > ai_zombie.health)
            {
                self add_to_player_score( 50 );
                self.kills++;
                self.pers["kills"] = self.kills;
            }
            ai_zombie dodamage( n_tomahawk_damage, grenade.origin, self, grenade, "none", "MOD_GRENADE", 0, "bouncing_tomahawk_zm" );
            ai_zombie.hit_by_tomahawk = 1;
            self maps\mp\zombies\_zm_score::add_to_player_score( 10 );
        }
    }
}

tomahawk_attack_zombies_custom( m_tomahawk, a_zombies )
{
    self endon( "disconnect" );

    if ( !isdefined( a_zombies ) )
    {
        self thread tomahawk_return_player( m_tomahawk, 0 );
        return;
    }

    if ( a_zombies.size <= 4 )
        n_attack_limit = a_zombies.size;
    else
        n_attack_limit = 4;

    for ( i = 0; i < n_attack_limit; i++ )
    {
        if ( isdefined( a_zombies[i] ) && isalive( a_zombies[i] ) )
        {
            tag = "J_Head";

            if ( a_zombies[i].isdog )
                tag = "J_Spine1";

            if ( isdefined( a_zombies[i].hit_by_tomahawk ) && !a_zombies[i].hit_by_tomahawk )
            {
                v_target = a_zombies[i] gettagorigin( tag );
                if (check_for_botb_port() == true)
                    m_tomahawk moveto( v_target, 0.3 * self.hawk_cd);
                else 
                    m_tomahawk moveto( v_target, 0.3 );

                m_tomahawk waittill( "movedone" );

                if ( isdefined( a_zombies[i] ) && isalive( a_zombies[i] ) )
                {
                    if ( self.current_tactical_grenade == "upgraded_tomahawk_zm" )
                        playfxontag( level._effect["tomahawk_impact_ug"], a_zombies[i], tag );
                    else
                        playfxontag( level._effect["tomahawk_impact"], a_zombies[i], tag );

                    playfxontag( level._effect["tomahawk_fire_dot"], a_zombies[i], "j_spineupper" );
                    a_zombies[i] setclientfield( "play_tomahawk_hit_sound", 1 );
                    n_tomahawk_damage = calculate_tomahawk_damage( a_zombies[i], m_tomahawk.n_grenade_charge_power, m_tomahawk );
                    if (n_tomahawk_damage > a_zombies[i].health)
                    {
                        self add_to_player_score( 50 );
                        self.kills++;
                        self.pers["kills"] = self.kills;
                    }
                    a_zombies[i] dodamage( n_tomahawk_damage, m_tomahawk.origin, self, m_tomahawk, "none", "MOD_GRENADE", 0, "bouncing_tomahawk_zm" );
                    a_zombies[i].hit_by_tomahawk = 1;
                    self maps\mp\zombies\_zm_score::add_to_player_score( 10 );
                }
            }
        }

        wait 0.2;
    }

    self thread tomahawk_return_player( m_tomahawk, n_attack_limit );
}

watch_for_tomahawk_throw_custom()
{
    self endon( "disconnect" );

    while ( true )
    {
        self waittill( "grenade_fire", grenade, weapname );

        if ( !issubstr( weapname, "tomahawk_zm" ) )
            continue;

        grenade.use_grenade_special_bookmark = 1;
        grenade.grenade_multiattack_bookmark_count = 1;
        grenade.low_level_instant_kill_charge = 1;
        grenade.owner = self;
        self notify( "throwing_tomahawk" );

        if ( isdefined( self.n_tomahawk_cooking_time ) )
            grenade.n_cookedtime = grenade.birthtime - self.n_tomahawk_cooking_time;
        else
            grenade.n_cookedtime = 0;

        self thread check_for_time_out( grenade );
        self thread tomahawk_thrown( grenade );
    }
}

tomahawk_thrown_custom( grenade )
{
    self endon( "disconnect" );
    grenade endon( "in_hellhole" );
    grenade_owner = undefined;

    if ( isdefined( grenade.owner ) )
        grenade_owner = grenade.owner;

    playfxontag( level._effect["tomahawk_charged_trail"], grenade, "tag_origin" );
    self setclientfieldtoplayer( "tomahawk_in_use", 2 );
    grenade waittill_either( "death", "time_out" );
    grenade_origin = grenade.origin;
    a_zombies = getaispeciesarray( "axis", "all" );
    n_grenade_charge_power = grenade get_grenade_charge_power( self );
    a_zombies = get_array_of_closest( grenade_origin, a_zombies, undefined, undefined, 200 );
    a_powerups = get_array_of_closest( grenade_origin, level.active_powerups, undefined, undefined, 200 );

    if ( isdefined( level.a_tomahawk_pickup_funcs ) )
    {
        foreach ( tomahawk_func in level.a_tomahawk_pickup_funcs )
        {
            if ( [[ tomahawk_func ]]( grenade, n_grenade_charge_power ) )
                return;
        }
    }

    if ( isdefined( a_powerups ) && a_powerups.size > 0 )
    {
        m_tomahawk = tomahawk_spawn( grenade_origin, n_grenade_charge_power );
        m_tomahawk.n_grenade_charge_power = n_grenade_charge_power;

        foreach ( powerup in a_powerups )
        {
            powerup.origin = grenade_origin;
            powerup linkto( m_tomahawk );
            m_tomahawk.a_has_powerup = a_powerups;
        }

        self thread tomahawk_return_player( m_tomahawk, 0 );
        return;
    }

    if ( !isdefined( a_zombies ) )
    {
        m_tomahawk = tomahawk_spawn( grenade_origin, n_grenade_charge_power );
        m_tomahawk.n_grenade_charge_power = n_grenade_charge_power;
        self thread tomahawk_return_player( m_tomahawk, 0 );
        return;
    }
    else
    {
        foreach ( ai_zombie in a_zombies )
            ai_zombie.hit_by_tomahawk = 0;
    }

    if ( isdefined( a_zombies[0] ) && isalive( a_zombies[0] ) )
    {
        v_zombiepos = a_zombies[0].origin;

        if ( distancesquared( grenade_origin, v_zombiepos ) <= 4900 )
        {
            a_zombies[0] setclientfield( "play_tomahawk_hit_sound", 1 );
            n_tomahawk_damage = calculate_tomahawk_damage( a_zombies[0], n_grenade_charge_power, grenade );
            a_zombies[0] dodamage( n_tomahawk_damage, grenade_origin, self, grenade, "none", "MOD_GRENADE", 0, "bouncing_tomahawk_zm" );
            a_zombies[0].hit_by_tomahawk = 1;
            self maps\mp\zombies\_zm_score::add_to_player_score( 10 );
            self thread tomahawk_ricochet_attack( grenade_origin, n_grenade_charge_power );
        }
        else
        {
            m_tomahawk = tomahawk_spawn( grenade_origin, n_grenade_charge_power );
            m_tomahawk.n_grenade_charge_power = n_grenade_charge_power;
            self thread tomahawk_return_player( m_tomahawk, 0 );
        }
    }
    else
    {
        m_tomahawk = tomahawk_spawn( grenade_origin, n_grenade_charge_power );
        m_tomahawk.n_grenade_charge_power = n_grenade_charge_power;

        if ( isdefined( grenade ) )
            grenade delete();

        self thread tomahawk_return_player( m_tomahawk, 0 );
    }
}


tomahawk_return_player_custom( m_tomahawk, num_zombie_hit )
{
    self endon( "disconnect" );
    n_dist = distance2dsquared( m_tomahawk.origin, self.origin );

    if ( !isdefined( num_zombie_hit ) )
        num_zombie_hit = 5;

    while ( n_dist > 4096 )
    {
        if (check_for_botb_port() == true)
            m_tomahawk moveto( self geteye(), 0.25 * self.hawk_cd);
        else 
            m_tomahawk moveto( self geteye(), 0.25 );

        if ( num_zombie_hit < 5 )
        {
            self tomahawk_check_for_zombie( m_tomahawk );
            num_zombie_hit++;
        }

        wait 0.1;
        n_dist = distance2dsquared( m_tomahawk.origin, self geteye() );
    }

    if ( isdefined( m_tomahawk.a_has_powerup ) )
    {
        foreach ( powerup in m_tomahawk.a_has_powerup )
        {
            if ( isdefined( powerup ) )
                powerup.origin = self.origin;
        }
    }

    m_tomahawk delete();
    self playsoundtoplayer( "wpn_tomahawk_catch_plr", self );
    self playsound( "wpn_tomahawk_catch_npc" );

    if (check_for_botb_port() == false)
        wait 5;
    self playsoundtoplayer( "wpn_tomahawk_cooldown_done", self );
    self givemaxammo( self.current_tomahawk_weapon );
    a_zombies = getaispeciesarray( "axis", "all" );

    foreach ( ai_zombie in a_zombies )
        ai_zombie.hit_by_tomahawk = 0;

    self setclientfieldtoplayer( "tomahawk_in_use", 3 );
}


brutus_damage_override_custom( inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, shitloc, poffsettime, boneindex )
{
    if ((weapon == "spork_zm_alcatraz") && check_for_botb_port() == true && !(isdefined(self.is_boss)))
    {
        if (self.fakeHat)
            self.fakeHat delete();
        if (self.fakeBrutus)
            self.fakeBrutus delete();
        self dodamage(self.health + 666, self.origin);
        attacker add_to_player_score( 50 );
        attacker.kills++;
        attacker.pers["kills"] = attacker.kills;
        return;
    }
    if (isdefined(attacker.slayer_multiplier))
    {
        damage *= (1 + float(attacker.kills / 200));
    }
    if ( isdefined( attacker ) && isalive( attacker ) && isplayer( attacker ) && ( level.zombie_vars[attacker.team]["zombie_insta_kill"] || isdefined( attacker.personal_instakill ) && attacker.personal_instakill ) )
    {
        n_brutus_damage_percent = 1.0;
        n_brutus_headshot_modifier = 2.0;
    }
    else
    {
        n_brutus_damage_percent = level.brutus_damage_percent;
        n_brutus_headshot_modifier = 1.0;
    }

    if ( isdefined( weapon ) && is_weapon_shotgun( weapon ) )
    {
        n_brutus_damage_percent *= level.brutus_shotgun_damage_mod;
        n_brutus_headshot_modifier *= level.brutus_shotgun_damage_mod;
    }

    if ( isdefined( weapon ) && weapon == "bouncing_tomahawk_zm" && isdefined( inflictor ) )
    {
        self playsound( "wpn_tomahawk_imp_zombie" );

        if ( self.has_helmet )
        {
            if ( damage == 1 )
                return 0;

            if ( isdefined( inflictor.n_cookedtime ) && inflictor.n_cookedtime >= 2000 )
                self.helmet_hits = level.brutus_helmet_shots;
            else if ( isdefined( inflictor.n_grenade_charge_power ) && inflictor.n_grenade_charge_power >= 2 )
                self.helmet_hits = level.brutus_helmet_shots;
            else
                self.helmet_hits++;

            if ( self.helmet_hits >= level.brutus_helmet_shots )
            {
                self thread brutus_remove_helmet( vdir );

                if ( level.brutus_in_grief )
                    player_points = level.brutus_points_for_helmet;
                else
                {
                    multiplier = maps\mp\zombies\_zm_score::get_points_multiplier( self );
                    player_points = multiplier * round_up_score( level.brutus_points_for_helmet, 5 );
                }

                if ( isdefined( attacker ) && isplayer( attacker ) )
                {
                    attacker add_to_player_score( player_points );
                    attacker.pers["score"] = attacker.score;
                    level notify( "brutus_helmet_removed", attacker );
                }
            }

            return damage * n_brutus_damage_percent;
        }
        else
            return damage;
    }

    if ( isdefined( meansofdeath ) && ( meansofdeath == "MOD_MELEE" || meansofdeath == "MOD_IMPACT" ) )
    {
        if ( weapon == "alcatraz_shield_zm" )
        {
            shield_damage = level.zombie_vars["riotshield_fling_damage_shield"];
            inflictor maps\mp\zombies\_zm_weap_riotshield_prison::player_damage_shield( shield_damage, 0 );
            return 0;
        }
    }

    if ( isdefined( level.zombiemode_using_afterlife ) && level.zombiemode_using_afterlife && weapon == "lightning_hands_zm" )
    {
        self thread brutus_afterlife_teleport();
        return 0;
    }

    if ( is_explosive_damage( meansofdeath ) )
    {
        self.explosive_dmg_taken += damage;

        if ( !self.has_helmet )
            scaler = n_brutus_headshot_modifier;
        else
            scaler = level.brutus_damage_percent;

        if ( self.explosive_dmg_taken >= self.explosive_dmg_req && ( isdefined( self.has_helmet ) && self.has_helmet ) )
        {
            self thread brutus_remove_helmet( vectorscale( ( 0, 1, 0 ), 10.0 ) );

            if ( level.brutus_in_grief )
                player_points = level.brutus_points_for_helmet;
            else
            {
                multiplier = maps\mp\zombies\_zm_score::get_points_multiplier( self );
                player_points = multiplier * round_up_score( level.brutus_points_for_helmet, 5 );
            }

            attacker add_to_player_score( player_points );
            attacker.pers["score"] = inflictor.score;
        }

        return damage * scaler;
    }
    else if ( shitloc != "head" && shitloc != "helmet" )
        return damage * n_brutus_damage_percent;
    else
        return int( self scale_helmet_damage( attacker, damage, n_brutus_headshot_modifier, n_brutus_damage_percent, vdir ) );
}

zombie_damage_custom( mod, hit_location, hit_origin, player, amount, team )
{
    if (player GetCurrentWeapon() == "spork_zm_alcatraz" && check_for_botb_port() == true && !(isdefined(self.is_boss)))
    {
        self dodamage(self.health + 666, self.origin);
    }
    if ( is_magic_bullet_shield_enabled( self ) )
        return;

    player.use_weapon_type = mod;

    if ( isdefined( self.marked_for_death ) )
        return;

    if ( !isdefined( player ) )
        return;

    if ( isdefined( hit_origin ) )
        self.damagehit_origin = hit_origin;
    else
        self.damagehit_origin = player getweaponmuzzlepoint();

    if ( self check_zombie_damage_callbacks( mod, hit_location, hit_origin, player, amount ) )
        return;
    else if ( self zombie_flame_damage( mod, player ) )
    {
        if ( self zombie_give_flame_damage_points() )
            player maps\mp\zombies\_zm_score::player_add_points( "damage", mod, hit_location, self.isdog, team );
    }
    else
    {
        if ( player_using_hi_score_weapon( player ) )
            damage_type = "damage";
        else
            damage_type = "damage_light";

        if ( !( isdefined( self.no_damage_points ) && self.no_damage_points ) )
            player maps\mp\zombies\_zm_score::player_add_points( damage_type, mod, hit_location, self.isdog, team, self.damageweapon );
    }

    if ( isdefined( self.zombie_damage_fx_func ) )
        self [[ self.zombie_damage_fx_func ]]( mod, hit_location, hit_origin, player );

    modname = remove_mod_from_methodofdeath( mod );

    if ( is_placeable_mine( self.damageweapon ) )
    {
        if ( isdefined( self.zombie_damage_claymore_func ) )
            self [[ self.zombie_damage_claymore_func ]]( mod, hit_location, hit_origin, player );
        else if ( isdefined( player ) && isalive( player ) )
            self dodamage( level.round_number * randomintrange( 100, 200 ), self.origin, player, self, hit_location, mod );
        else
            self dodamage( level.round_number * randomintrange( 100, 200 ), self.origin, undefined, self, hit_location, mod );
    }
    else if ( mod == "MOD_GRENADE" || mod == "MOD_GRENADE_SPLASH" )
    {
        if ( isdefined( player ) && isalive( player ) )
        {
            player.grenade_multiattack_count++;
            player.grenade_multiattack_ent = self;
            self dodamage( level.round_number + randomintrange( 100, 200 ), self.origin, player, self, hit_location, modname );
        }
        else
            self dodamage( level.round_number + randomintrange( 100, 200 ), self.origin, undefined, self, hit_location, modname );
    }
    else if ( mod == "MOD_PROJECTILE" || mod == "MOD_EXPLOSIVE" || mod == "MOD_PROJECTILE_SPLASH" )
    {
        if ( isdefined( player ) && isalive( player ) )
            self dodamage( level.round_number * randomintrange( 0, 100 ), self.origin, player, self, hit_location, modname );
        else
            self dodamage( level.round_number * randomintrange( 0, 100 ), self.origin, undefined, self, hit_location, modname );
    }

    if ( isdefined( self.a.gib_ref ) && self.a.gib_ref == "no_legs" && isalive( self ) )
    {
        if ( isdefined( player ) )
        {
            rand = randomintrange( 0, 100 );

            if ( rand < 10 )
                player create_and_play_dialog( "general", "crawl_spawn" );
        }
    }
    else if ( isdefined( self.a.gib_ref ) && ( self.a.gib_ref == "right_arm" || self.a.gib_ref == "left_arm" ) )
    {
        if ( self.has_legs && isalive( self ) )
        {
            if ( isdefined( player ) )
            {
                rand = randomintrange( 0, 100 );

                if ( rand < 7 )
                    player create_and_play_dialog( "general", "shoot_arm" );
            }
        }
    }

    self thread maps\mp\zombies\_zm_powerups::check_for_instakill( player, mod, hit_location );
}
check_for_botb_port()
{
    found = 0;
	if (isdefined(level.net_port_botb))
	{
		foreach(port in level.net_port_botb)
		{
			if (getdvar("net_port") == port)
				found = 1;
		}
	}
    if (found == 0)
        return false;
    return true;
}

init()
{   
    level.net_port_botb = [];
    level.net_port_botb[level.net_port_botb.size] = "30001"; //botb
    level.net_port_botb[level.net_port_botb.size] = "30005"; //pv
    level.blessing_count = 10;
    if (check_for_botb_port() == false)
        return;

    level.votes = 0;
    level.extra_brutus = 0;
    level.extra_hp = 0;
    level.extra_speed = 0;
    level.primaryprogressbarwidth = 400;
    level.primaryprogressbarheight = 15;
    level.primaryprogressbarfontsize = 1;
    level.brutus_health = 6000;
    level.brutus_health_increase_custom = 18;

    level.zombie_ai_limit = 32;
    level.zombie_actor_limit = 40;

    setdvar("botb_hitless", "0");
    setdvar("king_lock", "0");
    setDvar("lock", "0");
    setDvar("noShakeVote", "");
    setDvar("noShake", "");
    setDvar("EE_Completion", "0");
    setDvar("brutus_helmet", "0");
    setDvar("brutus_oneshot", "0");
    setDvar("final_wave", "0");
    setDvar("game_end", "0");
    setDvar("wave", "0");
    setDvar("color", "");
    setDvar("slowed_player1", "-1");
    setDvar("slowed_player2", "-1"); 
    setDvar("brutus_sprint", "0");
    setDvar("brutus_walk", "0");
    setDvar("isBigMacShown", "0");
    setDvar("ninjaBrutus", "0");



    level.boss_name = "^1Brutus Primis^3";
    level.round_number = 0;
    level.game_started = 0;
    level.difficulty_selected = 0;
    level.ez_difficulty_vote_count = 0;
    level.gigachad_difficulty_vote_count = 0;
    level.chad_difficulty_vote_count = 0;
    level.ns_vote_required = 8;
    level.vote_required = 8;
    level.gamemode_difficulty = "^2Ez^7";
    level thread onPlayerConnect();
    level thread story();
    level thread spawnBrutus();
    level thread zmWatcher();
    level thread playerSpawnWatcher();
    level thread noShakeWatcher();
    level thread difficulty_watcher();
    level thread player_rev_watcher();
    level thread team_buff();
    level thread hitless_watcher();
    level.zombie_vars["riotshield_hit_points"] = level.zombie_vars["riotshield_hit_points"] * 20;

    level thread brutus_death_barrier();
    level.global_brutus_powerup_prevention = 1;
    level thread restart_checker();
    level thread check_for_m1911();
    flag_wait("initial_blackscreen_passed");
}

brutus_fire_teargas_when_possible_custom()
{
    self endon( "death" );
    wait 0.2;

    while ( isdefined( self.not_interruptable ) && self.not_interruptable )
        wait 0.05;

    self.not_interruptable = 1;
    self playsound( "vox_brutus_enraged" );
    self animscripted( self.origin, self.angles, "zm_teargas_attack" );
    self thread maps\mp\animscripts\zm_shared::donotetracks( "teargas_anim" );

    self waittillmatch( "teargas_anim", "grenade_drop" );

    v_org_left = self gettagorigin( "TAG_WEAPON_LEFT" );
    v_org_right = self gettagorigin( "TAG_WEAPON_RIGHT" );
    self thread sndplaydelayedsmokeaudio( v_org_left, v_org_right );
    //self magicgrenadetype( "willy_pete_zm", v_org_left, ( 0, 0, 0 ), 0.4 );
    //self magicgrenadetype( "willy_pete_zm", v_org_right, ( 0, 0, 0 ), 0.4 );

    self waittillmatch( "teargas_anim", "end" );

    self.not_interruptable = 0;
}

check_for_m1911()
{
    level endon("game_ended");

    for (;;)
    {
        foreach (player in level.players)
        {
            if (player GetCurrentWeapon() == "m1911_zm" || player GetCurrentWeapon() == "m1911_upgraded_zm")
                player TakeWeapon(player GetCurrentWeapon());
        }
        wait 0.5;
    }
}

restart_checker()
{
    level.is_game_stuck = 1;
    level thread watch_for_stuck_restart();
    flag_wait("initial_blackscreen_passed");
    level.is_game_stuck = 0;
}

watch_for_stuck_restart()
{
    wait 180;
    if (level.is_game_stuck == 1)
        executeCommand("map_restart");
}

hitless_watcher()
{
    level endon("game_ended");

    flag_wait("initial_blackscreen_passed");
    for(;;)
    {
        if (isdefined(level.on_bridge))
            break;
        wait 0.1;
    }
    foreach(player in level.players)
    {
        player.og = 1;
        player.max_hp = player.maxhealth;
    }
    for (;;)
    {
        foreach(player in level.players)
        {
            if (isdefined(player.got_hit))
                continue;
            if (!isdefined(player.og))
                player.got_hit = 1;
            else if (player.health < player.max_hp || player.sessionstate == "spectator")
            {
                player.got_hit = 1;
            }
        }
        wait 0.1;
    }
}
gamemode_hud()
{
    self endon("disconnect");
    level endon("game_ended");

    flag_wait("initial_blackscreen_passed");
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

// x  -2200 to -90 
// y -4120 to -2950
// z -7882 to -9079
brutus_death_barrier()
{
    level waittill("start_of_round");

    for (;;)
    {
        zombies = getaiarray(level.zombie_team);
        for ( i = 0; i < zombies.size; i++ )
        {
            if (isdefined(zombies[i].is_bridge_brutus) || isdefined(zombies[i].is_brutus))
            {
                if (zombies[i].origin[0] < -2200 || zombies[i].origin[0] > -90
                || zombies[i].origin[1] < -4120 || zombies[i].origin[1] > -2950
                || zombies[i].origin[2] < -9079 || zombies[i].origin[2] > -7882)
                    zombies[i] DoDamage(zombies[i].maxhealth + 1, zombies[i].origin);
            }
        }
        wait 5; 
    }

}

onPlayerConnect()
{
    if (check_for_botb_port() == false)
        return;


	while( 1 )
	{
		level waittill( "connected", player );
		player thread onPlayerSpawned();
        player thread WaveWatcher();
        player thread FinalMsg();
        player thread removeAfterlives();
        player thread ammoRegen();
        player thread permaSprint();
        player thread gamemode_hud();
	}
}

team_buff()
{
    level endon("game_ended");
    flag_wait("initial_blackscreen_passed");

    wait 5;
    m_id = 0;
    r = randomint(100);
    r2 = randomint(100);
    if (r > 85)//85
    {
        m_id = 1;
        level.str1 = "^2Death Incarnate^7\n- All players receive a death machine"; 
        level.death_machine = 1;
    }
    else if (r > 70) //70
    {
        m_id = 2;
        level.str1 = "^2Shiny^7\n- All players receive a golden spoon";  
        level thread give_spork();
        foreach(player in level.players)
        {
            player.current_tomahawk_weapon = "spork_zm_alcatraz";
        }
    }
    else if (r > 55)
    {
        m_id = 3;
        level.str1 = "^2Running in the 90s^7\n- Your team is zooming";
        level.extra_speed = 0.25;
    }
    else if (r > 40)
    {
        m_id = 4;
        level.str1 = "^2Double Tap 3.0^7\n- Grant an empowered Double Tap\n- Lost if downed";
        setdvar("perk_weapRateMultiplier", "0.5");
        setdvar("fire_rate", "0.5");
        level waittill("start_of_round");
        foreach(player in level.players)
        {
            if (player HasPerk("specialty_rof") == 0)
                player thread maps\mp\zombies\_zm_perks::wait_give_perk("specialty_rof", 1); 
        }
    }
    else if (r > 20)
    {
        m_id = 5;
        level.str1 = "^2Medic Squad^7\n- Increased revive speed";
        level.faster_revive = 1;
    }
    else if (r >= 0)
    {
        m_id = 6;
        level.str1 = "^2Brutus Slayer^7\n- Each kill grant 2 permanent HP";
        level.hp_stack = 1;
    }

    //ENEMY BUFF
    if (r2 > 80)
    {
        level.str2 = "^1Sneaky Brutus^7\n- Brutus spawn point changed";
        level.brutus_new_spawns = 1;
    }
    else if (r2 > 55)
    {
        level.str2 = "^1Juggernauts^7\n- Brutus are beefy";
        level.beefy_brutus = 1;
    } 
    else if (r2 > 20)
    {
        level.str2 = "^1Endless Horde^7\n- More Brutus spawns";
        level.extra_brutus = 4;
    }
    else if (r2 >= 0)
    {
        level.str2 = "^2None^7\n- You lucky nugget !";
    }

    for (i = 0; i < 90; i++)
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
        level.str1 += "\n ^6[GUILD]^7 ";
        for (;;)
        {
            r = randomint(100);
            if (r > 85 && m_id != 1)
                break;
            else if (r > 70 && m_id != 2)
                break;
            else if (r > 55 && m_id != 3)
                break;
            else if (r > 40 && m_id != 4)
                break;
            else if (r > 20 && m_id != 5)
                break;
            else if (r > 0 && m_id != 6)
                break;
            wait 0.05;
        }

        if (r > 85)
        {
            level.str1 += "^2Death Incarnate^7\n- All players receive a death machine"; 
            level.death_machine = 1;
        }
        else if (r > 70)
        {
            level.str1 += "^2Shiny^7\n- All players receive a golden spoon";  
            level thread give_spork();
            foreach(player in level.players)
            {
                player.current_tomahawk_weapon = "spork_zm_alcatraz";
            }
        }
        else if (r > 55)
        {
            level.str1 += "^2Running in the 90s^7\n- Your team is zooming";
            level.extra_speed = 0.25;
        }
        else if (r > 40)
        {
            level.str1 += "^2Double Tap 3.0^7\n- Grant an empowered Double Tap\n- Lost if downed";
            setdvar("perk_weapRateMultiplier", "0.5");
            setdvar("fire_rate", "0.5");
            level waittill("start_of_round");
            foreach(player in level.players)
            {
                if (player HasPerk("specialty_rof") == 0)
                    player thread maps\mp\zombies\_zm_perks::wait_give_perk("specialty_rof", 1); 
            }
        }
        else if (r > 20)
        {
            level.str1 += "^2Medic Squad^7\n- Increased revive speed";
            level.faster_revive = 1;
        }
        else if (r >= 0)
        {
            level.str1 += "^2Brutus Slayer^7\n- Each kill grant 2 permanent HP";
            level.hp_stack = 1;
        }
    }
    level.modif_lock = 1;
}


give_spork()
{
    level endon("game_ended");

    for(;;)
    {
        foreach(player in level.players)
        {
            if (!(player hasweapon("spork_zm_alcatraz")))
                player giveweapon( "spork_zm_alcatraz" );
        }
        wait 1;
    }
}
player_rev_watcher()
{
    level endon ("game_ended");
    flag_wait("initial_blackscreen_passed");

    for (;;)
    {
        foreach(player in level.players)
        {
            if (player.sessionstate == ("spectator") && !isdefined(player.lock))
            {
                player.lock = 1;
                player thread waittill_rev();
            }
        }
        wait 1;
    }
}

waittill_rev()
{
    level endon ("game_ended");
    self endon ("disconnect");

    for (;;)
    {
        if (self.sessionstate != ("spectator"))
        {
            id = self getEntityNumber();
          //  self.spectator_respawn = undefined;
            level.pers_upgrade_revive = 1;
            tag = strTok(self.name, "]");
            if (tag[1] == "^6[VIP" || tag[1] == "[^6VIP^7" || tag[1] == "^1[VIP" || tag[1] == "[^1VIP^7" || tag[1] == "[^2VIP^7")
            {
                self thread permaQuickRevive();
            }
        //    self TakeAllWeapons();
            self thread TpToBridge(id);
            self SetMoveSpeedScale(1.05);
            wait 0.2;
            foreach(guid in level.premium_pass_guid_list)
            {
                if (self getguid() == guid)
                {
                    self giveweapon("ak47_upgraded_zm", 0, self maps\mp\zombies\_zm_weapons::get_pack_a_punch_weapon_options( "ak47_upgraded_zm" ) );
                    self SwitchToWeapon("ak47_upgraded_zm");
                    self.lock = undefined;
                    return;
                }
            }
            foreach(guid in level.premium_pass_guid_list2)
            {
                if (self getguid() == guid)
                {
                    self giveweapon("ak47_upgraded_zm", 0, self maps\mp\zombies\_zm_weapons::get_pack_a_punch_weapon_options( "ak47_upgraded_zm" ) );
                    self SwitchToWeapon("ak47_upgraded_zm");
                    self.lock = undefined;
                    return;
                }
            }
            self GiveWeapon("thompson_zm");
            self SwitchToWeapon("thompson_zm");
            self.lock = undefined;
            return;
        }
        wait 0.5;
    }
}


noShakeWatcher()
{
    level endon("game_ended");
    level waittill( "initial_blackscreen_passed");

    vote = 0;
    guidList = [];
    guidList[0] = "999999";
    for (;;)
    {
        if (getDvar("noShakeVote") != "")
        {
            pGuid = getDvar("noShakeVote");
            setDvar("noShakeVote", "");
            forEach(guid in guidList)
            {
                if (pGuid == guid)
                {
                    getPlayerByGuid(pGuid) iprintln("^3You've ^5already voted^3 this run");
                }
                else
                {
                    if (level.players.size >= 6)
                        level.ns_vote_required = level.players.size - 2;
                    else if (level.players.size >= 3)
                        level.ns_vote_required = level.players.size - 1;
                    else
                        level.ns_vote_required = level.players.size;
                    guidList[guidList.size] = pGuid;
                    setDvar("ln", ("^5" + getPlayerByGuid(pGuid).name +
                    " ^3has voted to disable ^5shaking & animations^7 (^2" + guidList.size + "^3/^1" + level.ns_vote_required + "^3)"));
                    break;
                }
            }
        }
        if (guidList.size >= level.ns_vote_required)
        {
            setDvar("noShake" , "1");
            setDvar("bold", "^5Shaking & Brutus animations ^1[Disabled]");
            return;
        }
        wait 0.05;
    }   
}


permaSprint()
{
    if (check_for_botb_port() == false)
        return;

    for (;;)
    {
        self allowsprint( 1 );
        wait 0.5;
    }
}

noPermaQuickRevive()
{
    tag = strTok(self.name, "]");
    if (tag[1] == "^6[VIP" || tag[1] == "[^6VIP^7" || tag[1] == "^1[VIP" || tag[1] == "[^1VIP^7"  || tag[1] == "[^2VIP^7")
    {
        return;
    }
    for (;;)
    {
        self.pers_upgrades_awarded["revive"] = 0;
        wait 0.1;
    }
}

permaQuickRevive()
{
    for (;;)
    {
        self.pers_upgrades_awarded["revive"] = 1;
        wait 0.1;
    }
}
onPlayerSpawned()
{
	self endon( "disconnect" );
	level endon( "game_ended" ); 
    self.extrahp = 0;

    flag_wait("initial_blackscreen_passed");
    
    //self.spectator_respawn = undefined;
    level.pers_upgrade_revive = 1;
    tag = strTok(self.name, "]");
    if (tag[1] == "^6[VIP" || tag[1] == "[^6VIP^7" || tag[1] == "^1[VIP" || tag[1] == "[^1VIP^7"  || tag[1] == "[^2VIP^7")
    {
        self thread permaQuickRevive();
    }
    for (;;)
    {
        if (level.game_started == 0)
        {
            if (isAlive(self) && !self.afterlife)
            {
            //    self TakeAllWeapons();
                id = self getEntityNumber();
                self thread TpToCell(id);
                self SetMoveSpeedScale(1.05);
                break;
            }
        }
        wait 0.1;
    }
    if (level.game_started == 0)
        level waittill("start_of_round");
    if (tag[1] == "^6[VIP" || tag[1] == "[^6VIP^7" || tag[1] == "^1[VIP" || tag[1] == "[^1VIP^7"  || tag[1] == "[^2VIP^7")
    {
        self iprintln("Enjoy a ^3nice^7 little ^5refreshing drink ! ^6<3 u perma vip's");
        self thread scripts\AATs_Perks::drawshader_and_shadermove( "Dying_Wish", 1, 1, "custom" );
    }
    wait 19;
    self thread TpToBridge(id);
    group = 0;

    if (tag[0] == "[^3SSS^7" || tag[0] == "[^6 I ^7" || tag[0] == "[^6II^7"|| tag[0] == "[^6III^7"
    || tag[1] == "[^3VIP^7" || tag[1] == "^3[VIP" || tag[1] == "^6[VIP" || tag[1] == "[^6VIP^7"
    || tag[0] == "[^5IV^7" || tag[0] == "[^5V^7" || tag[0] == "[^5VI^7" || tag[0] == "[^5VII^7"
    || tag[0] == "[^1IIX^7]" || tag[0] == "[^1IX^7]" || tag[0] == "[^1-X-^7]"
    || tag[1] == "[^1VIP^7" || tag[1] == "^1[VIP"  || tag[1] == "[^2VIP^7")
    {
        group = 3;
    }
    else if (tag[0] == "[^8E^7" || tag[0] == "[^4C^7" || tag[0] == "[^2D^7")
    {
        group = 1;
    }
    else if (tag[0] == "[^5B^7" || tag[0] == "[^6A^7" || tag[0] == "[^3S^7" ||  tag[0] == "[^3SS^7")
    {
        group = 2;
    }

    if (isdefined(self.hawk_cd)) //dont give weapon to hawk players
        return;
    if (isdefined(level.death_machine))
    {
        if (isAlive(self))
        {
            weapon_loadout = self GetWeaponsListPrimaries();
            if (weapon_loadout.size >= 2)
                self TakeWeapon(self GetCurrentWeapon());          
            self GiveWeapon("minigun_alcatraz_zm");
            self SwitchToWeapon("minigun_alcatraz_zm");
            return;
        }
    }

    foreach(guid in level.premium_pass_guid_list)
    {
        if (self getguid() == guid)
        {
            self giveweapon("ak47_upgraded_zm", 0, self maps\mp\zombies\_zm_weapons::get_pack_a_punch_weapon_options( "ak47_upgraded_zm" ) );
            self SwitchToWeapon("ak47_upgraded_zm");
            self.lock = undefined;
            return;
        }
    }
    foreach(guid in level.premium_pass_guid_list2)
    {
        if (self getguid() == guid)
        {
            self giveweapon("ak47_upgraded_zm", 0, self maps\mp\zombies\_zm_weapons::get_pack_a_punch_weapon_options( "ak47_upgraded_zm" ) );
            self SwitchToWeapon("ak47_upgraded_zm");
            self.lock = undefined;
            return;
        }
    }
    if (group == 1)
    {
        self GiveWeapon("m14_zm");
        self SwitchToWeapon("m14_zm");
    }
    else if (group == 2)
    {
        self GiveWeapon("beretta93r_zm");
        self SwitchToWeapon("beretta93r_zm");
    }
    else if (group == 3)
    {
        self GiveWeapon("thompson_zm");
        self SwitchToWeapon("thompson_zm");
    }
}

modified_main_start() //Sets all personal upgrades on
{
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
    flag_wait("initial_blackscreen_passed");
    
    for (;;)
    {
        if (!(self.sessionstate == "spectator"))
        {
            if(!isdefined(self.old_maxhealth))
            {
                if (isdefined(level.hp_stack))
                    extra_hp = (self.kills * 2);
                else
                    extra_hp = 0;
                if (isdefined(self.extrahp) && self.extrahp == 1)
                    self.maxhealth = 600 + level.extra_hp + extra_hp;
                else
                    self.maxhealth = 400 + level.extra_hp + extra_hp;
            }


            stockcount = self getweaponammostock( self GetCurrentWeapon() );
            self setWeaponAmmostock( self GetCurrentWeapon(), stockcount + 500 );
            wait 2;     
        }
        wait 3;
    }
}

playerSpawnWatcher()
{
    flag_wait("initial_blackscreen_passed");

    foreach ( player in level.players )
        maps\mp\_visionset_mgr::vsmgr_activate( "visionset", "zm_audio_log", player );
    second = 0;
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
        if (second >= 15)
            break;
        wait 1;
    }
    level waittill("start_of_round");
    for (i = 0; i < level.players.size; i++)
    {
        if (!(level.players[i].sessionstate == "spectator") && getdvar("final_wave") != "1")
        {
            if (isdefined(level.players[i].speedrunner))
                level.players[i] SetMoveSpeedScale(1.20);
            else
                level.players[i] SetMoveSpeedScale(1.05);
        } 
    } 
    for (;;)
    {
        alive_player = 0;
        for (i = 0; i < level.players.size; i++)
        {
            if (!(level.players[i].sessionstate == "spectator"))
            {
                alive_player++;
            }
            if (level.players[i] HasPerk("specialty_armorvest") == 0)
                level.players[i] thread maps\mp\zombies\_zm_perks::wait_give_perk("specialty_armorvest", 1); 
        } 
       /* if (alive_player <= 1) 
        {
            setDvar("bold", "^3Without a teammate, ^1No victory.");
            for (i = 0; i < level.players.size; i++)
            {
                if (!(level.players[i].sessionstate == "spectator"))
                {
                    level.players[i] SetMoveSpeedScale(0.2);
                } 
            }          
        }
        else
        {*/  
      //  }

        wait 2;
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
        boss_name_text settext("^1Brutus Ultimis");
    else if (level.gamemode_difficulty == "^6GigaChad^7")
        boss_name_text settext("^1Brutus Suprimis");
    else
        boss_name_text settext("^1Brutus Primis");
    boss_health_text.hidewheninmenu = 1;

    /*for (i = 0; i < 200; i++)
    {
        boss_hud_alpha(boss_bar, boss_name_text, boss_health_text, i / 2);
        wait 0.1;
    }*/
    while (1)
    {
        if (level.intermission == 1)
        {
            return;
        }
        if (level.boss.health <= 1)
        {
            boss_bar.barframe destroy();
            boss_bar.bar destroy();
            boss_bar destroy();
            boss_name_text destroy();
            boss_health_text destroy();
            setDvar("game_end", "1");
            foreach ( player in level.players )
                maps\mp\_visionset_mgr::vsmgr_deactivate( "visionset", "zm_audio_log", player );
            wait 3;
            if (level.gamemode_difficulty == "^1Chad^7")
                setDvar("EE_Completion", "BotB_Final_Chad");
            else if (level.gamemode_difficulty == "^6GigaChad^7")
                setDvar("EE_Completion", "BotB_Final_GigaChad");
            else
                setDvar("EE_Completion", "BotB_Final");
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
            boss_bar updatebar(level.boss.health / level.boss.maxhealth);
        if (level.gamemode_difficulty == "^6GigaChad^7")
        {
            if (level.boss.health > level.boss.maxhealth - (level.boss.health / 5))
                boss_health_text settext("^1IT'S OVER 9000 !!!");
            else 
            {
                boss_health_text settext("");
                boss_health_text setvalue(level.boss.health);
            }
        }
        else 
        {
            boss_health_text setvalue(level.boss.health);
        }


        wait 0.3;
    }
}

boss_hud_alpha(boss_bar, boss_name_text, boss_health_text, alpha)
{
    boss_bar.barframe.alpha = alpha;
    boss_bar.bar.alpha = alpha;
    boss_bar.alpha = alpha;
    boss_name_text.alpha = alpha;
    boss_health_text.alpha = alpha;
}

WaveWatcher()
{
    self endon("disconnect");
    level endon ("game_ended");

    flag_wait("initial_blackscreen_passed");
    
  //  if (int(getdvar("wave")) <= 0)
  //      level waittill("start_of_round");
    wave = getDvar("wave");
    self.zombieTextWave = maps\mp\gametypes_zm\_hud_util::createFontString( "hudsmall" , 3 );
    self.zombieTextWave maps\mp\gametypes_zm\_hud_util::setPoint( "BOTTOM", "LEFT", -15, 220 );
    self.zombieTextWave.label = &"^3Wave ^2";
    self.zombieTextWave setValue(int(wave));
    self.zombieTextWave.alpha = 0.8;
    for (;;)
    {
        wave = getDvar("wave");
        if (int(wave) == 20)
            self.zombieTextWave.label = &"^1Wave : ";
        else if (int(wave) >= 15)
            self.zombieTextWave.label = &"^3Wave : ^6";  
        else if (int(wave) >= 12)
            self.zombieTextWave.label = &"^3Wave : ^4";      
        else if (int(wave) >= 5)
            self.zombieTextWave.label = &"^3Wave : ^5";
        self.zombieTextWave setValue(int(wave));
        wait 1;
    }
}

FinalMsg()
{
    self endon("disconnect");
    level endon ("game_ended");
    flag_wait("initial_blackscreen_passed");
    
    for (;;)
    {
        if (getDvar("game_end") == "1")
        {
            str = "";

            foreach(index, player in level.players)
            {
                if (!isdefined(player.got_hit) && isdefined(player.og))
                {
                    str += player getguid();
                    if (index + 1 < level.players.size)
                        str += ";";
                    level.hitless = 1;
                }
            }
            if (isdefined(level.hitless))
                setdvar("botb_hitless", str);
            zombies = getaiarray(level.zombie_team);
            for ( i = 0; i < zombies.size; i++ )
            {
                zombies[i] dodamage( zombies[i].health + 666, zombies[i].origin );
            }
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
                setdvar("gamemode_speedrun_quest_botb", ((GetTime() - level.start_time) / 1000 / 60) + ";" + txt);
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
            executeCommand("fast_restart"); //restart map
        }
        wait 5;
    }
}
removeAfterlives()
{
    self endon("disconnect");
    level endon ("game_ended");
    flag_wait("initial_blackscreen_passed");
    
    for (;;)
    {
        self.lives = 0;            
        wait 0.5;
    }
}

story()
{
    level endon ("game_ended");
    flag_wait("initial_blackscreen_passed");

    level.zones["zone_golden_gate_bridge"].is_enabled = 1;
    level.zones["zone_golden_gate_bridge"].is_spawning_allowed = 1;
    level.brutus_zombie_per_round = 999;
    level waittill("start_of_round");
    wait 20;
    iprintln("^3[" + level.boss_name + "]^7 : Foolish prisoners, you dare ^3defy me ^7?");
    wait 5;
    iprintln("^3[" + level.boss_name + "]^7 : You should all know by now that ^3no one escapes alive^7.");
    wait 5;
    iprintln("^3[" + level.boss_name + "]^7 : Prepare yourself to die, ^3my little cell rats^7 !");
    wait 10;

    iprintln("^8C rank^7 - ^5B rank^7 starting weapon : ^5M14");
    iprintln("^6A rank^7 - ^3S rank^7 starting weapon : ^5B23R");
    iprintln("^3SS+ rank - ^3VIP^7 starting weapon : ^5Thompson");
}

zmWatcher()
{
    level endon ("game_ended");
    flag_wait("initial_blackscreen_passed");
    
    for (;;)
    {
        level.round_number = 0;
        level.zombie_total = 1;

        zombies = getaiarray(level.zombie_team);
        for ( i = 0; i < zombies.size; i++ )
        {
            if (isdefined(zombies[i].is_bridge_brutus) || isdefined(zombies[i].is_brutus))
                continue;
            zombies[i] dodamage( zombies[i].health + 666, zombies[i].origin );
        }
        wait 2; 
    }
}

blessingArray(x)
{
    blessingArray = [];

    glutton = [];
    glutton[0] = "^1Glutton^7";
    glutton[1] = "^3Big Mac immunity";    

    extraLife = [];
    extraLife[0] = "^1Extra Life^7";
    extraLife[1] = "^3Get a Dying wish charge";

    magicWeapon = [];
    magicWeapon[0] = "^1Magic Weapon^7";
    magicWeapon[1] = "^3Gain a special weapon";   

    speedRunner = [];
    speedRunner[0] = "^1SpeedRunner^7";
    speedRunner[1] = "^3Increase your speed";

    quickRevive = [];
    quickRevive[0] = "^1Medic";
    quickRevive[1] = "^3Increase revive speed";

    juggernautPlus = [];
    juggernautPlus[0] = "^1Juggernaut^7";
    juggernautPlus[1] = "^3Increase your HP";

    In_plain_sight = [];
    In_plain_sight[0] = "^1Time Breaker^7";
    In_plain_sight[1] = "^3Use Melee to stop time";

    slayer = [];
    slayer[0] = "^1Slayer";
    slayer[1] = "^3Gain 0.5 percent\n damage per kill";

    healer = [];
    healer[0] = "^1Combat Medic";
    healer[1] = "^3   Gain 0.5 percent\nrevive speed per kill";

    hawk = [];
    hawk[0] = "^1The Eagle";
    hawk[1] = "^3    Gain a Tomahawk\nIt upgrades every kills";  

    if (x == 0)
    {
        blessingArray = glutton;
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
        blessingArray = In_plain_sight;
    }
    else if (x == 7)
    {
        blessingArray = slayer;
    }
    else if (x == 8)
    {
        blessingArray = healer;
    }
    else if (x == 9)
    {
        blessingArray = hawk;
    }
    return blessingArray;
}

difficulty_watcher()
{
    level endon("disconnected");

    for (;;)
    {
        if (level.game_started == 1)
        {
            if (level.gigachad_difficulty_vote_count >= level.chad_difficulty_vote_count && level.gigachad_difficulty_vote_count >= level.ez_difficulty_vote_count)
            {
                level.difficulty_selected = 1;
                level.gamemode_difficulty = "^6GigaChad^7";
                level.boss_name = "^1Brutus Suprimis^3";
                wait 5;
                iprintln("Selected difficulty : ^6GigaChad^7.");
                wait 8;
                iprintln("^3[ " + level.boss_name + " ]^7 : ^1Y'all donzo");
                return;
            }
            else if (level.chad_difficulty_vote_count >= level.ez_difficulty_vote_count)
            {
                level.difficulty_selected = 1;
                level.gamemode_difficulty = "^1Chad^7";
                level.boss_name = "^1Brutus Ultimis^3";
                wait 5;
                iprintln("Selected difficulty : ^1Chad^7.");
                wait 3;
                iprintln("^3[ " + level.boss_name + " ]^7 : ^1Game on.");
                return;
            }
            else
            {
                level.difficulty_selected = 1;
                level.gamemode_difficulty = "^2Ez^7";
                level.boss_name = "^1Brutus Primis^3";
                wait 5;
                iprintln("Selected difficulty : ^2Ez^7.");
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
    self.zombieChoiceRightDesc settext("You're gonna have a ^1bad^7 time\n   ^3    Reward multiplier : ^5x2^7\n");
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

    if (IsSubStr(self.name , "^1VIP") || IsSubStr(self.name , "^1[VIP") || IsSubStr(self.name , "[^2VIP") || IsSubStr(self.name , "[^2VIP"))
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
        playfx( level._effect["afterlife_teleport"], self.origin );
    }
    self playsound( "zmb_quest_electricchair_spawn" );

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
    selector = "left";
    tag = strTok(self.name, "]");

    maps\mp\_visionset_mgr::vsmgr_activate( "visionset", "zm_audio_log", self );

    for (;;)
    {
        x = randomintrange(0, level.blessing_count);
        if (x != 0 || (x == 0 && getdvar("isBigMacShown") == "0"))
        {
            if ((x == 4 || x == 1) && (tag[1] == "^6[VIP" || tag[1] == "[^6VIP^7" || tag[1] == "^1[VIP" || tag[1] == "[^1VIP^7" || tag[1] == "[^2VIP^7"))
                continue;
            else if (x != 0)
                break;
        }
        wait 0.1;
    }
    blessingArrayLeft = blessingArray(x);
    for (;;)
    {
        y = randomintrange(0, level.blessing_count);
        if (y != x && (y != 0 || (y == 0 && getdvar("isBigMacShown") == "0")))
        {
            if ((y == 4 || y == 1) && (tag[1] == "^6[VIP" || tag[1] == "[^6VIP^7" || tag[1] == "^1[VIP" || tag[1] == "[^1VIP^7" || tag[1] == "[^2VIP^7"))
                continue;
            else if (y != 0)
                break;
        }
        wait 0.1;
    }
    blessingArrayRight = blessingArray(y);    

    second_blessing = 1;
    if (tag[0] != "[^3SSS^7" && tag[0] != "[^6 I ^7" && tag[0] != "[^6II^7" && tag[0] != "[^6III^7"
    && tag[1] != "^3[VIP" && tag[1] != "[^3VIP^7" && tag[1] != "^6[VIP" && tag[1] != "[^6VIP^7"
    && tag[0] != "[^5IV^7" && tag[0] != "[^5V^7" && tag[0] != "[^5VI^7" && tag[0] != "[^5VII^7"
    && tag[0] != "[^1IIX^7]" && tag[0] != "[^1IX^7]" && tag[0] != "[^1-X-^7]"
    && tag[1] != "[^1VIP^7" && tag[1] != "^1[VIP"
    && tag[1] != "[^2VIP^7")
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
    self.zombieChoiceAdesc settext("^3Melee^5 to switch, ^3Use^5 to confirm^7\n               ^3Jump^5 to reroll");
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
                    playfx( level._effect["afterlife_teleport"], self.origin );
                }
                self playsound( "zmb_quest_electricchair_spawn" );
                break;
            }
            else if (selector == "right" && second_blessing == 1)
            {
                self thread applyBlessing(y);
                for (i = 0; i < 10; i++)
                {
                    playfx( level._effect["afterlife_teleport"], self.origin );
                }
                self playsound( "zmb_quest_electricchair_spawn" );
                break;
            }

        }
        if (self JumpButtonPressed())
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
                if (x != 0 || (x == 0 && getdvar("isBigMacShown") == "0"))
                {
                    if ((x == 4 || x == 1) && (tag[1] == "^6[VIP" || tag[1] == "[^6VIP^7" || tag[1] == "^1[VIP" || tag[1] == "[^1VIP^7" || tag[1] == "[^2VIP^7" || tag[1] == "^2[VIP^7"))
                        continue;
                  //  if (x == old_x || x == old_y)
                  //      continue;
                    else if (x != 0)
                        break;
                }
                wait 0.05;
            }
            blessingArrayLeft = blessingArray(x);
            for (;;)
            {
                y = randomintrange(0, level.blessing_count);
                if (y != x && (y != 0 || (y == 0 && getdvar("isBigMacShown") == "0")))
                {
                    if ((y == 4 || y == 1) && (tag[1] == "^6[VIP" || tag[1] == "[^6VIP^7" || tag[1] == "^1[VIP" || tag[1] == "[^1VIP^7" || tag[1] == "[^2VIP^7"  || tag[1] == "^2[VIP^7"))
                        continue;
                   // if (y == old_x || y == old_y)
                    //    continue;
                    else if (y != 0)
                        break;
                }
                wait 0.05;
            }
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
    maps\mp\_visionset_mgr::vsmgr_deactivate( "visionset", "zm_audio_log", self);   
}

applyBlessing(blessingNumber)
{
    if (blessingNumber == 0)
    {
        iprintln(self.name + " ^7picked ^3Glutton");
        self.noslow = 1;
        self iPrintln("^3You can hear your ^5stomach growling^7!");
    }
    else if (blessingNumber == 1)
    {
        iprintln(self.name + " ^7picked ^3Extra Life");
        self thread scripts\AATs_Perks::drawshader_and_shadermove( "Dying_Wish", 1, 1, "custom" );
        self iPrintln("^3It feels like ^5a guardian angel^3 is watching you^7 !");
    }
    else if (blessingNumber == 2)
    {
        iprintln(self.name + " ^7picked ^3Magic weapon");
        weapon_loadout = self GetWeaponsListPrimaries();
        if (weapon_loadout.size >= 2)
            self TakeWeapon(self GetCurrentWeapon());
        weapon_name = "";
        i = randomintrange(0, 100);
        if (i >= 95)
            weapon_name = "blundergat_zm";
        else if (i >= 90)
            weapon_name = "raygun_mark2_zm";
        else if (i >= 60)
            weapon_name = "lsat_zm";
        else if (i >= 30)
        {
            weapon_name = "blundergat_zm";
            if (level.gamemode_difficulty == "^1Chad^7" || level.gamemode_difficulty == "^6GigaChad^7")
                weapon_name = "lsat_zm";
        }
        else if (i >= 0)
            weapon_name = "galil_zm";
        self GiveWeapon(weapon_name);
        self SwitchToWeapon(weapon_name);
        self iPrintln("^3A ^2magic weapon ^5suddenly materialized^3 in your hand!");
    }
    else if (blessingNumber == 3)
    {
        iprintln(self.name + " ^7picked ^3Speedrunner");
         self.speedrunner = 1;
         self SetMoveSpeedScale(1.15);
         self iPrintln("^3You feel as ^5light as a feather!^7");
    }
    else if (blessingNumber == 4)
    {
        iprintln(self.name + " ^7picked ^3Medic");
        self thread permaQuickRevive();
        self.perma_quick = 1;
        self iPrintln("^3No team survives without a ^5Medic");   
    }
    else if (blessingNumber == 5)
    {
        iprintln(self.name + " ^7picked ^3Juggernaut");
        self iPrintln("^3You feel ^1bulkier");
        self.extrahp = 1;
    }
    else if (blessingNumber == 6)
    {
        iprintln(self.name + " ^7picked ^3Time Breaker");
        self thread in_plain_sight();
    }
    else if (blessingNumber == 7)
    {
        iprintln(self.name + " ^7picked ^3Slayer");
        self.slayer_multiplier = 1;
    }
    else if (blessingNumber == 8)
    {
        iprintln(self.name + " ^7picked ^3Combat Medic");
        self.healer_multiplier = 1;
    }
    else if (blessingNumber == 9)
    {
        self.hawk_cd = 0.5;
        self.loadout.hastomahawk = 1;
        self giveweapon( "zombie_tomahawk_flourish" );
        self switchtoweapon( "zombie_tomahawk_flourish" );

        self giveweapon( "bouncing_tomahawk_zm" );
        self set_player_tactical_grenade( "bouncing_tomahawk_zm" );
        self setclientfieldtoplayer( "tomahawk_in_use", 1 );

        self thread watch_hawk_kill_count();
        self thread tomahawk_clear_guns();
        self thread tomahawk_watcher();
    }
    if (blessingNumber != 4)
        self thread noPermaQuickRevive();
}

tomahawk_watcher()
{
    self endon("disconnect");

    for(;;)
    {
        if (self maps\mp\zombies\_zm_laststand::player_is_in_laststand())
        {
            for(;;)
            {
                if (!(self maps\mp\zombies\_zm_laststand::player_is_in_laststand()) && (self.sessionstate != "spectator"))
                {
                    if (self.kills > 15)
                    {
                        self takeweapon( "bouncing_tomahawk_zm" );
                        self takeweapon( "upgraded_tomahawk_zm" );
                        self.current_tomahawk_weapon = "upgraded_tomahawk_zm";
                        self giveweapon( "upgraded_tomahawk_zm" );
                        self set_player_tactical_grenade( "upgraded_tomahawk_zm" );
                        self setclientfieldtoplayer( "upgraded_tomahawk_in_use", 1 );
                        break;
                    }
                    else
                    {
                        self takeweapon( "bouncing_tomahawk_zm" );
                        self takeweapon( "upgraded_tomahawk_zm" );
                        self giveweapon( "bouncing_tomahawk_zm" );
                        self set_player_tactical_grenade( "bouncing_tomahawk_zm" );
                        self setclientfieldtoplayer( "tomahawk_in_use", 1 );    
                        break;
                    }
                }
                wait 0.1;
            }
        }
        wait 0.1;
    }
}

watch_hawk_kill_count()
{
    self endon("disconnect");

    lock = 0;
    for(;;)
    {
        if (self.kills > 5 && lock == 0)
        {
            self.hawk_cd = 0.3;
            self playsound( "zmb_easteregg_scream");
            for (i = 0; i < 10; i++)
            {
                playfx( level._effect["afterlife_teleport"], self.origin );
            }
            lock = 1;
        }
        if (self.kills > 15 && lock == 1)
        {
            self.hawk_cd = 0.15;
            self takeweapon( "bouncing_tomahawk_zm" );
            self set_player_tactical_grenade( "none" );
            maps\mp\_visionset_mgr::vsmgr_activate( "visionset", "zm_afterlife", self );
            self playsound( "zmb_easteregg_scream");
            for (i = 0; i < 10; i++)
            {
                playfx( level._effect["afterlife_teleport"], self.origin );
            }

            self.current_tomahawk_weapon = "upgraded_tomahawk_zm";
            self giveweapon( "upgraded_tomahawk_zm" );
            self set_player_tactical_grenade( "upgraded_tomahawk_zm" );
            self setclientfieldtoplayer( "upgraded_tomahawk_in_use", 1 );
            wait 0.2;
            maps\mp\_visionset_mgr::vsmgr_deactivate( "visionset", "zm_afterlife", self );
            lock = 2;
        }
        if (self.kills > 70 && lock == 2)
        {
            self.hawk_cd = 0.01;
            self playsound( "zmb_easteregg_scream");
            for (i = 0; i < 10; i++)
            {
                playfx( level._effect["afterlife_teleport"], self.origin );
            }
            lock = 3;   
        }
        wait 0.1;
    }
}

tomahawk_clear_guns()
{
    self endon("disconnect");

    for(;;)
    {
        if (self GetCurrentWeapon() != "zombie_tomahawk_flourish" && self GetCurrentWeapon() != "spork_zm_alcatraz")
        {
            self giveweapon( "zombie_tomahawk_flourish" );
            self switchtoweapon( "zombie_tomahawk_flourish" );
        }

        wait 0.1;
    }
}

in_plain_sight()
{
    self endon("disconnect");
    cooldown = 60;
    for (;;)
    {
        if (self MeleeButtonPressed())
        {
            self EnableInvulnerability();
            self.ignoreme = 1;
            maps\mp\_visionset_mgr::vsmgr_activate( "visionset", "zm_audio_log", self );
            self setclientthirdperson( 1 );
            for (i = 0; i < 10; i++)
            {
                playfx( level._effect["afterlife_teleport"], self.origin );
            }
            self playsound( "zmb_quest_electricchair_spawn" );
            wait 5;
            for (i = 0; i < 10; i++)
            {
                playfx( level._effect["afterlife_teleport"], self.origin );
            }
            maps\mp\_visionset_mgr::vsmgr_deactivate( "visionset", "zm_audio_log", self); 
            self setclientthirdperson( 0 );
            self.ignoreme = 0;
            self DisableInvulnerability();
            wait cooldown;
            self iprintln("^3Time Breaker^7 - ^2READY");
            self iprintln("^3Time Breaker^7 - ^2READY");
            self iprintln("^3Time Breaker^7 - ^2READY");
        }
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
    hud setparent(level.uiparent);
	hud setshader( shader, width, height );
	hud.x = x;
	hud.y = y;
    hud.foreground = 0;
	return hud;
}

spawn_brutus_cluster_side_shaped(amount)
{

    /*
        -455, -3907 -1333 / 10
        -1788, -3907 670 / 10
        -1788, -3237 +718 / 5
        -1070, -3237 +670 / 5
        -455, -3422

    */
    if (getdvar("final_wave" == "1"))
        wait 3;
    setDvar("brutus_walk", "1");
    level.brutus_cluster = 1;
    x_offset = 0;
    y_offset = 0;
    x = -455;
    y = -3907;
    lock = 0;
    for (i = 0; i < amount; i++)
    {
        if (i == 6 || i == 8)
        {
           x_offset += -133.3;
            continue;
        }
        level.brutus_last_spawn_round = -1;
        ai = spawn_zombie( level.brutus_spawners[0] );
        ai.pos = (x + x_offset, y + y_offset, -8447.88);
        ai thread brutus_spawn_custom();
        if (i < 10)
        {
            x_offset += -133.3;
        }
        else if (i < 20)
        {
            y_offset += 67; 
            x_offset = -1333;
        }
        else if (i < 25)
        {
            x_offset += 143.6;
            y_offset = 670; 
        }
        else
        {
            x = -455;
            y = -3422;
            x_offset = 0;
            if (lock == 0)
            {
                lock = 1;
                y_offset = 0;

                continue;
            }
            y_offset -= 134; 
        }
     //   wait .05;
    }
    level.brutus_cluster = 0;
    setDvar("brutus_walk", "0");
    wait 3;

    if (getDvar("final_wave") != "1")
    {
        zombies = getaispeciesarray( "axis", "all" );
        foreach(zombie in zombies)
        {
            zombie set_zombie_run_cycle( "sprint" );
        }
    }

}

spawn_brutus_cluster_cross_shaped()
{
/*
 -465 -3597 -1390 / 21
-1855 -3597

-1073 -3252 -656 / 9
-1073 -3908
*/
    setDvar("brutus_walk", "1");
    level.brutus_cluster = 1;
    x_offset = 0;
    y_offset = 0;
    x = -465;
    y = -3597;
    for (i = 0; i < 29; i++)
    {
        if (i == 4 || i == 5)
        {
            x_offset += -66.19;
            continue;
        }
        level.brutus_last_spawn_round = -1;
        ai = spawn_zombie( level.brutus_spawners[0] );
        ai.pos = (x + x_offset, y + y_offset, -8447.88);
        ai thread brutus_spawn_custom();
        if (i < 21)
        {
            x = -465;
            y = -3597;
            x_offset += -66.19;
        }
        else 
        {
            x = -1073;
            y = -3252;
            x_offset = 0;
            y_offset += -72.888; 
        }
       // wait .05;
    }
    level.brutus_cluster = 0;
    setDvar("brutus_walk", "0");
    wait 3;

    zombies = getaispeciesarray( "axis", "all" );
    foreach(zombie in zombies)
    {
        zombie set_zombie_run_cycle( "sprint" );
    }
}

spawn_brutus_cluster_u_shaped(x, y, x_inc, y_inc, x_cap, y_cap, type)
{
    level.brutus_cluster = 1;
    x_offset = 0;
    y_offset = 0;
/*  
    U shaped Spawn
    -1211 -3330
    47.7 to 334
    -32.9 to -527
*/

/*  
    U shaped Spawn Chair
    -1351 -3814
    -1780 -3814 x_cap = -429 / 7
    -1780 -3234 y_cap = -580 / 16
    -1351 -3234 x_cap = +429 / 7 
    -61.3 to -429
    -36.25 to -580
*/

/*  
    U shaped Spawn Dock
    -979 -3416 x_cap = 510  / 7
    -469 -3416 y_cap = -499 / 16    
    -469 -3915
    -979 -3915
    72.85 to 510
    -31.18 to -499
*/

    for (i = 0; i < 29; i++)
    {
        level.brutus_last_spawn_round = -1;
        ai = spawn_zombie( level.brutus_spawners[0] );
        ai.pos = (x + x_offset, y + y_offset, -8447.88);
        ai thread brutus_spawn_custom();
        if (i < 7)// 7 side
            x_offset += x_inc;
        else if (i < 23) // 16 main
        {
            x_offset = x_cap;
            y_offset -= y_inc;
        }       
        else // 7 side
        {
            x_offset -= x_inc;
            if (type == 1)
            {
                y_cap = -y_cap;
                type = 0;
            }
            y_offset = y_cap; 
        }
      //      wait .05;
    }
    level.brutus_cluster = 0;
    zombies = getaispeciesarray( "axis", "all" );
    foreach(zombie in zombies)
    {
        zombie set_zombie_run_cycle( "sprint" );
    }
}

spawnBrutus()
{
    level endon ("game_ended");
    level waittill("start_of_round");
    
    wait 25;
    wave = 0;
    delay = 2;
    lock = 0;
    checkpoint = 0;
    wlock = 0;
        level thread PlayEESong("mus_zmb_secret_song");
    for (;;)
    {
        if (wave >= 15)
            setdvar("king_lock", "1");
        if (wave >= 4)
        {
            for (i = 0; i < level.players.size; i++)
            {
                if (level.players[i] HasPerk("specialty_fastreload") == 0)
                {
                    level.players[i] iprintln("^3[ ^2Nikolai^3 ] ^7: Take a drink my friend. ^3Vodka^7 makes hands ^2faster!");
                    level.players[i] thread maps\mp\zombies\_zm_perks::wait_give_perk("specialty_fastreload", 1); 
                }
            }
        }
        if (wave >= 16)
        {
            for (i = 0; i < level.players.size; i++)
            {
                if (level.players[i] HasPerk("specialty_rof") == 0)
                {
                    level.players[i] iprintln("^3[ ^2Dempsey^3 ] ^7: A ^5true Marine^7 knows his weapon by heart, ^3this^7 will pump up yours.");
                    level.players[i] thread maps\mp\zombies\_zm_perks::wait_give_perk("specialty_rof", 1); 
                }
            }
        }
        zombies = getaispeciesarray( "axis", "all" );
        brutus_count = 0;
        foreach (zombie in zombies)
        {
            if (zombie.animname == "brutus_zombie" && zombie.is_brutus == 1)
            {
                brutus_count++;
            }
        }
        if (brutus_count <= 0)
        {
            wave++;
         //   if (wave >= 8)
        //        level thread SlowRandomPlayers(0.5);            
            setDvar("wave", wave);
            delay -= 0.2;
            //-------------------------------------------------------------------CHECKPOINTS
            if (wave >= 10 && checkpoint == 0)
            {
                if (level.gamemode_difficulty == "^6GigaChad^7")
                    setDvar("EE_Completion", "BotB_Middle_GigaChad");
                else 
                    setDvar("EE_Completion", "8");
                for (i = 0; i < level.players.size; i++)
                {
                    if(level.players[i].sessionstate == "spectator")
                    {
                        level.players[i] thread Checkpoint(i);
                    }
                }
                checkpoint = 1;
                setDvar("bold", "Checkpoint ^2reached!");
                wait 60;
            }
            if (wave >= 15 && checkpoint == 1)
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
                wait 60;
            }
            //-------------------------------------------------------------------WEAPONS
            if (wave >= 5 && wlock == 0)
            {
                setdvar("bold", "^1[!]^7 New weapon : ^5" + weapon);
                wait 5;
                for (i = 0; i < level.players.size; i++)
                {
                    r = RandomInt(3);
                    if (r == 1)
                        weapon = "dsr50_zm";
                    else if (r == 2)
                        weapon = "tar21_zm";
                    else
                        weapon = "mp5k_zm";

                    if (isAlive(level.players[i]) && !(isdefined(level.players[i].hawk_cd)))
                    {
                        weapon_loadout = level.players[i] GetWeaponsListPrimaries();
                        if (weapon_loadout.size >= 2)
                            level.players[i] TakeWeapon(level.players[i] GetCurrentWeapon());
                        level.players[i] GiveWeapon(weapon);
                        level.players[i] SwitchToWeapon(weapon);
                    }
                }
                wlock = 1;               
            }
            if (wave >= 9 && wlock == 1)
            {
                r = RandomInt(4);
                if (r == 1)
                    weapon = "uzi_zm";
                else if (r == 2)
                    weapon = "pdw57_zm";
                else if (r == 3)
                    weapon = "thompson_zm";
                else
                    weapon = "saiga12_zm";

                setdvar("bold", "^1[!]^7 New weapon : ^5" + weapon);
                wait 5;
                for (i = 0; i < level.players.size; i++)
                {
                    if (isAlive(level.players[i]) && !(isdefined(level.players[i].hawk_cd)))
                    {
                        weapon_loadout = level.players[i] GetWeaponsListPrimaries();
                        if (weapon_loadout.size >= 2)
                            level.players[i] TakeWeapon(level.players[i] GetCurrentWeapon());
                        level.players[i] GiveWeapon(weapon);
                        level.players[i] SwitchToWeapon(weapon);
                    }
                }
                wlock = 2;               
            }
            if (wave >= 12 && wlock == 2)
            {
                r = RandomInt(3);
                if (r == 1)
                    weapon = "lsat_zm";
                else if (r == 2)
                    weapon = "galil_zm";
                else
                    weapon = "ak47_zm";

                level thread PlayEESong("mus_zmb_secret_song");
                setdvar("bold", "^1[!]^7 New weapon : ^5" + weapon);
                wait 5;
                for (i = 0; i < level.players.size; i++)
                {
                    if (isAlive(level.players[i]) && !(isdefined(level.players[i].hawk_cd)))
                    {
                        weapon_loadout = level.players[i] GetWeaponsListPrimaries();
                        if (weapon_loadout.size >= 2)
                            level.players[i] TakeWeapon(level.players[i] GetCurrentWeapon());
                        level.players[i] GiveWeapon(weapon);
                        level.players[i] SwitchToWeapon(weapon);
                    }
                }
                wlock = 3;               
            }
            if (wave >= 16 && wlock == 3)
            {
                r = RandomInt(100);
                if (r > 95)
                    weapon = "blundergat_zm";
                else
                    weapon = "minigun_alcatraz_zm";
                setdvar("bold", "^1[!]^7 New weapon : ^5" + weapon);
                wait 5;
                level thread PlayEESong( "mus_zmb_secret_song_2");

                for (i = 0; i < level.players.size; i++)
                {
                    if (isAlive(level.players[i]) && !(isdefined(level.players[i].hawk_cd)))
                    {
                        weapon_loadout = level.players[i] GetWeaponsListPrimaries();
                        if (weapon_loadout.size >= 2)
                            level.players[i] TakeWeapon(level.players[i] GetCurrentWeapon());
                        level.players[i] GiveWeapon(weapon);
                        level.players[i] SwitchToWeapon(weapon);
                    }
                }        
                wlock = 4;       
            }
        /*    if (wave == 19 && wlock == 4)
            {
                for (i = 0; i < level.players.size; i++)
                {
                    if (isAlive(level.players[i]))
                    {
                        weapon_loadout = level.players[i] GetWeaponsListPrimaries();
                        if (weapon_loadout.size >= 2)
                            level.players[i] TakeWeapon(level.players[i] GetCurrentWeapon());
                        level.players[i] GiveWeapon("blundergat_zm");
                        level.players[i] SwitchToWeapon("blundergat_zm");
                    }
                }
                wlock = 5;               
            }*/
            if (wave <= 2)
            {
                setDvar("brutus_walk", "1");
            }
            else
            {
               setDvar("brutus_walk", "0"); 
            }
            if (wave >= 3 && lock == 0)
            {
                setDvar("ln", "^3[ " + level.boss_name + " ]^7 : ^3You thought it was going to be that easy ? ^1Make them dance");
                lock = 1;
            }
            if (wave >= 5 && lock == 1)
            {
                setDvar("ln", "^3[ " + level.boss_name + " ]^7 : Do you think you stand a chance ? Boys, ^3helmets on^7 !!");
                setDvar("brutus_helmet", "1");
                lock = 2;
            }
            if (wave >= 10 && wave <= 11 && lock == 2)
            {
                setDvar("ln", "^3[ " + level.boss_name + " ]^7 : ^5Ninja Brutus^7,^3 Your numbers are on!");
                setDvar("ninjaBrutus", "1");
                lock = 3;
            }
            if (wave != 10 && wave != 11)
                setDvar("ninjaBrutus", "0"); 
            if (wave >= 12 && lock == 3)
            {
                setDvar("ln", "^3[ " + level.boss_name + " ]^7 : Let's ^2speed^7 things up");
                setDvar("brutus_sprint", "1");
                lock = 4;
            }
            if (wave >= 14 && lock == 4)
            {
                setDvar("ln", "^3[ " + level.boss_name + " ]^7 : Spread up ^3boys !");
                lock = 5;
            }
            if (wave >= 15 && lock == 5)
            {
                if (level.gamemode_difficulty == "^1Chad^7")
                {
                    setDvar("brutus_oneshot", "1");
                    setDvar("ln", "^3[ " + level.boss_name + " ]^7 : Get closer to us again^7, ^1see what happens ^7!");
                    level thread PlayEESong( "mus_zmb_secret_song_2");
                }
                wait 20;
                lock = 6;
            }
            if (wave == 20 && lock == 6)
            {
                level.final_wave = 1;
                lock = 7;
                color = "^6";
                setDvar("color", color);
                setDvar("ln", "^3[ " + level.boss_name + " ]^7 : I see you managed to defeat my ^3minions^7, however your ^5hopes^7 ends ^1now^7.");   
                wait 11;           
                setDvar("ln", "^3[ " + level.boss_name + " ]^7 : Bring it on, ^3I'll take all of you on^7 by ^1myself");
                wait 14;

                foreach ( player in level.players )
                    maps\mp\_visionset_mgr::vsmgr_activate( "visionset", "zm_audio_log", player );

                level thread RespawnWatcher();
                level thread LoopEESong();
              /*  if(level.gamemodedifficulty == "^1Chad^7")
                    level thread SpawnSmoke(15);
                else
                    level thread SpawnSmoke(3);*/
                level thread SlowPlayers(0.4);
                setDvar("final_wave", "1");
                setDvar("brutus_oneshot", "1");
                wait 2;
                level notify( "spawn_brutus", 1 );
                wait 3;
                if (level.gamemode_difficulty == "^6GigaChad^7")
                    level thread boss_phase();
                for (;;)
                {
                    zombies = getaispeciesarray( "axis", "all" );
                    for (i = 0; i < zombies.size; i++)
                    {
                        if (isdefined(zombies[i].is_brutus))
                        {
                            level.boss = zombies[i];
                            zombies[i].is_boss = 1;
                            foreach(player in level.players)
                            {
                                player thread healthbarboss();
                            }
                            level.boss thread player_too_close_watcher();
                            return;
                        }
                    }
                    wait 0.1;
                }
            }

            level.brutus_last_spawn_round = -1;

            if (level.gamemode_difficulty == "^6GigaChad^7")
            {
                if (wave > 14 && wave % 2 == 0 && wave != 20)
                    setDvar("ninjaBrutus", "1");
                else
                    setDvar("ninjaBrutus", "0");
                if (wave == 1 || wave == 6 || wave == 11 || wave == 16)
                    level thread spawn_brutus_cluster_u_shaped(-1211, -3330, 47.7, 32.9, 334, -527, 0);
                if (wave == 2 || wave == 7 || wave == 12 || wave == 17)
                    level thread spawn_brutus_cluster_u_shaped(-1351, -3814, -61.3, -36.25, -429, -580, 1);
                if (wave == 3 || wave == 8 || wave == 13 || wave == 18)
                    level thread spawn_brutus_cluster_u_shaped(-979, -3416, 72.85, 31.18, 510, -499, 0);
                if (wave == 4 || wave == 9 || wave == 14 || wave == 18)
                    level thread spawn_brutus_cluster_cross_shaped();
                if (wave == 5 || wave == 10 || wave == 15 || wave == 19)
                    level thread spawn_brutus_cluster_side_shaped(29);
                for (;;)
                {
                    brutus_count = 0;
                    zombies = getaispeciesarray( "axis", "all" );
                    foreach (zombie in zombies)
                    {
                        if (isdefined(zombie.is_brutus) && zombie.is_brutus == 1)
                        {
                            brutus_count++;
                        }
                    }
                    if (brutus_count <= 0)
                        break;
                    wait 3;
                }

            }
            for (i = 0; i < (wave * 2) + level.extra_brutus; i++)
            {
                for (;;)
                {
                    zombies = getaispeciesarray( "axis", "all" );
                    if (zombies.size < 18)
                        break;
                    wait 1;
                }
                if (delay < 0.4)
                    delay = 0.4;
                x = randomintrange(0, 15);
                if (x == 9 && wave >= 14)
                {
                    setDvar("brutus_walk", "1");
                        ai = spawn_zombie( level.brutus_spawners[0] );
                    ai thread brutus_spawn_custom();
                //    level notify( "spawn_brutus", 1 );
                    wait 0.1;
                    setDvar("brutus_walk", "0");
                }
                else if ((x == 8 || x == 7) && wave >= 14)
                {
                    setDvar("ninjaBrutus", "1");
                    setDvar("brutus_walk", "1");
                    ai = spawn_zombie( level.brutus_spawners[0] );
                    ai thread brutus_spawn_custom();
                   // level notify( "spawn_brutus", 1 );
                    wait 0.1;
                    setDvar("ninjaBrutus", "0");
                    setDvar("brutus_walk", "0");
                }
                else
                {
                    ai = spawn_zombie( level.brutus_spawners[0] );
                    ai thread brutus_spawn_custom();
                  //  level notify( "spawn_brutus", 1 );
                }
                wait delay;
            }
            
        }
        wait 3;
    }
}

boss_phase()
{
    level endon("game_ended");

    wait 5;
    boss_stage = 0;
    for (;;)
    {
        if (level.intermission == 1)
        {
            return;
        }
        if (boss_stage == 0 && level.boss.health < (level.boss.maxhealth - (level.boss.maxhealth / 3)))
        {
            iprintln("^3[" + level.boss_name + "]^7 : Brutes, ^1COVER ME !^7");
            level.is_adds = 1;
            level thread spawn_brutus_cluster_side_shaped(10);
            level.is_adds = 0;  
            boss_stage = 1;
        }
        if (boss_stage == 1 && level.boss.health < level.boss.maxhealth / 3)
        {
            iprintln("^3[" + level.boss_name + "]^7 : Brutes, ^1COVER ME !^7");
            level.is_adds = 1;
            level thread spawn_brutus_cluster_side_shaped(20);
            level.is_adds = 0;
            boss_stage = 2;
        }
        wait 0.1;
    }
}

player_too_close_watcher()
{
    for (;;)
    {
        foreach(player in level.players)
        {
            if (distance(player.origin, self.origin) < 120)
            {
                foreach(index, ignored_player in self.ignoreplayer)
                {
                    if (ignored_player == player)
                    {
                        self.ignoreplayer[index] = undefined;
                        wait 3;
                        self.ignoreplayer[index] = player;
                    }
                }

            }
        }
        wait 0.1;
    }
}

LoopEESong()
{
    level endon ("game_ended");
    for (;;)
    {
        level thread PlayEESong( "mus_zmb_secret_song_2");
        wait 140;
    }
}

RespawnWatcher()
{
    level endon ("game_ended");
    setdvar( "player_lastStandBleedoutTime", "0" );
}

SpawnSmoke(seconds)
{
	level endon( "game_ended" );

    for (;;)
    {
        if (isdefined(level.jammer))
            return;
        if (getDvar("game_end") == "1")
            return;
        alive_player = 0;
        for (i = 0; i < level.players.size; i++)
        {
            v_org_left = level.players[i] gettagorigin( "TAG_WEAPON_LEFT" );
            v_org_right = level.players[i] gettagorigin( "TAG_WEAPON_RIGHT" );
            level.players[i] thread sndplaydelayedsmokeaudio( v_org_left, v_org_right );
            level.players[i] magicgrenadetype( "willy_pete_zm", v_org_left, ( 0, 0, 0 ), 0.4 );
            level.players[i] magicgrenadetype( "willy_pete_zm", v_org_right, ( 0, 0, 0 ), 0.4 );

            if (!(level.players[i].sessionstate == "spectator"))
            {
                alive_player++;
            }
        }
        wait seconds;
    }
}

SlowRandomPlayers(ms)
{
	level endon( "game_ended" );

    alive_player = 0;
    for (i = 0; i < level.players.size; i++)
    {
        if (!(level.players[i].sessionstate == "spectator"))
        {
            alive_player++;
        }
    }

    for (i = 0; i < level.players.size; i++)
    {
        if (alive_player > 1 && !(level.players[i].sessionstate == "spectator") && getdvar("final_wave") != "1")
        {
            if (isdefined(level.players[i].speedrunner))
                level.players[i] SetMoveSpeedScale(1.20 + level.extra_speed);
            else 
                level.players[i] SetMoveSpeedScale(1.05 + level.extra_speed);
        }
    }

    slowed_players = 0;
    if (alive_player  <= 3)
    {
        slowed_players = 1;
        setDvar("slowed_player2", "-1");
    }
    else if (alive_player > 3)
        slowed_players = 2;
    slowed_player1 = int(getdvar("slowed_player1"));
    slowed_player2 = int(getdvar("slowed_player2"));

    for (i = 0; i < slowed_players; i++)
    {
        for (f = 0; f < 1000; f++)
        {
            x = randomintrange(0, alive_player);
            if (x != slowed_player1 && x != slowed_player2)
            {
                break;
            }
        }
     /*   if (alive_player <= 1)
        {
            for (j = 0; j < level.players.size; j++)
            {
                if (!(level.players[j].sessionstate == "spectator"))
                {
                    level.players[j] SetMoveSpeedScale(0.2);
                }
            }
        }
        else
        {   */
            w = 0;
            for (k = 0; k < level.players.size; k++) 
            {
                if (!(level.players[k].sessionstate == "spectator"))
                {
                    if (w == x)
                    {
                        if (i == 0)
                        {
                            slowed_player1 = k;
                            setdvar("slowed_player1", k);
                        }
                        if (i == 1)
                        {
                            slowed_player2 = k;
                            setdvar("slowed_player2", k);
                        }
                        if (level.players[k].noslow && level.players[k].noslow == 1)
                        {
                            level.players[k] iPrintln("^3You ate ^1A LOT of ^3BigMacs^3 but it ^2barely filled up your belly :)");
                            break;
                        }
                        else
                        {
                            if (isdefined(level.players[k].speedrunner))
                            {
                                level.players[k] SetMoveSpeedScale(ms + 0.2);
                                level.players[k] iPrintln("^1You ate too many ^3Big Macs ^2 but you are still speedy!");
                            }
                            else
                            {
                                level.players[k] SetMoveSpeedScale(ms);                           
                                level.players[k] iPrintln("^1You ate too many ^3Big Macs");
                            }
                            break;
                        }
                    }
                    w++;
                }
            }
        //}
    }
}

SlowPlayers(ms)
{
	level endon( "game_ended" );

    for (;;)
    {
        for (i = 0; i < level.players.size; i++)
        {
            if (isdefined(level.players[i].speedrunner))
                level.players[i] SetMoveSpeedScale(ms + 0.1);
            else
                level.players[i] SetMoveSpeedScale(ms);
        }
        wait 0.5;
        if (getdvar("game_end") == "1")
            break;
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
    self endon ("disconnect");
    self.origin = (10000, 10000, 10000 + 100 * i);
  //  self.spectator_respawn = 1;
    self [[ level.spawnplayer ]]();
    wait 0.1;
  //  self.spectator_respawn = undefined;
    self thread TpToCell(i);
    //self TakeAllWeapons();
    wait 10;
    self iprintln("^3[ ^2Kiels^3 ]^7 : It is ^3too soon^7 for you to die, ^5get ready soldier");
    wait 6;
    self thread TpToBridge(i);

    foreach(guid in level.premium_pass_guid_list)
    {
        if (self getguid() == guid && !(isdefined(self.hawk_cd)))
        {
            self giveweapon("ak47_upgraded_zm", 0, self maps\mp\zombies\_zm_weapons::get_pack_a_punch_weapon_options( "ak47_upgraded_zm" ) );
            self SwitchToWeapon("ak47_upgraded_zm");
            return;
        }
    }
    foreach(guid in level.premium_pass_guid_list2)
    {
        if (self getguid() == guid && !(isdefined(self.hawk_cd)))
        {
            self giveweapon("ak47_upgraded_zm", 0, self maps\mp\zombies\_zm_weapons::get_pack_a_punch_weapon_options( "ak47_upgraded_zm" ) );
            self SwitchToWeapon("ak47_upgraded_zm");
            return;
        }
    }
    group = 0;
    tag = strTok(self, "]");
       if (tag[0] == "[^3SSS^7" || tag[0] == "[^6 I ^7" || tag[0] == "[^6II^7"|| tag[0] == "[^6III^7"
    || tag[1] == "[^3VIP^7" || tag[1] == "^3[VIP" || tag[1] == "^6[VIP" || tag[1] == "[^6VIP^7"
    || tag[0] == "[^5IV^7" || tag[0] == "[^5V^7" || tag[0] == "[^5VI^7" || tag[0] == "[^5VII^7"
    || tag[0] == "[^1IIX^7]" || tag[0] == "[^1IX^7]" || tag[0] == "[^1-X-^7]")
    {
        group = 3;
    }
    else if (tag[0] == "[^9F^7" || tag[0] == "[^8E^7" || tag[0] == "[^4C^7" || tag[0] == "[^2D^7" || tag[0] == "[^5B^7" )
    {
        group = 1;
    }
    else if (tag[0] == "[^6A^7" || tag[0] == "[^3S^7" )
    {
        group = 2;
    }

    if (group == 1)
    {
        self GiveWeapon("m14_zm");
        self SwitchToWeapon("m14_zm");
    }
    else if (group == 2)
    {
        self GiveWeapon("beretta93r_zm");
        self SwitchToWeapon("beretta93r_zm");
    }
    else if (group == 3)
    {
        self GiveWeapon("thompson_zm");
        self SwitchToWeapon("thompson_zm");
    }
}

TpToBridge(id)
{
    level endon ("game_ended");
    self endon("disconnect");

    level.on_bridge = 1;
    if (id == 0)
    {
        origin = (-1061.06, -3448.74, -8447.88);
        angle = (1.59851, 267.896, 0);
        self setOrigin(origin);
        self SetPlayerAngles(angle);
    }
    else if (id == 1)
    {
        origin = (-1072, -3686.39, -8447.88);
        angle = (8.255, 84.9902, 0);
        self setOrigin(origin);
        self SetPlayerAngles(angle);
    }
    else if (id == 2)
    {
        origin = (-973.846, -3553.86, -8444.87);
        angle = (0.961304, 179.572, 0);
        self setOrigin(origin);
        self SetPlayerAngles(angle);
    }
    else if (id == 3)
    {
        origin = (-1156.97, -3543.47, -8447.88);
        angle = (358.588, 357.303, 0);
        self setOrigin(origin);
        self SetPlayerAngles(angle);
    }
    else if (id == 4)
    {
        origin = (-1125.43, -3483.31, -8447.88);
        angle = (7.206, 306.392, 0);
        self setOrigin(origin);
        self SetPlayerAngles(angle);
    }
    else if (id == 5)
    {
        origin = (-1009.49, -3635.56, -8447.88);
        angle = (19.3018, 128.09, 0);
        self setOrigin(origin);
        self SetPlayerAngles(angle);
    }
    else if (id == 6)
    {
        origin = (-1007.36, -3489.46, -8440.38);
        angle = (11.3104, 222.435, 0);
        self setOrigin(origin);
        self SetPlayerAngles(angle);
    }
    else if (id == 7)
    {
        origin = (-1149.47, -3608.69, -8447.88);
        angle = (359.517, 34.8706, 0);
        self setOrigin(origin);
        self SetPlayerAngles(angle);
    }
}

TpToCell(id)
{
    level endon ("game_ended");
    self endon("disconnect");

    maps\mp\_visionset_mgr::vsmgr_deactivate( "visionset", "zm_audio_log", self);  
    angle = (6.66, 89.65, 0);
    if (id == 0)
    {
        origin = (1004.46, 10372.1, 1440.13);
        self setOrigin(origin);
        self SetPlayerAngles(angle);
    }
    else if (id == 1)
    {
        origin = (1726.43, 10392.3, 1336.13);
        self setOrigin(origin);
        self SetPlayerAngles(angle);
    }
    else if (id == 2)
    {
        origin = (832.784, 10391.3, 1440.13);
        self setOrigin(origin);
        self SetPlayerAngles(angle);
    }
    else if (id == 3)
    {
        origin = (1650.3, 10375.5, 1455.13);
        self setOrigin(origin);
        self SetPlayerAngles(angle);
    }
    else if (id == 4)
    {
        origin = (1724.79, 10372.2, 1440.13);
        self setOrigin(origin);
        self SetPlayerAngles(angle);
    }
    else if (id == 5)
    {
        origin = (1155.6, 10380.4, 1544.13);
        self setOrigin(origin);
        self SetPlayerAngles(angle);
    }
    else if (id == 6)
    {
        origin = (1390.07, 10355.8, 1544.13);
        self setOrigin(origin);
        self SetPlayerAngles(angle);
    }
    else if (id == 7)
    {
        origin = (1316.04, 10346.8, 1440.13);
        self setOrigin(origin);
        angle = (8.22876, 85.7813, 0);
        self SetPlayerAngles(angle);
    }

    wait 2;
    if (level.game_started == 0)
    {
        self thread difficulty_selector();
    }

}

brutus_stuck_teleport_custom()
{
    self endon( "death" );

    if (check_for_botb_port() == true)
        return;


    align_struct = spawn( "script_model", self.origin );
    align_struct.angles = self.angles;
    align_struct setmodel( "tag_origin" );

    if ( !level.brutus_in_grief && ( self istouching( level.e_gondola.t_ride ) || isdefined( self.force_gondola_teleport ) && self.force_gondola_teleport ) )
    {
        self.force_gondola_teleport = 0;
        align_struct linkto( level.e_gondola );
        self linkto( align_struct );
    }

    self.not_interruptable = 1;
    playfxontag( level._effect["brutus_spawn"], align_struct, "tag_origin" );
    self animscripted( self.origin, self.angles, "zm_taunt" );
    self maps\mp\animscripts\zm_shared::donotetracks( "taunt_anim" );
    self.not_interruptable = 0;
    self ghost();
    self notify( "brutus_cleanup" );
    self notify( "brutus_teleporting" );

    if ( isdefined( align_struct ) )
        align_struct delete();

    if ( isdefined( self.sndbrutusmusicent ) )
    {
        self.sndbrutusmusicent delete();
        self.sndbrutusmusicent = undefined;
    }

    if ( isdefined( level.brutus_respawn_after_despawn ) && level.brutus_respawn_after_despawn )
    {
        b_no_current_valid_targets = are_all_targets_invalid();
        level thread maps\mp\zombies\_zm_ai_brutus::respawn_brutus( self.health, self.has_helmet, self.helmet_hits, self.explosive_dmg_taken, self.force_zone, b_no_current_valid_targets );
    }

    level.brutus_count--;
    self delete();
}

brutus_spawn_custom( starting_health, has_helmet, helmet_hits, explosive_dmg_taken, zone_name )
{
    level.num_pulls_since_brutus_spawn = 0;
    self set_zombie_run_cycle( "run" );  
    if (getdvar("ninjaBrutus") == "1")
        self ghost();
    if (getDvar("brutus_walk") == "1")
    {
        self set_zombie_run_cycle( "walk" ); 
        self.is_walking = 1;
    }
  
    else if (getDvar("brutus_sprint") == "1")
        self set_zombie_run_cycle( "sprint" );
    self.has_helmet = 0;
    if (getDvar("brutus_helmet") == "1")
    {
        r = randomint(100);
        //if (r > 80)        
           self.has_helmet = 1; 
    }

    self.helmet_hits = 5;
    self.explosive_dmg_taken = 0;
    self.meleedamage = 340;
    if (getDvar("brutus_oneshot") == "1")
    {
        self.meleedamage = 450;
    }
    if (isdefined(level.gamemode_difficulty) && level.gamemode_difficulty == "^6GigaChad^7")
        self.meleedamage = 450;

    if (check_for_botb_port() == false)
        self brutus_health_increases();
    if (level.gamemode_difficulty == "^6GigaChad^7")
        level.brutus_health += level.brutus_health_increase_custom;
    else
         self brutus_health_increases_customized();
    self.maxhealth = level.brutus_health;
    self.health = level.brutus_health;
    if (isdefined(level.beefy_brutus))
    {
        self.maxhealth *= 1.2;
        self.health *= 1.2;
    }

    if (isdefined(level.is_adds) && level.is_adds == 1)
    {
        self.maxhealth = self.maxhealth * 1.25;
        self.health = self.maxhealth;
        self.meleedamage = 9999;
    }

    self.custom_item_dmg = 1000;
    if (getDvar("final_wave") == "1" && getDvar("lock") == "0")
    {
        setDvar("lock", "1");
        self.is_boss = 1;
        self.maxhealth = 250000;
        self.health = self.maxhealth;
        self.meleedamage = 999;
        if (isdefined(level.gamemode_difficulty) && level.gamemode_difficulty == "^1Chad^7")
        {
            self.meleedamage = 999999;
            self.maxhealth = 550000;
            self.health = self.maxhealth;
            self.custom_item_dmg = 1000000;
        }
        if (isdefined(level.gamemode_difficulty) && level.gamemode_difficulty == "^6GigaChad^7")
        {
            self.meleedamage = 999999;
            self.maxhealth = 1100000;
            self.health = self.maxhealth;
            self.custom_item_dmg = 1000000;
        }    
    }
    self.explosive_dmg_req = level.brutus_expl_dmg_req;
    self.no_damage_points = 1;
    self endon( "death" );
    level endon( "intermission" );
    self.animname = "brutus_zombie";
    self.audio_type = "brutus";
    self.has_legs = 1;
    self.ignore_all_poi = 1;
    self.is_brutus = 1;
    self.ignore_enemy_count = 1;
    self.instakill_func = ::brutus_instakill_override;
    self.nuke_damage_func = ::brutus_nuke_override;
    self.melee_anim_func = ::melee_anim_func;
    self.brutus_lockdown_state = 0;
    recalc_zombie_array();
    self setphysparams( 20, 0, 60 );
    self.zombie_init_done = 1;
    self notify( "zombie_init_done" );
    self.allowpain = 0;
    self animmode( "normal" );
    self orientmode( "face enemy" );
    self maps\mp\zombies\_zm_spawner::zombie_setup_attack_properties();
    self setfreecameralockonallowed( 0 );
    level thread maps\mp\zombies\_zm_spawner::zombie_death_event( self );
    self thread maps\mp\zombies\_zm_spawner::enemy_death_detection();

    if (getDvar("noShake") == "1" && getdvar("ninjaBrutus") != "1" && getDvar("final_wave") != "1" && isdefined(level.gamemode_difficulty) && level.gamemode_difficulty == "^6GigaChad^7")
        self ghost();
    else if (getDvar("noShake") == "1" && getdvar("ninjaBrutus") != "1" && getDvar("final_wave") != "1")
        self thread addBrutusModel();

    zone_name = "zone_golden_gate_bridge";
    spawn_pos = get_random_brutus_spawn_pos( zone_name );

    if (isdefined(level.brutus_cluster) && level.brutus_cluster == 1)
    {
        spawn_pos.origin = self.pos;
    }
    else if (check_for_botb_port() == true)
    {
        x = randomintrange(0, 3);
        if (isdefined(level.brutus_new_spawns))
        {
            if (x == 0)
                spawn_pos.origin = (-1213, -3267, -8447.88);
            if (x == 1)
                spawn_pos.origin = (-926, -3798, -8447.88);
            if (x == 2)
                spawn_pos.origin = (-1684, -3801, -8447.88);
            
            
            
        }
        else
        {
            if (x == 0)
                spawn_pos.origin = (-494.192, -3600.21, -8447.88);
            if (x == 1)
                spawn_pos.origin = (-1745.74, -3587.59, -8447.88);
            if (x == 2)
                spawn_pos.origin = (-980.373, -3590.95, -8447.88);
        }

    }

    if ( !isdefined( spawn_pos ) )
    {
        self delete();
        return;
    }

    if ( !isdefined( spawn_pos.angles ) )
        spawn_pos.angles = ( 0, 0, 0 );

  //  if ( isdefined( level.brutus_do_prologue ) && level.brutus_do_prologue )
   //     self brutus_spawn_prologue( spawn_pos );

    if ( !self.has_helmet )
        self detach( "c_zom_cellbreaker_helmet" );

    level.brutus_count++;
    self maps\mp\zombies\_zm_spawner::zombie_complete_emerging_into_playable_area();
    self thread snddelayedmusic();
    self thread brutus_death();
    self thread brutus_check_zone();
    self thread brutus_watch_enemy();
    self forceteleport( spawn_pos.origin, spawn_pos.angles );
    self.cant_melee = 1;
    self.not_interruptable = 1;
    self.actor_damage_func = ::brutus_damage_override;
    self.non_attacker_func = ::brutus_non_attacker_damage_override;
    //self thread brutus_lockdown_client_effects( 999999999 );
    playfx( level._effect["brutus_spawn"], self.origin );
    playsoundatposition( "zmb_ai_brutus_spawn", self.origin );
    if (isdefined(level.gamemode_difficulty) && level.gamemode_difficulty != "^6GigaChad^7")
    {
        self animscripted( spawn_pos.origin, spawn_pos.angles, "zm_spawn" );
        self thread maps\mp\animscripts\zm_shared::donotetracks( "spawn_anim" );

        self waittillmatch( "spawn_anim", "spawn_complete" );
    }

    self.not_interruptable = 0;
    self.cant_melee = 0;
    self thread brutus_chest_flashlight();
    self thread brutus_find_flesh();
    self thread maps\mp\zombies\_zm_spawner::delayed_zombie_eye_glow();
    level notify( "brutus_spawned", self );
    if (getDvar("final_wave") == "1" && isdefined(self.is_boss) && isdefined(level.gamemode_difficulty) && (level.gamemode_difficulty == "^1Chad^7" || level.gamemode_difficulty == "^6GigaChad^7"))
    {
        self thread target_selector();
    }
}

brutus_health_increases_customized()
{
    if ( level.round_number > level.brutus_last_spawn_round )
    {
        a_players = getplayers();
        n_player_modifier = 1;

        if (a_players.size >= 6)
            n_player_modifier = 6 * 0.75;
        else if ( a_players.size > 1 )
            n_player_modifier = a_players.size * 0.75;

        level.brutus_round_count++;
        level.brutus_health = int( level.brutus_health_increase * n_player_modifier * level.brutus_round_count );
        level.brutus_expl_dmg_req = int( level.brutus_explosive_damage_increase * n_player_modifier * level.brutus_round_count );

        if ( level.brutus_health >= 7000 * n_player_modifier )
            level.brutus_health = int( 7000 * n_player_modifier );

        if ( level.brutus_expl_dmg_req >= 4500 * n_player_modifier )
            level.brutus_expl_dmg_req = int( 4500 * n_player_modifier );

        level.brutus_last_spawn_round = level.round_number;
    }
}

target_selector()
{
    wait 2;

    rand = 0;
    for (;;)
    {
        for (;;)
        {
            rand = randomintrange(0, level.players.size);
            if (level.players[rand].sessionstate != "spectator")
            {
                self.favoriteenemy = level.players[rand];
                tag = strtok(level.players[rand].name, "]");
                if (isdefined(tag[3]))
                    player_name = tag[3];
                else if (isdefined(tag[2]))
                    player_name = tag[2];
                else if (isdefined(tag[1]))
                    player_name = tag[1];
                else if (isdefined(tag[0]))
                    player_name = tag[0];
                rand2 = randomintrange (0, 3);
                if (rand2 == 0)
                    iprintln("^3[ " + level.boss_name + " ]^7 : " + player_name + "^7, I'm coming for ^1you^7");
                if (rand2 == 1)
                    iprintln("^3[ " + level.boss_name + " ]^7 : " + "You're ^1next^7 " + player_name);
                if (rand2 == 2)
                    iprintln("^3[ " + level.boss_name + " ]^7 : " + "Do you think you're ^1safe^7 " + player_name + " ^7?");
                self.ignore_player = [];
                for(i = 0; i < level.players.size; i++)
                {
                    if (i == rand)
                        continue;
                    self.ignore_player[self.ignore_player.size] = level.players[i];
                }
                break;
            }
            wait 0.1;
        }
        for (i = 0 ; i < 7 ; i++)
        {
            if (level.players[rand].sessionstate == "spectator")
            {
                break;
            }
            self.favoriteenemy = level.players[rand];
            wait 3;
        }
        wait 1;
    }
}

// the part where i prove mr elmaasarawy12 that i'm lucky this time :)
addBrutusModel()
{
    self ghost();
    self.fakeBrutus = spawn( "script_model", self.origin );
    self.fakeBrutus setmodel( "c_zom_cellbreaker_fb" );
    self.fakeBrutus linkto( self, "J_SpineLower", (-48.7, 4, 0), (180, -90, -90));

    if (self.has_helmet)
    {
        self.fakeHat = spawn( "script_model", self.origin );
        self.fakeHat setmodel( "c_zom_cellbreaker_fb" );
        self.fakeHat linkto( self, "J_SpineLower", (-48.7, 4, 0), (180, -90, -90));
        self.fakeHat attach( "c_zom_cellbreaker_helmet" );
        for (;;)
        {
            if (self && self.has_helmet == 0)
            {
                if (self && self.fakeHat)
                    self.fakeHat delete();
                break;
            }
            wait 0.1;
        }
    }
    self waittill( "brutus_cleanup" );
    if (self && self.fakeBrutus)
        self.fakeBrutus delete();
}