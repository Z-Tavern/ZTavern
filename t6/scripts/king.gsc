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
    level waittill("initial_blackscreen_passed");
    for (;;)
    {
        if (getDvar("king") != "0")
        {
            kingName = strtok(getDvar("king"), ";");
            setDvar("king", "0");
            iprintln("King ^5" + kingName[0] + "^7 is requesting a slot.");

            kills = 1000000;
            clientslot = -1;
            clientguid = 0;
            vip4_count = 0;
            is_staff = 0;
            foreach(player in level.players)
            {
                if (issubstr(player.name, "^2[VIP") || issubstr(player.name, "^2VIP"))
                    vip4_count++;
            }

            for (i = 0; i < level.players.size; i++)
            {
                foreach (staff_guid in level.staff_list_a)
                {
                    if (int(level.players[i] getguid()) == int(staff_guid))
                    {
                        is_staff = 1;
                        break; // immune staff
                    }
                }
                if (is_staff == 1)
                    continue;
                if (kingName[2] == "4")
                {
                    if (vip4_count != level.players.size && (issubstr(level.players[i].name, "^2[VIP") || issubstr(level.players[i].name, "^2VIP"))) //if its not a vip4 full lobby, immune the vip 4
                    {
                        wait 0.1;
                        continue;
                    }
                    if (kills >= level.players[i].kills)
                    {
                        kills = level.players[i].kills;
                        clientguid = level.players[i] getGuid();
                    }
                }
                else if (kingName[2] == "3" && !issubstr(level.players[i].name, "^2[VIP") && !issubstr(level.players[i].name, "^2VIP"))
                {
                    if (kills >= level.players[i].kills)
                    {
                        kills = level.players[i].kills;
                        clientguid = level.players[i] getGuid();
                    }
                }
                else if (kingName[2] == "2" && !issubstr(level.players[i].name, "^2[VIP") && !issubstr(level.players[i].name, "^2VIP")
                && !issubstr(level.players[i].name, "^1[VIP") && !issubstr(level.players[i].name, "^1VIP"))
                {
                    if (kills >= level.players[i].kills)
                    {
                        kills = level.players[i].kills;
                        clientguid = level.players[i] getGuid();
                    }
                }
                else if (kingName[2] == "1"  && !issubstr(level.players[i].name, "^2[VIP") && !issubstr(level.players[i].name, "^2VIP")
                && !issubstr(level.players[i].name, "^1[VIP") && !issubstr(level.players[i].name, "^1VIP")
                && !issubstr(level.players[i].name, "^6[VIP") && !issubstr(level.players[i].name, "^6VIP"))
                {
                    if (kills >= level.players[i].kills)
                    {
                        kills = level.players[i].kills;
                        clientguid = level.players[i] getGuid();
                    }
                }
            }
            if (clientguid != 0)
            {
                setDvar("kingslot", clientguid);
                setDvar("kingId", kingName[1]);
            }
            else
            {
                iprintln("King request ^1denied^7, king level too low");
                setDvar("kingslot", "12");
                setDvar("kingId", kingName[1]);
            }
        }
        wait 0.1;
    }
}