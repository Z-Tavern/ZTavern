init()
{
	setdvar("r_fog", "0");
	level thread onPlayerConnect();
}

onplayerconnect()
{
	while( 1 )
	{
		level waittill( "connected", player );
		player SetClientDvar("r_fog", "0");
	}
}