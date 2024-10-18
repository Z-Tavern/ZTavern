#include maps\mp\zombies\_zm_magicbox;

#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_magicbox_lock;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zombies\_zm_audio_announcer;
#include maps\mp\zombies\_zm_pers_upgrades_functions;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\_demo;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_perks;

init()
{
    replacefunc(maps\mp\zombies\_zm_perks::perk_give_bottle_begin, ::perk_give_bottle_begin_custom);
    replacefunc(maps\mp\zombies\_zm_magicbox::treasure_chest_weapon_spawn, ::treasure_chest_weapon_spawn_custom);
    replacefunc(maps\mp\zombies\_zm_perks::third_person_weapon_upgrade, ::third_person_weapon_upgrade_custom);
}

perk_give_bottle_begin_custom( perk )
{

    gun = self getcurrentweapon();
    if (isdefined(self.has_timeslip) && self.has_timeslip == 1)
    {
        self thread maps\mp\zombies\_zm_perks::wait_give_perk(perk, 0.1);
        return gun;
    }


    self increment_is_drinking();
    self disable_player_move_states( 1 );

    weapon = "";

    switch ( perk )
    {
        case "specialty_armorvest":
        case " _upgrade":
            weapon = level.machine_assets["juggernog"].weapon;
            break;
        case "specialty_quickrevive_upgrade":
        case "specialty_quickrevive":
            weapon = level.machine_assets["revive"].weapon;
            break;
        case "specialty_fastreload_upgrade":
        case "specialty_fastreload":
            weapon = level.machine_assets["speedcola"].weapon;
            break;
        case "specialty_rof_upgrade":
        case "specialty_rof":
            weapon = level.machine_assets["doubletap"].weapon;
            break;
        case "specialty_longersprint_upgrade":
        case "specialty_longersprint":
            weapon = level.machine_assets["marathon"].weapon;
            break;
        case "specialty_flakjacket_upgrade":
        case "specialty_flakjacket":
            weapon = level.machine_assets["divetonuke"].weapon;
            break;
        case "specialty_deadshot_upgrade":
        case "specialty_deadshot":
            weapon = level.machine_assets["deadshot"].weapon;
            break;
        case "specialty_additionalprimaryweapon_upgrade":
        case "specialty_additionalprimaryweapon":
            weapon = level.machine_assets["additionalprimaryweapon"].weapon;
            break;
        case "specialty_scavenger_upgrade":
        case "specialty_scavenger":
            weapon = level.machine_assets["tombstone"].weapon;
            break;
        case "specialty_finalstand_upgrade":
        case "specialty_finalstand":
            weapon = level.machine_assets["whoswho"].weapon;
            break;
    }

    if ( isdefined( level._custom_perks[perk] ) && isdefined( level._custom_perks[perk].perk_bottle ) )
        weapon = level._custom_perks[perk].perk_bottle;

    self giveweapon( weapon );
    self switchtoweapon( weapon );
    return gun;
}

third_person_weapon_upgrade_custom( current_weapon, upgrade_weapon, packa_rollers, perk_machine, trigger )
{
    level endon( "Pack_A_Punch_off" );
    trigger endon( "pap_player_disconnected" );
    rel_entity = trigger.perk_machine;
    origin_offset = ( 0, 0, 0 );
    angles_offset = ( 0, 0, 0 );
    origin_base = self.origin;
    angles_base = self.angles;

    if ( isdefined( rel_entity ) )
    {
        if ( isdefined( level.pap_interaction_height ) )
            origin_offset = ( 0, 0, level.pap_interaction_height );
        else
            origin_offset = vectorscale( ( 0, 0, 1 ), 35.0 );

        angles_offset = vectorscale( ( 0, 1, 0 ), 90.0 );
        origin_base = rel_entity.origin;
        angles_base = rel_entity.angles;
    }
    else
        rel_entity = self;

    forward = anglestoforward( angles_base + angles_offset );
    interact_offset = origin_offset + forward * -25;

    if ( !isdefined( perk_machine.fx_ent ) )
    {
        perk_machine.fx_ent = spawn( "script_model", origin_base + origin_offset + ( 0, 1, -34 ) );
        perk_machine.fx_ent.angles = angles_base + angles_offset;
        perk_machine.fx_ent setmodel( "tag_origin" );
        perk_machine.fx_ent linkto( perk_machine );
    }

    if ( isdefined( level._effect["packapunch_fx"] ) )
        fx = playfxontag( level._effect["packapunch_fx"], perk_machine.fx_ent, "tag_origin" );

    offsetdw = vectorscale( ( 1, 1, 1 ), 3.0 );
    weoptions = self maps\mp\zombies\_zm_weapons::get_pack_a_punch_weapon_options( current_weapon );
    trigger.worldgun = spawn_weapon_model( current_weapon, undefined, origin_base + interact_offset, self.angles, weoptions );
    worldgundw = undefined;

    if ( maps\mp\zombies\_zm_magicbox::weapon_is_dual_wield( current_weapon ) )
        worldgundw = spawn_weapon_model( current_weapon, maps\mp\zombies\_zm_magicbox::get_left_hand_weapon_model_name( current_weapon ), origin_base + interact_offset + offsetdw, self.angles, weoptions );

    trigger.worldgun.worldgundw = worldgundw;

    if ( isdefined( level.custom_pap_move_in ) )
        perk_machine [[ level.custom_pap_move_in ]]( trigger, origin_offset, angles_offset, perk_machine );
    else
        perk_machine pap_weapon_move_in( trigger, origin_offset, angles_offset );

    self playsound( "zmb_perks_packa_upgrade" );

    if ( isdefined( perk_machine.wait_flag ) )
        perk_machine.wait_flag rotateto( perk_machine.wait_flag.angles + vectorscale( ( 1, 0, 0 ), 179.0 ), 0.25, 0, 0 );

    wait 0.35;
    trigger.worldgun delete();

    if ( isdefined( worldgundw ) )
        worldgundw delete();

    if (!isdefined(self.has_timeslip) || self.has_timeslip == 0) 
        wait 3;

    if ( isdefined( self ) )
        self playsound( "zmb_perks_packa_ready" );
    else
        return;

    upoptions = self maps\mp\zombies\_zm_weapons::get_pack_a_punch_weapon_options( upgrade_weapon );
    trigger.current_weapon = current_weapon;
    trigger.upgrade_name = upgrade_weapon;
    trigger.worldgun = spawn_weapon_model( upgrade_weapon, undefined, origin_base + origin_offset, angles_base + angles_offset + vectorscale( ( 0, 1, 0 ), 90.0 ), upoptions );
    worldgundw = undefined;

    if ( maps\mp\zombies\_zm_magicbox::weapon_is_dual_wield( upgrade_weapon ) )
        worldgundw = spawn_weapon_model( upgrade_weapon, maps\mp\zombies\_zm_magicbox::get_left_hand_weapon_model_name( upgrade_weapon ), origin_base + origin_offset + offsetdw, angles_base + angles_offset + vectorscale( ( 0, 1, 0 ), 90.0 ), upoptions );

    trigger.worldgun.worldgundw = worldgundw;

    if ( isdefined( perk_machine.wait_flag ) )
        perk_machine.wait_flag rotateto( perk_machine.wait_flag.angles - vectorscale( ( 1, 0, 0 ), 179.0 ), 0.25, 0, 0 );

    if ( isdefined( level.custom_pap_move_out ) )
        rel_entity thread [[ level.custom_pap_move_out ]]( trigger, origin_offset, interact_offset );
    else
        rel_entity thread pap_weapon_move_out( trigger, origin_offset, interact_offset );

    return trigger.worldgun;
}

treasure_chest_weapon_spawn_custom( chest, player, respin )
{
    if ( isdefined( level.using_locked_magicbox ) && level.using_locked_magicbox )
    {
        self.owner endon( "box_locked" );
        self thread maps\mp\zombies\_zm_magicbox_lock::clean_up_locked_box();
    }

    self endon( "box_hacked_respin" );
    self thread clean_up_hacked_box();
    assert( isdefined( player ) );
    self.weapon_string = undefined;
    modelname = undefined;
    rand = undefined;
    number_cycles = 40; 
    if (isdefined(player.has_timeslip) && player.has_timeslip == 1)
        number_cycles = 19;
    if ( isdefined( chest.zbarrier ) )
    {
        if ( isdefined( level.custom_magic_box_do_weapon_rise ) )
            chest.zbarrier thread [[ level.custom_magic_box_do_weapon_rise ]]();
        else
            chest.zbarrier thread magic_box_do_weapon_rise();
    }

    for ( i = 0; i < number_cycles; i++ )
    {
        if ( i < 20 )
        {
            wait 0.05;
            continue;
        }

        if ( i < 30 )
        {
            wait 0.1;
            continue;
        }

        if ( i < 35 )
        {
            wait 0.2;
            continue;
        }

        if ( i < 38 )
            wait 0.3;
    }
    if (isdefined(player.has_timeslip) && player.has_timeslip == 1)
        self setzbarrierpiecestate( 3, "open" );
    if ( isdefined( level.custom_magic_box_weapon_wait ) )
        [[ level.custom_magic_box_weapon_wait ]]();

    if ( isdefined( player.pers_upgrades_awarded["box_weapon"] ) && player.pers_upgrades_awarded["box_weapon"] )
        rand = maps\mp\zombies\_zm_pers_upgrades_functions::pers_treasure_chest_choosespecialweapon( player );
    else
        rand = treasure_chest_chooseweightedrandomweapon( player );

    self.weapon_string = rand;
    wait 0.1;

    if ( isdefined( level.custom_magicbox_float_height ) )
        v_float = anglestoup( self.angles ) * level.custom_magicbox_float_height;
    else
        v_float = anglestoup( self.angles ) * 40;

    self.model_dw = undefined;
    self.weapon_model = spawn_weapon_model( rand, undefined, self.origin + v_float, self.angles + vectorscale( ( 0, 1, 0 ), 180.0 ) );

    if ( weapon_is_dual_wield( rand ) )
        self.weapon_model_dw = spawn_weapon_model( rand, get_left_hand_weapon_model_name( rand ), self.weapon_model.origin - vectorscale( ( 1, 1, 1 ), 3.0 ), self.weapon_model.angles );

    if ( getdvar( "magic_chest_movable" ) == "1" && !( isdefined( chest._box_opened_by_fire_sale ) && chest._box_opened_by_fire_sale ) && !( isdefined( level.zombie_vars["zombie_powerup_fire_sale_on"] ) && level.zombie_vars["zombie_powerup_fire_sale_on"] && self [[ level._zombiemode_check_firesale_loc_valid_func ]]() ) )
    {
        random = randomint( 100 );

        if ( !isdefined( level.chest_min_move_usage ) )
            level.chest_min_move_usage = 4;

        if ( level.chest_accessed < level.chest_min_move_usage )
            chance_of_joker = -1;
        else
        {
            chance_of_joker = level.chest_accessed + 20;

            if ( level.chest_moves == 0 && level.chest_accessed >= 8 )
                chance_of_joker = 100;

            if ( level.chest_accessed >= 4 && level.chest_accessed < 8 )
            {
                if ( random < 15 )
                    chance_of_joker = 100;
                else
                    chance_of_joker = -1;
            }

            if ( level.chest_moves > 0 )
            {
                if ( level.chest_accessed >= 8 && level.chest_accessed < 13 )
                {
                    if ( random < 30 )
                        chance_of_joker = 100;
                    else
                        chance_of_joker = -1;
                }

                if ( level.chest_accessed >= 13 )
                {
                    if ( random < 50 )
                        chance_of_joker = 100;
                    else
                        chance_of_joker = -1;
                }
            }
        }

        if ( isdefined( chest.no_fly_away ) )
            chance_of_joker = -1;

        if ( isdefined( level._zombiemode_chest_joker_chance_override_func ) )
            chance_of_joker = [[ level._zombiemode_chest_joker_chance_override_func ]]( chance_of_joker );

        if ( chance_of_joker > random )
        {
            self.weapon_string = undefined;
            self.weapon_model setmodel( level.chest_joker_model );
            self.weapon_model.angles = self.angles + vectorscale( ( 0, 1, 0 ), 90.0 );

            if ( isdefined( self.weapon_model_dw ) )
            {
                self.weapon_model_dw delete();
                self.weapon_model_dw = undefined;
            }

            self.chest_moving = 1;
            flag_set( "moving_chest_now" );
            level.chest_accessed = 0;
            level.chest_moves++;
        }
    }

    self notify( "randomization_done" );

    if ( flag( "moving_chest_now" ) && !( level.zombie_vars["zombie_powerup_fire_sale_on"] && self [[ level._zombiemode_check_firesale_loc_valid_func ]]() ) )
    {
        if ( isdefined( level.chest_joker_custom_movement ) )
            self [[ level.chest_joker_custom_movement ]]();
        else
        {
            wait 0.5;
            level notify( "weapon_fly_away_start" );
            wait 2;

            if ( isdefined( self.weapon_model ) )
            {
                v_fly_away = self.origin + anglestoup( self.angles ) * 500;
                self.weapon_model moveto( v_fly_away, 4, 3 );
            }

            if ( isdefined( self.weapon_model_dw ) )
            {
                v_fly_away = self.origin + anglestoup( self.angles ) * 500;
                self.weapon_model_dw moveto( v_fly_away, 4, 3 );
            }

            self.weapon_model waittill( "movedone" );

            self.weapon_model delete();

            if ( isdefined( self.weapon_model_dw ) )
            {
                self.weapon_model_dw delete();
                self.weapon_model_dw = undefined;
            }

            self notify( "box_moving" );
            level notify( "weapon_fly_away_end" );
        }
    }
    else
    {
        acquire_weapon_toggle( rand, player );

        if ( rand == "tesla_gun_zm" || rand == "ray_gun_zm" )
        {
            if ( rand == "ray_gun_zm" )
                level.pulls_since_last_ray_gun = 0;

            if ( rand == "tesla_gun_zm" )
            {
                level.pulls_since_last_tesla_gun = 0;
                level.player_seen_tesla_gun = 1;
            }
        }

        if ( !isdefined( respin ) )
        {
            if ( isdefined( chest.box_hacks["respin"] ) )
                self [[ chest.box_hacks["respin"] ]]( chest, player );
        }
        else if ( isdefined( chest.box_hacks["respin_respin"] ) )
            self [[ chest.box_hacks["respin_respin"] ]]( chest, player );

        if ( isdefined( level.custom_magic_box_timer_til_despawn ) )
            self.weapon_model thread [[ level.custom_magic_box_timer_til_despawn ]]( self );
        else
            self.weapon_model thread timer_til_despawn( v_float );

        if ( isdefined( self.weapon_model_dw ) )
        {
            if ( isdefined( level.custom_magic_box_timer_til_despawn ) )
                self.weapon_model_dw thread [[ level.custom_magic_box_timer_til_despawn ]]( self );
            else
                self.weapon_model_dw thread timer_til_despawn( v_float );
        }

        self waittill( "weapon_grabbed" );

        if ( !chest.timedout )
        {
            if ( isdefined( self.weapon_model ) )
                self.weapon_model delete();

            if ( isdefined( self.weapon_model_dw ) )
                self.weapon_model_dw delete();
        }
    }

    self.weapon_string = undefined;
    self notify( "box_spin_done" );
}