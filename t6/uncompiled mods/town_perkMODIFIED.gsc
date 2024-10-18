//PLUTO v1 - TOWN Survival with Dogs

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
init()
{
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
	    level._effect["fx_zombie_cola_revive_on"] = loadfx( "misc/fx_zombie_cola_revive_on" );
	    level._effect["fx_zombie_cola_dtap_on"] = loadfx( "misc/fx_zombie_cola_dtap_on" );
	    level._effect["fx_zombie_cola_on"] = loadfx( "misc/fx_zombie_cola_on" );
	    level._effect["fx_zmb_wall_buy_taseknuck"] = loadfx( "maps/zombie/fx_zmb_wall_buy_taseknuck" );
	    level._effect["fx_zmb_wall_buy_bowie"] = loadfx( "maps/zombie/fx_zmb_wall_buy_bowie" );
	 //   level._effect["fx_default_explosion"] = loadfx( "explosions/fx_default_explosion" );

	
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
		level thread perk_machine_removal( "specialty_scavenger" );
		init_custom_map(); 

	    level.get_player_weapon_limit = ::custom_get_player_weapon_limit;
	    level.zombie_last_stand = ::LastStand;
	    level.custom_vending_precaching = ::default_vending_precaching;

	    register_player_damage_callback( ::damage_callback );
		


       
	    level.player_out_of_playable_area_monitor = 0;
	    level.perk_purchase_limit = 50;
		foreach( weapon in level.zombie_weapons) 
		{
			weapon.is_in_box = 1;
		}
// }
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



damagehitmarker()
{
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
        if( getdvar( "mapname" ) == "zm_transit" && getdvar ( "g_gametype" )  == "zstandard" )
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
	perk_system( "script_model", ( 1478.64, 1529.64, 3216.13 ), "zombie_vending_jugg_on", ( 0, 182.54, 0 ), "custom", "mus_perks_packa_sting", "Electric Cherry", 2000, "tombstone_light", "ELECTRIC_CHERRY" ); // 613,-250,z 0,0,0
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
//	perk_system( "script_model", (  ), "zombie_vending_jugg_on", ( 0, 283.349, 0 ), "custom", "mus_perks_doubletap_sting", "Mule Kick", 4000, "sleight_light", "MULE" );
	perk_system( "script_model", ( 1152.5, 160.6, 79.125 ), "zombie_vending_jugg_on", ( 0, 283.349, 0 ), "custom", "mus_perks_packa_sting", "PhD Flopper", 2500, "sleight_light", "PHD_FLOPPER" );
	perk_system( "script_model", ( 156.738, 513.899, -62.3141 ), "zombie_vending_jugg_on", ( 0, 101.8164, 0 ), "custom", "mus_perks_doubletap_sting", "Downer's Delight", 2000, "sleight_light", "Downers_Delight" );
	perk_system( "script_model", ( -646.863, 271.522, -55.875 ), "zombie_vending_jugg_on", ( 0, 160.8405, 0 ), "custom", "mus_perks_doubletap_sting", "Dying Wish", 6000, "sleight_light", "Dying_Wish" );
	perk_system( "script_model", ( -1582.46, 112.604, -63.2092 ), "zombie_vending_jugg_on", ( 0, 250.829, 0 ), "custom", "mus_perks_doubletap_sting", "Ammo Regen", 3000, "sleight_light", "Ammo_Regen" );
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
			    	    player thread drawshader_and_shadermove( perk, 1, 1 );
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
        self drawshader_and_shadermove("none", 0, 0);
    }
}

drawshader_and_shadermove(perk, custom, print)
{
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
    x = -408 + (self.perk_count * 30);
    for(i = 0; i < self.perkarray.size; i++)
	{
    	self.perkarray[i].x = self.perkarray[i].x + 30;
	}
        if(perk == "Downers_Delight")
        {
            self.perk1back = self drawshader( "specialty_marathon_zombies", x, 350, 24, 24, ( 0, 0, 0 ), 100, 0 );  
            self.perk1front = self drawshader( "waypoint_revive", x, 350, 23, 23, ( 0, 1, 1 ), 100, 0 ); 
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
            self.perk2back = self drawshader( "specialty_marathon_zombies", x, 350, 24, 24, ( 0, 0, 0 ), 100, 0 );
            self.perk2front = self drawshader( "menu_mp_weapons_1911", x, 350, 22, 22, ( 0, 1, 0 ), 100, 0 );
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
            self.perk3back = self drawshader( "specialty_marathon_zombies", x, 350, 24, 24, ( 0, 0, 0 ), 100, 0 );
            self.perk3front = self drawshader( "hud_icon_sticky_grenade", x, 350, 23, 23, (1, 0, 1 ), 100, 0 );
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
            self.perk4back = self drawshader( "specialty_marathon_zombies", x, 350, 24, 24, ( 0, 200, 0 ), 100, 0 );
            self.perk4front = self drawshader( "zombies_rank_2", x, 350, 23, 23, ( 1, 1, 1 ), 100, 0 );
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
            self.perk5back = self drawshader( "specialty_marathon_zombies", x, 350, 24, 24, ( 0, 0, 200 ), 100, 0 );
            self.perk5front = self drawshader( "zombies_rank_5", x, 350, 23, 23, ( 1, 1, 1 ), 100, 0 );
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
            self.perk6back = self drawshader( "specialty_marathon_zombies", x, 350, 24, 24, ( 0, 0, 0 ), 100, 0 );
            self.perk6front = self drawshader( "zombies_rank_3", x, 350, 23, 23, ( 1, 1, 1 ), 100, 0 );
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
            self.perk7back = self drawshader( "specialty_marathon_zombies", x, 350, 24, 24, ( 200, 0, 0 ), 100, 0 );
            self.perk7front = self drawshader( "zombies_rank_4", x, 350, 23, 23, ( 1, 1, 1 ), 100, 0 );
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
            self.perk8back = self drawshader( "specialty_marathon_zombies", x, 350, 24, 24, ( 0, 0, 0 ), 100, 0 );
            self.perk8front = self drawshader( "menu_mp_lobby_icon_customgamemode", x, 350, 23, 23, ( 1, 1, 1 ), 100, 0 );
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
            self.perk9back = self drawshader( "specialty_marathon_zombies", x, 350, 24, 24, ( 200, 0, 0 ), 100, 0 );
            self.perk9front = self drawshader( "faction_cdc", x, 350, 23, 23, ( 1, 1, 1 ), 100, 0 );
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
            self.perk10back = self drawshader( "specialty_marathon_zombies", x, 350, 24, 24, ( 200, 0, 0 ), 100, 0 );
            self.perk10front = self drawshader( "zombies_rank_5", x, 350, 23, 23, ( 1, 1, 1 ), 100, 0 );
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
            self.perk11back = self drawshader( "specialty_marathon_zombies", x, 350, 24, 24, ( 0, 0, 0 ), 100, 0 );
            self.perk11front = self drawshader( "killiconheadshot", x, 350, 23, 23, ( 1, 1, 1 ), 100, 0 );
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
		if(!self GetCurrentWeapon() == "" && !is_grenade_launcher( self GetCurrentWeapon()) )
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
	hint = spawn( "trigger_radius", origin, 1, width, height );
	hint setcursorhint( cursorhint, hint );
	hint sethintstring( string );
	hint setvisibletoall();
	wait 0.2;
	hint delete();
}


ww_points( player )
{
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
    ent = spawn( "script_model", origin );
    ent setmodel( model );
    if( IsDefined( angles ) )
    {
        ent.angles = angles;
    }
    return ent;
}


damage_callback( einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime, boneindex )
{
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
	fire_ent = spawn( "script_model", self.origin );
	wait_network_frame();
	fire_ent linkto( self );
	fire_ent playloopsound( "evt_plr_fire_loop" );
	self waittill_any( "stop_flame_damage", "stop_flame_sounds", "death", "disconnect" );
	fire_ent delete();
}
