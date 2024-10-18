
/* 
 * Copyright 2023 K Mod. All rights reserved.
 *
 * This code, including any associated documentation or files, is the
 * intellectual property of K Mod. You may not
 * use, modify, reproduce, distribute, or disclose this code without
 * explicit written permission from the owner.
 *
 * Unauthorized use, reproduction, or distribution of this code or any
 * portion thereof is strictly prohibited and may result in severe legal
 * consequences. For licensing inquiries or permission requests, please
 * contact eizekiels@gmail.com.
 */

/* -------- STARTER GUIDE ----------

    --------- HOW TO MAKE THE BOSS LOOKS COOL, Spawn an object to a specific location --------- 

    model = "t6_wpn_zmb_staff_tip_lightning_world";

    self.fx = spawn( "script_model", self.origin ); // create objet
    self.fx linkto( self, "J_SpineLower", (0, -10, 15), (180, 90, 70)); // link to the boss (anchor)
    wait 0.1;
    self.fx setmodel( model );  // apply the model

    --------- HOW TO MAKE BOSS ATTACK SPECIAL EFFECTS, Spawn a FX on an fx ---------------------

    fx_origin = level.boss.origin; //set origin of effect 
    fx = spawn( "script_model", (fx_origin[0], fx_origin[1], -390)); // spawn object
    fx setmodel( "tag_origin" ); // set three D default object
    wait 0.1;
    playfxontag( level._effect["whirlwind"], fx, "tag_origin" ); // <- only thing to change is the level._effect, go search it in the stock script (ctrl + F)

    --------- HOW TO ADD SOUND TO ATTACKS -------------------------------------------------------

    self playsound( "evt_medal_acquired" ); // search playsound in stock script (CTRL + F)

    --------- HOW TO MAKE BOSS SHINY ------------------------------------------------------------

       level.boss.fx_element_glow = playfxontag( localclientnum, level._effect["fire_glow"], level.boss, "tag_origin" );
    else if ( newval == 2 )
        level.boss.fx_element_glow = playfxontag( localclientnum, level._effect["air_glow"], level.boss, "tag_origin" );
    else if ( newval == 3 )
        level.boss.fx_element_glow = playfxontag( localclientnum, level._effect["elec_glow"], level.boss, "tag_origin" );
    else if ( newval == 4 )
        level.boss.fx_element_glow = playfxontag( localclientnum, level._effect["ice_glow"], level.boss, "tag_origin" );


    --------- USEFUL COORDINATES -----------------------------------------------------------------
    level.fire_spawn_origin = (9463, -8560, -398);
    level.ice_spawn_origin = (11211, -7058.7, -345.875);
    level.wind_spawn_origin = (11253, -8655, -408);
    level.lightning_spawn_origin = (9623.4, -7016.2, -345.875);
    level.pap_spawn_origin = (10760.4, -7980.47, -463.875);
    level.center_spawn_origin = (10314.5, -7889.91, -411.875);
    level.fire_puzzle_origin = (9891.5, -8764, -452);
    
*/

#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

init()
{
    level thread on_player_connect(); //Start the player code


  //  if (getdvar("net_port") != "27050") //your default server port is close to this number, find it. Now only this server will have this code active (prevents loading ressources from other map & crashing)
   //     return

    level.fire_spawn_origin = (9463, -8560, -398); //set global variables for important locations
    level.ice_spawn_origin = (11211, -7058.7, -345.875);
    level.wind_spawn_origin = (11253, -8655, -408);
    level.lightning_spawn_origin = (9623.4, -7016.2, -345.875);
    level.pap_spawn_origin = (10760.4, -7980.47, -463.875);
    level.center_spawn_origin = (10314.5, -7889.91, -411.875);
    level.fire_puzzle_origin = (9891.5, -8764, -452);
    level.player_out_of_playable_area_monitor = false; //disable instant death when entering out of bound area
    flag_wait("initial_blackscreen_passed"); // wait for blackscreen to pass 
    flag_set( "activate_zone_chamber" ); //activate Agartha zm spawn

    level thread init_kill_zombie(); //Start the global code
}

on_player_connect()
{
    level endon("game_ended"); // just add it all the time

    for(;;)
    {
        level waittill("connected", player); //wait until a player connects 
        player thread god_player(); // give every players buff
        id = player getEntityNumber(); //find player id (0-8)
        player thread TpToCenter(id); //tp all players depending on their id
    }
}

TpToCenter(id)
{
    self endon("disconnect");

    if (id == 0)
    {
        origin = (10463.8, -8036.59, -419.875);
        angle =  (0, 135, 0);
        self setOrigin(origin); //tp the player
        self SetPlayerAngles(angle); //change player angles
    }
    else if (id == 1)
    {
        origin = (10216, -7776.28, -419.875);
        angle = (0, 315, 0);
        self setOrigin(origin);
        self SetPlayerAngles(angle);
    }
    else if (id == 2)
    {
        origin = (10212.8, -8044.76, -419.875);
        angle = (0, 45, 0);
        self setOrigin(origin);
        self SetPlayerAngles(angle);
    }
    else if (id == 3)
    {
        origin = (10472.6, -7778.6, -419.875);
        angle = (0, 225, 0);
        self setOrigin(origin);
        self SetPlayerAngles(angle);
    }
    else if (id == 4)
    {
        origin = (10672.6, -7778.6, -419.875);
        angle = (0, 225, 0);
        self setOrigin(origin);
        self SetPlayerAngles(angle);
    }
    else if (id == 5)
    {
        origin = (10272.6, -7778.6, -419.875);
        angle = (0, 225, 0);
        self setOrigin(origin);
        self SetPlayerAngles(angle);
    }
}

god_player()
{
    player_hp = 100000; //increase player hp

    self.maxhealth = player_hp;
    self.health = self.maxhealth;
    self SetMoveSpeedScale(1.5); //increase player speed
}

init_kill_zombie()
{
    flag_wait("initial_blackscreen_passed");

    wait 20;
    iprintln("^2Loading ^1Raid Boss"); //print to everyone
    zombie_list = GetAIArray(level.zombie_team); // get the zombie array
    for(i = 0; i < zombie_list.size; i++) // find all zombies in the zombie array
    {
        if (i != 0) //kill all zm except the first one
        {
            zombie_list[i] DoDamage(zombie_list[i] + 1, zombie_list[i].origin);
        }
    }

    //transform the remaining zm into the raid boss
    zombie_list[0] set_zombie_run_cycle("super_sprint");
    zombie_list[0].maxhealth = 10000;
    zombie_list[0].health = zombie_list[0].maxhealth;
    zombie_list[0].meleedamage = 1;

    level.boss = zombie_list[0]; //set the raid boss as a global variable accessible from all code (no need to pass it as parameter)

    iprintln("^1Raid Boss Loaded !");
    level.boss thread boss_think(); //call the raid boss attacks loop
}

boss_think() // After boss spawned, start the attacks rotation
{
    self endon("death"); //on boss death, stop the script

    cooldown = 15; //set cooldown here so u can easily reuse

    wait 6; // let the boss time to get to the middle

    for(;;) //start the attack rotation loop
    {
        level.boss thread attack_1();
        wait cooldown;
        level.boss thread attack_2();
        wait cooldown;
        level.boss thread attack_3();
        wait cooldown;
        level.boss thread attack_4();
        wait 0.1;
    }
}
 
attack_1()
{
    iprintln("Attack ^31^7 start !");
    cooldown = 0.5;
  
    //add fx here to show that the attack has started
  
    for (i = 0; i < 10 ; i++)
    {
        foreach(player in level.players) //define player, run this code for all players
        {
           if (distance(level.boss.origin, player.origin) < 1500) //if close to boss
              player dodamage(100, player.origin); // deal damage to player (you gotta run away !)
        }
        wait cooldown;
    }
    iprintln("Attack ^31^7 end !");
  
    //delete the fx like this -> fx delete();
}

attack_2()
{
    //Fill with your custom attacks !
}

attack_3()
{
    //Fill with your custom attacks !
}

attack_4()
{
    //Fill with your custom attacks !
}
