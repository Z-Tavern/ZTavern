#include maps\mp\zombies\_zm_power;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zombies\_zm_chugabud;
#include maps\mp\zombies\_zm_afterlife;
#include maps\mp\zombies\_zm_tombstone;
#include maps\mp\zombies\_zm_perk_vulture;
#include maps\mp\zombies\_zm_weap_time_bomb;
#include maps\mp\_demo;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_pers_upgrades_functions;
#include maps\mp\gametypes_zm\_gameobjects;
#include maps\mp\zombies\_zm_buildables;
#include maps\mp\zombies\_zm_perks;
#include maps\mp\zombies\_zm_clone;
#include maps\mp\zombies\_zm_weap_cymbal_monkey;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\zombies\_zm;
#include maps\mp\_visionset_mgr;
//motd
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_craftables;
#include maps\mp\zm_alcatraz_utility;
#include maps\mp\zm_alcatraz_gamemodes;
#include maps\mp\zm_prison_fx;
#include maps\mp\zm_prison_ffotd;
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


//timebomb
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\zombies\_zm_weapon_locker;
#include maps\mp\zombies\_zm_magicbox;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_spawner;

init() {
  	level thread playerBank();
   	setDvar("bank_withdraw", "");
  	setDvar("bank_deposit", "");

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
	if ( level.script == "zm_buried")
	{
		level thread checkTimeBombActive();
	}
	if (level.script == "zm_buried" || level.script == "zm_tranzit" || level.script == "zm_highrise")
	{
		level.ta_tellerfee = 6942000;
		level.ta_vaultfee = 1000;
	}
}

onPlayerConnect(player)
{
		player thread endPlayerMoney2();
		player thread endPlayerMoney(); // probably not necessary
		player thread setPlayerMoney();
		player thread onPlayerSpawned();

		if (level.script == "zm_prison")
		{
			player thread checkAfterlifeActive();
		}
}

onPlayerSpawned()
{
	self endon( "disconnect" );
	level endon( "game_ended" );
	for(;;)
	{
		self waittill( "spawned_player" );
		if(self.score < 3000)
		{
			self.score = 3000;
		}
	}
}

checkAfterlifeActive()
{
	level endon ("game_ended");
	self endon("disconnect");
	for (;;)
	{
        	if (self.afterlife == 1)
        	{
				if(getdvar(self getEntityNumber() + "_can_use_bank") != "1")
					setDvar(self getEntityNumber() + "_can_use_bank", "1");
			}	
			else
			{
				if(getdvar(self getEntityNumber() + "_can_use_bank") != "")
					setDvar(self getEntityNumber() + "_can_use_bank", "");
			}
		wait 0.05;
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


endPlayerMoney()
{
	self endon("disconnect");
	for (;;) {
		level waittill("end_game");
		setDvar(self getEntityNumber() + "_money", 0);
	}
}

endPlayerMoney2()
{
	self endon("disconnect");
	for (;;) {
		level waittill("_zombie_game_over");
		setDvar(self getEntityNumber() + "_money", 0);
	}
}


setPlayerMoney()
{
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

getPlayerByGuid(guid)
{
	for (i = 0; i < level.players.size; i++) {
		if (isAlive(level.players[i]) && int(level.players[i] getGuid()) == int(guid)) {
			return level.players[i];
		} 
	}
	return false;
}

playerBank()
{
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