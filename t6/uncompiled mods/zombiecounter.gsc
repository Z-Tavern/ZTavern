init()
{
    level thread onPlayerConnect();
}

onPlayerConnect()
{
    level endon("game_ended");
    for(;;)
    {
        level waittill("connected", player);
	    player thread discordWatermark();
    }
}


discordWatermark()
{
	self endon( "disconnect" );
	level endon( "end_game" );

    self.zombieText1 = maps\mp\gametypes_zm\_hud_util::createFontString( "hudsmall" , 1.5 );
    self.zombieText1 maps\mp\gametypes_zm\_hud_util::setPoint( "TOP", "LEFT", 0, -230 );
    self.zombieText1.label = &"Join the ^3Tavern";
    self.zombieText1.alpha = 0.7;

    self.zombieText2 = maps\mp\gametypes_zm\_hud_util::createFontString( "hudsmall" , 1.5 );
    self.zombieText2 maps\mp\gametypes_zm\_hud_util::setPoint( "TOP", "LEFT", 0, -214 );
    self.zombieText2.label = &"^5discord.gg\ZTavern";
	self.zombieText2.alpha = 0.7;
    
}
