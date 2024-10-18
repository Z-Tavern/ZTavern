#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\gametypes_zm\_spawnlogic;
#include maps\mp\animscripts\traverse\shared;
#include maps\mp\animscripts\utility;
#include maps\mp\zombies\_load;
#include maps\mp\_createfx;
#include maps\mp\_music;
#include maps\mp\_busing;
#include maps\mp\_script_gen;
#include maps\mp\gametypes_zm\_globallogic_audio;
#include maps\mp\gametypes_zm\_tweakables;
#include maps\mp\_challenges;
#include maps\mp\gametypes_zm\_weapons;
#include maps\mp\_demo;
#include maps\mp\gametypes_zm\_hud_message;
#include maps\mp\gametypes_zm\_spawning;
#include maps\mp\gametypes_zm\_globallogic_utils;
#include maps\mp\gametypes_zm\_spectating;
#include maps\mp\gametypes_zm\_globallogic_spawn;
#include maps\mp\gametypes_zm\_globallogic_ui;
#include maps\mp\gametypes_zm\_hostmigration;
#include maps\mp\gametypes_zm\_globallogic_score;
#include maps\mp\gametypes_zm\_globallogic;
#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_zm_ai_faller;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\zombies\_zm_pers_upgrades_functions;
#include maps\mp\zombies\_zm_pers_upgrades;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\animscripts\zm_run;
#include maps\mp\animscripts\zm_death;
#include maps\mp\zombies\_zm_blockers;
#include maps\mp\animscripts\zm_shared;
#include maps\mp\animscripts\zm_utility;
#include maps\mp\zombies\_zm_ai_basic;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\zombies\_zm_net;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\gametypes_zm\_zm_gametype;
#include maps\mp\_visionset_mgr;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\zombies\_zm_power;
#include maps\mp\zombies\_zm_server_throttle;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\zombies\_zm_perks;
#include maps\mp\zombies\_zm_melee_weapon;
#include maps\mp\zombies\_zm_audio_announcer;
#include maps\mp\zombies\_zm_magicbox;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_ai_dogs;
#include maps\mp\zombies\_zm_game_module;
#include maps\mp\zombies\_zm_buildables;
#include codescripts\character;
#include maps\mp\zombies\_zm_weap_riotshield;
#include maps\mp\zombies\_zm_weap_riotshield_tomb;
#include maps\mp\zombies\_zm_weap_riotshield_prison;
#include maps\mp\zm_transit_bus;
#include maps\mp\zm_transit_utility;
#include maps\mp\zombies\_zm_equip_turret;
#include maps\mp\zombies\_zm_mgturret;
#include maps\mp\zombies\_zm_weap_jetgun;

#include maps\mp\zombies\_zm_ai_sloth;
#include maps\mp\zombies\_zm_ai_sloth_ffotd;
#include maps\mp\zombies\_zm_ai_sloth_utility;
#include maps\mp\zombies\_zm_ai_sloth_magicbox;
#include maps\mp\zombies\_zm_ai_sloth_crawler;
#include maps\mp\zombies\_zm_ai_sloth_buildables;

#include maps\mp\zombies\_zm_tombstone;
#include maps\mp\zombies\_zm_chugabud;

#include maps\mp\zm_nuked_perks;

#include maps\mp\zm_tomb_utility;
#include maps\mp\zm_tomb_gamemodes;
#include maps\mp\zm_tomb_fx;
#include maps\mp\zm_tomb_ffotd;
#include maps\mp\zm_tomb_tank;
#include maps\mp\zm_tomb_quest_fire;
#include maps\mp\zm_tomb_capture_zones;
#include maps\mp\zm_tomb_teleporter;
#include maps\mp\zm_tomb_giant_robot;
#include maps\mp\zm_tomb_amb;
#include maps\mp\zombies\_zm_ai_mechz;
#include maps\mp\zombies\_zm_ai_quadrotor;
#include maps\mp\zm_tomb_vo;
#include maps\mp\zombies\_zm_perk_divetonuke;
#include maps\mp\zombies\_zm_perk_electric_cherry;
#include maps\mp\zombies\_zm_weap_one_inch_punch;
#include maps\mp\zombies\_zm_weap_staff_fire;
#include maps\mp\zombies\_zm_weap_staff_water;
#include maps\mp\zombies\_zm_weap_staff_lightning;
#include maps\mp\zombies\_zm_weap_staff_air;
#include maps\mp\zm_tomb;
#include maps\mp\zm_tomb_achievement;
#include maps\mp\zm_tomb_distance_tracking;
#include maps\mp\zombies\_zm_magicbox_tomb;
#include maps\mp\zm_tomb_challenges;
#include maps\mp\zombies\_zm_perk_random;
#include maps\mp\_sticky_grenade;
#include maps\mp\zombies\_zm_weap_beacon;
#include maps\mp\zombies\_zm_weap_claymore;
#include maps\mp\zombies\_zm_weap_staff_revive;
#include maps\mp\zombies\_zm_weap_cymbal_monkey;
#include maps\mp\zm_tomb_ambient_scripts;
#include maps\mp\zm_tomb_dig;
#include maps\mp\zm_tomb_main_quest;
#include maps\mp\zm_tomb_ee_main;
#include maps\mp\zm_tomb_ee_side;
#include maps\mp\zm_tomb_chamber;
#include character\c_usa_dempsey_dlc4;
#include character\c_rus_nikolai_dlc4;
#include character\c_ger_richtofen_dlc4;
#include character\c_jap_takeo_dlc4;
#include maps\mp\zombies\_zm_powerup_zombie_blood;
#include maps\mp\zombies\_zm_devgui;
#include maps\mp\zombies\_zm_challenges;
#include scripts\AATs_Perks;
#include maps\mp\zm_prison_sq_final;
#include maps\mp\zm_alcatraz_sq_vo;
#include maps\mp\zm_alcatraz_sq_nixie;
#include maps\mp\zombies\_zm_ai_brutus;
#include maps\mp\animscripts\shared;
#include maps\mp\zombies\_zm_clone;
#include maps\mp\zombies\_zm_craftables;
#include maps\mp\zm_alcatraz_utility;
#include maps\mp\zm_alcatraz_weap_quest;
#include maps\mp\zombies\_zm_afterlife;

#include maps\mp\zm_alcatraz_travel;

main()
{
    replaceFunc(maps\mp\zm_alcatraz_sq::track_quest_status_thread, ::track_quest_status_thread_custom);
    replaceFunc(maps\mp\zm_alcatraz_utility::disable_powerup_if_player_on_bridge, ::disable_powerup_if_player_on_bridge_custom);
    replaceFunc(maps\mp\zm_alcatraz_utility::enable_powerup_if_no_player_on_bridge, ::enable_powerup_if_no_player_on_bridge_custom); 
    replaceFunc(maps\mp\zombies\_zm_afterlife::afterlife_fake_death, ::afterlife_fake_death_custom);
    replaceFunc(maps\mp\zm_alcatraz_utility::wait_for_player_to_take, ::wait_for_player_to_take_custom);
    replaceFunc(maps\mp\zm_alcatraz_craftables::include_craftables, ::include_craftables_custom);
    maps\mp\zombies\_zm::register_player_damage_callback( ::playerDamageLastCheckMOTD );
}
init()
{
    
    level.is_forever_solo_game = 1;
    level thread onPlayerConnect();
}

include_craftables_custom()
{
    level.zombie_include_craftables["open_table"].custom_craftablestub_update_prompt = ::prison_open_craftablestub_update_prompt;
    craftable_name = "alcatraz_shield_zm";
    riotshield_dolly = generate_zombie_craftable_piece( craftable_name, "dolly", "t6_wpn_zmb_shield_dlc2_dolly", 32, 64, 0, undefined, ::onpickup_common, ::ondrop_common, undefined, undefined, undefined, undefined, "piece_riotshield_dolly", 1, "build_zs" );
    riotshield_door = generate_zombie_craftable_piece( craftable_name, "door", "t6_wpn_zmb_shield_dlc2_door", 48, 15, 25, undefined, ::onpickup_common, ::ondrop_common, undefined, undefined, undefined, undefined, "piece_riotshield_door", 1, "build_zs" );
    riotshield_clamp = generate_zombie_craftable_piece( craftable_name, "clamp", "t6_wpn_zmb_shield_dlc2_shackles", 32, 15, 0, undefined, ::onpickup_common, ::ondrop_common, undefined, undefined, undefined, undefined, "piece_riotshield_clamp", 1, "build_zs" );
    riotshield = spawnstruct();
    riotshield.name = craftable_name;
    riotshield add_craftable_piece( riotshield_dolly );
    riotshield add_craftable_piece( riotshield_door );
    riotshield add_craftable_piece( riotshield_clamp );
    riotshield.onbuyweapon = maps\mp\zm_alcatraz_craftables::onbuyweapon_riotshield;
    riotshield.triggerthink = maps\mp\zm_alcatraz_craftables::riotshieldcraftable;
    maps\mp\zm_alcatraz_utility::include_craftable( riotshield );
    craftable_name = "packasplat";
    packasplat_case = generate_zombie_craftable_piece( craftable_name, "case", "p6_zm_al_packasplat_suitcase", 48, 36, 0, undefined, ::onpickup_common, ::ondrop_common, undefined, undefined, undefined, undefined, "piece_packasplat_case", 1, "build_bsm" );
    packasplat_fuse = generate_zombie_craftable_piece( craftable_name, "fuse", "p6_zm_al_packasplat_engine", 32, 36, 0, undefined, ::onpickup_common, ::ondrop_common, undefined, undefined, undefined, undefined, "piece_packasplat_fuse", 1, "build_bsm" );
    packasplat_blood = generate_zombie_craftable_piece( craftable_name, "blood", "p6_zm_al_packasplat_iv", 32, 15, 0, undefined, ::onpickup_common, ::ondrop_common, undefined, undefined, undefined, undefined, "piece_packasplat_blood", 1, "build_bsm" );
    packasplat = spawnstruct();
    packasplat.name = craftable_name;
    packasplat add_craftable_piece( packasplat_case );
    packasplat add_craftable_piece( packasplat_fuse );
    packasplat add_craftable_piece( packasplat_blood );
    packasplat.triggerthink = maps\mp\zm_alcatraz_craftables::packasplatcraftable;
    maps\mp\zm_alcatraz_utility::include_craftable( packasplat );
    maps\mp\zm_alcatraz_craftables::include_key_craftable( "quest_key1", "p6_zm_al_key" );
    craftable_name = "plane";
    plane_cloth = generate_zombie_craftable_piece( craftable_name, "cloth", "p6_zm_al_clothes_pile_lrg", 48, 15, 0, undefined, ::onpickup_plane, ::ondrop_plane, ::oncrafted_plane, undefined, "tag_origin", undefined, 1 );
    plane_fueltanks = generate_zombie_craftable_piece( craftable_name, "fueltanks", "veh_t6_dlc_zombie_part_fuel", 32, 15, 0, undefined, ::onpickup_plane, ::ondrop_plane, ::oncrafted_plane, undefined, "tag_feul_tanks", undefined, 2 );
    plane_engine = generate_zombie_craftable_piece( craftable_name, "engine", "veh_t6_dlc_zombie_part_engine", 32, 62, 0, undefined, ::onpickup_plane, ::ondrop_plane, ::oncrafted_plane, undefined, "tag_origin", undefined, 3 );
    plane_steering = generate_zombie_craftable_piece( craftable_name, "steering", "veh_t6_dlc_zombie_part_control", 32, 15, 0, undefined, ::onpickup_plane, ::ondrop_plane, ::oncrafted_plane, undefined, "tag_control_mechanism", undefined, 4 );
    plane_rigging = generate_zombie_craftable_piece( craftable_name, "rigging", "veh_t6_dlc_zombie_part_rigging", 32, 15, 0, undefined, ::onpickup_plane, ::ondrop_plane, ::oncrafted_plane, undefined, "tag_origin", undefined, 5 );

  //  if ( level.is_forever_solo_game )
   // {
        plane_cloth.is_shared = 1;
        plane_fueltanks.is_shared = 1;
        plane_engine.is_shared = 1;
        plane_steering.is_shared = 1;
        plane_rigging.is_shared = 1;
        plane_cloth.client_field_state = undefined;
        plane_fueltanks.client_field_state = undefined;
        plane_engine.client_field_state = undefined;
        plane_steering.client_field_state = undefined;
        plane_rigging.client_field_state = undefined;
   // }

    plane_cloth.pickup_alias = "sidequest_sheets";
    plane_fueltanks.pickup_alias = "sidequest_oxygen";
    plane_engine.pickup_alias = "sidequest_engine";
    plane_steering.pickup_alias = "sidequest_valves";
    plane_rigging.pickup_alias = "sidequest_rigging";
    plane = spawnstruct();
    plane.name = craftable_name;
    plane add_craftable_piece( plane_cloth );
    plane add_craftable_piece( plane_engine );
    plane add_craftable_piece( plane_fueltanks );
    plane add_craftable_piece( plane_steering );
    plane add_craftable_piece( plane_rigging );
    plane.triggerthink = maps\mp\zm_alcatraz_craftables::planecraftable;
    plane.custom_craftablestub_update_prompt = maps\mp\zm_alcatraz_craftables::prison_plane_update_prompt;
    maps\mp\zm_alcatraz_utility::include_craftable( plane );
    craftable_name = "refuelable_plane";
    refuelable_plane_gas1 = generate_zombie_craftable_piece( craftable_name, "fuel1", "accessories_gas_canister_1", 32, 15, 0, undefined, ::onpickup_fuel, ::ondrop_fuel, ::oncrafted_fuel, undefined, undefined, undefined, 6 );
    refuelable_plane_gas2 = generate_zombie_craftable_piece( craftable_name, "fuel2", "accessories_gas_canister_1", 32, 15, 0, undefined, ::onpickup_fuel, ::ondrop_fuel, ::oncrafted_fuel, undefined, undefined, undefined, 7 );
    refuelable_plane_gas3 = generate_zombie_craftable_piece( craftable_name, "fuel3", "accessories_gas_canister_1", 32, 15, 0, undefined, ::onpickup_fuel, ::ondrop_fuel, ::oncrafted_fuel, undefined, undefined, undefined, 8 );
    refuelable_plane_gas4 = generate_zombie_craftable_piece( craftable_name, "fuel4", "accessories_gas_canister_1", 32, 15, 0, undefined, ::onpickup_fuel, ::ondrop_fuel, ::oncrafted_fuel, undefined, undefined, undefined, 9 );
    refuelable_plane_gas5 = generate_zombie_craftable_piece( craftable_name, "fuel5", "accessories_gas_canister_1", 32, 15, 0, undefined, ::onpickup_fuel, ::ondrop_fuel, ::oncrafted_fuel, undefined, undefined, undefined, 10 );

//    if ( level.is_forever_solo_game )
 //   {
        refuelable_plane_gas1.is_shared = 1;
        refuelable_plane_gas2.is_shared = 1;
        refuelable_plane_gas3.is_shared = 1;
        refuelable_plane_gas4.is_shared = 1;
        refuelable_plane_gas5.is_shared = 1;
        refuelable_plane_gas1.client_field_state = undefined;
        refuelable_plane_gas2.client_field_state = undefined;
        refuelable_plane_gas3.client_field_state = undefined;
        refuelable_plane_gas4.client_field_state = undefined;
        refuelable_plane_gas5.client_field_state = undefined;
 //   }

    refuelable_plane = spawnstruct();
    refuelable_plane.name = craftable_name;
    refuelable_plane add_craftable_piece( refuelable_plane_gas1 );
    refuelable_plane add_craftable_piece( refuelable_plane_gas2 );
    refuelable_plane add_craftable_piece( refuelable_plane_gas3 );
    refuelable_plane add_craftable_piece( refuelable_plane_gas4 );
    refuelable_plane add_craftable_piece( refuelable_plane_gas5 );
    refuelable_plane.triggerthink = maps\mp\zm_alcatraz_craftables::planefuelable;
    plane.custom_craftablestub_update_prompt = maps\mp\zm_alcatraz_craftables::prison_plane_update_prompt;
    maps\mp\zm_alcatraz_utility::include_craftable( refuelable_plane );
}

checkPlayerAfterlife()
{
    self endon("game_ended");
    self endon ("disconnect");
    for (;;)
    {
        if(!self.afterlife)
        {
            self iprintln("Adding you ^2$1M^7 in ^19 seconds, use ^2.d all^7"); 
            wait 1;
            self iprintln("Adding you ^2$1M^7 in ^18 seconds, use ^2.d all^7"); 
            wait 1;
            self iprintln("Adding you ^2$1M^7 in ^17 seconds, use ^2.d all^7"); 
            wait 1;
            self iprintln("Adding you ^2$1M^7 in ^16 seconds, use ^2.d all^7"); 
            wait 1;
            self iprintln("Adding you ^2$1M^7 in ^15 seconds, use ^2.d all^7"); 
            wait 1;
            self iprintln("Adding you ^2$1M^7 in ^14 seconds, use ^2.d all^7"); 
            wait 1;
            self iprintln("Adding you ^2$1M^7 in ^13 seconds, use ^2.d all^7"); 
            wait 1;
            self iprintln("Adding you ^2$1M^7 in ^12 seconds, use ^2.d all^7"); 
            wait 1;
            self iprintln("Adding you ^2$1M^7 in ^11 second, use ^2.d all^7"); 
            wait 1;     
            self.score += 1000000;
            wait 3;
            self iprintln("Congratulations! Make sure to use ^2.d all^7");
            self iprintln("Congratulations! Make sure to use ^2.d all^7");
            self iprintln("Congratulations! Make sure to use ^2.d all^7");
            return;
        }
        wait 0.5;
    }
}
onPlayerConnect()
{
	while( 1 )
	{
		level waittill( "connected", player );
		player thread onPlayerSpawned();
	}
}

onPlayerSpawned()
{
	self endon( "disconnect" );
	level endon( "game_ended" );
	self waittill( "spawned_player" );
    self.shouldkeepperk = 1;
 /*   lock = 0;
    bridge = (-1205.55, -3389.17, -8447.88);
    spawn = (1963, 10493, 1343.38);
    wait 10;
    for (;;)
    {

        if (self is_jumping() && lock == 0)
        {

            self setOrigin(bridge);
            lock = 1;
            wait 3;
        }
        if (self is_jumping() && lock == 1)
        {
            self setOrigin(spawn);
            lock = 0;
            wait 3;
        }       
        wait 0.1;
    }*/
}

wait_for_player_to_take_custom( player, str_valid_weapon )
{
    self endon( "acid_timeout" );
    player endon( "disconnect" );

    while ( true )
    {
        self waittill( "trigger", trigger_player );

        if ( isdefined( level.custom_craftable_validation ) )
        {
            valid = self [[ level.custom_craftable_validation ]]( player );

            if ( !valid )
                continue;
        }

        if ( trigger_player == player )
        {
            current_weapon = player getcurrentweapon();

            if ( is_player_valid( player ) && !( player.is_drinking > 0 ) && !is_placeable_mine( current_weapon ) && !is_equipment( current_weapon ) && level.revive_tool != current_weapon && "none" != current_weapon && !player hacker_active() )
            {
                self notify( "acid_taken" );
                player notify( "acid_taken" );

                weapon_limit = 2;
                if (player scripts\AATs_Perks::hascustomperk("MULE"))
                    weapon_limit = 3;
                primaries = player getweaponslistprimaries();

                if ( isdefined( primaries ) && primaries.size >= weapon_limit )
                    player takeweapon( current_weapon );

                str_new_weapon = undefined;

                if ( str_valid_weapon == "blundergat_zm" )
                    str_new_weapon = "blundersplat_zm";
                else
                    str_new_weapon = "blundersplat_upgraded_zm";

                if ( player hasweapon( "blundersplat_zm" ) )
                    player givemaxammo( "blundersplat_zm" );
                else if ( player hasweapon( "blundersplat_upgraded_zm" ) )
                    player givemaxammo( "blundersplat_upgraded_zm" );
                else
                {
                    player giveweapon( str_new_weapon );
                    player switchtoweapon( str_new_weapon );
                }

                player thread do_player_general_vox( "general", "player_recieves_blundersplat" );
                player notify( "player_obtained_acidgat" );
                player thread maps\mp\zm_alcatraz_utility::player_lost_blundersplat_watcher();
                return;
            }
        }
    }
}

afterlife_fake_death_custom()
{
    level notify( "fake_death" );
    self notify( "fake_death" );

    self.savedaat = self.aat;
    if (self scripts\AATs_Perks::hascustomperk("MULE"))
    {
        weapons = self GetWeaponsListPrimaries();
        if (weapons && weapons[2])
        self.muleweap = weapons[2];
        self.muleweapstockcount = self getweaponammostock( weapons[2] );
        self.muleweapclipcount = self getweaponammoclip( weapons[2] );
    }
    self thread giveAATback();
    self takeallweapons();
    self allowstand( 0 );
    self allowcrouch( 0 );
    self allowprone( 1 );
    self setstance( "prone" );

    if ( self is_jumping() )
    {
        while ( self is_jumping() )
            wait 0.05;
    }
    playfx( level._effect["afterlife_enter"], self.origin );
    self.ignoreme = 1;
    self enableinvulnerability();
    self freezecontrols( 1 );
}

disable_powerup_if_player_on_bridge_custom()
{
    self endon( "disconnect" );
    return;
  /*  flag_wait( "afterlife_start_over" );

    while ( true )
    {
        if ( self maps\mp\zombies\_zm_zonemgr::is_player_in_zone( "zone_golden_gate_bridge" ) )
        {
            if ( flag( "zombie_drop_powerups" ) )
                flag_clear( "zombie_drop_powerups" );
        }

        wait 1;
    }*/
}

enable_powerup_if_no_player_on_bridge_custom()
{
 //   flag_wait( "afterlife_start_over" );

    while ( true )
    {
     //   n_player_total = 0;
     //   n_player_total += get_players_in_zone( "zone_golden_gate_bridge" );

    //    if ( n_player_total == 0 && !flag( "zombie_drop_powerups" ) )
            flag_set( "zombie_drop_powerups" );

        wait 1;
    }
}

track_quest_status_thread_custom()
{
    while ( true )
    {

      /*  while ( level.characters_in_nml.size == 0 )
            wait 1;

        while ( level.characters_in_nml.size > 0 )
            wait 1;*/
            flag_wait("plane_crashed");
            wait 26;
      //  if ( flag( "plane_trip_to_nml_successful" ) )
      //  {
            maps\mp\zm_alcatraz_sq::bestow_quest_rewards();
            flag_clear( "plane_trip_to_nml_successful" );
     //   }

        level notify( "bridge_empty" );

    //    level waittill( "start_of_round" );

       if ( level.n_quest_iteration_count == 2 )
            maps\mp\zm_alcatraz_sq_vo::vo_play_four_part_conversation( level.four_part_convos["alcatraz_return_alt" + randomintrange( 0, 2 )] );

        maps\mp\zm_alcatraz_sq::prep_for_new_quest();
        maps\mp\zombies\_zm_craftables::waittill_crafted( "refuelable_plane" );
        maps\mp\zombies\_zm_ai_brutus::transfer_plane_trigger( "fuel", "fly" );
        t_plane_fly = getent( "plane_fly_trigger", "targetname" );
        t_plane_fly trigger_on();
    }
}

playerDamageLastCheckMOTD(einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime)
{
	players = get_players();
	for(i=0;i<players.size;i++)
	{
		if( isdefined(players[i].gluster_grenade) && eattacker == players[i].gluster_grenade )
			return 0;
		
		if( isdefined(players[i].firework_weapon) && eattacker == players[i].firework_weapon )
			return 0;
	}
//-------------------CUSTOMPERK------------------------
    if( isDefined( eAttacker.is_zombie ) && eAttacker.is_zombie && self  scripts\AATs_Perks::hascustomperk("WIDOWS_WINE") )
	{
		zombies = getaiarray(level.zombie_team);
        foreach(zombie in zombies)
    	{
	   		if(distance(self.origin, zombie.origin) < 150)
        	{
				grenades = self get_player_lethal_grenade();
            	grenade_count = self getweaponammoclip(grenades);
            	if(grenade_count > 0)
				{
					self PlaySound("zmb_elec_jib_zombie");
                	self setweaponammoclip(grenades, (grenade_count - 1));
					zombie thread  scripts\AATs_Perks::ww_points( self );
				}
            }
		}
    }
	if(self scripts\AATs_Perks::hascustomperk("PHD_FLOPPER"))
	{
        if( smeansofdeath == "MOD_FALLING" )
		{
            if(isDefined( self.divetoprone ) && self.divetoprone == 1 )
			{
                radiusdamage( self.origin, 300, 5000, 1000, self, "MOD_GRENADE_SPLASH" );
                playfx(loadfx("explosions/fx_default_explosion"), self.origin, anglestoforward( ( 0, 45, 55  ) ) );
                self playsound( "zmb_phdflop_explo" );
            }
            return 0;
        }
        if( smeansofdeath == "MOD_PROJECTILE" || smeansofdeath == "MOD_PROJECTILE_SPLASH" || smeansofdeath == "MOD_GRENADE" || smeansofdeath == "MOD_GRENADE_SPLASH" && eattacker == self)
		{
            return 0;
        }
    }
	if(idamage > self.health && !self.dying_wish_on_cooldown && self  scripts\AATs_Perks::hascustomperk("Dying_Wish") )
	{
			self notify("dying_wish_charge");
			self thread scripts\AATs_Perks::dying_wish_effect();
			return 0;
	}



    if ( isdefined( eattacker ) )
    {
        if ( isdefined( eattacker.is_zombie ) && eattacker.is_zombie )
        {
            if ( isdefined( eattacker.custom_damage_func ) )
                idamage = eattacker [[ eattacker.custom_damage_func ]]( self );
            else if ( isdefined( eattacker.meleedamage ) && smeansofdeath != "MOD_GRENADE_SPLASH" )
                idamage = eattacker.meleedamage;

            if ( isdefined( self.afterlife ) && self.afterlife )
            {
                self maps\mp\zombies\_zm_afterlife::afterlife_reduce_mana( 10 );
                self clientnotify( "al_d" );
                return 0;
            }
        }
    }

    if ( isdefined( self.afterlife ) && self.afterlife )
        return 0;

    if ( isdefined( eattacker ) && ( isdefined( eattacker.is_zombie ) && eattacker.is_zombie || isplayer( eattacker ) ) )
    {
        if ( isdefined( self.hasriotshield ) && self.hasriotshield && isdefined( vdir ) )
        {
            item_dmg = 100;

            if ( isdefined( eattacker.custom_item_dmg ) )
                item_dmg = eattacker.custom_item_dmg;

            if ( isdefined( self.hasriotshieldequipped ) && self.hasriotshieldequipped )
            {
                if ( self player_shield_facing_attacker( vdir, 0.2 ) && isdefined( self.player_shield_apply_damage ) )
                {
                    self [[ self.player_shield_apply_damage ]]( item_dmg, 0 );
                    return 0;
                }
            }
            else if ( !isdefined( self.riotshieldentity ) )
            {
                if ( !self player_shield_facing_attacker( vdir, -0.2 ) && isdefined( self.player_shield_apply_damage ) )
                {
                    self [[ self.player_shield_apply_damage ]]( item_dmg, 0 );
                    return 0;
                }
            }
        }
    }

    if ( sweapon == "tower_trap_zm" || sweapon == "tower_trap_upgraded_zm" || sweapon == "none" && shitloc == "riotshield" && !( isdefined( eattacker.is_zombie ) && eattacker.is_zombie ) )
    {
        self.use_adjusted_grenade_damage = 1;
        return 0;
    }

    if ( smeansofdeath == "MOD_PROJECTILE" || smeansofdeath == "MOD_PROJECTILE_SPLASH" || smeansofdeath == "MOD_GRENADE" || smeansofdeath == "MOD_GRENADE_SPLASH" )
    {
        if ( sweapon == "blundersplat_explosive_dart_zm" )
        {
            if ( self hasperk( "specialty_flakjacket" ) )
            {
                self.use_adjusted_grenade_damage = 1;
                idamage = 0;
            }

            if ( isalive( self ) && !( isdefined( self.is_zombie ) && self.is_zombie ) )
            {
                self.use_adjusted_grenade_damage = 1;
                idamage = 10;
            }
        }
        else
        {
            if ( self hasperk( "specialty_flakjacket" ) )
                return 0;

            if ( self.health > 75 && !( isdefined( self.is_zombie ) && self.is_zombie ) )
                idamage = 75;
        }
    }

    if ( idamage >= self.health && ( isdefined( level.intermission ) && !level.intermission ) )
    {
        self.savedaat = self.aat;
        self thread giveAATback();
        self.shouldkeepperk = 0;
        if ( self.lives > 0 && ( isdefined( self.afterlife ) && !self.afterlife ) )
        {
            self playsoundtoplayer( "zmb_afterlife_death", self );
            self maps\mp\zombies\_zm_afterlife::afterlife_remove();
            self.afterlife = 1;
            self thread maps\mp\zombies\_zm_afterlife::afterlife_laststand();

            if ( self.health <= 1 )
                return 0;
            else
                idamage = self.health - 1;
        }
        else
            self thread last_stand_conscience_vo();
    }
    return idamage;
}

giveAATback()
{
    wait 2;
    for (;;)
    {
        if (!self.afterlife)
        {
         /*   if (self scripts\AATs_Perks::hascustomperk("MULE"))
            {
                if (self.muleweap)
                {
                    weapon = self.muleweap;
                    self giveweapon( weapon, 2, self maps\mp\zombies\_zm_weapons::get_pack_a_punch_weapon_options( weapon ) );
                    self setweaponammostock( weapon, self.muleweapstockcount );
                    self setweaponammoclip( weapon, self.muleweapclipcount );    
                }           
            }*/
            self.aat = self.savedaat;
            weapon = self getCurrentWeapon();
            name = self.aat[weapon];
            self scripts\AATs_Perks::aat_hud(name);
            return;
        }
        wait 0.5;
    }
}