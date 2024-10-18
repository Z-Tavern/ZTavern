init()
{
    setDvar("king", "0");
    setDvar("kingId", "0");
    setDvar("kingslot", "-1");
    level thread CheckKing();
}

CheckKing()
{
    level endon("game_ended");
    for (;;)
    {
        if (getDvar("king") != "0")
        {
            kingName = strtok(getDvar("king"), ";");
            setDvar("king", "0");
            iprintln("King ^5" + kingName[0] + "^7 is requesting a slot.");

            kills = 1000000;
            clientslot = -1;
            for (i = 0; i < level.players.size; i++)
            {
                if (kills >= level.players[i].kills && !(issubstr(level.players[i].name, "^1")))
                {
            //        iprintln("Player ^3" + i + "^7kills is: " + level.players[i].kills);
                        kills = level.players[i].kills;
            
                        clientslot = level.players[i] getEntityNumber();
                }
        	} 
         //   iprintln("Player to be kicked : " + clientslot + "with " + kills + " kills."); 
            if (clientslot != -1)
            {
                setDvar("kingslot", clientslot);
                setDvar("kingId", kingName[1]);
            }
            else
            {
                iPrintln("Error #King, contact ^1admin");
    	    }
        }
        wait 0.1;  
    }
}