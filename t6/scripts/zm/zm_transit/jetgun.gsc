init()
{
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
    level waittill("initial_blackscreen_passed");
    self thread jetgun_heat_watcher();
}

jetgun_heat_watcher()
{
    level endon("end_game");
    while ( true )
    {
        if ( self getcurrentweapon() == "jetgun_zm" )
            self setweaponoverheating( self.jetgun_overheating, self.jetgun_heatval * 0.988);
        wait 0.12;
    }
}