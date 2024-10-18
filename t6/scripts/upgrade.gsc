init()
{
    level thread zcoins();
    setdvar("fire_rate", "0.75");
    setdvar("cost", "75");
    setdvar("upgrade", "");
    setdvar("perk_weapRateMultiplier", "0.75");
    level.rate = 0.75;
    level.lock = 0;
}

zcoins()
{
    for (;;)
    {
        if (getdvar("upgrade") != "")
        {
            level.rate = float(getdvar("upgrade"));
            iprintln("rate = " + level.rate);
//            if (level.rate <= 0.3)
 //               level.rate = 0.3;
            setdvar("fire_rate", level.rate);
            setdvar("upgrade", "");
            setdvar("perk_weapRateMultiplier", level.rate);
            level thread joining_player_watcher();
        }
        wait 0.1;
    }
}

joining_player_watcher()
{
    foreach(player in level.players)
    {
        if (player HasPerk("specialty_rof") == 0)
            player thread maps\mp\zombies\_zm_perks::wait_give_perk("specialty_rof", 1); 
            if (level.rate != 0.3)
                player iprintln("Fire rate ^3Upgraded^7 to " + level.rate + " !");
    }
    if (level.rate <= 0.5 && level.lock == 0)
    {
        iprintln("Perma ^3Double Tap^7 ^2unlocked !");
        iprintln("Perma ^3Double Tap^7 ^2unlocked !");
        iprintln("Perma ^3Double Tap^7 ^2unlocked !");
        level thread firerate_upgrade();
        level.lock = 1;
    }
        
}

firerate_upgrade()
{
    for (;;)
    {
        foreach(player in level.players)
        {
            if (player HasPerk("specialty_rof") == 0)
            {
                player thread maps\mp\zombies\_zm_perks::wait_give_perk("specialty_rof", 1); 
            }

        }
        wait 1;
    }

}