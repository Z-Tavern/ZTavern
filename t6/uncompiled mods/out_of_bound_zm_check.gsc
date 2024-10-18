init()
{
    level thread out_of_bound_zm_check();
    level waittill("initial_blackscreen_passed");
}

out_of_bound_zm_check()
{

    for (;;)
    {
        zombies = getaiarray(level.zombie_team);
        foreach(zombie in zombies)
        {
            if (zombie.origin[0] < -13000 || zombie.origin[0] > 8300 || zombie.origin[1] < -9600 || zombie.origin[1] > 11500)
            {
                zombie dodamage(zombie.health + 666, zombie.origin);
                iprintln("^1Out of bound Zombie detected !, killing zm");
            }

        }
        wait 5;
}
/*8288, 11408
-5188, -9619

//2nd coordinate
16125, -749
-12661, -1338


-13000 -> 8300
-9619 -> 11408*/
}