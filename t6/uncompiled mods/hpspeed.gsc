/*#include maps\mp\_utility;
#include maps\mp\gametypes_zm\_hud_util;

#include common_scripts/utility;
#include maps/mp/_demo;
#include maps/mp/_utility;
#include maps/mp/_visionset_mgr;
#include maps/mp/gametypes_zm/_hud_util;
#include maps/mp/gametypes_zm/_weapons;
#include maps/mp/gametypes_zm/_zm_gametype;
#include maps/mp/zombies/_zm;
#include maps/mp/zombies/_zm_ai_basic;
#include maps/mp/zombies/_zm_ai_dogs;
#include maps/mp/zombies/_zm_audio;
#include maps/mp/zombies/_zm_audio_announcer;
#include maps/mp/zombies/_zm_blockers;
#include maps/mp/zombies/_zm_bot;
#include maps/mp/zombies/_zm_buildables;
#include maps/mp/zombies/_zm_clone;
#include maps/mp/zombies/_zm_devgui;
#include maps/mp/zombies/_zm_equipment;
#include maps/mp/zombies/_zm_ffotd;
#include maps/mp/zombies/_zm_game_module;
#include maps/mp/zombies/_zm_gump;
#include maps/mp/zombies/_zm_laststand;
#include maps/mp/zombies/_zm_magicbox;
#include maps/mp/zombies/_zm_melee_weapon;
#include maps/mp/zombies/_zm_perks;
#include maps/mp/zombies/_zm_pers_upgrades;
#include maps/mp/zombies/_zm_pers_upgrades_system;
#include maps/mp/zombies/_zm_pers_upgrades_functions;
#include maps/mp/zombies/_zm_playerhealth;
#include maps/mp/zombies/_zm_powerups;
#include maps/mp/zombies/_zm_power;
#include maps/mp/zombies/_zm_score;
#include maps/mp/zombies/_zm_sidequests;
#include maps/mp/zombies/_zm_spawner;
#include maps/mp/zombies/_zm_stats;
#include maps/mp/zombies/_zm_timer;
#include maps/mp/zombies/_zm_tombstone;
#include maps/mp/zombies/_zm_traps;
#include maps/mp/zombies/_zm_unitrigger;
#include maps/mp/zombies/_zm_utility;
#include maps/mp/zombies/_zm_weapons;
#include maps/mp/zombies/_zm_zonemgr;*/
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
    replaceFunc(maps/mp/zombies/_zm_perks::perk_set_max_health_if_jugg, ::customJugg);
}
init()
{
    setdvar("hp", "");
    level thread onPlayerConnect();
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
    if (getdvar("hp" != "")
    {
        self iPrintln("custom hp activated)
    }
    setdvar("hp", "");
    level endon("game_ended");
    self endon("disconnect");
    self waittill( "spawned_player" );

    self.extrahealth = 50;
    self.maxhealth += self.extrahealth;
    self.health = self.maxhealth;

   // self SetMoveSpeedScale(1.9);
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
        if ( self maps\mp\zombies\_zm_pers_upgrades_functions::pers_jugg_active() )
            max_total_health += level.pers_jugg_upgrade_health_bonus;

        if (self.extrahealth)
            self setmaxhealth( max_total_health + self.extrahealth);
        else
            self setmaxhealth( max_total_health + self.extrahealth);          

        if ( isdefined( clamp_health_to_max_health ) && clamp_health_to_max_health == 1 )
        {
            if ( self.health > self.maxhealth )
                self.health = self.maxhealth;
        }
    }
}