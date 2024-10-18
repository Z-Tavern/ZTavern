#include common_scripts\utility;

init()
{
    level thread on_player_connect();
    level thread hat_think();
}

on_player_connect()
{
    for (;;)
    {
        level waittill("connected", player);
        player thread hat_think();

    }
}


hat_think()
{
    flag_wait("initial_blackscreen_passed");

    for (;;)
    {
        if (getdvar("hat") != "0")
        {
            p_guid = getdvarInt("hat");
            setdvar("hat", "0");
            foreach(player in level.players)
            {
                if (int(player getguid()) == p_guid)
                {
                    if (getdvar("net_port") == "30007" || getdvar("net_port") == "30008" || getdvar("net_port") == "30009"  || getdvar("net_port") == "30010" )
                        player thread origins_hat_think();
                    if (getdvar("net_port") == "30001" || getdvar("net_port") == "30004" || getdvar("net_port") == "30005")
                        player thread motd_hat_think();
                    if (getdvar("net_port") == "30011" || getdvar("net_port") == "30012" || getdvar("net_port") == "300013"  || getdvar("net_port") == "30014" || getdvar("net_port") == "30015")
                        player thread transit_hat_think();
                    player thread hat_cleanup();
                }
            }
        }
        wait 0.1;
    }
}

hat_cleanup()
{
    self waittill("disconnect");
    self.p_helmet delete();
}

origins_hat_think()
{
    self endon("disconnect");
    iprintln("^5Hat^7 granted to " + self.name);
    for (;;)
    {
        if (self.sessionstate != "spectator")
            break;
        wait 0.1;
    }
    self.p_helmet = spawn( "script_model", self.origin );
    self.p_helmet linkto( self, "J_Helmet", (4, 0, -5), (-20, 0, 0));
    wait 0.1;
    self.p_helmet setmodel( "c_zom_mech_faceplate" );  
    self.p_helmet notsolid();

}

motd_hat_think()
{
    self endon("disconnect");
    iprintln("^5Hat^7 granted to " + self.name);
    for (;;)
    {
        if (self.sessionstate != "spectator")
            break;
        wait 0.1;
    }

    self.hatmodel = "c_zom_cellbreaker_helmet";
    self attach( self.hatmodel );

    for (;;)
    {
        for (;;)
        {
            if (self.sessionstate == "spectator")
                break;
            wait 0.1;
        }
        for (;;)
        {
            if (self.sessionstate != "spectator")
            {
                self attach( self.hatmodel );
                break;
            }
            wait 0.1;   
        }
        wait 0.1;
    }  
}

transit_hat_think()
{
    self endon("disconnect");
    iprintln("^5Hat^7 granted to " + self.name);
    for (;;)
    {
        if (self.sessionstate != "spectator")
            break;
        wait 0.1;
    }

    self.p_helmet = spawn( "script_model", self.origin );
    self.p_helmet linkto( self, "J_Helmet", (-9, 0, -25), (0, 0, 0));
    wait 0.1;
    self.p_helmet setmodel( "c_zom_screecher_fb" );  
}