#include scripts\AATs_Perks;
#include common_scripts\utility;

init()
{
//    if (getdvar("net_port") != "30003")
        return;
    level thread on_player_connect();
}

on_player_connect()
{
    for(;;)
    {
        level waittill("connected", player);
        player thread perkaholic();
    }
}

perkaholic()
{
    self endon("disconnect");
    flag_wait("initial_blackscreen_passed");

    perk_list_c = [];
    perk_list_c[perk_list_c.size] = "Downers_Delight";
    perk_list_c[perk_list_c.size] = "MULE";
    perk_list_c[perk_list_c.size] = "PHD_FLOPPER";
    perk_list_c[perk_list_c.size] = "ELECTRIC_CHERRY";
    perk_list_c[perk_list_c.size] = "WIDOWS_WINE";
    perk_list_c[perk_list_c.size] = "Time_Slip";
    perk_list_c[perk_list_c.size] = "Ammo_Regen";
    perk_list_c[perk_list_c.size] = "Burn_Heart";
    perk_list_c[perk_list_c.size] = "Dying_Wish";
    perk_list_c[perk_list_c.size] = "Momentum_Mocha";
    perk_list_c[perk_list_c.size] = "Bandolier_Bandit";

    perk_list = [];
    perk_list[perk_list.size] = "specialty_quickrevive";
    perk_list[perk_list.size] = "specialty_armorvest";
    perk_list[perk_list.size] = "specialty_fastreload";
    perk_list[perk_list.size] = "specialty_rof";
    perk_list[perk_list.size] = "specialty_longersprint";
    perk_list[perk_list.size] = "specialty_flakjacket";
    perk_list[perk_list.size] = "specialty_deadshot";
    perk_list[perk_list.size] = "specialty_additionalprimaryweapon";

    for(;;)
    {
        foreach(perk in perk_list)
        {
            if (!self HasPerk(perk))
            {
                self thread maps\mp\zombies\_zm_perks::give_perk(perk, 0);
                iprintln("draw2");
            }

            wait 0.3;
        }
        foreach(perk in perk_list_c)
        {
            if (!(self HascustomPerk(perk)))
            {
                self thread drawshader_and_shadermove( perk, 0, 0, "custom" );
                iprintln("draw");
            }
            wait 0.3;
        }
        wait 1;
    }
}