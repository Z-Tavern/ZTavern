#include maps\mp\_utility;
#include maps\mp\gametypes_zm\_hud_util;

init()
{
    setDvar("bold", "");
    setDvar("ln", "");
	level thread checkRestartTime();
    level thread AnnouncementWatcher();
}

AnnouncementWatcher()
{
	for (;;)
    {
		if (getDvar("bold") != "") {
			printBold = getDvar("bold");
			setDvar("bold", "");
			level thread TriplePrint(printBold);

		}
		if (getDvar("ln") != "") {
			printLn = getDvar("ln");
			setDvar("ln", "");
			level thread DoublePrint(printLn);
		}
        wait 0.5;
    } 
}

DoublePrint(printLn)
{
	level endon("game_ended");
	iprintLn(printLn);
	wait 5;
	iprintLn(printLn);
	return;
}

TriplePrint(printBold)
{
	level endon("game_ended");
	iprintLnBold(printBold);
	wait 2;
	iprintLnBold(printBold);
	wait 2;
	iprintLnBold(printBold);
	return;
}

checkRestartTime()
{
	restart_interval = 21600000; //(12h)
	restart_minus_10m = restart_interval - 600000;
	restart_minus_5m = restart_interval - 300000;
	restart_minus_2m = restart_interval - 120000;
	restart_minus_1m = restart_interval - 60000;


	level endon("game_ended");
	for (;;)
	{
		time = getTime();
		if (time >= restart_minus_10m)
		{
			printRestart("10 minutes.");
			restart_minus_10m = restart_interval + 10000; //disable
		}
		if (time >= restart_minus_5m)
		{
			printRestart("5 minutes.");
			restart_minus_5m = restart_interval + 10000; //disable
		}
		if (time >= restart_minus_2m)
		{
			printRestart("2 minutes.");
			restart_minus_2m = restart_interval + 10000; //disable
		}
		if (time >= restart_minus_1m)
		{
			printRestart("1 minute.");
			restart_minus_1m = restart_interval + 10000; //disable
		}
		wait 60;
	}
}

printRestart(msg)
{
	text = "Server ^3restarting^7 in ^1" + msg + " ^7Use ^2.d all^7 & ^2.save^7";
	TriplePrint(text);
	DoublePrint(text);
	wait 6;
	DoublePrint(text);
	TriplePrint(text);
}

getPlayerByGuid(guid) {
    	for (i = 0; i < level.players.size; i++) {
        	if (isAlive(level.players[i]) && int(level.players[i] getGuid()) == int(guid)) {
            	return level.players[i];
        	} 
    	}
    	return false;
}