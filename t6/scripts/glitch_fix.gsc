init()
{
    if (level.script == "zm_buried")
    {
        angles1 = (0, 0, 0);
        //tree
        pos1 = (1221.66, 668.30, 64.1656);
        //bank1
        pos2 = (-496.463, -353.429, 174.104);
        //bank2
        pos3 = (-500.475, -320.788, 190.151);
        //spawn
        pos4 = (-2861.92, -170.065, 1223.61);
        //spawn2
        pos5 = (-2861.92, -170.065, 1450.61);    

        //barriere gauche
        pos6 = (1695.22, 715.026, 90.0841);

        //barriere droite
        pos7 = (1643.07, 418.81, 89.9731);

        //barriere gauche coin
        pos8 = (1670.28, 1146.52, 90.3161);

        //barriere gauche a gauche du gauche
        pos9 = (1689.67, 823.039, 90.0031);

        generateInvisiblePerk(pos1, angles1);
            angles1 = (0, 90, 0); 

        generateInvisiblePerk(pos2, angles1);
        angles1 = (0, 0, 0);
    //   generateInvisiblePerk(pos3, angles1);
        angles1 = (0, 0, 0);
        generateInvisiblePerk(pos4, angles1);
        generateInvisiblePerk(pos5, angles1);     
        angles1 = (0, 90, 0);   
        generateInvisiblePerk(pos6, angles1);
        angles1 = (0, 90, 0); 
        generateInvisiblePerk(pos7, angles1);  
        generateInvisiblePerk(pos8, angles1);
        generateInvisiblePerk(pos9, angles1);
    } 
    if (level.script == "zm_highrise")
    {
        //meilleur zone pr tourner
        angles1 = (0, 180, 0);
        posd1 = (2311.39, 2068.4, 3143.68);
        generateInvisiblePerk(posd1, angles1); 

        //giga chad jump
        angles1 = (0, 0, 0);
        posd2 = (1769.13, 452.928, 2889.02);
        generateInvisiblePerk(posd2, angles1);             
    }    
}

generateInvisiblePerk(pos, angles)
{
    iWall = spawn( "script_model", pos );
	iWall setmodel( "zm_collision_perks1" );
	iWall.angles = angles;

	/*col = spawn( "script_model", pos);
	col setmodel( "zombie_vending_jugg_on" );
	col.angles = angles;*/
}

