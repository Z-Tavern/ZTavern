#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_magicbox;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\zombies\_zm_power;
#include maps\mp\zombies\_zm_pers_upgrades_functions;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\_demo;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_chugabud;
#include maps\mp\_visionset_mgr;
#include maps\mp\zombies\_zm_perks;
#include maps\mp\zombies\_zm;

main()
{
    replaceFunc(maps\mp\zombies\_zm_perks::perk_set_max_health_if_jugg, ::customJugg);
}
init()
{    
  //  level thread onPlayerConnect();
    level thread playerStats();
    setdvar("hp", "");
	setdvar("speed", "");
	setdvar("starthp", "");
	setdvar("0_hp", "");
	setdvar("1_hp", "");
	setdvar("2_hp", "");
	setdvar("3_hp", "");
	setdvar("4_hp", "");
	setdvar("5_hp", "");
	setdvar("6_hp", "");
	setdvar("7_hp", "");
	setdvar("0_speed", "");
	setdvar("1_speed", "");
	setdvar("2_speed", "");
	setdvar("3_speed", "");
	setdvar("4_speed", "");
	setdvar("5_speed", "");
	setdvar("6_speed", "");
	setdvar("7_speed", "");
    flag_wait( "initial_blackscreen_passed" );
	setdvar("restart", "1");
}

/*onPlayerConnect()
{
	while( 1 )
	{
		level waittill( "connected", player );
		player thread onPlayerSpawned();
	}
}

onPlayerSpawned()
{
    level endon("game_ended");
    self endon("disconnect");
	self waittill( "spawned_player" );
	
	if (getDvar("starthp") != "") {
			stats = strTok(getDvar("starthp"), ";");
			setDvar("starthp", "");
			self waittill( "spawned_player" );
			getPlayerByGuid(stats[0]).extrahealth = int(stats[1]);
			baseHp = 100;
			if (getPlayerByGuid(stats[0]) HasPerk("specialty_armorvest"))
				baseHp += 150;
            getPlayerByGuid(stats[0]).maxhealth = getPlayerByGuid(stats[0]).extrahealth + baseHp;
            getPlayerByGuid(stats[0]).health = getPlayerByGuid(stats[0]).maxhealth;
			getPlayerByGuid(stats[0]) iPrintLn("^3Custom^1 HP^3 set.");
		}
   // self SetMoveSpeedScale(1.9);
}*/

playerStats() {
	for (;;) {
		if (getDvar("hp") != "")
		{
			statsHp = strTok(getDvar("hp"), ";");
			setDvar("hp", "");
			target = getPlayerByGuid(statsHp[0]);
			target.extrahealth = int(statsHp[1]);
			baseHp = 100;
			if (target HasPerk("specialty_armorvest"))
				baseHp += 150;
            target.maxhealth = target.extrahealth + baseHp;
        	target.health = target.maxhealth;
			target iPrintLn("^1HP^3 set to ^2" + target.maxhealth + "^7");
			iprintln("^3" + target.name + "^7 now have ^1" + target.maxhealth + " HP !^7"
		}
		if (getDvar("speed") != "")
		{
			statsSpeed = strTok(getDvar("speed"), ";");
			setDvar("speed", "");
			target = getPlayerByGuid(statsSpeed[0]);
			if (target HasPerk("specialty_longersprint"))
			{
				target SetMoveSpeedScale(float(statsSpeed[1]) + 0.07);
				target iPrintLn("^1Speed^3 set to ^2" + (float(statsSpeed[1]) + 0.07) + "^7");
			}
			else
			{
				target SetMoveSpeedScale(float(statsSpeed[1]));
				target iPrintLn("^1Speed^3 set to ^2" + statsSpeed[1] + "^7");
			}
			iprintln("^3" + target.name + "^7 now have ^2" + statsSpeed[1] + " Speed !^7"
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


customJugg( perk, set_premaxhealth, clamp_health_to_max_health )
{
    max_total_health = undefined;

    if ( perk == "specialty_armorvest" )
    {
        if ( set_premaxhealth )
            self.premaxhealth = self.maxhealth;

        max_total_health = level.zombie_vars["zombie_perk_juggernaut_health"];
    }
    else if ( perk == "specialty_armorvest_upgrade" )
    {
        if ( set_premaxhealth )
            self.premaxhealth = self.maxhealth;

        max_total_health = level.zombie_vars["zombie_perk_juggernaut_health_upgrade"];
    }
    else if ( perk == "jugg_upgrade" )
    {
        if ( set_premaxhealth )
            self.premaxhealth = self.maxhealth;

        if ( self hasperk( "specialty_armorvest" ) )
            max_total_health = level.zombie_vars["zombie_perk_juggernaut_health"];
        else
            max_total_health = 100;
    }
    else if ( perk == "health_reboot" )
        max_total_health = 100;

    if ( isdefined( max_total_health ) )
    {
       // if ( self maps\mp\zombies\_zm_pers_upgrades_functions::pers_jugg_active() )
        //    max_total_health += level.pers_jugg_upgrade_health_bonus;

			if (isdefined (self.extrahealth))
            	self setmaxhealth( max_total_health + self.extrahealth);    
			else
				self setmaxhealth( max_total_health);    

        if ( isdefined( clamp_health_to_max_health ) && clamp_health_to_max_health == 1 )
        {
            if ( self.health > self.maxhealth )
                self.health = self.maxhealth;
        }
    }
}

