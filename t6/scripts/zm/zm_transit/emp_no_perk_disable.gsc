#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_perks;
#include maps\mp\_demo;
#include maps\mp\zombies\_zm_ai_basic;
//always add includes of the replaced functions
main()
{
    replaceFunc( maps\mp\zombies\_zm_power::change_power_in_radius, ::emp_no_perk_disable); //replace base function by custom function
}

emp_no_perk_disable( delta, origin, radius )
{
    changed_list = [];

if (level.script == "zm_transit")
{
    for ( i = 0; i < level.powered_items.size; i++ )
    {
        powered = level.powered_items[i]; // this is in base code and is equivalent to a foreach item in level.powered_items

        if (isdefined(powered.target) && powered.target) // check if target exist
        {
            if (isdefined(powered.target.script_noteworthy) && powered.target.script_noteworthy) // check if target name exist
            {
                powered_name = strTok(powered.target.script_noteworthy, "_"); //separate the target name using "_" (since we want only to avoid disabled perks and their name is "specialty_XXX"
                if ( powered.power_sources != 2 && powered_name[0] != "specialty") // in powered_named array, check if the first text element is different than "specialty"
                {
                    if ( powered [[ powered.range_func ]]( delta, origin, radius ) )
                    {
                        powered maps\mp\zombies\_zm_power::change_power( delta, origin, radius ); //if the replaced functions call other functions you must link the called function path
                        changed_list[changed_list.size] = powered;
                    }
                }
            }
         /*   else
            {
                iprintLn("^1Error^7, please contact ^1admin^7");
            }*/
        }
      /*  else
        {
            iprintLn("^1Error^7, please contact ^1admin^7");
        }*/
    }
    return changed_list;
}
else
{
    for ( i = 0; i < level.powered_items.size; i++ )
    {
        powered = level.powered_items[i];

        if ( powered.power_sources != 2 )
        {
            if ( powered [[ powered.range_func ]]( delta, origin, radius ) )
            {
                powered maps\mp\zombies\_zm_power::change_power( delta, origin, radius );
                changed_list[changed_list.size] = powered;
            }
        }
    }

    return changed_list;
}

}