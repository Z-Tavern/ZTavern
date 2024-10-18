#include maps\mp\_utility;
#include common_scripts\utility;

init()
{
    setDvar("EE_Completion", "0");
    level thread onEECompletion();

    flag_wait("initial_blackscreen_passed");
    level.start_time = GetTime();
}

onEECompletion()
{
    flag_wait("initial_blackscreen_passed");
    if (level.script == "zm_tomb")
    {
        level endon( "game_ended" );    
        level waittill("tomb_sidequest_complete");
        setDvar("EE_Completion", "1");
        max_time = (35 * 60 * 1000);
        if (GetTime() - level.start_time < max_time)
        {
            str = "";
            foreach(index, player in level.players)
            {
                str += player getguid();
                if (index + 1 < level.players.size)
                    str += ";";
            }
            setdvar("ee_speedrun", str);
        }
        txt = "";
        index = 0;
        foreach(player in level.players)
        {
            txt += player getguid() + "-" + player.kills;
            index++;
            if (index < level.players.size)
                txt += ";";
        }
        setdvar("ee_speedrun_quest_tomb", ((GetTime() - level.start_time) / 1000 / 60) + ";" + txt);
        print_time();
        return;
    }
    else if (level.script == "zm_prison")
    {
        level waittill("start_of_round");
        for (;;)
        {
            if (isdefined(level.final_flight_activated) && level.final_flight_activated == 1 && getDvar( "g_gametype" ) != "zgrief")
            {
                setDvar("EE_Completion", "3");
                txt = "";
                index = 0;
                foreach(player in level.players)
                {
                    txt += player getguid() + "-" + player.kills;
                    index++;
                    if (index < level.players.size)
                        txt += ";";
                }
                setdvar("ee_speedrun_quest_prison", ((GetTime() - level.start_time) / 1000 / 60) + ";" + txt);
                print_time();
                return;
            }
            wait 0.5;
        }
    }
    else if (level.script == "zm_transit")
    {
        level waittill( "transit_sidequest_achieved" );
        setDvar("EE_Completion", "1");
        txt = "";
        index = 0;
        foreach(player in level.players)
        {
            txt += player getguid() + "-" + player.kills;
            index++;
            if (index < level.players.size)
                txt += ";";
        }
        setdvar("ee_speedrun_quest_transit", ((GetTime() - level.start_time) / 1000 / 60) + ";" + txt);
        print_time();
        return;
    }
    else if (level.script == "zm_buried")
    {
        level endon( "game_ended" );    
        level waittill_any( "sq_richtofen_complete", "sq_maxis_complete" ); 
        setDvar("EE_Completion", "4");
        txt = "";
        index = 0;
        foreach(player in level.players)
        {
            txt += player getguid() + "-" + player.kills;
            index++;
            if (index < level.players.size)
                txt += ";";
        }
        setdvar("ee_speedrun_quest_buried", ((GetTime() - level.start_time) / 1000 / 60) + ";" + txt);
        print_time();
        return;
    }
    else if (level.script == "zm_highrise")
    {
        level endon( "game_ended" );    
        level waittill( "highrise_sidequest_achieved" );
        setDvar("EE_Completion", "2");
        txt = "";
        index = 0;
        foreach(player in level.players)
        {
            txt += player getguid() + "-" + player.kills;
            index++;
            if (index < level.players.size)
                txt += ";";
        }
        setdvar("ee_speedrun_quest_highrise", ((GetTime() - level.start_time) / 1000 / 60) + ";" + txt);
        print_time();
        return;
    }
}

print_time()
{
    iprintln("^3EE completed^7 in : ^2" + ((GetTime() - level.start_time) / 1000 / 60) + "^7 minutes !");
    iprintln("^3EE completed^7 in : ^2" + ((GetTime() - level.start_time) / 1000 / 60) + "^7 minutes !");
    iprintln("^3EE completed^7 in : ^2" + ((GetTime() - level.start_time) / 1000 / 60) + "^7 minutes !");
    wait 5;
    iprintln("^3EE completed^7 in : ^2" + ((GetTime() - level.start_time) / 1000 / 60) + "^7 minutes !");
    iprintln("^3EE completed^7 in : ^2" + ((GetTime() - level.start_time) / 1000 / 60) + "^7 minutes !");
    iprintln("^3EE completed^7 in : ^2" + ((GetTime() - level.start_time) / 1000 / 60) + "^7 minutes !");   
}