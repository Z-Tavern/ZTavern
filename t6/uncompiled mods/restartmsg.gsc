#include maps\mp\_utility;
#include maps\mp\gametypes_zm\_hud_util;

init() {
		level thread checkRestartTime();
}

checkRestartTime()
{
	restart_interval = 43200000; //(12h)
	restart_minus_1h = restart_interval - 3600000;
	restart_minus_30m = restart_interval - 5400000;
	restart_minus_10m = restart_interval - 600000;
	restart_minus_1m = restart_interval - 60000;

	level endon("game_ended");
	for (;;)
	{
		time = getTime();
		if (time >= restart_minus_1h)
		{
			printRestart("1 hour.");
			restart_minus_1h = restart_interval + 10000; //disable
		}
		if (time >= restart_minus_30m)
		{
			printRestart("30 minutes.");
			restart_minus_30m = restart_interval + 10000; //disable
		}
		if (time >= restart_minus_10m)
		{
			printRestart("10 minutes.");
			restart_minus_10m = restart_interval + 10000; //disable
		}
		if (time >= restart_minus_1h)
		{
			printRestart("1 minute.");
			restart_minus_1m = restart_interval + 10000; //disable
		}
		wait 60;
	}
}

printRestart(msg)
{
	for (i= 0; i < 5; i++)
	{
		iPrintLnbold("Server ^3restarting^7 in ^1" + msg + " ^7Use ^2.d all^7");
	}
}