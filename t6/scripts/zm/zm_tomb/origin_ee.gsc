#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_sidequests;
#include maps\mp\zm_tomb_ee_main;
#include maps\mp\zm_tomb_utility;
#include maps\mp\zm_tomb_vo;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_hud;
#include maps\mp\zm_tomb_chamber;

init()
{
    level.start_time = GetTime();
    setDvar("EE_Completion", "0");
    setdvar("stepCompleted", "0");
    level thread EEFix();
    level thread CheckEECompletion();
    level thread onPlayerConnect();
}


onPlayerConnect()
{
	while( 1 )
	{
		level waittill( "connected", player );
		player thread onPlayerSpawned();
	}
}

onPlayerSpawned()
{
	self endon( "disconnect" );
	level endon( "game_ended" );
	self waittill( "spawned_player" );
    flag_wait("initial_blackscreen_passed");
    for (;;)
    {
        if (getDvar("stepCompleted") == "1")
        {
            for (i = 0; i < level.players.size; i++)
            {
                if (level.players[i].b_punch_upgraded != 1)
                {
                    level.players[i].b_punch_upgraded = 1;

                    if ( level.players[i] hasweapon( "staff_fire_upgraded_zm" ) )
                        level.players[i].str_punch_element = "fire";
                    else if ( level.players[i] hasweapon( "staff_air_upgraded_zm" ) )
                        level.players[i].str_punch_element = "air";
                    else if ( level.players[i] hasweapon( "staff_lightning_upgraded_zm" ) )
                        level.players[i].str_punch_element = "lightning";
                    else if ( level.players[i] hasweapon( "staff_water_upgraded_zm" ) )
                        level.players[i].str_punch_element = "ice";
                    else
                        level.players[i].str_punch_element = "upgraded";

                    level.players[i] thread maps\mp\zombies\_zm_weap_one_inch_punch::one_inch_punch_melee_attack();
                }
            }        
        }
        wait 3;
    }
}

EEFix()
{
    flag_wait("initial_blackscreen_passed");
    stepcompleted = 0;
    for (;;)
    {
        if (level._cur_stage_name == "step_6")
        {
            for (i = 0; i < level.players.size; i++)
            {
                if (level.players[i].b_punch_upgraded == 1)
                {
                    setDvar("stepCompleted", "1");
                }
            }
            if (getDvar("stepCompleted") == "1")
            {
                for (i = 0; i < level.players.size; i++)
                {
                    level.players[i].b_punch_upgraded = 1;

                    if ( level.players[i] hasweapon( "staff_fire_upgraded_zm" ) )
                        level.players[i].str_punch_element = "fire";
                    else if ( level.players[i] hasweapon( "staff_air_upgraded_zm" ) )
                        level.players[i].str_punch_element = "air";
                    else if ( level.players[i] hasweapon( "staff_lightning_upgraded_zm" ) )
                        level.players[i].str_punch_element = "lightning";
                    else if ( level.players[i] hasweapon( "staff_water_upgraded_zm" ) )
                        level.players[i].str_punch_element = "ice";
                    else
                        level.players[i].str_punch_element = "upgraded";

                    level.players[i] thread maps\mp\zombies\_zm_weap_one_inch_punch::one_inch_punch_melee_attack();
                }    
                flag_set( "ee_all_players_upgraded_punch" );        
            }

        }
        wait 5;
    }
}

CheckEECompletion()
{
    level endon( "game_ended" );    
	flag_wait("initial_blackscreen_passed");
    level waittill("tomb_sidequest_complete");
    setDvar("EE_Completion", "1");
    max_time = (30 * 60 * 1000);
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
    iprintln("^3EE completed^7 in : ^2" + ((GetTime() - level.start_time) / 1000 / 60) + "^7 minutes !");
    return;
}