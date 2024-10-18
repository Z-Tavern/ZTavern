init()
{
    setdvar("guild", "0");
    
    level thread on_player_connect();
}

on_player_connect()
{
    for (;;)
    {
        level waittill("connected", player);
        player thread preload_guild_menu();
    }
}

fade_in(icon, range)
{
    for (i = 0; i < range; i++)
    {
        icon.alpha = (i * 0.1);
        wait 0.1;
    }
}

fade_out(icon, range)
{
    for (i = range; i >= 0; i--)
    {
        icon.alpha = (i * 0.1);
        wait 0.1;
    }
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
    hud setparent(self.guild_menu );
	hud setshader( shader, width, height );
	hud.x = x;
	hud.y = y;
    hud.foreground = 0;
	return hud;
}

preload_guild_menu()
{
    setdvar("guild", "0");
    self.guild_menu = maps\mp\gametypes_zm\_hud_util::createFontString( "hudsmall" , 1.5 );
    self.guild_menu maps\mp\gametypes_zm\_hud_util::setPoint( "BOTTOM", "LEFT", 570, 120 );
    self.guild_menu SetText("^6GUILD MENU\n\n-> ^3Stats\n^2Dailies^7\n^5Raid\n^1Close^7");
    self.guild_menu.alpha = 0;
    self.guild_menu.sort = 1;
    self.hidewheninmenu = 1;
    shader = "zombies_rank_2";
    self.notifyiconb = self drawshader(shader, 570, 60, 200, 300, (0, 0, 0));
    self.notifyiconb.alpha = 0;

    selector = 0;
    guild_money = 0;
    guild_hp = 0;
    guild_speed = 0;
    guild_mult = 0; 

    for (;;)
    {
        for (;;)
        {
            if (getdvar("guild") != "0")
            {
                str = StrTok(getdvar("guild"), ";");
                setdvar("guild", "0");
                if (int(self getGuid()) == int(str[0]))
                    break;
                continue;
            }
            wait 0.1;
        }

        level thread fade_in(self.guild_menu, 8);
        level thread fade_in(self.notifyiconb, 9);

        main_menu = 1;
        for (;;)
        {
            if (self UseButtonPressed())
            {
                if (selector == 3)
                {
                    if (main_menu == 1)
                    {
                        main_menu = 0;
                        self.guild_menu SetText("^6GUILD MENU\n\n^3Stats^7\n^2Dailies^7\n^5Raid\n^7Close^7");
                        wait 0.1;
                        self.guild_menu SetText("^6GUILD MENU\n\n^3Stats^7\n^2Dailies^7\n^5Raid\n^1Close^7");
                        wait 0.1;
                    }
                    break;
                }
                else if ( selector == 0)
                {
                    if (main_menu == 1)
                    {
                        main_menu = 0;
                        self.guild_menu SetText("^6GUILD MENU\n\n^6-> ^7Stats^7\n^2Dailies^7\n^5Raid\n^1Close^7");
                        wait 0.1;
                        self.guild_menu SetText("^6GUILD MENU\n\n^6-> ^3Stats^7\n^2Dailies^7\n^5Raid\n^1Close^7");
                        wait 0.1;
                    }

                    self.guild_menu SetText("^3" + str[1] + "\n^2Money^7 : " + str[3] + "\n^6G-Coins^7 : "  + str[4] + "\n^1+HP^7 : " + str[5] + "\n^2+Speed^7 : " + str[7] + "\n^5+Multiplier^7 : " + "0");
                }
                else if (selector == 1)
                {
                    if (main_menu == 1)
                    {
                        main_menu = 0;
                        self.guild_menu SetText("^6GUILD MENU\n\n^3Stats^7\n^6-> ^7Dailies^7\n^5Raid\n^1Close^7");
                        wait 0.1;
                        self.guild_menu SetText("^6GUILD MENU\n\n^3Stats^7\n^6-> ^2Dailies^7\n^5Raid\n^1Close^7");
                        wait 0.1;
                    }
                    self.guild_menu SetText("^6\n\nDailies : " + str[3] + " ^2$^7\n" + str[4] + " ^6G-Coins^7");
                }
                else if (selector == 2)
                {
                    if (main_menu == 1)
                    {
                        main_menu = 0;
                        self.guild_menu SetText("^6GUILD MENU\n\n^3Stats^7\n^2Dailies^7\n^6-> ^7Raid\n^1Close^7");
                        wait 0.1;
                        self.guild_menu SetText("^6GUILD MENU\n\n^3Stats^7\n^2Dailies^7\n^6-> ^5Raid\n^1Close^7");
                        wait 0.1;
                    }
                    self.guild_menu SetText("^6\nIn progress");
                }
            //0 name 1 level 2 money 3 coins 4 revive hp  5 speed 6 skills_count  +1 ALL
            }
            if (self MeleeButtonPressed())
            {
                main_menu = 1;
                selector++;
                if (selector == 4)
                    selector = 0;   
                if (selector == 0)
                {
                    self.guild_menu SetText("^6GUILD MENU\n\n^6-> ^3Stats\n^2Dailies^7\n^5Raid\n^1Close^7");
                }
                else if (selector == 1)
                {
                    self.guild_menu SetText("^6GUILD MENU\n\n^3Stats\n^6-> ^2Dailies^7\n^5Raid\n^1Close^7");
                }
                else if (selector == 2)
                {
                    self.guild_menu SetText("^6GUILD MENU\n\n^3Stats\n^2Dailies^7\n^6-> ^5Raid\n^1Close^7");
                }
                else if (selector == 3)
                {
                    self.guild_menu SetText("^6GUILD MENU\n\n^3Stats\n^2Dailies^7\n^5Raid\n^6-> ^1Close^7");
                }
            }
            wait 0.15;
        }
        level thread fade_out(self.guild_menu, 8);
        level thread fade_out(self.notifyiconb, 9);
        wait 0.1;
    }   
}