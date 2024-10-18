#include maps\mp\zombies\_zm_utility;
#include maps\mp\_utility;
#include scripts\zm\zm_tomb\raid_boss;

setup_boss_kiels1()
{
    zombies = getaiarray(level.zombie_team);
    zombies[0].maxhealth = level.boss_hp;
    zombies[0].health = level.boss_hp;  
    zombies[0].meleedamage = 1900;
    zombies[0].custom_item_dmg = 600000000;
    wait 1;
    zombies = getaiarray(level.zombie_team);
    zombies[0] add_skin_kiels1();
    zombies[0].maxhealth = level.boss_hp;
    zombies[0].health = level.boss_hp;  
    zombies[0].meleedamage = 1900;
    zombies[0] set_zombie_run_cycle("super_sprint");
    level.boss = zombies[0]; 
    level.boss.name = "Templar";
    level.is_boss_spawned = 1;
    level thread boss_think_kiels1();
}

add_skin_kiels1()
{
    model_u = "t6_wpn_zmb_staff_tip_lightning_world";
    model_fx = level._effect["elec_glow"];
    model_u = "t6_wpn_zmb_staff_tip_air_world";
    model_fx = level._effect["air_glow"];  
    model_u = "t6_wpn_zmb_staff_tip_water_world";
    model_fx = level._effect["ice_glow"];   
    model_u = "t6_wpn_zmb_staff_tip_fire_world";
    model_fx = level._effect["fire_glow"];

    
    model_u2 = "t6_wpn_zmb_staff_tip_lightning_world";
    model_fx2 = level._effect["elec_glow"];
    model_u2 = "t6_wpn_zmb_staff_tip_air_world";
    model_fx2 = level._effect["air_glow"];  
    model_u2 = "t6_wpn_zmb_staff_tip_water_world";
    model_fx2 = level._effect["ice_glow"];   
   /* model_u2 = "t6_wpn_zmb_staff_tip_fire_world";
    model_fx2 = level._effect["fire_glow"];*/

    self.staff_u = spawn( "script_model", self.origin );
    self.staff_u linkto( self, "J_SpineLower", (0, -10, 15), (180, 90, 70));
    wait 0.1;
    self.staff_u setmodel( model_u ); 

    self.fx = spawn( "script_model", self.staff_u.origin );
    wait 0.1;
    self.fx setmodel( "tag_origin" );
    playfxontag( model_fx, self.staff_u, "tag_origin" );
    self.fx linkto( self, "J_SpineLower", self.staff_u.origin, (0, 0, 0));
 
    self.staff_u2 = spawn( "script_model", self.origin );
    self.staff_u2 linkto( self, "J_SpineLower", (0, -10, -15), (180, 90, 110));
    wait 0.1;
    self.staff_u2 setmodel( model_u2 ); 

    self.fx2 = spawn( "script_model", self.staff_u2.origin );
    wait 0.1;
    self.fx2 setmodel( "tag_origin" );
    playfxontag( model_fx2, self.staff_u2, "tag_origin" );
    self.fx2 linkto( self, "J_SpineLower", self.staff_u2.origin, (0, 0, 0));

}

boss_think_kiels1()
{
    level endon("game_ended");

    wait 3;
    level.boss_attacks_cooldown = 15;
    for (;;)
    {
        if (level.boss.health && level.boss.health < level.boss.health * 0.4)
            level.boss_attacks_cooldown = 12;
        if (level.boss.health && level.boss.health < level.boss.health * 0.2)
            level.boss_attacks_cooldown = 9;
        if (!isdefined(level.boss) || !isdefined(!level.boss.health) || level.boss.health < 1)
            return;
            level.boss.elem_fx setclientfield( "element_glow_fx", 3 );
            wait 3;
            level thread do_lightning_attack_kiels1();
            level.boss.elem_fx setclientfield( "element_glow_fx", 0 );
            wait level.boss_attacks_cooldown;
            level.boss.elem_fx setclientfield( "element_glow_fx", 1 );
            wait 3;
            level thread do_fire_attack_kiels1();
            level.boss.elem_fx setclientfield( "element_glow_fx", 0 );
            wait level.boss_attacks_cooldown;
            level.boss.elem_fx setclientfield( "element_glow_fx", 2 );
            wait 3;
            level thread do_wind_attack_kiels1();
            level.boss.elem_fx setclientfield( "element_glow_fx", 0 );

        /*    if (level.boss.health < level.boss.maxhealth * 0.33)
            {
                r = RandomInt(3);
                if (r == 0)
                {
                    level.boss thread miniboss_lightning_think(0);
                }
                else if (r == 1)
                {
                    level.boss thread miniboss_wind_think(0); 
                }
                else if (r == 2)
                {
                    level.boss thread miniboss_ice_think(0); 
                }
                else if (r == 3)
                {
                    level.boss thread miniboss_fire_think(0);
                }

            }*/
            wait level.boss_attacks_cooldown;
    }
}

do_fire_attack_kiels1()
{
    level endon("game_ended");
    
    lock = 0;
    for (h = 0; h < 2; h++)
    {
        x = randomintrange(0, 2);
        if (x == 0)
        {
            iprintln("^1HIGH Firewall^7");
            z = -20;
            iteration = 3;
        }
        else
        {
            iprintln("^1LOW Firewall^7");
            z = -70;
            iteration = 2;
        }
        for (j = 0; j < iteration; j++)
        {
            x = 75;
            z += 50;
            for (i = 0; i < 35; i++)
            {
                level thread spawn_firewall_kiels1(x, z);
                x += 75;
            }
            wait 0.1;
        }
        wait 1;
        level notify("firewall_setup");
        wait 5;
    }
}

spawn_firewall_kiels1(x_offset, z_offset)
{
    level endon("game_ended");

    fx_origin = ((8895 + x_offset), -9270, (-450 + z_offset));
    fx_destination_origin = ((8895 + x_offset), -6800, (-450 + z_offset));
    fx = spawn( "script_model", fx_origin);
    fx setmodel( "tag_origin" );
    wait 1;
    playfxontag( level._effect["fx_tomb_fire_lg"], fx, "tag_origin" );
    level waittill("firewall_setup");
    fx moveto( fx_destination_origin, level.firewall_duration );
    for (i = 0; i < (level.firewall_duration * 10); i++)
    {
        foreach(player in level.players)
        {
            stance = player GetStance();
            player_origin_offset = 0;
            if (stance == "prone")
                player_origin_offset = 30;
            if (distancesquared((fx.origin), (player.origin - (0, 0, player_origin_offset))) < 1700 && player.ignoreme != true)
                player thread dodamage_wrapper(1000);
        }
        wait 0.1;
    }
    fx delete();
    level notify("fire_attack_end");
}

do_lightning_attack_kiels1()
{
    level endon("game_ended");
    
    a_aoe = [];
    c = 0;
    delay = 1;
    for (j = 0; j < 4; j++)
    {
        offset = 100;
        for(i = 0; i < 20; i++)
        {
            a_aoe[0] = (offset, 0, 0);
            a_aoe[1] = (offset, offset, 0);   
            a_aoe[2] = (0, offset, 0); 
            a_aoe[3] = (offset, offset, 0);
            a_aoe[4] = (0, -(offset), 0); 
            a_aoe[5] = (-(offset), -(offset), 0); 
            a_aoe[6] = (offset, -(offset), 0);
            a_aoe[7] = (-(offset), 0, 0);   
            a_aoe[8] = (-(offset), offset, 0); 
            foreach(aoe in a_aoe)
            {
                level thread spawn_orb_kiels1(aoe, c);
                c++;
            }
            offset += 100;
            wait 0.1;
        }   
        wait delay;
        delay = delay / 2;
    }
}

spawn_orb_kiels1(target_origin, c)
{
    level endon("game_ended");



    fx_origin = level.boss.origin + target_origin;

        fx = spawn( "script_model", (fx_origin[0], fx_origin[1], -390));
        fx setmodel( "tag_origin" );
            wait 0.1;
        playfxontag( level._effect["elec_piano_glow"], fx, "tag_origin" );
    for (i = 0; i < 8; i++)
    {
        foreach(player in level.players)
        {
            if (distancesquared(fx_origin, player.origin) < 7000)
                player shellshock( "explosion", 0.4 );
        }
        wait 0.1;
    }
    fx delete();
    fx = spawn( "script_model", (fx_origin[0], fx_origin[1], -390));
    fx setmodel( "tag_origin" );
    wait 0.1;
    playfxontag( level._effect["ice_explode"], fx, "tag_origin" );  
    foreach(player in level.players)
    {
        if (distancesquared(fx_origin, player.origin) < 7000 && player.ignoreme != true)
            player thread dodamage_wrapper(1000);
    }
    wait 0.5; 
    fx delete();
}

do_wind_attack_kiels1()
{
    level endon("game_ended");

    level.is_boss_casting = 1;
    a_aoe = [];
    offset = 300;
    for (i = 0; i < 8; i++)
    {
        a_aoe[0] = (offset, 0, 0);
        a_aoe[1] = (0, offset, 0); 
        a_aoe[2] = (0, -(offset), 0); 
        a_aoe[3] = (-(offset), 0, 0); 
        foreach (aoe in a_aoe)     
            level thread spawn_tornado_kiels1(aoe); 
        offset += 300;
    }
    iprintln("^11");
    level thread rumble_players_kiels1(2, 1);
    wait 1.1;
    iprintln("^12");
    level thread rumble_players_kiels1(2, 1);    
    wait 1.1;   
    foreach(player in level.players)
    {
        player thread dodamage_wrapper(2000);
    }
    level thread rumble_players_kiels1(5, 2);
    fadetowhite = newhudelem();
    fadetowhite.x = 0;
    fadetowhite.y = 0;
    fadetowhite.alpha = 0;
    fadetowhite.horzalign = "fullscreen";
    fadetowhite.vertalign = "fullscreen";
    fadetowhite.foreground = 1;
    fadetowhite setshader( "white", 640, 480 );
    fadetowhite fadeovertime( 0.2 );
    fadetowhite.alpha = 0.3;
    wait 0.5;
    fadetowhite fadeovertime( 0.5 );
    fadetowhite.alpha = 0;
    wait 1.1;
    fadetowhite destroy();
    level.is_boss_casting = 0;
}

spawn_tornado_kiels1(target_origin)
{
    level endon("game_ended");

    fx_origin = level.boss.origin + target_origin;
    fx = spawn( "script_model", (fx_origin[0], fx_origin[1], -390));
    fx setmodel( "tag_origin" );
    wait 0.1;
    playfxontag( level._effect["whirlwind"], fx, "tag_origin" );
    wait 4.6;
    fx delete();
}

rumble_players_kiels1(strenght, time)
{
    strength = strength * 4;
    foreach(player in level.players)
        player setclientfieldtoplayer( "player_rumble_and_shake", strenght );
    wait(time);
    foreach(player in level.players)
        player setclientfieldtoplayer( "player_rumble_and_shake", 0 );
}