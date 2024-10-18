#include maps\mp\zombies\_zm_weapon_locker;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_magicbox;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zombies\_zm_audio;

main()
{
    replacefunc(maps\mp\zombies\_zm_weapon_locker::triggerweaponslockerisvalidweaponpromptupdate, ::triggerweaponslockerisvalidweaponpromptupdate_custom);
    replacefunc(maps\mp\zombies\_zm_weapon_locker::triggerweaponslockerwatch, ::triggerweaponslockerwatch_custom);
}

triggerweaponslockerwatch_custom()
{
    unitrigger_stub = spawnstruct();
    unitrigger_stub.origin = self.origin;

    if ( isdefined( self.script_angles ) )
        unitrigger_stub.angles = self.script_angles;
    else
        unitrigger_stub.angles = self.angles;

    unitrigger_stub.script_angles = unitrigger_stub.angles;

    if ( isdefined( self.script_length ) )
        unitrigger_stub.script_length = self.script_length;
    else
        unitrigger_stub.script_length = 16;

    if ( isdefined( self.script_width ) )
        unitrigger_stub.script_width = self.script_width;
    else
        unitrigger_stub.script_width = 32;

    if ( isdefined( self.script_height ) )
        unitrigger_stub.script_height = self.script_height;
    else
        unitrigger_stub.script_height = 64;

    unitrigger_stub.origin -= anglestoright( unitrigger_stub.angles ) * unitrigger_stub.script_length / 2;
    unitrigger_stub.targetname = "weapon_locker";
    unitrigger_stub.cursor_hint = "HINT_NOICON";
    unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
    unitrigger_stub.clientfieldname = "weapon_locker";
    maps\mp\zombies\_zm_unitrigger::unitrigger_force_per_player_triggers( unitrigger_stub, 1 );
    unitrigger_stub.prompt_and_visibility_func = ::triggerweaponslockerthinkupdateprompt;
    maps\mp\zombies\_zm_unitrigger::register_static_unitrigger( unitrigger_stub, ::triggerweaponslockerthink_custom );
}

triggerweaponslockerthink_custom()
{
    self.parent_player thread triggerweaponslockerweaponchangethink( self );

    while ( true )
    {
        self waittill( "trigger", player );

        retrievingweapon = player wl_has_stored_weapondata();

        if ( !retrievingweapon )
        {
            curweapon = player getcurrentweapon();
            curweapon = player maps\mp\zombies\_zm_weapons::switch_from_alt_weapon( curweapon );

            if ( !triggerweaponslockerisvalidweapon( curweapon ) )
                continue;

            weapondata = player maps\mp\zombies\_zm_weapons::get_player_weapondata( player );
            player wl_set_stored_weapondata( weapondata );
            assert( curweapon == weapondata["name"], "weapon data does not match" );
            player takeweapon( curweapon );
            primaries = player getweaponslistprimaries();

            if ( isdefined( primaries[0] ) )
                player switchtoweapon( primaries[0] );
            else
                player maps\mp\zombies\_zm_weapons::give_fallback_weapon();

            self triggerweaponslockerisvalidweaponpromptupdate( player, player getcurrentweapon() );
            player playsoundtoplayer( "evt_fridge_locker_close", player );
            player thread maps\mp\zombies\_zm_audio::create_and_play_dialog( "general", "weapon_storage" );
        }
        else
        {
            if (isdefined(level.gamemode_difficulty) && level.gamemode_difficulty == "^6GigaChad^7")
            {
                wait 3;
                continue;
            }

            curweapon = player getcurrentweapon();
            primaries = player getweaponslistprimaries();
            weapondata = player wl_get_stored_weapondata();

            if ( isdefined( level.remap_weapon_locker_weapons ) )
                weapondata = remap_weapon( weapondata, level.remap_weapon_locker_weapons );

            weapontogive = weapondata["name"];

            if ( !triggerweaponslockerisvalidweapon( weapontogive ) )
            {
                player playlocalsound( level.zmb_laugh_alias );
                player wl_clear_stored_weapondata();
                self triggerweaponslockerisvalidweaponpromptupdate( player, player getcurrentweapon() );
                continue;
            }

            curweap_base = maps\mp\zombies\_zm_weapons::get_base_weapon_name( curweapon, 1 );
            weap_base = maps\mp\zombies\_zm_weapons::get_base_weapon_name( weapontogive, 1 );

            if ( player has_weapon_or_upgrade( weap_base ) && weap_base != curweap_base )
            {
                self sethintstring( &"ZOMBIE_WEAPON_LOCKER_DENY" );
                wait 3;
                self triggerweaponslockerisvalidweaponpromptupdate( player, player getcurrentweapon() );
                continue;
            }

            maxweapons = get_player_weapon_limit( player );

            if ( isdefined( primaries ) && primaries.size >= maxweapons || weapontogive == curweapon )
            {
                curweapon = player maps\mp\zombies\_zm_weapons::switch_from_alt_weapon( curweapon );

                if ( !triggerweaponslockerisvalidweapon( curweapon ) )
                {
                    self sethintstring( &"ZOMBIE_WEAPON_LOCKER_DENY" );
                    wait 3;
                    self triggerweaponslockerisvalidweaponpromptupdate( player, player getcurrentweapon() );
                    continue;
                }

                curweapondata = player maps\mp\zombies\_zm_weapons::get_player_weapondata( player );
                player takeweapon( curweapondata["name"] );
                player maps\mp\zombies\_zm_weapons::weapondata_give( weapondata );
                player wl_clear_stored_weapondata();
                player wl_set_stored_weapondata( curweapondata );
                player switchtoweapon( weapondata["name"] );
                self triggerweaponslockerisvalidweaponpromptupdate( player, player getcurrentweapon() );
            }
            else
            {
                player thread maps\mp\zombies\_zm_audio::create_and_play_dialog( "general", "wall_withdrawl" );
                player wl_clear_stored_weapondata();
                player maps\mp\zombies\_zm_weapons::weapondata_give( weapondata );
                player switchtoweapon( weapondata["name"] );
                self triggerweaponslockerisvalidweaponpromptupdate( player, player getcurrentweapon() );
            }

            level notify( "weapon_locker_grab" );
            player playsoundtoplayer( "evt_fridge_locker_open", player );
        }

        wait 0.5;
    }
}

triggerweaponslockerisvalidweaponpromptupdate_custom( player, weaponname )
{
    retrievingweapon = player wl_has_stored_weapondata();

    if ( !retrievingweapon )
    {
        weaponname = player get_nonalternate_weapon( weaponname );

        if ( !triggerweaponslockerisvalidweapon( weaponname ) )
            self sethintstring( &"ZOMBIE_WEAPON_LOCKER_DENY" );
        else
            self sethintstring( &"ZOMBIE_WEAPON_LOCKER_STORE" );
    }
    else
    {
        if (isdefined(level.gamemode_difficulty) && level.gamemode_difficulty == "^6GigaChad^7")
        {
            self sethintstring("A fridge. Used to store ^3food^7.");
            return;
        }

        weapondata = player wl_get_stored_weapondata();

        if ( isdefined( level.remap_weapon_locker_weapons ) )
            weapondata = remap_weapon( weapondata, level.remap_weapon_locker_weapons );

        weapontogive = weapondata["name"];
        primaries = player getweaponslistprimaries();
        maxweapons = get_player_weapon_limit( player );
        weaponname = player get_nonalternate_weapon( weaponname );

        if ( isdefined( primaries ) && primaries.size >= maxweapons || weapontogive == weaponname )
        {
            if ( !triggerweaponslockerisvalidweapon( weaponname ) )
            {
                self sethintstring( &"ZOMBIE_WEAPON_LOCKER_DENY" );
                return;
            }
        }
        self sethintstring( &"ZOMBIE_WEAPON_LOCKER_GRAB" );
    }
}