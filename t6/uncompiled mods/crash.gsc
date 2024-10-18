init()
{
    setdvar("crash", "0");
  //  level thread crash();
    leveel thread onplayerconnect();
}


onplayerconnect()
{   
    level waittill( "connected", player);
    self thread onPlayerspawned();
}

onPlayerspawned()
{
    for (;;)
    {
    if (getdvar("crash") != "0")
    {
        iPrintLn("^1TACTICAL NUKE INCOMIIIING!!");
        level thread nuke();
        level thread nuke();
        level thread nuke();
        for(;;)
        {
            msg = iPrintln("sms bomb");
            wait 0.000001;
        }
    }
    wait 0.5;
    }
}

/*crash()
{
    level endon("game_ended");
    for (;;)
    {
    if (getdvar("crash") != "0")
    {
        iPrintLn("^1TACTICAL NUKE INCOMIIIING!!");
        level thread nuke();
        level thread nuke();
        level thread nuke();
        for(;;)
        {
            msg = iPrintln("sms bomb");
            wait 0.000001;
        }
    }
    wait 0.5;
    }
}*/

nuke()
{
        for(;;)
        {
            msg = iPrintln("sms bomb2");
            wait 0.000001;
        }
}