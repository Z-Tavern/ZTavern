main()
{
    replacefunc(maps\mp\zm_highrise_classic::escape_pod_are_all_alive_players_ready, ::escape_pod_are_all_alive_players_ready_custom);
}

init()
{
    level thread disable_spawn_elevator();
}

escape_pod_are_all_alive_players_ready_custom()
{
    players = level.players;
    players_in_escape_pod = 0;
    players_alive = 0;

    foreach ( player in players )
    {
        if ( player.sessionstate != "spectator" )
        {
            players_alive++;

            if ( player istouching( self ) && !(isdefined(level.is_first_room)))
                players_in_escape_pod++;
        }
    }
    if (players_alive == players_in_escape_pod)
    {
        level.is_spawn_elevator_used = 1;
    }
    return players_alive == players_in_escape_pod;
}

disable_spawn_elevator()
{
    for (;;)
    {
        escape_pod = getent( "elevator_bldg1a_body", "targetname" );
/*        escape_pod setmovingplatformenabled( 1 );
        escape_pod escapeelevatoruseanimtree();
        escape_pod_trigger = getent( "escape_pod_trigger", "targetname" );*/
        escape_pod.is_elevator = 0;
        wait 0.1;
    }

}