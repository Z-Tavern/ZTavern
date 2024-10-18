init()
{
    setDvar("hide", "");
    level thread onPlayerConnect();
    level thread hideHUD();
}

onPlayerConnect()
{
    for(;;)
    {
        level waittill("connected", player);
  //      player thread isLobbyClaimed();
        player thread healthCounter();
        player thread zombieCounter();
	    player thread discordWatermark();
    }
}

hideHUD()
{
    level endon("game_ended");
	for (;;) {
		if (getDvar("hide") != "")
        {
			hide = strTok(getDvar("hide"), ";");
			setDvar("hide", "");
            client = getPlayerByGuid(hide[0]);
            if (hide[1] == "off")
            {
                client.zombieText2.alpha = 0;
                client.zombieText3.alpha = 0;
                client.zombieText4.alpha = 0;
                client.zombieText5.alpha = 0;
                client.zombieText6.alpha = 0;
                client.zombieText7.alpha = 0;
                client.zombieText8.alpha = 0;
                client.zombieText9.alpha = 0;
                client.zombieText10.alpha = 0;
                client.zombieText11.alpha = 0;
                client iPrintLn("^3HUD ^1OFF^7");    
            }
            if (hide[1] == "on")
            {
                client.zombieText2.alpha = 0.7;
                client.zombieText3.alpha = 0.7;
                client.zombieText4.alpha = 0.7;
                client.zombieText5.alpha = 0.7;
                client.zombieText6.alpha = 0.7;
                client.zombieText7.alpha = 0.7;
                client.zombieText8.alpha = 0.7;
                client.zombieText9.alpha = 0.7;
                client.zombieText10.alpha = 0.7;
                client.zombieText11.alpha = 0.7;
                client iPrintLn("^3HUD ^2ON^7");   
            }
		}
		wait 0.5;
	}
}
/*isLobbyClaimed()
{
	self endon ("disconnect");
	level endon( "end_game" );

	common_scripts\utility::flag_wait( "initial_blackscreen_passed" );
    self.zombieText12 = maps\mp\gametypes_zm\_hud_util::createFontString( "hudsmall" , 1 );
    self.zombieText12 maps\mp\gametypes_zm\_hud_util::setPoint( "TOP", "LEFT", 0, -145 );
    self.zombieText12.label = &"^5 Is Lobby Claimed ?^7 ~ ^1[NO] ^7YES  ~";
    self.zombieText12.alpha = 0.7;

    self.zombieText13 = maps\mp\gametypes_zm\_hud_util::createFontString( "hudsmall" , 1 );
    self.zombieText13 maps\mp\gametypes_zm\_hud_util::setPoint( "TOP", "LEFT", 0, -135 );
    self.zombieText13.label = &"^3use ^2.save [1-2]^7 to ^3claim it!^7";
    self.zombieText13.alpha = 0.7;

    for (;;)
    {
        if (getDvar("isSaved") != "0")
        {
            self.zombieText12.alpha = 0;
            self.zombieText13.alpha = 0;
        }
        wait 1;
    }
}*/

healthCounter()
{
	self endon("disconnect");
	level endon( "end_game" );
	common_scripts\utility::flag_wait( "initial_blackscreen_passed" );
	self.healthText = maps\mp\gametypes_zm\_hud_util::createFontString ("hudsmall", 1.5);
	self.healthText maps\mp\gametypes_zm\_hud_util::setPoint ("CENTER", "CENTER", 100, 220);
	self.healthText.label = &"Health: ^2";
	while ( 1 )
	{
		self.healthText setValue(self.health);
		wait 0.25;
	}
}

zombieCounter()
{
	self endon( "disconnect" );
	level endon( "end_game" );
	common_scripts\utility::flag_wait( "initial_blackscreen_passed" );
    self.zombieText = maps\mp\gametypes_zm\_hud_util::createFontString( "hudsmall" , 1.5 );
    self.zombieText maps\mp\gametypes_zm\_hud_util::setPoint( "CENTER", "CENTER", -100, 220 );
    while( 1 )
    {
        self.zombieText setValue( ( maps\mp\zombies\_zm_utility::get_round_enemy_array().size + level.zombie_total ) );
        if( ( maps\mp\zombies\_zm_utility::get_round_enemy_array().size + level.zombie_total ) != 0 )
        {
        	self.zombieText.label = &"Zombies: ^1";
        }
        else
        {
        	self.zombieText.label = &"Zombies: ^6";
        }
        wait 0.25;
    }
}

discordWatermark()
{
	self endon( "disconnect" );
	level endon( "end_game" );

	common_scripts\utility::flag_wait( "initial_blackscreen_passed" );
    self.zombieText2 = maps\mp\gametypes_zm\_hud_util::createFontString( "hudsmall" , 1.5 );
    self.zombieText2 maps\mp\gametypes_zm\_hud_util::setPoint( "TOP", "LEFT", 0, -230 );
    self.zombieText2.label = &"Join the ^3Tavern";
    self.zombieText2.alpha = 0.7;

    self.zombieText3 = maps\mp\gametypes_zm\_hud_util::createFontString( "hudsmall" , 1.5 );
    self.zombieText3 maps\mp\gametypes_zm\_hud_util::setPoint( "TOP", "LEFT", 0, -214 );
    self.zombieText3.label = &"^5discord.gg/ZTavern";
	self.zombieText3.alpha = 0.7;

    self.zombieText4 = maps\mp\gametypes_zm\_hud_util::createFontString( "hudsmall" , 1 );
    self.zombieText4 maps\mp\gametypes_zm\_hud_util::setPoint( "TOP", "LEFT", 0, -195 );
    self.zombieText4.label = &"to get ^2200K POINTS";
	self.zombieText4.alpha = 0.7;

    self.zombieText5 = maps\mp\gametypes_zm\_hud_util::createFontString( "hudsmall" , 1 );
    self.zombieText5 maps\mp\gametypes_zm\_hud_util::setPoint( "TOP", "RIGHT", 0, -225 );
    self.zombieText5.label = &"Use ^3.c ^7for commands";
    self.zombieText5.alpha = 0.7;

    self.zombieText6 = maps\mp\gametypes_zm\_hud_util::createFontString( "hudsmall" , 1 );
    self.zombieText6 maps\mp\gametypes_zm\_hud_util::setPoint( "TOP", "RIGHT", 0, -212 );
    self.zombieText6.label = &"FR ^3.c fr ^7pour les commandes^7";
    self.zombieText6.alpha = 0.7;

    self.zombieText7 = maps\mp\gametypes_zm\_hud_util::createFontString( "hudsmall" , 1 );
    self.zombieText7 maps\mp\gametypes_zm\_hud_util::setPoint( "TOP", "RIGHT", 0, -195 );
    self.zombieText7.label = &"^3[.rank] [.rankup] ^6[.d] [.w] ^2[.afk]";
    self.zombieText7.alpha = 0.7;

    self.zombieText8 = maps\mp\gametypes_zm\_hud_util::createFontString( "hudsmall" , 1 );
    self.zombieText8 maps\mp\gametypes_zm\_hud_util::setPoint( "TOP", "RIGHT", 0, -185 );
    self.zombieText8.label = &"^5[.buy] [.buy hp] [.buy speed] [.^1flex^5]^7";
    self.zombieText8.alpha = 0.7;

    self.zombieText9 = maps\mp\gametypes_zm\_hud_util::createFontString( "hudsmall" , 1 );
    self.zombieText9 maps\mp\gametypes_zm\_hud_util::setPoint( "TOP", "RIGHT", 0, -172 );
    self.zombieText9.label = &"^3[.save] [.load] ^6[.hud] [.kill]";
    self.zombieText9.alpha = 0.7;

    self.zombieText10 = maps\mp\gametypes_zm\_hud_util::createFontString( "hudsmall" , 1 );
    self.zombieText10 maps\mp\gametypes_zm\_hud_util::setPoint( "TOP", "RIGHT", 0, -160 );
    self.zombieText10.label = &"^3VIP/HIGH RANK COMMANDS^7";
    self.zombieText10.alpha = 0.7;

    self.zombieText11 = maps\mp\gametypes_zm\_hud_util::createFontString( "hudsmall" , 1 );
    self.zombieText11 maps\mp\gametypes_zm\_hud_util::setPoint( "TOP", "RIGHT", 0, -145 );
    self.zombieText11.label = &"^1[.rev] [.drop] [.king]";
    self.zombieText11.alpha = 0.7;

  /*  self.zombieText11 = maps\mp\gametypes_zm\_hud_util::createFontString( "hudsmall" , 1 );
    self.zombieText11 maps\mp\gametypes_zm\_hud_util::setPoint( "TOP", "RIGHT", 0, -130 );
    self.zombieText11.label = &"^5 SEASON 1 -20 ON ALL SHOP";
    self.zombieText11.alpha = 0.7;*/
}

getPlayerByGuid(guid) {
    	for (i = 0; i < level.players.size; i++) {
        	if (isAlive(level.players[i]) && int(level.players[i] getGuid()) == int(guid)) {
            	return level.players[i];
        	} 
    	}
    	return false;
}