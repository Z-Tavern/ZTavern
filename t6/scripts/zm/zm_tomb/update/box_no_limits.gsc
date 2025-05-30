#include maps\mp\zombies\_zm_stats;
#include maps\mp\_demo;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_pers_upgrades_functions;
#include maps\mp\zombies\_zm_audio_announcer;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_magicbox_lock;

init() //checked matches cerberus output
{
	//begin debug code
	level.custom_zm_magicbox_loaded = 1;
	maps/mp/zombies/_zm_bot::init();
	if ( !isDefined( level.debugLogging_zm_magicbox ) )
	{
		level.debugLogging_zm_magicbox = 0;
	}
	//end debug code
	if ( !isDefined( level.chest_joker_model ) )
	{
		level.chest_joker_model = "zombie_teddybear";
		precachemodel( level.chest_joker_model );
	}
	

	if ( is_true( level.using_locked_magicbox ) )
	{
		maps/mp/zombies/_zm_magicbox_lock::init();
	}
	if ( is_classic() )
	{
		level.chests = getstructarray( "treasure_chest_use", "targetname" );
		treasure_chest_init( "start_chest" );
	}
	if ( level.createfx_enabled )
	{
		return;
	}

	if ( !isDefined( level.magic_box_check_equipment ) )
	{
		level.magic_box_check_equipment = ::default_magic_box_check_equipment;
	}
	level thread magicbox_host_migration();
}

treasure_chest_init( start_chest_name ) //checked changed to match cerberus output
{
	flag_init( "moving_chest_enabled" );
	flag_init( "moving_chest_now" );
	flag_init( "chest_has_been_used" );
	level.chest_moves = 0;
	level.chest_level = 0;
	if ( level.chests.size == 0 )
	{
		return;
	}
	for ( i = 0; i < level.chests.size; i++ )
	{
		level.chests[ i ].box_hacks = [];
		level.chests[ i ].orig_origin = level.chests[ i ].origin;
		level.chests[ i ] get_chest_pieces();
		if ( isDefined( level.chests[ i ].zombie_cost ) )
		{
			level.chests[ i ].old_cost = level.chests[ i ].zombie_cost;
		}
		else 
		{
			level.chests[ i ].old_cost = 950;
		}
	}
	if ( !level.enable_magic )
	{
		foreach( chest in level.chests )
		{
			chest hide_chest();
		}
		return;
	}
	level.chest_accessed = 0;
	if ( level.chests.size > 1 )
	{
		flag_set( "moving_chest_enabled" );
		level.chests = array_randomize( level.chests );
	}
	else
	{
		level.chest_index = 0;
		level.chests[ 0 ].no_fly_away = 1;
	}
	init_starting_chest_location( start_chest_name );
	array_thread( level.chests, ::treasure_chest_think );
}

init_starting_chest_location( start_chest_name ) //checked changed to match cerberus output
{
	level.chest_index = 0;
	start_chest_found = 0;
	if ( level.chests.size == 1 )
	{
		start_chest_found = 1;
		if ( isdefined( level.chests[ level.chest_index ].zbarrier ) )
		{
			level.chests[ level.chest_index ].zbarrier set_magic_box_zbarrier_state( "initial" );
		}
	}
	else
	{
		for ( i = 0; i < level.chests.size; i++ )
		{
			if ( isdefined( level.random_pandora_box_start ) && level.random_pandora_box_start == 1 )
			{
				if ( start_chest_found || isdefined( level.chests[ i ].start_exclude ) && level.chests[ i ].start_exclude == 1 )
				{
					level.chests[ i ] hide_chest();
				}
				else
				{
					level.chest_index = i;
					level.chests[ level.chest_index].hidden = 0;
					if ( isdefined( level.chests[ level.chest_index ].zbarrier ) )
					{
						level.chests[ level.chest_index ].zbarrier set_magic_box_zbarrier_state( "initial" );
					}
					start_chest_found = 1;
				}
			}
			else
			{
				if ( start_chest_found || !isdefined(level.chests[ i ].script_noteworthy) || !issubstr( level.chests[ i ].script_noteworthy, start_chest_name ) )
				{
					level.chests[ i ] hide_chest();
				}
				else
				{
					level.chest_index = i;
					level.chests[ level.chest_index ].hidden = 0;
					if ( isdefined( level.chests[ level.chest_index ].zbarrier ) )
					{
						level.chests[ level.chest_index ].zbarrier set_magic_box_zbarrier_state( "initial" );
					}
					start_chest_found = 1;
				}
			}
		}
	}
	if ( !isdefined( level.pandora_show_func ) )
	{
		level.pandora_show_func = ::default_pandora_show_func;
	}
	level.chests[ level.chest_index ] thread [[ level.pandora_show_func ]]();
}

set_treasure_chest_cost( cost ) //checked matches cerberus output
{
	level.zombie_treasure_chest_cost = cost;
}

get_chest_pieces() //checked changed to match cerberus output
{
	self.chest_box = getent( self.script_noteworthy + "_zbarrier", "script_noteworthy" );
	self.chest_rubble = [];
	rubble = getentarray( self.script_noteworthy + "_rubble", "script_noteworthy" );
	for ( i = 0; i < rubble.size; i++ )
	{
		if ( distancesquared( self.origin, rubble[ i ].origin ) < 10000 )
		{
			self.chest_rubble[ self.chest_rubble.size ] = rubble[ i ];
		}
	}
	self.zbarrier = getent( self.script_noteworthy + "_zbarrier", "script_noteworthy" );
	if ( isDefined( self.zbarrier ) )
	{
		self.zbarrier zbarrierpieceuseboxriselogic( 3 );
		self.zbarrier zbarrierpieceuseboxriselogic( 4 );
	}
	self.unitrigger_stub = spawnstruct();
	self.unitrigger_stub.origin = self.origin + ( anglesToRight( self.angles ) * -22.5 );
	self.unitrigger_stub.angles = self.angles;
	self.unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
	self.unitrigger_stub.script_width = 104;
	self.unitrigger_stub.script_height = 50;
	self.unitrigger_stub.script_length = 45;
	self.unitrigger_stub.trigger_target = self;
	unitrigger_force_per_player_triggers( self.unitrigger_stub, 1 );
	self.unitrigger_stub.prompt_and_visibility_func = ::boxtrigger_update_prompt;
	self.zbarrier.owner = self;
}

boxtrigger_update_prompt( player ) //checked matches cerberus output
{
	can_use = self boxstub_update_prompt( player );
	if ( isDefined( self.hint_string ) )
	{
		if ( isDefined( self.hint_parm1 ) )
		{
			self sethintstring( self.hint_string, self.hint_parm1 );
		}
		else
		{
			self sethintstring( self.hint_string );
		}
	}
	return can_use;
}

boxstub_update_prompt( player ) //checked matches cerberus output
{
	self setcursorhint( "HINT_NOICON" );
	if ( !self trigger_visible_to_player( player ) )
	{
		return 0;
	}
	self.hint_parm1 = undefined;
	if ( is_true( self.stub.trigger_target.grab_weapon_hint ) )
	{
		if ( isDefined( level.magic_box_check_equipment ) && [[ level.magic_box_check_equipment ]]( self.stub.trigger_target.grab_weapon_name ) )
		{
			self.hint_string = &"ZOMBIE_TRADE_EQUIP";
		}
		else
		{
			self.hint_string = &"ZOMBIE_TRADE_WEAPON";
		}
	}
	else if ( is_true( level.using_locked_magicbox ) && is_true( self.stub.trigger_target.is_locked ) )
	{
		self.hint_string = get_hint_string( self, "locked_magic_box_cost" );
	}
	else
	{
		self.hint_parm1 = self.stub.trigger_target.zombie_cost;
		self.hint_string = get_hint_string( self, "default_treasure_chest" );
	}
	return 1;
}

default_magic_box_check_equipment( weapon ) //checked matches cerberus output
{
	return is_offhand_weapon( weapon );
}

trigger_visible_to_player( player ) //checked changed to match cerberus output
{
	self setinvisibletoplayer( player );
	visible = 1;
	if ( isDefined( self.stub.trigger_target.chest_user ) && !isDefined( self.stub.trigger_target.box_rerespun ) )
	{
		if ( player != self.stub.trigger_target.chest_user || is_placeable_mine( self.stub.trigger_target.chest_user getcurrentweapon() ) || self.stub.trigger_target.chest_user hacker_active() )
		{
			visible = 0;
		}
	}
	else if ( !player can_buy_weapon() )
	{
		visible = 0;
	}
	if ( !visible )
	{
		return 0;
	}
	self setvisibletoplayer( player );
	return 1;
}

magicbox_unitrigger_think() //checked changed to match cerberus output
{
	self endon( "kill_trigger" );
	while ( 1 )
	{
		self waittill( "trigger", player );
		self.stub.trigger_target notify( "trigger", player );
	}
}

play_crazi_sound() //checked matches cerberus output
{
	self playlocalsound( level.zmb_laugh_alias );
}

show_chest_sound_thread() //checked matches cerberus output
{

}

show_chest() //checked matches cerberus output
{
	self.zbarrier set_magic_box_zbarrier_state( "arriving" );
	self.zbarrier waittill( "arrived" );
	self thread [[ level.pandora_show_func ]]();
	thread maps/mp/zombies/_zm_unitrigger::register_static_unitrigger( self.unitrigger_stub, ::magicbox_unitrigger_think );
	self thread show_chest_sound_thread();
	self.hidden = 0;
	if ( isDefined( self.box_hacks[ "summon_box" ] ) )
	{
		self [[ self.box_hacks[ "summon_box" ] ]]( 0 );
	}
}

hide_chest_sound_thread() //checked matches cerberus output
{

}

hide_chest( doboxleave ) //checked matches cerberus output
{
	if ( isDefined( self.unitrigger_stub ) )
	{
		thread maps/mp/zombies/_zm_unitrigger::unregister_unitrigger( self.unitrigger_stub );
	}
	if ( isDefined( self.pandora_light ) )
	{
		self.pandora_light delete();
	}
	self.hidden = 1;
	if ( isDefined( self.box_hacks ) && isDefined( self.box_hacks[ "summon_box" ] ) )
	{
		self [[ self.box_hacks[ "summon_box" ] ]]( 1 );
	}
	if ( isDefined( self.zbarrier ) )
	{
		if ( is_true( doboxleave ) )
		{
			self thread hide_chest_sound_thread();
			level thread leaderdialog( "boxmove" );
			self.zbarrier thread magic_box_zbarrier_leave();
			self.zbarrier waittill( "left" );
			playfx( level._effect[ "poltergeist" ], self.zbarrier.origin, anglesToUp( self.angles ), anglesToForward( self.angles ) );
			playsoundatposition( "zmb_box_poof", self.zbarrier.origin );
			return;
		}
		else
		{
			self.zbarrier thread set_magic_box_zbarrier_state( "away" );
		}
	}
}

magic_box_zbarrier_leave() //checked matches cerberus output
{
	self set_magic_box_zbarrier_state( "leaving" );
	self waittill( "left" );
	self set_magic_box_zbarrier_state( "away" );
}

default_pandora_fx_func() //checked partially changed to match cerberus output
{
	self endon( "death" );
	self.pandora_light = spawn( "script_model", self.zbarrier.origin );
	self.pandora_light.angles = self.zbarrier.angles + vectorScale( ( -1, 0, -1 ), 90 );
	self.pandora_light setmodel( "tag_origin" );
	if ( !is_true( level._box_initialized ) )
	{
		flag_wait( "start_zombie_round_logic" );
		level._box_initialized = 1;
	}
	wait 1;
	if ( isDefined( self ) && isDefined( self.pandora_light ) )
	{
		playfxontag( level._effect[ "lght_marker" ], self.pandora_light, "tag_origin" );
	}
}

default_pandora_show_func( anchor, anchortarget, pieces ) //checked matches cerberus output
{
	if ( !isDefined( self.pandora_light ) )
	{
		if ( !isDefined( level.pandora_fx_func ) )
		{
			level.pandora_fx_func = ::default_pandora_fx_func;
		}
		self thread [[ level.pandora_fx_func ]]();
	}
	playfx( level._effect[ "lght_marker_flare" ], self.pandora_light.origin );
}

unregister_unitrigger_on_kill_think() //checked matches cerberus output
{
	self notify( "unregister_unitrigger_on_kill_think" );
	self endon( "unregister_unitrigger_on_kill_think" );
	self waittill( "kill_chest_think" );
	thread maps/mp/zombies/_zm_unitrigger::unregister_unitrigger( self.unitrigger_stub );
}

treasure_chest_think() //checked changed to match cerberus output
{
	self endon( "kill_chest_think" );
	user = undefined;
	user_cost = undefined;
	self.box_rerespun = undefined;
	self.weapon_out = undefined;

	self thread unregister_unitrigger_on_kill_think();
	while ( 1 )
	{
		if ( !isdefined( self.forced_user ) )
		{
			self waittill( "trigger", user );
			if ( user == level )
			{
				wait 0.1;
				continue;
			}
		}
		else
		{
			user = self.forced_user;
		}
		if ( user in_revive_trigger() )
		{
			wait 0.1;
			continue;
		}
		if ( user.is_drinking > 0 )
		{
			wait 0.1;
			continue;
		}
		if ( is_true( self.disabled ) )
		{
			wait 0.1;
			continue;
		}
		if ( user getcurrentweapon() == "none" )
		{
			wait 0.1;
			continue;
		}
		reduced_cost = undefined;
		if ( is_player_valid( user ) && user maps/mp/zombies/_zm_pers_upgrades_functions::is_pers_double_points_active() )
		{
			reduced_cost = int( self.zombie_cost / 2 );
		}
		if ( is_true( self.is_locked ) ) 
		{
			if ( user.score >= level.locked_magic_box_cost )
			{
				user maps/mp/zombies/_zm_score::minus_to_player_score( level.locked_magic_box_cost );
				self.zbarrier set_magic_box_zbarrier_state( "unlocking" );
				self.unitrigger_stub run_visibility_function_for_all_triggers();
			}
			else
			{
				user maps/mp/zombies/_zm_audio::create_and_play_dialog( "general", "no_money_box" );
			}
			wait 0.1 ;
			continue;
		}
		else if ( isdefined( self.auto_open ) && is_player_valid( user ) )
		{
			if ( !isdefined( self.no_charge ) )
			{
				user maps/mp/zombies/_zm_score::minus_to_player_score( self.zombie_cost );
				user_cost = self.zombie_cost;
			}
			else
			{
				user_cost = 0;
			}
			self.chest_user = user;
			break;
		}
		else if ( is_player_valid( user ) && user.score >= self.zombie_cost )
		{
			user maps/mp/zombies/_zm_score::minus_to_player_score( self.zombie_cost );
			user_cost = self.zombie_cost;
			self.chest_user = user;
			break;
		}
		else if ( isdefined( reduced_cost ) && user.score >= reduced_cost )
		{
			user maps/mp/zombies/_zm_score::minus_to_player_score( reduced_cost );
			user_cost = reduced_cost;
			self.chest_user = user;
			break;
		}
		else if ( user.score < self.zombie_cost )
		{
			play_sound_at_pos( "no_purchase", self.origin );
			user maps/mp/zombies/_zm_audio::create_and_play_dialog( "general", "no_money_box" );
			wait 0.1;
			continue;
		}
		wait 0.05;
	}
	flag_set( "chest_has_been_used" );
	if ( isDefined( level._magic_box_used_vo ) )
	{
		user thread [[ level._magic_box_used_vo ]]();
	}
	self thread watch_for_emp_close();
	self._box_open = 1;
	self._box_opened_by_fire_sale = 0;
	if ( is_true( level.zombie_vars[ "zombie_powerup_fire_sale_on" ] ) && !isDefined( self.auto_open ) && self [[ level._zombiemode_check_firesale_loc_valid_func ]]() )
	{
		self._box_opened_by_fire_sale = 1;
	}
	if ( isDefined( self.chest_lid ) )
	{
		self.chest_lid thread treasure_chest_lid_open();
	}
	if ( isDefined( self.zbarrier ) )
	{
		play_sound_at_pos( "open_chest", self.origin );
		play_sound_at_pos( "music_chest", self.origin );
		self.zbarrier set_magic_box_zbarrier_state( "open" );
	}
	self.timedout = 0;
	self.weapon_out = 1;
	self.zbarrier thread treasure_chest_weapon_spawn( self, user );
	self.zbarrier thread treasure_chest_glowfx();
	thread maps/mp/zombies/_zm_unitrigger::unregister_unitrigger( self.unitrigger_stub );
	self.zbarrier waittill_any( "randomization_done", "box_hacked_respin" );
	if ( flag( "moving_chest_now" ) && !self._box_opened_by_fire_sale && isDefined( user_cost ) )
	{
		user maps/mp/zombies/_zm_score::add_to_player_score( user_cost, 0 );
	}
	if ( flag( "moving_chest_now" ) && !level.zombie_vars[ "zombie_powerup_fire_sale_on" ] && !self._box_opened_by_fire_sale )
	{
		self thread treasure_chest_move( self.chest_user );
	}
	else
	{
		self.grab_weapon_hint = 1;
		self.grab_weapon_name = self.zbarrier.weapon_string;
		self.chest_user = user;
		thread maps/mp/zombies/_zm_unitrigger::register_static_unitrigger( self.unitrigger_stub, ::magicbox_unitrigger_think );
		if ( isDefined( self.zbarrier ) && !is_true( self.zbarrier.closed_by_emp ) )
		{
			self thread treasure_chest_timeout();
		}
		while ( !is_true( self.closed_by_emp ) )
		{
			self waittill( "trigger", grabber );
			self.weapon_out = undefined;
			if ( is_true( level.magic_box_grab_by_anyone ) )
			{
				if ( isplayer( grabber ) )
				{
					user = grabber;
				}
			}
			if ( is_true( level.pers_upgrade_box_weapon ) )
			{
				self maps/mp/zombies/_zm_pers_upgrades_functions::pers_upgrade_box_weapon_used( user, grabber );
			}
			if ( isDefined( grabber.is_drinking ) && grabber.is_drinking > 0 )
			{
				wait 0.1;
				continue;
			}
			if ( grabber == user && user getcurrentweapon() == "none" )
			{
				wait 0.1;
				continue;
			}
			if ( grabber != level && is_true( self.box_rerespun ) )
			{
				user = grabber;
			}
			if ( grabber == user || grabber == level )
			{
				self.box_rerespun = undefined;
				current_weapon = "none";
				if ( is_player_valid( user ) )
				{
					current_weapon = user getcurrentweapon();
				}
				if ( grabber == user && is_player_valid( user ) && !user.is_drinking && !is_placeable_mine( current_weapon ) && !is_equipment( current_weapon ) && level.revive_tool != current_weapon )
				{
					bbprint( "zombie_uses", "playername %s playerscore %d round %d cost %d name %s x %f y %f z %f type %s", user.name, user.score, level.round_number, self.zombie_cost, self.zbarrier.weapon_string, self.origin, "magic_accept" );
					self notify( "user_grabbed_weapon" );
					user notify( "user_grabbed_weapon" );
					user thread treasure_chest_give_weapon( self.zbarrier.weapon_string );
					maps/mp/_demo::bookmark( "zm_player_grabbed_magicbox", getTime(), user );
					user maps/mp/zombies/_zm_stats::increment_client_stat( "grabbed_from_magicbox" );
					user maps/mp/zombies/_zm_stats::increment_player_stat( "grabbed_from_magicbox" );
					break;
				}
				else if ( grabber == level )
				{
					unacquire_weapon_toggle( self.zbarrier.weapon_string );
					self.timedout = 1;
					if ( is_player_valid( user ) )
					{
						bbprint( "zombie_uses", "playername %s playerscore %d round %d cost %d name %s x %f y %f z %f type %S", user.name, user.score, level.round_number, self.zombie_cost, self.zbarrier.weapon_string, self.origin, "magic_reject" );
					}
					break;
				}
			}
			wait 0.05;
		}
		self.grab_weapon_hint = 0;
		self.zbarrier notify( "weapon_grabbed" );
		if ( !is_true( self._box_opened_by_fire_sale ) )
		{
			level.chest_accessed += 1;
		}
		if ( level.chest_moves > 0 && isDefined( level.pulls_since_last_ray_gun ) )
		{
			level.pulls_since_last_ray_gun += 1;
		}
		if ( isDefined( level.pulls_since_last_tesla_gun ) )
		{
			level.pulls_since_last_tesla_gun += 1;
		}
		thread maps/mp/zombies/_zm_unitrigger::unregister_unitrigger( self.unitrigger_stub );
		if ( isDefined( self.chest_lid ) )
		{
			self.chest_lid thread treasure_chest_lid_close( self.timedout );
		}
		if ( isDefined( self.zbarrier ) )
		{
			self.zbarrier set_magic_box_zbarrier_state( "close" );
			play_sound_at_pos( "close_chest", self.origin );
			self.zbarrier waittill( "closed" );
			wait 1;
		}
		else
		{
			wait 3;
		}
		if ( is_true( level.zombie_vars[ "zombie_powerup_fire_sale_on" ] ) || self [[ level._zombiemode_check_firesale_loc_valid_func ]]() || self == level.chests[ level.chest_index ] )
		{
			thread maps/mp/zombies/_zm_unitrigger::register_static_unitrigger( self.unitrigger_stub, ::magicbox_unitrigger_think );
		}
	}
	self._box_open = 0;
	self._box_opened_by_fire_sale = 0;
	self.chest_user = undefined;
	self notify( "chest_accessed" );
	self thread treasure_chest_think();
}

watch_for_emp_close() //checked changed to match cerberus output
{
	self endon( "chest_accessed" );
	self.closed_by_emp = 0;
	if ( !should_watch_for_emp() )
	{
		return;
	}
	if ( isDefined( self.zbarrier ) )
	{
		self.zbarrier.closed_by_emp = 0;
	}
	while ( 1 )
	{
		level waittill( "emp_detonate", origin, radius );
		if ( distancesquared( origin, self.origin ) < ( radius * radius ) )
		{
			break;
		}
	}
	if ( flag( "moving_chest_now" ) )
	{
		return;
	}
	self.closed_by_emp = 1;
	if ( isDefined( self.zbarrier ) )
	{
		self.zbarrier.closed_by_emp = 1;
		self.zbarrier notify( "box_hacked_respin" );
		if ( isDefined( self.zbarrier.weapon_model ) )
		{
			self.zbarrier.weapon_model notify( "kill_weapon_movement" );
		}
		if ( isDefined( self.zbarrier.weapon_model_dw ) )
		{
			self.zbarrier.weapon_model_dw notify( "kill_weapon_movement" );
		}
	}
	wait 0.1;
	self notify( "trigger", level );
}

can_buy_weapon() //checked matches cerberus output
{
	if ( isDefined( self.is_drinking ) && self.is_drinking > 0 )
	{
		return 0;
	}
	if ( self hacker_active() )
	{
		return 0;
	}
	current_weapon = self getcurrentweapon();
	if ( is_placeable_mine( current_weapon ) || is_equipment_that_blocks_purchase( current_weapon ) )
	{
		return 0;
	}
	if ( self in_revive_trigger() )
	{
		return 0;
	}
	if ( current_weapon == "none" )
	{
		return 0;
	}
	return 1;
}

default_box_move_logic() //checked changed to match cerberus output
{
	index = -1;
	for ( i = 0; i < level.chests.size; i++ )
	{
		if ( issubstr( level.chests[ i ].script_noteworthy, "move" + level.chest_moves + 1 ) && i != level.chest_index )
		{
			index = i;
			break;
		}
	}
	if ( index != -1 )
	{
		level.chest_index = index;
	}
	else
	{
		level.chest_index++;
	}
	if ( level.chest_index >= level.chests.size )
	{
		temp_chest_name = level.chests[ level.chest_index - 1 ].script_noteworthy;
		level.chest_index = 0;
		level.chests = array_randomize( level.chests );
		if ( temp_chest_name == level.chests[ level.chest_index ].script_noteworthy )
		{
			level.chest_index++;
		}
	}
}

treasure_chest_move( player_vox ) //checked changed to match cerberus output
{
	level waittill( "weapon_fly_away_start" );
	players = get_players();
	array_thread( players, ::play_crazi_sound );
	if ( isDefined( player_vox ) )
	{
		player_vox delay_thread( randomintrange( 2, 7 ), ::create_and_play_dialog, "general", "box_move" );
	}
	level waittill( "weapon_fly_away_end" );
	if ( isDefined( self.zbarrier ) )
	{
		self hide_chest( 1 );
	}
	wait 0.1;
	post_selection_wait_duration = 7;
	if ( level.zombie_vars[ "zombie_powerup_fire_sale_on" ] == 1 && self [[ level._zombiemode_check_firesale_loc_valid_func ]]() )
	{
		current_sale_time = level.zombie_vars[ "zombie_powerup_fire_sale_time" ];
		wait_network_frame();
		self thread fire_sale_fix();
		level.zombie_vars[ "zombie_powerup_fire_sale_time" ] = current_sale_time;
		while ( level.zombie_vars[ "zombie_powerup_fire_sale_time" ] > 0 )
		{
			wait 0.1;
		}
	}
	else
	{
		post_selection_wait_duration += 5;
	}
	level.verify_chest = 0;
	if ( isDefined( level._zombiemode_custom_box_move_logic ) )
	{
		[[ level._zombiemode_custom_box_move_logic ]]();
	}
	else
	{
		default_box_move_logic();
	}
	if ( isDefined( level.chests[ level.chest_index ].box_hacks[ "summon_box" ] ) )
	{
		level.chests[ level.chest_index ] [[ level.chests[ level.chest_index ].box_hacks[ "summon_box" ] ]]( 0 );
	}
	wait post_selection_wait_duration;
	playfx( level._effect[ "poltergeist" ], level.chests[ level.chest_index ].zbarrier.origin );
	level.chests[ level.chest_index ] show_chest();
	flag_clear( "moving_chest_now" );
	self.zbarrier.chest_moving = 0;
}

fire_sale_fix() //checked matches cerberus output
{
	if ( !isDefined( level.zombie_vars[ "zombie_powerup_fire_sale_on" ] ) )
	{
		return;
	}
	if ( level.zombie_vars[ "zombie_powerup_fire_sale_on" ] )
	{
		self.old_cost = 950;
		self thread show_chest();
		self.zombie_cost = 10;
		self.unitrigger_stub unitrigger_set_hint_string( self, "default_treasure_chest", self.zombie_cost );
		wait_network_frame();
		level waittill( "fire_sale_off" );
		while ( is_true( self._box_open ) )
		{
			wait 0.1;
		}
		self hide_chest( 1 );
		self.zombie_cost = self.old_cost;
	}
}

check_for_desirable_chest_location() //checked changed to match cerberus output
{
	if ( !isDefined( level.desirable_chest_location ) )
	{
		return level.chest_index;
	}
	if ( level.chests[ level.chest_index ].script_noteworthy == level.desirable_chest_location )
	{
		level.desirable_chest_location = undefined;
		return level.chest_index;
	}
	for ( i = 0; i < level.chests.size; i++ )
	{
		if ( level.chests[ i ].script_noteworthy == level.desirable_chest_location )
		{
			level.desirable_chest_location = undefined;
			return i;
		}
	}
	/*
/#
	iprintln( level.desirable_chest_location + " is an invalid box location!" );
#/
	*/
	level.desirable_chest_location = undefined;
	return level.chest_index;
}

rotateroll_box() //checked matches cerberus output
{
	angles = 40;
	angles2 = 0;
	while ( isDefined( self ) )
	{
		self rotateroll( angles + angles2, 0.5 );
		wait 0.7;
		angles2 = 40;
		self rotateroll( angles * -2, 0.5 );
		wait 0.7;
	}
}

verify_chest_is_open() //checked changed to match cerberus output
{
	for ( i = 0; i < level.open_chest_location.size; i++ )
	{
		if ( isDefined( level.open_chest_location[ i ] ) )
		{
			if ( level.open_chest_location[ i ] == level.chests[ level.chest_index ].script_noteworthy )
			{
				level.verify_chest = 1;
				return;
			}
		}
	}
	level.verify_chest = 0;
}

treasure_chest_timeout() //checked changed to match cerberus output
{
	self endon( "user_grabbed_weapon" );
	self.zbarrier endon( "box_hacked_respin" );
	self.zbarrier endon( "box_hacked_rerespin" );
	wait 12;
	self notify( "trigger", level );
}

treasure_chest_lid_open() //checked matches cerberus output
{
	openroll = 105;
	opentime = 0.5;
	self rotateroll( 105, opentime, opentime * 0.5 );
	play_sound_at_pos( "open_chest", self.origin );
	play_sound_at_pos( "music_chest", self.origin );
}

treasure_chest_lid_close( timedout ) //checked matches cerberus output
{
	closeroll = -105;
	closetime = 0.5;
	self rotateroll( closeroll, closetime, closetime * 0.5 );
	play_sound_at_pos( "close_chest", self.origin );
	self notify( "lid_closed" );
}

treasure_chest_chooserandomweapon( player ) //checked matches cerberus output
{
	keys = getarraykeys( level.zombie_weapons );
	return keys[ randomint( keys.size ) ];
}


treasure_chest_canplayerreceiveweapon( player, weapon, pap_triggers ) //checked matches cerberus output
{
	if ( !get_is_in_box( weapon ) )
	{
		return 0;
	}
	if ( isDefined( player ) && player has_weapon_or_upgrade( weapon ) )
	{
		return 0;
	}
	return 1;
}

treasure_chest_chooseweightedrandomweapon( player ) //checked changed to match cerberus output
{
	keys = array_randomize( getarraykeys( level.zombie_weapons ) );
	if ( isDefined( level.customrandomweaponweights ) )
	{
		keys = player [[ level.customrandomweaponweights ]]( keys );
	}
	/*
/#
	forced_weapon = getDvar( "scr_force_weapon" );
	if ( forced_weapon != "" && isDefined( level.zombie_weapons[ forced_weapon ] ) )
	{
		arrayinsert( keys, forced_weapon, 0 );
#/
	}
	*/
	pap_triggers = getentarray( "specialty_weapupgrade", "script_noteworthy" );
	for ( i = 0; i < keys.size; i++ )
	{
		if ( treasure_chest_canplayerreceiveweapon( player, keys[ i ], pap_triggers ) )
		{
			return keys[ i ];
		}
	}
	return keys[ 0 ];
}

weapon_is_dual_wield( name ) //checked matches cerberus output
{
	switch( name )
	{
		case "cz75dw_upgraded_zm":
		case "cz75dw_zm":
		case "fivesevendw_upgraded_zm":
		case "fivesevendw_zm":
		case "hs10_upgraded_zm":
		case "m1911_upgraded_zm":
		case "microwavegundw_upgraded_zm":
		case "microwavegundw_zm":
		case "pm63_upgraded_zm":
			return 1;
		default:
			return 0;
	}
}

weapon_show_hint_choke() //checked matches cerberus output
{
	level._weapon_show_hint_choke = 0;
	while ( 1 )
	{
		wait 0.05;
		level._weapon_show_hint_choke = 0;
	}
}

decide_hide_show_hint( endon_notify, second_endon_notify, onlyplayer ) //checked changed to match cerberus output
{
	self endon( "death" );
	if ( isDefined( endon_notify ) )
	{
		self endon( endon_notify );
	}
	if ( isDefined( second_endon_notify ) )
	{
		self endon( second_endon_notify );
	}
	if ( !isDefined( level._weapon_show_hint_choke ) )
	{
		level thread weapon_show_hint_choke();
	}
	use_choke = 0;
	if ( isDefined( level._use_choke_weapon_hints ) && level._use_choke_weapon_hints == 1 )
	{
		use_choke = 1;
	}
	while ( 1 )
	{
		last_update = getTime();
		if ( isDefined( self.chest_user ) && !isDefined( self.box_rerespun ) )
		{
			if ( is_placeable_mine( self.chest_user getcurrentweapon() ) || self.chest_user hacker_active() )
			{
				self setinvisibletoplayer( self.chest_user );
			}
			else
			{
				self setvisibletoplayer( self.chest_user );
			}
		}
		if ( isDefined( onlyplayer ) )
		{
			if ( onlyplayer can_buy_weapon() )
			{
				self setinvisibletoplayer( onlyplayer, 0 );
			}
			else
			{
				self setinvisibletoplayer( onlyplayer, 1 );
			}
		}
		players = get_players();
		i = 0;
		while ( i < players.size )
		{
			if ( players[ i ] can_buy_weapon() )
			{
				self setinvisibletoplayer( players[ i ], 0 );
				i++;
				continue;
			}
			self setinvisibletoplayer( players[ i ], 1 );
			i++;
		}
		if ( use_choke )
		{
			while ( level._weapon_show_hint_choke > 4 && getTime() < ( last_update + 150 ) )
			{
				wait 0.05;
			}
		}
		else
		{
			wait 0.1;
		}
		level._weapon_show_hint_choke++;
	}
}

get_left_hand_weapon_model_name( name ) //checked matches cerberus output
{
	switch( name )
	{
		case "microwavegundw_zm":
			return getweaponmodel( "microwavegunlh_zm" );
		case "microwavegundw_upgraded_zm":
			return getweaponmodel( "microwavegunlh_upgraded_zm" );
		default:
			return getweaponmodel( name );
	}
}

clean_up_hacked_box() //checked matches cerberus output
{
	self waittill( "box_hacked_respin" );
	self endon( "box_spin_done" );
	if ( isDefined( self.weapon_model ) )
	{
		self.weapon_model delete();
		self.weapon_model = undefined;
	}
	if ( isDefined( self.weapon_model_dw ) )
	{
		self.weapon_model_dw delete();
		self.weapon_model_dw = undefined;
	}
	self hidezbarrierpiece( 3 );
	self hidezbarrierpiece( 4 );
	self setzbarrierpiecestate( 3, "closed" );
	self setzbarrierpiecestate( 4, "closed" );
}

treasure_chest_weapon_spawn( chest, player, respin ) //checked changed to match cerberus output
{
	if ( is_true( level.using_locked_magicbox ) )
	{
		self.owner endon( "box_locked" );
		self thread maps/mp/zombies/_zm_magicbox_lock::clean_up_locked_box();
	}
	self endon( "box_hacked_respin" );
	self thread clean_up_hacked_box();
	/*
/#
	assert( isDefined( player ) );
#/
	*/
	self.weapon_string = undefined;
	modelname = undefined;
	rand = undefined;
	number_cycles = 40;
	if ( isDefined( chest.zbarrier ) )
	{
		if ( isDefined( level.custom_magic_box_do_weapon_rise ) )
		{
			chest.zbarrier thread [[ level.custom_magic_box_do_weapon_rise ]]();
		}
		else
		{
			chest.zbarrier thread magic_box_do_weapon_rise();
		}
	}
	for ( i = 0; i < number_cycles; i++ )
	{

		if ( i < 20 )
		{
			wait 0.05 ; 
		}
		else if ( i < 30 )
		{
			wait 0.1 ; 
		}
		else if ( i < 35 )
		{
			wait 0.2 ; 
		}
		else if ( i < 38 )
		{
			wait 0.3 ; 
		}
	}
	if ( isDefined( level.custom_magic_box_weapon_wait ) )
	{
		[[ level.custom_magic_box_weapon_wait ]]();
	}
	if ( is_true( player.pers_upgrades_awarded[ "box_weapon" ] ) )
	{
		rand = maps/mp/zombies/_zm_pers_upgrades_functions::pers_treasure_chest_choosespecialweapon( player );
	}
	else
	{
		rand = treasure_chest_chooseweightedrandomweapon( player );
	}
	
	self.weapon_string = rand;
	wait 0.1;
	if ( isDefined( level.custom_magicbox_float_height ) )
	{
		v_float = anglesToUp( self.angles ) * level.custom_magicbox_float_height;
	}
	else
	{
		v_float = anglesToUp( self.angles ) * 40;
	}
	self.model_dw = undefined;
	self.weapon_model = spawn_weapon_model( rand, undefined, self.origin + v_float, self.angles + vectorScale( ( 0, 1, 0 ), 180 ) );
	if ( weapon_is_dual_wield( rand ) )
	{
		self.weapon_model_dw = spawn_weapon_model( rand, get_left_hand_weapon_model_name( rand ), self.weapon_model.origin - vectorScale( ( 0, 1, 0 ), 3 ), self.weapon_model.angles );
	}
	if ( getDvar( "magic_chest_movable" ) == "1" && !is_true( chest._box_opened_by_fire_sale ) && !is_true( level.zombie_vars[ "zombie_powerup_fire_sale_on" ] ) && self [[ level._zombiemode_check_firesale_loc_valid_func ]]() )
	{
		random = randomint( 100 );
		if ( !isDefined( level.chest_min_move_usage ) )
		{
			level.chest_min_move_usage = 4;
		}
		if ( level.chest_accessed < level.chest_min_move_usage )
		{
			chance_of_joker = -1;
		}
		else
		{
			chance_of_joker = level.chest_accessed + 20;
			if ( level.chest_moves == 0 && level.chest_accessed >= 8 )
			{
				chance_of_joker = 100;
			}
			if ( level.chest_accessed >= 4 && level.chest_accessed < 8 )
			{
				if ( random < 15 )
				{
					chance_of_joker = 100;
				}
				else
				{
					chance_of_joker = -1;
				}
			}
			if ( level.chest_moves > 0 )
			{
				if ( level.chest_accessed >= 8 && level.chest_accessed < 13 )
				{
					if ( random < 30 )
					{
						chance_of_joker = 100;
					}
					else
					{
						chance_of_joker = -1;
					}
				}
				if ( level.chest_accessed >= 13 )
				{
					if ( random < 50 )
					{
						chance_of_joker = 100;
					}
					else
					{
						chance_of_joker = -1;
					}
				}
			}
		}
		if ( isDefined( chest.no_fly_away ) )
		{
			chance_of_joker = -1;
		}
		if ( isDefined( level._zombiemode_chest_joker_chance_override_func ) )
		{
			chance_of_joker = [[ level._zombiemode_chest_joker_chance_override_func ]]( chance_of_joker );
		}
		if ( chance_of_joker > random )
		{
			self.weapon_string = undefined;
			self.weapon_model setmodel( level.chest_joker_model );
			self.weapon_model.angles = self.angles + vectorScale( ( 0, 1, 0 ), 90 );
			if ( isDefined( self.weapon_model_dw ) )
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
	if ( flag( "moving_chest_now" ) && !level.zombie_vars[ "zombie_powerup_fire_sale_on" ] && self [[ level._zombiemode_check_firesale_loc_valid_func ]]() )
	{
		if ( isDefined( level.chest_joker_custom_movement ) )
		{
			self [[ level.chest_joker_custom_movement ]]();
		}
		else
		{
			wait 0.5;
			level notify( "weapon_fly_away_start" );
			wait 2;
			if ( isDefined( self.weapon_model ) )
			{
				v_fly_away = self.origin + ( anglesToUp( self.angles ) * 500 );
				self.weapon_model moveto( v_fly_away, 4, 3 );
			}
			if ( isDefined( self.weapon_model_dw ) )
			{
				v_fly_away = self.origin + ( anglesToUp( self.angles ) * 500 );
				self.weapon_model_dw moveto( v_fly_away, 4, 3 );
			}
			self.weapon_model waittill( "movedone" );
			self.weapon_model delete();
			if ( isDefined( self.weapon_model_dw ) )
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
			{
				level.pulls_since_last_ray_gun = 0;
			}
			if ( rand == "tesla_gun_zm" )
			{
				level.pulls_since_last_tesla_gun = 0;
				level.player_seen_tesla_gun = 1;
			}
		}
		if ( !isDefined( respin ) )
		{
			if ( isDefined( chest.box_hacks[ "respin" ] ) )
			{
				self [[ chest.box_hacks[ "respin" ] ]]( chest, player );
			}
		}
		else
		{
			if ( isDefined( chest.box_hacks[ "respin_respin" ] ) )
			{
				self [[ chest.box_hacks[ "respin_respin" ] ]]( chest, player );
			}
		}
		if ( isDefined( level.custom_magic_box_timer_til_despawn ) )
		{
			self.weapon_model thread [[ level.custom_magic_box_timer_til_despawn ]]( self );
		}
		else
		{
			self.weapon_model thread timer_til_despawn( v_float );
		}
		if ( isDefined( self.weapon_model_dw ) )
		{
			if ( isDefined( level.custom_magic_box_timer_til_despawn ) )
			{
				self.weapon_model_dw thread [[ level.custom_magic_box_timer_til_despawn ]]( self );
			}
			else
			{
				self.weapon_model_dw thread timer_til_despawn( v_float );
			}
		}
		self waittill( "weapon_grabbed" );
		if ( !chest.timedout )
		{
			if ( isDefined( self.weapon_model ) )
			{
				self.weapon_model delete();
			}
			if ( isDefined( self.weapon_model_dw ) )
			{
				self.weapon_model_dw delete();
			}
		}
	}
	self.weapon_string = undefined;
	self notify( "box_spin_done" );
}

chest_get_min_usage() //checked matches cerberus output
{
	min_usage = 4;
	return min_usage;
}

chest_get_max_usage() //checked matches cerberus output
{
	max_usage = 6;
	players = get_players();
	if ( level.chest_moves == 0 )
	{
		if ( players.size == 1 )
		{
			max_usage = 3;
		}
		else if ( players.size == 2 )
		{
			max_usage = 4;
		}
		else if ( players.size == 3 )
		{
			max_usage = 5;
		}
		else
		{
			max_usage = 6;
		}
	}
	else if ( players.size == 1 )
	{
		max_usage = 4;
	}
	else if ( players.size == 2 )
	{
		max_usage = 4;
	}
	else if ( players.size == 3 )
	{
		max_usage = 5;
	}
	else
	{
		max_usage = 7;
	}
	return max_usage;
}

timer_til_despawn( v_float ) //checked matches cerberus output
{
	self endon( "kill_weapon_movement" );
	putbacktime = 12;
	self moveto( self.origin - ( v_float * 0.85 ), putbacktime, putbacktime * 0.5 );
	wait putbacktime;
	if ( isDefined( self ) )
	{
		self delete();
	}
}

treasure_chest_glowfx() //checked matches cerberus output
{

}

treasure_chest_give_weapon( weapon_string ) //checked matches cerberus output
{
	self.last_box_weapon = getTime();
	self maps/mp/zombies/_zm_weapons::weapon_give( weapon_string, 0, 1 );
}

magic_box_teddy_twitches() //checked matches cerberus output
{
	self endon( "zbarrier_state_change" );
	self setzbarrierpiecestate( 0, "closed" );
	while ( 1 )
	{
		wait randomfloatrange( 180, 1800 );
		self setzbarrierpiecestate( 0, "opening" );
		wait randomfloatrange( 180, 1800 );
		self setzbarrierpiecestate( 0, "closing" );
	}
}

magic_box_initial() //checked matches cerberus output
{
	self setzbarrierpiecestate( 1, "open" );
}

magic_box_arrives()
{
	self setzbarrierpiecestate( 1, "opening" );
	while ( self getzbarrierpiecestate( 1 ) == "opening" )
	{
		wait 0.05;
	}
	self notify( "arrived" );
}

magic_box_leaves() //checked matches cerberus output
{
	self setzbarrierpiecestate( 1, "closing" );
	while ( self getzbarrierpiecestate( 1 ) == "closing" )
	{
		wait 0.1;
	}
	self notify( "left" );
}

magic_box_opens() //checked matches cerberus output
{
	self setzbarrierpiecestate( 2, "opening" );
	while ( self getzbarrierpiecestate( 2 ) == "opening" )
	{
		wait 0.1;
	}
	self notify( "opened" );
}

magic_box_closes() //checked matches cerberus output
{
	self setzbarrierpiecestate( 2, "closing" );
	while ( self getzbarrierpiecestate( 2 ) == "closing" )
	{
		wait 0.1;
	}
	self notify( "closed" );
}

magic_box_do_weapon_rise() //checked matches cerberus output
{
	self endon( "box_hacked_respin" );
	self setzbarrierpiecestate( 3, "closed" );
	self setzbarrierpiecestate( 4, "closed" );
	wait_network_frame();
	self zbarrierpieceuseboxriselogic( 3 );
	self zbarrierpieceuseboxriselogic( 4 );
	self showzbarrierpiece( 3 );
	self showzbarrierpiece( 4 );
	self setzbarrierpiecestate( 3, "opening" );
	self setzbarrierpiecestate( 4, "opening" );
	while ( self getzbarrierpiecestate( 3 ) != "open" )
	{
		wait 0.5;
	}
	self hidezbarrierpiece( 3 );
	self hidezbarrierpiece( 4 );
}

magic_box_do_teddy_flyaway() //checked matches cerberus output
{
	self showzbarrierpiece( 3 );
	self setzbarrierpiecestate( 3, "closing" );
}

is_chest_active() //checked matches cerberus output
{
	curr_state = self.zbarrier get_magic_box_zbarrier_state();
	if ( flag( "moving_chest_now" ) )
	{
		return 0;
	}
	if ( curr_state == "open" || curr_state == "close" )
	{
		return 1;
	}
	return 0;
}

get_magic_box_zbarrier_state() //checked matches cerberus output
{
	return self.state;
}

set_magic_box_zbarrier_state( state ) //checked changed to match cerberus output
{
	for ( i = 0; i < self getnumzbarrierpieces(); i++ )
	{
		self hidezbarrierpiece( i );
	}
	self notify( "zbarrier_state_change" );
	self [[ level.magic_box_zbarrier_state_func ]]( state );
}

process_magic_box_zbarrier_state( state ) //checked matches cerberus output
{
	switch( state )
	{
		case "away":
			self showzbarrierpiece( 0 );
			self thread magic_box_teddy_twitches();
			self.state = "away";
			break;
		case "arriving":
			self showzbarrierpiece( 1 );
			self thread magic_box_arrives();
			self.state = "arriving";
			break;
		case "initial":
			self showzbarrierpiece( 1 );
			self thread magic_box_initial();
			thread maps/mp/zombies/_zm_unitrigger::register_static_unitrigger( self.owner.unitrigger_stub, ::magicbox_unitrigger_think );
			self.state = "initial";
			break;
		case "open":
			self showzbarrierpiece( 2 );
			self thread magic_box_opens();
			self.state = "open";
			break;
		case "close":
			self showzbarrierpiece( 2 );
			self thread magic_box_closes();
			self.state = "close";
			break;
		case "leaving":
			self showzbarrierpiece( 1 );
			self thread magic_box_leaves();
			self.state = "leaving";
			break;
		default:
			if ( isDefined( level.custom_magicbox_state_handler ) )
			{
				self [[ level.custom_magicbox_state_handler ]]( state );
			}
			break;
	}
}

magicbox_host_migration() //checked changed to match cerberus output
{
	level endon( "end_game" );
	level notify( "mb_hostmigration" );
	level endon( "mb_hostmigration" );
	while ( 1 )
	{
		level waittill( "host_migration_end" );
		while ( !isDefined( level.chests ) )
		{
			wait 0.1;
		}
		foreach ( chest in level.chests )
		{
			if ( !is_true( chest.hidden ) )
			{
				if ( isdefined( chest ) && isdefined( chest.pandora_light ) )
				{
					playfxontag( level._effect[ "lght_marker" ], chest.pandora_light, "tag_origin" );
				}
			}
			wait_network_frame();
		}
	}
}





