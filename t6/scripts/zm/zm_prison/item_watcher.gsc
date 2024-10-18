init()
{
    wait 1;
    if (check_for_botb_port() == true || getdvar("net_port") == "30011" || getdvar("net_port") == "30001")
        return;
    level thread check_for_equipment();
    setdvar("upgraded_tomahawk", "0");
    setdvar("golden_spork", "0");
}

check_for_equipment()
{
    level waittill("start_of_round");
    for(;;)
    {
        foreach(player in level.players)
        {
            if (player hasweapon("spork_zm_alcatraz") && !isdefined(player.has_spork))
            {
                setdvar("golden_spork", player getguid());
                player iprintln("^3Golden Spoon^7 challenge ^2completed^7 !");
                player iprintln("^3Golden Spoon^7 challenge ^2completed^7 !");
                player iprintln("^3Golden Spoon^7 challenge ^2completed^7 !");
                player.has_spork = 1;
            }
            if (player hasweapon( "upgraded_tomahawk_zm") && !isdefined(player.has_hawk))
            {
                setdvar("upgraded_tomahawk", player getguid());
                player iprintln("^5Upgraded Tomahawk^7 challenge ^2completed^7 !");
                player iprintln("^5Upgraded Tomahawk^7 challenge ^2completed^7 !");
                player iprintln("^5Upgraded Tomahawk^7 challenge ^2completed^7 !");
                player.has_hawk = 1;
            }
        }
        wait 1;
    }
}

check_for_botb_port()
{
    found = 0;
	if (isdefined(level.net_port_botb))
	{
		foreach(port in level.net_port_botb)
		{
			if (getdvar("net_port") == port)
				found = 1;
		}
	}
    if (found == 0)
        return false;
    return true;
}