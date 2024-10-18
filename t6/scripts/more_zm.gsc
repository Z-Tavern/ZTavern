init()
{
    level thread more_zm();
}

more_zm()
{
    level waittill("start_of_round");

    for (;;)
    {
        if (level.round_number >= 30)
        {
            wait 10;
            level.zombie_ai_limit = 32;
            level.zombie_actor_limit = 40;
            setdvar("ln", "Maximum amount of zombies ^1increased !");
            return;
        }
        wait 1;
    }
}
