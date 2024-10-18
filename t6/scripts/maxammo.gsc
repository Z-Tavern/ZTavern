init()
{
    setDvar("maxammo", "0");
    level thread maxAmmo();
}

maxAmmo()
{
    level endon("game_ended");
    level waittill("initial_blackscreen_passed");
    for (;;)
    {
        if (getDvar("maxammo") != "0")
        {
            player_data = strtok(getDvar("maxammo"), ";");
            setDvar("maxammo", "0");
            player_struct = getPlayerByGuid(player_data[0]);
            primaries = player_struct getweaponslistprimaries();

            foreach (primary in primaries)
            {
                if(!primary == "" && primary != "slipgun_zm"
                && primary != "staff_fire_zm" && primary != "staff_fire_upgraded_zm" 
                && primary != "staff_air_zm" && primary != "staff_air_upgraded_zm" 
                && primary != "staff_water_zm" && primary != "staff_water_upgraded_zm"
                && primary != "staff_lightning_zm" && primary != "staff_lightning_upgraded_zm"
                && primary !=  "blundersplat_upgraded_zm" && primary !=  "blundersplat_zm")
                {
                    max_ammo = weaponmaxammo( primary );
                    current_ammo = player_struct getweaponammostock (primary);
                    player_struct setweaponammostock( primary, int(current_ammo + (max_ammo * float(player_data[1])) ));
                    clip_ammo = player_struct getweaponammoclip( primary );
                    player_struct setweaponammoclip( primary, clip_ammo );
                }
            }
            player_struct iprintln("Weapons ^3ammo^7 refilled by ^5" + (float(player_data[1]) * 100) + "^7 percent !");
        }
        wait 0.1;
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