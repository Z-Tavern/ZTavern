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

init() {
   	level thread onPlayerConnect();
        mapname = getDvar( "mapname" );
   	setDvar("bank_withdraw", "");
  	setDvar("bank_deposit", "");
						setDvar("0_can_use_bank", "");
  	level thread playerBank();
}

onPlayerConnect()
{
	level endon( "end_game" );
   	self endon( "disconnect" );
	for (;;)
	{
		level waittill( "connected", player );
		player thread endPlayerMoney2();
		player thread endPlayerMoney(); // probably not necessary
		player thread setPlayerMoney();

	}
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
	self endon("disconnect");
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

			if ( level.script == "zm_buried")
			{
				if(!flag("time_bomb_restore_active"))
				{
					setDvar("0_can_use_bank", "0");
					getPlayerByGuid(deposit[0]) iPrintLn("Cannot deposit when ^2Time Bomb ^7is set.");
					deposit = strTok(getDvar("bank_deposit"), ";");

					getPlayerByGuid(deposit[0]).score -= 0;
					getPlayerByGuid(deposit[0]) iPrintLn("Deposited ^2$" + int(deposit[1]) + "^7 into your bank account!");				
				}
				else
				{
				deposit = strTok(getDvar("bank_deposit"), ";");
				setDvar("bank_deposit", "");
				getPlayerByGuid(deposit[0]).score -= int(deposit[1]);
				getPlayerByGuid(deposit[0]) iPrintLn("Deposited ^2$" + int(deposit[1]) + "^7 into your bank account!");
				}
			}
			else
			{
				deposit = strTok(getDvar("bank_deposit"), ";");
				setDvar("bank_deposit", "");
				getPlayerByGuid(deposit[0]).score -= int(deposit[1]);
				getPlayerByGuid(deposit[0]) iPrintLn("Deposited ^2$" + int(deposit[1]) + "^7 into your bank account!");
			}
		}
		wait 0.05;
	}
}