#include maps\mp\zombies\_zm_laststand;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\_demo;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_pers_upgrades_functions;
#include maps\mp\gametypes_zm\_gameobjects;
#include maps\mp\zombies\_zm_buildables;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\zombies\_zm_chugabud;
#include maps\mp\zombies\_zm_perks;

main()
{
    replacefunc(maps\mp\zombies\_zm_laststand::revive_do_revive, ::revive_do_revive_custom);
}

revive_do_revive_custom( playerbeingrevived, revivergun )
{
    assert( self is_reviving( playerbeingrevived ) );
    revivetime = 3;

    if ( self hasperk( "specialty_quickrevive" ) )
        revivetime /= 2;

    if ( self maps\mp\zombies\_zm_pers_upgrades_functions::pers_revive_active() )
    {
        if (check_for_botb_port() == true || check_for_pia_port() == true || check_for_titb_port() == true && isdefined(self.perma_quick))
            revivetime *= 0.3;
        else
            revivetime *= 0.5;
    }

    if (isdefined(level.faster_revive))
    {
        revivetime *= 0.5;
    }
    if (isdefined(self.healer_multiplier))
    {
        if (self.kills >= 200)
            revivetime = 0;
        else 
            revivetime *= (1 - float(self.kills / 200));
    }
    timer = 0;
    revived = 0;
    playerbeingrevived.revivetrigger.beingrevived = 1;
    playerbeingrevived.revive_hud settext( &"ZOMBIE_PLAYER_IS_REVIVING_YOU", self );
    playerbeingrevived revive_hud_show_n_fade( 3.0 );
    playerbeingrevived.revivetrigger sethintstring( "" );

    if ( isplayer( playerbeingrevived ) )
        playerbeingrevived startrevive( self );

    if ( !isdefined( self.reviveprogressbar ) )
        self.reviveprogressbar = self createprimaryprogressbar();

    if ( !isdefined( self.revivetexthud ) )
        self.revivetexthud = newclienthudelem( self );

    self thread laststand_clean_up_on_disconnect( playerbeingrevived, revivergun );

    if ( !isdefined( self.is_reviving_any ) )
        self.is_reviving_any = 0;

    self.is_reviving_any++;
    self thread laststand_clean_up_reviving_any( playerbeingrevived );
    self.reviveprogressbar updatebar( 0.01, 1 / revivetime );
    self.revivetexthud.alignx = "center";
    self.revivetexthud.aligny = "middle";
    self.revivetexthud.horzalign = "center";
    self.revivetexthud.vertalign = "bottom";
    self.revivetexthud.y = -113;

    if ( self issplitscreen() )
        self.revivetexthud.y = -347;

    self.revivetexthud.foreground = 1;
    self.revivetexthud.font = "default";
    self.revivetexthud.fontscale = 1.8;
    self.revivetexthud.alpha = 1;
    self.revivetexthud.color = ( 1, 1, 1 );
    self.revivetexthud.hidewheninmenu = 1;

    if ( self maps\mp\zombies\_zm_pers_upgrades_functions::pers_revive_active() )
        self.revivetexthud.color = ( 0.5, 0.5, 1.0 );

    self.revivetexthud settext( &"ZOMBIE_REVIVING" );
    self thread check_for_failed_revive( playerbeingrevived );

    while ( self is_reviving( playerbeingrevived ) )
    {
        wait 0.05;
        timer += 0.05;

        if ( self player_is_in_laststand() )
            break;

        if ( isdefined( playerbeingrevived.revivetrigger.auto_revive ) && playerbeingrevived.revivetrigger.auto_revive == 1 )
            break;

        if ( timer >= revivetime )
        {
            revived = 1;
            break;
        }
    }

    if ( isdefined( self.reviveprogressbar ) )
        self.reviveprogressbar destroyelem();

    if ( isdefined( self.revivetexthud ) )
        self.revivetexthud destroy();

    if ( isdefined( playerbeingrevived.revivetrigger.auto_revive ) && playerbeingrevived.revivetrigger.auto_revive == 1 )
    {

    }
    else if ( !revived )
    {
        if ( isplayer( playerbeingrevived ) )
            playerbeingrevived stoprevive( self );
    }

    playerbeingrevived.revivetrigger sethintstring( &"ZOMBIE_BUTTON_TO_REVIVE_PLAYER" );
    playerbeingrevived.revivetrigger.beingrevived = 0;
    self notify( "do_revive_ended_normally" );
    self.is_reviving_any--;

    if ( !revived )
        playerbeingrevived thread checkforbleedout( self );

    return revived;
}

check_for_titb_port()
{
    found = 0;
    foreach(port in level.net_port_titb)
    {
        if (getdvar("net_port") == port)
            found = 1;
    }
    if (found == 0)
        return false;
    return true;
}

check_for_botb_port()
{
    found = 0;
	if (isdefined(level.net_port_botb))
	{
		foreach(port in level.net_port_botb)
		{
			if (getdvar("net_port") == port)
				found = 1;
		}
	}
    if (found == 0)
        return false;
    return true;
}

check_for_pia_port()
{
    found = 0;
    if (isdefined(level.net_port_pia))
    {
        foreach(port in level.net_port_pia)
        {
            if (getdvar("net_port") == port)
                found = 1;
        }
    }
    if (found == 0)
        return false;
    return true;
}