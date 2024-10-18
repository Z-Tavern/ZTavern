#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_buildables;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_magicbox;
#include maps\mp\zombies\_zm_sidequests;
#include maps\mp\zombies\_zm_buildables_pooled;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_melee_weapon;
#include maps\mp\zombies\_zm_weap_claymore;
#include maps\mp\zombies\_zm_unitrigger;

#include maps\mp\zm_buried_buildables;

main()
{
    replaceFunc(maps\mp\zm_buried_buildables::include_buildables, ::include_buildables_custom);
}

include_buildables_custom( buildablesenabledlist )
{
    turbine_fan = generate_zombie_buildable_piece( "turbine", "p6_zm_buildable_turbine_fan", 32, 64, 0, "zm_hud_icon_fan", ::onpickup_common, ::ondrop_common, undefined, "tag_part_03", undefined, 1 );
    turbine_panel = generate_zombie_buildable_piece( "turbine", "p6_zm_buildable_turbine_rudder", 32, 64, 0, "zm_hud_icon_rudder", ::onpickup_common, ::ondrop_common, undefined, "tag_part_04", undefined, 2 );
    turbine_body = generate_zombie_buildable_piece( "turbine", "p6_zm_buildable_turbine_mannequin", 32, 15, 0, "zm_hud_icon_mannequin", ::onpickup_common, ::ondrop_common, undefined, "tag_part_01", undefined, 3 );
    springpad_door = generate_zombie_buildable_piece( "springpad_zm", "p6_zm_buildable_tramplesteam_door", 32, 64, 0, "zom_hud_trample_steam_screen", ::onpickup_common, ::ondrop_common, undefined, "Tag_part_02", undefined, 4 );
    springpad_flag = generate_zombie_buildable_piece( "springpad_zm", "p6_zm_buildable_tramplesteam_bellows", 32, 15, 0, "zom_hud_trample_steam_bellow", ::onpickup_common, ::ondrop_common, undefined, "Tag_part_04", undefined, 5 );
    springpad_motor = generate_zombie_buildable_piece( "springpad_zm", "p6_zm_buildable_tramplesteam_compressor", 32, 15, 0, "zom_hud_trample_steam_compressor", ::onpickup_common, ::ondrop_common, undefined, "Tag_part_01", undefined, 6 );
    springpad_whistle = generate_zombie_buildable_piece( "springpad_zm", "p6_zm_buildable_tramplesteam_flag", 48, 15, 0, "zom_hud_trample_steam_whistle", ::onpickup_common, ::ondrop_common, undefined, "Tag_part_03", undefined, 7 );
    sq_common_electricbox = generate_zombie_buildable_piece( "sq_common", "p6_zm_buildable_sq_electric_box", 32, 64, 0, "zm_hud_icon_sq_powerbox", ::onpickup_common, ::ondrop_common, undefined, "tag_part_02", undefined, 1, 2 );
    sq_common_meteor = generate_zombie_buildable_piece( "sq_common", "p6_zm_buildable_sq_meteor", 32, 64, 0, "zm_hud_icon_sq_meteor", ::onpickup_common, ::ondrop_common, undefined, "tag_part_04", undefined, 2, 2 );
    sq_common_scaffolding = generate_zombie_buildable_piece( "sq_common", "p6_zm_buildable_sq_scaffolding", 64, 96, 0, "zm_hud_icon_sq_scafold", ::onpickup_common, ::ondrop_common, undefined, "tag_part_01", undefined, 3, 2 );
    sq_common_transceiver = generate_zombie_buildable_piece( "sq_common", "p6_zm_buildable_sq_transceiver", 64, 96, 0, "zm_hud_icon_sq_tranceiver", ::onpickup_common, ::ondrop_common, undefined, "tag_part_03", undefined, 4, 2 );
    sq_lamp_piece = generate_zombie_buildable_piece( "buried_sq_oillamp", "p6_zm_bu_lantern_silver_on", 32, 64, 0, "zm_hud_icon_jetgun_engine", ::onpickup_common, ::ondrop_common, undefined, undefined, undefined, 13, 2 );
    sq_m_tower_vacuum_tube = generate_zombie_buildable_piece( "buried_sq_bt_m_tower", "p6_zm_bu_sq_vaccume_tube", 32, 64, 0, "zm_hud_icon_sq_powerbox", ::onpickup_common, ::ondrop_common, undefined, "j_vaccume_01", undefined, 7, 2 );
    sq_m_tower_battery = generate_zombie_buildable_piece( "buried_sq_bt_m_tower", "p6_zm_bu_sq_buildable_battery", 32, 64, 0, "zm_hud_icon_battery", ::onpickup_common, ::ondrop_common, undefined, "j_battery", undefined, 8, 2 );
    sq_r_tower_crystal = generate_zombie_buildable_piece( "buried_sq_bt_r_tower", "p6_zm_bu_sq_crystal", 96, 64, 0, "zm_hud_icon_sq_powerbox", ::onpickup_common, ::ondrop_common, undefined, "j_crystal_01", undefined, 9, 2 );
    sq_r_tower_satellite = generate_zombie_buildable_piece( "buried_sq_bt_r_tower", "p6_zm_bu_sq_satellite_dish", 32, 64, 0, "zm_hud_icon_sq_powerbox", ::onpickup_common, ::ondrop_common, "j_satellite", undefined, undefined, 10, 2 );
    sq_s_tower_antenna = generate_zombie_buildable_piece( "buried_sq_bt_m_tower", "p6_zm_bu_sq_antenna", 32, 64, 0, "zm_hud_icon_sq_powerbox", ::onpickup_common, ::ondrop_common, undefined, "j_antenna", undefined, 11, 2 );
    sq_s_tower_wire = generate_zombie_buildable_piece( "buried_sq_bt_m_tower", "p6_zm_bu_sq_wire_spool", 32, 64, 0, "zm_hud_icon_sq_powerbox", ::onpickup_common, ::ondrop_common, undefined, "j_wire", undefined, 12, 2 );
    subwoofer_speaker = generate_zombie_buildable_piece( "subwoofer_zm", "t6_wpn_zmb_subwoofer_parts_speaker", 32, 64, 0, "zom_hud_icon_buildable_woof_speaker", ::onpickup_common, ::ondrop_common, undefined, "TAG_SPEAKER", undefined, 8 );
    subwoofer_motor = generate_zombie_buildable_piece( "subwoofer_zm", "t6_wpn_zmb_subwoofer_parts_motor", 48, 15, 0, "zom_hud_icon_buildable_woof_motor", ::onpickup_common, ::ondrop_common, undefined, "TAG_ENGINE", undefined, 9 );
    subwoofer_table = generate_zombie_buildable_piece( "subwoofer_zm", "t6_wpn_zmb_subwoofer_parts_table", 48, 15, 0, "zom_hud_icon_buildable_woof_frame", ::onpickup_common, ::ondrop_common, undefined, "TAG_SPIN", undefined, 11 );
    subwoofer_mount = generate_zombie_buildable_piece( "subwoofer_zm", "t6_wpn_zmb_subwoofer_parts_mount", 32, 15, 0, "zom_hud_icon_buildable_woof_chains", ::onpickup_common, ::ondrop_common, undefined, "TAG_MOUNT", undefined, 10 );
    headchopper_blade = generate_zombie_buildable_piece( "headchopper_zm", "t6_wpn_zmb_chopper_part_blade", 32, 64, 0, "zom_hud_icon_buildable_chop_a", ::onpickup_common, ::ondrop_common, undefined, "TAG_SAW", undefined, 12 );
    headchopper_crank = generate_zombie_buildable_piece( "headchopper_zm", "t6_wpn_zmb_chopper_part_crank", 32, 15, 0, "zom_hud_icon_buildable_chop_b", ::onpickup_common, ::ondrop_common, undefined, "TAG_CRANK", undefined, 13 );
    headchopper_hinge = generate_zombie_buildable_piece( "headchopper_zm", "t6_wpn_zmb_chopper_part_hinge", 32, 15, 0, "zom_hud_icon_buildable_chop_c", ::onpickup_common, ::ondrop_common, undefined, "TAG_GEARS", undefined, 14 );
    headchopper_mount = generate_zombie_buildable_piece( "headchopper_zm", "t6_wpn_zmb_chopper_part_mount", 32, 15, 0, "zom_hud_icon_buildable_chop_d", ::onpickup_common, ::ondrop_common, undefined, "TAG_MOUNT", undefined, 15 );
    bottle = generate_zombie_buildable_piece( "booze", "p6_zm_bu_booze", 32, 64, 2.4, "zom_hud_icon_buildable_sloth_booze", ::onpickup_booze, ::ondrop_booze, undefined, undefined, 0, 1, 1 );
    cane = generate_zombie_buildable_piece( "candy", "p6_zm_bu_sloth_candy_bowl", 32, 64, 2.4, "zom_hud_icon_buildable_sloth_candy", ::onpickup_candy, ::ondrop_candy, undefined, undefined, 0, 2, 1 );
    pencil = generate_zombie_buildable_piece( "chalk", "p6_zm_bu_chalk", 32, 64, 2.4, "zom_hud_icon_buildable_weap_chalk", ::onpickup_common, ::ondrop_chalk, undefined, undefined, 0, 4, 1 );
    key_chain = generate_zombie_buildable_piece( "keys_zm", "p6_zm_bu_sloth_key", 32, 64, 9, "zom_hud_icon_buildable_sloth_key", ::onpickup_keys, ::ondrop_keys, undefined, undefined, 0, 3, 1 );

    if ( isinarray( buildablesenabledlist, "turbine" ) )
    {
        turbine = spawnstruct();
        turbine.name = "turbine";
        turbine add_buildable_piece( turbine_fan );
        turbine add_buildable_piece( turbine_panel );
        turbine add_buildable_piece( turbine_body );
        turbine.onuseplantobject = ::onuseplantobject_turbine;
        turbine.triggerthink = ::turbinebuildable;
        include_buildable( turbine );
        maps\mp\zombies\_zm_buildables::hide_buildable_table_model( "turbine_buildable_trigger" );
    }

    if ( isinarray( buildablesenabledlist, "springpad_zm" ) )
    {
        springpad = spawnstruct();
        springpad.name = "springpad_zm";
        springpad add_buildable_piece( springpad_door );
        springpad add_buildable_piece( springpad_flag );
        springpad add_buildable_piece( springpad_motor );
        springpad add_buildable_piece( springpad_whistle );
        springpad.triggerthink = ::springpadbuildable;
       // include_buildable( springpad );
    }

    if ( isinarray( buildablesenabledlist, "sq_common" ) )
    {
        if ( is_sidequest_allowed( "zclassic" ) )
        {
            sqcommon = spawnstruct();
            sqcommon.name = "sq_common";
            sqcommon add_buildable_piece( sq_common_electricbox );
            sqcommon add_buildable_piece( sq_common_meteor );
            sqcommon add_buildable_piece( sq_common_scaffolding );
            sqcommon add_buildable_piece( sq_common_transceiver );
            sqcommon.triggerthink = ::sqcommonbuildable;
            include_buildable( sqcommon );
            maps\mp\zombies\_zm_buildables::hide_buildable_table_model( "sq_common_buildable_trigger" );
        }
    }

    if ( isinarray( buildablesenabledlist, "buried_sq_oillamp" ) )
    {
        if ( is_sidequest_allowed( "zclassic" ) )
        {
            sq_oillamp = spawnstruct();
            sq_oillamp.name = "buried_sq_oillamp";
            sq_oillamp add_buildable_piece( sq_lamp_piece );
            sq_oillamp.triggerthink = ::sqoillampbuildable;
            include_buildable( sq_oillamp );
        }
    }

    if ( isinarray( buildablesenabledlist, "buried_sq_bt_m_tower" ) )
    {
        if ( is_sidequest_allowed( "zclassic" ) )
        {
            sq_m_tower = spawnstruct();
            sq_m_tower.name = "buried_sq_bt_m_tower";
            sq_m_tower add_buildable_piece( sq_m_tower_vacuum_tube );
            sq_m_tower add_buildable_piece( sq_m_tower_battery );
            sq_m_tower add_buildable_piece( sq_s_tower_antenna, undefined, 1 );
            sq_m_tower add_buildable_piece( sq_s_tower_wire, undefined, 1 );
            sq_m_tower.triggerthink = ::sqmtowerbuildable;
            sq_m_tower.onuseplantobject = ::onuseplantobject_mtower;
            include_buildable( sq_m_tower );
        }
        else
            remove_maxis_tower();
    }

    if ( isinarray( buildablesenabledlist, "buried_sq_bt_r_tower" ) )
    {
        if ( is_sidequest_allowed( "zclassic" ) )
        {
            sq_r_tower = spawnstruct();
            sq_r_tower.name = "buried_sq_bt_r_tower";
            sq_r_tower add_buildable_piece( sq_r_tower_crystal );
            sq_r_tower add_buildable_piece( sq_r_tower_satellite );
            sq_r_tower add_buildable_piece( sq_s_tower_antenna, undefined, 1 );
            sq_r_tower add_buildable_piece( sq_s_tower_wire, undefined, 1 );
            sq_r_tower.triggerthink = ::sqrtowerbuildable;
            sq_r_tower.onuseplantobject = ::onuseplantobject_rtower;
            include_buildable( sq_r_tower );
        }
        else
            remove_ricky_tower();
    }

    if ( isinarray( buildablesenabledlist, "subwoofer_zm" ) )
    {
        subwoofer = spawnstruct();
        subwoofer.name = "subwoofer_zm";
        subwoofer add_buildable_piece( subwoofer_speaker );
        subwoofer add_buildable_piece( subwoofer_motor );
        subwoofer add_buildable_piece( subwoofer_table );
        subwoofer add_buildable_piece( subwoofer_mount );
        subwoofer.triggerthink = ::subwooferbuildable;
        include_buildable( subwoofer );
    }

    if ( isinarray( buildablesenabledlist, "headchopper_zm" ) )
    {
        ent = getent( "buildable_headchopper", "targetname" );
        ent setmodel( "t6_wpn_zmb_chopper" );
        headchopper = spawnstruct();
        headchopper.name = "headchopper_zm";
        headchopper add_buildable_piece( headchopper_blade );
        headchopper add_buildable_piece( headchopper_crank );
        headchopper add_buildable_piece( headchopper_hinge );
        headchopper add_buildable_piece( headchopper_mount );
        headchopper.triggerthink = ::headchopperbuildable;
        include_buildable( headchopper );
    }

    if ( isinarray( buildablesenabledlist, "booze" ) )
    {
        level.booze_model = "p6_zm_bu_sloth_booze_jug";
        precachemodel( level.booze_model );
        bottle.hint_grab = &"ZM_BURIED_BOOZE_G";
        bottle.hint_swap = &"ZM_BURIED_BOOZE_G";
        bottle manage_multiple_pieces( 2 );
        bottle.onspawn = ::piece_spawn_booze;
        bottle.onunspawn = ::piece_unspawn_booze;
        bottle.ondestroy = ::piece_destroy_booze;
        level.booze_piece = bottle;
        booze = spawnstruct();
        booze.name = "booze";
        booze.hint_more = &"ZM_BURIED_I_NEED_BOOZE";
        booze.hint_wrong = &"ZM_BURIED_I_SAID_BOOZE";
        booze add_buildable_piece( bottle );
        booze.triggerthink = ::boozebuildable;
        booze.onuseplantobject = ::onuseplantobject_booze_and_candy;
        include_buildable( booze );
    }

    if ( isinarray( buildablesenabledlist, "candy" ) )
    {
        level.candy_model = "p6_zm_bu_sloth_candy_bowl";
        precachemodel( level.candy_model );
        cane.hint_grab = &"ZM_BURIED_CANDY_G";
        cane.hint_swap = &"ZM_BURIED_CANDY_G";
        cane manage_multiple_pieces( 1 );
        cane.onspawn = ::piece_spawn_candy;
        cane.onunspawn = ::piece_unspawn_candy;
        cane.ondestroy = ::piece_destroy_candy;
        level.candy_piece = cane;
        candy = spawnstruct();
        candy.name = "candy";
        candy.hint_more = &"ZM_BURIED_I_WANT_CANDY";
        candy.hint_wrong = &"ZM_BURIED_THATS_NOT_CANDY";
        candy add_buildable_piece( cane );
        candy.triggerthink = ::candybuildable;
        candy.onuseplantobject = ::onuseplantobject_booze_and_candy;
        include_buildable( candy );
    }

    if ( isinarray( buildablesenabledlist, "sloth" ) )
    {
        sloth_buildable = spawnstruct();
        sloth_buildable.name = "sloth";
        sloth_buildable.hint_more = &"NULL_EMPTY";
        sloth_buildable.hint_wrong = &"NULL_EMPTY";
        sloth_buildable add_buildable_piece( bottle );
        sloth_buildable add_buildable_piece( cane );
        sloth_buildable.triggerthink = ::slothbuildable;
        sloth_buildable.onuseplantobject = ::onuseplantobject_sloth;
        sloth_buildable.snd_build_add_vo_override = ::empty;
        include_buildable( sloth_buildable );
    }

    if ( isinarray( buildablesenabledlist, "chalk" ) )
    {
        pencil.hint_grab = level.str_buildables_grab_part;
        pencil.hint_swap = level.str_buildables_swap_part;
        pencil.onspawn = ::piece_spawn_chalk;
        pencil.ondestroy = ::piece_destroy_chalk;
        pencil manage_multiple_pieces( 6, 6 );
        chalk = spawnstruct();
        chalk.name = "chalk";
        chalk.hint_more = &"NULL_EMPTY";
        chalk.hint_wrong = &"NULL_EMPTY";
        chalk add_buildable_piece( pencil );
        chalk.triggerthink = ::chalkbuildable;
        chalk.onuseplantobject = ::onuseplantobject_chalk;

        if ( isdefined( level.buy_random_wallbuys ) && level.buy_random_wallbuys )
            chalk.oncantuse = ::oncantuse_chalk;

        chalk.onbeginuse = ::onbeginuse_chalk;
        chalk.onenduse = ::onenduse_chalk;
        include_buildable( chalk );
    }

    if ( isinarray( buildablesenabledlist, "keys_zm" ) )
    {
        key_chain.onspawn = ::onspawn_keys;
        key_chain manage_multiple_pieces( 2 );
        key_chain.hint_grab = &"ZM_BURIED_KEY_G";
        key_chain.hint_swap = &"ZM_BURIED_KEY_G";
        key = spawnstruct();
        key.name = "keys_zm";
        key add_buildable_piece( key_chain );
        key.triggerthink = ::keysbuildable;
        key.onuseplantobject = ::onuseplantobject_key;
        key.hint_wrong = &"NULL_EMPTY";
        include_buildable( key );
    }

    generate_piece_makers();
    level thread maps\mp\zombies\_zm_buildables_pooled::randomize_pooled_buildables( "buried" );
}