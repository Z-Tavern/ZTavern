init()
{
    setDvar("bold", "");
    setDvar("ln", "");
    level thread AnnouncementWatcher();
}

AnnouncementWatcher()
{
	for (;;)
    {
		if (getDvar("bold") != "") {
			printBold = getDvar("bold");
			setDvar("bold", "");
			iprintLnBold(printBold);
            wait 2;
            iprintLnBold(printBold);
            wait 2;
            iprintLnBold(printBold);
		}
		if (getDvar("ln") != "") {
			printLn = getDvar("ln");
			setDvar("ln", "");
			iprintLn(printLn);
		}
        wait 0.5;
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