#include maps\mp\_utility;


init()
{
    if (getDvar("mapname") == "zm_prison")
	    level._callbacks[ "on_player_connect" ][ 16 ] = ::player_lightning_manager_override;
}


player_lightning_manager_override()
{
	self setclientfieldtoplayer( "toggle_lightning", 0 );
}