#include common_scripts\utility;

init()
{
    level thread on_player_connect();
}

on_player_connect()
{
    for(;;)
    {
        level waittill("connected", player);
        player thread afterlife_ignoreme();
    }
}

afterlife_ignoreme()
{
    flag_wait("initial_blackscreen_passed");

    for (;;)
    {
        if (self.afterlife)
            self.ignoreme = 1;
        else
            self.ignoreme = 0;
        wait 0.1;
    }
}