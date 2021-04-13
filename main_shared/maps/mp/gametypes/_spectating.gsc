init()
{
	level.spectateOverride["allies"] = spawnstruct();
	level.spectateOverride["axis"] = spawnstruct();

	level thread onPlayerConnect();
}


onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);
		
		player thread onJoinedTeam();
		player thread onJoinedSpectators();
		player thread onPlayerSpawned();
	}
}


onPlayerSpawned()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("spawned_player");
		self setSpectatePermissions();
	}
}


onJoinedTeam()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("joined_team");
		self setSpectatePermissions();
	}
}

onJoinedSpectators()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("joined_spectators");
		self setSpectatePermissions();
	}
}


updateSpectateSettings()
{
	level endon ( "game_ended" );
	
	for ( index = 0; index < level.players.size; index++ )
		if(!isDefined(level.players[index].pers["isBot"]))
			level.players[index] setSpectatePermissions();
}


getOtherTeam( team )
{
	if ( team == "axis" )
		return "allies";
	else if ( team == "allies" )
		return "axis";
	else
		return "none";
}



setSpectatePermissions()
{
	// ** volkv spectatemode for members

	
			self allowSpectateTeam( "allies", true );
			self allowSpectateTeam( "axis", true );
			self allowSpectateTeam( "freelook", true );
			self allowSpectateTeam( "none", true );
		

			self allowSpectateTeam( "freelook", true );
		
	}

