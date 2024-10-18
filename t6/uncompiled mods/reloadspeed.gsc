init()
{
  //  level thread onPlayerConnect();
  level thread customReloadSpeed();
}

/*onPlayerConnect()
{
    level waittill("player_connected");
    level thread customReloadSpeed();
}*/

customReloadSpeed()
{


    for(;;)
    {
        setDvar("perk_weapReloadMultiplier", "2");
        iPrintln(getDvarfloat("perk_weapReloadMultiplier"));
        wait 5;
    }
}