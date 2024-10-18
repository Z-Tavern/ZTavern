#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_zm_perks;
#include maps\mp\_visionset_mgr;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\_demo;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_pers_upgrades_functions;
#include maps\mp\zombies\_zm_power;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_stats;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zombies\_zm_chugabud;
#include maps\mp\zombies\_zm_afterlife;
#include maps\mp\zombies\_zm_tombstone;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\zombies\_zm_perk_vulture;
#include maps\mp\zombies\_zm_weap_time_bomb;

#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\_demo;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_pers_upgrades_functions;
#include maps\mp\gametypes_zm\_gameobjects;
#include maps\mp\zombies\_zm_buildables;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\zombies\_zm_chugabud;
#include maps\mp\zombies\_zm_perks;


#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\zombies\_zm_chugabud;
#include maps\mp\zombies\_zm_perks;
#include maps\mp\zombies\_zm_clone;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_weap_cymbal_monkey;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\zombies\_zm;
#include maps\mp\_visionset_mgr;

//motd
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_craftables;
#include maps\mp\zm_alcatraz_utility;
#include maps\mp\zm_alcatraz_gamemodes;
#include maps\mp\zm_prison_fx;
#include maps\mp\zm_prison_ffotd;
#include maps\mp\zombies\_zm;
#include maps\mp\animscripts\zm_death;
#include maps\mp\zm_alcatraz_amb;
#include maps\mp\zombies\_load;
#include maps\mp\zm_prison_achievement;
#include maps\mp\gametypes_zm\_spawning;
#include maps\mp\zombies\_zm_perk_electric_cherry;
#include maps\mp\zombies\_zm_perk_divetonuke;
#include maps\mp\zm_alcatraz_distance_tracking;
#include maps\mp\zm_alcatraz_traps;
#include maps\mp\zm_alcatraz_travel;
#include maps\mp\zombies\_zm_magicbox_prison;
#include maps\mp\zombies\_zm_ai_basic;
#include maps\mp\zombies\_zm_weap_claymore;
#include maps\mp\zombies\_zm_weap_riotshield_prison;
#include maps\mp\zombies\_zm_weap_blundersplat;
#include maps\mp\zombies\_zm_weap_tomahawk;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\zm_alcatraz_weap_quest;
#include maps\mp\zm_alcatraz_grief_cellblock;
#include maps\mp\_visionset_mgr;
#include maps\mp\zm_prison;
#include character\c_zom_arlington;
#include character\c_zom_deluca;
#include character\c_zom_handsome;
#include character\c_zom_oleary;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_blockers;

//points
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_pers_upgrades_functions;


//timebomb
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\_visionset_mgr;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_blockers;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\zombies\_zm_weapon_locker;
#include maps\mp\zombies\_zm_magicbox;
#include maps\mp\zombies\_zm_perks;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\animscripts\zm_death;
#include maps\mp\zombies\_zm_ai_basic;
#include maps\mp\zombies\_zm_weap_time_bomb;

main()
{
	replaceFunc( maps/mp/zombies/_zm_score::player_add_points, ::disablerevivemoney);
}

init() {
   	level thread onPlayerConnect();
        mapname = getDvar( "mapname" );
   	setDvar("bank_withdraw", "");
  	setDvar("bank_deposit", "");
	setDvar("revive", "0");
  	level thread playerBank();
				if(getdvar("0_can_use_bank") != "")
					setDvar("0_can_use_bank", "");
				if(getdvar("1_can_use_bank") != "")
					setDvar("1_can_use_bank", "");
				if(getdvar("2_can_use_bank") != "")
					setDvar("2_can_use_bank", "");
				if(getdvar("3_can_use_bank") != "")
					setDvar("3_can_use_bank", "");
				if(getdvar("4_can_use_bank") != "")
					setDvar("4_can_use_bank", "");
				if(getdvar("5_can_use_bank") != "")
					setDvar("5_can_use_bank", "");
				if(getdvar("6_can_use_bank") != "")
					setDvar("6_can_use_bank", "");
				if(getdvar("7_can_use_bank") != "")
					setDvar("7_can_use_bank", "");
		if (level.script == "zm_prison")
		{
					setDvar("0_can_use_bank", "2");
					setDvar("1_can_use_bank", "2");
					setDvar("2_can_use_bank", "2");
					setDvar("3_can_use_bank", "2");
					setDvar("4_can_use_bank", "2");
					setDvar("5_can_use_bank", "2");
					setDvar("6_can_use_bank", "2");
					setDvar("7_can_use_bank", "2");			
		}
		if ( level.script == "zm_buried")
		{
			level thread checkTimeBombActive();
		}

	level._game_module_point_adjustment = ::doublepoints;
	

}


onPlayerConnect()
{
	for (;;)
	{
		level waittill( "connected", player );
		player thread endPlayerMoney2();
		player thread endPlayerMoney(); // probably not necessary
		player thread setPlayerMoney();
		//player thread showInfo();
		//player thread printDebug();
		if (level.script == "zm_buried" || level.script == "zm_tranzit" || level.script == "zm_highrise")
		{
			level.ta_tellerfee = 6942000;
			level.ta_vaultfee = 1000;
		}

	}
}

doublepoints(player, zombie_team, player_points){
	if (level.script != "zm_prison")
	{
	if (player_points != 0)
	{
		tag = strTok(player.name, "]");
		if (tag[0] == "[^9F^7")
		{
			player maps/mp/zombies/_zm_score::add_to_player_score( player_points );
			player.pers[ "score" ] = player.score;
		}
		else if (tag[0] == "[^8E^7")
		{
			player maps/mp/zombies/_zm_score::add_to_player_score( player_points * 2);
			player.pers[ "score" ] = player.score;
		}
		else if (tag[0] == "[^2D^7")
		{
			player maps/mp/zombies/_zm_score::add_to_player_score( player_points * 2);
			player.pers[ "score" ] = player.score;
		}
		else if (tag[0] == "[^4C^7")
		{
			player maps/mp/zombies/_zm_score::add_to_player_score( player_points * 3);
			player.pers[ "score" ] = player.score;
		}
		else if (tag[0] == "[^5B^7")
		{
			player maps/mp/zombies/_zm_score::add_to_player_score( player_points * 3);
			player.pers[ "score" ] = player.score;
		}
		else if (tag[0] == "[^6A^7")
		{
			player maps/mp/zombies/_zm_score::add_to_player_score( player_points * 4);
			player.pers[ "score" ] = player.score;
		}
		else if (tag[0] == "[^3S^7")
		{
			player maps/mp/zombies/_zm_score::add_to_player_score( player_points * 5);
			player.pers[ "score" ] = player.score;
		}
		else if (tag[0] == "[^3SS^7")
		{
			player maps/mp/zombies/_zm_score::add_to_player_score( player_points * 6);
			player.pers[ "score" ] = player.score;
		}
		else if (tag[0] == "[^3SSS^7")
		{
			player maps/mp/zombies/_zm_score::add_to_player_score( player_points * 8);
			player.pers[ "score" ] = player.score;
		}
		if (tag[1])
		{
			if(tag[1] == "[^3VIP^7" || tag[1] == "^3[VIP")
			{	
				player maps/mp/zombies/_zm_score::add_to_player_score( player_points * 3);
				player.pers[ "score" ] = player.score;
			}
		}
	}
	}
}

disablerevivemoney(event, mod, hit_location, is_dog, zombie_team, damage_weapon)
{
    if ( level.intermission )
        return;

    if ( !is_player_valid( self ) )
        return;

    player_points = 0;
    team_points = 0;
    multiplier = get_points_multiplier( self );

    switch ( event )
    {
        case "death":
            player_points = get_zombie_death_player_points();
            team_points = get_zombie_death_team_points();
            points = self player_add_points_kill_bonus( mod, hit_location );

            if ( level.zombie_vars[self.team]["zombie_powerup_insta_kill_on"] == 1 && mod == "MOD_UNKNOWN" )
                points *= 2;

            player_points += points;

            if ( team_points > 0 )
                team_points += points;

            if ( mod == "MOD_GRENADE" || mod == "MOD_GRENADE_SPLASH" )
            {
                self maps\mp\zombies\_zm_stats::increment_client_stat( "grenade_kills" );
                self maps\mp\zombies\_zm_stats::increment_player_stat( "grenade_kills" );
            }

            break;
        case "ballistic_knife_death":
            player_points = get_zombie_death_player_points() + level.zombie_vars["zombie_score_bonus_melee"];
            self score_cf_increment_info( "death_melee" );
            break;
        case "damage_light":
            player_points = level.zombie_vars["zombie_score_damage_light"];
            self score_cf_increment_info( "damage" );
            break;
        case "damage":
            player_points = level.zombie_vars["zombie_score_damage_normal"];
            self score_cf_increment_info( "damage" );
            break;
        case "damage_ads":
            player_points = int( level.zombie_vars["zombie_score_damage_normal"] * 1.25 );
            self score_cf_increment_info( "damage" );
            break;
        case "rebuild_board":
        case "carpenter_powerup":
            player_points = mod;
            break;
        case "bonus_points_powerup":
            player_points = mod;
            break;
        case "nuke_powerup":
            player_points = mod;
            team_points = mod;
            break;
        case "thundergun_fling":
        case "riotshield_fling":
        case "jetgun_fling":
            player_points = mod;
            break;
        case "hacker_transfer":
            player_points = mod;
            break;
        case "reviver":
            player_points = 0;
            break;
        case "vulture":
            player_points = mod;
            break;
        case "build_wallbuy":
            player_points = mod;
            break;
        default:
            assert( 0, "Unknown point event" );
            break;
    }

    player_points = multiplier * round_up_score( player_points, 5 );
    team_points = multiplier * round_up_score( team_points, 5 );

    if ( ( event == "death" || event == "ballistic_knife_death" ) && isdefined( self.point_split_receiver ))
    {
        split_player_points = player_points - round_up_score( player_points * self.point_split_keep_percent, 10 );
        self.point_split_receiver add_to_player_score( split_player_points );
        player_points -= split_player_points;
    }

    if ( is_true( level.pers_upgrade_pistol_points ) )
        player_points = self maps\mp\zombies\_zm_pers_upgrades_functions::pers_upgrade_pistol_points_set_score( player_points, event, mod, damage_weapon );

    self add_to_player_score( player_points );
    self.pers["score"] = self.score;

    if ( isdefined( level._game_module_point_adjustment ) )
        level [[ level._game_module_point_adjustment ]]( self, zombie_team, player_points );
}

get_points_multiplier( player )
{
    multiplier = level.zombie_vars[player.team]["zombie_point_scalar"];

    if ( isdefined( level.current_game_module ) && level.current_game_module == 2 )
    {
        if ( isdefined( level._race_team_double_points ) && level._race_team_double_points == player._race_team )
            return multiplier;
        else
            return 1;
    }

    return multiplier;
}


printDebug()
{
	for(;;)
	{
		if(getDvar("revive"))
		{
			self iPrintLn("revive dvar is defined");
			self iPrintLn("revive value : " + getDvar("revive"));
			self iPrintLn("resetting revive value to 0:");
			setDvar("revive", "0");
		}
		else
		{
			self iPrintLn("test dvar is defined");
		}
		wait 5;
	}
}

showInfo()
{
	for(;;)
	{
			/*if (isdefined(self.afterlife))
			{
				self iPrintLn("Time bomb defined");
			}
			else
			{
				self iPrintLn("Time bomb not defined");
			}*/	

			if(isdefined(self.afterlife))
			{
				self iPrintLn("TB save ready defined");
				self iPrintLn("Time bomb save_ready value : " + self.afterlife);				
			}
			else
				self iPrintLn("Tb save ready not defined");
	wait 5;
	}
}

checkAfterlifeActive()
{
	for (;;)
	{
        		if (self.afterlife == 1)
        		{
				if(getdvar("0_can_use_bank") != "1")
					setDvar("0_can_use_bank", "1");
				if(getdvar("1_can_use_bank") != "1")
					setDvar("1_can_use_bank", "1");
				if(getdvar("2_can_use_bank") != "1")
					setDvar("2_can_use_bank", "1");
				if(getdvar("3_can_use_bank") != "1")
					setDvar("3_can_use_bank", "1");
				if(getdvar("4_can_use_bank") != "1")
					setDvar("4_can_use_bank", "1");
				if(getdvar("5_can_use_bank") != "1")
					setDvar("5_can_use_bank", "1");
				if(getdvar("6_can_use_bank") != "1")
					setDvar("6_can_use_bank", "1");
				if(getdvar("7_can_use_bank") != "1")
					setDvar("7_can_use_bank", "1");
			}	
			else
			{
				if(getdvar("0_can_use_bank") != "")
					setDvar("0_can_use_bank", "");
				if(getdvar("1_can_use_bank") != "")
					setDvar("1_can_use_bank", "");
				if(getdvar("2_can_use_bank") != "")
					setDvar("2_can_use_bank", "");
				if(getdvar("3_can_use_bank") != "")
					setDvar("3_can_use_bank", "");
				if(getdvar("4_can_use_bank") != "")
					setDvar("4_can_use_bank", "");
				if(getdvar("5_can_use_bank") != "")
					setDvar("5_can_use_bank", "");
				if(getdvar("6_can_use_bank") != "")
					setDvar("6_can_use_bank", "");
				if(getdvar("7_can_use_bank") != "")
					setDvar("7_can_use_bank", "");
			}
		wait 0.2;
	}
}

checkTimeBombActive()
{
	for (;;)
	{
		if (time_bomb_save_exists())
		{
				if(getdvar("0_can_use_bank") != "0")
				setDvar("0_can_use_bank", "0");
				if(getdvar("1_can_use_bank") != "0")
				setDvar("1_can_use_bank", "0");
				if(getdvar("2_can_use_bank") != "0")
				setDvar("2_can_use_bank", "0");
				if(getdvar("3_can_use_bank") != "0")
				setDvar("3_can_use_bank", "0");
				if(getdvar("4_can_use_bank") != "0")
				setDvar("4_can_use_bank", "0");
				if(getdvar("5_can_use_bank") != "0")
				setDvar("5_can_use_bank", "0");
				if(getdvar("6_can_use_bank") != "0")
				setDvar("6_can_use_bank", "0");
				if(getdvar("7_can_use_bank") != "0")
				setDvar("7_can_use_bank", "0");
		}	
		else
		{
				if(getdvar("0_can_use_bank") != "")
				setDvar("0_can_use_bank", "");
				if(getdvar("1_can_use_bank") != "")
				setDvar("1_can_use_bank", "");
				if(getdvar("2_can_use_bank") != "")
				setDvar("2_can_use_bank", "");
				if(getdvar("3_can_use_bank") != "")
				setDvar("3_can_use_bank", "");
				if(getdvar("4_can_use_bank") != "")
				setDvar("4_can_use_bank", "");
				if(getdvar("5_can_use_bank") != "")
				setDvar("5_can_use_bank", "");
				if(getdvar("6_can_use_bank") != "")
				setDvar("6_can_use_bank", "");
				if(getdvar("7_can_use_bank") != "")
				setDvar("7_can_use_bank", "");
		}
		wait 0.2;
	}
}

time_bomb_save_exists()
{
    return isdefined( level.time_bomb_save_data ) && isdefined( level.time_bomb_save_data.save_ready ) && level.time_bomb_save_data.save_ready;
}


endPlayerMoney() {
	self endon("disconnect");
	for (;;) {
		level waittill("end_game");
		setDvar(self getEntityNumber() + "_money", 0);
	}
}

endPlayerMoney2() {
	self endon("disconnect");
	for (;;) {
		level waittill("_zombie_game_over");
		setDvar(self getEntityNumber() + "_money", 0);
	}
}


setPlayerMoney() {
	level endon("end_game");
	level endon("_zombie_game_over");
	for (;;) {
		if (!isAlive(self)) {
			setDvar(self getEntityNumber() + "_money", 0);
		} else {
			setDvar(self getEntityNumber() + "_money", self.score);
		}
		wait 0.05;
	}
}

getPlayerByGuid(guid) {
    	for (i = 0; i < level.players.size; i++) {
        	if (isAlive(level.players[i]) && int(level.players[i] getGuid()) == int(guid)) {
            	return level.players[i];
        	} 
    	}
    	return false;
}

playerBank() {
	for (;;) {
		if (getDvar("bank_withdraw") != "") {
			withdraw = strTok(getDvar("bank_withdraw"), ";");
			setDvar("bank_withdraw", "");
			getPlayerByGuid(withdraw[0]).score += int(withdraw[1]);
			getPlayerByGuid(withdraw[0]) iPrintLn("Withdrew ^2$" + int(withdraw[1]) + "^7 from your bank account!");
		}
		if (getDvar("bank_deposit") != "") {
				deposit = strTok(getDvar("bank_deposit"), ";");
				setDvar("bank_deposit", "");
				getPlayerByGuid(deposit[0]).score -= int(deposit[1]);
				getPlayerByGuid(deposit[0]) iPrintLn("Deposited ^2$" + int(deposit[1]) + "^7 into your bank account!");
		}
		wait 0.05;
	}
}