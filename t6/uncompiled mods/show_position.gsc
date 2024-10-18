#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\zombies\_zm;
#include maps\mp\gametypes_zm\_hud_util;

init() {
    level thread on_player_connect();
}

on_player_connect() {
    for(;;) {
	    level waittill("connected", player);
        player thread show_pos_text();
    }
}

show_pos_text() {
    self endon("disconnect");
    level endon("end_game");
    flag_wait( "initial_blackscreen_passed" );

    debug_position_label_epic = createFontString("default", 1.5);
	debug_position_label_epic setPoint("TOPLEFT", "TOPLEFT", 15, 15);
    for (;;) {
        /*self.str = "";
        if (isDefined(level.zombie_spawn_locations)) {
            self.str += "level.zombie_spawn_locations:\n";
            foreach(position in level.zombie_spawn_locations) {
                if (isDefined(position)) {
                    self.str += "Position: " + position.origin + "\n";
                }
            }
        }*/
        
        local_origin = self getorigin();
        local_angles = self getplayerangles();
        self iprintln("Position: " + local_origin + "\nAngles: " + local_angles);
        //debug_position_label_epic settext("Position: " + local_origin + "\nAngles: " + local_angles);
        wait 5;
    }
}
