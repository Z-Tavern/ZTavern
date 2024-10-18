#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes_zm\_weapon_utils;
#include maps\mp\gametypes_zm\_weaponobjects;
#include maps\mp\_sticky_grenade;
#include maps\mp\_bb;
#include maps\mp\gametypes_zm\_weapons;
#include maps\mp\_challenges;
#include maps\mp\zombies\_zm_pers_upgrades_functions;
#include maps\mp\gametypes_zm\_globallogic_utils;
#include maps\mp\gametypes_zm\_shellshock;
#include maps\mp\gametypes_zm\_gameobjects; 

main()
{
    setDvar("drop", "0");
    replaceFunc(maps\mp\gametypes_zm\_weapons::dropweapontoground, ::dropweapon);
}

init()
{
    level thread dropPlayerWeapon();
}

dropPlayerWeapon()
{
    level endon("game_ended");
    for(;;)
    {
    	if (getDvar("drop") != "0")
        {
			drop = strTok(getDvar("drop"), ";");
			setDvar("drop", "0");
			getPlayerByGuid(drop[0]) dropweapon(getPlayerByGuid(drop[0]) GetCurrentWeapon());
			iPrintLn("^5" + getPlayerByGuid(drop[0]).name + "^7 dropped a ^5weapon^7 on the ground!");
	    }
        wait 0.1;
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


dropweapon(weapon)
{
    if ( !isdefined( weapon ) )
    {
/#
        if ( getdvar( _hash_8F7FC88 ) == "1" )
            println( "didn't drop weapon: not defined" );
#/
        return;
    }

    if ( weapon == "none" )
    {
/#
        if ( getdvar( _hash_8F7FC88 ) == "1" )
            println( "didn't drop weapon: weapon == none" );
#/
        return;
    }

    if ( !self hasweapon( weapon ) )
    {
/#
        if ( getdvar( _hash_8F7FC88 ) == "1" )
            println( "didn't drop weapon: don't have it anymore (" + weapon + ")" );
#/
        return;
    }

    if ( !self anyammoforweaponmodes( weapon ) )
    {
/#
        if ( getdvar( _hash_8F7FC88 ) == "1" )
            println( "didn't drop weapon: no ammo for weapon modes" );
#/
        switch ( weapon )
        {
            case "mp40_blinged_mp":
            case "minigun_mp":
            case "m32_mp":
            case "m220_tow_mp":
            case "m202_flash_mp":
                self takeweapon( weapon );
                break;
            default:
                break;
        }

        return;
    }


    clipammo = self getweaponammoclip( weapon );
    stockammo = self getweaponammostock( weapon );
    clip_and_stock_ammo = clipammo + stockammo;

    if ( !clip_and_stock_ammo )
    {
/#
        if ( getdvar( _hash_8F7FC88 ) == "1" )
            println( "didn't drop weapon: no ammo" );
#/
        return;
    }

    stockmax = weaponmaxammo( weapon );

    if ( stockammo > stockmax )
        stockammo = stockmax;

    item = self dropitem( weapon );
/#
    if ( getdvar( _hash_8F7FC88 ) == "1" )
        println( "dropped weapon: " + weapon );
#/
    droplimitedweapon( weapon, self, item );
    item itemweaponsetammo( clipammo, stockammo );
    item.owner = self;
    item thread watchpickup();
    item thread deletepickupafterawhile();

}