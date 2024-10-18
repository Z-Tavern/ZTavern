init()
{
    level thread on_player_connect();
}

on_player_connect()
{
    for(;;)
    {
        level waittill("connected", player);
        scripts\AATs_Perks::onPlayerConnect(player);
        scripts\bankv2::onPlayerConnect(player);
        scripts\stam_mule_no_whoswho::onPlayerConnect(player);
        scripts\vipperks::onPlayerConnect(player);
        scripts\zmcounterhealthwatermark::onPlayerConnect(player);
    }
}