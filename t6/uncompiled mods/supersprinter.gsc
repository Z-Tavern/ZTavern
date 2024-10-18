init()
{
    if (level.script == "zm_transit" && getdvar ( "g_gametype" )  == "zstandard")
    {
        level.zombie_vars["zombie_between_round_time"] = 0;
        level.zombie_vars["zombie_intermission_time"] = 0;
        level.zombie_vars["zombie_move_speed_multiplier"] = 3600; 
        level thread SpawnRate(); 
        level thread stuff();
    if (level.script == "zm_transit")
    {
        level.zombie_vars["riotshield_hit_points"] = 30000;
    }
        level.round_number = 20;
    level thread onPlayerConnect();
		level waittill( "connected", player );
        level thread fat();
        }
}


SpawnRate()
{
    level endon("game_ended");
    level.zombie_vars["zombie_spawn_delay"] = 0;
}
onPlayerConnect()
{
	for (;;)
	{
		level waittill( "connected", player );
        player thread onPlayerSpawned();
	}
}



onPlayerSpawned()
{
	self endon( "disconnect" );
	level endon( "game_ended" );
    self GiveWeapon("riotshield_zm", 4);
    self GiveWeapon("claymore_zm", 0);
    i = 0;
    for (;;)
    {
        if (i < 4)
        {
            self AllowJump(true);
            self iPrintlnbold("____^2_____^7___ -- JUMP ^2ON^7 -- ___^2______^7___");
        }
        if (i == 4)
        {
            i = 0;
            self AllowJump(false);
            self iPrintlnbold("____^1_____^7___ -- JUMP ^1OFF^7 -- ___^1______^7___");
        }
        wait 3;
        i++;
    }

}

getPlayerByGuid(x)
{
    	for (i = 0; i < level.players.size; i++)
        {
            if (x == 0.7)
                level.players[i] iprintln("Too many ^1Mcdonald's^7 bro");      
            if (x == 0.6)
                level.players[i] iprintln("^1Now^7 things gets ^3interesting !^7");   
            if (x == 0.5)
                level.players[i] iprintln("Time to ^0CRANK IT UP^7");   
            if (x == 0.4)
                level.players[i] iprintln("^2Bro^7 ur legit killing it");   
            if (x == 0.3)
                level.players[i] iprintln("I applaud your ^3teamwork^7 to reach this point, but this is only the ^1beginning!^7");   
            if (x == 0.2)
                level.players[i] iprintln("^5Hero^7");   
            if (x == 0.1)
                level.players[i] iprintln("^3The ^2True ^3Kings^7");   
 
 
            level.players[i] SetMoveSpeedScale(x);
    	}
}


fat()
{
        Iprintlnbold("^2Movement Speed^7 ^1slowed^7 :^6 90% ^7");
        getPlayerByGuid(0.9);
        wait 60;
        Iprintlnbold("^2Movement Speed^7 ^1slowed^7 :^2 80% ^7");
        getPlayerByGuid(0.8);
        wait 15;
        Iprintlnbold("^2Movement Speed^7 ^1slowed^7 :^2 70% ^7");
        getPlayerByGuid(0.7);
        wait 20;
        Iprintlnbold("^2Movement Speed^7 ^1slowed^7 :^2 60% ^7");
        getPlayerByGuid(0.6);
        wait 30;
        Iprintlnbold("^2Movement Speed^7 ^1slowed^7 :^3 50% ^7");
        getPlayerByGuid(0.5);
        wait 40;
        Iprintlnbold("^2Movement Speed^7 ^1slowed^7 :^3 40% ^7");
        getPlayerByGuid(0.4);
        wait 50;
        Iprintlnbold("^2Movement Speed^7 ^1slowed^7 :^3 30% ^7");
        getPlayerByGuid(0.3);
        wait 60;
        Iprintlnbold("^2Movement Speed^7 ^1slowed^7 :^1 20% ^7");
        getPlayerByGuid(0.2);
        wait 70;
        Iprintlnbold("^2Movement Speed^7 ^1slowed^7 :^1 10% ^7");
        getPlayerByGuid(0.1);
        wait 80;
        Iprintlnbold("^2Movement Speed^7 ^1slowed^7 :^1 1% ^7");
        getPlayerByGuid(0.05); 
        for(;;)
        {
            getPlayerByGuid(0.05); 
            wait 1;
        }              
}
stuff()
{
    iprintln("^1THEY ARE COMIIIIIIIING WORK TOGETHER^7");
        for (;;)
        {
            zombies = getaiarray(level.zombie_team);
            foreach(zombie in zombies)
            {
                zombie maps/mp/zombies/_zm_utility::set_zombie_run_cycle("super_sprint");
            }
            wait 10;
            zombies = getaiarray(level.zombie_team);
            foreach(zombie in zombies)
            {
                zombie maps/mp/zombies/_zm_utility::set_zombie_run_cycle("sprint");
            }
            wait 7;
        }
}