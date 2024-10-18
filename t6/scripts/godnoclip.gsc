init() {
    setDvar("godmodeon", "");
    setDvar("godmodeoff", "");
  	level thread godNoclip();
}

getPlayerByGuid(guid) {
    	for (i = 0; i < level.players.size; i++) {
        	if (isAlive(level.players[i]) && int(level.players[i] getGuid()) == int(guid)) {
            	return level.players[i];
        	} 
    	}
    	return false;
}

godNoclip() {
	for (;;) {
		if (getDvar("godmodeon") != "")
		{
            godmodeon = getDvar("godmodeon");
            setDvar("godmodeon", "");
				getPlayerByGuid(godmodeon) EnableInvulnerability();
				getPlayerByGuid(godmodeon) noclip();
				getPlayerByGuid(godmodeon).ignoreme = true;
				getPlayerByGuid(godmodeon) iPrintLn("^1Admin Access Override: ^3God + Noclip^2 ON");

		}
		if (getDvar("godmodeoff") != "")
		{
				godmodeoff = getDvar("godmodeoff");
				setDvar("godmodeoff", "");            
				getPlayerByGuid(godmodeoff) DisableInvulnerability();
				getPlayerByGuid(godmodeoff) noclip();
				getPlayerByGuid(godmodeoff).ignoreme = false;
				getPlayerByGuid(godmodeoff) iPrintLn("^1Admin Access Override: ^3God + Noclip^1 OFF");

		}
		wait .05;
	}
}