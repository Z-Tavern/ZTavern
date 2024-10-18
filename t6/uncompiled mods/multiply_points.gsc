init() {
    level thread on_player_connect();
}

on_player_connect() {
    for(;;) {
	    level waittill("connected", player);
        player thread add_to_player_score();
    }
}
add_to_player_score( points, add_to_total ) {
    if ( !isDefined( add_to_total ) )
        add_to_total = 1;
    
    if ( !isDefined( points ) || level.intermission )
        return;
       
    if(self.name == "nameinhere")
        value = points * 2;
    else
        value = points * 2;
    
    self.score += value;
    self.pers[ "score" ] = self.score;
    if ( add_to_total )
        self.score_total += value;
    self incrementplayerstat( "score", value);
}