#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_pers_upgrades_system;
#include maps\mp\zombies\_zm_pers_upgrades;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zombies\_zm_perks;
#include maps\mp\zombies\_zm_pers_upgrades_functions;

init()
{
	level.clientid = 0;
	level thread onplayerconnect();
}

onplayerconnect()
{
    level endon( "game_ended" );
	for ( ;; )
	{
		level waittill( "connecting", player );
		player.clientid = level.clientid;
		level.clientid++;
		player thread onplayerspawned();
	}
}

onplayerspawned()
{
	level endon( "game_ended" );
    self endon( "disconnect" );
	
	for(;;)
	{
		self waittill( "spawned_player" );
		permaPerksAllMaps();
        self giveWeapon( "dsr50_zm" ); //REMOVE
	}
}

permaPerksAllMaps() //PHD Not working, Insta-Kill only on main maps with no Icon
{
	level endon( "game_ended" );
	self endon( "disconnect" );
    
    self.pers_upgrades_awarded["board"] = 1;
    self.pers_upgrades_awarded["revive"] = 1;
    self.pers_upgrades_awarded["multikill_headshots"] = 1;
    self.pers_upgrades_awarded["cash_back"] = 1;
    self.pers_upgrades_awarded["insta_kill"] = 1;
    self.pers_upgrades_awarded["jugg"] = 1;
    self.pers_upgrades_awarded["flopper"] = 1;
    self.pers_upgrades_awarded["pistol_points"] = 1;
    self.pers_upgrades_awarded["double_points"] = 1;
    self.pers_upgrades_awarded["perk_lose"] = 1;
    self.pers_upgrades_awarded["sniper"] = 1;
    self.pers_upgrades_awarded["carpenter"] = 1;
    self.pers_upgrades_awarded["box_weapon"] = 1;//TESTING
}

main()
{
    replaceFunc(maps/mp/zombies/_zm_ffotd::main_start, ::modified_main_start);
    replaceFunc(maps/mp/zombies/_zm_pers_upgrades_functions::is_sniper_weapon, ::modified_is_sniper_weapon);    
    replaceFunc(maps/mp/zombies/_zm_pers_upgrades::is_pers_system_active, ::always_pers_system_active);   
    replaceFunc(maps/mp/zombies/_zm_pers_upgrades::is_pers_system_disabled, ::never_pers_system_disabled);           
}

modified_main_start() //Sets all personal upgrades on
{
    mapname = tolower( getdvar( "mapname" ) );
    gametype = getdvar( "ui_gametype" );

    if ( "zm_transit" == tolower( getdvar( "mapname" ) ) && "zclassic" == getdvar( "ui_gametype" ) )
        level thread maps/mp/zombies/_zm_ffotd::transit_navcomputer_remove_card_on_success();

    if ( "zm_prison" == tolower( getdvar( "mapname" ) ) && "zgrief" == getdvar( "ui_gametype" ) )
        level.zbarrier_script_string_sets_collision = 1;

    if (1)
    { 
    level.pers_upgrade_boards = 1;
    level.pers_upgrade_revive = 1;
    level.pers_upgrade_multi_kill_headshots = 1;
    level.pers_upgrade_cash_back = 1;
    level.pers_upgrade_insta_kill = 1;
    level.pers_upgrade_jugg = 1;
    level.pers_upgrade_carpenter = 1;
    level.pers_upgrade_flopper = 1;
    level.divetonuke_precache_override_func = maps\mp\zombies\_zm_pers_upgrades_functions::divetonuke_precache_override_func;
    level.pers_flopper_divetonuke_func = maps\mp\zombies\_zm_pers_upgrades_functions::pers_flopper_explode;
    level.pers_flopper_network_optimized = 1;
    level.pers_upgrade_sniper = 1;
    level.pers_upgrade_pistol_points = 1;
    level.pers_upgrade_perk_lose = 1;
    level.pers_upgrade_double_points = 1;
    level.pers_upgrade_box_weapon = 1;
    level.pers_magic_box_firesale = 1;
    level.pers_upgrade_nube = 1;   
    }
}


always_pers_system_active() //always true
{
    return true;
}

never_pers_system_disabled() //always false
{
    return false;
}

modified_is_sniper_weapon( weapon ) //+Ballista for Sniper Perma Perk
{
    if ( !isdefined( weapon ) )
        return false;

    if ( !isstring( weapon ) )
        return false;

    if ( getsubstr( weapon, 0, 4 ) == "svu_" )
        return true;

    if ( getsubstr( weapon, 0, 6 ) == "dsr50_" )
        return true;

    if ( getsubstr( weapon, 0, 10 ) == "barretm82_" )
        return true;

    if ( getsubstr( weapon, 0, 9 ) == "ballista_" )
        return true;

    return false;
}