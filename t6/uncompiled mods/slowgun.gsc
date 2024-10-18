#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_audio;

main()
{
    replaceFunc(maps\mp\zombies\_zm_weap_slowgun::init, ::slowgun);
}

slowgun()
{
 //   if ( !maps\mp\zombies\_zm_weapons::is_weapon_included( "slowgun_zm" ) )
  //      return;

    registerclientfield( "actor", "slowgun_fx", 12000, 3, "int" );
    registerclientfield( "actor", "anim_rate", 7000, 5, "float" );
    registerclientfield( "allplayers", "anim_rate", 7000, 5, "float" );
    registerclientfield( "toplayer", "sndParalyzerLoop", 12000, 1, "int" );
    registerclientfield( "toplayer", "slowgun_fx", 12000, 1, "int" );
    level.sliquifier_distance_checks = 0;
    maps\mp\zombies\_zm_spawner::add_cusom_zombie_spawn_logic( ::slowgun_on_zombie_spawned );
    maps\mp\zombies\_zm_spawner::register_zombie_damage_callback( ::slowgun_zombie_damage_response );
    maps\mp\zombies\_zm_spawner::register_zombie_death_animscript_callback( ::slowgun_zombie_death_response );
    level._effect["zombie_slowgun_explosion"] = loadfx( "weapon/paralyzer/fx_paralyzer_body_disintegrate" );
    level._effect["zombie_slowgun_explosion_ug"] = loadfx( "weapon/paralyzer/fx_paralyzer_body_disintegrate_ug" );
    level._effect["zombie_slowgun_sizzle"] = loadfx( "weapon/paralyzer/fx_paralyzer_hit_dmg" );
    level._effect["zombie_slowgun_sizzle_ug"] = loadfx( "weapon/paralyzer/fx_paralyzer_hit_dmg_ug" );
    level._effect["player_slowgun_sizzle"] = loadfx( "weapon/paralyzer/fx_paralyzer_hit_noharm" );
    level._effect["player_slowgun_sizzle_ug"] = loadfx( "weapon/paralyzer/fx_paralyzer_hit_noharm" );
    level._effect["player_slowgun_sizzle_1st"] = loadfx( "weapon/paralyzer/fx_paralyzer_hit_noharm_view" );
    maps\mp\zombies\_zm_weap_slowgun::onplayerconnect_callback( ::slowgun_player_connect );
    level.slowgun_damage = 40;
    level.slowgun_damage_ug = 60;
    level.slowgun_damage_mod = "MOD_PROJECTILE_SPLASH";
    precacherumble( "damage_heavy" );
/#
    level thread show_anim_rates();
#/
}