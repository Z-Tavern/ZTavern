#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\gametypes_zm\_hud;
#include maps\mp\zombies\_zm;

init() {
	setDvar("killzm", "0");
	setDvar("killzmadmin", "0");
	setDvar("customround", "0");
	setDvar("load", "0");
	setDvar("votecount", "0");
	setDvar("vote", "0");
	level thread killZm();
		level thread setZmCount();
//	level thread setRound();

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
	saveRound = 1;
	for (;;)
	{
		if (level.round_number > 29 && level.round_number != saveRound && level.script != "zm_highrise")
		{
			saveRound = level.round_number;
			setDvar("currentround", saveRound);
			wait 16;
			intval = int((0.0896 * (saveRound * saveRound)) + (0.0115 * saveRound) + 23.518);
			level.zombie_total = intval;
			iPrintLn("Entering ^1High Rounds^7: Zombie amount set to 1 player.");
		}
		if (level.zombie_total < 0)
			level.zombie_total = 0;
		if (getDvar("load") == "1")
		{
			setDvar("load", "0");
			flag_wait( "initial_blackscreen_passed" );
			level.round_number = int(getDvar("customround")) - 1;
			saveRound = level.round_number;
			wait 8;
			setDvar("killzmadmin", "1");
			wait 1;
			level.zombie_total = 1;
		}
		round = getDvar("votecount");
		if (int(round) > 0)
		{
			level thread Announcement(round);
			setDvar("votecount", "0");

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
	for(;;)
	{
		if (getDvar("killzmadmin") == "1")
		{
			zombies = getaiarray( level.zombie_team );
			if (zombies && zombies.size > 0)
			{
				for ( i = 0; i < zombies.size; i++ )
				{
					zombies[i] dodamage( zombies[i].health + 666, zombies[i].origin );
				}
				iPrintLn("^1Admin Access Code^7: Killing all ^1spawned zombies^7.");
			}
			setDvar("killzmadmin", "0");
		}
		else if (level.script == "zm_transit" || level.script == "zm_buried")
		{
			if(getDvar("killzm") == "1")
			{
				zombies = getaiarray( level.zombie_team );
				if (zombies && zombies.size > 0)
				{
					if(zombies.size == 1 || zombies.size == 2 )
					{
						zombies[0] dodamage( zombies[0].health + 666, zombies[0].origin );
						iPrintLn("^1Killing^7 last zombie.");
					}
					else
					{
						iPrintLn("Can only use ^3.kill command^7 when ^11/2 zombie/witch is left.");
					}
				}
				setDvar("killzm", "0");
			}
		}
		wait 1;
	}
}