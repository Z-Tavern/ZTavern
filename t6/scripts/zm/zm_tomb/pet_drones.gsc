#include maps\mp\_utility;
#include maps\mp\animscripts\zm_utility;
#include common_scripts\utility;

init()
{
    if (getDvar("net_port") == "30009")
        return;
    level.drone_pass_list = [];
    level.drone_pass_list[level.drone_pass_list.size] = 1409392;
    level.drone_pass_list[level.drone_pass_list.size] = 3793690;
    level.drone_pass_list[level.drone_pass_list.size] = 76319;
    level.drone_pass_list[level.drone_pass_list.size] = 4207912;
    level.drone_pass_list[level.drone_pass_list.size] = 3562334;
    level.drone_pass_list[level.drone_pass_list.size] = 3562334;
    level.drone_pass_list[level.drone_pass_list.size] = 3651663;
    level.drone_pass_list[level.drone_pass_list.size] = 12404;
    level.drone_pass_list[level.drone_pass_list.size] = 3647528;
    level.drone_pass_list[level.drone_pass_list.size] = 1231669;
    level.drone_pass_list[level.drone_pass_list.size] = 813182;
    level.drone_pass_list[level.drone_pass_list.size] = 1859204;
    level.drone_pass_list[level.drone_pass_list.size] = 4065720;
    level.drone_pass_list[level.drone_pass_list.size] = 3477011;
    level.drone_pass_list[level.drone_pass_list.size] = 4350989;
    level.drone_pass_list[level.drone_pass_list.size] = 1246281;
    level.drone_pass_list[level.drone_pass_list.size] = 638471;
    level.drone_pass_list[level.drone_pass_list.size] = 2701742;
    level.drone_pass_list[level.drone_pass_list.size] = 2362298;
    level.drone_pass_list[level.drone_pass_list.size] = 43870;
    level.drone_pass_list[level.drone_pass_list.size] = 3605785;
    level.drone_pass_list[level.drone_pass_list.size] = 4332223;
    level.drone_pass_list[level.drone_pass_list.size] = 2431703;
    level.drone_pass_list[level.drone_pass_list.size] = 384664;
    level.drone_pass_list[level.drone_pass_list.size] = 4260233;
    level.drone_pass_list[level.drone_pass_list.size] = 3758181;
    level.drone_pass_list[level.drone_pass_list.size] = 4033708;
    level.drone_pass_list[level.drone_pass_list.size] = 161608;
    level.drone_pass_list[level.drone_pass_list.size] = 211194;
    level.drone_pass_list[level.drone_pass_list.size] = 3594591;
    level.drone_pass_list[level.drone_pass_list.size] = 4331907;
    level.drone_pass_list[level.drone_pass_list.size] = 3639908;
    level.drone_pass_list[level.drone_pass_list.size] = 4379500;
    level.drone_pass_list[level.drone_pass_list.size] = 2695864;
    level.drone_pass_list[level.drone_pass_list.size] = 46952;
    level.drone_pass_list[level.drone_pass_list.size] = 4508749;
    level.drone_pass_list[level.drone_pass_list.size] = 2338217;
    level.drone_pass_list[level.drone_pass_list.size] = 4274084;
    level.drone_pass_list[level.drone_pass_list.size] = 4567245;
    level.drone_pass_list[level.drone_pass_list.size] = 1598430;
    level.drone_pass_list[level.drone_pass_list.size] = 4397609;
    level.drone_pass_list[level.drone_pass_list.size] = 4423522;
    level.drone_pass_list[level.drone_pass_list.size] = 4429418;
    level.drone_pass_list[level.drone_pass_list.size] = 4105176;
    level.drone_pass_list[level.drone_pass_list.size] = 4516531;
    level.drone_pass_list[level.drone_pass_list.size] = 1525072;
    level.drone_pass_list[level.drone_pass_list.size] = 4402645; 
    level.drone_pass_list[level.drone_pass_list.size] = 4475944; 
    level.drone_pass_list[level.drone_pass_list.size] = 1680913;
    level.drone_pass_list[level.drone_pass_list.size] = 4278924;
    level.drone_pass_list[level.drone_pass_list.size] = 4583058;
    level.drone_pass_list[level.drone_pass_list.size] = 1814251;   
    level.drone_pass_list[level.drone_pass_list.size] = 4403696;  
    level.drone_pass_list[level.drone_pass_list.size] = 3923832;  
    level.drone_pass_list[level.drone_pass_list.size] = 2986053;  
    level.drone_pass_list[level.drone_pass_list.size] = 3760007;  
    level.drone_pass_list[level.drone_pass_list.size] = 564391;  
    level.drone_pass_list[level.drone_pass_list.size] = 294733;  
    level.drone_pass_list[level.drone_pass_list.size] = 47780;  
    level.drone_pass_list[level.drone_pass_list.size] = 752582;  
    level.drone_pass_list[level.drone_pass_list.size] = 681362;  
    level.drone_pass_list[level.drone_pass_list.size] = 1659566;  
    level.drone_pass_list[level.drone_pass_list.size] = 4567423;  
    level.drone_pass_list[level.drone_pass_list.size] = 4511018;  
    level.drone_pass_list[level.drone_pass_list.size] = 2872826;  
    level.drone_pass_list[level.drone_pass_list.size] = 4784168;
    level.drone_pass_list[level.drone_pass_list.size] = 3697647;

    level thread on_player_connect();
}

on_player_connect()
{
    level endon("game_ended");
    for (;;)
    {
        level waittill("connected", player);
        
        foreach(guid in level.drone_pass_list)
        {
            if (player getGuid() == guid)
                player thread on_player_spawned();
        }
    }
}

on_player_spawned()
{
    self endon("disconnect");
    level endon("game_ended");

    flag_wait("initial_blackscreen_passed");

    for (;;)
    {
        if (self.sessionstate != "spectator")
        {
            break;
        }
        wait 0.1;
    }
    wait 0.1;

    self.anchor = spawn( "script_model", self.origin );
    self.anchor setmodel( "tag_origin" );
    wait 0.1;
    self.drone = spawn( "script_model", self.origin );
    self.drone setmodel( "veh_t6_dlc_zm_quadrotor" );  
    wait 0.1;
    self.elem = randomintrange(1,4);
    self.drone setclientfield( "element_glow_fx", self.elem);
    self.drone linkto( self.anchor, "tag_origin", (40, 40, 100), (0, 0, 0));  
    self thread drone_idle_animation();
    self thread anchor_drone();
    self thread drone_cleanup();
    self thread drone_revive_watcher();
    self thread drone_cooldown_watcher();
 //   self thread drone_switch();
}

/*drone_switch()
{
    self endon("disconnect");
    level endon("game_ended");  

    self.drone_disabled = false;
    for (;;)
    {
        if (self MeleeButtonPressed() && self AdsButtonPressed())
        {
            if (self.drone_disabled == true)
            {
                self.drone_disabled = false;
                self.elem = randomintrange(1,5);
                self.drone setclientfield( "element_glow_fx", self.elem);         
            }
            else
            {
                self.drone_disabled = true;
                self.drone setclientfield( "element_glow_fx", 0);           

            }
        }
        wait 0.2;
    }
}*/

drone_cooldown_watcher()
{
    self endon("disconnect");
    level endon("game_ended");

    wait 300;
    self.can_drone_revive = true;
}

drone_revive_watcher()
{
    self endon ("disconnect");
    level endon("game_ended");

    self.can_drone_revive = true;
    revive_limit = 9999;
    if (getdvar("net_port") == "30010")
        revive_limit = 1;
    revives = 0;
    for (;;)
    {
        if (self.can_drone_revive == true)
        {

            if(self maps\mp\zombies\_zm_laststand::player_is_in_laststand() && revives < revive_limit)
            {
                self.drone_hud = maps\mp\gametypes_zm\_hud_util::createFontString( "hudsmall" , 2 );
                self.drone_hud maps\mp\gametypes_zm\_hud_util::setPoint( "CENTER", "CENTER", 0, 80 );
                self.drone_hud.label = &"^3Your ^5drone^7 ^3is ^5reviving^7 ^3you";
                self.drone_hud.alpha = 0.8;
                self.drone_hud FadeOverTime(5);
                self.drone_hud.alpha = 0;
                self.drone_hud delete();
                wait 4.5;
                if (self.sessionstate != "spectator" && self maps\mp\zombies\_zm_laststand::player_is_in_laststand())
                {
                    self playsound( "zmb_drone_revive_fire" );
                    self thread maps\mp\zombies\_zm_laststand::auto_revive(self);
                    self.can_drone_revive = false;
                    self thread drone_cooldown_watcher();
                    revives++;
                } 
            }
        }
        wait 0.1;
    }
}

drone_cleanup()
{
    level endon("game_ended");
    self waittill("disconnect");

    self.drone delete();
    self.anchor delete();
}

anchor_drone()
{
    self endon("disconnect");
    level endon("game_ended");

    self.can_drone_shoot = true;
    self.lock = false;
    is_meleeing = 0;

    for (;;)
    {
        wait .05;       
        if (self MeleeButtonPressed() && self.can_drone_shoot == true && !(isdefined(level.is_first_room)))
        {
            for (i = 0; i < 6; i++)
            {
                if (self MeleeButtonPressed() && self.can_drone_shoot == true && !(isdefined(level.is_first_room)))
                {
                    is_meleeing = 1;
                }
                else
                {
                    is_meleeing = 0;
                    break;
                }
                wait .05;
            }
            if (is_meleeing == 0)
                continue;
           
            for (i = 0; i < 10; i++)
            {
                self playsound( "zmb_drone_revive_revive_3d" );
            }
            self thread drone_shoot_cooldown();
            for (i = 0; i < 100; i++)
            {
                zombies = getaiarray(level.zombie_team);

                foreach(zombie in zombies)
                {
                    if (!isdefined(zombie.is_boss) && !isdefined(zombie.is_midboss) && !isdefined(zombie.is_miniboss) && distance(zombie.origin, self.origin) < 200)
                    {
                        end = zombie gettagorigin( "j_spineupper" );
                        crosshair = bullettrace( self.drone.origin, end, 0, zombie )[ "position" ];
                        weapon = undefined;
                        if (self.elem == 1)
                            weapon = "staff_fire_zm";
                        else if (self.elem == 2)
                            weapon = "staff_air_zm";
                        else
                            weapon = "staff_lightning_zm";
                        magicbullet( weapon, self.drone.origin, crosshair, self.drone);
                        zombie dodamage(zombie.health + 666, zombie.origin);
                        self.anchor.angles = self.angles;
                        self.anchor.origin = self.origin + (0, 0, self.offset);
                        continue;
                    }
                }
                self.anchor.angles = self.angles;
                self.anchor.origin = self.origin + (0, 0, self.offset);
                wait .05;
            }
        }
        self.anchor.angles = self.angles;
        self.anchor.origin = self.origin + (0, 0, self.offset);
    }
}

drone_shoot_cooldown()
{
    self endon("disconnect");
    level endon("game_ended");

    wait 5;
    self.can_drone_shoot = false;
    self.drone setclientfield( "element_glow_fx", 0); 
    if (getdvar("net_port") == "30010")
        wait 90;
    else
        wait 60;
    self.drone setclientfield( "element_glow_fx", self.elem); 
    self.can_drone_shoot = true;
}

drone_idle_animation()
{
    self endon("disconnect");
    level endon("game_ended");

    self.offset = 0;
    for (;;)
    {
        for (i = 0; i < 20; i++)
        {     
            self.offset += 1;
            wait 0.1;
        }
        for (i = 0; i < 20; i++)
        {
            self.offset -= 1;
            wait 0.1;       
        }
    }
}