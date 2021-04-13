#include maps\mp\gametypes\_hud_util;

killcam(
	attackerNum, // entity number of the attacker
	killcamentity, // entity number of the attacker's killer entity aka helicopter or airstrike
	sWeapon, // killing weapon
	predelay, // time between player death and beginning of killcam
	offsetTime, // something to do with how far back in time the killer was seeing the world when he made the kill; latency related, sorta
	maxtime, // time remaining until map ends; the killcam will never last longer than this. undefined = no limit
	attacker, // entity object of attacker
	victim,  // entity object of victim
	time,
	sWeaponForKillcam
)
{
	self endon("disconnect");

	if(attackerNum < 0)
	{
		return;
	}
	
	self SetClientDvar( "ui_ShowMenuOnly", "class" );
	visionSetNaked( level.script );
		
	waittillframeend;
	
	if( isDefined( self.moneyhud ) )
		self.moneyhud destroy();

	// length from killcam start to killcam end
	if( sWeapon == "artillery_mp" )
	{
		if( isDefined( sWeaponForKillcam ) )
		{
			switch( sWeaponForKillcam )
			{
				case "ac180_105mm":
					camtime = 4;
					break;
				case "ac180_40mm":
					camtime = 3.5;
					break;
				case "ac180_25mm":
					camtime = 3;
					break;
				case "nuke_main":
					camtime = 4.5;
					break;
				case "nuke_rad":
					camtime = 3.5;
					break;
				case "agm":
					if( isDefined( level.AGMLaunchTime[ attackerNum ] ) && level.AGMLaunchTime[ attackerNum ] / 1000 < 8 )
						camtime = level.AGMLaunchTime[ attackerNum ] / 1000;
					else
						camtime = 2;

					break;
				case "artillery":
					camtime = 3.7;
					break;
				default:
					camtime = 2;
					break;
			}
		}
		else
			camtime = 2;
	}
	else if (sWeapon == "frag_grenade_mp")
		camtime = 4.5; // show long enough to see grenade thrown
	else
		camtime = 4;
		
	
	
	postdelay = 1.75;
	
	killcamlength = camtime + postdelay;
	
//	if( !isDefined( level.slowcaminit ) )
//	 thread slowMotion(camtime);
	 
	self.killcam = true;
	self.finalcam = true;

	killcamoffset = camtime + predelay;
	
	self notify ( "begin_killcam", getTime() );
	
	self thread finalHUD( attacker, victim );
	
	self.sessionstate = "spectator";
	self.spectatorclient = attackerNum;
	self.killcamentity = killcamentity;
		
	self.archivetime = (getTime() - time)/1000 + killcamoffset - 4.5;

	self.killcamlength = killcamlength;
	self.psoffsettime = offsetTime;

	// ignore spectate permissions
	self allowSpectateTeam("allies", true);
	self allowSpectateTeam("axis", true);
	self allowSpectateTeam("freelook", true);
	self allowSpectateTeam("none", true);
	
	// wait till the next server frame to allow code a chance to update archivetime if it needs trimming
	wait 0.05;

	if ( self.archivetime <= predelay ) // if we're not looking back in time far enough to even see the death, cancel
	{
		self.sessionstate = "dead";
		self.spectatorclient = -1;
		self.killcamentity = -1;
		self.archivetime = 0;
		self.psoffsettime = 0;
		self SetClientDvar( "ui_ShowMenuOnly", "" );
		
		return;
	}

	self thread spawnedKillcamCleanup();
	self thread endedKillcamCleanup();
	
	
	
	self thread waitKillcamTime();

	self waittill("end_killcam");

	self endKillcam();
		
	self.sessionstate = "dead";
	self.spectatorclient = -1;
	self.killcamentity = -1;
	self.archivetime = 0;
	self.psoffsettime = 0;
}

finalHUD( attacker, victim )
{
	self endon( "disconnect" );
	
	level.randomcolour = ( randomFloatRange( 0, 1 ), randomFloatRange( 0, 1 ), randomFloatRange( 0, 1 ) );

	self.kc_hud[ 3 ] = createFontString( "default", level.lowerTextFontSize );
	self.kc_hud[ 3 ] setPoint( "CENTER", "BOTTOM", -500, -60 ); 
	self.kc_hud[ 3 ].alignX = "right";
	self.kc_hud[ 3 ].archived = false;
	if( isDefined( attacker ) )
		self.kc_hud[ 3 ] setText( attacker.name );
	else
		self.kc_hud[ 3 ] setText( "[Player Disconnected]" );
	self.kc_hud[ 3 ].alpha = 1;
	self.kc_hud[ 3 ].glowalpha = 1;
	self.kc_hud[ 3 ].glowColor = level.randomcolour;
	self.kc_hud[ 3 ] moveOverTime( 2.5 );
	self.kc_hud[ 3 ].x = -20;  

	self.kc_hud[ 4 ] = createFontString( "default", level.lowerTextFontSize );
	self.kc_hud[ 4 ].alpha = 0;
	self.kc_hud[ 4 ] setPoint( "CENTER", "BOTTOM", 0, -60 );  
	self.kc_hud[ 4 ].archived = false;
	self.kc_hud[ 4 ] setText( "vs" );
	self.kc_hud[ 4 ].glowColor = level.randomcolour;
	self.kc_hud[ 4 ] fadeOverTime( 2.5 );
	self.kc_hud[ 4 ].alpha = 1;
  
	self.kc_hud[ 5 ] = createFontString( "default", level.lowerTextFontSize );
	self.kc_hud[ 5 ] setPoint( "CENTER", "BOTTOM", 500, -60 );
	self.kc_hud[ 5 ].alignX = "left";  
	self.kc_hud[ 5 ].archived = false;
	if( isDefined( victim ) )
		self.kc_hud[ 5 ] setText( victim.name );
	else
		self.kc_hud[ 5 ] setText( "[Player Disconnected]" );
	self.kc_hud[ 5 ].glowalpha = 1; 
	self.kc_hud[ 5 ].glowColor = level.randomcolour;
	self.kc_hud[ 5 ] moveOverTime( 2.5 );
	self.kc_hud[ 5 ].x = 20; 
	
	if( isDefined( self.kc_hud ) && isDefined( self.kc_hud[ 0 ] ) )
	{
		for( i = 0; i < 3; i++ )
		{
			if( isDefined( self.kc_hud[ i ] ) )
				self.kc_hud[ i ] destroy();
		}
	}
	
	self.kc_hud[ 0 ] = newClientHudElem( self );
	self.kc_hud[ 0 ].alpha = 1;
	self.kc_hud[ 0 ].y = 15;
	self.kc_hud[ 0 ].alignX = "center";
	self.kc_hud[ 0 ].alignY = "middle";
	self.kc_hud[ 0 ].horzAlign = "center";
	self.kc_hud[ 0 ].vertAlign = "top";
	self.kc_hud[ 0 ].archived = false;
	self.kc_hud[ 0 ].fontscale = 2.2;
	self.kc_hud[ 0 ] setText( self volkv\_common::getLangString("KC_FINAL"));
	
	self.kc_hud[ 1 ] = newClientHudElem( self );
	self.kc_hud[ 1 ].alpha = 0.25;
	self.kc_hud[ 1 ] setShader( "white", 640, 30 );
	self.kc_hud[ 1 ].color	= (1, 1, 1);
	self.kc_hud[ 1 ].horzAlign = "fullscreen";
	self.kc_hud[ 1 ].vertAlign = "fullscreen";
	self.kc_hud[ 1 ].archived = false;
	
	self.kc_hud[ 2 ] = newClientHudElem( self );
	self.kc_hud[ 2 ].alpha = 0.25;
	self.kc_hud[ 2 ] setShader( "white", 640, 30 );
	self.kc_hud[ 2 ].color	= (1, 1, 1);
	self.kc_hud[ 2 ].horzAlign = "fullscreen";
	self.kc_hud[ 2 ].vertAlign = "fullscreen";
	self.kc_hud[ 2 ].archived = false;
	self.kc_hud[ 2 ].y = 450;
}

finalHUDPVP( attacker, victim )
{
	self endon( "disconnect" );
	
	level.randomcolour = ( randomFloatRange( 0, 1 ), randomFloatRange( 0, 1 ), randomFloatRange( 0, 1 ) );

	self.pvp_hud[ 0 ] = createFontString( "default", level.lowerTextFontSize );
	self.pvp_hud[ 0 ] setPoint( "CENTER", "CENTER", -500, 60); 
	self.pvp_hud[ 0 ].alignX = "right";
	self.pvp_hud[ 0 ].archived = false;
	if( isDefined( attacker ) )
		self.pvp_hud[ 0 ] setText( attacker.name );
	else
		self.pvp_hud[ 0 ] setText( "[Player Disconnected]" );
	self.pvp_hud[ 0 ].alpha = 1;
	self.pvp_hud[ 0 ].glowalpha = 1;
	self.pvp_hud[ 0 ].glowColor = level.randomcolour;
	self.pvp_hud[ 0 ] moveOverTime( 2 );
	self.pvp_hud[ 0 ].x = -20;  

	self.pvp_hud[ 1 ] = createFontString( "default", level.lowerTextFontSize );
	self.pvp_hud[ 1 ].alpha = 0;
	self.pvp_hud[ 1 ] setPoint( "CENTER", "CENTER", 0, 60 );  
	self.pvp_hud[ 1 ].archived = false;
	self.pvp_hud[ 1 ] setText( "vs" );
	self.pvp_hud[ 1 ].glowColor = level.randomcolour;
	self.pvp_hud[ 1 ] fadeOverTime( 2.5 );
	self.pvp_hud[ 1 ].alpha = 1;
  
	self.pvp_hud[ 2 ] = createFontString( "default", level.lowerTextFontSize );
	self.pvp_hud[ 2 ] setPoint( "CENTER", "CENTER", 500, 60 );
	self.pvp_hud[ 2 ].alignX = "left";  
	self.pvp_hud[ 2 ].archived = false;
	if( isDefined( victim ) )
		self.pvp_hud[ 2 ] setText( victim.name );
	else
		self.pvp_hud[ 2 ] setText( "[Player Disconnected]" );
	self.pvp_hud[ 2 ].glowalpha = 1; 
	self.pvp_hud[ 2 ].glowColor = level.randomcolour;
	self.pvp_hud[ 2 ] moveOverTime( 2 );
	self.pvp_hud[ 2 ].x = 20; 
	
	
	self.pvp_hud[ 3 ] = createFontString( "default", 2.2 );
	self.pvp_hud[ 3 ] setPoint( "CENTER", "CENTER", 0, -60 );
	self.pvp_hud[ 3 ].alignX = "center";
	self.pvp_hud[ 3 ].alignY = "middle";
	self.pvp_hud[ 3 ].horzAlign = "center";
	self.pvp_hud[ 3 ].vertAlign = "middle";
	self.pvp_hud[ 3 ].archived = false;
	self.pvp_hud[ 3 ] setText(self volkv\_common::getLangString("BEST_PL_FIGHT"));
	
	
	wait 5;
	
		if( isArray( self.pvp_hud ) )
	{
		for( i = 0; i < 4; i++ )
		{
			if( isDefined( self.pvp_hud[ i ] ) )
				self.pvp_hud[ i ] destroy();
		}
	}
	self.pvp_hud = undefined;
}

waitKillcamTime()
{
	self endon("disconnect");
	self endon("end_killcam");

	wait(self.killcamlength - 0.05);
	self notify("end_killcam");
}


slowMotion(killcamlength)
{
    level.slowcaminit = true;
	
    wait killcamlength - 1.9;

	setDvar( "timescale", "0.390625" );
	
	wait(4); 
	
	setDvar("timescale","1");
	
}


endKillcam()
{
	if( isArray( self.kc_hud ) )
	{
		for( i = 0; i < self.kc_hud.size; i++ )
		{
			if( isDefined( self.kc_hud[ i ] ) )
				self.kc_hud[ i ] destroy();
		}
	}
	self.kc_hud = undefined;
	
	self.visiondata = undefined;
	
	
	self.killcam = undefined;
	self.finalcam = undefined;
	
	self SetClientDvar( "ui_ShowMenuOnly", "" );
	
	self thread maps\mp\gametypes\_spectating::setSpectatePermissions();
}

spawnedKillcamCleanup()
{
	self endon("end_killcam");
	self endon("disconnect");

	self waittill("spawned");
	self endKillcam();
	self notify("end_killcam");
}

spectatorKillcamCleanup( attacker )
{
	self endon("end_killcam");
	self endon("disconnect");
	attacker endon ( "disconnect" );

	attacker waittill ( "begin_killcam", attackerKcStartTime );
	waitTime = max( 0, (attackerKcStartTime - self.deathTime) - 50 );
	wait (waitTime);
	self endKillcam();
	self notify("end_killcam");
}

endedKillcamCleanup()
{
	self endon("end_killcam");
	self endon("disconnect");

	level waittill("game_ended");
	self endKillcam();
	self notify("end_killcam");
}