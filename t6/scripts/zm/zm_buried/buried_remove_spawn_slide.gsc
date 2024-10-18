#include common_scripts\utility;

init()
{
    level thread check_first_room_height();
}

check_first_room_height()
{
    flag_wait("initial_blackscreen_passed");

    for (;;)
    {
        foreach (player in level.players)
        {
            if (isdefined(level.is_first_room) && player.sessionstate != "spectator" && player.origin[2] < 1250)
            {
                setdvar( "player_lastStandBleedoutTime", "0" );
                player DoDamage(999, player.origin);
                wait 0.1;
                setdvar( "player_lastStandBleedoutTime", "45" );
            }
        }
        wait 0.1;
    }
}