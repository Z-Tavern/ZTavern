#include maps/mp/_utility;
#include common_scripts/utility;
#include maps/mp/gametypes_zm/_hud_util;
#include maps/mp/zombies/_zm_weapons;
#include maps/mp/zombies/_zm_stats;
#include maps/mp/gametypes_zm/_spawnlogic;
#include maps/mp/animscripts/traverse/shared;
#include maps/mp/animscripts/utility;
#include maps/mp/zombies/_load;
#include maps/mp/_createfx;
#include maps/mp/_music;
#include maps/mp/_busing;
#include maps/mp/_script_gen;
#include maps/mp/gametypes_zm/_globallogic_audio;
#include maps/mp/gametypes_zm/_tweakables;
#include maps/mp/_challenges;
#include maps/mp/gametypes_zm/_weapons;
#include maps/mp/_demo;
#include maps/mp/gametypes_zm/_hud_message;
#include maps/mp/gametypes_zm/_spawning;
#include maps/mp/gametypes_zm/_globallogic_utils;
#include maps/mp/gametypes_zm/_spectating;
#include maps/mp/gametypes_zm/_globallogic_spawn;
#include maps/mp/gametypes_zm/_globallogic_ui;
#include maps/mp/gametypes_zm/_hostmigration;
#include maps/mp/gametypes_zm/_globallogic_score;
#include maps/mp/gametypes_zm/_globallogic;
#include maps/mp/zombies/_zm;
#include maps/mp/zombies/_zm_ai_faller;
#include maps/mp/zombies/_zm_spawner;
#include maps/mp/zombies/_zm_pers_upgrades_functions;
#include maps/mp/zombies/_zm_pers_upgrades;
#include maps/mp/zombies/_zm_score;
#include maps/mp/zombies/_zm_powerups;
#include maps/mp/animscripts/zm_run;
#include maps/mp/animscripts/zm_death;
#include maps/mp/zombies/_zm_blockers;
#include maps/mp/animscripts/zm_shared;
#include maps/mp/animscripts/zm_utility;
#include maps/mp/zombies/_zm_ai_basic;
#include maps/mp/zombies/_zm_laststand;
#include maps/mp/zombies/_zm_net;
#include maps/mp/zombies/_zm_audio;
#include maps/mp/gametypes_zm/_zm_gametype;
#include maps/mp/_visionset_mgr;
#include maps/mp/zombies/_zm_equipment;
#include maps/mp/zombies/_zm_power;
#include maps/mp/zombies/_zm_server_throttle;
#include maps/mp/gametypes/_hud_util;
#include maps/mp/zombies/_zm_unitrigger;
#include maps/mp/zombies/_zm_zonemgr;
#include maps/mp/zombies/_zm_perks;
#include maps/mp/zombies/_zm_melee_weapon;
#include maps/mp/zombies/_zm_audio_announcer;
#include maps/mp/zombies/_zm_magicbox;
#include maps/mp/zombies/_zm_utility;
#include maps/mp/zombies/_zm_ai_dogs;
#include maps/mp/gametypes_zm/_hud_message;
#include maps/mp/zombies/_zm_game_module;
#include maps/mp/zombies/_zm_buildables;
#include codescripts/character;
#include maps/mp/zombies/_zm_weap_riotshield;
#include maps/mp/zm_transit_bus;
#include maps/mp/zm_transit_utility;
#include maps/mp/zombies/_zm_equip_turret;
#include maps/mp/zombies/_zm_mgturret;
#include maps\mp\zombies\_zm_weap_jetgun;

#include maps/mp/zombies/_zm_ai_sloth;
#include maps/mp/zombies/_zm_ai_sloth_ffotd;
#include maps/mp/zombies/_zm_ai_sloth_utility;
#include maps/mp/zombies/_zm_ai_sloth_magicbox;
#include maps/mp/zombies/_zm_ai_sloth_crawler;
#include maps/mp/zombies/_zm_ai_sloth_buildables;


#include maps/mp/zombies/_zm_tombstone;
#include maps/mp/zombies/_zm_chugabud;



//customperkinclude
#include maps/mp/_utility;
#include common_scripts/utility;
#include maps/mp/gametypes_zm/_hud_util;
#include maps/mp/zombies/_zm_weapons;
#include maps/mp/zombies/_zm_stats;
#include maps/mp/gametypes_zm/_spawnlogic;
#include maps/mp/animscripts/traverse/shared;
#include maps/mp/animscripts/utility;
#include maps/mp/zombies/_load;
#include maps/mp/_createfx;
#include maps/mp/_music;
#include maps/mp/_busing;
#include maps/mp/_script_gen;
#include maps/mp/gametypes_zm/_globallogic_audio;
#include maps/mp/gametypes_zm/_tweakables;
#include maps/mp/_challenges;
#include maps/mp/gametypes_zm/_weapons;
#include maps/mp/_demo;
#include maps/mp/gametypes_zm/_hud_message;
#include maps/mp/gametypes_zm/_spawning;
#include maps/mp/gametypes_zm/_globallogic_utils;
#include maps/mp/gametypes_zm/_spectating;
#include maps/mp/gametypes_zm/_globallogic_spawn;
#include maps/mp/gametypes_zm/_globallogic_ui;
#include maps/mp/gametypes_zm/_hostmigration;
#include maps/mp/gametypes_zm/_globallogic_score;
#include maps/mp/gametypes_zm/_globallogic;
#include maps/mp/zombies/_zm;
#include maps/mp/zombies/_zm_ai_faller;
#include maps/mp/zombies/_zm_spawner;
#include maps/mp/zombies/_zm_pers_upgrades_functions;
#include maps/mp/zombies/_zm_pers_upgrades;
#include maps/mp/zombies/_zm_score;
#include maps/mp/animscripts/zm_run;
#include maps/mp/animscripts/zm_death;
#include maps/mp/zombies/_zm_blockers;
#include maps/mp/animscripts/zm_shared;
#include maps/mp/animscripts/zm_utility;
#include maps/mp/zombies/_zm_ai_basic;
#include maps/mp/zombies/_zm_laststand;
#include maps/mp/zombies/_zm_net;
#include maps/mp/zombies/_zm_audio;
#include maps/mp/gametypes_zm/_zm_gametype;
#include maps/mp/_visionset_mgr;
#include maps/mp/zombies/_zm_equipment;
#include maps/mp/zombies/_zm_power;
#include maps/mp/zombies/_zm_server_throttle;
#include maps/mp/gametypes/_hud_util;
#include maps/mp/zombies/_zm_unitrigger;
#include maps/mp/zombies/_zm_zonemgr;
#include maps/mp/zombies/_zm_perks;
#include maps/mp/zombies/_zm_melee_weapon;
#include maps/mp/zombies/_zm_audio_announcer;
#include maps/mp/zombies/_zm_magicbox;
#include maps/mp/zombies/_zm_utility;
#include maps/mp/zombies/_zm_ai_dogs;
#include maps/mp/gametypes_zm/_hud_message;
#include maps/mp/zombies/_zm_game_module;
#include maps/mp/zombies/_zm_buildables;
#include codescripts/character;
#include maps/mp/zombies/_zm_weap_riotshield;


main()
{
	register_player_damage_callback( ::playerdamagelastcheck ); //moved to main from init because of it not loading in origins
	replaceFunc( maps\mp\animscripts\zm_utility::wait_network_frame, ::wait_network_frame_override );
	replaceFunc( maps\mp\zombies\_zm_utility::wait_network_frame, ::wait_network_frame_override );
}

init()
{
//-------------------CUSTOMPERK------------------------

      //      if( (getdvar( "mapname" ) == "zm_transit" || getdvar( "mapname" ) == "zm_highrise") && getdvar ( "g_gametype")  == "zstandard" )
	//	{
	    precacheshader("menu_mp_lobby_icon_film");
	    precacheshader( "menu_mp_lobby_icon_customgamemode" );
	    precacheshader( "waypoint_revive" );
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


	    level.town = 1;
	    level.diner = 0;

        level thread onPlayerConnect();

		//level thread perk_machine_removal( "specialty_scavenger" );
		init_custom_map(); 

	    if(level.script != "zm_buried" && level.script != "zm_highrise" && level.script != "zm_tomb" && level.script != "zm_prison")
	  	  level.get_player_weapon_limit = ::custom_get_player_weapon_limit;
	    level.zombie_last_stand = ::LastStand;
	    level.custom_vending_precaching = ::default_vending_precaching;
		


       
	    level.player_out_of_playable_area_monitor = 0;
	    level.perk_purchase_limit = 50;
		if( getdvar( "mapname" ) == "zm_transit" && getdvar ( "g_gametype" )  == "zstandard" )
	   	{
			foreach( weapon in level.zombie_weapons) 
			{
				weapon.is_in_box = 1;
			}
		}

// }



//-------------------ENDCUSTOMPERK------------------------

	isTown();

/*	precacheshader("damage_feedback");
	precacheshader("hud_status_dead");    
	if( getdvar( "mapname" ) == "zm_transit" )
	{
		level._effect[ "jetgun_smoke_cloud" ] = loadfx( "weapon/thunder_gun/fx_thundergun_smoke_cloud" );
	}
    level.custom_pap_validation = thread new_pap_trigger();
	level._poi_override = ::turned_zombie;
    flag_wait( "initial_blackscreen_passed" );

	level.original_damagecallback = level.callbackactordamage;
	level.callbackactordamage = ::actor_damage_override_wrapper;
    //get_players()[0] thread perks_gived(); //test tombstone and whos who aat recovery
	wait 1;
	level.chugabud_laststand_func = ::chugabud_laststand; //recover aat on whos who revive

	level.tombstone_spawn_func = ::tombstone_spawn;	//recover aat on tombstone revive*/
}



//-------------------CUSTOMPERK------------------------

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

	self.perkarray = [];
	self.dying_wish_on_cooldown = 0;
    self.perk_reminder = 0;
    self.perk_count = 0;
    self.num_perks = 0;
	self thread removeperkshader();
    self thread perkboughtcheck();
	self thread damagehitmarker();
	for(;;)
	{
		self waittill( "spawned_player" );
		if(self.score < 1500)
		{
			self.score = 1500;
		}
	}
}

wait_network_frame_override()
{
	wait 0.1;
}

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
		if( isplayer( attacker ) )
		{
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
	perk_system( "script_model", ( 1856, -810.722, -55.875), "zombie_vending_tombstone_on", ( 0, 180, 0 ), "custom", "mus_perks_deadshot_sting", "Deadshot", 2000, "tombstone_light", "deadshot" );
	perk_system( "script_model", ( 2460, -780, -55.875 ), "zombie_vending_tombstone_on", ( 0, 225, 0 ), "custom", "mus_perks_doubletap_sting", "Burn Heart", 2500, "jugger_light", "Burn_Heart" );
	perk_system( "script_model", ( 901.86, -1575.574, -47.875 ), "zombie_vending_tombstone_on", ( 0, 180, 0 ), "custom", "mus_perks_deadshot_sting", "Widow's Wine", 4000, "tombstone_light", "WIDOWS_WINE" );
	perk_system( "script_model", ( 450, -300.574, -61.875 ), "zombie_vending_tombstone_on", ( 0, 45, 0 ), "custom", "mus_perks_packa_sting", "Electric Cherry", 2000, "tombstone_light", "ELECTRIC_CHERRY" ); // 613,-250,z 0,0,0
	perk_system( "script_model", ( 1069, -1133, 120.125 ), "zombie_vending_tombstone_on", ( 0, 180, 0 ), "custom", "mus_perks_doubletap_sting", "Ethereal Razor", 3500, "tombstone_light", "Ethereal_Razor" );
	perk_system( "script_model", ( 1823.86, 670.574, -55.875 ), "zombie_vending_tombstone_on", ( 0, 45, 0 ), "custom", "mus_perks_doubletap_sting", "Mule Kick", 4000, "tombstone_light", "MULE" );
	perk_system( "script_model", ( 840, 603.809, -40.875 ), "zombie_vending_tombstone_on", ( 0, 0, 0 ), "custom", "mus_perks_packa_sting", "PhD Flopper", 2500, "tombstone_light", "PHD_FLOPPER" );
	perk_system( "script_model", ( 2358, -87, -55.875  ), "zombie_vending_tombstone_on", ( 0, -90, 0 ), "custom", "mus_perks_doubletap_sting", "Downer's Delight", 2000, "tombstone_light", "Downers_Delight" );
	perk_system( "script_model", (  2015, 858, -56.875  ), "zombie_vending_tombstone_on", ( 0, -90, 0 ), "custom", "mus_perks_doubletap_sting", "Dying Wish", 6000, "tombstone_light", "Dying_Wish" );
	perk_system( "script_model", ( 559, -1364, 120.125  ), "zombie_vending_tombstone_on", ( 0, 180, 0 ), "custom", "mus_perks_doubletap_sting", "Ammo Regen", 3000, "tombstone_light", "Ammo_Regen" );
	}
	if( level.script == "zm_highrise")
	{
	perk_system( "script_model", ( 1884.42, 491.946, 1298.72), "zombie_vending_jugg_on", ( 0, 418.728, 0 ), "custom", "mus_perks_deadshot_sting", "Deadshot", 2000, "tombstone_light", "deadshot" );
//	perk_system( "script_model", ( 2764.64, 1868.03, 1391.01 ), "zombie_vending_jugg_on", ( 0, 384.236, 0 ), "custom", "mus_perks_doubletap_sting", "Burn Heart", 2500, "jugger_light", "Burn_Heart" );
	perk_system( "script_model", ( 1978.25, 597.657, 2704.13 ), "zombie_vending_jugg_on", ( 0, 329.291, 0 ), "custom", "mus_perks_deadshot_sting", "Widow's Wine", 4000, "tombstone_light", "WIDOWS_WINE" );
	perk_system( "script_model", ( 1415.64, 2108.36, 3220.26 ), "zombie_vending_jugg_on", ( 0, 406.661, 0 ), "custom", "mus_perks_packa_sting", "Electric Cherry", 2000, "tombstone_light", "ELECTRIC_CHERRY" ); // 613,-250,z 0,0,0
	perk_system( "script_model", ( 1901.97, 1431.36, 3216.13 ), "zombie_vending_jugg_on", ( 0, 404.762, 0 ), "custom", "mus_perks_doubletap_sting", "Ethereal Razor", 3500, "tombstone_light", "Ethereal_Razor" );
//	perk_system( "script_model", ( 1891.64, 1119.64, 3048.36 ), "zombie_vending_jugg_on", ( 0, 45, 0 ), "custom", "mus_perks_doubletap_sting", "Mule Kick", 4000, "tombstone_light", "MULE" );
	perk_system( "script_model", ( 1429.29, -453.397, 2880.13 ), "zombie_vending_jugg_on", ( 0, 149.1426, 0 ), "custom", "mus_perks_packa_sting", "PhD Flopper", 2500, "tombstone_light", "PHD_FLOPPER" );
	perk_system( "script_model", ( 1109.64, 2701.36, 3043.82  ), "zombie_vending_jugg_on", ( 0, 394.926, 0 ), "custom", "mus_perks_doubletap_sting", "Downer's Delight", 2000, "tombstone_light", "Downers_Delight" );
	perk_system( "script_model", ( 1706.28, 1055.64, 3395.1  ), "zombie_vending_jugg_on", ( 0, 180, 0 ), "custom", "mus_perks_doubletap_sting", "Dying Wish", 6000, "tombstone_light", "Dying_Wish" );
	perk_system( "script_model", ( 2269.17, 182.377, 2880.13  ), "zombie_vending_jugg_on", ( 0, 418.596, 0 ), "custom", "mus_perks_doubletap_sting", "Ammo Regen", 3000, "tombstone_light", "Ammo_Regen" );
	}
	if( level.script == "zm_buried")
	{
	perk_system( "script_model", ( 1618.14, 1513.46, 200.62), "zombie_vending_jugg_on", ( 0, 250.147, 0 ), "custom", "mus_perks_deadshot_sting", "Deadshot", 2000, "sleight_light", "deadshot" );
//	perk_system( "script_model", ( -1176.36, 508.26, 144.125 ), "zombie_vending_jugg_on", ( 0, 448.269, 0 ), "custom", "mus_perks_doubletap_sting", "Burn Heart", 2500, "sleight_light", "Burn_Heart" );
	perk_system( "script_model", ( -1176.36, 510.625, 144.125 ), "zombie_vending_jugg_on", ( 0, 449.412, 0 ), "custom", "mus_perks_deadshot_sting", "Widow's Wine", 4000, "sleight_light", "WIDOWS_WINE" );
	perk_system( "script_model", ( -448.859, 131.435, 143.491 ), "zombie_vending_jugg_on", ( 0, 180.3, 0 ), "custom", "mus_perks_packa_sting", "Electric Cherry", 2000, "sleight_light", "ELECTRIC_CHERRY" ); // 613,-250,z 0,0,0
	perk_system( "script_model", ( 890.359, -840.206, -22.8006 ), "zombie_vending_jugg_on", ( 0, 270.367, 0 ), "custom", "mus_perks_doubletap_sting", "Ethereal Razor", 3500, "sleight_light", "Ethereal_Razor" );
//	perk_system( "script_model", ( 1891.64, 1119.64, 3048.36 ), "zombie_vending_jugg_on", ( 0, 45, 0 ), "custom", "mus_perks_doubletap_sting", "Mule Kick", 4000, "sleight_light", "MULE" );
	perk_system( "script_model", ( 572.507, -712.359, 149.95 ), "zombie_vending_jugg_on", ( 0, 178.4505, 0 ), "custom", "mus_perks_packa_sting", "PhD Flopper", 2500, "sleight_light", "PHD_FLOPPER" );
	perk_system( "script_model", ( 488.324, 727.641, 176.125  ), "zombie_vending_jugg_on", ( 0, 178.9998, 0 ), "custom", "mus_perks_doubletap_sting", "Downer's Delight", 2000, "sleight_light", "Downers_Delight" );
	perk_system( "script_model", ( -1298.32, -837.178, -23.875  ), "zombie_vending_jugg_on", ( 0, 91.37286, 0 ), "custom", "mus_perks_doubletap_sting", "Dying Wish", 6000, "sleight_light", "Dying_Wish" );
	perk_system( "script_model", ( -122.161, -1469.21, 168.125  ), "zombie_vending_jugg_on", ( 0, 448.841, 0 ), "custom", "mus_perks_doubletap_sting", "Ammo Regen", 3000, "sleight_light", "Ammo_Regen" );
	}
	if( level.script == "zm_nuked")
	{
	perk_system( "script_model", ( 28.8155, -356.18, -65.8346 ), "zombie_vending_jugg_on", ( 0, 129.8755, 0 ), "custom", "mus_perks_deadshot_sting", "Deadshot", 2000, "sleight_light", "deadshot" );
//	perk_system( "script_model", (  ), "zombie_vending_jugg_on", (  ), "custom", "mus_perks_doubletap_sting", "Burn Heart", 2500, "sleight_light", "Burn_Heart" );
	perk_system( "script_model", ( -954.194, 714.594, 84.0385 ), "zombie_vending_jugg_on", ( 0, 429.46, 0 ), "custom", "mus_perks_deadshot_sting", "Widow's Wine", 4000, "sleight_light", "WIDOWS_WINE" );
	perk_system( "script_model", ( 683.524, 618.635, -56.875 ), "zombie_vending_jugg_on", ( 0, 102.5635, 0 ), "custom", "mus_perks_packa_sting", "Electric Cherry", 2000, "sleight_light", "ELECTRIC_CHERRY" ); // 613,-250,z 0,0,0
	perk_system( "script_model", ( 1420.35, -21.4313, -63.8849 ), "zombie_vending_jugg_on", ( 0, 194.085, 0 ), "custom", "mus_perks_doubletap_sting", "Ethereal Razor", 3500, "sleight_light", "Ethereal_Razor" );
	perk_system( "script_model", ( 618.292, -188.322, -56.3686 ), "zombie_vending_jugg_on", ( 0, 105.5011, 0 ), "custom", "mus_perks_doubletap_sting", "Mule Kick", 4000, "sleight_light", "MULE" );
	perk_system( "script_model", ( 1152.5, 160.6, 79.125 ), "zombie_vending_jugg_on", ( 0, 392.541, 0 ), "custom", "mus_perks_packa_sting", "PhD Flopper", 2500, "sleight_light", "PHD_FLOPPER" );
	perk_system( "script_model", ( 156.738, 513.899, -62.3141 ), "zombie_vending_jugg_on", ( 0, 101.8164, 0 ), "custom", "mus_perks_doubletap_sting", "Downer's Delight", 2000, "sleight_light", "Downers_Delight" );
	perk_system( "script_model", ( -646.863, 271.522, -55.875 ), "zombie_vending_jugg_on", ( 0, 160.8405, 0 ), "custom", "mus_perks_doubletap_sting", "Dying Wish", 6000, "sleight_light", "Dying_Wish" );
	perk_system( "script_model", ( -1582.46, 112.604, -63.2092 ), "zombie_vending_jugg_on", ( 0, 250.829, 0 ), "custom", "mus_perks_doubletap_sting", "Ammo Regen", 3000, "sleight_light", "Ammo_Regen" );
	}
	if( level.script == "zm_tomb")
	{
	perk_system( "script_model", ( 184.995, -2422.49, 50.125), "zombie_vending_jugg_on", ( 0, 369.091, 0 ), "custom", "mus_perks_deadshot_sting", "Deadshot", 2000, "sleight_light", "deadshot" );
	perk_system( "script_model", ( 160.359, 3781.17, -351.875 ), "zombie_vending_jugg_on", ( 0, 266.122, 0 ), "custom", "mus_perks_deadshot_sting", "Widow's Wine", 4000, "sleight_light", "WIDOWS_WINE" );
	perk_system( "script_model", ( 375.771, 2119.22, -122.951 ), "zombie_vending_jugg_on", ( 0, 179.5935, 0 ), "custom", "mus_perks_doubletap_sting", "Ethereal Razor", 3500, "sleight_light", "Ethereal_Razor" );
	perk_system( "script_model", ( -335.604, -187.006, 325.273 ), "zombie_vending_jugg_on", ( 0, 132.9565, 0 ), "custom", "mus_perks_packa_sting", "PhD Flopper", 2500, "sleight_light", "PHD_FLOPPER" );
	perk_system( "script_model", ( 924.47, 360.72, 131.005 ), "zombie_vending_jugg_on", ( 0, 373.266, 0 ), "custom", "mus_perks_doubletap_sting", "Downer's Delight", 2000, "sleight_light", "Downers_Delight" );
	perk_system( "script_model", ( 1345.09, -3822.62, 302.125 ), "zombie_vending_jugg_on", ( 0, 270.593, 0 ), "custom", "mus_perks_doubletap_sting", "Dying Wish", 6000, "sleight_light", "Dying_Wish" );
	perk_system( "script_model", ( 2972.36, 5218.91, -378.566 ), "zombie_vending_jugg_on", ( 0, 270.379, 0 ), "custom", "mus_perks_doubletap_sting", "Ammo Regen", 3000, "sleight_light", "Ammo_Regen" );
	}
	if( level.script == "zm_prison")
	{
	perk_system( "script_model", ( -1344.65, 5598.31, -71.875 ), "p6_zm_al_vending_jugg_on", ( 0, 98.34412, 0 ), "custom", "mus_perks_deadshot_sting", "Deadshot", 2000, "sleight_light", "deadshot" );
	perk_system( "script_model", ( 3763.64, 9669.99, 1704.13 ), "p6_zm_al_vending_jugg_on", ( 0, 90, 0 ), "custom", "mus_perks_deadshot_sting", "Widow's Wine", 4000, "sleight_light", "WIDOWS_WINE" );
	perk_system( "script_model", ( 2160.71, 9247.64, 1558.13 ), "p6_zm_al_vending_jugg_on", ( 0, 179.1815, 0 ), "custom", "mus_perks_doubletap_sting", "Ethereal Razor", 3500, "sleight_light", "Ethereal_Razor" );
	perk_system( "script_model", ( 597.633, 8546.86, 832.125 ), "p6_zm_al_vending_jugg_on", ( 0, 221.984, 0 ), "custom", "mus_perks_doubletap_sting", "Mule Kick", 4000, "sleight_light", "MULE" );
	perk_system( "script_model", ( 456.359, 8679.51, 1128.13 ), "p6_zm_al_vending_jugg_on", ( 0, 269.533, 0 ), "custom", "mus_perks_packa_sting", "PhD Flopper", 2500, "sleight_light", "PHD_FLOPPER" );
	perk_system( "script_model", ( -685.943, 9199.64, 1336.13 ), "p6_zm_al_vending_jugg_on", ( 0, 178.5443, 0 ), "custom", "mus_perks_doubletap_sting", "Downer's Delight", 2000, "sleight_light", "Downers_Delight" );
	perk_system( "script_model", ( 1728.56, 10688.4, 1336.13 ), "p6_zm_al_vending_jugg_on", ( 0, 357.896, 0 ), "custom", "mus_perks_doubletap_sting", "Dying Wish", 6000, "sleight_light", "Dying_Wish" );
	perk_system( "script_model", ( 1367.28, 10096.4, 1128.13 ), "p6_zm_al_vending_jugg_on", ( 0, 358.687, 0 ), "custom", "mus_perks_doubletap_sting", "Ammo Regen", 3000, "sleight_light", "Ammo_Regen" );
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
            if(!player.machine_is_in_use)
			{
                if( distance( self.origin, player.origin ) <= 70 )
                {
				    player thread SpawnHint( self.origin, 30, 30, "HINT_ACTIVATE", "Hold ^3&&1^7 for " + name + " [Cost: " + cost + "]" );
                    if(player usebuttonpressed() && !player hasperk(perk) && !player hascustomperk(perk) && player.score >= cost && !player maps/mp/zombies/_zm_laststand::player_is_in_laststand())
                    {
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
                            player maps/mp/zombies/_zm_audio::create_and_play_dialog( "general", "perk_deny", undefined, 0 );
                        }
                    }
                }
            }
        }
        wait 0.1;
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
	common_scripts/utility::flag_wait( "initial_blackscreen_passed" );
    for(;;)
    {
        self waittill_any_return( "fake_death", "player_downed", "player_revived", "spawned_player", "disconnect", "death" );
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
        self maps/mp/zombies/_zm_audio::playerexert( "burp" );
        self setblur( 4, 0.1 );
        wait 0.1;
        self setblur( 0, 0.1 );
        self allowProne(true);
        self allowSprint(true);
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
				self iprintln("^9Downer's Delight");
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
				self iprintln("^9Mule Kick");
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
				self iprintln("^9PhD Flopper");
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
				self iprintln("^9Electric Cherry");
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
				self iprintln("^9Widow's Wine");
				wait 0.2;
				self iprintln("This Perk damages zombies around the player when player is hit and grenades are upgraded.");
        	}
		}
        if(perk == "Ethereal_Razor")
        {    
            self.perk7back = self drawshader( "specialty_marathon_zombies", x, yPerk, 24, 24, ( 200, 0, 0 ), 100, 0 );
            self.perk7front = self drawshader( "zombies_rank_4", x, yPerk, 23, 23, ( 1, 1, 1 ), 100, 0 );
			self.perk7front.name = perk;
			self.perkarray[self.perkarray.size] = self.perk7front;
			self.perk7back.name = perk;
            self.perkarray[self.perkarray.size] = self.perk7back;
			self.num_perks++;
			if(print)
			{
				self iprintln("^9Ethereal Razor");
				wait 0.2;
				self iprintln("This Perk deals extra damage when player using melee attacks and restores a small amount of health.");
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
				self iprintln("^9Burn Heart");
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
				self iprintln("^9Dying Wish");
				wait 0.2;
				self iprintln("This Perk allow player to go berserker mode for 9 seconds instead of laststand.");
				wait 0.1;
				self iprintln(" (cooldown 5mins and it's increased 30sec every time perk is used. - max 10mins) ");
			}
		}
        if(perk == "deadshot")
        {
            self.perk11back = self drawshader( "specialty_marathon_zombies", x, yPerk, 24, 24, ( 0, 0, 0 ), 100, 0 );
            self.perk11front = self drawshader( "killiconheadshot", x, yPerk, 23, 23, ( 1, 1, 1 ), 100, 0 );
            self.perk11front.name = perk;
			self.perkarray[self.perkarray.size] = self.perk11front;
			self.perk11back.name = perk;
            self.perkarray[self.perkarray.size] = self.perk11back;
			self.num_perks++;
			self setclientfieldtoplayer( "deadshot_perk", 1 );
			if(print)
			{
				self iprintln("^9Deadshot");
				wait 0.2;
				self iprintln("This Perk aims automatically enemys head instead of body.");
        	}
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
		if(!self GetCurrentWeapon() == "" && !is_grenade_launcher( self GetCurrentWeapon()) && self GetCurrentWeapon() != "slipgun_zm"
&& self GetCurrentWeapon() != "staff_fire_zm" && self GetCurrentWeapon() != "staff_fire_upgraded_zm" 
&& self GetCurrentWeapon() != "staff_air_zm" && self GetCurrentWeapon() != "staff_air_upgraded_zm" 
&& self GetCurrentWeapon() != "staff_water_zm" && self GetCurrentWeapon() != "staff_water_upgraded_zm"
&& self GetCurrentWeapon() != "staff_lightning_zm" && self GetCurrentWeapon() != "staff_lightning_upgraded_zm"
&& self GetCurrentWeapon() !=  "blundersplat_upgraded_zm")
		{
			stockcount = self getweaponammostock( self GetCurrentWeapon() );
			self setWeaponAmmostock( self GetCurrentWeapon(), stockcount + 1 );
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
            foreach(zombie in getAiArray(level.zombie_team))
			{
                if( distance( self.origin, zombie.origin ) <= 100 )
				{
					
                } 
            }
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
        self maps/mp/zombies/_zm::last_stand_pistol_swap();
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
    if (!(self hasperk(perk) || (self maps/mp/zombies/_zm_perks::has_perk_paused(perk))))
    {
        gun = self maps/mp/zombies/_zm_perks::perk_give_bottle_begin(perk);
        evt = self waittill_any_return("fake_death", "death", "player_downed", "weapon_change_complete");
        if (evt == "weapon_change_complete")
            self thread maps/mp/zombies/_zm_perks::wait_give_perk(perk, 1);
        self maps/mp/zombies/_zm_perks::perk_give_bottle_end(gun, perk);
        if (self maps/mp/zombies/_zm_laststand::player_is_in_laststand() || isDefined(self.intermission) && self.intermission)
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
		self maps/mp/zombies/_zm_utility::set_zombie_run_cycle("walk");
        player maps/mp/zombies/_zm_score::add_to_player_score( 10 );
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
    self useServerVisionSet(true);
    self setvisionsetforplayer( "zombie_death", 0 );
    self freezeControls(1);
    wait 1;
    self freezeControls(0);
    wait 8;
	self.health = 1;
    self disableInvulnerability();
    self.ignoreme = 0;
    self useServerVisionSet(false);
    self setvisionsetforplayer("remote_mortar_enhanced", 0);
}


player_burning_audio()
{
	level endon("end_game");
	self endon("disconnect");
	fire_ent = spawn( "script_model", self.origin );
	wait_network_frame();
	fire_ent linkto( self );
	fire_ent playloopsound( "evt_plr_fire_loop" );
	self waittill_any( "stop_flame_damage", "stop_flame_sounds", "death", "disconnect" );
	fire_ent delete();
}


//-------------------ENDCUSTOMPERK------------------------



perks_gived()
{
	level endon("end_game");
	self endon("disconnect");
    wait 5;
    iprintln("done");
    self give_perk("specialty_scavenger");
    bot = addtestclient();
	wait 1;
    bot enableInvulnerability();
    
}

playerdamagelastcheck( einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime )
{
	level endon("end_game");
	self endon("disconnect");
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
	else
	{
        return idamage;
    }

//-------------------ENDCUSTOMPERK------------------------







	if(isdefined(self.has_cluster) && self.has_cluster && isdefined(eattacker) && eattacker == self) 
    {
        return 0;
    }
	players = get_players();
	for(i=0;i<players.size;i++)
	{
		if(isdefined(players[i].firework_weapon) && eattacker == players[i].firework_weapon)
		{
			return 0;
		}
	}
	return idamage;
}

hascustomperk(perk)
{
	level endon("end_game");
	self endon("disconnect");
	for(i = 0; i < self.perkarray.size; i++)
	{
		if(self.perkarray[i].name == perk)
		{
			return 1;
		}
	}
	return 0;
}


vector_scal( vec, scale )
{
	level endon("end_game");
	self endon("disconnect");
	vec = ( vec[ 0] * scale, vec[ 1] * scale, vec[ 2] * scale );
	return vec;
}

pap_off()
{
	level endon("end_game");
	self endon("disconnect");
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
	self endon("disconnect");
    level waittill("Pack_A_Punch_on");
    wait 2;
    
	if( getdvar( "mapname" ) == "zm_transit" && getdvar ( "g_gametype")  == "zstandard" )
	{	
	}
	else
	{
		level notify("Pack_A_Punch_off");
		level thread pap_off();
	}
    if( getdvar( "mapname" ) == "zm_nuked" )
    {
        level waittill( "Pack_A_Punch_on" );
    }
	perk_machine = getent( "vending_packapunch", "targetname" );
	weapon_upgrade_trigger = getentarray( "specialty_weapupgrade", "script_noteworthy" );
	weapon_upgrade_trigger[0] trigger_off();
	if( getdvar( "mapname" ) == "zm_transit" && getdvar ( "g_gametype")  == "zclassic" )
	{
		if(!level.buildables_built[ "pap" ])
		{
			level waittill("pap_built");
			
		}
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
		trigger = spawn( "trigger_radius", perk_machine.origin, 1, 60, 80 );
		Trigger enableLinkTo();
		Trigger linkto(self.perk_machine);
	}
	else
	{
		trigger = spawn( "trigger_radius", perk_machine.origin, 1, 35, 80 );
	}
	Trigger SetCursorHint( "HINT_NOICON" );
    Trigger sethintstring( "			Hold ^3&&1^7 for Pack-a-Punch [Cost: 5000] \n Weapons can be pack a punched multiple times" );
	Trigger usetriggerrequirelookat();
	perk_machine thread maps/mp/zombies/_zm_perks::activate_packapunch();
	for(;;)
	{
		Trigger waittill("trigger", player);
		current_weapon = player getcurrentweapon();
        if(current_weapon == "saritch_upgraded_zm+dualoptic" || current_weapon == "dualoptic_saritch_upgraded_zm+dualoptic" || current_weapon == "slowgun_upgraded_zm")
        {
            Trigger sethintstring( "^1This weapon doesn't have alternative ammo types." );
            continue;
        }
		if(player UseButtonPressed() && player.score >= 5000 && current_weapon != "riotshield_zm" && player can_buy_weapon() && !player.is_drinking && !is_placeable_mine( current_weapon ) && !is_equipment( current_weapon ) && level.revive_tool != current_weapon && current_weapon != "none" )
        {
			player.score -= 5000;
            player thread maps/mp/zombies/_zm_audio::play_jingle_or_stinger( "mus_perks_packa_sting" );
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
            
			player thread maps/mp/zombies/_zm_perks::do_knuckle_crack();
			wait .1;
			player takeWeapon(current_weapon);
			current_weapon = player maps/mp/zombies/_zm_weapons::switch_from_alt_weapon( current_weapon );
			self.current_weapon = current_weapon;
			upgrade_name = maps/mp/zombies/_zm_weapons::get_upgrade_weapon( current_weapon, upgrade_as_attachment );
			player third_person_weapon_upgrade( current_weapon, upgrade_name, packa_rollers, perk_machine, self );
			trigger sethintstring( &"ZOMBIE_GET_UPGRADED" );
			trigger thread wait_for_pick(player, current_weapon, self.upgrade_name);
			if ( isDefined( player ) )
			{
				trigger setinvisibletoall();
				trigger setvisibletoplayer( player );
			}
			self thread wait_for_timeout( current_weapon, packa_timer, player );
			self waittill_any( "pap_timeout", "pap_taken", "pap_player_disconnected" );
			self.current_weapon = "";
			if ( isDefined( self.worldgun ) && isDefined( self.worldgun.worldgundw ) )
			{
				self.worldgun.worldgundw delete();
			}
			if ( isDefined( self.worldgun ) )
			{
				self.worldgun delete();
			}
			trigger setinvisibletoplayer( player );
			wait 1.5;
			trigger setvisibletoall();
			self.pack_player = undefined;
			flag_clear( "pack_machine_in_use" );
		}
        Trigger sethintstring( "			Hold ^3&&1^7 for Pack-a-Punch [Cost: 5000] \n Weapons can be pack a punched multiple times" );
		wait .1;
	}
}

wait_for_pick(player, weapon, upgrade_weapon )
{
	level endon("end_game");
	self endon("disconnect");
	level endon( "pap_timeout" );
	for (;;)
	{
		self playloopsound( "zmb_perks_packa_ticktock" );
		self waittill( "trigger", user );
		if(user UseButtonPressed() && player == user)
		{	
			self stoploopsound( 0.05 );
			player thread do_player_general_vox( "general", "pap_arm2", 15, 100 );
			gun = player maps/mp/zombies/_zm_weapons::get_upgrade_weapon( upgrade_weapon, 0 );
			if(is_weapon_upgraded( weapon ) )
			{
				player.restore_ammo = 1;
				if( weapon == "galil_upgraded_zm+reflex" || weapon  == "fnfal_upgraded_zm+reflex" )
				{
					level thread aats(weapon, player); //Alternative ammo type for galil and fnfal upgraded
				}
				else
				{
					level thread aats(upgrade_weapon, player); //Alternative ammo type for all other weapons
				}
			}
			if( weapon == "galil_upgraded_zm+reflex" || weapon  == "fnfal_upgraded_zm+reflex" )
			{
				player giveweapon( weapon, 0, player maps/mp/zombies/_zm_weapons::get_pack_a_punch_weapon_options( weapon ));
				player switchToWeapon( weapon );
				x = weapon;
			}
            else
            {
                weapon_limit = get_player_weapon_limit( player );
                player maps/mp/zombies/_zm_weapons::take_fallback_weapon();
                primaries = player getweaponslistprimaries();
                if ( isDefined( primaries ) && primaries.size >= weapon_limit )
                {
                    player maps/mp/zombies/_zm_weapons::weapon_give( upgrade_weapon );
                }
                else
                {
                    player giveweapon( upgrade_weapon, 0, player maps/mp/zombies/_zm_weapons::get_pack_a_punch_weapon_options( upgrade_weapon ));
                }
			    player switchToWeapon( upgrade_weapon );
                x = upgrade_weapon;
            }

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

aats(name, player)
{
	level endon("end_game");
	self endon("disconnect");
	self endon( "death" );
	self endon( "pap_timeout" );
	self endon( "pap_player_disconnected" );
	self endon( "Pack_A_Punch_off" );
	self waittill("pap_taken");
	self thread pick_ammo(name, player);
}

pick_ammo(name, player)
{
	level endon("end_game");
	self endon("disconnect");
	player notify("new_aat");
	primaries = player getweaponslistprimaries();
	if(!isDefined(player.active_explosive_bullet))
	{
		player thread explosive_bullet();
	}
	if(!isDefined(player.weaponname))
	{
		player.active_turned = 0;
		player.has_turned = 0;
        player.has_blast_furnace = 0;
        player.has_fireworks = 0;
        player.cooldown = 0;
        player.has_explosive_bullets = 0;
        player.has_thunder_wall = 0;
		player.has_Headcutter = 0;
        player.has_cluster = 0;
	//	player thread aat_hitmarker();
	}
	if(!isDefined(player.weaponname))
	{
		player.weaponname = "x";
	}
	if(!isDefined(player.last_aat))
	{
		player.last_aat = 0;
	}
	if(!isDefined(player.aat_weapon))
	{
		player.aat_weapon = [];
	}
	if(!isDefined(player.weapon_aats))
	{
		player.weapon_aats = [];
	}
	aat = randomIntRange(0,8);
	
	/*aats = array("Blast Furnace", "Fireworks", "Explosive", "Headcutter", "Cluster", "Turned", "Thunder Wall");
	aats = array("Blast Furnace", "Headcutter", "Turned", "Thunder Wall");
	randomize = array_randomize(aats);
	aat = randomize[0];*/
	

	if(name == player.weaponname && aat == player.last_aat )
	{
		return pick_ammo(name, player);
	}
	for(i=0; i<primaries.size; i++)
	{
		if(isdefined(primaries[i]) && name == primaries[i])
		{
			player.weapon_aats[i] = aat;
			player.aat_weapon[i] = name;
		}
	}
	player.last_aat = aat;
	player.weaponname = name;
	player.aat_hud destroy();

	if(aat == 1 || aat == 5)
	{
		player aat_hud("Blast Furnace", (1,0,0));
		player.has_blast_furnace = 1;
		player.has_fireworks = 0;
		player.has_explosive_bullets = 0;
        player.has_thunder_wall = 0;
        player.has_Headcutter = 0;
        player.has_cluster = 0;
		player.has_turned = 0;
	}
   	 if(aat == 2 || aat == 3)
	{
		player aat_hud("Headcutter", (1,0,1));
		player.has_fireworks = 0;
		player.has_blast_furnace = 0;
		player.has_explosive_bullets = 0;
        player.has_thunder_wall = 0;
        player.has_Headcutter = 1;
        player.has_cluster = 0;
		player.has_turned = 0;
	}
   	 if(aat == 7)
	{
		player aat_hud("Headcutter", (1,0,1));
		player.has_fireworks = 0;
		player.has_blast_furnace = 0;
		player.has_explosive_bullets = 0;
        player.has_thunder_wall = 0;
        player.has_Headcutter = 1;
        player.has_cluster = 0;
		player.has_turned = 0;
	}
/*	if(aat == 3 || aat == 7)
	{
		player aat_hud("Turned", (1,0.5,0.5));
		player.has_fireworks = 0;
		player.has_blast_furnace = 0;
		player.has_explosive_bullets = 0;
        player.has_thunder_wall = 0;
        player.has_Headcutter = 0;
        player.has_cluster = 1;
		player.has_turned = 0;
	}*/
   	if(aat == 4 || aat == 6)
	{
		player aat_hud("Thunder Wall", (0,1,1));
		player.has_fireworks = 0;
		player.has_blast_furnace = 0;
		player.has_explosive_bullets = 0;
        player.has_thunder_wall = 1;
        player.has_Headcutter = 0;
        player.has_cluster = 0;
		player.has_turned = 0;
	}





	/*if(aat == 2)
	{
		player aat_hud("Fireworks", (0,1,0));
		player.has_fireworks = 1;
		player.has_blast_furnace = 0;
		player.has_explosive_bullets = 0;
        player.has_thunder_wall = 0;
        player.has_Headcutter = 0;
        player.has_cluster = 0;
		player.has_turned = 0;
	}*/
	/*if(aat == 3)
	{
		player aat_hud("Explosive", (0,0,1));
		player.has_fireworks = 0;
		player.has_blast_furnace = 0;
		player.has_explosive_bullets = 1;
        player.has_thunder_wall = 0;
        player.has_Headcutter = 0;
        player.has_cluster = 0;
		player.has_turned = 0;
	}*/

  /*  if(aat == 5)
	{
		player aat_hud("Cluster", (0.4,0.4,0.2));
		player.has_fireworks = 0;
		player.has_blast_furnace = 0;
		player.has_explosive_bullets = 0;
        player.has_thunder_wall = 0;
        player.has_Headcutter = 0;
        player.has_cluster = 1;
		player.has_turned = 0;
	}*/

	player thread monitor_aat_weapon();
	//player notify( "weapon_change" );
}

aat_hud(name, color)
{
	level endon("end_game");
	self endon("disconnect");
	self endon("disconnect");
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
	else
	{
		self.aat_hud.x = -95;
		self.aat_hud.y = -80;
	}
	self.aat_hud.fontscale = 1;
	self.aat_hud.alpha = 1;
	self.aat_hud.color = color;
	self.aat_hud.hidewheninmenu = 1;
	self.aat_hud settext(name);
}

monitor_aat_weapon()
{
	level endon("end_game");
	self endon("disconnect");
	self endon("disconnect");
	self endon("new_aat");
	for(;;)
	{
		self waittill( "weapon_change" );
        
    	wait .1;

		if(self getCurrentWeapon() == "none")
		{
			return monitor_aat_weapon();
		}
		if(isDefined(self.aat_hud))
		{
			self.aat_hud destroy();
		}
		for(i=0;i<3;i++)
		{
			if(isDefined(self.aat_weapon[i]) && !self hasweapon(self.aat_weapon[i]))
			{
				self.weapon_aats[i] = undefined;
				self.aat_weapon[i] = undefined;
			}
		}
		wait .1;
		for(i=0;i<3;i++)
		{
			if(IsDefined( self.aat_weapon[i] ) && self getCurrentWeapon() == self.aat_weapon[i])
			{
			/*	if(self.weapon_aats[i] == 2)
				{
					self.has_fireworks = 1;
					self.has_blast_furnace = 0;
					self.has_explosive_bullets = 0;
					self.has_thunder_wall = 0;
					self.has_Headcutter = 0;
					self.has_cluster = 0;
					self.has_turned = 0;
					self aat_hud("Fireworks", (0,1,0));
				}/
				if(self.weapon_aats[i] == 1 || self.weapon_aats[i] == 5)
				{
					self.has_fireworks = 0;
					self.has_blast_furnace = 1;
					self.has_explosive_bullets = 0;
					self.has_thunder_wall = 0;
					self.has_Headcutter = 0;
					self.has_cluster = 0;
					self.has_turned = 0;
					self aat_hud("Blast Furnace", (1,0,0));
				}
			/*	if(self.weapon_aats[i] == 3)
				{
					self aat_hud("Explosive", (0,0,1));
					self.has_fireworks = 0;
					self.has_blast_furnace = 0;
					self.has_explosive_bullets = 1;
					self.has_thunder_wall = 0;
					self.has_Headcutter = 0;
					self.has_cluster = 0;
					self.has_turned = 0;
				}*/
				if(self.weapon_aats[i] == 2 || self.weapon_aats[i] == 3)
				{
					self aat_hud("Headcutter", (1,0,1));
					self.has_fireworks = 0;
					self.has_blast_furnace = 0;
					self.has_explosive_bullets = 0;
					self.has_thunder_wall = 0;
					self.has_Headcutter = 1;
					self.has_cluster = 0;
					self.has_turned = 0;
				}
				if(self.weapon_aats[i] == 7)
				{
					self aat_hud("Headcutter", (1,0,1));
					self.has_fireworks = 0;
					self.has_blast_furnace = 0;
					self.has_explosive_bullets = 0;
					self.has_thunder_wall = 0;
					self.has_Headcutter = 1;
					self.has_cluster = 0;
					self.has_turned = 0;
				}
				/*if(self.weapon_aats[i] == 5)
				{
					self aat_hud("Cluster", (0.4,0.4,0.2));
					self.has_fireworks = 0;
					self.has_blast_furnace = 0;
					self.has_explosive_bullets = 0;
					self.has_thunder_wall = 0;
					self.has_Headcutter = 0;
					self.has_cluster = 1;
					self.has_turned = 0;
				}*/
			/*	if(self.weapon_aats[i] == 3 || self.weapon_aats[i] == 7)
				{
					self aat_hud("Turned", (1,0.5,0.5));
					self.has_fireworks = 0;
					self.has_blast_furnace = 0;
					self.has_explosive_bullets = 0;
					self.has_thunder_wall = 0;
					self.has_Headcutter = 0;
					self.has_cluster = 0;
					self.has_turned = 1;
				}*/
               			if(self.weapon_aats[i] == 4 || self.weapon_aats[i] == 6)
				{
					self aat_hud("Thunder Wall", (0,1,1));
					self.has_fireworks = 0;
					self.has_blast_furnace = 0;
					self.has_explosive_bullets = 0;
					self.has_thunder_wall = 1;
					self.has_Headcutter = 0;
					self.has_cluster = 0;
					self.has_turned = 0;
				}
			}
		}
        if(isdefined(self.keep_perks) && self.keep_perks)
        {
            //iprintln("keep_perks");
            //keep aat when returning from bridge
        }

		else if(self getCurrentWeapon() != self.aat_weapon[0] && self getCurrentWeapon() != self.aat_weapon[1] && self getCurrentWeapon() != self.aat_weapon[2])
		{
            self.has_thunder_wall = 0;
			self.has_fireworks = 0;
			self.has_blast_furnace = 0;
			self.has_explosive_bullets = 0;
            self.has_Headcutter = 0;
			self.has_cluster = 0;
			self.has_turned = 0;
		}

		if(self hasperk("specialty_finalstand") || self hasperk("specialty_scavenger"))
        {
			wait .1;
			self thread save_aat();
		}
	}
}

actor_damage_override_wrapper( inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex ) 
{
	level endon("end_game");
	self endon("disconnect");
	damage_override = self actor_damage_override( inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex );
	if ( ( self.health - damage_override ) > 0 || !is_true( self.dont_die_on_me ) )
	{
		self finishactordamage( inflictor, attacker, damage_override, flags, meansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex );
	}
}

actor_damage_override( inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex ) 
{
	level endon("end_game");
	self endon("disconnect");
    if(isdefined(level.sloth) && self == level.sloth || isDefined(self.is_avogadro) && self.is_avogadro || isDefined(self.is_brutus) && self.is_brutus || isDefined(self.is_mechz) && self.is_mechz )
    {
		return [[level.original_damagecallback]]( inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex );
    }
	if(isdefined( attacker.weaponname ))
	{
        
        if(!isDefined(self.is_turned))
            self.is_turned = 0;

		//attacker cannot damage active turned zombie
		if(/*attacker.active_turned &&*/ self.is_turned)
			return 0;

		if(isdefined( attacker ) && isplayer( attacker ) && !attacker.cooldown && MeansOfDeath != "MOD_MELEE" && MeansOfDeath != "MOD_IMPACT" && weapon != "knife_zm")
		{
            aat_cooldown_time = randomintrange(10, 16); //cooldown 10 - 15 seconds
	        aat_activation = randomintrange(1,11); //bullet that actives aat 1 - 10 

            zombies = getaiarray( level.zombie_team );
            if(meansofdeath == "MOD_GRENADE" || meansofdeath == "MOD_GRENADE_SPLASH" || meansofdeath == "MOD_EXPLOSIVE" || meansofdeath == "MOD_PROJECTILE")
            {
                if(is_weapon_upgraded( weapon ))
                {
                }
                else
                {
                    return [[level.original_damagecallback]]( inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex );
                }
            }
            if(self turned_zombie_validation() && attacker.has_turned && !attacker.active_turned)
            {
                turned = aat_activation;
                if(turned == 1)
                {
                    attacker.aat_actived = 1;
                    attacker thread cool_down(aat_cooldown_time);
                    self thread turned( attacker );
                }
            }
            if(attacker.has_cluster)
            {
                cluster = aat_activation;
                if(cluster == 1)
                {
                    attacker.aat_actived = 1;
                    attacker thread cool_down(aat_cooldown_time);
                    self thread cluster();
        			self dodamage( self.health * 2, (0,0,0), attacker, attacker, "none", "MOD_IMPACT" );
                }

            }
            if(attacker.has_Headcutter)
            {
                Headcutter = aat_activation;
                if(Headcutter == 1)
                {
                    attacker.aat_actived = 1;
                    attacker thread cool_down(aat_cooldown_time);
                    for( i=0; i < zombies.size; i++ )
                    {
                        if(distance(self.origin, zombies[i].origin) <= 200)
                        {
                            if(!zombies[i].done)
                            {
                                zombies[i].done = 1;
                                zombies[i] thread Headcutter(attacker);
                            }
                        }
                    }
        			self dodamage( self.health * 2, (0,0,0), attacker, attacker, "none", "MOD_IMPACT" );
                }
            }
            if(attacker.has_thunder_wall)
            {
                thunder_wall = aat_activation;
                if(thunder_wall == 1)
                {
                    attacker setclientdvar( "ragdoll_enable", 1);
                    attacker.aat_actived = 1;
                    self thread thunderwall(attacker);
                    attacker thread cool_down(aat_cooldown_time);
        			self dodamage( self.health * 2, (0,0,0), attacker, attacker, "none", "MOD_IMPACT" );
                }
                
            }
            if(attacker.has_blast_furnace)
            {
                blast_furnace = aat_activation;
                if(blast_furnace == 1)
                {
                    attacker.aat_actived = 1;
                    attacker thread cool_down(aat_cooldown_time);
                    flameFX=loadfx("env/fire/fx_fire_zombie_torso");
                    PlayFXOnTag(flameFX,self, "j_spinelower");
                    flameFX2=loadfx("env/fire/fx_fire_zombie_md");
                    PlayFXOnTag(flameFX2,self,"j_spineupper");
                    for( i = 0; i < zombies.size; i++ )
                    {
                        if(distance(self.origin, zombies[i].origin) <= 220)
                        {
                            zombies[i] thread flames_fx();
                        }
                    }
        			self dodamage( self.health * 2, (0,0,0), attacker, attacker, "none", "MOD_IMPACT" );
                }
            }
            if(attacker.has_fireworks)
            {
                fireworks = aat_activation;
                if(fireworks == 1)
                {
                    attacker.aat_actived = 1;
                    attacker thread cool_down(aat_cooldown_time);
                    origin = self.origin;
                    weapon = attacker getcurrentweapon();
                    self thread spawn_weapon(origin, weapon, attacker);
                    self thread fireworks(origin);
                    self dodamage( self.health * 2, (0,0,0), attacker, attacker, "none", "MOD_IMPACT" );
                }
            }
		}
	}
	return [[level.original_damagecallback]]( inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex );
}

cool_down(time)
{
	level endon("end_game");
	self endon("disconnect");
	self.cooldown = 1;
	wait time;
	self.cooldown = 0;
}

explosive_bullet()
{
	level endon("end_game");
	self endon("disconnect");
	self.active_explosive_bullet = 1;
	for( ;; )
	{
		self waittill( "weapon_fired" );
		explosive = randomintrange(1,5);
		if(explosive == 1 && self.has_explosive_bullets && !self.cooldown)
		{
			self.aat_actived = 1;
			self thread cool_down(randomintrange(5,11));
			forward = self gettagorigin( "tag_weapon_right" );
			end = self thread vector_scal( anglestoforward( self getplayerangles() ), 1000000 );
			crosshair_entity = bullettrace(self gettagorigin("tag_weapon_right"),self gettagorigin("tag_weapon_right")+anglestoforward(self getplayerangles())*1000000,true,self)["entity"];
			crosshair = bullettrace( forward, end, 0, self )[ "position"];
			magicbullet( self getcurrentweapon(), self gettagorigin( "j_shouldertwist_le" ), crosshair, self );
			self enableInvulnerability();
			if(isdefined(crosshair_entity))
			{
				crosshair_entity playsound( "zmb_phdflop_explo" );
				playfx(loadfx("explosions/fx_default_explosion"), crosshair_entity.origin, anglestoforward( ( 0, 45, 55  ) ) );
				radiusdamage( crosshair_entity.origin, 300, 5000, 1000, self );
			}
			else
			{
				crosshair playsound( "zmb_phdflop_explo" );
				playfx(loadfx("explosions/fx_default_explosion"), crosshair, anglestoforward( ( 0, 45, 55  ) ) );
				radiusdamage( crosshair, 300, 5000, 1000, self );
			}
            wait .5;
			self disableInvulnerability();
		}
		wait .1;
	}
}

flames_fx()
{
	level endon("end_game");
	self endon("disconnect");
	for(i = 0; i < 5; i++)
	{
		flameFX=loadfx("env/fire/fx_fire_zombie_torso");
		PlayFXOnTag(flameFX, self, "j_spineupper");
		if(i < 3)
		{
			self dodamage(self.health / 2, (0,0,0));
		}
		else
		{
			self dodamage(self.maxhealth * 2, (0,0,0));
		}
		wait 1;
	}
}

fireworks(origin)
{
	level endon("end_game");
	self endon("disconnect");
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

spawn_weapon(origin, weapon, attacker)
{
	level endon("end_game");
	self endon("disconnect");
    attacker.firework_weapon = spawnentity( "script_model", getweaponmodel( weapon ), origin + (0,0,45), (0,0,0) + ( 0, 50, 0 ));
    for(i=0;i<100;i++)
    {
        zombies = get_array_of_closest( attacker.firework_weapon.origin, getaiarray( level.zombie_team ), undefined, undefined, 300  );
        forward = attacker.firework_weapon.origin;
        end = zombies[ 0 ] gettagorigin( "j_spineupper" );
        crosshair = bullettrace( forward, end, 0, self )[ "position"];
        attacker.firework_weapon.angles = VectorToAngles( end - attacker.firework_weapon.origin );
        if( distance(zombies[ 0 ].origin, attacker.firework_weapon.origin) <= 300)
        {
            magicbullet( weapon, attacker.firework_weapon.origin, crosshair, attacker.firework_weapon );
        }
        wait .05;
    }
    attacker.firework_weapon delete();
}

spawnentity( class, model, origin, angle )
{
	level endon("end_game");
	self endon("disconnect");
	entity = spawn( class, origin );
	entity.angles = angle;
	entity setmodel( model );
	return entity;
}

thunderwall( attacker ) 
{
	level endon("end_game");
	self endon("disconnect");
	thunder_wall_blast_pos = self.origin; 
	ai_zombies = get_array_of_closest( thunder_wall_blast_pos, getaiarray( level.zombie_team ), undefined, undefined, 250  );
    if ( !isDefined( ai_zombies ) )
	{
		return;
	}
	flung_zombies = 0;
    max_zombies = undefined;
    max_zombies = randomIntRange(5,25);
	for ( i = 0; i < ai_zombies.size; i++ )
	{
		if(isDefined(ai_zombies[i].is_avogadro) && ai_zombies[i].is_avogadro || isDefined(ai_zombies[i].is_brutus) && ai_zombies[i].is_brutus || isDefined(ai_zombies[i].is_mechz) && ai_zombies[i].is_mechz )
		{
			//boss zombie check
		}
		else
		{
			n_random_x = RandomFloatRange( -3, 3 );
			n_random_y = RandomFloatRange( -3, 3 );
			ai_zombies[i] StartRagdoll();
			ai_zombies[i] LaunchRagdoll( (n_random_x, n_random_y, 150) );
            playfxontag( level._effect[ "jetgun_smoke_cloud"], ai_zombies[i], "J_SpineUpper" );
            ai_zombies[i] DoDamage( ai_zombies[i].health * 2, ai_zombies[i].origin, attacker, attacker, "none", "MOD_IMPACT" );
        	flung_zombies++;
			if ( flung_zombies >= max_zombies )
			{
				break;
			}
		}
    }
}

Headcutter(attacker)
{
	level endon("end_game");
	self endon("disconnect");
    self endon("death");
    self maps\mp\zombies\_zm_spawner::zombie_head_gib();
    for(;;)
    {  	
		wait 1;
		damage = 100 * level.round_number;
        self dodamage( damage, self.origin, attacker, attacker, "none", "MOD_IMPACT" );
    }
}

cluster()
{
	level endon("end_game");
	self endon("disconnect");
	if(level.round_number < 10)
	{
		amount = randomIntRange(1, (level.round_number * 2));
	}
	else
	{
		amount = randomIntRange(7, level.round_number);
	}
	random_x = RandomFloatRange( -3,3 );
	random_y = RandomFloatRange( -3,3 );
	for(i = 0; i < amount; i++)
	{
		self MagicGrenadeType( "frag_grenade_zm", self.origin + (random_x, random_y, 10), (random_x, random_y, 0), 2 );
		wait .1;
	}
}

/*aat_hitmarker()
{
	self thread startwaiting();
	self.aat_hitmarker = newdamageindicatorhudelem( self );
	self.aat_hitmarker.horzalign = "center";
	self.aat_hitmarker.vertalign = "middle";
	self.aat_hitmarker.x = -12;
	self.aat_hitmarker.y = -12;
	self.aat_hitmarker.alpha = 0;
	self.aat_hitmarker setshader( "damage_feedback", 24, 48 );
}*/

startwaiting()
{
	level endon("end_game");
	self endon("disconnect");
	while( 1 )
	{
		foreach( zombie in getaiarray( level.zombie_team ) )
		{
			if( !(IsDefined( zombie.waitingfordamage )) )
			{
				//zombie thread aat_hitmarks();
			}
		}
		wait 0.25;
	}
}

/*aat_hitmarks()
{
	self.waitingfordamage = 1;
	while( 1 )
	{
		self waittill( "damage", amount, attacker, dir, point, mod );
		if(!isDefined(attacker.aat_actived))
		{
			attacker.aat_actived = 0;
		}
		attacker.aat_hitmarker.alpha = 0;
		if( isplayer( attacker ) )
		{
			if(attacker.aat_actived)
			{
				attacker.aat_hitmarker.alpha = 1;
				for(i=0;i<20;i++)
				{
					r = randomfloatrange(0.1, 0.9);
					g = randomfloatrange(0.1, 0.9);
					b = randomfloatrange(0.1, 0.9);
					attacker.aat_hitmarker.color = ( r, g, b );
					if(i > 5)
					{
						attacker.aat_hitmarker.alpha -= .075;
					}
					wait .1;
				}
				attacker.aat_hitmarker.alpha = 0;
				attacker.aat_actived = 0;
				self.waitingfordamage = 0;
				break;
			}
		}
	}
}*/

turned( attacker )
{
	level endon("end_game");
	self endon("disconnect");
	self.is_turned = 1;
	attacker.active_turned = 1;
	turned_zombie_kills = 0;
	max_kills = randomIntRange(15,21);

	self thread set_zombie_run_cycle( "sprint" );
	self.custom_goalradius_override = 1000000;

	//set turned icon for zombie
	//todo: icon takes zombies z origin from original ground not zombies z origin
	turned_icon = newHudElem();
    turned_icon.x = self.origin[ 0 ];
    turned_icon.y = self.origin[ 1 ];
    turned_icon.z = self.origin[ 2 ] + (0,0,80);
	turned_icon.color = (0,1,0);
    turned_icon.isshown = 1;
    turned_icon.archived = 0;
    turned_icon setshader( "hud_status_dead", 4, 4 );
    turned_icon setwaypoint( 1 );

	enemyoverride = [];

	//cannot damage player
	self.team = level.players; 
	
	//allow round change while turned zombie is alive
	self.ignore_enemy_count = 1;

	if(getdvar("mapname") == "zm_tomb")
		attackanim = "zm_generator_melee";
	else
		attackanim = "zm_riotshield_melee";
	
	if ( !self.has_legs )
	{
		attackanim += "_crawl";
	}
	
	while(isAlive(self))
	{
		turned_icon.x = self.origin[ 0 ];
		turned_icon.y = self.origin[ 1 ];
		turned_icon.z = self.origin[ 2 ] + (0,0,80);

		ai_zombies = get_array_of_closest( self.origin, getaiarray( level.zombie_team ), undefined, undefined, undefined  );
		if(isdefined(ai_zombies[1]))
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
			ai_zombies[1] dodamage(ai_zombies[1].maxhealth * 2, ai_zombies[1].origin);
			turned_zombie_kills++;

			if(turned_zombie_kills > max_kills)
			{
				self.is_turned = 0;
				wait .1;
				self dodamage(self.maxhealth * 2, self.origin);
			}

			wait 1;
		}
		else
			self stopanimscripted();

		wait .05; 
	}
	attacker.active_turned = 0;
	self.is_turned = 0;
	turned_icon destroy();
}

turned_zombie()
{
	level endon("end_game");
	self endon("disconnect");
	if(self.turned)
	{
		//attack zombies
	}
	else
	{
		zombie_poi = self get_zombie_point_of_interest( self.origin );
	}
	return zombie_poi;
}

turned_zombie_validation()
{	
	level endon("end_game");
	self endon("disconnect");
	if( IS_TRUE( self.barricade_enter ) )
	{
		return false;
	}
	if ( IS_TRUE( self.is_traversing ) )
	{
		return false;
	}
	if ( !IS_TRUE( self.completed_emerging_into_playable_area ) )
	{
		return false;
	}
	if ( IS_TRUE( self.is_leaping ) )
	{
		return false;
	}
	if ( IS_TRUE( self.is_inert ) )
	{
		return false;
	}
	
	return true;
}

is_true(check)
{
	return(IsDefined(check) && check);
}

save_aat()
{
	level endon("end_game");
	self endon("disconnect");
	self endon("new_aat");
	self endon("disconnect");
	if(isDefined(self.saved_aat_weapons))
		self.saved_aat_weapons = [];

	if(isDefined(self.saved_aat_weapons_name))
		self.saved_aat_weapons_name = [];

	weapons = self getweaponslistprimaries();
	
	if(weapons.size > 0 && isDefined(self.weapon_aats[0]))
	{
		self.saved_aat_weapons_name[0] = self.aat_weapon[0];
		self.saved_aat_weapons[0] = self.weapon_aats[0];
	}
	else
	{
		self.saved_aat_weapons[2] = undefined;
		self.saved_aat_weapons_name[2] = undefined;
	}

	if(weapons.size > 1 && isDefined(self.weapon_aats[1]))
	{
		self.saved_aat_weapons_name[1] = self.aat_weapon[1];
		self.saved_aat_weapons[1] = self.weapon_aats[1];
	}
	else
	{
		self.saved_aat_weapons[2] = undefined;
		self.saved_aat_weapons_name[2] = undefined;
	}

	if(weapons.size > 2 && isDefined(self.weapon_aats[2]))
	{
		self.saved_aat_weapons_name[2] = self.aat_weapon[2];
		self.saved_aat_weapons[2] = self.weapon_aats[2];
	}
	else
	{
		self.saved_aat_weapons[2] = undefined;
		self.saved_aat_weapons_name[2] = undefined;
	}
}

//----whos who recover aat----------------------------------------------------------------------------

chugabud_laststand()
{
	level endon("end_game");
	self endon("disconnect");
    self endon( "player_suicide" );
    self endon( "disconnect" );
    self endon( "chugabud_bleedout" );
    self maps\mp\zombies\_zm_laststand::increment_downed_stat();
    self.ignore_insta_kill = 1;
    self.health = self.maxhealth;
    self maps\mp\zombies\_zm_chugabud::chugabud_save_loadout();
    self maps\mp\zombies\_zm_chugabud::chugabud_fake_death();
    wait 3;

    if ( isdefined( self.insta_killed ) && self.insta_killed || isdefined( self.disable_chugabud_corpse ) )
        create_corpse = 0;
    else
        create_corpse = 1;

    if ( create_corpse == 1 )
    {
        if ( isdefined( level._chugabug_reject_corpse_override_func ) )
        {
            reject_corpse = self [[ level._chugabug_reject_corpse_override_func ]]( self.origin );

            if ( reject_corpse )
                create_corpse = 0;
        }
    }

    if ( create_corpse == 1 )
    {
        self thread activate_chugabud_effects_and_audio();
        corpse = self chugabud_spawn_corpse();
        corpse thread chugabud_corpse_revive_icon( self );
        self.e_chugabud_corpse = corpse;
        corpse thread chugabud_corpse_cleanup_on_spectator( self );

        if ( isdefined( level.whos_who_client_setup ) )
            corpse setclientfield( "clientfield_whos_who_clone_glow_shader", 1 );
    }

    self chugabud_fake_revive();
    wait 0.1;
    self.ignore_insta_kill = undefined;
    self.disable_chugabud_corpse = undefined;

    if ( create_corpse == 0 )
    {
        self notify( "chugabud_effects_cleanup" );
        return;
    }

    bleedout_time = getdvarfloat( "player_lastStandBleedoutTime" );
    self thread chugabud_bleed_timeout( bleedout_time, corpse );
    self thread chugabud_handle_multiple_instances( corpse );

    corpse waittill( "player_revived", e_reviver );

    if ( isdefined( e_reviver ) && e_reviver == self )
        self notify( "whos_who_self_revive" );

    self perk_abort_drinking( 0.1 );
    self maps\mp\zombies\_zm_perks::perk_set_max_health_if_jugg( "health_reboot", 1, 0 );
    self setorigin( corpse.origin );
    self setplayerangles( corpse.angles );

    if ( self player_is_in_laststand() )
    {
        self thread chugabud_laststand_cleanup( corpse, "player_revived" );
        self enableweaponcycling();
        self enableoffhandweapons();
        self auto_revive( self, 1 );
        return;
    }

    self chugabud_laststand_cleanup( corpse, undefined );
}

chugabud_laststand_cleanup( corpse, str_notify )
{
	level endon("end_game");
	self endon("disconnect");
    if ( isdefined( str_notify ) )
        self waittill( str_notify );

    self chugabud_give_loadout();
    self chugabud_corpse_cleanup( corpse, 1 );
}

chugabud_give_loadout()
{
	level endon("end_game");
	self endon("disconnect");
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

        if ( loadout.weapons[i]["name"] == "none" )
            continue;

        self maps\mp\zombies\_zm_weapons::weapondata_give( loadout.weapons[i] );
    }

    if ( loadout.current_weapon >= 0 && isdefined( loadout.weapons[loadout.current_weapon]["name"] ) )
        self switchtoweapon( loadout.weapons[loadout.current_weapon]["name"] );

    self giveweapon( "knife_zm" );
    self maps\mp\zombies\_zm_equipment::equipment_give( self.loadout.equipment );
    loadout restore_weapons_for_chugabud( self );
    self chugabud_restore_claymore();
    self.score = loadout.score;
    self.pers["score"] = loadout.score;
    perk_array = maps\mp\zombies\_zm_perks::get_perk_array( 1 );

    for ( i = 0; i < perk_array.size; i++ )
    {
        perk = perk_array[i];
        self unsetperk( perk );
        self.num_perks--;
        self set_perk_clientfield( perk, 0 );
    }

    if ( isdefined( loadout.perks ) && loadout.perks.size > 0 )
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

    self chugabud_restore_grenades();

    if ( maps\mp\zombies\_zm_weap_cymbal_monkey::cymbal_monkey_exists() )
    {
        if ( loadout.zombie_cymbal_monkey_count )
        {
            self maps\mp\zombies\_zm_weap_cymbal_monkey::player_give_cymbal_monkey();
            self setweaponammoclip( "cymbal_monkey_zm", loadout.zombie_cymbal_monkey_count );
        }
    }

	if(isDefined(self.saved_aat_weapons[0]))
	{
		self.weapon_aats[0] = self.saved_aat_weapons[0];
		self.aat_weapon[0] = self.saved_aat_weapons_name[0];
	}
	else
	{
		self.saved_aat_weapons[0] = undefined;
		self.saved_aat_weapons_name[0] = undefined;
	}
	if(isDefined(self.saved_aat_weapons[1]))
	{
		self.weapon_aats[1] = self.saved_aat_weapons[1];
		self.aat_weapon[1] = self.saved_aat_weapons_name[1];
	}
	else
	{
		self.saved_aat_weapons[1] = undefined;
		self.saved_aat_weapons_name[1] = undefined;
	}
	if(isDefined(self.saved_aat_weapons[2]))
	{
		self.weapon_aats[2] = self.saved_aat_weapons[2];
		self.aat_weapon[2] = self.saved_aat_weapons_name[2];
	}
	else
	{
		self.saved_aat_weapons[2] = undefined;
		self.saved_aat_weapons_name[2] = undefined;
	}
	self notify("weapon_change");
}

//-------tombstone recover aat------------------------------------------------------------------

tombstone_spawn()
{
	level endon("end_game");
	self endon("disconnect");
    dc = spawn( "script_model", self.origin + vectorscale( ( 0, 0, 1 ), 40.0 ) );
    dc.angles = self.angles;
    dc setmodel( "tag_origin" );
    dc_icon = spawn( "script_model", self.origin + vectorscale( ( 0, 0, 1 ), 40.0 ) );
    dc_icon.angles = self.angles;
    dc_icon setmodel( "ch_tombstone1" );
    dc_icon linkto( dc );
    dc.icon = dc_icon;
    dc.script_noteworthy = "player_tombstone_model";
    dc.player = self;
    self thread tombstone_clear();
    dc thread tombstone_wobble();
    dc thread tombstone_revived( self );
    result = self waittill_any_return( "player_revived", "spawned_player", "disconnect" );

    if ( result == "player_revived" || result == "disconnect" )
    {
        dc notify( "tombstone_timedout" );
        dc_icon unlink();
        dc_icon delete();
        dc delete();
        return;
    }

    dc thread tombstone_timeout();
    dc thread tombstone_grab();
}

tombstone_grab()
{
	level endon("end_game");
	self endon("disconnect");
    self endon( "tombstone_timedout" );
    wait 1;

    while ( isdefined( self ) )
    {
        players = get_players();

        for ( i = 0; i < players.size; i++ )
        {
            if ( players[i].is_zombie )
                continue;

            if ( isdefined( self.player ) && players[i] == self.player )
            {
                tombstone_machine_triggers = getentarray( "specialty_scavenger", "script_noteworthy" );
                istombstonepowered = 0;

                foreach ( trigger in tombstone_machine_triggers )
                {
                    if ( isdefined( trigger.power_on ) && trigger.power_on || isdefined( trigger.turbine_power_on ) && trigger.turbine_power_on )
                        istombstonepowered = 1;
                }

                if ( istombstonepowered )
                {
                    dist = distance( players[i].origin, self.origin );

                    if ( dist < 64 )
                    {
                        playfx( level._effect["powerup_grabbed"], self.origin );
                        playfx( level._effect["powerup_grabbed_wave"], self.origin );
                        players[i] tombstone_give();
                        wait 0.1;
                        playsoundatposition( "zmb_tombstone_grab", self.origin );
                        self stoploopsound();
                        self.icon unlink();
                        self.icon delete();
                        self delete();
                        self notify( "tombstone_grabbed" );
                        players[i] clientnotify( "dc0" );
                        players[i] notify( "dance_on_my_grave" );
                    }
                }
            }
        }

        wait_network_frame();
    }
}

tombstone_give()
{
	level endon("end_game");
	self endon("disconnect");
    dc = level.tombstones[self.tombstone_index];

    if ( !flag( "solo_game" ) )
    {
        primaries = self getweaponslistprimaries();

        if ( dc.weapon.size > 1 || primaries.size > 1 )
        {
            foreach ( weapon in primaries )
                self takeweapon( weapon );
        }

        for ( i = 0; i < dc.weapon.size; i++ )
        {
            if ( !isdefined( dc.weapon[i] ) )
                continue;

            if ( dc.weapon[i] == "none" )
                continue;

            weapon = dc.weapon[i];
            stock = dc.stockcount[i];

            if ( !self hasweapon( weapon ) )
            {
                self giveweapon( weapon, 0, self maps\mp\zombies\_zm_weapons::get_pack_a_punch_weapon_options( weapon ) );
                self setweaponammoclip( weapon, weaponclipsize( weapon ) );
                self setweaponammostock( weapon, stock );

                if ( i == dc.current_weapon )
                    self switchtoweapon( weapon );
            }
        }
    }

    if ( isdefined( dc.hasriotshield ) && dc.hasriotshield )
    {
        self maps\mp\zombies\_zm_equipment::equipment_give( "riotshield_zm" );

        if ( isdefined( self.player_shield_reset_health ) )
            self [[ self.player_shield_reset_health ]]();
    }

    dc restore_weapons_for_tombstone( self );

    if ( isdefined( dc.hasclaymore ) && dc.hasclaymore && !self hasweapon( "claymore_zm" ) )
    {
        self giveweapon( "claymore_zm" );
        self set_player_placeable_mine( "claymore_zm" );
        self setactionslot( 4, "weapon", "claymore_zm" );
        self setweaponammoclip( "claymore_zm", dc.claymoreclip );
    }

    if ( isdefined( dc.hasemp ) && dc.hasemp )
    {
        self giveweapon( "emp_grenade_zm" );
        self setweaponammoclip( "emp_grenade_zm", dc.empclip );
    }

    if ( isdefined( dc.perk ) && dc.perk.size > 0 )
    {
        for ( i = 0; i < dc.perk.size; i++ )
        {
            if ( self hasperk( dc.perk[i] ) )
                continue;

            if ( dc.perk[i] == "specialty_quickrevive" && flag( "solo_game" ) )
                continue;

            maps\mp\zombies\_zm_perks::give_perk( dc.perk[i] );
        }
    }

    if ( dc.grenade > 0 && !flag( "solo_game" ) )
    {
        curgrenadecount = 0;

        if ( self hasweapon( self get_player_lethal_grenade() ) )
            self getweaponammoclip( self get_player_lethal_grenade() );
        else
            self giveweapon( self get_player_lethal_grenade() );

        self setweaponammoclip( self get_player_lethal_grenade(), dc.grenade + curgrenadecount );
    }

    if ( maps\mp\zombies\_zm_weap_cymbal_monkey::cymbal_monkey_exists() && !flag( "solo_game" ) )
    {
        if ( dc.zombie_cymbal_monkey_count )
        {
            self maps\mp\zombies\_zm_weap_cymbal_monkey::player_give_cymbal_monkey();
            self setweaponammoclip( "cymbal_monkey_zm", dc.zombie_cymbal_monkey_count );
        }
    }

	if(isDefined(self.saved_aat_weapons[0]))
	{
		self.weapon_aats[0] = self.saved_aat_weapons[0];
		self.aat_weapon[0] = self.saved_aat_weapons_name[0];
	}
	else
	{
		self.saved_aat_weapons[0] = undefined;
		self.saved_aat_weapons_name[0] = undefined;
	}
	if(isDefined(self.saved_aat_weapons[1]))
	{
		self.weapon_aats[1] = self.saved_aat_weapons[1];
		self.aat_weapon[1] = self.saved_aat_weapons_name[1];
	}
	else
	{
		self.saved_aat_weapons[1] = undefined;
		self.saved_aat_weapons_name[1] = undefined;
	}
	if(isDefined(self.saved_aat_weapons[2]))
	{
		self.weapon_aats[2] = self.saved_aat_weapons[2];
		self.aat_weapon[2] = self.saved_aat_weapons_name[2];
	}
	else
	{
		self.saved_aat_weapons[2] = undefined;
		self.saved_aat_weapons_name[2] = undefined;
	}
	self notify("weapon_change");
}

//---------


solo_tombstone_removal()
{
	notify( "tombstone_on" );
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
