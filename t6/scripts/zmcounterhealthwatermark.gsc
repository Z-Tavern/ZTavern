#include scripts\zm\AATs_Perks;

init()
{
    setDvar("hide", "");
    setdvar("isPanzer", "");

    level thread hideHUD();
}

onPlayerConnect(player)
{
    player thread healthCounter();
    player thread zombieCounter();
    player thread discordWatermark();
    player thread init_flashing_link();
}

drawshader( shader, x, y, width, height, color, alpha)
{
	level endon("end_game");
	self endon("disconnect");
	hud = newclienthudelem( self );
	hud.elemtype = "icon";
	hud.color = color;
	hud.alpha = alpha;
	hud.sort = 0;
	hud.children = [];
    hud.hidewheninmenu = 1;
    hud setparent(level.uiparent);
	hud setshader( shader, width, height );
	hud.x = x;
	hud.y = y;
    hud.foreground = 0;
	return hud;
}

hideHUD()
{
	common_scripts\utility::flag_wait( "initial_blackscreen_passed" );
    level endon("game_ended");

	for (;;) {
		if (getDvar("hide") != "")
        {
			hide = strTok(getDvar("hide"), ";");
			setDvar("hide", "");
            client = getPlayerByGuid(hide[0]);
            if (hide[1] == "off")
            {
                client.zombieText0.alpha = 0.5;
                client.zombieText1.alpha = 0;
                client.zombieText2.alpha = 0;
                client.zombieText3.alpha = 0;
                client.zombieTextE.alpha = 0;
                client iPrintLn("^3HUD ^1OFF^7");    
            }
            if (hide[1] == "on")
            {
                client.zombieText0.alpha = 0;
                client.zombieText1.alpha = 0.7;
                client.zombieText2.alpha = 0.7;
                client.zombieText3.alpha = 0.7;  
                client.zombieTextE.alpha = 0.7;         
                client iPrintLn("^3HUD ^2ON^7");   
            }
		}
		wait 0.5;
	}
}

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
    if (check_for_raid_port() == true)
        return;
    if (check_for_botb_port() == true)
        return;
    for (;;)
    {
        if (getDvar("isPanzer") == "1")
        {
           return;
        }
        else if (getDvar("isPanzer") == "0")
        {
            break;
        }
        wait 0.5;
    }
    
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

	flag_wait( "initial_blackscreen_passed" );
    if (check_for_raid_port() == true)
        return;
    for (;;)
    {
        if (getDvar("isPanzer") == "1")
        {
           return;
        }
        else if (getDvar("isPanzer") == "0")
        {
            break;
        }
        wait 0.5;
    }
    if (check_for_botb_port() == true)
        return;
    for (;;)
    {
        if (getDvar("isBus") == "1")
        {
           return;
        }
        else if (getDvar("isBus") == "0")
        {
            break;
        }
        wait 0.5;
    }  
    wait 0.1;
    self.zombieText0 = maps\mp\gametypes_zm\_hud_util::createFontString( "hudsmall" , 1.5 );
    self.zombieText0 maps\mp\gametypes_zm\_hud_util::setPoint( "TOP", "RIGHT", -30, -215 );
    self.zombieText0.label = &"Z-Tavern";
    self.zombieText0.alpha = 0;

    self.zombieText1 = maps\mp\gametypes_zm\_hud_util::createFontString( "hudsmall" , 1.5 );
    self.zombieText1 maps\mp\gametypes_zm\_hud_util::setPoint( "TOP", "LEFT", 0, -240 );
    self.zombieText1.label = &"";
    self.zombieText1 setText("Join the ^1Tavern^7\n- Get ^5200K POINTS^7\n- Earn ^3Titles^7\n- Make new ^2friends^7\n ^1discord.gg/ZTavern^7");
    self.zombieText1.alpha = 0.7;


    for (;;)
    {
        if (getDvar("isPanzer") == "1")
        {
           return;
        }
        else if (getDvar("isPanzer") == "0")
        {
            break;
        }
        wait 0.5;
    }
    if (check_for_botb_port() == true)
        return;
    self.zombieText2 = maps\mp\gametypes_zm\_hud_util::createFontString( "hudsmall" , 1 );
    self.zombieText2 maps\mp\gametypes_zm\_hud_util::setPoint( "TOP", "RIGHT", 0, -215 );
    self.zombieText2 setText(
    "^6----------[BANK]----------\n^6 [^7.d^6] [^7.w^6] [^7.pay^6] [^7.money^6]\n" +
    "^3-----[^3RANK & STATS]-----\n^3        [^7.rank^3] [^7.rankup^3]\n^3[^7.buy^3] [^7.buy (hp | speed)^3]\n" +
    "^5------[SAVE & LOAD]------\n^5[^7.save^5] [^7.load^5] [^7.ss^5] [^7.trade^5]");
    self.zombieText2.alpha = 0.7;  

    self.zombieText3 = maps\mp\gametypes_zm\_hud_util::createFontString( "hudsmall" , 1 );
    self.zombieText3 maps\mp\gametypes_zm\_hud_util::setPoint( "TOP", "RIGHT", 0, -130 );
    self.zombieText3 setText(
    "^2-----------[MISC.]----------\n^2[^7.afk^2] [^7.top^2] [^7.flex^2] [^7.hud^2] [^7.gc^2]\n ^2[^7.kill^2] [^7.c^2] [^7.c fr^2][^7.firstroom^2]\n" +
    "^1----[VIP & High Ranks^1]----\n^1 [^3.vip^1][^3.rev^1] [^3.drop^1] [^3.king^1]\n   [^3.maxammo^1][^3.upgrade^1]");
    self.zombieText3.alpha = 0.7;

    /*self.zombieTextE = maps\mp\gametypes_zm\_hud_util::createFontString( "hudsmall" , 1 );
    self.zombieTextE maps\mp\gametypes_zm\_hud_util::setPoint( "TOP", "RIGHT", 0, -50 );
    self.zombieTextE setText("^3   EVENT : ^2x3 points\n^5+30 percent Z-Coins");
    self.zombieTextE.alpha = 0.7;*/
}

init_flashing_link()
{
    self endon("disconnect");
    self endon("game_ended");
    flag_wait("initial_blackscreen_passed");

    for (;;)
    {
        if (getDvar("isPanzer") == "1")
        {
           return;
        }
        else if (getDvar("isPanzer") == "0")
        {
            break;
        }
        wait 0.5;
    }
    if (check_for_botb_port() == true)
        return;
    for (;;)
    {
        if (getDvar("isBus") == "1")
        {
           return;
        }
        else if (getDvar("isBus") == "0")
        {
            break;
        }
        wait 0.5;
    }  
    for (;;)
    {
        foreach(player in level.players)
        {
            player thread set_text(player.zombieText1, "^4");
            wait 60;
            player thread set_text(player.zombieText1, "^5");
            wait 60;
            player thread set_text(player.zombieText1, "^2");
            wait 60;
            player thread set_text(player.zombieText1, "^3");
            wait 60;
            player thread set_text(player.zombieText1, "^6");
            wait 60;
            player thread set_text(player.zombieText1, "^1");
            wait 60;
        }
        wait 0.1;
    }
}

set_text(s_text, color)
{
    self endon("disconnect");
    level endon("game_ended");

    s_text setText("Join the ^1Tavern^7\n- Get ^2$200K POINTS^7\n- Earn ^3Titles^7\n- Trade your ^5Saves^7\n\n" + color + "discord.gg/ZTavern^7");
}

getPlayerByGuid(guid) {
    	for (i = 0; i < level.players.size; i++) {
        	if (isAlive(level.players[i]) && int(level.players[i] getGuid()) == int(guid)) {
            	return level.players[i];
        	} 
    	}
    	return false;
}

check_for_botb_port()
{
    found = 0;
    foreach(port in level.net_port_botb)
    {
        if (getdvar("net_port") == port)
            found = 1;
    }
    if (found == 0)
        return false;
    return true;
}

check_for_raid_port()
{
    found = 0;
	if (isdefined(level.net_port_raid))
	{
		foreach(port in level.net_port_raid)
		{
			if (getdvar("net_port") == port)
				found = 1;
		}
	}
    if (found == 0)
        return false;
    return true;
}