#include maps/mp/zombies/_zm_weapons;
#include maps/mp/gametypes_zm/_hud_util;
#include maps/mp/zombies/_zm_utility;
#include common_scripts/utility;
#include maps/mp/_utility;
#include maps/mp/zombies/_zm_stats;
#include maps/mp/zombies/_zm_weapons;
#include maps/mp/zombies/_zm_ai_brutus;
#include maps/mp/zombies/_zm_stats;
#include maps/mp/zombies/_zm_audio;
#include maps/mp/animscripts/zm_death;
#include maps/mp/zombies/_zm_laststand;
#include maps/mp/zombies/_zm_score;
#include maps/mp/zombies/_zm_utility;
#include maps/mp/_utility;
#include common_scripts/utility;
#include maps/mp/zombies/zm_alcatraz_traps;
#include maps/mp/zombies/_zm_magicbox;
#include maps/mp/_demo;
#include maps/mp/zombies/_zm_score;
#include maps/mp/zombies/_zm_pers_upgrades_functions;
#include maps/mp/zombies/_zm_audio_announcer;
#include maps/mp/zombies/_zm_unitrigger;
#include maps/mp/zombies/_zm_weapons;
#include maps/mp/zombies/_zm_magicbox_lock;
#include maps/mp/zombies/_zm;

//#namespace buried;

init()
{
	//setdvar("player_strafeSpeedScale", 1);
	//setdvar("player_backSpeedScale", 1);
	level thread onplayerconnect();
}

onPlayerConnect()
{
	while(1)
	{
		level waittill("connecting", player);
		player thread onplayerspawned();
		player thread givepermaperks();
		//player thread givebankandfridge();
		level waittill("initial_players_connected");
		//level.special_weapon_magicbox_check = undefined;
		//level.zombie_weapons["hamr_zm"].is_in_box = 0;
		//level.zombie_weapons["type95_zm"].is_in_box = 0;
		//level.zombie_weapons["galil_zm"].is_in_box = 0;
		//level.zombie_weapons["fnfal_zm"].is_in_box = 0;
		//level.zombie_weapons["srm1216_zm"].is_in_box = 0;
		//level.zombie_weapons["dsr50_zm"].is_in_box = 0;
		//level.zombie_weapons["kard_zm"].is_in_box = 0;
		//level.zombie_weapons["python_zm"].is_in_box = 0;
		//level.zombie_weapons["fivesevendw_zm"].is_in_box = 0;
		//level.zombie_weapons["m32_zm"].is_in_box = 0;
		//level.zombie_weapons["mp44_zm"].is_in_box = 0;
		//level.zombie_weapons["870mcs_zm"].is_in_box = 0;
		//level.zombie_weapons["ak74u_zm"].is_in_box = 0;
		//level.zombie_weapons["mp40_zm"].is_in_box = 0;
		//level.zombie_weapons["ballista_zm"].is_in_box = 0;
		//level.zombie_weapons["rnma_zm"].is_in_box = 0;
		//level.zombie_weapons["barretm82_zm"].is_in_box = 0;
		//level.zombie_weapons["judge_zm"].is_in_box = 0;
		//level.zombie_weapons["saiga12_zm"].is_in_box = 0;
		//level.zombie_weapons["tar21_zm"].is_in_box = 0;
		//level.zombie_weapons["usrpg_zm"].is_in_box = 0;
		//level.zombie_weapons["knife_ballistic_zm"].is_in_box = 0;
		//level.zombie_weapons["time_bomb_zm"].is_in_box = 0;
		//level.zombie_weapons["saritch_zm"].is_in_box = 0;
		//level.zombie_weapons["slowgun_zm"].is_in_box = 1;
		//level.zombie_weapons["fiveseven_zm"].is_in_box = 0;
		//level.zombie_weapons["raygun_mark2_zm"].is_in_box = 1;
		//level.zombie_weapons["ray_gun_zm"].is_in_box = 0;
		//level.zombie_weapons["cymbal_monkey_zm"].is_in_box = 1;
	}
}

onPlayerSpawned()
{
	level endon("game_ended");
	self endon("disconnect");
	self.initialspawn = 1;
	for(;;)
	{
		self waittill("spawned_player");
		if(self.initalspawn)
		{
			self.initialspawn = 0;
			self thread zombies_remaining_hud();
			self thread givebankandfridge();
			self thread givepermaperks();
		}
	}
}

givepermaperks()
{
	flag_wait("initial_blackscreen_passed");
	permaperks = strtok("pers_revivenoperk,pers_insta_kill,pers_jugg,pers_sniper_counter,pers_flopper_counter,pers_perk_lose_counter,pers_box_weapon_counter,pers_multikill_headshots", ",");
	for(i = 0; i < permaperks.size; i++)
	{
		self increment_client_stat(permaperks[i], 0);
		wait(0.25);
	}
}

givebankandfridge()
{
	//flag_wait("initial_blackscreen_passed");
	//self set_map_stat("depositBox", 250, level.banking_map);
	//self.account_value = 250000;
	//self clear_stored_weapondata();
	//self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "name", "galil_upgraded_zm");
	//self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "clip", 6);
	//self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "stock", 48);
}

zombies_remaining_hud()
{
	//self endon("disconnect");
	//remaining = newclienthudelem(self);
	//remaining.alignx = "left";
	//remaining.aligny = "top";
	//remaining.horzalign = "user_left";
	//remaining.vertalign = "user_top";
	//remaining.x = remaining.x + 10;
	//remaining.y = remaining.y + 410;
	//remaining.fontscale = 1,4;
	//remaining.alpha = 0;
	//remaining.color =  1, 0, 0;
	//remaining.hidewheninmenu = 1;
	//remaining.label = &"Zombies: ";
	//flag_wait("initial_blackscreen_passed");
	//remaining.alpha = 1;
	//while(1)
	//{
	//	enemies = get_round_enemy_array().size + level.zombie_total;
	//	if(enemies == 0)
	//	{
	//		remaining settext("");
	//	}
	//	else
	//	{
	//		remaining setvalue(enemies);
	//	}
	//	wait(0,05);
	//}
}

