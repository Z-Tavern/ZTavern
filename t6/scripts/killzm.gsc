#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\gametypes_zm\_hud;
#include maps\mp\zombies\_zm;

init()
{
	setDvar("killzm", "");
	setDvar("killzmadmin", "");
	setDvar("customround", "0");
	setDvar("load", "0");
	setDvar("votecount", "0");
	setDvar("vote", "0");
	setDvar("restart", "0");
    setDvar("saveId", "0");
    setDvar("saveSlot", "-1");
	setDvar("isGameLoaded", "0");
	level thread killZm();
	level thread setZmCount();
	level thread isGameLoaded();
//	level thread setRound();

}

isGameLoaded()
{
	if (level.script == "zm_prison")
		level waittill("start_of_round");
	else
		flag_wait("initial_blackscreen_passed");
	wait 11;	
	setDvar("isGameLoaded", "1");
}
/*setRound()
{
	for(;;)
	{
		if (getDvar("customround") != "0")
		{
			customround = int(getDvar("customround"));
			level.round_number = customround;
			if(customround == level.round_number)
				setDvar("customround", "0");
		}
		wait 3;
	}
}*/

setZmCount()
{
	for (;;)
    {
        if (getDvar("isBus") == "1")
        {
            return false;
        }
        else if (getDvar("isBus") == "0")
        {
            break;
        }
        wait 0.5;
    }
	saveRound = 1;
	for (;;)
	{
		if (level.round_number > 29 && level.round_number != saveRound && level.script != "zm_highrise")
		{
			saveRound = level.round_number;
			setDvar("currentround", saveRound);
			wait 16;
			intval = int((0.0896 * (saveRound * saveRound)) + (0.0115 * saveRound) + 23.518); //ROUND(0.1777 * ®^2 + 0.0249 * R + 23.468, 0)
			level.zombie_total = intval;
			iPrintLn("Entering ^1High Rounds^7: Zombie amount set to 1 player.");
		}
		if (level.zombie_total < 0)
			level.zombie_total = 0;
		if (getDvar("load") == "1")
		{
			setDvar("load", "0");
			level.is_game_loaded = 1;
			level.round_number = int(getDvar("customround")) - 1;
			saveRound = level.round_number;
			setDvar("killzmadmin", "1");
			wait 1;
			level.zombie_total = 1;
		}
		else
		{
			round = getDvar("votecount");
			if (int(round) > 0)
			{
				level thread Announcement(round);
				setDvar("votecount", "0");

			}
		}
		wait 1;
	}
}

Announcement(round)
{
	level endon("game_ended");
	for (i = 0; i < 3; i++)
	{
		iPrintlnbold("^2Vote ^3Request^7 : Load ^5Round " + round + "^7 Game ? ^3Type ^2.yes^7");
		wait 3;
	}
}
killZm()
{
	if (check_for_titb_port() == true)
		return;
	is_staff = 0;
	for(;;)
	{
		if (getdvar("killzmadmin") != "")
		{
			setDvar("killzmadmin", "");
			zombies = getaiarray( level.zombie_team );
			if (zombies && zombies.size > 0)
			{
				for ( i = 0; i < zombies.size; i++ )
				{
					zombies[i] dodamage( zombies[i].health + 666, zombies[i].origin );
				}
				iPrintLn("^1Admin Access Code^7: Killing all ^1spawned zombies^7.");
				continue;
			}
		}
		if(getDvar("killzm") != "")
		{
			content = int(getDvar("killzm"));
			setDvar("killzm", "");

			if (level.script == "zm_transit" || level.script == "zm_buried")
			{
				player = getPlayerByGuid(content);
				if (player.sessionstate == "spectator")
				{
					player iprintln("Cannot use ^1.kill^7 when spectating.");
					return;
				}
				zombies = getaiarray( level.zombie_team );
				if (zombies && zombies.size > 0)
				{
					if(zombies.size <= 5)
					{
						zombies[0] dodamage( zombies[0].health + 666, zombies[0].origin );
						iPrintLn("^1Killing^7 last zombie.");
					}
					else
					{
						iPrintLn("Can only use ^3.kill command^7 when ^11/2 zombie/witch is left.");
					}
				}
			}
		}
		wait 0.1;
	}
}

getPlayerByGuid(guid) {
    	for (i = 0; i < level.players.size; i++) {
        	if (isAlive(level.players[i]) && int(level.players[i] getGuid()) == int(guid)) {
            	return level.players[i];
        	} 
    	}
    	return false;
}

check_for_titb_port()
{
    found = 0;
    foreach(port in level.net_port_titb)
    {
        if (getdvar("net_port") == port)
            found = 1;
    }
    if (found == 0)
        return false;
    return true;
}