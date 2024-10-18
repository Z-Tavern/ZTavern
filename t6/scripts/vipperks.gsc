#include maps\mp\_visionset_mgr;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\_demo;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_pers_upgrades_functions;
#include maps\mp\zombies\_zm_power;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zombies\_zm_chugabud;
#include maps\mp\zombies\_zm_afterlife;
#include maps\mp\zombies\_zm_tombstone;
#include maps\mp\zombies\_zm_perk_vulture;
#include maps\mp\zombies\_zm_weap_time_bomb;

#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_gameobjects;
#include maps\mp\zombies\_zm_buildables;


#include maps\mp\zombies\_zm_perks;
#include maps\mp\zombies\_zm_clone;
#include maps\mp\zombies\_zm_weap_cymbal_monkey;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\zombies\_zm;


init()
{
    level.premium_pass_guid_list = [];
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 3968479;
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 3987957;
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 1678458;
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 1231669;
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 2987958;
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 1525072;
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 45923;
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 3208375;
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 564391;
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 3182080;
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 46876; 
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 4065720; 
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 4084332;
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 2986053;
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 1672650;
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 3647528;
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 12404;
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 69226;
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 2495128;   
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 2431703; 
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 3896525; 
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 507816;
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 3380572;  
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 3923832;   
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 207889; 
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 3069177;  
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 384664;  
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 3738486; 
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 711546; 
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 2322919;
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 721994;  
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 544392;  
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 3793690;  
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 2119046;  
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 3718336;  
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 1409392;  
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 1325372;  
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 156188;   
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 813182;   
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 4207912;  
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 4034748;  
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 3651663;  
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 4274084; 
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 962346; 
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 4260233; 
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 4332223; 
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 185225; 
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 4209248; 
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 4152074; 
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 3562334; 
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 3749436; 
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 52224; 
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 3650683; 
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 1859204; 
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 3477011; 
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 4350989; 
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 1246281; 
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 638471; 
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 2701742; 
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 3658; 
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 4353146; 
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 2178072; 
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 211194; 
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 3758181; 
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 4033708; 
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 161608; 
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 93901565; 
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 3901565;
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 4331907;
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 3639908;
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 3440389;
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 2362298;
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 4010056;
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 1598430;
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 4402645; 
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 4397760; 
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 2753396; 
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 2329450;
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 2751401;
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 4459498;
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 3415461;   
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 4397609;
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 4278924;
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 4567245;
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 4516531;
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 1598430;
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 4423522;
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 4475944;
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 294733;
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 2395428;
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 1680913;
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 4429418;
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 2012925;
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 4105176;
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 3531497;
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 4438351;  
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 4583058;  
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 15686;  
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 4629606;  
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 3594591;  
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 4642679;  
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 250243; 
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 1814251;        
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 1431061;  
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 4403696;  
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 1937929;  
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 2953060;  
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 4295591;  
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 752582;  
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 3760007;  
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 1713786;  
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 3846726;  
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 4727280;  
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 3631325;  
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 3530081;  
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 4509605;  
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 4767238;  
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 390860;  
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 3361195;  
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 1027466;  
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 1789515;  
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 3069811;  
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 4838265;
    level.premium_pass_guid_list[level.premium_pass_guid_list.size] = 831223;

    level.premium_pass_guid_list2 = [];
    level.premium_pass_guid_list2[level.premium_pass_guid_list2.size] = 47780;
    level.premium_pass_guid_list2[level.premium_pass_guid_list2.size] = 4289343; 
    level.premium_pass_guid_list2[level.premium_pass_guid_list2.size] = 4245614;
    level.premium_pass_guid_list2[level.premium_pass_guid_list2.size] = 55406;
    level.premium_pass_guid_list2[level.premium_pass_guid_list2.size] = 2157784;
    level.premium_pass_guid_list2[level.premium_pass_guid_list2.size] = 2066354;
    level.premium_pass_guid_list2[level.premium_pass_guid_list2.size] = 4296689;
    level.premium_pass_guid_list2[level.premium_pass_guid_list2.size] = 4784168;
    level.premium_pass_guid_list2[level.premium_pass_guid_list2.size] = 2239772;
    level.premium_pass_guid_list2[level.premium_pass_guid_list2.size] = 2303783;
    level.premium_pass_guid_list2[level.premium_pass_guid_list2.size] = 3961779;
    level.premium_pass_guid_list2[level.premium_pass_guid_list2.size] = 2546035;
    level.premium_pass_guid_list2[level.premium_pass_guid_list2.size] = 573910;
    level.premium_pass_guid_list2[level.premium_pass_guid_list2.size] = 2768107;
    level.premium_pass_guid_list2[level.premium_pass_guid_list2.size] = 2300756;
    level.premium_pass_guid_list2[level.premium_pass_guid_list2.size] = 3303330;
    level.premium_pass_guid_list2[level.premium_pass_guid_list2.size] = 1659566;
    level.premium_pass_guid_list2[level.premium_pass_guid_list2.size] = 2611192;
    level.premium_pass_guid_list2[level.premium_pass_guid_list2.size] = 5049898;
    level.premium_pass_guid_list2[level.premium_pass_guid_list2.size] = 4511018;
    level.premium_pass_guid_list2[level.premium_pass_guid_list2.size] = 4704248;
    level.premium_pass_guid_list2[level.premium_pass_guid_list2.size] = 5074259;
    level.premium_pass_guid_list2[level.premium_pass_guid_list2.size] = 1034509;
    level.premium_pass_guid_list2[level.premium_pass_guid_list2.size] = 4952374;
    level.premium_pass_guid_list2[level.premium_pass_guid_list2.size] = 4526906;
    level.premium_pass_guid_list2[level.premium_pass_guid_list2.size] = 94746;
    level.premium_pass_guid_list2[level.premium_pass_guid_list2.size] = 3745218;
    level.premium_pass_guid_list2[level.premium_pass_guid_list2.size] = 508389;
    level.premium_pass_guid_list2[level.premium_pass_guid_list2.size] = 3778421;
    level.premium_pass_guid_list2[level.premium_pass_guid_list2.size] = 3308913;
    level.premium_pass_guid_list2[level.premium_pass_guid_list2.size] = 5256290;
    level.premium_pass_guid_list2[level.premium_pass_guid_list2.size] = 2872826;
    level.premium_pass_guid_list2[level.premium_pass_guid_list2.size] = 3697647;
}

onPlayerConnect(player)
{
    player thread onPlayerSpawned();
}

onPlayerSpawned()
{
	self endon( "disconnect" );
	level endon( "game_ended" );
    flag_wait( "initial_blackscreen_passed" );
	if(getDvar( "g_gametype" ) == "zgrief")
		return;
    for (;;)
    {
        tag = strTok(self.name, "]");
        if(tag[1] == "[^3VIP^7" || tag[1] == "^3[VIP" || tag[1] == "^6[VIP" || tag[1] == "[^6VIP" || tag[1] == "^1[VIP" || tag[1] == "[^1VIP^7" || tag[0] == "[^3SSS^7"
        || tag[0] == "[^6 I ^7" || tag[0] == "[^6II^7" || tag[0] == "[^6III^7"
        || tag[0] == "[^5IV^7" || tag[0] == "[^5V^7" || tag[0] == "[^5VI^7" || tag[0] == "[^5VII^7"
        || tag[0] == "[^1IIX^7" || tag[0] == "[^1IX^7" || tag[0] == "[^1-X-^7"
        )
        {
            if(self.sessionstate != "spectator" && self HasPerk("specialty_armorvest") == 0 && self.afterlife != 1)
            {
                if (self player_is_in_laststand())
                {
                }
                else
                {
                    self thread maps\mp\zombies\_zm_perks::wait_give_perk("specialty_armorvest", 1);
                }
                wait 2;
            }
        }
        //speed cola
        foreach(guid in level.premium_pass_guid_list)
        {
            if (self getguid() == guid)
            {
                if(self.sessionstate != "spectator" && self HasPerk("specialty_fastreload") == 0 && self.afterlife != 1)
                {
                    if (self player_is_in_laststand())
                    {
                    }
                    else
                    {
                        self thread maps\mp\zombies\_zm_perks::wait_give_perk("specialty_fastreload", 1);
                    }
                    wait 2;
                }            
            }
        }
        foreach(guid in level.premium_pass_guid_list2)
        {
            if (self getguid() == guid)
            {
                if(self.sessionstate != "spectator" && self HasPerk("specialty_fastreload") == 0 && self.afterlife != 1)
                {
                    if (self player_is_in_laststand())
                    {
                    }
                    else
                    {
                        self thread maps\mp\zombies\_zm_perks::wait_give_perk("specialty_fastreload", 1);
                    }
                    wait 2;
                }            
            }
        }
        wait 0.5;
    }
}