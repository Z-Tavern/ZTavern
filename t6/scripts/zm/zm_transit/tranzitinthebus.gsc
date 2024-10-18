#include maps\mp\zombies\zm_transit_bus;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zm_transit_bus;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_weap_riotshield;
#include maps\mp\zombies\_zm_buildables;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_riotshield;
#include maps\mp\zombies\_zm_blockers;
#include maps\mp\zombies\_zm_ai_avogadro;
#include maps\mp\zm_transit_automaton;
#include maps\mp\zm_transit_utility;
#include maps\mp\gametypes_zm\_weaponobjects;
#include maps\mp\zm_transit_lava;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zombies\_zm_laststand;

#include maps\mp\zombies\_zm_ffotd;
#include maps\mp\zombies\_zm;
#include maps\mp\_visionset_mgr;
#include maps\mp\zombies\_zm_devgui;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_bot;
#include maps\mp\zombies\_zm_clone;
#include maps\mp\zombies\_zm_magicbox;
#include maps\mp\zombies\_zm_perks;
#include maps\mp\zombies\_zm_playerhealth;
#include maps\mp\zombies\_zm_power;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\zombies\_zm_gump;
#include maps\mp\zombies\_zm_timer;
#include maps\mp\zombies\_zm_traps;
#include maps\mp\zombies\_zm_tombstone;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_pers_upgrades;
#include maps\mp\gametypes_zm\_zm_gametype;
#include maps\mp\zombies\_zm_pers_upgrades_functions;
#include maps\mp\_demo;
#include maps\mp\zombies\_zm_melee_weapon;
#include maps\mp\zombies\_zm_ai_dogs;
#include maps\mp\zombies\_zm_pers_upgrades_system;
#include maps\mp\gametypes_zm\_weapons;
#include maps\mp\zombies\_zm_ai_basic;
#include maps\mp\zombies\_zm_game_module;

main()
{
    replacefunc(maps\mp\zm_transit_bus::busdoorssetup, ::busdoorssetupcustom);
    replacefunc(maps\mp\zombies\_zm_riotshield::watchriotshielddeploy, ::watchriotshielddeploycustom);
    replacefunc(maps\mp\zm_transit_automaton::automatondamagecallback, ::automatondamagecallback_custom);
    replacefunc(maps\mp\zm_transit_automaton::shove_players_off_bus, ::shove_players_off_bus_custom);

    replacefunc(maps\mp\gametypes_zm\_globallogic_score::incpersstat, ::incpersstat_custom);
    replacefunc(maps\mp\zombies\_zm_stats::add_client_stat, ::add_client_stat_custom);
    replacefunc(maps\mp\zombies\_zm_stats::initializematchstats, ::initializematchstats_custom);
    replacefunc(maps\mp\zombies\_zm_audio::zmbvoxgetlinevariant, ::zmbvoxgetlinevariant_custom);
    replacefunc(maps\mp\gametypes_zm\_weaponobjects::createweaponobjectwatcher, ::createweaponobjectwatcher_custom);
    replacefunc(maps\mp\gametypes_zm\_globallogic_score::initpersstat, ::initpersstat_custom);
    replacefunc(maps\mp\zombies\_zm_powerups::powerup_hud_monitor, ::powerup_hud_monitor_custom);
    replacefunc(maps\mp\gametypes_zm\_hostmigration::waittillhostmigrationdone, ::waittillhostmigrationdone_custom);
    replacefunc(maps\mp\zm_transit_achievement::init, ::init_custom);
    replacefunc(maps\mp\zombies\_zm::actor_damage_override, ::actor_damage_override_custom);
}

actor_damage_override_custom( inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex )
{
    if (isdefined(attacker.slayer_multiplier))
    {
        damage *= (1 + float(attacker.kills / 300));
    }
    if ( !isdefined( self ) || !isdefined( attacker ) )
        return damage;

    if ( weapon == "tazer_knuckles_zm" || weapon == "jetgun_zm" )
        self.knuckles_extinguish_flames = 1;
    else if ( weapon != "none" )
        self.knuckles_extinguish_flames = undefined;

    if ( isdefined( attacker.animname ) && attacker.animname == "quad_zombie" )
    {
        if ( isdefined( self.animname ) && self.animname == "quad_zombie" )
            return 0;
    }

    if ( !isplayer( attacker ) && isdefined( self.non_attacker_func ) )
    {
        if ( isdefined( self.non_attack_func_takes_attacker ) && self.non_attack_func_takes_attacker )
            return self [[ self.non_attacker_func ]]( damage, weapon, attacker );
        else
            return self [[ self.non_attacker_func ]]( damage, weapon );
    }

    if ( !isplayer( attacker ) && !isplayer( self ) )
        return damage;

    if ( !isdefined( damage ) || !isdefined( meansofdeath ) )
        return damage;

    if ( meansofdeath == "" )
        return damage;

    old_damage = damage;
    final_damage = damage;

    if ( isdefined( self.actor_damage_func ) )
        final_damage = [[ self.actor_damage_func ]]( inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex );
/#
    if ( getdvarint( _hash_5ABA6445 ) )
        println( "Perk/> Damage Factor: " + final_damage / old_damage + " - Pre Damage: " + old_damage + " - Post Damage: " + final_damage );
#/
    if ( attacker.classname == "script_vehicle" && isdefined( attacker.owner ) )
        attacker = attacker.owner;

    if ( isdefined( self.in_water ) && self.in_water )
    {
        if ( int( final_damage ) >= self.health )
            self.water_damage = 1;
    }

    attacker thread maps\mp\gametypes_zm\_weapons::checkhit( weapon );

    if ( attacker maps\mp\zombies\_zm_pers_upgrades_functions::pers_mulit_kill_headshot_active() && is_headshot( weapon, shitloc, meansofdeath ) )
        final_damage *= 2;

    if ( isdefined( level.headshots_only ) && level.headshots_only && isdefined( attacker ) && isplayer( attacker ) )
    {
        if ( meansofdeath == "MOD_MELEE" && ( shitloc == "head" || shitloc == "helmet" ) )
            return int( final_damage );

        if ( is_explosive_damage( meansofdeath ) )
            return int( final_damage );
        else if ( !is_headshot( weapon, shitloc, meansofdeath ) )
            return 0;
    }

    return int( final_damage );
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
                level.gamemode_difficulty = "^6GigaChad^7";
                level.difficulty_selected = 1;
                level.boss_name = "^1Avogadro Suprimis^3";
                iprintln("Selected difficulty : ^6GigaChad^7.");
                wait 5;
                iprintln("^3[ " + level.boss_name + " ]^7 : ^1You are in for a hell of a ride");
                return;

            }
            else if (level.chad_difficulty_vote_count >= level.ez_difficulty_vote_count)
            {
                level.gamemode_difficulty = "^1Chad^7";
                level.difficulty_selected = 1;
                level.boss_name = "^1Avogadro Ultimis^3";
                iprintln("Selected difficulty : ^1Chad^7.");
                wait 5;
                iprintln("^3[ " + level.boss_name + " ]^7 : ^1My turn.");
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

    if (getdvar("net_port") != "30011")
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

    for (i = 0; i < 20; i++)
    {
        playfx( level._effect["jetgun_vortex"], self.origin );
    }
    self playsound( "zmb_screecher_portal_spawn" );

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

init_custom()
{
    return;
}

waittillhostmigrationdone_custom()
{
    if (getdvar("net_port") == "30011")
        return;
    if ( !isdefined( level.hostmigrationtimer ) )
        return 0;

    starttime = gettime();

    level waittill( "host_migration_end" );

    return gettime() - starttime;
}


lava_damage_think_custom()
{
   // flag_wait("initial_blackscreen_passed" );
    if (getdvar("net_port") == "30011")
        return;
    self._trap_type = "";

    if ( isdefined( self.script_noteworthy ) )
        self._trap_type = self.script_noteworthy;

    if ( isdefined( self.target ) )
    {
        self.volume = getent( self.target, "targetname" );
        assert( isdefined( self.volume ), "No volume found for lava target " + self.target );
    }

    while ( true )
    {
        self waittill( "trigger", ent );

        if ( isdefined( ent.ignore_lava_damage ) && ent.ignore_lava_damage )
            continue;

        if ( isdefined( ent.is_burning ) )
            continue;

        if ( isdefined( self.target ) && !ent istouching( self.volume ) )
            continue;

        if ( isplayer( ent ) )
        {
            switch ( self._trap_type )
            {
                case "fire":
                default:
                    if ( !isdefined( self.script_float ) || self.script_float >= 0.1 )
                        ent thread player_lava_damage( self );

                    break;
            }
        }
        else if ( !isdefined( ent.marked_for_death ) )
        {
            switch ( self._trap_type )
            {
                case "fire":
                default:
                    if ( !isdefined( self.script_float ) || self.script_float >= 0.1 )
                        ent thread zombie_lava_damage( self );

                    break;
            }
        }
    }
}

powerup_hud_monitor_custom()
{
  //  flag_wait("initial_blackscreen_passed" );
    if (getdvar("net_port") == "30011")
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

        for ( playerindex = 0; playerindex < level.players.size; playerindex++ )
        {
            for ( client_field_key_index = 0; client_field_key_index < client_field_keys.size; client_field_key_index++ )
            {
                player = level.players[playerindex];
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

initpersstat_custom( dataname, record_stats, init_to_stat_value )
{
  //  flag_wait("initial_blackscreen_passed" );
    if (getdvar("net_port") == "30011")
        return;
    if ( !isdefined( self.pers[dataname] ) )
        self.pers[dataname] = 0;

    if ( !isdefined( record_stats ) || record_stats == 1 )
        recordplayerstats( self, dataname, int( self.pers[dataname] ) );

    if ( isdefined( init_to_stat_value ) && init_to_stat_value == 1 )
        self.pers[dataname] = self getdstat( "PlayerStatsList", dataname, "StatValue" );
}

decrease_bus_oxygen()
{
    level endon( "game_ended" );

    flag_wait("initial_blackscreen_passed");
    for (;;)
    {
        level.oxygen_level--;
        if (level.gamemode_difficulty == "^6GigaChad^7")
            wait 24;
        else
            wait 19;
    }
}

oxygen_level()
{
    level endon( "game_ended" );
    self endon("disconnect");

    //wait 60;
    self.zombieTextO = maps\mp\gametypes_zm\_hud_util::createFontString( "hudsmall" , 1.5 );
    self.zombieTextO maps\mp\gametypes_zm\_hud_util::setPoint( "TOP", "RIGHT", -10, -215 );
    self.zombieTextO.label = &"Bus ^5Oxygen^7 Level : ^2";
    self.zombieTextO setvalue(level.oxygen_level);
    self.zombieTextO.alpha = 0.8;
    for (;;)
    {
        if (level.round_number >= 35 && level.gamemode_difficulty == "^6GigaChad^7")
        {
            self.zombieTextO destroy();
            return;
        }
        if (level.round_number >= 35 && level.gamemode_difficulty == "^1Chad^7")
        {
            self.zombieTextO destroy();
            return;
        }
        if (level.round_number >= 25 && level.gamemode_difficulty == "^2Ez^7")
        {
            self.zombieTextO destroy();
            return;
        }
        if (level.oxygen_level <= 0)
        {
            self.zombieTextO setvalue(0);
            break;
        }
        self.zombieTextO setvalue(level.oxygen_level);
        if (level.oxygen_level < 75)
                self.zombieTextO.label = &"^5Bus Oxygen Level : ^5";
        if (level.oxygen_level < 50)
                self.zombieTextO.label = &"^5Bus Oxygen Level : ^3";
        if (level.oxygen_level < 25)
                self.zombieTextO.label = &"^5Bus Oxygen Level : ^1";
        wait 5;
    }
    self iprintln("^1The Bus ran out of oxygen !");
    wait 2;
    self iprintln("^1The Bus ran out of oxygen !");
    for (;;)
    {
        self dodamage(5, self.origin);
        wait 0.5;
    }
}

createweaponobjectwatcher_custom( name, weapon, ownerteam )
{
    if (weapon != "equip_turbine_zm")
        return;

        if ( !isdefined( self.weaponobjectwatcherarray ) )
            self.weaponobjectwatcherarray = [];

        weaponobjectwatcher = getweaponobjectwatcher( name );

        if ( !isdefined( weaponobjectwatcher ) )
        {
            weaponobjectwatcher = spawnstruct();
            self.weaponobjectwatcherarray[self.weaponobjectwatcherarray.size] = weaponobjectwatcher;
            weaponobjectwatcher.name = name;
            weaponobjectwatcher.type = "use";
            weaponobjectwatcher.weapon = weapon;
            weaponobjectwatcher.weaponidx = getweaponindexfromname( weapon );
            weaponobjectwatcher.watchforfire = 0;
            weaponobjectwatcher.hackable = 0;
            weaponobjectwatcher.altdetonate = 0;
            weaponobjectwatcher.detectable = 1;
            weaponobjectwatcher.headicon = 1;
            weaponobjectwatcher.stuntime = 0;
            weaponobjectwatcher.activatesound = undefined;
            weaponobjectwatcher.ignoredirection = undefined;
            weaponobjectwatcher.immediatedetonation = undefined;
            weaponobjectwatcher.deploysound = getweaponfiresound( weaponobjectwatcher.weaponidx );
            weaponobjectwatcher.deploysoundplayer = getweaponfiresoundplayer( weaponobjectwatcher.weaponidx );
            weaponobjectwatcher.pickupsound = getweaponpickupsound( weaponobjectwatcher.weaponidx );
            weaponobjectwatcher.pickupsoundplayer = getweaponpickupsoundplayer( weaponobjectwatcher.weaponidx );
            weaponobjectwatcher.altweapon = undefined;
            weaponobjectwatcher.ownergetsassist = 0;
            weaponobjectwatcher.playdestroyeddialog = 1;
            weaponobjectwatcher.deleteonkillbrush = 1;
            weaponobjectwatcher.deleteondifferentobjectspawn = 1;
            weaponobjectwatcher.enemydestroy = 0;
            weaponobjectwatcher.onspawn = undefined;
            weaponobjectwatcher.onspawnfx = undefined;
            weaponobjectwatcher.onspawnretrievetriggers = undefined;
            weaponobjectwatcher.ondetonated = undefined;
            weaponobjectwatcher.detonate = undefined;
            weaponobjectwatcher.stun = undefined;
            weaponobjectwatcher.ondestroyed = undefined;

            if ( !isdefined( weaponobjectwatcher.objectarray ) )
                weaponobjectwatcher.objectarray = [];
        }
        resetweaponobjectwatcher( weaponobjectwatcher, ownerteam );
        return weaponobjectwatcher;
}



init()
{
    setDvar("EE_Completion", "");
    setDvar("isBus", "");
    setdvar("king_lock", "0");
    setDvar("gamemode_speedrun_quest_titb", "0");

    level.blessing_count = 8;
    level.net_port_titb = [];
    level.net_port_titb[level.net_port_titb.size] = "30011";
    level.zombie_ai_limit = 32;
    level.zombie_actor_limit = 40;
    level.extra_speed = 0;
    level.primaryprogressbarwidth = 400;
    level.primaryprogressbarheight = 15;
    level.primaryprogressbarfontsize = 1;
    level.oxygen_level = 100;
    level.boss_name = "^1Avogadro Primis^3";
    level.game_started = 0;
    level.difficulty_selected = 0;
    level.ez_difficulty_vote_count = 0;
    level.chad_difficulty_vote_count = 0;
    level.gigachad_difficulty_vote_count = 0;
    level.gamemode_difficulty = "^2Ez^7";
    level.vote_required = 8;
    level thread on_player_connect();
    level thread super_zombie();
    level thread bus_kick_faster();
    level thread bus_wait_at_start();
    level thread story();
    level thread rewardWatcher();
    level thread LoopEESong();
    level thread outofzoneplayerwatcher();
    level thread setZmCount();
    level thread player_manager();
    level thread decrease_bus_oxygen();
    level thread difficulty_watcher();
    level thread weapon_watcher();
    level thread init_bolts();
    level thread team_buff();
    level thread wait_for_difficulty();
    level thread door_text();
    level thread invisible_wall();

    flag_wait("initial_blackscreen_passed");
    level.start_time = GetTime();
}

invisible_wall()
{
    if (getdvar("net_port") != "30011")
        return;
    level thread generateInvisibleBoxCollision((13543.8, -962.988, -187.96), (0, -90, 0));
    level thread generateInvisibleBoxCollision((13543.8, -290.138, -187.875), (0, -90, 0));
}

door_text()
{
    flag_wait("initial_blackscreen_passed" );
    level endon("game_ended");

    if (getdvar("net_port") != "30011")
        return;

    doorstrigger = getentarray( "bus_door_trigger", "targetname" );

    for (;;)
    {
        for ( i = 0; i < doorstrigger.size; i++ )
        {
            doorstrigger[i] sethintstring( "The door is ^1jammed^7. Find ^3another way" );
        }
        wait 0.1;
    }
}

wait_for_difficulty()
{
    level endon ("game_ended");

    flag_wait("initial_blackscreen_passed" );
        
    for (;;)
    {
        if (level.difficulty_selected == 1)
        {
            level thread delayrnd();
            return;
        }

        wait 1;
    }
}

super_zombie()
{
	level endon("end_game");

    flag_wait("initial_blackscreen_passed" );

    if (getdvar("net_port") != "30011")
        return;
    for (;;)
    {
        if (level.difficulty_selected == 1)
        {
            wait 20;
            break;
        }
        wait 0.1;
    }
    for (;;)
    {
        if (level.gamemode_difficulty == "^6GigaChad^7")
        {
            zombies = getAiArray(level.zombie_team);
            foreach(zombie in zombies)
            {
                if (!isdefined(zombie.is_avogadro) && !isdefined(zombie.isscreecher) && isdefined(level.zm_more_dmg))
                    zombie.meleedamage = 80;
                if (!isdefined(zombie.upgrade_chance))
                {
                    rnd = randomint(20);
                    if (isdefined(level.more_omega) && rnd > 15 || rnd > 16)
                        zombie thread change_zombie_speed("chase_bus");
                    else if (rnd > 11)
                        zombie thread change_zombie_speed("super_sprint");
                    zombie.upgrade_chance = 1;
                }
            }
        }
    	wait 3;
    }
}

change_zombie_speed(speed)
{
    level endon("game_ended");
    self endon("death");

    for (;;)
    {
        if(!isDefined(self.cloned_distance))
        {
            self.cloned_distance = self.origin;
        }
        else if(distance(self.cloned_distance, self.origin) > 15)
        {
            self.cloned_distance = self.origin;
            if(self.self_move_speed != speed)
                self maps\mp\zombies\_zm_utility::set_zombie_run_cycle(speed);
        }
        else if(distance(self.cloned_distance, self.origin) <= 15)
        {
            self.cloned_distance = self.origin;
            self maps\mp\zombies\_zm_utility::set_zombie_run_cycle("run");
        }
        wait 0.25;
    }

}

on_player_connect()
{
    level endon("game_ended");

    if (getdvar("net_port") != "30011")
        return;

    for (;;)
    {
        level waittill("connected", player);
        player thread gamemode_hud();
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

team_buff()
{
    level endon("game_ended");

    if (getdvar("net_port") != "30011")
        return;

    m_id = 0;
    r = randomint(100);
    r2 = randomint(100);
    if (r > 80)
    {
        m_id = 1;
        level.str1 = "^2Gas Mask^7\n- Slower loss of oxygen";
        level.gas_mask = 1;
    }
    else if (r > 60)
    {
        m_id = 2;
        level.str1 = "^2Running in the 90s^7\n- Your team is zooming";
        level.extra_speed = 0.25;
    }
    else if (r > 40)
    {
        m_id = 3;
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
        m_id = 4;
        level.str1 = "^2Welder^7\n- Repaired barricade are now metal";
        level thread set_barricade_perma_perk(1);
    }
    else if (r >= 0)
    {
        m_id = 5;
        level.str1 = "^2Medic Squad^7\n- Increased revive speed";
        level.faster_revive = 1;
    }

    //ENEMY BUFF

    else if (r2 >= 90 && level.gamemode_difficulty == "^6GigaChad^7")
    {
        level.str2 = "^1Omega Swarm^7\n- Omega zombie spawn chance increased";
        level.more_omega = 1;
    }
    if (r2 >= 70)
    {
        level.str2 = "^1Rusty Bus^7\n- Bus will randomly stop"; 
        level thread rusty_bus();
    }
    else if (r2 >= 50)
    {
        level.str2 = "^1Gymholic^7\n- Zombies hits harder";
        level.zm_more_dmg = 1;
    }
    else if (r2 >= 30 && level.str1 != "^1Welder^7\n- Repaired barricade are now metal")
    {
        level.str2 = "^1Clumsy^7\n- Metal barricade removed";
        level thread set_barricade_perma_perk(0);
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
            if (r > 80 && m_id != 1)
                break;
            else if (r > 60 && m_id != 2)
                break;
            else if (r > 40 && m_id != 3)
                break;
            else if (r > 20 && m_id != 4)
                break;
            else if (r > 0 && m_id != 5)
                break;
            wait 0.05;
        }
        if (r > 80)
        {
            level.str1 += "^2Gas Mask^7\n- Slower loss of oxygen";
            level.gas_mask = 1;
        }
        else if (r > 60)
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
            level.str1 += "^1Welder^7\n- Repaired barricade are now metal";
            level thread set_barricade_perma_perk(1);
        }
        else if (r >= 0)
        {
            level.str1 += "^2Medic Squad^7\n- Increased revive speed";
            level.faster_revive = 1;
        }
    }
    level.modif_lock = 1;
}

set_barricade_perma_perk(val)
{
    level endon("game_ended");

    for (;;)
    {
        foreach(player in level.players)
        {
            self.pers_upgrades_awarded["board"] = val;
        }
        wait 0.5;
    }
}

rusty_bus()
{
    level endon("game_ended");

    for (;;)
    {
        if (isdefined(level.game_started) && level.game_started == 1)
            break;
        wait 0.5;
    }
    wait 30;
    for (;;)
    {
        rnd = randomint(100);
        if (rnd > 95)
        {
            level.the_bus busstopmoving();
            wait 30;
            level thread bus_speed(1200);
            wait 180;
        }

        wait 5;
    }

}

init_bolts()
{
    flag_wait("initial_blackscreen_passed" );
    if (getdvar("net_port") != "30011")
        return;
    level.a_bolts = [];
    for (i = 0; i < 8; i++)
    {
        level.a_bolts[i] = spawn( "script_model", (0, 0, 0) );
        level.a_bolts[i] setmodel( "tag_origin", (0, 0, 0) );
    }
}

weapon_watcher()
{
    level endon("game_ended");
    flag_wait("initial_blackscreen_passed");
    
    if (getdvar("net_port") != "30011")
        return;
    for (;;)
    {
        foreach(player in level.players)
        {
            weapon = player GetCurrentWeapon();
            if (weapon == "m1911_zm")
                player TakeWeapon(weapon);
        }
        wait 2;
    }
}

player_manager()
{
    level endon( "game_ended" );
    flag_wait("initial_blackscreen_passed" );

    if (getdvar("net_port") != "30011")
        return;
    for (;;)
    {
        foreach (player in level.players)
        {
            if (!isdefined(player.has_spawned))
                player thread onPlayerSpawned();
        }

        wait 0.5;
    }
}

onPlayerSpawned()
{
    level endon( "game_ended" );
    self endon("disconnect");
    flag_wait("initial_blackscreen_passed" );

    if (getdvar("net_port") != "30011")
        return;
    self.hasBlessing = 0;    
    self.has_spawned = 1;
    self thread set_speed();
    self thread healthBar(); 
    self thread health();  
    self thread nores();  
    self thread oxygen_level(); 
    self thread fog_damage_player();  
    self thread tf();
    if (self.sessionstate != "spectator")
        self TakeWeapon(self GetCurrentWeapon());
    wait 5;
    for (;;)
    {
        if (level.round_number >= 35 && (level.gamemode_difficulty == "^1Chad^7" || level.gamemode_difficulty == "^6GigaChad^7"))
            break;        
        if (level.round_number >= 25 && level.gamemode_difficulty == "^2Ez^7")
            break;
        if (self.sessionstate != "spectator")
        {
            tag = strtok(self.name, "]");
            if (tag[1] == "^6VIP^7]" || tag[1] == "^6VIP]" || tag[1] == "^1[VIP" || tag[1] == "[^1VIP^7" || tag[1] == "[^2VIP^7")
                self thread permaQuickRevive();
            id = self getEntityNumber();
            self thread TpToBus(id);
          //  self maps\mp\zombies\_zm_equipment::equipment_give( "riotshield_zm" );
            //self maps\mp\zombies\_zm_equipment::equipment_give( "jetgun_zm" );
            return;
        }
        wait 0.5;
    }
}

tf()
{
    if (getdvar("net_port") != "30011")
        return;
    for (;;)
    {
        if (self GetCurrentWeapon() == "ray_gun_zm")
            self TakeWeapon("ray_gun_zm");
        wait 0.2;
    }

}

set_speed()
{
    for (;;)
    {
        self SetMoveSpeedScale(1.10 + level.extra_speed);
        wait 1;
    }

}

shove_players_off_bus_custom()
{
    playfxontag( level._effect["turbine_on"], level.automaton, "J_neck" );
    wait 0.25;
    level.automaton playsound( "zmb_powerup_grabbed" );

    foreach ( player in level.players )
    {
        if (isdefined( player.isonbusroof ) && player.isonbusroof != 0 && isdefined (level.gamemode_difficulty))
        {
            continue;
        }

        if ( isdefined( player.isonbus ) && player.isonbus)
        {
            dir = anglestoright( level.the_bus.angles );
            dir = vectornormalize( dir );
            player_velocity = dir * 900;
            player setvelocity( player_velocity );
            earthquake( 0.25, 1.0, player.origin, 256, player );
        }
    }
}

link_nodes_custom( a, b, bdontunlinkonmigrate = 0 )
{
    return;
}

unlink_nodes_custom( a, b, bdontlinkonmigrate = 0 )
{
    return;
}

bus_kick_faster()
{
    level endon ("game_ended");
        flag_wait("initial_blackscreen_passed" );
    if (getdvar("net_port") != "30011")
        return;
    for (;;)
    {
        level.timesplayerattackingautomaton = 3;
        wait 2;
    }
}


bus_wait_at_start()
{
    level endon ("game_ended");
    flag_wait("initial_blackscreen_passed" );
    if (getdvar("net_port") != "30011")
        return;
    level thread bus_speed(1200);
    wait 5;
    for (i = 0; i < 20; i++)
    {
        level.the_bus busstopmoving();
        wait 3;
    }
    level thread bus_speed(1200);
    for (;;)
    {
        if (level.gamemode_difficulty == "^1Chad^7" || level.gamemode_difficulty == "^6GigaChad^7")
            level.the_bus.waittimeatdestination = 30;
        else
            level.the_bus.waittimeatdestination = 60;
        wait 5;

    }
}

bus_speed(speed)
{
    level.the_bus busstartmoving( speed );  
}


story()
{
    level endon ("game_ended");
    flag_wait("initial_blackscreen_passed" );
    if (getdvar("net_port") != "30011")
        return;
    wait 75;
    iprintln("^3[ " + level.boss_name + " ]^7 : New ^1challengers^7 ? I wonder how long you can ^1hold your breath^7 :)");
    wait 5;
    iprintln("^3[ " + level.boss_name + " ]^7 : ^1Awakened^7, ^1Blessed^7, ... It will not matter.");
    wait 5;
    iprintln("^3[ " + level.boss_name + " ]^7 : While my cage is not much of a prison,");
    wait 3;
    iprintln("^3[ " + level.boss_name + " ]^7 : With your team ^1I doubt I will need to leave it^7.");
    wait 10;
    if (level.gamemode_difficulty == "^1Chad^7" || level.gamemode_difficulty == "^6GigaChad^7" )
        setdvar("ln", "^3Reach ^5Round 35^3 to face " + level.boss_name + " !"); 
    else
        setdvar("ln", "^3Reach ^5Round 25^3 to face " + level.boss_name + " !"); 
    wait 10;
    if (level.gamemode_difficulty == "^1Chad^7" || level.gamemode_difficulty == "^6GigaChad^7" )
        setdvar("ln", "^3Reach ^5Round 35^3 to face " + level.boss_name + " !"); 
    else
        setdvar("ln", "^3Reach ^5Round 25^3 to face " + level.boss_name + " !"); 
}

rewardWatcher()
{
    level endon ("game_ended");
    flag_wait("initial_blackscreen_passed" );
    if (getdvar("net_port") != "30011")
        return;
    wait 60;
    if (level.gamemode_difficulty == "^1Chad^7" || level.gamemode_difficulty == "^6GigaChad^7") //changed
        level thread game_watcher(30, 32, 34, 35);
    else
        level thread game_watcher(20, 22, 24, 25);
}

game_watcher(cp1, cp2, cp3, cp4)
{
    lock = 0;

    for (;;)
    {
        if (level.round_number >= cp1 && lock == 0)
        {
            foreach(player in level.players)
            {
                if (player.sessionstate == "spectator")
                {
                    id = player getEntityNumber();
                    player thread Checkpoint(id);
                }
            }
            setDvar("bold", "Checkpoint ^2reached!");
            lock = 1;
        }
        else if (level.round_number >= cp2 && lock == 1)
        {

            foreach(player in level.players)
            {
                if(player.sessionstate == "spectator")
                {
                    id = player getEntityNumber();
                    player thread Checkpoint(id);
                }
            }
            setDvar("bold", "Checkpoint ^2reached!");
            lock = 2;
            if (level.gamemode_difficulty == "^1Chad^7")
            {
                level.avogadro.maxhealth = 400000;
                if (level.players.size <= 2)
                    level.avogadro.maxhealth = 200000;   
                if (level.players.size >= 6)
                    level.avogadro.maxhealth = 600000;
            }
            else if (level.gamemode_difficulty == "^6GigaChad^7")
            {
                level.avogadro.maxhealth = 700000;
                if (level.players.size <= 2)
                    level.avogadro.maxhealth = 500000;   
                if (level.players.size >= 6)
                    level.avogadro.maxhealth = 900000;
            }
            else
            {
                level.avogadro.maxhealth = 300000;
                if (level.players.size <= 2)
                    level.avogadro.maxhealth = 150000;   
                if (level.players.size >= 6)
                    level.avogadro.maxhealth = 450000;
            }
            level.avogadro.health = level.avogadro.maxhealth;
        }
        else if (level.round_number >= cp3 && lock == 2)
        {
            setdvar("king_lock", "1");
            if (level.gamemode_difficulty == "^6GigaChad^7")
                setDvar("EE_Completion", "TitB_Early_GigaChad");
            else
                setDvar("EE_Completion", "TitB_Early");
            for (i = 0; i < 5; i++)
            {
                self playsound("zmb_cha_ching");
                wait 0.5;
            }
            foreach(player in level.players)
            {
                if(player.sessionstate == "spectator")
                {
                    id = player getEntityNumber();
                    player thread Checkpoint(id);
                }
            }
            setDvar("bold", "Checkpoint ^2reached!");
            lock = 4;
        }
        else if (level.round_number == cp4 && lock == 4)
        {
            foreach (player in level.players)
            {
                id = player getEntityNumber();
                player thread tp_to_final_stage(id);
                
            }
            wait 5;
            iprintln("^3[ " + level.boss_name + " ]^7 : ^1I applaud your joined efforts, but this is where your story ends.");
            wait 5;
            iprintln("^3[ " + level.boss_name + " ]^7 : ^1Time to up the voltage !");
            wait 10;
            if (level.gamemode_difficulty == "^1Chad^7")
                level thread spawn_boss(1.8, 1.4, 1.2);
            else if (level.gamemode_difficulty == "^6GigaChad^7")
                level thread spawn_boss(1.4, 1.2, 0.9);
            else
                level thread spawn_boss(2, 1.7, 1.4);
            level thread player_rev_watcher();
            level thread LoopEESong();
            return;
        }
        wait 5;
    }
}

player_rev_watcher()
{
    level endon ("game_ended");

    for (;;)
    {
        foreach(player in level.players)
        {
                if (player.sessionstate == ("spectator") && !isdefined(player.lock))
                {
                    player.lock = 1;
                    id = player getEntityNumber();
                    player thread waittill_rev(id);
                    
                }
        }
        wait 1;
    }
}

waittill_rev(id)
{
        level endon ("game_ended");
        self endon ("disconnect");
    for (;;)
    {
        if (self.sessionstate != ("spectator"))
        {
            self thread tp_to_final_stage(id);
            self.lock = undefined; //can cause issue
            return;
        }
        wait 0.5;
    }
}

delayrnd()
{
    flag_wait("initial_blackscreen_passed" );
    if (getdvar("net_port") != "30011")
        return;
    set_zombie_var( "emp_stun_range", 0 );

    if (level.gamemode_difficulty == "^1Chad^7" || level.gamemode_difficulty == "^6GigaChad^7" )
        level.round_number = 29;
    else
        level.round_number = 19;
    level.zombie_total = 1;
    wait 20;
    for(;;)
    {
        if (level.round_number != 29 && (level.gamemode_difficulty == "^1Chad^7" || level.gamemode_difficulty == "^6GigaChad^7") ) //changed
        {
            break;
        }

        if (level.round_number != 19 && level.gamemode_difficulty == "^2Ez^7") //changed
            break;
        zombies = getaiarray( level.zombie_team );
        foreach ( enemy in zombies )    
        {
            if (!isdefined(enemy.is_avogadro))
                enemy dodamage( enemy.health + 666, enemy.origin );
        }
        wait 2;   
    }
}

outofzoneplayerwatcher()
{
    level endon ("game_ended");

    flag_wait("initial_blackscreen_passed" );
    if (getdvar("net_port") != "30011")
        return;
  //  foreach (player in level.players)
   //     player thread announcement();
}


fog_damage_player()
{
    self endon("disconnect");
    level endon("game_ended");

    for (;;)
    {
        wait 1.5;
        if (level.round_number >= 35 && (level.gamemode_difficulty == "^1Chad^7" || level.gamemode_difficulty == "^6GigaChad^7"))
            break;
        if (level.round_number >= 25 && level.gamemode_difficulty == "^2Ez^7")
            break;
        bus_forward = vectornormalize( anglestoforward( level.the_bus.angles ) );
        if (distance(self.origin, level.the_bus.origin + vectorscale( bus_forward, 155 )) > 260)
        {
            if (isdefined(self.scavenger) && self.scavenger == true)
            {
                wait 0.8;
            }
            if (isdefined(level.gas_mask))
                wait 0.8;
            if (level.gamemode_difficulty == "^1Chad^7" || level.gamemode_difficulty == "^6GigaChad^7")
                self dodamage( 4, self.origin );
            else
                self dodamage( 2, self.origin );
        }
    }
}
announcement()
{
    wait 2;
    for (;;)
    {
        wait 1;
        if (self.sessionstate == "spectator" || (self maps\mp\zombies\_zm_laststand::player_is_in_laststand()))
            continue;
        self.zombieTexta setvalue(self.health); 
        if (self.health <= 50 && self.health != 0)
        {
            self useServerVisionSet(true);
            self setvisionsetforplayer( "zombie_death", 0 );
            self thread maps\mp\gametypes_zm\_hud::fadetoblackforxsec( 0, 0, 5, 5);
            wait 6;
        }
        else if (self.health < 100)
        {
            self thread maps\mp\gametypes_zm\_hud::fadetoblackforxsec( 0, 0, 2, 2);
            wait 3;
        }
        else if (self.health <= 150)
        {
            self thread maps\mp\gametypes_zm\_hud::fadetoblackforxsec( 0, 0, 1, 1);
            wait 2;
        }         
        else
        {
            self useServerVisionSet(false);
            self setvisionsetforplayer("remote_mortar_enhanced", 0);
        }  
    }
}

nores()
{
    level endon( "game_ended" );

    for (;;)
    {
        self.spectator_respawn = undefined;
        wait 3;
    }
}

isBusGamemode()
{
	level endon( "game_ended" );
    flag_wait("initial_blackscreen_passed" );

    if (getdvar("net_port") != "30011")
        return;
    return true;
}

incpersstat_custom( dataname, increment, record_stats, includegametype )
{
    return;
}

add_client_stat_custom( stat_name, stat_value, include_gametype )
{
    return;
}

CheckPoint(id)
{
    self endon("disconnect");
    level endon ("game_ended");
    self.origin = (10000, 10000, 10000 + 100 * id);
  //  self.spectator_respawn = 1;
    self [[ level.spawnplayer ]]();
    wait 0.1;
    self TakeWeapon(self GetCurrentWeapon());
  //  self.spectator_respawn = undefined;
    self thread TpToBus(id);
}



watchriotshielddeploycustom()
{
    self endon( "death" );
    self endon( "disconnect" );
    self endon( "start_riotshield_deploy" );

    self restoreriotshieldviewmodel();
    self setplacementhint( 1 );
    placement_hint = 0;
    self doriotshielddeploy( self.origin, self.angles );
}


LoopEESong()
{
    level endon ("game_ended");
    flag_wait("initial_blackscreen_passed" );
    wait 60;

    if (getdvar("net_port") != "30011")
        return;
    for (;;)
    {
        level thread PlayEESong("mus_zmb_secret_song");
        wait 700;
        if (level.round_number >= 22)
            break;
    }
}

PlayEESong(song)
{
    level endon ("game_ended");
    level.music_override = 1;
    playsoundatposition( song, ( 0, 0, 0 ) );

    level.music_override = 0;
}





health()
{
    self.health = 300;
    for (;;)
    {
        if (level.gamemode_difficulty == "^6GigaChad^7")
            self.maxhealth = 300;
        else
            self.maxhealth = 300;
        wait 1; 
    }
}

healthBar ()
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
    boss_name_text settext("^5Oxygen");
    //boss_bar_text setvalue(self.health);

    boss_health_text.hidewheninmenu = 1;

    while (1)
    {
        if (level.round_number == 35 && (level.gamemode_difficulty == "^1Chad^7" || level.gamemode_difficulty == "^6GigaChad^7"))
        {
            boss_bar.barframe destroy();
            boss_bar.bar destroy();
            boss_bar destroy();
            boss_name_text destroy();
            boss_health_text destroy();
            return;
        }
        if (level.round_number == 25 && level.gamemode_difficulty == "^2Ez^7")
        {
            boss_bar.barframe destroy();
            boss_bar.bar destroy();
            boss_bar destroy();
            boss_name_text destroy();
            boss_health_text destroy();
            return;
        }
        bus_forward = vectornormalize( anglestoforward( level.the_bus.angles ) );
        if (distance(self.origin, level.the_bus.origin + vectorscale( bus_forward, 155 )) < 260)
        {
            boss_bar.alpha = 0;
            boss_bar.bar.alpha = 0;
            boss_bar.barframe.alpha = 0;
            boss_name_text.alpha = 0;
            boss_health_text.alpha = 0;
        }
        else
        {
            boss_bar.alpha = 1;
            boss_bar.bar.alpha = 1;
            boss_bar.barframe.alpha = 1;
            boss_name_text.alpha = 1;
            boss_health_text.alpha = 1;
        }
        if (self.health / self.maxhealth > 0.5)
        {
            boss_bar.bar.color = ( self.maxhealth / self.health - 1, 1, 0 );
        }

        if (self.health / self.maxhealth == 0.5)
        {
            boss_bar.bar.color = ( 1, 1, 0 );
        }
        
        if (self.health / self.maxhealth < 0.5)
        {
            boss_bar.bar.color = ( 1, (self.health / self.maxhealth) * 2, 0 );
        }

        boss_bar updatebar(self.health / self.maxhealth);
        boss_health_text setvalue(self.health * 3);

        wait 0.3;
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
    boss_name_text settext(level.boss_name);
    //boss_bar_text setvalue(self.health);

    boss_health_text.hidewheninmenu = 1;
    while (1)
    {
        if (level.avogadro.health <= 1)
        {
            boss_bar.barframe destroy();
            boss_bar.bar destroy();
            boss_bar destroy();
            boss_name_text destroy();
            boss_health_text destroy();
            return;
        }
        if (level.avogadro.health / level.avogadro.maxhealth > 0.5)
        {
            boss_bar.bar.color = ( level.avogadro.maxhealth / level.avogadro.health - 1, 1, 0 );
        }

        if (level.avogadro.health / level.avogadro.maxhealth == 0.5)
        {
            boss_bar.bar.color = ( 1, 1, 0 );
        }
        
        if (level.avogadro.health / level.avogadro.maxhealth < 0.5)
        {
            boss_bar.bar.color = ( 1, (level.avogadro.health / level.avogadro.maxhealth) * 2, 0 );
        }

        boss_bar updatebar(level.avogadro.health / level.avogadro.maxhealth);


        if (level.gamemode_difficulty == "^6GigaChad^7")
        {
            if (level.avogadro.health > level.avogadro.maxhealth - (level.avogadro.health / 5))
                boss_health_text settext("^1IT'S OVER 9000 !!!");
            else 
            {
                boss_health_text settext("");
                boss_health_text setvalue(level.avogadro.health);
            }
        }
        else 
        {
            boss_health_text setvalue(level.avogadro.health);
        }

        boss_health_text setvalue(level.avogadro.health);

        wait 0.3;
    }
}

TpToBus(id)
{
    
    level endon ("game_ended");
    self endon("disconnect");
    bus_forward = vectornormalize( anglestoforward( level.the_bus.angles ) );
    if (id == 0)
    {
        
        angle = (0, 180, 0);
        origin = level.the_bus.origin + vectorscale( bus_forward, 30 ) + (0, 0, 30);
        self setOrigin(origin);
        self SetPlayerAngles(angle);
    }
    else if (id == 1)
    {
        angle = (0, 180, 0);
        origin = level.the_bus.origin + vectorscale( bus_forward, 60 ) + (0, 0, 30);
        self setOrigin(origin);
        self SetPlayerAngles(angle);
    }
    else if (id == 2)
    {
        angle = (0, 180, 0);
        origin = level.the_bus.origin + vectorscale( bus_forward, 90 ) + (0, 0, 30);
        self setOrigin(origin);
        self SetPlayerAngles(angle);
    }
    else if (id == 3)
    {
        angle = (0, 0, 0);
        origin = level.the_bus.origin + vectorscale( bus_forward, 120 ) + (0, 0, 30);
        self setOrigin(origin);
        self SetPlayerAngles(angle);
    }
    else if (id == 4)
    {
        angle = (0, 180, 0);
        origin = level.the_bus.origin + vectorscale( bus_forward, 150 ) + (0, 0, 30);
        self setOrigin(origin);
        self SetPlayerAngles(angle);
    }
    else if (id == 5)
    {
        angle = (0, 0, 0);
        origin = level.the_bus.origin + vectorscale( bus_forward, -30 ) + (0, 0, 30);
        self setOrigin(origin);
        self SetPlayerAngles(angle);
    }
    else if (id == 6)
    {
        angle = (0, 0, 0);
        origin = level.the_bus.origin + vectorscale( bus_forward, 180 ) + (0, 0, 30);
        self setOrigin(origin);
        self SetPlayerAngles(angle);
    }
    else if (id == 7)
    {
        angle = (0, 180, 0);
        origin = level.the_bus.origin + vectorscale( bus_forward, 155 ) + (0, 0, 30);
        self setOrigin(origin);
        self SetPlayerAngles(angle);
    }

    wait 2;
    if (isdefined(level.game_started) && level.game_started == 0)
    {
        self thread difficulty_selector();
    }
    for (;;)
    {
        if (level.difficulty_selected == 1)
            break;
        wait 0.5;
    }

    foreach(guid in level.premium_pass_guid_list)
    {
        if (self getguid() == guid)
        {
            if (level.gamemode_difficulty == "^6GigaChad^7")
            {
                self GiveWeapon("srm1216_zm");
                self SwitchToWeapon("srm1216_zm");
            }
            else
            {
                self GiveWeapon("beretta93r_upgraded_zm");
                self SwitchToWeapon("beretta93r_upgraded_zm");
            }
            return;
        }
    }
    foreach(guid in level.premium_pass_guid_list2)
    {
        if (self getguid() == guid)
        {
            if (level.gamemode_difficulty == "^6GigaChad^7")
            {
                self GiveWeapon("srm1216_zm");
                self SwitchToWeapon("srm1216_zm");
            }
            else
            {
                self GiveWeapon("beretta93r_upgraded_zm");
                self SwitchToWeapon("beretta93r_upgraded_zm");
            }
            return;
        }
    }
}

busdoorssetupcustom()
{
    self.doorblockers = [];
    self.doorblockers = getentarray( "bus_door_blocker", "targetname" );
    doorstrigger = getentarray( "bus_door_trigger", "targetname" );

    for ( i = 0; i < self.doorblockers.size; i++ )
    {
        self.doorblockers[i].offset = self worldtolocalcoords( self.doorblockers[i].origin );
        self.doorblockers[i] linkto( self, "", self.doorblockers[i].offset, ( 0, 0, 0 ) );
        self.doorblockers[i] setmovingplatformenabled( 1 );
    }

    for ( i = 0; i < doorstrigger.size; i++ )
    {
        doorstrigger[i] enablelinkto();
        doorstrigger[i] linkto( self, "", self worldtolocalcoords( doorstrigger[i].origin ), ( 0, 0, 0 ) );
        doorstrigger[i] setcursorhint( "HINT_NOICON" );
        doorstrigger[i] sethintstring( &"ZOMBIE_TRANSIT_OPEN_BUS_DOOR" );
        doorstrigger[i] setmovingplatformenabled( 1 );
        doorstrigger[i] sethintlowpriority( 1 );
        if (getdvar("net_port") != "30011")
            self thread busdoorthink( doorstrigger[i] );
    }
    if (getdvar("net_port") != "30011")
        self maps\mp\zm_transit_openings::busopeningsetenabled( "door", 0 );
}


blessingArray(x)
{
    blessingArray = [];

    gunslinger = [];
    gunslinger[0] = "^1Gunslinger^7";
    gunslinger[1] = "^3Permanent Double Tap";  

    extraLife = [];
    extraLife[0] = "^1Guardian angel^7";
    extraLife[1] = "^3Get Dying wish & 50% HP\n    after all uses.";

    magicWeapon = [];
    magicWeapon[0] = "^1Magic Weapon^7";
    magicWeapon[1] = "^3Gain a special weapon";   

    speedRunner = [];
    speedRunner[0] = "^1Speed Runner^7";
    speedRunner[1] = "^3Increase your speed";

    quickRevive = [];
    quickRevive[0] = "^1Medic";
    quickRevive[1] = "^3Increase revive speed";

    scavenger = [];
    scavenger[0] = "^1Scavenger";
    scavenger[1] = "^3Increased oxygen capacity";

    slayer = [];
    slayer[0] = "^1Slayer";
    slayer[1] = "^3Gain 0.3 percent\ndamage per kill";

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
        blessingArray = scavenger;   
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

blessingSelector()
{
    self endon("disconnect");
    level endon ("game_ended");
  /*  if (isPanzerGamemode() == false)
        return; */  

    selector = "left";
    tag = strTok(self.name, "]");

    for (;;)
    {
        x = randomintrange(0, level.blessing_count);
        if ((x == 4 || x == 1) && (tag[1] == "^6[VIP" || tag[1] == "[^6VIP^7" || tag[1] == "^1[VIP" || tag[1] == "[^1VIP^7" || tag[1] == "[^2VIP^7"))
            continue;
        else
            break;
        wait 0.1;
    }
    blessingArrayLeft = blessingArray(x);
    for (;;)
    {
        y = randomintrange(0, level.blessing_count);
        if (y != x)
        {
            if ((y == 4 || y == 1) && (tag[1] == "^6[VIP" || tag[1] == "[^6VIP^7" || tag[1] == "^1[VIP" || tag[1] == "[^1VIP^7" || tag[1] == "[^2VIP^7"))
                continue;
            else
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
     && tag[1] != "[^2VIP^7" && tag[1] != "^2[VIP")
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
                for (i = 0; i < 20; i++)
                {
                    playfx( level._effect["jetgun_vortex"], self.origin );
                }
                self playsound( "zmb_screecher_portal_spawn" );
                break;
            }
            else if (selector == "right" && second_blessing == 1)
            {
                self thread applyBlessing(y);
                for (i = 0; i < 20; i++)
                {
                    playfx( level._effect["jetgun_vortex"], self.origin );
                }
                self playsound( "zmb_screecher_portal_spawn" );
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
                x = randomintrange(0, level.blessing_count);
                if (x != 0 || (x == 0 && getdvar("isBigMacShown") == "0"))
                {
                    if ((x == 4 || x == 1) && (tag[1] == "^6[VIP" || tag[1] == "[^6VIP^7" || tag[1] == "^1[VIP" || tag[1] == "[^1VIP^7" || tag[1] == "[^2VIP^7"))
                        continue;
                 //   if (x == old_x || x == old_y)
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
                    if ((y == 4 || y == 1) && (tag[1] == "^6[VIP" || tag[1] == "[^6VIP^7" || tag[1] == "^1[VIP" || tag[1] == "[^1VIP^7" || tag[1] == "[^2VIP^7"))
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
        if (i == 0)
            weapon_name = "hamr_zm";
        else if (i == 1)
            self maps\mp\zombies\_zm_equipment::equipment_give( "jetgun_zm" );
        else if (i == 2)
            weapon_name = "judge_zm";
        else if (i == 3)
            weapon_name = "knife_ballistic_bowie_upgraded_zm";
        else if (i == 4)
            weapon_name = "rottweil72_upgraded_zm";

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
        iprintln(self.name + " ^7picked ^3Scavenger");
        self.scavenger = true;
        self iPrintln("^3It feels ^5easier to breath");   
    }
    else if (blessingNumber == 6)
    {
        iprintln(self.name + " ^7picked ^3Slayer");
        self.slayer_multiplier = 1;
    }
    else if (blessingNumber == 7)
    {
        iprintln(self.name + " ^7picked ^3Combat Medic");
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
        self SetMoveSpeedScale(1.25 + level.extra_speed);
        wait 10;
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
        wait 5;
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
        wait 10;
    }
}

setZmCount()
{
    level endon ("game_ended");
        flag_wait("initial_blackscreen_passed" );
    if (getdvar("net_port") != "30011")
        return;
	saveRound = 1;
    wait 10;
	for (;;)
	{
		if (level.round_number > 10 && level.round_number != saveRound)
		{
			saveRound = level.round_number;
			wait 16;
			intval = int((0.13 * (saveRound * saveRound)) + (0.0160 * saveRound) + 23.490);
            if (level.players.size > 3)
                intval = int(intval * 1.5);
			level.zombie_total = intval;
			iPrintLn("^1Custom zombie amount^3 set.");
		}
		if (level.zombie_total < 0)
			level.zombie_total = 0;
		wait 1;
	}
} 




tp_to_final_stage(id)
{
    level endon ("game_ended");
    self endon("disconnect");
    p0 = (13857, -515, -188.875);
    p0_angles = (0, 180, 0);
    p1 = (13857, -578, -188.875);
    p1_angles = (0, 180, 0);
    p2 = (13668, -515, -188.875);
    p2_angles = (0, 0, 0);
    p3 = (13668, -582, -188.875);
    p3_angles = (0, 0, 0);
    p4 = (13799, -453, -188.875);
    p4_angles = (0, 270, 0);
    p5 = (13708, -453, -188.875);
    p5_angles = (0, 270, 0);
    p6 = (13803, -630, -188.875);
    p6_angles = (0, 90, 0);    
    p7 = (13731, -630, -188.875);
    p7_angles = (0, 90, 0); 

    if (id == 0)
    {
        self setOrigin(p0);
        self SetPlayerAngles(p0_angles);
    }
    if (id == 1)
    {
        self setOrigin(p1);
        self SetPlayerAngles(p1_angles);
    }
    if (id == 2)
    {
        self setOrigin(p2);
        self SetPlayerAngles(p2_angles);
    }
    if (id == 3)
    {
        self setOrigin(p3);
        self SetPlayerAngles(p3_angles);
    }
    if (id == 4)
    {
        self setOrigin(p4);
        self SetPlayerAngles(p4_angles);
    }
    if (id == 5)
    {
        self setOrigin(p5);
        self SetPlayerAngles(p5_angles);
    }
    if (id == 6)
    {
        self setOrigin(p6);
        self SetPlayerAngles(p6_angles);
    }
    if (id == 7)
    {
        self setOrigin(p7);
        self SetPlayerAngles(p7_angles);
    }
   // self.return_round
}

spawn_boss(boss_p1_cd, boss_p2_cd, boss_p3_cd)
{
  /*  level.avogadro.state = "idle";
    level.avogadro unlink();*/
    level.lock = 0;
    level thread zombie_watcher();
    foreach (player in level.players)
    {
        player thread healthBarBoss();
    }

    new_origin = (13773.5, -530.393, -188.875);
  //  ground_pos = groundpos_ignore_water_new( new_origin + vectorscale( ( 0, 0, 1 ), 60.0 ) );
    new_angles = (0, 0, 0);

    playsoundatposition( "zmb_avogadro_spawn_3d", new_origin );
    playfx( level._effect["avogadro_descend"], new_origin );
    level.avogadro maps\mp\zombies\_zm_ai_avogadro::avogadro_teleport( new_origin, new_angles, 1 );
    level.avogadro.state = "idle";
    level thread show_avogadro();
    level.avogadro.hit_by_melee = 0;
    level thread avogadro_electric_field();
    if (level.gamemode_difficulty == "^1Chad^7" || level.gamemode_difficulty == "^6GigaChad^7")
    {
        level.boss_phase = 1;
        level.avogadro_buff = 1;
    }
    for (;;)
    {
        if (isdefined(level.avogadro_buff))
        {
            if (level.avogadro.health <= 1 || level.avogadro.hit_by_melee >= 4)
                break;
            foreach(player in level.players)
            {
                if (player.sessionstate != "spectator" && !(player maps\mp\zombies\_zm_laststand::player_is_in_laststand()))
                {
                   // level.is_custom_bolt = 1;
                    level.avogadro thread shoot_bolt( player );
                    wait 1;
                    //level.is_custom_bolt = 0;
                }
            }
        }
        if (level.boss_phase == 1)
            wait boss_p1_cd - 1;
        else if (level.boss_phase == 2)
            wait boss_p2_cd - 1;
        else if (level.boss_phase == 3)
            wait boss_p3_cd - 1;
        else 
            wait 1;
    }
    wait 5;
    if (level.gamemode_difficulty == "^1Chad^7")
        setDvar("EE_Completion", "TitB_Final_Chad");
    else if (level.gamemode_difficulty == "^6GigaChad^7")
        setDvar("EE_Completion", "TitB_Final_GigaChad");
    else
        setDvar("EE_Completion", "TitB_Final");
    for (i = 0; i < 5; i++)
    {
        self playsound("zmb_cha_ching");
        wait 0.5;
    }
    foreach(player in level.players)
    {
        player thread FinalMsg();
    }
}

show_avogadro()
{
    i = 0;
    level endon ("game_ended");
    for (;;)
    {
        wait 80;
        if (level.avogadro.health <= 1 || level.avogadro.hit_by_melee >= 4)
            break;
        level.avogadro show();
        new_origin = (13773.5, -530.393, -188.875);
        level.avogadro maps\mp\zombies\_zm_ai_avogadro::avogadro_teleport( new_origin, (0, 0, 0), 1 );
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
        setdvar("gamemode_speedrun_quest_titb", ((GetTime() - level.start_time) / 1000 / 60) + ";" + txt);
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

avogadro_electric_field()
{
    level endon ("game_ended");
    max_dist = 170;
    for (;;)
    {
            if (level.avogadro.health <= 1 || level.avogadro.hit_by_melee >= 4)
                break;
        foreach(player in level.players)
        {
            if (player.sessionstate != "spectator" && !(player maps\mp\zombies\_zm_laststand::player_is_in_laststand()))
            {
                if (isdefined (level.boss_phase) && level.boss_phase == 1)
                    max_dist = 170;
                else if (isdefined (level.boss_phase) && level.boss_phase == 2)
                    max_dist = 185;
                else if (isdefined (level.boss_phase) && level.boss_phase == 3)
                    max_dist = 200;
                if (distance(player.origin, level.avogadro.origin) < max_dist)
                {
                    maps\mp\_visionset_mgr::vsmgr_activate( "overlay", "zm_ai_avogadro_electrified", player, 1, 1 );
                    player shellshock( "electrocution", 1 );
                    player playsoundtoplayer( "zmb_avogadro_electrified", player );
                    player dodamage( 30, player.origin );
                }
                else if (distance(player.origin, level.avogadro.origin) < 90)
                {
                    maps\mp\_visionset_mgr::vsmgr_activate( "overlay", "zm_ai_avogadro_electrified", player, 1, 1 );
                    player shellshock( "electrocution", 1 );
                    player playsoundtoplayer( "zmb_avogadro_electrified", player );
                    player dodamage( 100, player.origin );
                }
            }
        }
        wait 0.5;
    }
}

zombie_watcher()
{
    self endon("level_ended");
    zm_spawner1 = (13343, -63, -196);
    zm_spawner2 = (13297, -391, -204);
    zm_spawner3 = (12590, -638, -137);
    zm_spawner4 = (13243, -817, -215);
    for (;;)
    {
        zombies = getaispeciesarray( "axis", "all" );
        foreach ( enemy in zombies )
        {
            enemy set_zombie_run_cycle( "super_sprint" );
            if (!isdefined(enemy.is_avogadro))
            {
                if (distance(enemy.origin, zm_spawner1) < 100 || distance(enemy.origin, zm_spawner2) < 100
                || distance(enemy.origin, zm_spawner3) < 500 || distance(enemy.origin, zm_spawner4) < 100)
                    enemy dodamage( enemy.health + 666, enemy.origin );
            }
            
        }
        wait 2;
    }
}

automatondamagecallback_custom()
{
    self setcandamage( 1 );
    self.health = 100000;
    triggers = getentarray( "bus_door_trigger", "targetname" );

    while ( true )
    {
        self waittill( "damage", amount, attacker, directionvec, point, type );

        self.health = 100000;
        wait 1;

        if ( isdefined( self.disabled_by_emp ) && self.disabled_by_emp || isdefined( self.isspeaking ) && self.isspeaking || isdefined( level.playerattackingautomaton ) && level.playerattackingautomaton )
            continue;

        self say_player_attack_vox();

        if ( level.timesplayerattackingautomaton < 3 )
            continue;

        level.timesplayerattackingautomaton = 0;

        if ( isdefined( attacker ) && isplayer( attacker ) )
        {
            wait 5;

            if ( !isdefined( self.dmgfxorigin ) )
            {
                self.dmgfxorigin = spawn( "script_model", point );
                self.dmgfxorigin setmodel( "tag_origin" );

                if ( isdefined( type ) && type == "MOD_GRENADE_SPLASH" )
                    self.dmgfxorigin.origin = self gettagorigin( "tag_origin" ) + vectorscale( ( 0, 0, 1 ), 40.0 );

                self.dmgfxorigin linkto( self, "J_neck" );
            }

            wait 0.5;
            playfxontag( level._effect["switch_sparks"], self.dmgfxorigin, "tag_origin" );

            foreach ( trigger in triggers )
                trigger setinvisibletoall();

            level.the_bus.force_lock_doors = 1;

            if ( randomint( 100 ) > 50 )
            {

                level thread automatonspeak( "inform", "player_pissed", undefined, 0 );
            }
            else
                level thread automatonspeak( "inform", "player_pissed", undefined, 1 );

            if ( level.the_bus.doorsclosed )
            {
                triggers[0] playsound( "zmb_bus_door_open" );
                level.the_bus maps\mp\zm_transit_bus::busdoorsopen();
                wait 1.25;
                if (getdvar("net_port") != "30011")
                    shove_players_off_bus();
                wait 3;
                triggers[0] playsound( "zmb_bus_door_close" );
                level.the_bus maps\mp\zm_transit_bus::busdoorsclose();
                if (isdefined(level.gamemode_difficulty) && level.gamemode_difficulty == "^6GigaChad^7")
                {
                    foreach(player in level.players)
                        player.difficulty_hud settext(level.gamemode_difficulty + "\nDoors : ^1LOCKED");
                    iprintln("Doors ^1LOCKED^7 for 30 seconds !");
                    iprintln("Doors ^1LOCKED^7 for 30 seconds !");
                    iprintln("Doors ^1LOCKED^7 for 30 seconds !");
                }
            }
            else
            {
                if (getdvar("net_port") != "30011")
                    shove_players_off_bus();
                wait 3;
                triggers[0] playsound( "zmb_bus_door_close" );
                level.the_bus maps\mp\zm_transit_bus::busdoorsclose();
                if (isdefined(level.gamemode_difficulty) && level.gamemode_difficulty == "^6GigaChad^7")
                {
                    foreach(player in level.players)
                        player.difficulty_hud settext(level.gamemode_difficulty + "\nDoors : ^2UNLOCKED");
                    iprintln("Doors ^1LOCKED^7 for 30 seconds !");
                    iprintln("Doors ^1LOCKED^7 for 30 seconds !");
                    iprintln("Doors ^1LOCKED^7 for 30 seconds !");
                }
            }

            wait 3.5;
            level thread automatonspeak( "inform", "player_pissed", undefined, 2 );
            wait 10;
            if (isdefined(level.gamemode_difficulty) && level.gamemode_difficulty == "^6GigaChad^7")
            {
                wait 17;
                foreach(player in level.players)
                    player.difficulty_hud settext(level.gamemode_difficulty + "\nDoors : ^2UNLOCKED");
                iprintln("Doors ^2UNLOCKED");
                iprintln("Doors ^2UNLOCKED");
                iprintln("Doors ^2UNLOCKED");
            }
            foreach ( trigger in triggers )
                trigger setvisibletoall();

            level.the_bus.force_lock_doors = 0;
        }

        if ( isdefined( self.dmgfxorigin ) )
        {
            self.dmgfxorigin unlink();
            self.dmgfxorigin delete();
            self.dmgfxorigin = undefined;
        }
    }
}

zmbvoxgetlinevariant_custom( prefix, alias_suffix, force_variant, override )
{
    return;
}

initializematchstats_custom()
{
    return;
}

generateInvisibleBoxCollision(pos, angles)
{
    flag_wait("initial_blackscreen_passed" );
    generateInvisiblePerk( pos + (0, 0, 0), angles);
    generateInvisiblePerk( pos + (0, -30, 0), angles);
    generateInvisiblePerk( pos + (0, 30, 0), angles);
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

check_for_titb_port()
{
    found = 0;
    foreach(port in level.net_port_titb)
    {
        if (getdvar("net_port") == port)
            found = 1;
    }
    if (found == 0)
        return false;
    return true;
}