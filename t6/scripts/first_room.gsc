#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_hud_message;
#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_zm_perks;

init()
{
    level.first_room_vote = [];
    setdvar("first_room", "");
    setdvar("is_first_room", "0");
    level thread first_room_watcher();
    level thread on_player_connect();
}

on_player_connect()
{
    for (;;)
    {
        level waittill("connected", player);
        player thread first_room_hud();
    }
}

first_room_hud()
{
    for (;;)
    {
        if (isdefined(level.is_first_room))
        {
            self.zombieTextR = maps\mp\gametypes_zm\_hud_util::createFontString( "hudsmall" , 1.5 );
            self.zombieTextR maps\mp\gametypes_zm\_hud_util::setPoint( "CENTER", "BOTTOM", 0, 0 );
            self.zombieTextR.label = &"";
            self.zombieTextR setText("^5First Room Challenge");
            self.zombieTextR.alpha = 0.7;
            return;
        }
        wait 0.1;
    }
}

first_room_watcher()
{
    level endon("game_ended");
    level waittill("initial_blackscreen_passed");

    for (;;)
    {
        has_voted = 0;
        if (getDvar("first_room") != "")
        {
            pGuid = getDvar("first_room");
            setDvar("first_room", "");
            foreach(guid in level.first_room_vote)
            {
                if (pGuid == guid)
                {
                    getPlayerByGuid(pGuid) iprintln("You've ^1already^7 voted for ^5First Room^7");
                    has_voted = 1;
                    break;
                }
            }
            if (has_voted == 0 || level.first_room_vote.size == level.players.size)
            {
                if (level.first_room_vote.size != level.players.size)
                    level.first_room_vote[level.first_room_vote.size] = pGuid;
                iprintln(getPlayerByGuid(pGuid).name + "^7 voted for ^5First Room^7 (^2.fr^7) (^2" + level.first_room_vote.size + "^7/^1" + level.players.size + "^7)");
                if (level.first_room_vote.size == level.players.size)
                {
                    if(isdefined(level.is_spawn_elevator_used))
                    {
                        iprintln("Cannot start ^5First Room challenge^7, spawn elevator used.");
                        return;
                    }
                    zombie_doors = getentarray( "zombie_door", "targetname" );
                    zombie_debris = getentarray( "zombie_debris", "targetname" );
                    foreach (door in zombie_doors)
                    {
                        if (( isdefined( door._door_open ) && door._door_open ))
                        {
                            iprintln("A door ^1has been opened^7, cannot start ^5First Room challenge^7.");
                            return;
                        }

                    }
                    foreach (debris in zombie_debris)
                    {
                        if (( isdefined( debris._door_open ) && debris._door_open ))
                        {
                            iprintln("A door ^1has been opened^7, cannot start ^5First Room challenge^7.");
                            return;
                        }

                    }
                    if (isdefined(level.is_game_loaded))
                    {
                        iprintln("Cannot start ^5First Room challenge^7 on a loaded save.");
                        return;
                    }


                    iprintln("^5First Room challenge^7 activated !");
                    setdvar("is_first_room", "1");
                    level.is_first_room = 1;
                    foreach ( debris in zombie_debris )
                    {
                        debris self_delete();
                    }
                    foreach ( door in zombie_doors )
                    {
                        door self_delete();
                    }
                    return;
                }
            }
        }

        wait 0.1;
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