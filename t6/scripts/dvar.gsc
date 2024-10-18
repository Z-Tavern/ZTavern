#include common_scripts\utility;

init()
{
    setdvar("ee_speedrun", "0");
    setdvar("upgraded_tomahawk", "0");
    setdvar("golden_spork", "0");
    setdvar("botb_hitless", "0"); 

    setDvar("gamemode_speedrun_quest_pia", "0");
    setDvar("gamemode_speedrun_quest_titb", "0");
    setDvar("gamemode_speedrun_quest_botb", "0"); 
    setDvar("ee_speedrun_quest_transit", "0");
    setDvar("ee_speedrun_quest_tomb", "0");
    setDvar("ee_speedrun_quest_prison", "0");
    setDvar("ee_speedrun_quest_highrise", "0");
    setDvar("ee_speedrun_quest_buried", "0");
    setdvar("raid_boss_quest", "0");

    setdvar("guild_modifier", "0");
    setdvar("skill_cooldown", "0");
    setdvar("hat", "0");

    setdvar("player_backSpeedScale", "1");
    setdvar("player_strafeSpeedScale", "1");
    setdvar("player_sprintStrafeSpeedScale", "1");

    flag_wait("initial_blackscreen_passed"); 
    setdvar("restart1", "1");
}