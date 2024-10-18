#include maps/mp/gametypes_zm/_hud_message;
#include maps/mp/gametypes_zm/_hud_util;

onplayerconnected()
{
	for ( ;; )
	{
		level waittill( "connected", player );
		player thread displayScore(); //add this line
	}
}

toggleScore()
{
	//self waittill("spawned_player");
	if(!isDefined(self.scoretext))
	{
        self.scoreText = CreateFontString("Objective", 1.5);
        self.scoretext setPoint("CENTER", "RIGHT", "CENTER", "RIGHT");
        self.scoreText.label = &"^2Score: ^7";
        self.scoretext.alpha = 0;	  	
	}
	else if(getplayers().size >= 5 && self.scoretext.alpha == 0)
	{
	  self.scoretext.alpha = 1;
      if(self.scoreInUse == 0)
      	self thread displayScore();	
	}
  	else if(getplayers().size < 5 && self.scoretext.alpha == 1)
	{
	  self.scoretext.alpha = 0;
	  self.scoreInUse = 0;
	}
}

displayScore()
{
	self endon( "disconnect" );
	level endon( "end_game" );
	self.scoreText = CreateFontString("Objective", 1.5);
	self.scoretext setPoint("CENTER", "RIGHT", "CENTER", "RIGHT");
	self.scoreText.label = &"^2Score: ^7";
	self.scoretext.alpha = 0;
	while(true)
	{
		self.scoretext SetValue(self.score);
		if(getplayers().size >= 5 && self.scoretext.alpha == 0)
		{
			self.scoretext FadeOverTime( 1 );
			self.scoretext.alpha = 1;
		}
		else if(getplayers().size < 5 && self.scoretext.alpha >= 0)
		{
			self.scoretext FadeOverTime( 1 );
			self.scoretext.alpha = 0;
		}
		wait 0.1;
	}
}