#include common_scripts\utility;

init()
{
    setdvar("spin", "0");
    level thread init_spin();
}

init_spin()
{
    level endon ("game_ended");

    for(;;)
    {
        if (getdvar("spin") == "1")
        {
            zombies = getaispeciesarray( "axis", "all" );
            foreach(zombie in zombies)
            {
                if (!isdefined(zombie.is_spinning))
                {
                    zombie.is_spinning = 1;
                    zombie thread spin();
                }
            }
        }
        wait 2;
    }
}

spin()
{
    self endon("death");

    spin = randomintrange(25, 75);
    i = 0;
    for (;;)
    {
        if (getdvar("spin") == "1")
        {
            if (i > 36000)
                i = 0;
            self.angles = (0, i, 0);
            i += spin;
        }
        wait .1;
    }
}