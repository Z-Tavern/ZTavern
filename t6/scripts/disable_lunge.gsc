init()
{
    level thread on_player_connect();
}

on_player_connect()
{
  level endon("game_ended");

  for(;;)
  {
      level waittill("connected", player);
      player setClientDvar( "aim_automelee_enabled", 0 );
  }
}