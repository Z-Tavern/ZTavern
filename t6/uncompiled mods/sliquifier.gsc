#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\gametypes_zm\_weaponobjects;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\zombies\_zm;
#include maps\mp\animscripts\zm_utility;
#include maps\mp\animscripts\zm_shared;
#include maps\mp\zombies\_zm_ai_basic;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zombies\_zm_audio;

main()
{
    replacefunc(maps\mp\zombies\_zm_weap_slipgun::explode_to_near_zombies, ::customSliquifier);
    replacefunc(maps\mp\zombies\_zm_weap_slipgun::add_slippery_spot, ::no_slippery_spot); 
}

customSliquifier( player, origin, radius, chain_depth )
{
    if ( level.zombie_vars["slipgun_max_kill_chain_depth"] > 0 && chain_depth > level.zombie_vars["slipgun_max_kill_chain_depth"] )
        return;

    enemies = get_round_enemy_array();
    enemies = get_array_of_closest( origin, enemies );
    minchainwait = level.zombie_vars["slipgun_chain_wait_min"];
    maxchainwait = level.zombie_vars["slipgun_chain_wait_max"];
    rsquared = radius * radius;
    tag = "J_Head";
    marked_zombies = [];

    if ( isdefined( enemies ) && enemies.size )
    {
        index = 0;
        for ( enemy = enemies[index]; distancesquared( enemy.origin, origin ) < rsquared; enemy = enemies[index] )
        {
            if ( isalive( enemy ) && !is_true( enemy.guts_explosion ) && !is_true( enemy.nuked ) && !isdefined( enemy.slipgun_sizzle ) )
            {
                trace = bullettrace( origin + vectorscale( ( 0, 0, 1 ), 50.0 ), enemy.origin + vectorscale( ( 0, 0, 1 ), 50.0 ), 0, undefined, 1 );

                if ( isdefined( trace["fraction"] ) && trace["fraction"] == 1 )
                {
                    enemy.slipgun_sizzle = playfxontag( level._effect["slipgun_simmer"], enemy, tag );
                    marked_zombies[marked_zombies.size] = enemy;
                }
            }

            index++;

            if ( index >= enemies.size )
                break;
        }
    }

    if ( isdefined( marked_zombies ) && marked_zombies.size )
    {
        foreach ( enemy in marked_zombies )
        {
            if ( isalive( enemy ) && !is_true( enemy.guts_explosion ) && !is_true( enemy.nuked ) )
            {
               // wait( randomfloatrange( minchainwait, maxchainwait ) );

                if ( isalive( enemy ) && !is_true( enemy.guts_explosion ) && !is_true( enemy.nuked ) )
                {
                    if ( !isdefined( enemy.goo_chain_depth ) )
                        enemy.goo_chain_depth = chain_depth;

                    if ( enemy.health > 0 )
                    {
                        if ( player maps\mp\zombies\_zm_powerups::is_insta_kill_active() )
                            enemy.health = 1;

                        enemy dodamage( level.slipgun_damage, origin, player, player, "none", level.slipgun_damage_mod, 0, "slip_goo_zm" );
                    }

                    if ( level.slippery_spot_count < level.zombie_vars["slipgun_reslip_max_spots"] )
                    {
                        if ( ( !isdefined( enemy.slick_count ) || enemy.slick_count == 0 ) && enemy.health <= 0 )
                        {
                            if ( level.zombie_vars["slipgun_reslip_rate"] > 0 && randomint( level.zombie_vars["slipgun_reslip_rate"] ) == 0 )
                            {
                                startpos = origin;
                                duration = 24;
                                thread maps\mp\zombies\_zm_weap_slipgun::add_slippery_spot( enemy.origin, duration, startpos );
                            }
                        }
                    }
                }
            }
        }
    }
}

no_slippery_spot( origin, duration, startpos )
{
    return;
}