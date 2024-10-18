#include common_scripts\utility;
#include maps\mp\_utility;


init()
{
    setdvar("song", "0");
    flag_wait("initial_blackscreen_passed");
    level thread MusicPlayer();
}

MusicPlayer()
{
    if( getdvar( "mapname" ) == "zm_transit" )
	{
        for(;;)
        {
            if (getdvar("song") == "1")
            {
                playsoundatposition( "mus_zmb_secret_song", ( 0, 0, 0 ) );//260
                wait 260;
                setdvar("song", "0");
            }
            wait 0.1;
        }
	}
    if( getdvar( "mapname" ) == "zm_nuked" )
	{
        for(;;)
        {
            if (getdvar("song") == "1")
            {
                playsoundatposition( "zmb_nuked_song_1", ( 0, 0, 0 ) );//88
                wait 88;
                setdvar("song", "0");
            }
            if (getdvar("song") == "2")
            {
                playsoundatposition( "zmb_nuked_song_2", ( 0, 0, 0 ) );//60
                wait 60;
                setdvar("song", "0");
            }
            if (getdvar("song") == "3")
            {
                playsoundatposition( "zmb_nuked_song_3", ( 0, 0, 0 ) );//80
                wait 80;
                setdvar("song", "0");
            }
            if (getdvar("song") == "4")
            {
                playsoundatposition( "mus_zmb_secret_song", ( 0, 0, 0 ) );//260
                wait 260;
                setdvar("song", "0");
            }
            wait 0.1;
        }
	}
	if( getdvar( "mapname" ) == "zm_highrise" )
	{
        for(;;)
        {
            if (getdvar("song") == "1")
            {
                playsoundatposition( "mus_zmb_secret_song", ( 0, 0, 0 ) );//190
                wait 190;
                setdvar("song", "0");
            }
            wait 0.1;
        }
	}
	if( getdvar( "mapname" ) == "zm_prison" )
	{
        for(;;)
        {
            if (getdvar("song") == "1")
            {
                playsoundatposition( "mus_zmb_secret_song", ( 0, 0, 0 ) );//170
                wait 170;
                setdvar("song", "0");
            }
            if (getdvar("song") == "2")
            {
                playsoundatposition( "mus_zmb_secret_song_2", ( 0, 0, 0 ) );//150
                wait 150;
                setdvar("song", "0");
            }
            wait 0.1;
        }
	}
	if( getdvar( "mapname" ) == "zm_buried" )
	{
        for(;;)
        {
            if (getdvar("song") == "1")
            {
                playsoundatposition( "mus_zmb_secret_song", ( 0, 0, 0 ) );//363
                wait 363;
                setdvar("song", "0");
            }
            wait 0.1;
        }
	}
	if( getdvar( "mapname" ) == "zm_tomb" )
	{
        for(;;)
        {
            if (getdvar("song") == "1")
            {
                playsoundatposition( "mus_zmb_secret_song", ( 0, 0, 0 ) );//310
                wait 310;
                setdvar("song", "0");
            }
            if (getdvar("song") == "2")
            {
                playsoundatposition( "mus_zmb_secret_song_aether", ( 0, 0, 0 ) );//135
                wait 135;
                setdvar("song", "0");
            }
            if (getdvar("song") == "3")
            {
                playsoundatposition( "mus_zmb_secret_song_a7x", ( 0, 0, 0 ) );//352
                wait 352;
                setdvar("song", "0");
            }
            wait 0.1;
        }
	}
}