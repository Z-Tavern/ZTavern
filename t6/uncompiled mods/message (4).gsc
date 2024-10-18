
/* Copyright (c) 2023 Z-Tavern - K Mod

 Created by Kiels (Z-Tavern)

* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_magicbox;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\zombies\_zm_power;
#include maps\mp\zombies\_zm_pers_upgrades_functions;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\_demo;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_chugabud;
#include maps\mp\_visionset_mgr;
#include maps\mp\zombies\_zm_perks;
#include maps\mp\zombies\_zm;

#include Maps\Origins\clientscripts\mp\zm_tomb_tank;
#include maps\mp\zombies\_zm_ai_mechz;
#include clientscripts\mp\_utility;
#include clientscripts\mp\_fx;
#include clientscripts\mp\zombies\_zm_utility;
#include clientscripts\mp\zombies\_zm_weapons;
#include Maps\Origins\clientscripts\mp\zombies\_zm_weap_beacon;
#include Maps\Origins\clientscripts\mp\zombies;
#include Maps\Tranzit\maps\mp\zombies\_zm_ai_avogadro;

/* --------MEMO----------

    (HOW TO MAKE THE BOSS LOOKS COOL) Spawn an object to a specific location :

    model = "t6_wpn_zmb_staff_tip_lightning_world";

    self.fx = spawn( "script_model", level.boss.origin ); // create objcet
    self.fx linkto( level.boss, "J_SpineLower", (23, 0, 0), (0, 90, 110)); 
    wait 0.1;
    self.fx setmodel( "t6_wpn_zmb_staff_tip_lightning_world" );  // change the model for other model

    (HOW TO MAKE BOSS ATTACK SPECIAL EFFECTS) Spawn a FX on an fx :

    fx_origin = level.boss.origin; //set origin of effect 
fx = spawn( "script_model", (fx_origin[0], fx_origin[1], -390)); // spawn object
fx setmodel( "tag_origin" ); // set three D default object
wait 0.1;
playfxontag( level._effect["fire_glow"], level.boss, "tag_origin" );


    (HOW TO ADD SOUND TO ATTACKS)

    self playsound( "evt_medal_acquired" ); // search playsound in stock script (CTRL + F)

*/

init()
{
    level thread on_player_connect();


  //  if (getdvar("net_port") != "27050") //the default is close to this number, find it.  Now only this server will have this code active
   //     return

    level.player_out_of_playable_area_monitor = false;
    flag_wait("initial_blackscreen_passed");
    flag_set( "activate_zone_chamber" );

    level thread init_kill_zombie();
}

on_player_connect()
{
    level endon("game_ended");

    for(;;)
    {
        level waittill("connected", player);
        player thread god_player();
        id = player getEntityNumber();
        player thread TpToCenter(id);
        player thread HP();
        player thread Give_Ammo();
    }
}

Give_Ammo()
{
    self endon("disconnect");

    for(;;)
    {
        stockcount = self GetWeaponAmmoStock( self GetCurrentWeapon() );
        self SetWeaponAmmoStock(self GetCurrentWeapon(), stockcount + 330);
        wait 5;
    }
}

TpToCenter(id)
{
    level endon ("game_ended");
    self endon("disconnect");

    if (id == 0)
    {
        origin = (10463.8, -8036.59, -419.875);
        angle =  (0, 135, 0);
        self giveweapon( "srm1216_upgraded_zm", 0 , self get_pack_a_punch_weapon_options("srm1216_upgraded_zm"));
        self SwitchToWeapon("srm1216_upgraded_zm");
        self setOrigin(origin);
        self SetPlayerAngles(angle);
    }
    else if (id == 1)
    {
        origin = (10216, -7776.28, -419.875);
        angle = (0, 315, 0);
        self giveweapon( "srm1216_upgraded_zm", 0 , self get_pack_a_punch_weapon_options("srm1216_upgraded_zm"));
        self SwitchToWeapon("srm1216_upgraded_zm");
        self setOrigin(origin);
        self SetPlayerAngles(angle);
    }
    else if (id == 2)
    {
        origin = (10212.8, -8044.76, -419.875);
        angle = (0, 45, 0);
        self giveweapon( "srm1216_upgraded_zm", 0 , self get_pack_a_punch_weapon_options("srm1216_upgraded_zm"));
        self SwitchToWeapon("srm1216_upgraded_zm");
        self setOrigin(origin);
        self SetPlayerAngles(angle);
    }
    else if (id == 3)
    {
        origin = (10472.6, -7778.6, -419.875);
        angle = (0, 225, 0);
        self giveweapon( "srm1216_upgraded_zm", 0 , self get_pack_a_punch_weapon_options("srm1216_upgraded_zm"));
        self SwitchToWeapon("srm1216_upgraded_zm");
        self setOrigin(origin);
        self SetPlayerAngles(angle);
    }
    else if (id == 4)
    {
        origin = (10672.6, -7778.6, -419.875);
        angle = (0, 225, 0);
        self giveweapon( "srm1216_upgraded_zm", 0 , self get_pack_a_punch_weapon_options("srm1216_upgraded_zm"));
        self SwitchToWeapon("srm1216_upgraded_zm");
        self setOrigin(origin);
        self SetPlayerAngles(angle);
    }
    else if (id == 5)
    {
        origin = (10272.6, -7778.6, -419.875);
        angle = (0, 225, 0);
        self giveweapon( "srm1216_upgraded_zm", 0 , self get_pack_a_punch_weapon_options("srm1216_upgraded_zm"));
        self SwitchToWeapon("srm1216_upgraded_zm");
        self setOrigin(origin);
        self SetPlayerAngles(angle);
    }
}

HP()
{
    self endon("disconnect");
        //Player
    self.hp_hud = maps\mp\gametypes_zm\_hud_util::createFontString( "hudbig" , 2 );
    self.hp_hud maps\mp\gametypes_zm\_hud_util::setPoint( "BOTTOM", "LEFT", 100, 240 );
    self.hp_hud.label = &"^4HP :";
    self.hp_hud setText(self.health);
    self.hp_hud.alpha = 1;
        //Boss
    self.boss_hp_hud = maps\mp\gametypes_zm\_hud_util::createFontString( "hudbig" , 2 );
    self.boss_hp_hud maps\mp\gametypes_zm\_hud_util::setPoint( "TOP", "LEFT", 50 , -240 );
    self.boss_hp_hud.label = &"^8BOSS : ";
    self.boss_hp_hud.alpha = 1;

    for(;;)
    {
        zombies = getaiarray(level.zombie_team);
        self.boss_hp_hud setText(zombies[0].health);
        self.hp_hud setText(self.health);
        wait 0.1;  
    }
}

god_player()
{   
    flag_wait("initial_blackscreen_passed");

    wait 0.2;
    self takeWeapon("c96_zm");
    wait 0.3;
    self playsound( "evt_medal_acquired" );
    wait 2;
    self playsound( "evt_medal_acquired" );

    player_hp = 100000; //increase player hp
    self.maxhealth = player_hp;
    self.health = self.maxhealth;
    self SetMoveSpeedScale(1.5); //increase player speed
    wait 2;
    self playsound( "zmb_ai_mechz_incoming_alarm" );
    
}

init_kill_zombie()
{   
    flag_wait("initial_blackscreen_passed");

    level waittill("start_of_round");
    wait 0.1;
    iprintln("^2Loading ^1Raid Boss"); //print to everyone
    zombie_list = GetAIArray(level.zombie_team); // get the zombie array

    //transform the remaining zm into the raid boss
    zombie_list[0] set_zombie_run_cycle("super_sprint");
    zombie_list[0].maxhealth = 1000000;
    zombie_list[0].health = zombie_list[0].maxhealth;
    zombie_list[0].meleedamage = 500;

    level.boss = zombie_list[0]; //set the raid boss as a global variable accessible from all code (no need to pass it as parameter)

    iprintln("^1Raid Boss Loaded !");
    level.boss thread boss_think(); //call the raid boss attacks loop

    for(;;) // find all zombies in the zombie array
    {
        zombie_list = getaiarray(level.zombie_team);
        zombie_list[1] doDamage( zombie_list[1].health + 1000, zombie_list[1].origin);
        wait 0.1;
    }
}

boss_think() // Six second after boss, start the attacks rotation
{
    self endon("death");

    cooldown = 15;

    wait 6;

    for(;;)
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
    //Fill with your custom attacks !
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

