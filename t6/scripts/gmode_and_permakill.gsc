init()
{
    setDvar("weed", "0");
    level thread weed();
}

weed()
{
    kiels = 0;
    for(;;)
    {
        if (getdvar("weed") == "1")
        {
            foreach(player in level.players)
            {
                player SetMoveSpeedScale(2);
                zombies = getaiarray(level.zombie_team);
                for ( i = 0; i < zombies.size; i++ )
                {
                    zombies[i] DoDamage(zombies[i].maxhealth + 1, zombies[i].origin);
                }
                wait 0.1;
                kiels = 1;
            }
        }
        else if (kiels == 1)
        {
            foreach(player in level.players)
            {
                player SetMoveSpeedScale(1.1);
            }
        }
        wait 0.1;
    }
}