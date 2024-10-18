#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\_visionset_mgr;
#include maps\mp\animscripts\zm_death;

main()
{
    replaceFunc(maps\mp\zm_transit_lava::zombie_exploding_death, ::zombie_exploding_death_custom);
}

init()
{

}

zombie_exploding_death_custom( zombie_dmg, trap )
{
    self endon( "stop_flame_damage" );

    if ( isdefined( self.isdog ) && self.isdog && isdefined( self.a.nodeath ) )
        return;

    while ( isdefined( self ) && self.health >= zombie_dmg && ( isdefined( self.is_on_fire ) && self.is_on_fire ) )
        wait 0.5;

    if ( !isdefined( self ) || !( isdefined( self.is_on_fire ) && self.is_on_fire ) || isdefined( self.damageweapon ) && ( self.damageweapon == "tazer_knuckles_zm" || self.damageweapon == "jetgun_zm" ) || isdefined( self.knuckles_extinguish_flames ) && self.knuckles_extinguish_flames )
        return;

    tag = "J_SpineLower";

    if ( isdefined( self.animname ) && self.animname == "zombie_dog" )
        tag = "tag_origin";

    if ( is_mature() )
    {
        if ( isdefined( level._effect["zomb_gib"] ) )
            playfx( level._effect["zomb_gib"], self gettagorigin( tag ) );
    }
    else if ( isdefined( level._effect["spawn_cloud"] ) )
        playfx( level._effect["spawn_cloud"], self gettagorigin( tag ) );

  //  self radiusdamage( self.origin, 128, 30, 15, undefined, "MOD_EXPLOSIVE" );
    self ghost();

    if ( isdefined( self.isdog ) && self.isdog )
        self hide();
    else
        self delay_thread( 1, ::self_delete );
}