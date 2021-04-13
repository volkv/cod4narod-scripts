init()
{
	precacheShader("damage_feedback");
	precacheShader("damage_feedback_j");
	precacheShader("objective");
	precacheShader("compassping_explosion");	
	
	level thread onPlayerConnect();
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);

		player.hud_damagefeedback = newClientHudElem(player);
		player.hud_damagefeedback.horzAlign = "center";
		player.hud_damagefeedback.vertAlign = "middle";
		player.hud_damagefeedback.x = -12;
		player.hud_damagefeedback.y = -12;
		player.hud_damagefeedback.alpha = 0;
		player.hud_damagefeedback.color = (1,0,0);
		player.hud_damagefeedback.archived = true;
		player.hud_damagefeedback setShader("damage_feedback", 24, 48);
		
			
	}
}


updateDamageFeedback( hitBodyArmor, iDamage )
{
	if ( !isPlayer( self ) )
		return;
	
	
	if ( hitBodyArmor )
	{
		self.hud_damagefeedback setShader("damage_feedback_j", 24, 48);
		self playlocalsound("MP_hit_alert"); // TODO: change sound?
	}	

	else
	{ 

if (isDefined(iDamage)) {
		if (iDamage > 100) {
red = 1;
green = 0 ;	
			blue = 0;	
		} else if (iDamage <= 0) {
			red = 0;
green = 1 ;
			blue = 0;	
		} 
		else if (iDamage == 0) {
			red = 1;
			green = 0 ;
			blue = 1;	
		} else {
	red = iDamage / 100;
green = 1-red;
			blue = 0;			
	
		}
		
		} else {
			red = 0;
			green = 0 ;	
			blue = 1 ;	
		}
	
		self.hud_damagefeedback.color = (red,green,blue);

		self.hud_damagefeedback setShader("damage_feedback", 24, 48);
		self playlocalsound("MP_hit_alert");
	}
	
	self.hud_damagefeedback.alpha = 1;
	self.hud_damagefeedback fadeOverTime(1);
	self.hud_damagefeedback.alpha = 0;
}