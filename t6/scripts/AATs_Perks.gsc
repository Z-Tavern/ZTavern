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
main()
{	
	replaceFunc( maps\mp\animscripts\zm_utility::wait_network_frame, ::wait_network_frame_override );
	replaceFunc( maps\mp\zombies\_zm_utility::wait_network_frame, ::wait_network_frame_override );
//	replaceFunc( maps\mp\zombies\_zm_afterlife::afterlife_give_loadout, ::afterlife_giveback);
//	if(getdvar("mapname") != "zm_prison") //[ Hotfix ] disabled in motd because afterlife doesnt work with it 
//		register_player_damage_callback( ::player_aat_damage_respond ); //moved to main from init because of it not loading in origins

	maps\mp\zombies\_zm_spawner::register_zombie_damage_callback( ::aat_zombie_damage_response );

}

init()
{
	if (level.script != "zm_prison")
	{
		maps\mp\zombies\_zm::register_player_damage_callback( ::playerdamagelastcheck );
	}


		setDvar("isPanzer", "");
		setDvar("isBus", "");
	    precacheshader("menu_mp_lobby_icon_film");
	    precacheshader( "menu_mp_lobby_icon_customgamemode" );
	    precacheshader( "waypoint_revive" );
		
		precacheshader("specialty_quickrevive_zombies_pro");
precacheshader( "specialty_marathon_zombies" );
		precacheshader("specialty_instakill_zombies");
	
			precacheshader( "zom_icon_player_life" );  
	    precacheshader( "killiconheadshot" );
	    precacheshader( "menu_lobby_icon_twitter" );
	    precacheshader( "hud_grenadeicon" ); 
	    precacheshader( "menu_mp_weapons_1911" );
	    precacheshader( "menu_mp_lobby_icon_screenshot" );
	    precacheshader( "damage_feedback" ); 
        precacheshader( "zombies_rank_1" );
	    precacheshader( "zombies_rank_3" );
	    precacheshader( "zombies_rank_2" );
	    precacheshader( "zombies_rank_4" );
	    precacheshader( "menu_mp_weapons_xm8" );
        precacheshader( "faction_cdc" ); 
	    precacheshader( "menu_mp_weapons_hamr" ); 
	    precacheshader( "zombies_rank_5" );
	    precacheshader( "hud_icon_sticky_grenade" );
        precacheshader( "specialty_instakill_zombies" );
	    precacheshader( "menu_mp_weapons_1911" );
		precacheshader( "hud_icon_colt" );
        precachemodel("p6_zm_buildable_sq_meteor");
	    precachemodel( "collision_player_wall_512x512x10" );
	    precachemodel( "collision_physics_512x512x10" );
	    precachemodel( "t5_foliage_tree_burnt03" );
	    precachemodel( "p_rus_door_roller" );
	    precachemodel( "ch_tombstone1" );
	    precachemodel( "collision_geo_256x256x10_standard" );
	    precachemodel( "zombie_vending_tombstone_on" );
	    precachemodel( "zombie_vending_revive_on" );
	    precachemodel( "zombie_vending_sleight_on" );
	    precachemodel( "zombie_vending_doubletap2_on" );
	    precachemodel( "zombie_pickup_perk_bottle" );
	    precachemodel( "zm_collision_perks1" );
	    precachemodel( "p6_zm_screecher_hole" );
	    precachemodel( "p_cub_door01_wood_fullsize" );
	    precachemodel( "veh_t6_civ_microbus_dead" );
	    precachemodel( "p_rus_door_white_window_plain_left" );
		if (level.script != "zm_prison")
		{
			level._effect["fx_zombie_cola_revive_on"] = loadfx( "misc/fx_zombie_cola_revive_on" );
			level._effect["fx_zombie_cola_dtap_on"] = loadfx( "misc/fx_zombie_cola_dtap_on" );
		}

	    level._effect["fx_zombie_cola_on"] = loadfx( "misc/fx_zombie_cola_on" );
		if (!(level.script == "zm_tomb" || level.script == "zm_prison"))
		{
			level._effect["fx_zmb_wall_buy_taseknuck"] = loadfx( "maps/zombie/fx_zmb_wall_buy_taseknuck" );
			level._effect["fx_zmb_wall_buy_bowie"] = loadfx( "maps/zombie/fx_zmb_wall_buy_bowie" );
		}
	  //  level._effect["fx_default_explosion"] = loadfx( "explosions/fx_default_explosion" );

	
        if( level.script == "zm_buried" || level.script == "zm_tomb" )                  
		{
			level._effect["fx_default_explosion"] = level._effect[ "divetonuke_groundhit"];
		}
		else
		{
			level._effect["fx_default_explosion"] = loadfx( "explosions/fx_default_explosion" );
		}


        level.ta_vaultfee = 1000;

    if ( !isdefined( level.ta_tellerfee ) )
        level.ta_tellerfee = 1000;


	//    level.town = 1;
	 //   level.diner = 0;

		isTown();

		//level thread perk_machine_removal( "specialty_scavenger" );
		init_custom_map(); 

	    if(level.script != "zm_buried" && level.script != "zm_highrise" && level.script != "zm_tomb")
	  		level.get_player_weapon_limit = ::custom_get_player_weapon_limit;

	    level.zombie_last_stand = ::LastStand;
	    level.custom_vending_precaching = ::default_vending_precaching;
		


       
	    level.player_out_of_playable_area_monitor = 0;
	    level.perk_purchase_limit = 50;

//--------------------------ENDCUSTOMPERKS--------------------------------------------------








    onplayerconnect_callback( ::watch_weapon_changes ); 
 
//	if( getdvar( "mapname" ) == "zm_transit" && getdvar ( "g_gametype" )  == "zstandard")
//		level._effect[ "jetgun_smoke_cloud" ] = loadfx( "weapon\thunder_gun\fx_thundergun_smoke_cloud" );
	
    thread new_pap_trigger();
	level._poi_override = ::turned_zombie;


}

wait_network_frame_override()
{
	wait .1;
}



//-------------------CUSTOMPERK------------------------

onPlayerConnect(player)
{
	player thread onPlayerSpawned();
}

onPlayerSpawned()
{
	self endon( "disconnect" );
	level endon( "game_ended" );
	self waittill( "spawned_player" );
	//self.flags = xor(self.flags, 0x2000);

	self.bleedout_time = 30;
	self.ignore_lava_damage = 0;
	self.has_timeslip = 0;
	self.savedaat = [];
	self.shouldkeepperk = 1;
	self.perkarray = [];
	self.dying_wish_on_cooldown = 0;
    self.perk_reminder = 0;
    self.perk_count = 0;
    self.num_perks = 0;
	self.weapons_aat_cooldown = [];
	self.weapons_aat_cooldown[0] = 0;
	self.weapons_aat_cooldown[1] = 0;
	self.weapons_aat_cooldown[2] = 0;
	self.is_aat_blinking = 0;
	self.aat_remaining_cooldown = 1;
	self.aat_cooldown_duration = 1;
	self.aat_color = (0, 0, 0);
	self.aat_remaining_cooldown = [];
	self.aat_remaining_cooldown[0] = 1;
	self.aat_remaining_cooldown[1] = 1;
	self.aat_remaining_cooldown[2] = 1;
	self.aat_cooldown_duration = [];
	self.aat_cooldown_duration[0] = 1;
	self.aat_cooldown_duration[1] = 1;
	self.aat_cooldown_duration[2] = 1;	


	self thread removeperkshader();
    self thread perkboughtcheck();
	self thread damagehitmarker();


/*	if (level.script == "zm_prison")
	{
	    for (;;)
		{
		//  perk_array = maps\mp\zombies\_zm_perks::get_perk_array( 1 );
		if (isdefined(self.perkarray))
		{
				for ( i = 0; i < self.perkarray.size; i++ )
				{
					iprintln(self.perkarray[i].name);
					iprintln(self.perkarray[i]);
				// self unsetperk( perk );
				// self set_perk_clientfield( perk, 0 );
				}
				wait 5;
			}
		}
	}*/
}



/*afterlife_giveback()
{
    self takeallweapons();
    loadout = self.loadout;
    primaries = self getweaponslistprimaries();

    if ( loadout.weapons.size > 1 || primaries.size > 1 )
    {
        foreach ( weapon in primaries )
            self takeweapon( weapon );
    }

    for ( i = 0; i < loadout.weapons.size; i++ )
    {
        if ( !isdefined( loadout.weapons[i] ) )
            continue;

        if ( loadout.weapons[i] == "none" )
            continue;

        weapon = loadout.weapons[i];
        stock_amount = loadout.stockcount[i];
        clip_amount = loadout.clipcount[i];

        if ( !self hasweapon( weapon ) )
        {
            self giveweapon( weapon, 0, self maps\mp\zombies\_zm_weapons::get_pack_a_punch_weapon_options( weapon ) );
            self setweaponammostock( weapon, stock_amount );
            self setweaponammoclip( weapon, clip_amount );

            if ( weaponisdualwield( weapon ) )
            {
                weapon_dw = weapondualwieldweaponname( weapon );
                self setweaponammoclip( weapon_dw, loadout.clipcount2[i] );
            }

            weapon_alt = weaponaltweaponname( weapon );

            if ( weapon_alt != "none" )
            {
                self setweaponammostock( weapon_alt, loadout.stockcountalt[i] );
                self setweaponammoclip( weapon_alt, loadout.clipcountalt[i] );
            }
        }
    }

    self setspawnweapon( loadout.weapons[loadout.current_weapon] );
    self switchtoweaponimmediate( loadout.weapons[loadout.current_weapon] );

    if ( isdefined( self get_player_melee_weapon() ) )
        self giveweapon( self get_player_melee_weapon() );

    self maps\mp\zombies\_zm_equipment::equipment_give( self.loadout.equipment );

    if ( isdefined( loadout.hasclaymore ) && loadout.hasclaymore && !self hasweapon( "claymore_zm" ) )
    {
        self giveweapon( "claymore_zm" );
        self set_player_placeable_mine( "claymore_zm" );
        self setactionslot( 4, "weapon", "claymore_zm" );
        self setweaponammoclip( "claymore_zm", loadout.claymoreclip );
    }

    if ( isdefined( loadout.hasemp ) && loadout.hasemp )
    {
        self giveweapon( "emp_grenade_zm" );
        self setweaponammoclip( "emp_grenade_zm", loadout.empclip );
    }

    if ( isdefined( loadout.hastomahawk ) && loadout.hastomahawk )
    {
        self giveweapon( self.current_tomahawk_weapon );
        self set_player_tactical_grenade( self.current_tomahawk_weapon );
        self setclientfieldtoplayer( "tomahawk_in_use", 1 );
    }

    self.score = loadout.score;
    perk_array = maps\mp\zombies\_zm_perks::get_perk_array( 1 );

    for ( i = 0; i < perk_array.size; i++ )
    {
        perk = perk_array[i];
        self unsetperk( perk );
        self set_perk_clientfield( perk, 0 );
    }

    if ( isdefined( self.keep_perks ) && self.keep_perks && isdefined( loadout.perks ) && loadout.perks.size > 0 )
    {
        for ( i = 0; i < loadout.perks.size; i++ )
        {
            if ( self hasperk( loadout.perks[i] ) )
                continue;

            if ( loadout.perks[i] == "specialty_quickrevive" && flag( "solo_game" ) )
                level.solo_game_free_player_quickrevive = 1;

            if ( loadout.perks[i] == "specialty_finalstand" )
                continue;

            maps\mp\zombies\_zm_perks::give_perk( loadout.perks[i] );
        }
    }

    self.keep_perks = undefined;
    self set_player_lethal_grenade( self.loadout.lethal_grenade );

    if ( loadout.grenade > 0 )
    {
        curgrenadecount = 0;

        if ( self hasweapon( self get_player_lethal_grenade() ) )
            self getweaponammoclip( self get_player_lethal_grenade() );
        else
            self giveweapon( self get_player_lethal_grenade() );

        self setweaponammoclip( self get_player_lethal_grenade(), loadout.grenade + curgrenadecount );
    }
}*/


damagehitmarker()
{
	self endon ("disconnect");
	level endon( "end_game" );
	self thread startwaiting();
	self.hitmarker = newdamageindicatorhudelem( self );
	self.hitmarker.horzalign = "center";
	self.hitmarker.vertalign = "middle";
	self.hitmarker.x = -12;
	self.hitmarker.y = -12;
	self.hitmarker.alpha = 0;
	self.hitmarker setshader( "damage_feedback", 24, 48 );

}

startwaiting()
{
	self endon ("disconnect");
	level endon( "end_game" );
	while( 1 )
	{
		foreach( zombie in getaiarray( level.zombie_team ) )
		{
			if( !(IsDefined( zombie.waitingfordamage )) )
			{
				zombie thread hitmark();
			}
		}
		wait 0.25;
	}
}

hitmark()
{
	self endon ("disconnect");
	level endon( "end_game" );
	self endon( "killed" );

	self.waitingfordamage = 1;
	while( 1 )
	{
		self waittill( "damage", amount, attacker, dir, point, mod );
		attacker.hitmarker.alpha = 0;
		if(!isDefined(attacker.aat_actived))
			attacker.aat_actived = 0;
		if( isplayer( attacker ) )
		{
			if(attacker.aat_actived)
			{
				attacker.hitmarker.alpha = 1;
				for(i = 0; i < 20; i++)
				{
					r = randomfloatrange(0.1, 0.9);
					g = randomfloatrange(0.1, 0.9);
					b = randomfloatrange(0.1, 0.9);
					attacker.hitmarker.color = ( r, g, b );
					if(i > 5)
						attacker.hitmarker.alpha -= .075;
					
					wait .1;
				}
				attacker.hitmarker.alpha = 0;
				attacker.aat_actived = 0;
				self.waitingfordamage = 0;
				break;
			}
			if( isalive( self ) )
			{
				attacker.hitmarker.color = ( 1, 1, 1 );
				attacker.hitmarker.alpha = 1;
				attacker.hitmarker fadeovertime( 1 );
				attacker.hitmarker.alpha = 0;
			}
			else
			{
				attacker.hitmarker.color = ( 1, 0, 0 );
				attacker.hitmarker.alpha = 1;
				attacker.hitmarker fadeovertime( 1 );
				attacker.hitmarker.alpha = 0;
				self notify( "killed" );
			}
		}
	}
}	




init_custom_map()
{
	if( level.script == "zm_transit" )
	{
		if (getdvar("net_port") != "30011")
		{
			perk_system( "script_model", ( 901.86, -1575.574, -47.875 ), "zombie_vending_tombstone_on", ( 0, 180, 0 ), "custom", "mus_perks_deadshot_sting", "^8Widow's Wine^7", 4000, "tombstone_light", "WIDOWS_WINE" );
			perk_system( "script_model", ( 450, -300.574, -61.875 ), "zombie_vending_tombstone_on", ( 0, 45, 0 ), "custom", "mus_perks_packa_sting", "^5Electric ^1Cherry^7", 2000, "tombstone_light", "ELECTRIC_CHERRY" ); // 613,-250,z 0,0,0
			perk_system( "script_model", ( 1069, -1133, 120.125 ), "zombie_vending_tombstone_on", ( 0, 180, 0 ), "custom", "mus_perks_doubletap_sting", "^6Time Slip^7", 2500, "tombstone_light", "Time_Slip" );
			perk_system( "script_model", ( 1823.86, 670.574, -55.875 ), "zombie_vending_tombstone_on", ( 0, 45, 0 ), "custom", "mus_perks_doubletap_sting", "^2Mule Kick^7", 4000, "tombstone_light", "MULE" );
			perk_system( "script_model", ( 840, 603.809, -40.875 ), "zombie_vending_tombstone_on", ( 0, 0, 0 ), "custom", "mus_perks_packa_sting", "^6PhD Flopper^7", 2500, "tombstone_light", "PHD_FLOPPER" );
			perk_system( "script_model", ( 2358, -87, -55.875  ), "zombie_vending_tombstone_on", ( 0, -90, 0 ), "custom", "mus_perks_doubletap_sting", "^5Downer's Delight^7", 2000, "tombstone_light", "Downers_Delight" );
		}
		perk_system( "script_model", ( 1856, -810.722, -55.875), "zombie_vending_tombstone_on", ( 0, 180, 0 ), "custom", "mus_perks_deadshot_sting", "^5Momentum ^3Mocha^7", 4000, "tombstone_light", "Momentum_Mocha" );
		perk_system( "script_model", ( 2460, -780, -55.875 ), "zombie_vending_tombstone_on", ( 0, 225, 0 ), "custom", "mus_perks_doubletap_sting", "^1Burn Heart^7", 2500, "jugger_light", "Burn_Heart" );
		perk_system( "script_model", (  2015, 858, -56.875  ), "zombie_vending_tombstone_on", ( 0, -90, 0 ), "custom", "mus_perks_doubletap_sting", "^5Dying Wish^7", 6000, "tombstone_light", "Dying_Wish" );
		perk_system( "script_model", ( 559, -1364, 120.125  ), "zombie_vending_tombstone_on", ( 0, 180, 0 ), "custom", "mus_perks_doubletap_sting", "^9Ammo Regen^7", 3000, "tombstone_light", "Ammo_Regen" );
		perk_system( "script_model", ( 1971.3, -144.641, -55.875  ), "zombie_vending_jugg_on", ( 0, 0, 0 ), "custom", "mus_perks_doubletap_sting", "^9Bandolier Bandit^7", 3500, "tombstone_light", "Bandolier_Bandit" );
	}
	if( level.script == "zm_highrise")
	{
	perk_system( "script_model", ( 1884.42, 491.946, 1298.72), "zombie_vending_jugg_on", ( 0, 418.728, 0 ), "custom", "mus_perks_deadshot_sting", "^5Momentum ^3Mocha^7", 4000, "tombstone_light", "Momentum_Mocha" );
//	perk_system( "script_model", ( 2764.64, 1868.03, 1391.01 ), "zombie_vending_jugg_on", ( 0, 384.236, 0 ), "custom", "mus_perks_doubletap_sting", "^1Burn Heart^7", 2500, "jugger_light", "Burn_Heart" );
	perk_system( "script_model", ( 1978.25, 597.657, 2704.13 ), "zombie_vending_jugg_on", ( 0, 329.291, 0 ), "custom", "mus_perks_deadshot_sting", "^8Widow's Wine^7", 4000, "tombstone_light", "WIDOWS_WINE" );
//	perk_system( "script_model", ( 1415.64, 2108.36, 3220.26 ), "zombie_vending_jugg_on", ( 0, 406.661, 0 ), "custom", "mus_perks_packa_sting", "^5Electric ^1Cherry^7", 2000, "tombstone_light", "ELECTRIC_CHERRY" ); // 613,-250,z 0,0,0
	perk_system( "script_model", ( 1901.97, 1431.36, 3216.13 ), "zombie_vending_jugg_on", ( 0, 404.762, 0 ), "custom", "mus_perks_doubletap_sting", "^6Time Slip^7", 2500, "tombstone_light", "Time_Slip" );
//	perk_system( "script_model", ( 1891.64, 1119.64, 3048.36 ), "zombie_vending_jugg_on", ( 0, 45, 0 ), "custom", "mus_perks_doubletap_sting", "^2Mule Kick^7", 4000, "tombstone_light", "MULE" );
	perk_system( "script_model", ( 1429.29, -453.397, 2880.13 ), "zombie_vending_jugg_on", ( 0, 149.1426, 0 ), "custom", "mus_perks_packa_sting", "^6PhD Flopper^7", 2500, "tombstone_light", "PHD_FLOPPER" );
	perk_system( "script_model", ( 1109.64, 2701.36, 3043.82  ), "zombie_vending_jugg_on", ( 0, 394.926, 0 ), "custom", "mus_perks_doubletap_sting", "^5Downer's Delight^7", 2000, "tombstone_light", "Downers_Delight" );
	perk_system( "script_model", ( 1706.28, 1055.64, 3395.1  ), "zombie_vending_jugg_on", ( 0, 180, 0 ), "custom", "mus_perks_doubletap_sting", "^5Dying Wish^7", 6000, "tombstone_light", "Dying_Wish" );
	perk_system( "script_model", ( 2269.17, 182.377, 2880.13  ), "zombie_vending_jugg_on", ( 0, 418.596, 0 ), "custom", "mus_perks_doubletap_sting", "^9Ammo Regen^7", 3000, "tombstone_light", "Ammo_Regen" );
	perk_system( "script_model", ( 1565.64, 1897.78, 3402.84  ), "zombie_vending_jugg_on", ( 0, 90, 0 ), "custom", "mus_perks_doubletap_sting", "^9Bandolier Bandit^7", 3500, "tombstone_light", "Bandolier_Bandit" );
	}
	if( level.script == "zm_buried")
	{
	perk_system( "script_model", ( 1618.14, 1513.46, 200.62), "zombie_vending_jugg_on", ( 0, 250.147, 0 ), "custom", "mus_perks_deadshot_sting", "^5Momentum ^3Mocha^7", 4000, "sleight_light", "Momentum_Mocha" );
//	perk_system( "script_model", ( -1176.36, 508.26, 144.125 ), "zombie_vending_jugg_on", ( 0, 448.269, 0 ), "custom", "mus_perks_doubletap_sting", "^1Burn Heart^7", 2500, "sleight_light", "Burn_Heart" );
	perk_system( "script_model", ( -1176.36, 510.625, 144.125 ), "zombie_vending_jugg_on", ( 0, 449.412, 0 ), "custom", "mus_perks_deadshot_sting", "^8Widow's Wine^7", 4000, "sleight_light", "WIDOWS_WINE" );
//	perk_system( "script_model", ( -448.859, 131.435, 143.491 ), "zombie_vending_jugg_on", ( 0, 180.3, 0 ), "custom", "mus_perks_packa_sting", "^5Electric ^1Cherry^7", 2000, "sleight_light", "ELECTRIC_CHERRY" ); // 613,-250,z 0,0,0
	perk_system( "script_model", ( 890.359, -840.206, -22.8006 ), "zombie_vending_jugg_on", ( 0, 270.367, 0 ), "custom", "mus_perks_doubletap_sting", "^6Time Slip^7", 2500, "sleight_light", "Time_Slip" );
//	perk_system( "script_model", ( 1891.64, 1119.64, 3048.36 ), "zombie_vending_jugg_on", ( 0, 45, 0 ), "custom", "mus_perks_doubletap_sting", "^2Mule Kick^7", 4000, "sleight_light", "MULE" );
	perk_system( "script_model", ( 572.507, -712.359, 149.95 ), "zombie_vending_jugg_on", ( 0, 178.4505, 0 ), "custom", "mus_perks_packa_sting", "^6PhD Flopper^7", 2500, "sleight_light", "PHD_FLOPPER" );
	perk_system( "script_model", ( 488.324, 727.641, 176.125  ), "zombie_vending_jugg_on", ( 0, 178.9998, 0 ), "custom", "mus_perks_doubletap_sting", "^5Downer's Delight^7", 2000, "sleight_light", "Downers_Delight" );
	perk_system( "script_model", ( -1298.32, -837.178, -23.875  ), "zombie_vending_jugg_on", ( 0, 91.37286, 0 ), "custom", "mus_perks_doubletap_sting", "^5Dying Wish^7", 6000, "sleight_light", "Dying_Wish" );
	perk_system( "script_model", ( -122.161, -1469.21, 168.125  ), "zombie_vending_jugg_on", ( 0, 448.841, 0 ), "custom", "mus_perks_doubletap_sting", "^9Ammo Regen^7", 3000, "sleight_light", "Ammo_Regen" );
	perk_system( "script_model", ( 1195.22, 1493.46, -19.875 ), "zombie_vending_jugg_on", ( 0, -20, 0 ), "custom", "mus_perks_deadshot_sting", "^9Bandolier Bandit^7", 3500, "sleight_light", "Bandolier_Bandit" );
	}
	if( level.script == "zm_nuked")
	{
	perk_system( "script_model", ( 28.8155, -356.18, -65.8346 ), "zombie_vending_jugg_on", ( 0, 129.8755, 0 ), "custom", "mus_perks_deadshot_sting", "^5Momentum ^3Mocha^7", 4000, "sleight_light", "Momentum_Mocha" );
//	perk_system( "script_model", (  ), "zombie_vending_jugg_on", (  ), "custom", "mus_perks_doubletap_sting", "^1Burn Heart^7", 2500, "sleight_light", "Burn_Heart" );
	perk_system( "script_model", ( -954.194, 714.594, 84.0385 ), "zombie_vending_jugg_on", ( 0, 429.46, 0 ), "custom", "mus_perks_deadshot_sting", "^8Widow's Wine^7", 4000, "sleight_light", "WIDOWS_WINE" );
	perk_system( "script_model", ( 683.524, 618.635, -56.875 ), "zombie_vending_jugg_on", ( 0, 102.5635, 0 ), "custom", "mus_perks_packa_sting", "^5Electric ^1Cherry^7", 2000, "sleight_light", "ELECTRIC_CHERRY" ); // 613,-250,z 0,0,0
	perk_system( "script_model", ( 1420.35, -21.4313, -63.8849 ), "zombie_vending_jugg_on", ( 0, 194.085, 0 ), "custom", "mus_perks_doubletap_sting", "^6Time Slip^7", 2500, "sleight_light", "Time_Slip" );
	perk_system( "script_model", ( 618.292, -188.322, -56.3686 ), "zombie_vending_jugg_on", ( 0, 105.5011, 0 ), "custom", "mus_perks_doubletap_sting", "^2Mule Kick^7", 4000, "sleight_light", "MULE" );
	perk_system( "script_model", ( 1152.5, 160.6, 79.125 ), "zombie_vending_jugg_on", ( 0, 392.541, 0 ), "custom", "mus_perks_packa_sting", "^6PhD Flopper^7", 2500, "sleight_light", "PHD_FLOPPER" );
	perk_system( "script_model", ( 156.738, 513.899, -62.3141 ), "zombie_vending_jugg_on", ( 0, 101.8164, 0 ), "custom", "mus_perks_doubletap_sting", "^5Downer's Delight^7", 2000, "sleight_light", "Downers_Delight" );
	perk_system( "script_model", ( -646.863, 271.522, -55.875 ), "zombie_vending_jugg_on", ( 0, 160.8405, 0 ), "custom", "mus_perks_doubletap_sting", "^5Dying Wish^7", 6000, "sleight_light", "Dying_Wish" );
	perk_system( "script_model", ( -1582.46, 112.604, -63.2092 ), "zombie_vending_jugg_on", ( 0, 250.829, 0 ), "custom", "mus_perks_doubletap_sting", "^9Ammo Regen^7", 3000, "sleight_light", "Ammo_Regen" );
	perk_system( "script_model", ( -229.945, 999.865, -63.875 ), "zombie_vending_jugg_on", ( 0, 25, 0 ), "custom", "mus_perks_deadshot_sting", "^9Bandolier Bandit^7", 3500, "sleight_light", "Bandolier_Bandit" );
	}
	if( level.script == "zm_tomb")
	{
	perk_system( "script_model", ( 184.995, -2422.49, 50.125), "zombie_vending_jugg_on", ( 0, 369.091, 0 ), "custom", "mus_perks_deadshot_sting", "^5Momentum ^3Mocha^7", 4000, "sleight_light", "Momentum_Mocha" );
	perk_system( "script_model", ( 160.359, 3781.17, -351.875 ), "zombie_vending_jugg_on", ( 0, 266.122, 0 ), "custom", "mus_perks_deadshot_sting", "^8Widow's Wine^7", 4000, "sleight_light", "WIDOWS_WINE" );
	perk_system( "script_model", ( 375.771, 2119.22, -122.951 ), "zombie_vending_jugg_on", ( 0, 179.5935, 0 ), "custom", "mus_perks_doubletap_sting", "^6Time Slip^7", 2500, "sleight_light", "Time_Slip" );
	//perk_system( "script_model", ( -335.604, -187.006, 325.273 ), "zombie_vending_jugg_on", ( 0, 132.9565, 0 ), "custom", "mus_perks_packa_sting", "^6PhD Flopper^7", 2500, "sleight_light", "PHD_FLOPPER" );
	perk_system( "script_model", ( 924.47, 360.72, 131.005 ), "zombie_vending_jugg_on", ( 0, 373.266, 0 ), "custom", "mus_perks_doubletap_sting", "^5Downer's Delight^7", 2000, "sleight_light", "Downers_Delight" );
	perk_system( "script_model", ( 1345.09, -3822.62, 302.125 ), "zombie_vending_jugg_on", ( 0, 270.593, 0 ), "custom", "mus_perks_doubletap_sting", "^5Dying Wish^7", 6000, "sleight_light", "Dying_Wish" );
	perk_system( "script_model", ( 2972.36, 5218.91, -378.566 ), "zombie_vending_jugg_on", ( 0, 270.379, 0 ), "custom", "mus_perks_doubletap_sting", "^9Ammo Regen^7", 3000, "sleight_light", "Ammo_Regen" );
	perk_system( "script_model", ( -104.105, -765.843, 224.125 ), "zombie_vending_jugg_on", ( 0, 90, 0 ), "custom", "mus_perks_deadshot_sting", "^9Bandolier Bandit^7", 3500, "sleight_light", "Bandolier_Bandit" );
	}
	if( level.script == "zm_prison")
	{
		perk_system( "script_model", ( 3763.64, 9669.99, 1704.13 ), "p6_zm_al_vending_jugg_on", ( 0, 90, 0 ), "custom", "mus_perks_deadshot_sting", "^8Widow's Wine^7", 4000, "sleight_light", "WIDOWS_WINE" );
		perk_system( "script_model", ( 2160.71, 9247.64, 1558.13 ), "p6_zm_al_vending_jugg_on", ( 0, 179.1815, 0 ), "custom", "mus_perks_doubletap_sting", "^6Time Slip^7", 2500, "sleight_light", "Time_Slip" );
		perk_system( "script_model", ( 597.633, 8546.86, 832.125 ), "p6_zm_al_vending_jugg_on", ( 0, 221.984, 0 ), "custom", "mus_perks_doubletap_sting", "^2Mule Kick^7", 4000, "sleight_light", "MULE" );
		perk_system( "script_model", ( 456.359, 8679.51, 1128.13 ), "p6_zm_al_vending_jugg_on", ( 0, 269.533, 0 ), "custom", "mus_perks_packa_sting", "^6PhD Flopper^7", 2500, "sleight_light", "PHD_FLOPPER" );
		perk_system( "script_model", ( -685.943, 9199.64, 1336.13 ), "p6_zm_al_vending_jugg_on", ( 0, 178.5443, 0 ), "custom", "mus_perks_doubletap_sting", "^5Downer's Delight^7", 2000, "sleight_light", "Downers_Delight" );
		perk_system( "script_model", ( 2998.88, 10048.4, 1336.3 ), "p6_zm_al_vending_jugg_on", ( 0, 357.896, 0 ), "custom", "mus_perks_doubletap_sting", "^5Dying Wish^7", 6000, "sleight_light", "Dying_Wish" );
		perk_system( "script_model", ( 1367.28, 10096.4, 1128.13 ), "p6_zm_al_vending_jugg_on", ( 0, 358.687, 0 ), "custom", "mus_perks_doubletap_sting", "^9Ammo Regen^7", 3000, "sleight_light", "Ammo_Regen" );
		
		wait 0.1;
		if (check_for_botb_port() == true)
		{
			perk_system( "script_model", ( -1928, -3382, -8448 ), "p6_zm_al_vending_jugg_on", ( 0, 90, 0 ), "custom", "mus_perks_deadshot_sting", "^5Momentum ^3Mocha^7", 4000, "sleight_light", "Momentum_Mocha" );
			perk_system( "script_model", ( -1916, -3786, -8448 ), "p6_zm_al_vending_jugg_on", ( 0, 90, 0 ), "custom", "mus_perks_deadshot_sting", "^9Bandolier Bandit^7", 3500, "sleight_light", "Bandolier_Bandit" );
		}
		else
		{
			perk_system( "script_model", ( -1344.65, 5598.31, -71.875 ), "p6_zm_al_vending_jugg_on", ( 0, 98.34412, 0 ), "custom", "mus_perks_deadshot_sting", "^5Momentum ^3Mocha^7", 4000, "sleight_light", "Momentum_Mocha" );
			perk_system( "script_model", ( 1418.77, 9047.64, 1336.13 ), "p6_zm_al_vending_jugg_on", ( 0, 180, 0 ), "custom", "mus_perks_deadshot_sting", "^9Bandolier Bandit^7", 3500, "sleight_light", "Bandolier_Bandit" );
		}
	}
}

play_fx( fx )
{
	playfxontag( level._effect[ fx ], self, "tag_origin" );
}

defaulth_vending_precaching()
{
	level._effect[ "sleight_light" ] = loadfx( "misc/fx_zombie_cola_on" );
	level._effect[ "tombstone_light" ] = loadfx( "misc/fx_zombie_cola_on" );
	level._effect[ "revive_light" ] = loadfx( "misc/fx_zombie_cola_revive_on" );
	level._effect[ "marathon_light" ] = loadfx( "maps/zombie/fx_zmb_cola_staminup_on" );
	level._effect[ "jugger_light" ] = loadfx( "misc/fx_zombie_cola_jugg_on" );
	level._effect[ "doubletap_light" ] = loadfx( "misc/fx_zombie_cola_dtap_on" );
	level._effect[ "deadshot_light" ] = loadfx( "misc/fx_zombie_cola_dtap_on" );
	level._effect[ "additionalprimaryweapon_light" ] = loadfx( "misc/fx_zombie_cola_arsenal_on" );
	level._effect[ "packapunch_fx" ] = loadfx( "maps/zombie/fx_zombie_packapunch" );
	level._effect[ "wall_taseknuck" ] = loadfx( "maps/zombie/fx_zmb_wall_buy_taseknuck" );
}


playchalkfx(effect, origin, angles)
{
    fx = SpawnFX(level._effect[ effect ], origin,AnglesToForward(angles),AnglesToUp(angles));
    TriggerFX(fx);
    level waittill("connected", player);
    fx Delete();
}



perk_system( script, pos, model, angles, type, sound, name, cost, fx, perk)
{
	col = spawn( script, pos);
	col setmodel( model );
	col.angles = angles;
	x = spawn( script, pos );
	x setmodel( "zm_collision_perks1" );
	x.angles = angles;
    col thread buy_system( perk, sound, name, cost, type );
    col thread play_fx( fx );
}

buy_system( perk, sound, name, cost, type )
{
	level endon("end_game");
	self endon("disconnect");
    self endon( "game_ended" );
    while( 1 )
    {
        foreach( player in level.players )
        {
            if(!isdefined(player.machine_is_in_use) || player.machine_is_in_use == 0)
			{
                if( distance( self.origin, player.origin ) <= 70 )
                {
					if (check_for_botb_port() == true)
					{
						if (name == "^9Bandolier Bandit^7")
						{
							cost = 0;
							player thread SpawnHint( self.origin, 30, 30, "HINT_ACTIVATE", "Hold ^3&&1^7 for ^5Super ^9Bandolier^7 [Cost: ^3-35 percent Speed^7]\n^1                            ^1Permanent Debuff^7" );
						}
						else if (name == "^5Momentum ^3Mocha^7")
						{
							cost = 0;
							player thread SpawnHint( self.origin, 30, 30, "HINT_ACTIVATE", "Hold ^3&&1^7 for ^5Super ^3Mocha^7 [Cost: ^1HP set to 100^7]\n                    ^1Permanent Debuff^7" );
						}
					}
					else
					{
						player thread SpawnHint( self.origin, 30, 30, "HINT_ACTIVATE", "Hold ^3&&1^7 for " + name + " [Cost: " + cost + "]" );
					}
                    if(player usebuttonpressed() && !player hasperk(perk) && !player hascustomperk(perk) && player.score >= cost && !player maps\mp\zombies\_zm_laststand::player_is_in_laststand())
                    {
						if (check_for_botb_port() == true)
						{
							if (name == "^9Bandolier Bandit^7")
							{
								player thread speed_debuff();
							}
							else if (name == "^5Momentum ^3Mocha^7")
							{
								player thread hp_debuff();
							}
						}
                        player.machine_is_in_use = 1;
                        player playsound( "zmb_cha_ching" );
                        player.score -= cost;
                        player playsound( sound );
			    	    player thread drawshader_and_shadermove( perk, 1, 1, type );
						wait 4;
                    	player.machine_is_in_use = 0;
					}
					else
                    {
                        if( player usebuttonpressed() && player.score < cost )
                        {
                            player maps\mp\zombies\_zm_audio::create_and_play_dialog( "general", "perk_deny", undefined, 0 );
                        }
                    }
                }
            }
        }
        wait 0.1;
    }
}

speed_debuff()
{
	if (!(isdefined(self.old_speed)))
		self.old_speed = self GetMoveSpeedScale();
	for(;;)
	{
		if (!isdefined(level.final_wave))
			self SetMoveSpeedScale(self.old_speed * 0.65);
		wait 1;
	}
}

hp_debuff()
{
	self.old_maxhealth = self.maxhealth;
	self.old_health = self.health;

	self.maxhealth = 100;
	self.health = 100;

	for (;;)
	{
		if (self.maxhealth != 100)
		{
			self.maxhealth = 100;
			self.health = 100;
		}
		wait 1;
	}
}

hascustomperk(perk)
{
	for(i = 0; i < self.perkarray.size; i++)
	{
		if(self.perkarray[i].name == perk)
		{
			return 1;
		}
	}
	return 0;
}

removeperkshader()
{
	self endon ("disconnect");
	level endon( "end_game" );
	common_scripts\utility::flag_wait( "initial_blackscreen_passed" );
    for(;;)
    {
		for (;;)
		{
			if (self maps\mp\zombies\_zm_laststand::player_is_in_laststand() || self.sessionstate == "spectator")
			{
				if (level.script == "zm_prison")
				{
					if (self.shouldkeepperk == 0)
					{
						if (isdefined(self.has_bandolier) && self.has_bandolier == 1)
						{
							self.has_bandolier = 0;
							self thread bandolier();
						}

						self.num_perks = 0;
						self.perk_reminder = 0;
						self.perk_count = 0;
						self.dying_wish_on_cooldown = 0;
						self removeallcustomshader();
						self.perkarray = [];
						self notify( "stopcustomperk" );
						self.bleedout_time = 30;
						self.ignore_lava_damage = 0;
						self setclientfieldtoplayer( "deadshot_perk", 0 );
						self.shouldkeepperk = 1;
						wait 0.1;
						/*if (isdefined(self.old_health) && isdefined(self.old_maxhealth))
						{
							self.maxhealth = self.old_maxhealth;
							self.health = self.old_health;
						}
						if (isdefined(self.old_speed))
						{
							self SetMoveSpeedScale(self.old_speed);
						}*/
					}
				}
				else
				{
					if (isdefined(self.has_bandolier) && self.has_bandolier == 1)
					{
						self.has_bandolier = 0;
						self thread bandolier();
					}
					self.num_perks = 0;
					self.perk_reminder = 0;
					self.perk_count = 0;
					self.dying_wish_on_cooldown = 0;
					self removeallcustomshader();
					self.perkarray = [];
					self notify( "stopcustomperk" );
					self.has_timeslip = 0;
					self.bleedout_time = 30;
					self.ignore_lava_damage = 0;
					self setclientfieldtoplayer( "deadshot_perk", 0 );
					self.shouldkeepperk = 1;
				}
				break;
			}
			wait 1;
		}
		for (;;)
		{
			if (!(self maps\mp\zombies\_zm_laststand::player_is_in_laststand()) && self.sessionstate != "spectator")
				break;
			wait 1;
		}
		wait 1;
    }
}

removeallcustomshader()
{
	for(i = 0; i < self.perkarray.size; i++)
	{
		self.perkarray[i] destroy();
	}
}

drawshader( shader, x, y, width, height, color, alpha, sort )
{
	level endon("end_game");
	self endon("disconnect");
	hud = newclienthudelem( self );
	hud.elemtype = "icon";
	hud.color = color;
	hud.alpha = alpha;
	hud.sort = sort;
	hud.children = [];
    hud.hidewheninmenu = 1;
	hud setparent( level.uiparent );
	hud setshader( shader, width, height );
	hud.x = x;
	hud.y = y;
	return hud;
}

perkboughtcheck()
{
    self endon("death");
    self endon("disconnect");
    for(;;)
    {
        self.perk_reminder = self.num_perks;
        self waittill("perk_acquired");
		n = 1;
        if(!(self.num_perks > self.perk_reminder))
        {
			n = (self.num_perks - self.perk_reminder);
            self.num_perks = (self.perk_reminder + n);
        }
        self.perk_reminder = self.num_perks;
        self.perk_count += n;
        self drawshader_and_shadermove("none", 0, 0, "normal"); //modified to remove perk alignement since 2 perk lines  Added "normal" for type check
    }
}

drawshader_and_shadermove(perk, custom, print, type)
{
	level endon("end_game");
	self endon("disconnect");
    if(custom)
	{
		if (!isdefined(self.has_timeslip) || self.has_timeslip == 0)
		{
			self allowProne(false);
			self allowSprint(false);
			self disableoffhandweapons();
			self disableweaponcycling();
			weapona = self getcurrentweapon();
			weaponb = "zombie_perk_bottle_jugg";
			self giveweapon( weaponb );
			self switchtoweapon( weaponb );
			self waittill( "weapon_change_complete" );
			self enableoffhandweapons();
			self enableweaponcycling();
			self takeweapon( weaponb );
			self switchtoweapon( weapona );
			self maps\mp\zombies\_zm_audio::playerexert( "burp" );
			self setblur( 4, 0.1 );
			wait 0.1;
			self setblur( 0, 0.1 );
			self allowProne(true);
			self allowSprint(true);
		}
		else
		{
			self maps\mp\zombies\_zm_audio::playerexert( "burp" );
			self setblur( 4, 0.1 );
			wait 0.1;
			self setblur( 0, 0.1 );
		}
    }

	yPerk = 325;
	if (level.script == "zm_buried")
	{
		yPerk = 300;
	}
	if (level.script == "zm_tomb")
	{
		yPerk = 275;
	}

    	x = -408;
	for(i = 0; i < self.perkarray.size; i++)
	{
		if (type == "custom")
		{
			x += 15;
		}	
	}
	/*if (perk == "custom")
	{
		for(i = 0; i < self.perkarray.size; i++)
		{
    			self.perkarray[i].x = self.perkarray[i].x + 30;
		}
	}*/
        if(perk == "Downers_Delight")
        {
            self.perk1back = self drawshader( "specialty_marathon_zombies", x, yPerk, 24, 24, ( 0, 0, 0 ), 100, 0 );  
            self.perk1front = self drawshader( "waypoint_revive", x, yPerk, 23, 23, ( 0, 1, 1 ), 100, 0 ); 
            self.perk1front.name = perk;
			self.perkarray[self.perkarray.size] = self.perk1front;
			self.perk1back.name = perk;
			self.perkarray[self.perkarray.size] = self.perk1back;
			self.num_perks++;
			self thread DDown();
			if(print)
			{
				self iprintln("^5Downer's Delight");
				wait 0.2;
				self iprintln("This Perk will increase players bleedout time by 10 seconds and current weapons is used in laststand.");
			}
		}
        if(perk == "MULE")
        {   
            self.perk2back = self drawshader( "specialty_marathon_zombies", x, yPerk, 24, 24, ( 0, 0, 0 ), 100, 0 );
            self.perk2front = self drawshader( "menu_mp_weapons_1911", x, yPerk, 22, 22, ( 0, 1, 0 ), 100, 0 );
            self.perk2front.name = perk;
			self.perkarray[self.perkarray.size] = self.perk2front;
			self.perk2back.name = perk;
            self.perkarray[self.perkarray.size] = self.perk2back;
			self.num_perks++;
			if(print)
			{
				self iprintln("^2Mule Kick");
				wait 0.2;
				self iprintln("This Perk enables additional primary weapon slot for player. ");
			}
		}
        if(perk == "PHD_FLOPPER")
        {    
            self.perk3back = self drawshader( "specialty_marathon_zombies", x, yPerk, 24, 24, ( 0, 0, 0 ), 100, 0 );
            self.perk3front = self drawshader( "hud_icon_sticky_grenade", x, yPerk, 23, 23, (1, 0, 1 ), 100, 0 );
            self.perk3front.name = perk;
			self.perkarray[self.perkarray.size] = self.perk3front;
			self.perk3back.name = perk;
            self.perkarray[self.perkarray.size] = self.perk3back;
			self.num_perks++;
			if(print)
			{
				self iprintln("^6PhD Flopper");
				wait 0.2;
				self iprintln("This Perk removes explosion and fall damage also player creates explosion when dive to prone.");
			}
		}
        if(perk == "Victorious_Tortoise")
        {    
            self.perk4back = self drawshader( "specialty_marathon_zombies", x, yPerk, 24, 24, ( 0, 200, 0 ), 100, 0 );
            self.perk4front = self drawshader( "zombies_rank_2", x, yPerk, 23, 23, ( 1, 1, 1 ), 100, 0 );
            self.perk4front.name = perk;
			self.perkarray[self.perkarray.size] = self.perk4front;
			self.perk4back.name = perk;
            self.perkarray[self.perkarray.size] = self.perk4back;
			self.num_perks++;
			self thread start_vt();
			if(print)
			{
				self iprintln("^9Victorious Tortoise");
				wait 0.2;
				self iprintln("This Perk allows shield block damage from all directions when in use.");
        	}
		}
        if(perk == "ELECTRIC_CHERRY")
        {    
            self.perk5back = self drawshader( "specialty_marathon_zombies", x, yPerk, 24, 24, ( 0, 0, 200 ), 100, 0 );
            self.perk5front = self drawshader( "zombies_rank_5", x, yPerk, 23, 23, ( 1, 1, 1 ), 100, 0 );
            self.perk5front.name = perk;
			self.perkarray[self.perkarray.size] = self.perk5front;
			self.perk5back.name = perk;
            self.perkarray[self.perkarray.size] = self.perk5back;
			self.num_perks++;
			self thread start_ec();
			if(print)
			{
				self iprintln("^5Electric ^1Cherry");
				wait 0.2;
				self iprintln("This Perk creates an electric shockwave around the player whenever they reload.");
        	}
		}	
        if(perk == "WIDOWS_WINE")
        {    
            self.perk6back = self drawshader( "specialty_marathon_zombies", x, yPerk, 24, 24, ( 0, 0, 0 ), 100, 0 );
            self.perk6front = self drawshader( "zombies_rank_3", x, yPerk, 23, 23, ( 1, 1, 1 ), 100, 0 );
            self.perk6front.name = perk;
			self.perkarray[self.perkarray.size] = self.perk6front;
			self.perk6back.name = perk;
            self.perkarray[self.perkarray.size] = self.perk6back;
			self.num_perks++;
			self takeweapon( self get_player_lethal_grenade() );
			self set_player_lethal_grenade( "sticky_grenade_zm" );
			self giveweapon("sticky_grenade_zm");
        	self thread ww_nades();
			if(print)
			{
				self iprintln("^8Widow's Wine");
				wait 0.2;
				self iprintln("This Perk damages zombies around the player when player is hit and grenades are upgraded.");
        	}
		}
        if(perk == "Time_Slip")
        {    
            self.perk7back = self drawshader( "specialty_marathon_zombies", x, yPerk, 24, 24, ( 200, 0, 0 ), 100, 0 );
            self.perk7front = self drawshader( "zombies_rank_4", x, yPerk, 23, 23, ( 1, 1, 1 ), 100, 0 );
			self.perk7front.name = perk;
			self.perkarray[self.perkarray.size] = self.perk7front;
			self.perk7back.name = perk;
            self.perkarray[self.perkarray.size] = self.perk7back;
			self.num_perks++;

			self.has_timeslip = 1;
			if(print)
			{
				self iprintln("^6Time Slip");
				wait 0.2;
				self iprintln("Increase Box speed, PaP speed, reduce AATs cooldown");
				wait 0.2;
				self iprintln("Remove perk drinking & knuckle crack animation");
        	}
		}
		if(perk == "Ammo_Regen")
        {
            self.perk8back = self drawshader( "specialty_marathon_zombies", x, yPerk, 24, 24, ( 0, 0, 0 ), 100, 0 );
            self.perk8front = self drawshader( "menu_mp_lobby_icon_customgamemode", x, yPerk, 23, 23, ( 1, 1, 1 ), 100, 0 );
            self.perk8front.name = perk;
			self.perkarray[self.perkarray.size] = self.perk8front;
			self.perk8back.name = perk;
            self.perkarray[self.perkarray.size] = self.perk8back;
			self.num_perks++;
			self thread ammoregen();
            self thread grenadesregen();
			if(print)
			{
				self iprintln("^9Ammo Regen");
				wait 0.2;
				self iprintln("This Perk will slowly regenerades players ammonation and grenades.");			
			}
		}
        if(perk == "Burn_Heart")
        {
            self.perk9back = self drawshader( "specialty_marathon_zombies", x, yPerk, 24, 24, ( 200, 0, 0 ), 100, 0 );
            self.perk9front = self drawshader( "faction_cdc", x, yPerk, 23, 23, ( 1, 1, 1 ), 100, 0 );
            self.perk9front.name = perk;
			self.perkarray[self.perkarray.size] = self.perk9front;
			self.perk9back.name = perk;
            self.perkarray[self.perkarray.size] = self.perk9back;
			self.num_perks++;
            self.ignore_lava_damage = 1;
			if(print)
			{
				self iprintln("^1Burn Heart");
				wait 0.2;
				self iprintln("This Perk removes lava damage.");
			}
		}
        if(perk == "Dying_Wish")
        {
            self.perk10back = self drawshader( "specialty_marathon_zombies", x, yPerk, 24, 24, ( 200, 0, 0 ), 100, 0 );
            self.perk10front = self drawshader( "zombies_rank_5", x, yPerk, 23, 23, ( 1, 1, 1 ), 100, 0 );
            self.perk10front.name = perk;
			self.perkarray[self.perkarray.size] = self.perk10front;
			self.perk10back.name = perk;
            self.perkarray[self.perkarray.size] = self.perk10back;
			self.num_perks++;
            self thread dying_wish_checker();
			if(print)
			{
				self iprintln("^3Dying Wish");
				wait 0.2;
				self iprintln("This Perk allow player to go berserker mode for 9 seconds instead of laststand.");
				wait 0.1;
				self iprintln("Cooldown : 5 minutes. Increased by 30s every time the perk is used. Max 10 mins");
			}
		}
        if(perk == "Momentum_Mocha")
        {

            self.perk11back = self drawshader( "specialty_marathon_zombies", x, yPerk, 24, 24, ( 0, 0, 0 ), 100, 0 );
            self.perk11front = self drawshader("specialty_quickrevive_zombies_pro", x, yPerk, 23, 23, ( 1, 1, 1 ), 100, 0 );
            self.perk11front.name = perk;
			self.perkarray[self.perkarray.size] = self.perk11front;
			self.perk11back.name = perk;
            self.perkarray[self.perkarray.size] = self.perk11back;
			self.num_perks++;

			self thread mocha();
			if(print)
			{
				self iprintln("^5Momentum ^3Mocha");
				wait 0.2;
				self iprintln("Gradually increase your speed while sprinting.");
        	}
		}
		if(perk == "Bandolier_Bandit")
		{
			self.perk11back = self drawshader( "specialty_marathon_zombies", x, yPerk, 24, 24, ( 0, 0, 0 ), 100, 0 );
			//self.perk11front = self drawshader(, x, yPerk, 23, 23, ( 1, 1, 1 ), 100, 0 );
			self.perk11front = self drawshader("specialty_instakill_zombies", x, yPerk, 23, 23, ( 1, 1, 1 ), 100, 0 );
			
			self.perk11front.name = perk;
			self.perkarray[self.perkarray.size] = self.perk11front;
			self.perk11back.name = perk;
			self.perkarray[self.perkarray.size] = self.perk11back;
			self.num_perks++;

			self.has_bandolier = 1;
			if (!isdefined(level.first_purchase))
			{
				level.first_purchase = 1;
				if (check_for_botb_port() == true)
					SetDvar( "player_clipsizemultiplier", 2 );
				else
					SetDvar( "player_clipsizemultiplier", 1.5 );
				level thread bandolier_watcher();
			}

			self notify("bandolier_purchased");

			for (;;)
			{
				if (self GetCurrentWeapon() != "zombie_perk_bottle_jugg" && self GetCurrentWeapon() != "knife_zm")
					break;
				wait 0.1;
			}
			wait 0.1;
			if (!isdefined(self.got_bb))
			{
				primaryweapons = self getweaponslistprimaries();
				foreach(weapon in primaryweapons)
				{
					self SetWeaponAmmoStock(weapon, 99999);
					self SetWeaponAmmoClip(weapon, 99999);
				}
				self.got_bb = 1;
			}


			if(print)
			{
				self iprintln("^9Bandolier Bandit");
				wait 0.2;
				self iprintln("Increase weapon clip & stock ammo capacity.");
			}
		}
}

bandolier_watcher()
{
	level endon("game_ended");

	foreach(player in level.players)
	{
		if (!isdefined(player.has_bandolier) || (player.has_bandolier == 0))
			player thread bandolier();
	}
	for (;;)
	{
		level waittill("connected", player);
		player thread bandolier();
	}
}

bandolier()
{
    self endon("disconnect");
    level endon("game_ended");
	self endon("bandolier_purchased");

    self thread reload_watcher();
    for (;;)
    {   
        weapon = self GetCurrentWeapon();
		if (weapon == "m32_zm" || weapon == "m32_upgraded_zm"
		|| weapon == "judge_zm" || weapon == "judge_upgraded_zm"
		|| weapon == "python_zm" || weapon == "python_upgraded_zm"
		|| weapon == "870mcs_zm" || weapon == "870mcs_upgraded_zm")
		{
			wait 0.1;
			continue;
		}
        stockmax = weaponmaxammo( weapon ) / float(getdvar("player_clipsizemultiplier"));
        clipmax = weaponclipsize( weapon ) / float(getdvar("player_clipsizemultiplier"));
		if (clipmax < 1)
			clipmax = 1;
		if (weapon == "minigun_alcatraz_zm")
		{
			stockmax = 300;
			clipmax = 150;
		}
		if (weapon == "minigun_alcatraz_upgraded_zm")
		{
			stockmax = 550;
			clipmax = 550;
		}
		if (weapon == "raygun_mark2_upgraded_zm")
			stockmax = 159;
		if (weapon == "raygun_mark2_zm")
			stockmax = 141;
		if (weapon == "ray_gun_zm")
			stockmax = 140;
		if (weapon == "raygun_mark2_zm")
			stockmax = 160;		
		if (weapon == "slipgun_zm")
			stockmax = 30;		
		if (weapon == "knife_ballistic_zm" || weapon == "knife_ballistic_bowie_zm")
			stockmax = 3;
		if (weapon == "knife_ballistic_zm" || weapon == "knife_ballistic_bowie_upgraded_zm")
			stockmax = 8;
        if (self GetWeaponAmmoStock(weapon) > int(stockmax))
            self SetWeaponAmmoStock(weapon, int(stockmax));
         if (self GetWeaponAmmoClip(weapon) > int(clipmax))
            self SetWeaponAmmoClip(weapon, int(clipmax));       
        wait .05;
    }
}

reload_watcher()
{
    self endon("disconnect");
    level endon("game_ended");
	self endon("bandolier_purchased");

    while ( true )
    {
        self waittill("reload");
        weapon = self GetCurrentWeapon();
			if (weapon == "m32_zm" || weapon == "m32_upgraded_zm"
			|| weapon == "judge_zm" || weapon == "judge_upgraded_zm"
			|| weapon == "python_zm" || weapon == "python_upgraded_zm"
			|| weapon == "870mcs_zm" || weapon == "870mcs_upgraded_zm")
			{
				wait 0.1;
				continue;
			}
			current_stock_ammo = int(self GetWeaponAmmoStock(weapon));
			current_clip_ammo = self GetWeaponAmmoClip(weapon);
			max_clip_ammo = weaponclipsize( weapon ) / float(getdvar("player_clipsizemultiplier"));
			self SetWeaponAmmoStock(weapon, int(current_stock_ammo + (current_clip_ammo - max_clip_ammo)));

    }
}

mocha()
{
	level endon("game_ended");
	self endon("disconnected");
	self endon("stopcustomperk");

    for (;;)
    {
		if (check_for_botb_port() == true && isdefined(level.final_wave))
		{
			return;
		}
        if (!self SprintButtonPressed())
        {
            if (!isdefined(self.base_speed))
                self.base_speed = self GetMoveSpeedScale();
			if (isdefined(self.old_speed))
				self SetMoveSpeedScale(self.old_speed * 0.65);
			else if (self HasPerk("specialty_longersprint"))
				self SetMoveSpeedScale(self.base_speed + 0.07);
			else 
            	self SetMoveSpeedScale(self.base_speed);
        }
        else
        {
            speed = self GetMoveSpeedScale();
			if (check_for_botb_port() == true)
			{
				if (isdefined(self.old_speed))
				{
					if (speed > 1.1)
						speed = 1.1;
					speed += 0.02;
				}
				else
				{
					if (speed > 1.7)
						speed = 1.7;    
					speed += 0.03;
				}

			}
			else
			{
				if (speed > 1.5)
					speed = 1.5;    
				speed += 0.01;
			}

            self SetMoveSpeedScale(speed);
        }
        wait 0.25;
    }
}

custom_get_player_weapon_limit( player )
{
	level endon("end_game");
	self endon("disconnect");
    weapon_limit = 2;
    if ( player hascustomperk("MULE") )
    {
        weapon_limit = 3;
    } 
	else 
	{
        weapons = self getWeaponsListPrimaries();
        if(weapons.size > 2)
		{
            self takeWeapon(weapons[2]);
        }
    }
    return weapon_limit;
}

ammoregen()
{
	self endon( "disconnect" );
	level endon( "end_game" );
	self endon( "stopcustomperk" );
	for(;;)
	{
		curr_weapon = self GetCurrentWeapon();
		if (curr_weapon == "time_bomb_zm" || curr_weapon == "time_bomb_detonator_zm"
		|| curr_weapon == "cymbal_monkey_zm" || curr_weapon == "beacon_zm")
		{
			wait 2;
		}
		else if (curr_weapon == "ray_gun_upgraded_zm" || curr_weapon == "ray_gun_zm" || curr_weapon == "raygun_mark2_zm" || curr_weapon == "raygun_mark2_upgraded_zm"
		|| curr_weapon == "m1911_upgraded_zm" || curr_weapon == "usrpg_upgraded_zm" || is_grenade_launcher( curr_weapon))
		{
			stockcount = self getweaponammostock( curr_weapon );
			self setWeaponAmmostock( curr_weapon, stockcount + 1 );
			wait 2;
		}
		else if(!curr_weapon == "" && curr_weapon != "slipgun_zm"
		&& curr_weapon != "staff_fire_zm" && curr_weapon != "staff_fire_upgraded_zm" 
		&& curr_weapon != "staff_air_zm" && curr_weapon != "staff_air_upgraded_zm" 
		&& curr_weapon != "staff_water_zm" && curr_weapon != "staff_water_upgraded_zm"
		&& curr_weapon != "staff_lightning_zm" && curr_weapon != "staff_lightning_upgraded_zm"
		&& curr_weapon !=  "blundersplat_upgraded_zm" && curr_weapon !=  "blundersplat_zm")
		{
			stockcount = self getweaponammostock( curr_weapon );
			self setWeaponAmmostock( curr_weapon, stockcount + 5 );
			wait 2;
		}
		wait 0.1;
	}
}

grenadesregen()
{
	self endon( "disconnect" );
	level endon( "end_game" );
	self endon( "stopcustomperk" );
	for(;;)
	{
		grenades = self get_player_lethal_grenade();
        grenade_count = self getweaponammoclip(grenades);
        if(grenade_count < 4)
		{
        	self setweaponammoclip(grenades, (grenade_count + 1));
		}
		tactical_grenades = self get_player_tactical_grenade();
        tactical_grenade_count = self getweaponammoclip(tactical_grenades);
        if(tactical_grenade_count < 3 )
		{
        	self setweaponammoclip(tactical_grenades, (tactical_grenade_count + 1));
		}
		wait 300;
	}
}

start_ec()
{
	level endon("end_game");
	self endon("disconnect");
	self endon("stopcustomperk");
	for(;;)
	{
		self waittill( "reload_start" );
    	playfxontag( level._effect[ "poltergeist"], self, "J_SpineUpper" );
		self EnableInvulnerability();
		RadiusDamage(self.origin, 120, 200, 100, self);
		self DisableInvulnerability();
		self playsound( "zmb_turbine_explo" );
		wait 1;
	}
}

start_vt()
{
	level endon("end_game");
	self endon("disconnect");
	self endon("stopcustomperk");
	for(;;)
	{
		if(self getcurrentweapon() == "riotshield_zm" )
		{
			self enableInvulnerability();
			self.shielddamagetaken += 100;
			wait 0.9;
		}
		else
		{
			self disableInvulnerability();
		}
		wait 0.1;
	}
}

start_er()
{
    level endon("end_game");
    self endon("disconnect");
    self endon("stopcustomperk");
    for(;;)
    {
        if (self hascustomperk("Ethereal_Razor") && self ismeleeing())
        {
            self.health += 20;
            if(self.health > self.maxhealth)
			{
                self.health = self.maxhealth;
            }
            while(self ismeleeing())
			{
                wait 0.1;
            }
        }
        wait 0.05;
    }
}

LastStand()
{
	level endon("end_game");
	self endon("disconnect");
    if(self hascustomperk("Downers_Delight"))
	{
        self.customlaststandweapon = self getcurrentweapon();
		self switchtoweapon( self.customlaststandweapon );
		self setweaponammoclip( self.customlaststandweapon, 150 );
		self.bleedout_time = 40;
    } 
	else 
	{
        self maps\mp\zombies\_zm::last_stand_pistol_swap();
    }
}

DDown() 
{
	self endon( "disconnect" );
	level endon( "end_game" );
	self endon( "stopcustomperk" );
	for(;;)
	{
		self waittill("player_downed");
		self playsound( "zmb_phdflop_explo" );
		playfx(loadfx("explosions/fx_default_explosion"), self.origin, anglestoforward( ( 0, 45, 55  ) ) );
		RadiusDamage(self.origin, 150, 600, 400, self);
		wait 0.1;
	}
}

doGivePerk(perk)
{
    self endon("disconnect");
    self endon("death");
    level endon("game_ended");
    self endon("perk_abort_drinking");
    if (!(self hasperk(perk) || (self maps\mp\zombies\_zm_perks::has_perk_paused(perk))))
    {
        gun = self maps\mp\zombies\_zm_perks::perk_give_bottle_begin(perk);
      //  evt = self waittill_any_return("fake_death", "death", "player_downed", "weapon_change_complete");
       // if (evt == "weapon_change_complete")
		self thread maps\mp\zombies\_zm_perks::wait_give_perk(perk, 1);
        self maps\mp\zombies\_zm_perks::perk_give_bottle_end(gun, perk);
        if (self maps\mp\zombies\_zm_laststand::player_is_in_laststand() || isDefined(self.intermission) && self.intermission)
            return;
        self notify("burp");
    }
}


SpawnHint( origin, width, height, cursorhint, string )
{
	level endon("end_game");
	self endon("disconnect");
	hint = spawn( "trigger_radius", origin, 1, width, height );
	hint setcursorhint( cursorhint, hint );
	hint sethintstring( string );
	hint setvisibletoall();
	wait 0.2;
	hint delete();
}


ww_points( player )
{
	level endon("end_game");
	self endon("disconnect");
    for(i = 0; i < 3; i++)
    {
		self maps\mp\zombies\_zm_utility::set_zombie_run_cycle("walk");
        player scripts\points_multiplier::doublepoints(player, 0, 10);
        PlayFXOnTag(level.effect_WebFX,self,"j_spineupper");
        self doDamage(150, (0, 0, 0));
        wait 1;
    }
}

ww_nade_explosion()
{
	level endon("end_game");
	self endon("disconnect");
    wait 2;
 //   if( self maps/mp/zm_transit_lava::object_touching_lava())
//	{
 //       self delete();
  //      return 0;
  //  }
	foreach(zombie in getAiArray(level.zombie_team))
	{
        if( distance( zombie.origin, self.origin ) < 210 )
		{
            zombie thread ww_points( self );
        }
    }
    self delete();
}

ww_nades()
{
    level endon("end_game");
    self endon("disconnect");
    self endon("stopcustomperk");
    for(;;)
	{
        self waittill( "grenade_fire", grenade, weapname );
        if( weapname == "sticky_grenade_zm" )
		{
            ww_nade = spawnsm( grenade.origin, "zombie_bomb" );
            ww_nade hide();
            ww_nade linkto( grenade );
            ww_nade thread ww_nade_explosion();
        }
    }
}

spawnsm( origin, model, angles )
{
	level endon("end_game");
	self endon("disconnect");
    ent = spawn( "script_model", origin );
    ent setmodel( model );
    if( IsDefined( angles ) )
    {
        ent.angles = angles;
    }
    return ent;
}

dying_wish_checker()
{
    level endon("end_game");
    self endon("disconnect");
    self endon( "stopcustomperk" );
    self.dying_wish_uses = 0;
    for(;;)
	{
        self.dying_wish_on_cooldown = 0;
        self.perk10back.alpha = 1;
        self.perk10front.alpha = 1;
        self waittill("dying_wish_charge");
        self.perk10back.alpha = 0.3;
        self.perk10front.alpha = 0.4;
        self.dying_wish_uses++;
		if (check_for_botb_port() == true || getDvar("isPanzer") == "1")
		{
			self.perk10back.alpha = 0;
			self.perk10front.alpha = 0;
			for (;;)
			{
        		self.dying_wish_on_cooldown = 1;
				wait 1;
			}
			return;
		}
        self.dying_wish_on_cooldown = 1;
        delay = 300 + (self.dying_wish_uses * 30);
        if(delay >= 600)
        delay = 600;
        wait delay;
    }
}

dying_wish_effect()
{
	level endon("end_game");
	self endon("disconnect");
    self enableInvulnerability();
    self.ignoreme = 1;
	self thread perma_ignore();
    self useServerVisionSet(true);
    self setvisionsetforplayer( "zombie_death", 0 );
   // self freezeControls(1); disabled
  //  wait 1;
  //  self freezeControls(0);
    wait 8;
	self notify("afk_end");
	if (getDvar("isBus") == "1")
	{
		self.health = 150;
	}
	else if (getDvar("isBus") == "0")
	{
		self.health = 1;
	}
    self disableInvulnerability();
    self.ignoreme = 0;
    self useServerVisionSet(false);
    self setvisionsetforplayer("remote_mortar_enhanced", 0);
}

perma_ignore()
{
    self endon("afk_end");
    self endon("disconnected");

    for (;;)
    {
        self.ignoreme = 1;
        wait 0.5;
    }
}
//-------------------ENDCUSTOMPERK------------------------











































playerdamagelastcheck( einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime )
{
	players = get_players();
	for(i=0;i<players.size;i++)
	{
		if( isdefined(players[i].gluster_grenade) && eattacker == players[i].gluster_grenade )
			return 0;
		
		if( isdefined(players[i].firework_weapon) && eattacker == players[i].firework_weapon )
			return 0;
	}

	if (level.script == "zm_tomb") //called from zm_tomb.gsc
	{
		if ( isdefined( sweapon ) )
		{
			if ( issubstr( sweapon, "staff" ) )
				return 0;
			else if ( sweapon == "t72_turret" )
				return 0;
			else if ( sweapon == "quadrotorturret_zm" || sweapon == "quadrotorturret_upgraded_zm" )
				return 0;
			else if ( sweapon == "zombie_markiv_side_cannon" )
				return 0;
			else if ( sweapon == "zombie_markiv_turret" )
				return 0;
			else if ( sweapon == "zombie_markiv_cannon" )
				return 0;
		}
	}
//-------------------CUSTOMPERK------------------------
    if( isDefined( eAttacker.is_zombie ) && eAttacker.is_zombie && self hascustomperk("WIDOWS_WINE") )
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
					zombie thread ww_points( self );
				}
            }
		}
    }
	if(self hascustomperk("PHD_FLOPPER"))
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
	if(idamage > self.health && !self.dying_wish_on_cooldown && self hascustomperk("Dying_Wish") )
	{
			self notify("dying_wish_charge");
			self thread dying_wish_effect();
			return 0;
	}

//-------------------ENDCUSTOMPERK------------------------
	if (level.script == "zm_prison")
	{
	//	scripts\zm\zm_prison\motd_perk_back::playerDamageLastCheckMOTD(einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime);
	}
	return idamage;
}

vector_scal( vec, scale )
{
	vec = ( vec[ 0] * scale, vec[ 1] * scale, vec[ 2] * scale );
	return vec;
}

vending_weapon_upgrade_cost()
{
	level endon("end_game");
	for( ;; )
	{
		level waittill( "powerup bonfire sale" );
		level._bonfire_sale = 1;
		level waittill( "bonfire_sale_off" );
		level._bonfire_sale = 0;
	}
}

pap_off()
{
	level endon("end_game");
	wait 5;
	for(;;)
	{
		level waittill("Pack_A_Punch_on");
		wait 1;
		level notify("Pack_A_Punch_off");
	}
}

new_pap_trigger()
{
	level endon("end_game");
    flag_wait( "initial_blackscreen_passed" );
    
    if (check_for_botb_port() == true)
        return;
    for (;;)
    {
        if (getDvar("isPanzer") == "1")
        {
            return;
        }
        else if (getDvar("isPanzer") == "0")
        {
            break;
        }
        wait 0.5;
    }
    for (;;)
    {
        if (getDvar("isBus") == "1")
        {
            return;
        }
        else if (getDvar("isBus") == "0")
        {
            break;
        }
        wait 0.5;
    }
	if(getDvar( "g_gametype" ) == "zgrief")
		return;
	thread vending_weapon_upgrade_cost();
    level waittill("Pack_A_Punch_on");
    wait 2;
	
	if(getdvar( "mapname" ) != "zm_transit" && getdvar ( "g_gametype") != "zstandard")
	{
		level notify("Pack_A_Punch_off");
		level thread pap_off();
	}

    if( getdvar( "mapname" ) == "zm_nuked" )
        level waittill( "Pack_A_Punch_on" );
    
	perk_machine = getent( "vending_packapunch", "targetname" );
    pap_triggers = getentarray( "specialty_weapupgrade", "script_noteworthy" );
    pap_triggers[0] delete();
	if( getdvar( "mapname" ) == "zm_transit" && getdvar ( "g_gametype")  == "zclassic" )
	{
		if(!level.buildables_built[ "pap" ])
			level waittill("pap_built");
	}
	wait 1;
	self.perk_machine = perk_machine;
	perk_machine_sound = getentarray( "perksacola", "targetname" );
	packa_rollers = spawn( "script_origin", perk_machine.origin );
	packa_timer = spawn( "script_origin", perk_machine.origin );
	packa_rollers linkto( perk_machine );
	packa_timer linkto( perk_machine );
	if( getdvar( "mapname" ) == "zm_highrise" )
	{
		Trigger = spawn( "trigger_radius", perk_machine.origin, 1, 60, 80 );
		Trigger enableLinkTo();
		Trigger linkto(self.perk_machine);
	}
	else
		Trigger = spawn( "trigger_radius", perk_machine.origin, 1, 35, 80 );
	
    
	Trigger SetCursorHint( "HINT_NOICON" );
    Trigger sethintstring( "			Hold ^3&&1^7 for Pack-a-Punch [Cost: 5000] \n Weapons can be pack a punched multiple times" );
	
    cost = 5000;

	Trigger usetriggerrequirelookat();
	for(;;)
	{
		Trigger waittill("trigger", player);
		current_weapon = player getcurrentweapon();
        if(current_weapon == "saritch_upgraded_zm+dualoptic" || current_weapon == "dualoptic_saritch_upgraded_zm+dualoptic" || current_weapon == "slowgun_upgraded_zm" || current_weapon == "staff_air_zm" || current_weapon == "staff_lightning_zm" || current_weapon == "staff_fire_zm" || current_weapon == "staff_water_zm" )
        {
            Trigger sethintstring( "^1This weapon can not be upgraded." );
			wait .05;
            continue;
        }
		
		if(player UseButtonPressed() && player.score >= cost && current_weapon != "riotshield_zm" && player can_buy_weapon() && !player.is_drinking && !is_placeable_mine( current_weapon ) && !is_equipment( current_weapon ) && level.revive_tool != current_weapon && current_weapon != "none" )
        {
			player.score -= cost;
            player thread maps\mp\zombies\_zm_audio::play_jingle_or_stinger( "mus_perks_packa_sting" );
			trigger setinvisibletoall();
			upgrade_as_attachment = will_upgrade_weapon_as_attachment( current_weapon );
            
            player.restore_ammo = undefined;
            player.restore_clip = undefined;
            player.restore_stock = undefined;
            player.restore_clip_size = undefined;
            player.restore_max = undefined;
            
            player.restore_clip = player getweaponammoclip( current_weapon );
            player.restore_clip_size = weaponclipsize( current_weapon );
            player.restore_stock = player getweaponammostock( current_weapon );
            player.restore_max = weaponmaxammo( current_weapon );
            
			if (!isdefined(player.has_timeslip) || player.has_timeslip == 0)
				player thread maps\mp\zombies\_zm_perks::do_knuckle_crack();
			wait .1;
			player takeWeapon(current_weapon);
			current_weapon = player maps\mp\zombies\_zm_weapons::switch_from_alt_weapon( current_weapon );
			self.current_weapon = current_weapon;
			upgrade_name = maps\mp\zombies\_zm_weapons::get_upgrade_weapon( current_weapon, upgrade_as_attachment );
			player third_person_weapon_upgrade( current_weapon, upgrade_name, packa_rollers, perk_machine, self );
			trigger sethintstring( &"ZOMBIE_GET_UPGRADED" );
			trigger thread wait_for_pick(player, current_weapon, self.upgrade_name);

			if ( isDefined( player ) )
			{
				Trigger setinvisibletoall();
				Trigger setvisibletoplayer( player );
			}
			self thread wait_for_timeout( current_weapon, packa_timer, player );
			self waittill_any( "pap_timeout", "pap_taken", "pap_player_disconnected" );
			self.current_weapon = "";

			if ( isDefined( self.worldgun ) && isDefined( self.worldgun.worldgundw ) )
				self.worldgun.worldgundw delete();
			
			if ( isDefined( self.worldgun ) )
				self.worldgun delete();
			
			Trigger setinvisibletoplayer( player );
			wait 1.5;
			Trigger setvisibletoall();
				
			self.current_weapon = "";
			self.pack_player = undefined;
			flag_clear( "pack_machine_in_use" );
		}
		weapon = player getcurrentweapon();
		if(isdefined(level._bonfire_sale) && level._bonfire_sale)
		{
			Trigger sethintstring( "			Hold ^3&&1^7 for Pack-a-Punch [Cost: 1000] \n Weapons can be pack a punched multiple times" );
			cost = 1000;
		}
		else if(is_weapon_upgraded(weapon))
		{
			Trigger sethintstring( "			Hold ^3&&1^7 for Pack-a-Punch [Cost: 2500] \n Weapons can be pack a punched multiple times" );
			cost = 2500;
		}
		else
		{
			Trigger sethintstring( "			Hold ^3&&1^7 for Pack-a-Punch [Cost: 5000] \n Weapons can be pack a punched multiple times" );
			cost = 5000;
		}
		wait .1;
	}
}

wait_for_pick(player, weapon, upgrade_weapon)
{
	level endon( "pap_timeout" );
	level endon("end_game");
	for (;;)
	{
		self playloopsound( "zmb_perks_packa_ticktock" );
		self waittill( "trigger", user );
		if(user UseButtonPressed() && player == user)
		{	
			self stoploopsound( 0.05 );
			player thread do_player_general_vox( "general", "pap_arm2", 15, 100 );

            base = get_base_name(weapon);
			if(is_weapon_upgraded( weapon ))
			{
				player.restore_ammo = 1;
                
				if( weapon == "galil_upgraded_zm+reflex" || weapon  == "fnfal_upgraded_zm+reflex" || base == "ak74u_upgraded_zm" || base  == "galil_upgraded_zm"  || base  == "fnfal_upgraded_zm")
                	player thread give_aat(weapon); //Alternative ammo type for galil and fnfal upgraded
				else
					player thread give_aat(upgrade_weapon); //Alternative ammo type for all other weapons
			}
			else if( weapon == "galil_upgraded_zm+reflex" || weapon  == "fnfal_upgraded_zm+reflex" || base == "ak74u_upgraded_zm" )
			{
				player giveweapon( weapon, 0, player maps\mp\zombies\_zm_weapons::get_pack_a_punch_weapon_options( weapon ));
				player switchToWeapon( weapon );
            }

			weapon_limit = get_player_weapon_limit( player );
			player maps\mp\zombies\_zm_weapons::take_fallback_weapon();
			primaries = player getweaponslistprimaries();
			
			if ( isDefined( primaries ) && primaries.size >= weapon_limit )
				player maps\mp\zombies\_zm_weapons::weapon_give( upgrade_weapon );
			else
				player giveweapon( upgrade_weapon, 0, player maps\mp\zombies\_zm_weapons::get_pack_a_punch_weapon_options( upgrade_weapon ));

			player switchToWeapon( upgrade_weapon );
			x = upgrade_weapon;
            
			if ( isDefined( player.restore_ammo ) && player.restore_ammo )
			{
				new_clip = player.restore_clip + ( weaponclipsize( x ) - player.restore_clip_size );
				new_stock = player.restore_stock + ( weaponmaxammo( x ) - player.restore_max );
				player setweaponammostock( x, new_stock );
				player setweaponammoclip( x, new_clip );
			}
			level notify( "pap_taken" );
			player notify( "pap_taken" );
			break;
		}
		wait .1;
	}
}

aat_zombie_damage_response( mod, hit_location, hit_origin, attacker, amount )
{
	weapons_inventory = attacker GetWeaponsListPrimaries();
	current_weapon = attacker GetCurrentWeapon();
	index = 0;
	weapon_match = 0;
	for (i = 0; i < weapons_inventory.size; i++)
	{
		if (current_weapon == weapons_inventory[i])
		{
			index = i;
			weapon_match = 1;
			break;
		}
	}
	if (weapon_match == 0)
		return;

    if(!can_aat_damage(self))
		return 0;

	player = attacker;
	if(isdefined( self.damageweapon ))
	{
		if(isdefined( attacker ) && isplayer( attacker ))
		{
            zombies = getaiarray( level.zombie_team );

            if(self turned_zombie_validation() && !is_true(player.active_turned) && isdefined(player.aat[self.damageweapon]) && player.aat[self.damageweapon] == "Turned")
            {
				attacker.aat_activated = 1;
                attacker thread Cooldown("Turned");
                self thread turned( attacker );
                return 1;
            }
            if(isdefined(attacker.aat[self.damageweapon]) && attacker.aat[self.damageweapon] == "Cluster")
            {
				attacker.aat_activated = 1;
                attacker thread Cooldown("Cluster");
                self thread cluster( attacker );
                return 1;
            }
            if(player.weapons_aat_cooldown[index] == 0 && isdefined(player.aat[self.damageweapon]) && player.aat[self.damageweapon] == "Headcutter")
            {
				attacker.aat_activated = 1;
                attacker thread Cooldown("Headcutter");
				max_kills = 12;
				killed = 0;
                for( i = 0; i < zombies.size; i++ )
                {
					if (killed >= max_kills)
						break;
                    if(distance(self.origin, zombies[i].origin) <= 300)
                    {
                        if(!zombies[i].done && can_aat_damage(zombies[i]))
                        {
                            zombies[i].done = 1;
                            zombies[i] thread Headcutter(attacker);
							killed++;
                        }
                    }
                }
                return 1;
            }
            if(player.weapons_aat_cooldown[index] == 0 && isdefined(player.aat[self.damageweapon]) && player.aat[self.damageweapon] == "Thunder Wall")
            {
				attacker.aat_activated = 1;
                attacker setclientdvar( "ragdoll_enable", 1);
				attacker thread Cooldown("Thunder Wall"); //switched cuz thunderwall thread prolly crashing and not going on cd
                self thread thunderwall(attacker);
                return 1;
            }
            if(player.weapons_aat_cooldown[index] == 0 && isdefined(player.aat[self.damageweapon]) && player.aat[self.damageweapon] == "Blast Furnace")
            {
				attacker.aat_activated = 1;
                attacker thread Cooldown("Blast Furnace");
                PlayFXOnTag(level._effect[ "character_fire_death_torso" ], self, "j_spinelower");
                PlayFXOnTag(level._effect[ "character_fire_death_sm" ], self, "j_spineupper");
				max_kills = 12;
				killed = 0;
                for( i = 0; i < zombies.size; i++ )
                {
					if (killed >= max_kills)
						break;
                    if(distance(self.origin, zombies[i].origin) <= 300 && can_aat_damage(zombies[i]))
					{
                        zombies[i] thread flames_fx(attacker);
						killed++;
					}
                }
                return 1;
            }
            if(player.weapons_aat_cooldown[index] == 0 && isdefined(player.aat[self.damageweapon]) && player.aat[self.damageweapon] == "Fireworks")
            {
				attacker.aat_activated = 1;
                attacker thread Cooldown("Fireworks");
                self thread spawn_weapon( attacker );
                self thread fireworks();
                return 1;
            }
			if(player.weapons_aat_cooldown[index] == 0 && isdefined(player.aat[self.damageweapon]) && player.aat[self.damageweapon] == "Cryo Freeze" )
			{
				self thread cryofreeze_zombie_damage_response(attacker);
				return true;
			}
			if(player.weapons_aat_cooldown[index] == 0 && isdefined(player.aat[self.damageweapon]) && player.aat[self.damageweapon] == "Dead Wire" )
			{
				attacker.aat_actived = 1;
				attacker thread Cooldown("Dead Wire");
				self thread deadwire_zombie_damage_response(attacker);
				return true;
			}
		}
	}
	return 0;
}

deadwire_zombie_damage_response(attacker)
{
	level endon("end_game");
	attacker endon("disconnect");

	max_kills = 12;
	ai_zombies = get_array_of_closest( self.origin, getaiarray( level.zombie_team ), undefined, undefined, 300);
	for ( i = 0; i < ai_zombies.size; i++ )
	{
		if (i >= max_kills)
			break;
		ai_zombies[i] thread deadwire_fx();
/*		if (is_true( ai_zombies[i].has_legs ))
			ai_zombies[i].deathanim = "zm_death_tesla";
		else
			ai_zombies[i].deathanim = "zm_death_tesla_crawl";*/
		ai_zombies[i] DoDamage( ai_zombies[i].health + 666, ai_zombies[i].origin);
		attacker.kills++;
		attacker scripts\points_multiplier::doublepoints(attacker, 0, 50);
		wait 0.20;
	}
}

deadwire_fx()
{
	fx = Spawn( "script_model", self GetTagOrigin( "j_spinelower" ) );
	fx.angles = self GetTagAngles( "j_spinelower" );
	fx SetModel( "tag_origin" );
	fx LinkTo( self, "j_spinelower" );

	PlayFxOnTag( level._effect["elec_md"] , fx, "tag_origin" );

	self playsound ("zmb_elec_jib_zombie");
	wait 2.5;
	fx delete();
}

cryofreeze_zombie_damage_response(attacker)
{
	r = randomint(20);
	if ( r > 18)
	{
		attacker.aat_actived = 1;
		self thread cryofreeze_explosion_fx();

		ai_zombies = getaispeciesarray("axis", "all");
		if ( !isDefined( ai_zombies ) )
			return;
		max_kills = 12;

		ai_zombies = get_array_of_closest( self.origin, getaiarray( level.zombie_team ), undefined, undefined, 300);
		for ( i = 0; i < ai_zombies.size; i++ )
		{
			if (i >= max_kills)
				break;
			ai_zombies[i] DoDamage( ai_zombies[i].health + 666, ai_zombies[i].origin, attacker, attacker, "none", "MOD_IMPACT" );
		}
		attacker thread Cooldown("Cryo Freeze");
		return;
	}
	self thread cryofreeze_slow_fx();	
	self set_zombie_run_cycle("walk");
}

cryofreeze_slow_fx()
{
	fx = Spawn( "script_model", self GetTagOrigin( "J_SpineLower" ) );
	fx.angles = self GetTagAngles( "J_SpineLower" );
	fx SetModel( "tag_origin" );
	fx LinkTo( self, "J_SpineLower" );
	fx.origin += (0, 0, -20);

	PlayFxOnTag( level._effect["fx_moon_lamp_glow"] , fx, "tag_origin"  );
	self playsound("wpn_thundergun_proj_impact_zombie");
	wait 2;
	fx delete();
}

cryofreeze_explosion_fx()
{
	fx = Spawn( "script_model", self GetTagOrigin( "J_SpineLower" ) );
	fx.angles = self GetTagAngles( "J_SpineLower" );
	fx SetModel( "tag_origin" );
	fx LinkTo( self, "J_SpineLower" );
	fx.origin += (0, 0, -20);

	PlayFxOnTag( level._effect["rise_burst_water"] , fx, "tag_origin"  );
	self playsound("wpn_thundergun_proj_impact_zombie");
	wait 5;
	fx delete();
}

Cooldown(aat)
{
	cooldown_time = 0;
	weapons_inventory = self GetWeaponsListPrimaries();
	current_weapon = self GetCurrentWeapon();
	index = 0;
	weapon_match = 0;

	for (i = 0; i < weapons_inventory.size; i++)
	{
		if (current_weapon == weapons_inventory[i])
		{
			index = i;
			weapon_match = 1;
			break;
		}
	}
	if (weapon_match == 0)
		return;
	self.weapons_aat_cooldown[index] = 1;

	self.aat_cooldown_duration[index] = 25;
    if (aat == "Thunder Wall")
		self.aat_cooldown_duration[index] = 40;

	if (isdefined(self.has_timeslip) && self.has_timeslip == 1)
		self.aat_cooldown_duration[index] = int(self.aat_cooldown_duration[index] * 0.8);

	for (i = 0; i < (self.aat_cooldown_duration[index] * 20); i++)
	{
		self.aat_remaining_cooldown[index] = (i / 20);
		wait .05;
	}

	self.weapons_aat_cooldown[index] = 0;

	weapons_inventory = self GetWeaponsListPrimaries();
	current_weapon = self GetCurrentWeapon();

	for (i = 0; i < weapons_inventory.size; i++)
	{
		if (current_weapon == weapons_inventory[i])
		{
			if (i != index)
				return;
			else
				break;
		}
	}
	self.is_aat_blinking = 1;
	self playsound ("zmb_cha_ching");
	previous_alpha = self.aat_hud.alpha;
	for  (i = 0; i < 7; i++)
	{
		self.aat_hud.alpha = 1;
		wait 0.1;
		self.aat_hud.alpha = 0.7;		
		wait 0.1;
	}
	if (previous_alpha == 0)
	{
		self.aat_hud fadeovertime( 0.75 );
		self.aat_hud.alpha = 0;
	}
	else
		self.aat_hud.alpha = 0.8;
	self.is_aat_blinking = 0;
}

explosive_bullet()
{
    level endon("end_game");
    self endon("disconnect");
	for( ;; )
	{
		self waittill( "weapon_fired", weapon);
		index = 0;
		weapons_inventory = self GetWeaponsListPrimaries();

		for (i = 0; i < weapons_inventory.size; i++)
		{
			if (weapon == weapons_inventory[i])
			{
				index = i;
				break;
			}
		}
        if(getdvar("mapname") == "zm_tomb" || getdvar("mapname") == "zm_buried")
			fx = level._effect[ "divetonuke_groundhit" ];
        else
            fx = level._effect[ "def_explosion" ];

		if(self.weapons_aat_cooldown[index] == 0 && isdefined(self.aat[weapon]) && self.aat[weapon] == "Explosive")
		{
			self.aat_activated = 1;
			self thread Cooldown("Explosive");
			forward = self gettagorigin( "tag_weapon_right" );
			end = self thread vector_scal( anglestoforward( self getplayerangles() ), 1000000 );
			crosshair_entity = bullettrace(self gettagorigin("tag_weapon_right"),self gettagorigin("tag_weapon_right")+anglestoforward(self getplayerangles())*1000000,true,self)["entity"];
			crosshair = bullettrace( forward, end, 0, self )[ "position"];
			magicbullet( self getcurrentweapon(), self gettagorigin( "j_shouldertwist_le" ), crosshair, self );
			self enableInvulnerability();

			if(isdefined(crosshair_entity))
			{
				crosshair_entity playsound( "zmb_phdflop_explo" );
				playfx(fx, crosshair_entity.origin, anglestoforward( ( 0, 45, 55  ) ) );
				
				ai_zombies = get_array_of_closest( crosshair_entity.origin, getaiarray( level.zombie_team ), undefined, undefined, 300);
				if (!isdefined(ai_zombies))
					continue;
				max_kills = 12;
				for ( i = 0; i < ai_zombies.size; i++ )
				{
					if (i >= max_kills)
						break;
					ai_zombies[i] DoDamage(ai_zombies[i].health + 666, ai_zombies[i].origin);
					self scripts\points_multiplier::doublepoints(self, 0, 25);
					self.kills++;
				}
			}
			else
			{
				crosshair playsound( "zmb_phdflop_explo" );
				playfx(fx, crosshair, anglestoforward( ( 0, 45, 55  ) ) );
				ai_zombies = get_array_of_closest( crosshair, getaiarray( level.zombie_team ), undefined, undefined, 300);
				if (!isdefined(ai_zombies))
					continue;
				max_kills = 12;
				for ( i = 0; i < ai_zombies.size; i++ )
				{
					if (i >= max_kills)
						break;
					ai_zombies[i] DoDamage(ai_zombies[i].health + 666, ai_zombies[i].origin);
					self scripts\points_multiplier::doublepoints(self, 0, 25);
					self.kills++;
				}
			}
            wait .5;
			self disableInvulnerability();
		}
		wait .1;
	}
}

flames_fx(attacker)
{
	for(i = 0; i < 5; i++)
	{
		PlayFXOnTag(level._effect[ "character_fire_death_sm" ], self, "j_spineupper");

		if(i < 3)
		{
			self dodamage(self.health / 2, (0,0,0));
			attacker scripts\points_multiplier::doublepoints(attacker, 0, 10);
		}
		else
		{
			self dodamage(self.maxhealth + 666, (0,0,0));
			attacker scripts\points_multiplier::doublepoints(attacker, 0, 50);
			attacker.kills++;
		}
		wait 1;
	}
}

fireworks()
{
	level endon("end_game");
	origin = self.origin;

	if(getdvar("mapname") == "zm_buried")
    {
		for(i=0;i<10;i++)
        {
			x = randomintrange(-40, 40);
			y = randomintrange(-40, 40);

            up_in_air = origin + (0,0,65);
			up_in_air2 = origin + (x,y,randomintrange(45, 66));
			up_in_air3 = origin + (x,y,randomintrange(45, 66));

            firework = Spawn( "script_model", origin );
            firework SetModel( "tag_origin" );

			firework2 = Spawn( "script_model", origin );
            firework2 SetModel( "tag_origin" );

			firework3 = Spawn( "script_model", origin );
            firework3 SetModel( "tag_origin" );
	
            fx = PlayFxOnTag( level._effect[ "fx_wisp_m" ], firework, "tag_origin");
			fx2 = PlayFxOnTag( level._effect[ "fx_wisp_m" ], firework2, "tag_origin");
			fx3 = PlayFxOnTag( level._effect[ "fx_wisp_m" ], firework3, "tag_origin");
            
			firework moveto(up_in_air, 1);
			firework2 moveto(up_in_air2, randomfloatrange(0.4, 1.1));
            firework3 moveto(up_in_air3, randomfloatrange(0.4, 1.1));

			wait .5;
            firework delete();
			firework2 delete();
			firework3 delete();
            fx delete();
			fx2 delete();
			fx3 delete();
        }
    }

	if(getdvar("mapname") == "zm_highrise")
    {
        for(i=0;i<22;i++)
        {
            firework = Spawn( "script_model", origin );
            firework SetModel( "tag_origin" );
            firework.angles = (0,0,0);
            fx = PlayFxOnTag( level._effect[ "sidequest_dragon_spark_max" ], firework, "tag_origin");
            wait .25;
            firework delete();
            fx delete();
        }
    }

    if(getdvar("mapname") == "zm_tomb")
    {
        for(i=0;i<20;i++)
        {
            firework = Spawn( "script_model", origin );
            firework SetModel( "tag_origin" );
            firework.angles = (-90,0,0);
            fx = PlayFxOnTag( level._effect[ "fire_muzzle" ], firework, "tag_origin");
            wait .25;
            firework delete();
            fx delete();
        }
    }
    else if(getdvar("mapname") == "zm_transit" && getdvar ( "g_gametype")  == "zclassic" )
    {
        for(i=0;i<5;i++)
        {
            up_in_air = origin + (0,0,65);
            firework = Spawn( "script_model", origin );
            firework SetModel( "tag_origin" );
            fx = PlayFxOnTag( level._effect[ "richtofen_sparks" ], firework, "tag_origin");
            firework moveto(up_in_air, 1);
            wait 1;
            firework delete();
            fx delete();
        }
    }
}

spawn_weapon(attacker)
{
    origin = self.origin;
    weapon = attacker getCurrentWeapon();

    attacker.firework_weapon = spawn( "script_model", origin );
	attacker.firework_weapon.angles = (0,0,0);
	attacker.firework_weapon setmodel( GetWeaponModel( weapon ) );
    attacker.firework_weapon useweaponhidetags( weapon );

	attacker.firework_weapon MoveTo( origin + (0, 0, 45), 0.5, 0.25, 0.25 );
	attacker.firework_weapon waittill( "movedone" );
	max_kills = 12;
	zombie_killed = 0;
    for(i=0;i<100;i++)
    {
        zombies = get_array_of_closest( attacker.firework_weapon.origin, getaiarray( level.zombie_team ), undefined, undefined, 300  );
        forward = attacker.firework_weapon.origin;
        
        if( can_aat_damage( zombies[ 0 ] ) )
        {
            end = zombies[ 0 ] gettagorigin( "j_spineupper" );
            crosshair = bullettrace( forward, end, 0, self )[ "position" ];
            attacker.firework_weapon.angles = VectorToAngles( end - attacker.firework_weapon.origin );

            if( distance(zombies[ 0 ].origin, attacker.firework_weapon.origin) <= 300)
			{
                magicbullet( weapon, attacker.firework_weapon.origin, crosshair, attacker.firework_weapon );
				zombies[0] DoDamage(zombies[0].health + 666, zombies[0].origin);
        		attacker scripts\points_multiplier::doublepoints(attacker, 0, 50);
				attacker.kills++;
				zombie_killed++;
				if (zombie_killed >= max_kills)
					break;
			}
        }
        wait .05;
    }
    attacker.firework_weapon MoveTo( origin, 0.5, 0.25, 0.25 );
	attacker.firework_weapon waittill( "movedone" );
    attacker.firework_weapon delete();
}

thunderwall( attacker ) 
{
	ai_zombies = get_array_of_closest( self.origin, getaiarray( level.zombie_team ), undefined, undefined, 250  );

    if ( !isDefined( ai_zombies ) )
		return;
	
	flung_zombies = 0;
	max_kills = 25;
   // max_kills = randomIntRange(5,25);
	for ( i = 0; i < ai_zombies.size; i++ )
	{
		if( can_aat_damage(ai_zombies[i]) )
        {
			n_random_x = RandomFloatRange( -180, 180 ); //base value was -3 3
			n_random_y = RandomFloatRange( -180, 180 );
			ai_zombies[i] StartRagdoll();
			ai_zombies[i] LaunchRagdoll( (n_random_x, n_random_y, 300) ); //was 300 before aprile

			if(getdvar("mapname") == "zm_transit")
	            playfxontag( level._effect[ "jetgun_smoke_cloud"], ai_zombies[i], "J_SpineUpper" );
            else if(getdvar("mapname") == "zm_tomb")
				playfxontag( level._effect[ "air_puzzle_smoke" ], ai_zombies[i], "J_SpineUpper" );
			else if(getdvar("mapname") == "zm_buried")
				playfxontag( level._effect[ "rise_billow_foliage" ], ai_zombies[i], "J_SpineUpper" );
        	
			ai_zombies[i] DoDamage( ai_zombies[i].health + 666, ai_zombies[i].origin);
			attacker.kills++;
			attacker scripts\points_multiplier::doublepoints(attacker, 0, 25);
			flung_zombies++;
			if ( flung_zombies >= max_kills )
				break;
		}
    }
}

Headcutter(attacker)
{
    self endon("death");
	
	self thread on_headcutter_death(attacker);
    self maps\mp\zombies\_zm_spawner::zombie_head_gib();
    for(;;)
    {  	
		wait 1;
		damage = 100 * level.round_number;
        self dodamage( damage, self.origin, attacker, attacker, "none", "MOD_IMPACT" );
    }
}

on_headcutter_death(attacker)
{
	level endon("game_ended");

	self waittill("death");
	attacker.kills++;
	attacker scripts\points_multiplier::doublepoints(attacker, 0, 50);
}

cluster( attacker )
{
	if(level.round_number < 10)
		amount = randomIntRange(1, (level.round_number * 2));
	else
		amount = randomIntRange(5, level.round_number);
	
	random_x = RandomFloatRange( -5, 5 );
	random_y = RandomFloatRange( -5, 5 );
	attacker.gluster_grenade = attacker;
	for(i = 0; i < amount; i++)
	{
		attacker.gluster_grenade MagicGrenadeType( "frag_grenade_zm", self.origin + (random_x, random_y, 10), (random_x, random_y, 0), 2 );
		wait .1;
	}
}

supersprint()
{
	level endon("game_ended");
	self endon("death");
 	for(;;)
	{
    	if(!isDefined(self.cloned_distance))
    		self.cloned_distance = self.origin;
    	else if(distance(self.cloned_distance, self.origin) > 15)
		{
    		self.cloned_distance = self.origin;
			if (cycle != "super_sprint")
			{
				self maps\mp\zombies\_zm_utility::set_zombie_run_cycle("super_sprint");
				cycle = "super_sprint";
			}
    	}
		else if(distance(self.cloned_distance, self.origin) <= 15)
		{
    		self.cloned_distance = self.origin;
			if (cycle != "run")
			{
    			self maps\mp\zombies\_zm_utility::set_zombie_run_cycle("run");
				cycle = "run";
			}
    	}
    	wait 0.25;
    }
}

turned( attacker )
{
	self.is_turned = 1;
    self.actor_damage_func = ::turned_damage_respond; 
    self.health = 999999;

	attacker.active_turned = 1;
	self.turned_zombie_kills = 0;
	self.max_kills = 18;

	self thread supersprint();	
	self SetMoveSpeedScale(20);
	self.custom_goalradius_override = 1000000;

    if(getdvar("mapname") == "zm_tomb")
        turned_fx = playfxontag(level._effect[ "staff_soul" ], self, "j_head");
    else
        turned_fx = playfxontag(level._effect["powerup_on_solo"], self, "j_head");

	enemyoverride = [];
	self.team = level.players; 
	self.ignore_enemy_count = 1;

	if(getdvar("mapname") == "zm_tomb")
		attackanim = "zm_generator_melee";
	else
		attackanim = "zm_riotshield_melee";
	
	if ( !self.has_legs )
		attackanim += "_crawl";
	
	while(isAlive(self))
	{
		ai_zombies = get_array_of_closest( self.origin, getaiarray( level.zombie_team ), undefined, undefined, undefined  );
		if(isdefined(ai_zombies[1]) && can_aat_damage(ai_zombies[1]))
		{
			enemyoverride[0] = ai_zombies[1].origin;
			enemyoverride[1] = ai_zombies[1];
		}
		else
		{
			enemyoverride[0] = ai_zombies[0].origin;
			enemyoverride[1] = ai_zombies[0];
		}
		self.enemyoverride = enemyoverride;	
		if(distance(self.origin, ai_zombies[1].origin) < 40 && isalive(ai_zombies[1]) )
		{
			angles = VectorToAngles( ai_zombies[1].origin - self.origin );
			self animscripted( self.origin, angles, attackanim );
			ai_zombies[1] DoDamage( ai_zombies[1].health + 666, ai_zombies[1].origin);
			attacker.kills++;
			attacker scripts\points_multiplier::doublepoints(attacker, 0, 50);
			self.turned_zombie_kills++;

			if(self.turned_zombie_kills > self.max_kills)
			{
                turned_fx delete();
				self.is_turned = 0;
				wait .1;
				self dodamage(self.health + 666, self.origin);
			}

			wait 0.5;
		}
		else
			self stopanimscripted();

		wait .05; 
	}
	attacker.active_turned = 0;
	self.is_turned = 0;

    if(isdefined(turned_fx))
        turned_fx delete();
}

turned_damage_respond( einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime, boneindex )
{
    if(self.is_turned)
        return 0;
}

turned_zombie()
{
	if(self.turned)
	{
		//attack zombies
	}
	else
		zombie_poi = self get_zombie_point_of_interest( self.origin );
	
	return zombie_poi;
}

turned_zombie_validation()
{	
	if( IS_TRUE( self.barricade_enter ) )
		return false;
	
	if ( IS_TRUE( self.is_traversing ) )
		return false;
	
	if ( !IS_TRUE( self.completed_emerging_into_playable_area ) )
		return false;
	
	if ( IS_TRUE( self.is_leaping ) )
		return false;
	
	if ( IS_TRUE( self.is_inert ) )
		return false;
	
	return true;
}

is_true(check)
{
	return(IsDefined(check) && check);
}

give_aat(weapon)
{		
	if(!isDefined(self.aat))
		self.aat = [];

    if(isdefined(self.old_aat))
    {
        if(self.old_aat == "Thunder Wall")
            self.old_aat = 0;
        else if(self.old_aat == "Fireworks")
            self.old_aat = 1;
        else if(self.old_aat == "Turned")
            self.old_aat = 2;
        else if(self.old_aat == "Cluster")
            self.old_aat = 3;
        else if(self.old_aat == "Headcutter")
            self.old_aat = 4;
        else if(self.old_aat == "Explosive")
            self.old_aat = 5;
        else if(self.old_aat == "Blast Furnace")
            self.old_aat = 6;
        else if(self.old_aat == "Cryo Freeze")
			self.old_aat = 7;
        else if(self.old_aat == "Dead Wire")
			self.old_aat = 8;
    }

	name = undefined;

	number = randomint(8);

	while(isdefined(self.old_aat) && number == self.old_aat)
	{
		number = randomint(8);
		wait .05;
	}
	if(number == 0)
		name = "Dead Wire";
	else if(number == 1)
		name = "Fireworks";
    else if(number == 2)
        name = "Thunder Wall"; //Cluster disabled was thunder
    else if(number == 3)
        name = "Headcutter";
    else if(number == 4)
        name = "Explosive";
    else if(number == 5)
        name = "Blast Furnace";
	else if (number == 6)
		name = "Cryo Freeze";
    else if(number == 7)
        name = "Turned";
	self.aat[weapon] = name;
	self.old_aat = name;

}

tombstone_timeout()
{
	level endon("end_game");
	self endon("dance_on_my_grave");
	self endon("disconnect");
	self endon("revived_player");

	self waittill("spawned_player");
	wait 60;
	self notify("tombstone_timedout");
	wait 1;
	weapon = self getCurrentWeapon();
	self notify("weapon_change", weapon);
}

watch_weapon_changes()
{
	level endon( "end_game" );
	self endon( "disconnect" );
	self waittill("spawned_player");
	flag_wait("initial_blackscreen_passed");

    if(level.script == "zm_prison") //prevent triggering weapon change when spawning in motd
	{
        level waittill("start_of_round");
	}

    self thread explosive_bullet(); //start explosive bullet background
	while( isdefined( self ) )
	{
		result = self waittill_any_return( "weapon_change", "fake_death", "player_downed" );
		weapon = self getCurrentWeapon();
			if(result == "player_downed" || result == "fake_death")
			{
				if(self hasperk("specialty_scavenger") || self hasperk("specialty_finalstand"))
				{
					if(self hasperk("specialty_scavenger"))
						self thread tombstone_timeout();

					self waittill_any("player_revived", "dance_on_my_grave", "tombstone_timedout", "chugabud_bleedout", "chugabud_effects_cleanup");
				}
			}
		//	if(isdefined(self.afterlife) && self.afterlife)
	//			self waittill("spawned_player");
		//	if (isdefined(self.aat_bar.bar))
		//	{
				if( IsDefined( self.aat[weapon] ) )
				{
					self.aat_bar.alpha = 1;
					self.aat_bar.bar.alpha = 1;
					name = self.aat[weapon];
					self aat_hud(name);
				}
				else 
				{
					self.aat_hud.alpha = 0;
					self.aat_bar.alpha = 0;
					self.aat_bar.bar.alpha = 0;
				}
				if( IsDefined( self.aat ) )
				{
					keys = GetArrayKeys( self.aat );
					foreach( aat in keys )
					{
						if(IsDefined( self.aat[aat] ) && isdefined( aat ) && !self hasweapon( aat ))
							self.aat[aat] = undefined;
					}
				}
	//		}
	}
}

aat_hud(name)
{
	self endon("disconnect");
	level endon("game_ended");

    if(isdefined(self.aat_hud))
	{
		self.aat_hud destroy();
		self notify("hud_destroyed");
	}

	if(isDefined(name))
	{
		if(name == "Thunder Wall")
        {
			label = &"Thunder Wall";
            color = (0,1,1);
        }
		else if(name == "Fireworks")
		{
        	label = &"Fireworks";
            color = (0,1,0);
		}
        else if(name == "Turned")
		{
        	label = &"Turned";
            color = (1,0.5,0.5);
		}
        else if(name == "Cluster")
		{
        	label = &"Cluster";
            color = (0.4,0.4,0.2);
		}
        else if(name == "Headcutter")
		{
        	label = &"Headcutter";
            color = (1,0,1);
		}
        else if(name == "Explosive")
		{
        	label = &"Explosive";
            color = (0,0,1);
		}
        else if(name == "Blast Furnace")
		{
        	label = &"Blast Furnace";
            color = (1,0,0);
        }
        else if(name == "Cryo Freeze")
		{
			label = &"Cryo Freeze";
			color = (0, 0.5, 1);
		}
        else if(name == "Dead Wire")
		{
			label = &"Dead Wire";
			color = (0.8, 0.75, 1);
		}
		else
		{
			color = (0, 0, 0);
		}

        self.aat_hud = newClientHudElem(self);
        self.aat_hud.alignx = "right";
        self.aat_hud.aligny = "bottom";
        self.aat_hud.horzalign = "user_right";
        self.aat_hud.vertalign = "user_bottom";
        if( getdvar( "mapname" ) == "zm_transit" || getdvar( "mapname" ) == "zm_highrise" || getdvar( "mapname" ) == "zm_nuked")
        {
            self.aat_hud.x = -85;
            self.aat_hud.y = -22;
        }
		else if( getdvar( "mapname" ) == "zm_tomb" )
        {
            self.aat_hud.x = -110;
            self.aat_hud.y = -80;
        }
        else
        {
            self.aat_hud.x = -95;
            self.aat_hud.y = -80;
        }
        self.aat_hud.archived = 1;
        self.aat_hud.fontscale = 1.25;
        self.aat_hud.alpha = 1;
        self.aat_hud.color = color;
        self.aat_hud.hidewheninmenu = 1;
        self.aat_hud.label = label;
		self thread aat_cooldown_hud_watcher();
		if (!(isdefined(self.aat_lock)))
		{
			self thread aat_loading_bar();
			self.aat_lock = 1;
		}

    }
}

aat_loading_bar()
{
	self endon("disconnect");
	level endon("game_ended");

	if (getdvar("net_port") == "30010" || getdvar("net_port") == "30011" || check_for_botb_port() == true)
	{
		return;
	}
    level.primaryprogressbarwidth = 60;
    level.primaryprogressbarheight = 5;
    self.aat_bar = self createprimaryprogressbar();
    self.aat_bar setpoint(undefined, "BOTTOM", 320, 20);
    self.aat_bar.hidewheninmenu = 1;
    self.aat_bar.bar.hidewheninmenu = 1;
    self.aat_bar.barframe.hidewheninmenu = 1;

    level.primaryprogressbarwidth = 400;
    level.primaryprogressbarheight = 15;
	for (;;)
	{
		current_weapon = self getCurrentWeapon();
		weapons_inventory = self GetWeaponsListPrimaries();

		for (i = 0; i < weapons_inventory.size; i++)
		{
			if (current_weapon == weapons_inventory[i])
			{
				index = i;
				break;
			}
			else
			{
				wait .05;
				continue;
			}
		}
		self.aat_bar updatebar(self.aat_remaining_cooldown[index] / self.aat_cooldown_duration[index]);
		if(isdefined(self.aat_hud.color))
			self.aat_bar.bar.color = self.aat_hud.color;
		wait .05;
	}
}

aat_cooldown_hud_watcher()
{
	self endon("disconnect");
	level endon("game_ended");
	self endon("hud_destroyed");

	for (;;)
	{
		if (self.is_aat_blinking == 1)
		{
			wait 1;
			continue;
		}
		index = 0;
		current_weapon = self getCurrentWeapon();
		weapons_inventory = self GetWeaponsListPrimaries();
		weapon_match = 0;

		for (i = 0; i < weapons_inventory.size; i++)
		{
			if (current_weapon == weapons_inventory[i])
			{
				index = i;
				weapon_match = 1;
				break;
			}
		}

		if (!IsDefined( self.aat[current_weapon] ))
			self.aat_hud.alpha = 0;
		else if (weapon_match != 0)
		{
			if (self.weapons_aat_cooldown[index] == 0)
				self.aat_hud.alpha = 0.8;
			else
				self.aat_hud.alpha = 0.2;
		}
		wait 0.1;
	}
}

can_aat_damage(ai_zombies)
{
    if(isdefined(ai_zombies.is_turned) && ai_zombies.is_turned)
        return 0;

    if(isdefined(level.sloth) && ai_zombies == level.sloth)
        return 0;

    if(isDefined(ai_zombies.is_avogadro) && ai_zombies.is_avogadro || isDefined(ai_zombies.is_brutus) && ai_zombies.is_brutus || isDefined(ai_zombies.is_mechz) && ai_zombies.is_mechz )
        return 0;

    return 1;
}

solo_tombstone_removal()
{
	level notify( "tombstone_on" );
}

turn_tombstone_on()
{
	level endon("end_game");
	self endon("disconnect");
	level endon("end_game");
	while ( 1 )
	{
		machine = getentarray( "vending_tombstone", "targetname" );
		machine_triggers = getentarray( "vending_tombstone", "target" );
		i = 0;
		while ( i < machine.size )
		{
			machine[ i ] setmodel( level.machine_assets[ "tombstone" ].off_model );
			i++;
		}
		level thread do_initial_power_off_callback( machine, "tombstone" );
		array_thread( machine_triggers, ::set_power_on, 0 );
		level waittill( "tombstone_on" );
		i = 0;
		while ( i < machine.size )
		{
			machine[ i ] setmodel( level.machine_assets[ "tombstone" ].on_model );
			machine[ i ] vibrate( vectorScale( ( 0, -1, 0 ), 100 ), 0,3, 0,4, 3 );
			machine[ i ] playsound( "zmb_perks_power_on" );
			machine[ i ] thread perk_fx( "tombstone_light" );
			machine[ i ] thread play_loop_on_machine();
			i++;
		}
		level notify( "specialty_scavenger_power_on" );
		array_thread( machine_triggers, ::set_power_on, 1 );
		if ( isDefined( level.machine_assets[ "tombstone" ].power_on_callback ) )
		{
			array_thread( machine, level.machine_assets[ "tombstone" ].power_on_callback );
		}
		level waittill( "tombstone_off" );
		if ( isDefined( level.machine_assets[ "tombstone" ].power_off_callback ) )
		{
			array_thread( machine, level.machine_assets[ "tombstone" ].power_off_callback );
		}
		array_thread( machine, ::turn_perk_off );
		players = get_players();
		_a1718 = players;
		_k1718 = getFirstArrayKey( _a1718 );
		while ( isDefined( _k1718 ) )
		{
			player = _a1718[ _k1718 ];
			player.hasperkspecialtytombstone = undefined;
			_k1718 = getNextArrayKey( _a1718, _k1718 );
		}
	}
}

perk_machine_spawn_init()
{
	level endon("end_game");
	self endon("disconnect");
	level endon("end_game");
	match_string = "";
	location = level.scr_zm_map_start_location;
	if ( location != "default" && location == "" && isDefined( level.default_start_location ) )
	{
		location = level.default_start_location;
	}
	match_string = ( level.scr_zm_ui_gametype + "_perks_" ) + location;
	pos = [];
	if ( isDefined( level.override_perk_targetname ) )
	{
		structs = getstructarray( level.override_perk_targetname, "targetname" );
	}
	else
	{
		structs = getstructarray( "zm_perk_machine", "targetname" );
	}
	_a3578 = structs;
	_k3578 = getFirstArrayKey( _a3578 );
	while ( isDefined( _k3578 ) )
	{
		struct = _a3578[ _k3578 ];
		if ( isDefined( struct.script_string ) )
		{
			tokens = strtok( struct.script_string, " " );
			_a3583 = tokens;
			_k3583 = getFirstArrayKey( _a3583 );
			while ( isDefined( _k3583 ) )
			{
				token = _a3583[ _k3583 ];
				if ( token == match_string )
				{
					pos[ pos.size ] = struct;
				}
				_k3583 = getNextArrayKey( _a3583, _k3583 );
			}
		}
		else pos[ pos.size ] = struct;
		_k3578 = getNextArrayKey( _a3578, _k3578 );
	}
	if ( !isDefined( pos ) || pos.size == 0 )
	{
		return;
	}
	precachemodel( "zm_collision_perks1" );
	i = 0;
	while ( i < pos.size )
	{
		perk = pos[ i ].script_noteworthy;
		if ( isDefined( perk ) && isDefined( pos[ i ].model ) )
		{
			use_trigger = spawn( "trigger_radius_use", pos[ i ].origin + vectorScale( ( 0, -1, 0 ), 30 ), 0, 40, 70 );
			use_trigger.targetname = "zombie_vending";
			use_trigger.script_noteworthy = perk;
			use_trigger triggerignoreteam();
			perk_machine = spawn( "script_model", pos[ i ].origin );
			perk_machine.angles = pos[ i ].angles;
			perk_machine setmodel( pos[ i ].model );
			if ( isDefined( level._no_vending_machine_bump_trigs ) && level._no_vending_machine_bump_trigs )
			{
				bump_trigger = undefined;
			}
			else
			{
				bump_trigger = spawn( "trigger_radius", pos[ i ].origin, 0, 35, 64 );
				bump_trigger.script_activated = 1;
				bump_trigger.script_sound = "zmb_perks_bump_bottle";
				bump_trigger.targetname = "audio_bump_trigger";
				if ( perk != "specialty_weapupgrade" )
				{
					bump_trigger thread thread_bump_trigger();
				}
			}
			collision = spawn( "script_model", pos[ i ].origin, 1 );
			collision.angles = pos[ i ].angles;
			collision setmodel( "zm_collision_perks1" );
			collision.script_noteworthy = "clip";
			collision disconnectpaths();
			use_trigger.clip = collision;
			use_trigger.machine = perk_machine;
			use_trigger.bump = bump_trigger;
			if ( isDefined( pos[ i ].blocker_model ) )
			{
				use_trigger.blocker_model = pos[ i ].blocker_model;
			}
			if ( isDefined( pos[ i ].script_int ) )
			{
				perk_machine.script_int = pos[ i ].script_int;
			}
			if ( isDefined( pos[ i ].turn_on_notify ) )
			{
				perk_machine.turn_on_notify = pos[ i ].turn_on_notify;
			}
			if ( perk == "specialty_scavenger" || perk == "specialty_scavenger_upgrade" )
			{
				use_trigger.script_sound = "mus_perks_tombstone_jingle";
				use_trigger.script_string = "tombstone_perk";
				use_trigger.script_label = "mus_perks_tombstone_sting";
				use_trigger.target = "vending_tombstone";
				perk_machine.script_string = "tombstone_perk";
				perk_machine.targetname = "vending_tombstone";
				if ( isDefined( bump_trigger ) )
				{
					bump_trigger.script_string = "tombstone_perk";
				}
			}
			if ( isDefined( level._custom_perks[ perk ] ) && isDefined( level._custom_perks[ perk ].perk_machine_set_kvps ) )
			{
				[[ level._custom_perks[ perk ].perk_machine_set_kvps ]]( use_trigger, perk_machine, bump_trigger, collision );
			}
		}
		i++;
	}
}

isTown()
{
	level endon("end_game");
	self endon("disconnect");
	if (isDefined(level.zombiemode_using_tombstone_perk) && level.zombiemode_using_tombstone_perk)
	{
		level thread perk_machine_spawn_init();
		thread solo_tombstone_removal();
		thread turn_tombstone_on();
	}
}

check_for_botb_port()
{
    found = 0;
    foreach(port in level.net_port_botb)
    {
        if (getdvar("net_port") == port)
            found = 1;
    }
    if (found == 0)
        return false;
    return true;
}