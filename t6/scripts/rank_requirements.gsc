#include common_scripts\utility;

init()
{
    setdvar("melee_only", "0");
    setdvar("first_room_30", "0"); 
    setdvar("oneshot_50", "0");
    if (getdvar("net_port") == "30010" || getdvar("net_port") == "30011" || check_for_botb_port() == true)
        return;
    level thread melee_challenge_watcher();
    level thread first_room_challenge_watcher();
    level thread round_watcher();
}

first_room_challenge_watcher()
{
    for (;;)
    {
        if (isdefined(level.is_first_room) && level.is_first_room == 1)
        {
            if (level.round_number >= 30)
            {
                iprintln("First Room Round 30 ^3successful !");
                iprintln("First Room Round 30 ^3successful !");
                iprintln("First Room Round 30 ^3successful !");

                setdvar("first_room_30", "1"); 
                return;
            }
        }
        wait 1;
    }
}

melee_challenge_watcher()
{
    melee_round = 30;
    start_round = 0;
    total_hits_end_round = 0;

    for (;;)
    {
        if (level.round_number >= melee_round)
        {
           /* if (!isdefined(level.lock))
            {
                start_round = level.round_number;
                level.lock = 1;
            }*/
            level.players_melee_only = 0;
            level.players_hit_only = 0;
            if (level.round_number == melee_round)
            {
                wait 0.1;
                continue;
            }

            foreach(player in level.players)
            {
                player.total_hits_start_round = player maps\mp\gametypes_zm\_globallogic_score::getpersstat( "hits" );
            }
            if (isdefined(level.is_game_loaded) && level.is_game_loaded == 1 && !isdefined(level.lock2))
            {
                level waittill("start_of_round");
                level.lock2 = 1;
                continue;
            }
            level waittill("start_of_round");
            players = getplayers();

            foreach(player in level.players)
            {
                total_hits_end_round = player maps\mp\gametypes_zm\_globallogic_score::getpersstat( "hits" );

                if (total_hits_end_round - player.total_hits_start_round == 0)
                    level.players_melee_only++;
                
            }

            if (level.players_melee_only == level.players.size)
            {
                iprintln("Melee only round ^3successful !");
                iprintln("Melee only round ^3successful !");
                iprintln("Melee only round ^3successful !");

                setdvar("melee_only", "1");
            }
        }
        wait 1;
    }
}

round_watcher()
{
    flag_wait("initial_blackscreen_passed");
    foreach(player in level.players)
    {
        player.og = 1;
    }
    for (;;)
    {
        str = "";
        if (level.round_number >= 50 && (!isdefined(level.is_game_loaded) || level.is_game_loaded == 0))
        {
            foreach(index, player in level.players)
            {
                if (isdefined(player.og))
                {
                    str += player getguid();
                    if (index + 1 < level.players.size)
                        str += ";";
                }
                level.r50 = 1;
            }
            if (isdefined(level.r50))
                setdvar("oneshot_50", str);
            return;
        }
        wait 1;
    }
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