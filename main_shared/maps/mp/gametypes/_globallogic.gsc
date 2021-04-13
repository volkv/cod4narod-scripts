#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

init()
{
	setExpFog( 100000000000, 100000000001, 0, 0, 0, 0 );

	if ( !isDefined( level.tweakablesInitialized ) )
		maps\mp\gametypes\_tweakables::init();

	if ( getDvar( "scr_player_sprinttime" ) == "" )
		setDvar( "scr_player_sprinttime", getDvar( "player_sprintTime" ) );

	level.splitscreen = false;
	level.xenon = false;
	level.ps3 = false;
	level.onlineGame = true;
	level.console = false;

	level.hardEffects[ "artilleryExp" ] = loadfx("explosions/artilleryExp_dirt_brown");
	level.hardEffects[ "hellfireGeo" ] = loadfx("smoke/smoke_geotrail_hellfire");
	level.hardEffects[ "tankerExp" ] = loadfx( "explosions/tanker_explosion" );
	level.hardEffects[ "smallExp" ] = loadfx( "impacts/large_mud" );

	precacheShader( "waypoint_kill" );
	precacheShader( "killiconsuicide" );
	precacheShader( "killiconmelee" );
	precacheShader( "killiconheadshot" );
	precacheShader( "killicondied" );
	precacheShader( "killiconimpact" );
	precacheShader( "hud_us_grenade" );
	precacheShader( "ui_host" );
	precacheShader( "hint_health" );
	precacheShader( "hud_bullets_spread" );
	precacheShader( "ui_slider2" );
	precacheShader( "hud_teamcaret" );
	precacheShader( "weapon_c4" );
	precacheShader( "weapon_remington700" );
	precacheShader( "weapon_rpg7" );
	precacheShader( "weapon_desert_eagle_gold" );
	precacheShader( "weapon_fraggrenade" );
	precacheShader( "weapon_attachment_m203" );
	precacheShader( "compass_objpoint_helicopter" );

	precacheStatusIcon("rank_prestige1");
	precacheStatusIcon("rank_prestige6");
	precacheStatusIcon("rank_prestige2");
	precacheStatusIcon("rank_prestige4");
	precacheStatusIcon("rank_prestige8");
	precacheStatusIcon("rank_prestige9");
	precacheStatusIcon("rank_prestige10");

	precacheShader("rank_prestige1");
	precacheShader("rank_prestige6");
	precacheShader("rank_prestige2");
	precacheShader("rank_prestige4");
	precacheShader("rank_prestige8");
	precacheShader("rank_prestige9");
	precacheShader("rank_prestige10");


	level.rankedMatch = true;


	level.script = toLower( getDvar( "mapname" ) );
	level.gametype = toLower( getDvar( "g_gametype" ) );

	thread volkv\events::init();

	level.otherTeam["allies"] = "axis";
	level.otherTeam["axis"] = "allies";

	level.teamBased = false;

	level.reaper = false;
	level.predatorInProgress = false;
	level.firstblood = false;
	level.numKills = 0;
	level.instrattime = false;
	level.clock = false;

	level.overrideTeamScore = false;
	level.overridePlayerScore = false;
	level.displayHalftimeText = false;
	level.displayRoundEndText = true;

	level.endGameOnScoreLimit = true;
	level.endGameOnTimeLimit = true;

	precacheString( &"MP_HALFTIME" );
	precacheString( &"MP_OVERTIME" );
	precacheString( &"MP_ROUNDEND" );
	precacheString( &"MP_INTERMISSION" );
	precacheString( &"MP_SWITCHING_SIDES" );
	precacheString( &"MP_FRIENDLY_FIRE_WILL_NOT" );

	precacheString( &"MP_HOST_ENDED_GAME" );

	level.halftimeType = "halftime";
	level.halftimeSubCaption = &"MP_SWITCHING_SIDES";

	level.lastStatusTime = 0;
	level.wasWinning = "none";

	level.lastSlowProcessFrame = 0;

	level.placement["allies"] = [];
	level.placement["axis"] = [];
	level.placement["all"] = [];

	level.postRoundTime = 1;

	level.inOvertime = false;

	level.dropTeam = getdvarint( "sv_maxclients" );

	registerDvars();
	maps\mp\gametypes\_class::initPerkDvars();

	if (getdvarint( "sniper" ) == 1) {
		level thread sniper::newInit();
		setDvar( "loc_warnings", 0 );
	}

	level.oldschool = ( getDvarInt( "scr_oldschool" ) == 1 );
	if ( level.oldschool )
	{
		logString( "game mode: oldschool" );

		setDvar( "jump_height", 64 );
		setDvar( "jump_slowdownEnable", 0 );
		setDvar( "bg_fallDamageMinHeight", 256 );
		setDvar( "bg_fallDamageMaxHeight", 512 );
	}

	precacheModel( "vehicle_mig29_desert" );
	precacheModel( "projectile_cbu97_clusterbomb" );
	precacheModel( "tag_origin" );

	precacheShader( "faction_128_usmc" );
	precacheShader( "faction_128_arab" );
	precacheShader( "faction_128_ussr" );
	precacheShader( "faction_128_sas" );


	precacheShader( "hint_usable" );
	precacheShader( "gradient" );
	precacheShader( "gradient_fadein" );
	precacheShader("gradient_top");
	precacheShader("gradient_bottom");
	precacheShader("line_horizontal");

	precacheItem( "flash_grenade_mp" );
	precacheItem( "claymore_mp" );
	precacheItem( "c4_mp" );


	level.fx_airstrike_afterburner = loadfx ("fire/jet_afterburner");
	level.fx_airstrike_contrail = loadfx ("smoke/jet_contrail");

	if ( !isDefined( game["tiebreaker"] ) )
		game["tiebreaker"] = false;


}

registerDvars()
{

	setDvar( "player_sprinttime", "8" );
	setDvar( "g_gravity", "650" );
	setDvar( "g_speed", "205" );
	setDvar("bg_fallDamageMaxHeight","450");
	setDvar("bg_fallDamageMinHeight","180");


	if ( getdvar( "scr_oldschool" ) == "" )
		setdvar( "scr_oldschool", "0" );

	makeDvarServerInfo( "scr_oldschool" );

	setDvar( "ui_bomb_timer", 0 );
	makeDvarServerInfo( "ui_bomb_timer" );


	if ( getDvar( "scr_show_unlock_wait" ) == "" )
		setDvar( "scr_show_unlock_wait", 0.1 );

	if ( getDvar( "scr_intermission_time" ) == "" )
		setDvar( "scr_intermission_time", 30.0 );
}

SetupCallbacks()
{
	level.onScriptCommand = ::blank;
	level.spawnPlayer = ::spawnPlayer;
	level.spawnClient = ::spawnClient;
	level.spawnSpectator = ::spawnSpectator;
	level.spawnIntermission = ::spawnIntermission;
	level.onPlayerScore = ::default_onPlayerScore;
	level.onPlayerScore_score = ::default_onPlayerScore_score;
	level.onTeamScore = ::default_onTeamScore;
	level.onTeamScore_score = ::default_onTeamScore_score;

	level.onXPEvent = ::onXPEvent;
	level.waveSpawnTimer = ::waveSpawnTimer;

	level.onSpawnPlayer = ::blank;
	level.onSpawnSpectator = ::default_onSpawnSpectator;
	level.onSpawnIntermission = ::default_onSpawnIntermission;
	level.onRespawnDelay = ::blank;

	level.onForfeit = ::default_onForfeit;
	level.onTimeLimit = ::default_onTimeLimit;
	level.onScoreLimit = ::default_onScoreLimit;
	level.onDeadEvent = ::default_onDeadEvent;
	level.onOneLeftEvent = ::default_onOneLeftEvent;
	level.giveTeamScore = ::giveTeamScore;
	level.givePlayerScore = ::givePlayerScore;

	level._setTeamScore = ::_setTeamScore;
	level._setPlayerScore = ::_setPlayerScore;

	level._getTeamScore = ::_getTeamScore;
	level._getPlayerScore = ::_getPlayerScore;

	level.onPrecacheGametype = ::blank;
	level.onStartGameType = ::blank;
	level.onPlayerConnect = ::blank;
	level.onPlayerDisconnect = ::blank;
	level.onPlayerDamage = ::blank;
	level.onPlayerKilled = ::blank;

	level.onEndGame = ::blank;

	level.autoassign = ::menuAutoAssign;
	level.spectator = ::menuSpectator;
	level.class = ::menuClass;
	level.allies = ::menuAllies;
	level.axis = ::menuAxis;
}

blank( arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10 )
{
}

WaitTillSlowProcessAllowed()
{

	if ( level.lastSlowProcessFrame == gettime() )
	{
		wait .05;
		if ( level.lastSlowProcessFrame == gettime() )
		{
			wait .05;
			if ( level.lastSlowProcessFrame == gettime() )
			{
				wait .05;
				if ( level.lastSlowProcessFrame == gettime() )
				{
					wait .05;
				}
			}
		}
	}

	level.lastSlowProcessFrame = gettime();
}


default_onForfeit( team )
{
	level notify ( "forfeit in progress" );
	level endon( "forfeit in progress" );
	level endon( "abort forfeit" );

	if ( !level.teambased && level.players.size > 1 )
		wait 10;

	forfeit_delay = 20.0;

	announcement( game["strings"]["opponent_forfeiting_in"], forfeit_delay );
	wait (10.0);
	announcement( game["strings"]["opponent_forfeiting_in"], 10.0 );
	wait (10.0);

	endReason = &"";
	if ( !isDefined( team ) )
	{
		setDvar( "ui_text_endreason", game["strings"]["players_forfeited"] );
		endReason = game["strings"]["players_forfeited"];
		winner = level.players[0];
	}
	else if ( team == "allies" )
	{
		setDvar( "ui_text_endreason", game["strings"]["allies_forfeited"] );
		endReason = game["strings"]["allies_forfeited"];
		winner = "axis";
	}
	else if ( team == "axis" )
	{
		setDvar( "ui_text_endreason", game["strings"]["axis_forfeited"] );
		endReason = game["strings"]["axis_forfeited"];
		winner = "allies";
	}
	else
	{
		assertEx( isdefined( team ), "Forfeited team is not defined" );
		assertEx( 0, "Forfeited team " + team + " is not allies or axis" );
		winner = "tie";
	}
	level.forcedEnd = true;

	if ( isPlayer( winner ) )
		logString( "forfeit, win: " + winner getXuid() + "(" + winner.name + ")" );
	else
		logString( "forfeit, win: " + winner + ", allies: " + game["teamScores"]["allies"] + ", opfor: " + game["teamScores"]["axis"] );
	thread endGame( winner, endReason );
}


default_onDeadEvent( team )
{
	if ( team == "allies" )
	{
		iPrintLn( game["strings"]["allies_eliminated"] );
		makeDvarServerInfo( "ui_text_endreason", game["strings"]["allies_eliminated"] );
		setDvar( "ui_text_endreason", game["strings"]["allies_eliminated"] );

		logString( "team eliminated, win: opfor, allies: " + game["teamScores"]["allies"] + ", opfor: " + game["teamScores"]["axis"] );

		thread endGame( "axis", game["strings"]["allies_eliminated"] );
	}
	else if ( team == "axis" )
	{
		iPrintLn( game["strings"]["axis_eliminated"] );
		makeDvarServerInfo( "ui_text_endreason", game["strings"]["axis_eliminated"] );
		setDvar( "ui_text_endreason", game["strings"]["axis_eliminated"] );

		logString( "team eliminated, win: allies, allies: " + game["teamScores"]["allies"] + ", opfor: " + game["teamScores"]["axis"] );

		thread endGame( "allies", game["strings"]["axis_eliminated"] );
	}
	else
	{
		makeDvarServerInfo( "ui_text_endreason", game["strings"]["tie"] );
		setDvar( "ui_text_endreason", game["strings"]["tie"] );

		logString( "tie, allies: " + game["teamScores"]["allies"] + ", opfor: " + game["teamScores"]["axis"] );

		if ( level.teamBased )
			thread endGame( "tie", game["strings"]["tie"] );
		else
			thread endGame( undefined, game["strings"]["tie"] );
	}
}


default_onOneLeftEvent( team )
{
	if ( !level.teamBased )
	{
		winner = getHighestScoringPlayer();

		if ( isDefined( winner ) )
			logString( "last one alive, win: " + winner.name );
		else
			logString( "last one alive, win: unknown" );

		thread endGame( winner, &"MP_ENEMIES_ELIMINATED" );
	}
	else
	{
		for ( index = 0; index < level.players.size; index++ )
		{
			player = level.players[index];

			if ( !isAlive( player ) )
				continue;

			if ( !isDefined( player.pers["team"] ) || player.pers["team"] != team )
				continue;

			player maps\mp\gametypes\_globallogic::leaderDialogOnPlayer( "last_alive" );
		}
	}
}


default_onTimeLimit()
{
	winner = undefined;

	if ( level.teamBased )
	{
		if ( game["teamScores"]["allies"] == game["teamScores"]["axis"] )
			winner = "tie";
		else if ( game["teamScores"]["axis"] > game["teamScores"]["allies"] )
			winner = "axis";
		else
			winner = "allies";

		logString( "time limit, win: " + winner + ", allies: " + game["teamScores"]["allies"] + ", opfor: " + game["teamScores"]["axis"] );
	}
	else
	{
		winner = getHighestScoringPlayer();

		if ( isDefined( winner ) )
			logString( "time limit, win: " + winner.name );
		else
			logString( "time limit, tie" );
	}

	makeDvarServerInfo( "ui_text_endreason", game["strings"]["time_limit_reached"] );
	setDvar( "ui_text_endreason", game["strings"]["time_limit_reached"] );

	thread endGame( winner, game["strings"]["time_limit_reached"] );
}


forceEnd()
{
	if ( level.hostForcedEnd || level.forcedEnd )
		return;

	winner = undefined;

	if ( level.teamBased )
	{
		if ( game["teamScores"]["allies"] == game["teamScores"]["axis"] )
			winner = "tie";
		else if ( game["teamScores"]["axis"] > game["teamScores"]["allies"] )
			winner = "axis";
		else
			winner = "allies";
		logString( "host ended game, win: " + winner + ", allies: " + game["teamScores"]["allies"] + ", opfor: " + game["teamScores"]["axis"] );
	}
	else
	{
		winner = getHighestScoringPlayer();
		if ( isDefined( winner ) )
			logString( "host ended game, win: " + winner.name );
		else
			logString( "host ended game, tie" );
	}

	level.forcedEnd = true;
	level.hostForcedEnd = true;

	endString = &"MP_HOST_ENDED_GAME";

	makeDvarServerInfo( "ui_text_endreason", endString );
	setDvar( "ui_text_endreason", endString );
	thread endGame( winner, endString );
}


default_onScoreLimit()
{
	if ( !level.endGameOnScoreLimit )
		return;

	winner = undefined;

	if ( level.teamBased )
	{
		if ( game["teamScores"]["allies"] == game["teamScores"]["axis"] )
			winner = "tie";
		else if ( game["teamScores"]["axis"] > game["teamScores"]["allies"] )
			winner = "axis";
		else
			winner = "allies";
		logString( "scorelimit, win: " + winner + ", allies: " + game["teamScores"]["allies"] + ", opfor: " + game["teamScores"]["axis"] );
	}
	else
	{
		winner = getHighestScoringPlayer();
		if ( isDefined( winner ) )
			logString( "scorelimit, win: " + winner.name );
		else
			logString( "scorelimit, tie" );
	}

	makeDvarServerInfo( "ui_text_endreason", game["strings"]["score_limit_reached"] );
	setDvar( "ui_text_endreason", game["strings"]["score_limit_reached"] );

	level.forcedEnd = true; // no more rounds if scorelimit is hit
	thread endGame( winner, game["strings"]["score_limit_reached"] );
}


updateGameEvents()
{
	if ( level.rankedMatch && !level.inGracePeriod )
	{
		if ( level.teamBased )
		{
			if ( (level.everExisted["allies"]) && level.playerCount["allies"] < 1 && level.playerCount["axis"] > 0 && game["state"] == "playing" )
			{
				thread [[level.onForfeit]]( "allies" );
				return;
			}

			if ( (level.everExisted["axis"]) && level.playerCount["axis"] < 1 && level.playerCount["allies"] > 0 && game["state"] == "playing" )
			{
				thread [[level.onForfeit]]( "axis" );
				return;
			}

			if ( level.playerCount["axis"] > 0 && level.playerCount["allies"] > 0 )
				level notify( "abort forfeit" );
		}
		else
		{
			if ( level.playerCount["allies"] + level.playerCount["axis"] == 1 && level.maxPlayerCount > 1 )
			{
				thread [[level.onForfeit]]();
				return;
			}

			if ( level.playerCount["axis"] + level.playerCount["allies"] > 1 )
				level notify( "abort forfeit" );
		}
	}

	if ( !level.numLives && !level.inOverTime )
		return;

	if ( level.inGracePeriod )
		return;

	if ( level.teamBased )
	{
		if ( level.everExisted["allies"] && !level.aliveCount["allies"] && level.everExisted["axis"] && !level.aliveCount["axis"] && !level.playerLives["allies"] && !level.playerLives["axis"] )
		{
			[[level.onDeadEvent]]( "all" );
			return;
		}

		if ( level.everExisted["allies"] && !level.aliveCount["allies"] && !level.playerLives["allies"] )
		{
			[[level.onDeadEvent]]( "allies" );
			return;
		}

		if ( level.everExisted["axis"] && !level.aliveCount["axis"] && !level.playerLives["axis"] )
		{
			[[level.onDeadEvent]]( "axis" );
			return;
		}

		if ( level.lastAliveCount["allies"] > 1 && level.aliveCount["allies"] == 1 && level.playerLives["allies"] == 1 )
		{
			[[level.onOneLeftEvent]]( "allies" );
			return;
		}

		if ( level.lastAliveCount["axis"] > 1 && level.aliveCount["axis"] == 1 && level.playerLives["axis"] == 1 )
		{
			[[level.onOneLeftEvent]]( "axis" );
			return;
		}
	}
	else
	{
		if ( (!level.aliveCount["allies"] && !level.aliveCount["axis"]) && (!level.playerLives["allies"] && !level.playerLives["axis"]) && level.maxPlayerCount > 1 )
		{
			[[level.onDeadEvent]]( "all" );
			return;
		}

		if ( (level.aliveCount["allies"] + level.aliveCount["axis"] == 1) && (level.playerLives["allies"] + level.playerLives["axis"] == 1) && level.maxPlayerCount > 1 )
		{
			[[level.onOneLeftEvent]]( "all" );
			return;
		}
	}
}

matchStartTimer()
{
	visionSetNaked( "mpIntro", 0 );

	level.instrattime = true;
	matchStartText = createServerFontString( "objective", 1.5 );
	matchStartText setPoint( "CENTER", "CENTER", 0, -20 );
	matchStartText.sort = 1001;
	matchStartText setText( game["strings"]["waiting_for_teams"] );
	matchStartText.foreground = false;
	matchStartText.hidewheninmenu = true;

	matchStartTimer = createServerTimer( "objective", 1.4 );
	matchStartTimer setPoint( "CENTER", "CENTER", 0, 0 );
	matchStartTimer setTimer( level.prematchPeriod );
	matchStartTimer.sort = 1001;
	matchStartTimer.foreground = false;
	matchStartTimer.hideWhenInMenu = true;

	waitForPlayers( level.prematchPeriod );

	if ( level.prematchPeriodEnd > 0 )
	{
		matchStartText setText( game["strings"]["match_starting_in"] );
		matchStartTimer setTimer( level.prematchPeriodEnd );

		wait level.prematchPeriodEnd;
	}

	visionSetNaked( getDvar( "mapname" ), 2.0 );
	level.instrattime = false;
	level notify("clock_over");
	matchStartText destroyElem();
	matchStartTimer destroyElem();
}

matchStartTimerSkip()
{
	visionSetNaked( getDvar( "mapname" ), 0 );
}

defaultHealth() {

	if (level.dominat[self.pers["team"]] == true)
		HPbonus = 0;
	else
		HPbonus = self.HPbonus;

	if ( level.hardcoreMode ) {

		self.maxhealth = 30 + HPbonus;

	} else if ( level.oldschool ) {
		self.maxhealth = 200 + HPbonus;
	} else {

		self.maxhealth = 100 + HPbonus;
	}

	if (isDefined(self.postgameok))
		self.maxhealth = 300;

	if (self.pers["knifemode"])
		self.maxhealth = 200;

	self.health = self.maxhealth;
}


spawnPlayer()
{
	prof_begin( "spawnPlayer_preUTS" );

	self endon("disconnect");
	self endon("joined_spectators");
	self notify("spawned");
	self notify("end_respawn");
	self setSpawnVariables();

	if ( level.teamBased )
		self.sessionteam = self.team;
	else
		self.sessionteam = "none";

	hadSpawned = self.hasSpawned;

	self.sessionstate = "playing";
	self.spectatorclient = -1;
	self.killcamentity = -1;
	self.archivetime = 0;
	self.psoffsettime = 0;




	if (self.pers["knife"] == false)
		self.pers["knifemode"] = false;
	else
		self.pers["knifemode"] = true;

	if (level.event)
		self.pers["knifemode"] = false;

	if (isDefined(self.pers["statusIcon"]))
		self.statusIcon = self.pers["statusIcon"];


	self.multipl_anticamp = 1;


	self defaultHealth();

	self.friendlydamage = undefined;
	self.hasSpawned = true;
	self.spawnTime = getTime();
	self.afk = false;
	if ( self.pers["lives"] )
		self.pers["lives"]--;
	self.lastStand = undefined;

	if ( !self.wasAliveAtMatchStart )
	{
		acceptablePassedTime = 20;
		if ( level.timeLimit > 0 && acceptablePassedTime < level.timeLimit * 60 / 4 )
			acceptablePassedTime = level.timeLimit * 60 / 4;

		if ( level.inGracePeriod || getTimePassed() < acceptablePassedTime * 1000 )
			self.wasAliveAtMatchStart = true;
	}


	[[level.onSpawnPlayer]]();

	if (isDefined(level.instrattime) && level.instrattime)
		self thread volkv\_common::setPlayerSpeed(0); // ** fixes the frame walk bug

	self maps\mp\gametypes\_missions::playerSpawned();

	prof_end( "spawnPlayer_preUTS" );

	level thread updateTeamStatus();

	prof_begin( "spawnPlayer_postUTS" );


	if ( level.oldschool )
	{
		assert( !isDefined( self.class ) );
		self maps\mp\gametypes\_oldschool::giveLoadout();
		self maps\mp\gametypes\_class::setClass( level.defaultClass );
	}
	else if (!self.inTrainingArea)
	{

		if (!isDefined(self.pers["primaryWeapon"]) || !isDefined(self.class)) {
			self maps\mp\gametypes\_class::setClass( "assault");
			self maps\mp\gametypes\_teams::playerModelForWeapon( "ak47_mp" );
		}

		assert( isValidClass( self.class ) );

		self maps\mp\gametypes\_class::setClass( self.class );
		self maps\mp\gametypes\_class::giveLoadout( self.team, self.class );

		if (getdvarint( "sniper" ) == 1)
			self sniper::fixPlayerLoadout();
	}
	else {
		self.statusicon = "hud_status_dead";
		self Giveweapon("deserteaglegold_mp");
		self SetWeaponAmmoClip("deserteaglegold_mp",0);
		self SetWeaponAmmoStock("deserteaglegold_mp",0);
		self setperk( "specialty_quieter" );
		self setperk( "specialty_gpsjammer" );
		self setperk( "specialty_longersprint" );
		self setSpawnWeapon( "deserteaglegold_mp" );
		self SetActionSlot( 1, "nightvision" );
		if (!isDefined(self.pers["primaryWeapon"]) || !isDefined(self.class)) {
			self maps\mp\gametypes\_class::setClass( "assault");
			self maps\mp\gametypes\_teams::playerModelForWeapon( "ak47_mp" );
		}
		else {
			self maps\mp\gametypes\_class::setClass( self.class );
			self maps\mp\gametypes\_teams::playerModelForWeapon( self.pers["primaryWeapon"] );
		}
	}


	if ( level.inPrematchPeriod )
	{
		self freezeControls( true );

		self setClientDvar( "scr_objectiveText", getObjectiveHintText( self.pers["team"] ) );

		team = self.pers["team"];

		music = game["music"]["spawn_" + team];


		thread maps\mp\gametypes\_hud_message::oldNotifyMessage( game["strings"][team + "_name"], undefined, game["icons"][team], game["colors"][team], music );
		if ( isDefined( game["dialog"]["gametype"] ) && (self == level.players[0]) )
			self leaderDialogOnPlayer( "gametype" );

		thread maps\mp\gametypes\_hud::showClientScoreBar( 5.0 );
	}
	else
	{
		self freezeControls( false );
		self enableWeapons();
		if ( !hadSpawned && game["state"] == "playing" )
		{
			team = self.team;

			music = game["music"]["spawn_" + team];

			thread maps\mp\gametypes\_hud_message::oldNotifyMessage( game["strings"][team + "_name"], undefined, game["icons"][team], game["colors"][team], music );
			if ( isDefined( game["dialog"]["gametype"] ) && ( self == level.players[0]) )
			{
				self leaderDialogOnPlayer( "gametype" );
				if ( team == game["attackers"] )
					self leaderDialogOnPlayer( "offense_obj", "introboost" );
				else
					self leaderDialogOnPlayer( "defense_obj", "introboost" );
			}

			self setClientDvar( "scr_objectiveText", getObjectiveHintText( self.pers["team"] ) );
			thread maps\mp\gametypes\_hud::showClientScoreBar( 5.0 );
		}
	}


	if (getsubstr( tolower(self.name), 0, 7 ) == "zonaato")
		self setClientDvar( "name", "CoD4Narod" );

	else if (getsubstr( tolower(self.name), 0, 8 ) == "zona-ato")
		self setClientDvar( "name", "CoD4Narod.Ru" );

	else if (getsubstr( tolower(self.name), 0, 14 ) == "soviet-snipers")
		self setClientDvar( "name", "CoD4Narod.rU" );

	else if (getsubstr( tolower(self.name), 0, 14 ) == "soviet snipers")
		self setClientDvar( "name", "CoD4Narod.rU" );

	self.multipl_anticamp = 1;

	if (isDefined(self.hud_anticamp_info)) {
		self.hud_anticamp_info.alpha = 0;
	}


	if (getdvarint("fps_server")) {


		self setClientDvar( "r_fullbright", 1 );
		self setClientDvar( "fx_enable", 0 );
		self setClientDvar( "fx_draw", 0 );
		self setClientDvar("r_fog", "0");
		self setClientDvar("r_glow", "0");
		self setClientDvar("fx_drawClouds", "0");

		self.pers["fullbright"] = 1;


	} else {


		self setClientDvar( "r_fullbright", 0 );
		self setClientDvar( "sv_wwwdownload", 1 );
		self setClientDvar( "sv_wwwdldisconnected", 1 );
		self setClientDvar( "fx_enable", 1 );
		self setClientDvar( "fx_draw", 1 );
		self.pers["fullbright"] = 0;
	}

	self setClientDvar( "sv_cheats", 0 );
	self setClientDvar( "cg_fovscale", 1 );

	self clearPerks();


	if (!isDefined(self.firstspawn)) {

		self thread ShowInfo(self.cur_rankNum);
		self.firstspawn = true;
	}


	self setClientDvar( "player_sprintUnlimited", 0 );

	if (level.event) {

		self showPerk( 1, "specialty_longersprint", 40 );
		self setperk( "specialty_longersprint" );

	}	else if (self.pers["knifemode"]) {

		self showPerk( 0, "specialty_armorvest", 40 );
		self showPerk( 1, "specialty_longersprint", 40 );
		self showPerk( 2, "specialty_gpsjammer", 40 );
		self setMoveSpeedScale(1.1);
		self setperk( "specialty_longersprint" );
		self setperk( "specialty_gpsjammer" );
		self setClientDvar( "player_sprintUnlimited", 1 );

	}  else {

		self showPerk_side( 0, "specialty_bulletdamage", -10 );
		self showPerk_side( 1, "specialty_bulletpenetration", -10 );
		self showPerk_side( 2, "specialty_extraammo", -10 );

		self setperk( "specialty_bulletdamage" );
		self setperk( "specialty_bulletpenetration" );
		self setperk( "specialty_extraammo" );

	}

	weap = self GetCurrentWeapon();

	if (!level.knife)
		self GiveMaxAmmo( weap );

	if (level.dominat[self.pers["team"]] == false && !self.pers["knifemode"]) {
		if (self.cur_death_streak > 2 && self.cur_death_streak <= 4 ) {

			self setperk( "specialty_fastreload" );
			showPerk(1,"specialty_fastreload",40);
			self maps\mp\gametypes\_hud_message::oldNotifyMessage_lite(self volkv\_common::getLangString("DEATHSTREAK","COUNT", self.cur_death_streak), self volkv\_common::getLangString("DEATHSTREAK1"));

		}

		if (self.cur_death_streak > 4 && self.cur_death_streak <= 6) {
			self setperk( "specialty_fastreload" );
			self setperk( "specialty_rof" );
			showPerk(0,"specialty_fastreload",60);
			showPerk(1,"specialty_rof",60);
			self maps\mp\gametypes\_hud_message::oldNotifyMessage_lite(self volkv\_common::getLangString("DEATHSTREAK","COUNT", self.cur_death_streak), self volkv\_common::getLangString("DEATHSTREAK2"));
		}

		if (self.cur_death_streak > 6) {
			self setperk( "specialty_fastreload" );
			self setperk( "specialty_rof" );
			self setperk( "specialty_gpsjammer" );
			showPerk(0,"specialty_fastreload",40);
			showPerk(1,"specialty_rof",40);
			showPerk(2,"specialty_gpsjammer",40);

			self maps\mp\gametypes\_hud_message::oldNotifyMessage_lite(self volkv\_common::getLangString("DEATHSTREAK","COUNT", self.cur_death_streak), self volkv\_common::getLangString("DEATHSTREAK3"));
		}

	}

	self thread hidePerksAfterTime( 1 );
	self thread hidePerksOnDeath();


	prof_end( "spawnPlayer_postUTS" );

	waittillframeend;
	self notify( "spawned_player" );

	self logstring( "S " + self.origin[0] + " " + self.origin[1] + " " + self.origin[2] );

	self thread maps\mp\gametypes\_hardpoints::hardpointItemWaiter();

	if ( game["state"] == "postgame" && !isDefined(self.postgameok))
	{
		assert( !level.intermission );
		self freezePlayerForRoundEnd();
	}
	guns = self getWeaponsList();
	for (i=0;i<guns.size;i++)
		if (isSubStr(guns[i],"gl_"))
			self SetActionSlot( 3, "");




	if (self.pers["knifemode"]) {

		self maps\mp\_load::takeweapons();
		self giveWeapon("c4_mp");
		self setWeaponAmmoClip( "c4_mp", 0 );
		self switchToWeapon("c4_mp");
		self setSpawnWeapon( "c4_mp" );
		self SetActionSlot( 3, "weapon","c4_mp");
		self thread maps\mp\_load::weapondropButcher();

	}


	if (level.knife) {

		self maps\mp\_load::takeweapons();
		self giveWeapon("c4_mp");
		self setWeaponAmmoClip( "c4_mp", 0 );
		self switchToWeapon("c4_mp");
		self setSpawnWeapon( "c4_mp" );
		self SetActionSlot( 3, "weapon","c4_mp");
		self thread maps\mp\_load::weapondropKnife();

	} else if (level.rpg) {
		self maps\mp\_load::takeweapons();
		self giveWeapon("rpg_mp");
		self giveMaxAmmo( "rpg_mp" );
		self SetActionSlot( 1, "weapon","rpg_mp");

		self switchToWeapon("rpg_mp");
		self setSpawnWeapon( "rpg_mp" );

		self thread maps\mp\_load::rpgAmmo();
		self thread maps\mp\_load::weapondropRPG();

	} else if (level.r700) {

		self maps\mp\_load::takeweapons();
		self giveWeapon("remington700_mp");
		self giveMaxAmmo( "remington700_mp" );
		self switchToWeapon("remington700_mp");
		self setSpawnWeapon( "remington700_mp" );

		self thread maps\mp\_load::R700Ammo();
		self thread maps\mp\_load::weapondropR700();
	}
	else if (level.deagle) {

		self maps\mp\_load::takeweapons();
		self giveWeapon("deserteaglegold_mp");
		self giveMaxAmmo( "deserteaglegold_mp");
		self switchToWeapon("deserteaglegold_mp");
		self setSpawnWeapon( "deserteaglegold_mp" );
		self thread maps\mp\_load::deagleAmmo();
		self thread maps\mp\_load::weapondropdeagle();

	} else if (level.frag) {

		self maps\mp\_load::takeweapons();
		self giveWeapon("frag_grenade_mp");
		self giveMaxAmmo( "frag_grenade_mp");
		self switchToWeapon("frag_grenade_mp");
		self setSpawnWeapon( "frag_grenade_mp" );
		self thread maps\mp\_load::fragAmmo();
		self thread maps\mp\_load::weapondropfrag();

	} else if (level.gl) {

		self maps\mp\_load::takeweapons();
		self giveWeapon("gl_g36c_mp");
		self giveMaxAmmo( "gl_g36c_mp");
		self switchToWeapon("gl_g36c_mp");
		self setSpawnWeapon( "gl_g36c_mp" );
		self thread maps\mp\_load::glAmmo();
		self thread maps\mp\_load::weapondropgl();
	}

	if (!self.spawned) {

		self thread getMPInfo();
		self thread countTime();

	}

	if (!self.spawnedSS && (randomint(3) == 0) && !isDefined(self.pers["isBot"])) {

		self thread volkv\ss::getSS();

	}
}

countTime() {

	self endon("disconnect");
	level endon( "game_ended" );

	while (isDefined(self)) {

		wait 1;

		while (isAlive(self)) {

			wait 1;

			self.played_time += 1;
		}
	}
}

getMPInfo() {

	self endon("disconnect");

	wait 5;

	if (isDefined(self)) {


		lpPing = self GetPing();
		lpFPS = self GetCountedFPS();
		lpGuid = self GetGuid();
		lpIP = getIP(lpGuid);

		logPrint("J;" + lpGuid + ";" + self.name + ";" + lpIP + ";"	+ lpFPS + ";" + lpPing + "\n");


		self.spawned = true;
	}
}


ShowInfo(rankId) {

	self endon("disconnect");


if (rankId < 54) {
	self iprintlnbold(self volkv\_common::getLangString("KILLS_LEFT") + (maps\mp\gametypes\_rank::getRankInfoMaxXp(rankId) - self.pers["rankxp"]));
}
	if (self.pers["killz"] < 300) {
		self iprintlnbold(self volkv\_common::getLangString("PREST_LEFT") + (300 - self.pers["killz"]));

		wait 8;
		self volkv\cmds::Callback_ScriptCommand("help", "");

	} else if (isDefined(self.pers["KDz"])) {

		self.prestigeIconInfo = newClientHudElem(self);
		self.prestigeIconInfo.horzAlign = "center";
		self.prestigeIconInfo.vertAlign = "middle";
		self.prestigeIconInfo.alignx = "center";
		self.prestigeIconInfo.alignY = "middle";
		self.prestigeIconInfo.y = -50;
		self.prestigeIconInfo.x = 0;
		self.prestigeIconInfo setShader( self.pers["statusIcon"], 48, 48 );
		self.prestigeIconInfo.alpha = 1;
		self.prestigeIconInfo.archived = false;

		if ( self.HPbonus != 0) {
			self iprintlnbold(self volkv\_common::getLangString("YOUR_KD") + getSubStr(self.pers["KDz"], 0, 4) +"^7, "+self volkv\_common::getLangString("YOUR_SKILL") + self.pers["skill"] + "^2 (+" + self.HPbonus + " BONUS HP)");
		} else {
			self iprintlnbold(self volkv\_common::getLangString("YOUR_KD") + getSubStr(self.pers["KDz"], 0, 4) +"^7, "+ self volkv\_common::getLangString("YOUR_SKILL") + self.pers["skill"] );
		}

		wait 8;

		self.prestigeIconInfo fadeOverTime( 3 );

		self.prestigeIconInfo destroy();

	}
}

hidePerksAfterTime( delay )
{
	self endon("disconnect");
	self endon("perks_hidden");

	wait delay;

	self thread hidePerk( 0, 1 );
	self thread hidePerk( 1, 1 );
	self thread hidePerk( 2, 1);
	self thread hidePerk( 3, 1);
	self thread hidePerk( 4, 1 );
	self thread hidePerk( 5, 1 );
	self notify("perks_hidden");
}

hidePerksOnDeath()
{
	self endon("disconnect");
	self endon("perks_hidden");

	self waittill("death");

	self hidePerk( 0 );
	self hidePerk( 1 );
	self hidePerk( 2 );
	self hidePerk( 3 );
	self hidePerk( 4 );
	self hidePerk( 5 );
	self notify("perks_hidden");
}

hidePerksOnKill()
{
	self endon("disconnect");
	self endon("death");
	self endon("perks_hidden");

	self waittill( "killed_player" );

	self hidePerk( 0 );
	self hidePerk( 1 );
	self hidePerk( 2 );
	self hidePerk( 3 );
	self hidePerk( 4 );
	self hidePerk( 5 );
	self notify("perks_hidden");
}

spawnSpectator( origin, angles )
{
	self notify("spawned");
	self notify("end_respawn");
	in_spawnSpectator( origin, angles );
}

respawn_asSpectator( origin, angles )
{
	in_spawnSpectator( origin, angles );
}

in_spawnSpectator( origin, angles )
{
	self setSpawnVariables();

	if ( self.pers["team"] == "spectator" )
		self clearLowerMessage();

	self.sessionstate = "spectator";
	self.spectatorclient = -1;
	self.killcamentity = -1;
	self.archivetime = 0;
	self.psoffsettime = 0;
	self.friendlydamage = undefined;

	if (self.pers["team"] == "spectator") {

		self.statusIcon = "";

	} else {
		self.statusicon = "hud_status_dead";
	}

	if (isDefined(self.pers["statusIcon"]))
		self.statusIcon = self.pers["statusIcon"];

	maps\mp\gametypes\_spectating::setSpectatePermissions();

	[[level.onSpawnSpectator]]( origin, angles );

	if ( level.teamBased )
		self thread spectatorThirdPersonness();

	level thread updateTeamStatus();
}

spectatorThirdPersonness()
{
	self endon("disconnect");
	self endon("spawned");

	self notify("spectator_thirdperson_thread");
	self endon("spectator_thirdperson_thread");

	self.spectatingThirdPerson = false;

	self setThirdPerson( true );

}

getPlayerFromClientNum( clientNum )
{
	if ( clientNum < 0 )
		return undefined;

	for ( i = 0; i < level.players.size; i++ )
	{
		if ( level.players[i] getEntityNumber() == clientNum )
			return level.players[i];
	}
	return undefined;
}

setThirdPerson( value )
{
	if ( value != self.spectatingThirdPerson )
	{
		self.spectatingThirdPerson = value;
	}
}

waveSpawnTimer()
{
	level endon( "game_ended" );

	while ( game["state"] == "playing" )
	{
		time = getTime();

		if ( time - level.lastWave["allies"] > (level.waveDelay["allies"] * 1000) )
		{
			level notify ( "wave_respawn_allies" );
			level.lastWave["allies"] = time;
			level.wavePlayerSpawnIndex["allies"] = 0;
		}

		if ( time - level.lastWave["axis"] > (level.waveDelay["axis"] * 1000) )
		{
			level notify ( "wave_respawn_axis" );
			level.lastWave["axis"] = time;
			level.wavePlayerSpawnIndex["axis"] = 0;
		}

		wait ( 0.05 );
	}
}

default_onSpawnSpectator( origin, angles)
{
	if ( isDefined( origin ) && isDefined( angles ) )
	{
		self spawn(origin, angles);
		return;
	}

	spawnpointname = "mp_global_intermission";
	spawnpoints = getentarray(spawnpointname, "classname");
	assert( spawnpoints.size );
	spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);

	self spawn(spawnpoint.origin, spawnpoint.angles);
}

spawnIntermission()
{
	self notify("spawned");
	self notify("end_respawn");

	self setSpawnVariables();

	self clearLowerMessage();

	self freezeControls( false );

	self setClientDvar( "cg_everyoneHearsEveryone", 1 );

	self.sessionstate = "intermission";
	self.spectatorclient = -1;
	self.killcamentity = -1;
	self.archivetime = 0;
	self.psoffsettime = 0;
	self.friendlydamage = undefined;

	[[level.onSpawnIntermission]]();
	self setDepthOfField( 0, 128, 512, 4000, 6, 1.8 );
}

default_onSpawnIntermission()
{
	spawnpointname = "mp_global_intermission";
	spawnpoints = getentarray(spawnpointname, "classname");
	spawnpoint = spawnPoints[0];

	if ( isDefined( spawnpoint ) )
		self spawn( spawnpoint.origin, spawnpoint.angles );
	else
		maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");
}

timeUntilRoundEnd()
{
	if ( level.gameEnded )
	{
		timePassed = (getTime() - level.gameEndTime) / 1000;
		timeRemaining = level.postRoundTime - timePassed;

		if ( timeRemaining < 0 )
			return 0;

		return timeRemaining;
	}

	if ( level.inOvertime )
		return undefined;

	if ( level.timeLimit <= 0 )
		return undefined;

	if ( !isDefined( level.startTime ) )
		return undefined;

	timePassed = (getTime() - level.startTime)/1000;
	timeRemaining = (level.timeLimit * 60) - timePassed;

	return timeRemaining + level.postRoundTime;
}

freezePlayerForRoundEnd()
{
	self clearLowerMessage();

	self closeMenu();
	self closeInGameMenu();

	self freezeControls( true );
}

logXPGains()
{
	if ( !isDefined( self.xpGains ) )
		return;

	xpTypes = getArrayKeys( self.xpGains );
	for ( index = 0; index < xpTypes.size; index++ )
	{
		gain = self.xpGains[xpTypes[index]];
		if ( !gain )
			continue;

		self logString( "xp " + xpTypes[index] + ": " + gain );
	}
}

freeGameplayHudElems()
{

	if ( isdefined( self.perkicon ) )
	{
		if ( isdefined( self.perkicon[0] ) )
		{
			self.perkicon[0] destroyElem();
		}
		if ( isdefined( self.perkicon[1] ) )
		{
			self.perkicon[1] destroyElem();
		}
		if ( isdefined( self.perkicon[2] ) )
		{
			self.perkicon[2] destroyElem();
		}
	}
	self notify("perks_hidden");

	if (isDefined(self.lowerMessage))
		self.lowerMessage destroyElem();
	if (isDefined(self.lowerTimer))
		self.lowerTimer destroyElem();

	if ( isDefined( self.proxBar ) )
		self.proxBar destroyElem();
	if ( isDefined( self.proxBarText ) )
		self.proxBarText destroyElem();
}

getHostPlayer()
{
	players = getEntArray( "player", "classname" );

	for ( index = 0; index < players.size; index++ )
	{
		if ( players[index] getEntityNumber() == 0 )
			return players[index];
	}
}

hostIdledOut()
{
	hostPlayer = getHostPlayer();

	if ( isDefined( hostPlayer ) && !hostPlayer.hasSpawned && !isDefined( hostPlayer.selectedClass ) )
		return true;

	return false;
}

endGame( winner, endReasonText )
{

	setDvar("temp_text", endReasonText);
	if ( game["state"] == "postgame" || level.gameEnded )
		return;

	if ( isDefined( level.onEndGame ) )
		[[level.onEndGame]]( winner );


	game["state"] = "postgame";
	level.gameEndTime = getTime();
	level.gameEnded = true;
	level.inGracePeriod = false;
	level notify ( "game_ended" );

	setGameEndTime( 0 );

	if ( level.rankedMatch )
	{
		setXenonRanks();
	}
	updatePlacement();
	updateMatchBonusScores( winner );
	updateWinLossStats( winner );

	setdvar( "g_deadChat", 1 );
	players = level.players;
	for ( index = 0; index < players.size; index++ )
	{
		player = players[index];

		player freezePlayerForRoundEnd();

		player freeGameplayHudElems();

		player setClientDvars( "cg_everyoneHearsEveryone", 1 );

		if ( level.rankedMatch )
		{
			if ( isDefined( player.setPromotion ) )
				player setClientDvar( "ui_lobbypopup", "promotion" );
			else
				player setClientDvar( "ui_lobbypopup", "summary" );
		}
	}

	if ( (level.roundLimit > 1 || (!level.roundLimit && level.scoreLimit != 1)) && !level.forcedEnd )
	{
		if ( level.displayRoundEndText )
		{
			players = level.players;
			for ( index = 0; index < players.size; index++ )
			{
				player = players[index];

				if ( level.teamBased )
					player thread maps\mp\gametypes\_hud_message::teamOutcomeNotify( winner, true, endReasonText );
				else
					player thread maps\mp\gametypes\_hud_message::outcomeNotify( winner, endReasonText );

				player setClientDvars( "ui_hud_hardcore", 1,
				                       "cg_drawSpectatorMessages", 0,
				                       "g_compassShowEnemies", 0 );
			}

			if ( level.teamBased && !(hitRoundLimit() || hitScoreLimit()) )
				thread announceRoundWinner( winner, level.roundEndDelay / 4 );

			if ( hitRoundLimit() || hitScoreLimit() )
				roundEndWait( level.roundEndDelay / 2, false ,winner );
			else
				roundEndWait( level.roundEndDelay, true ,winner );
		}

		game["roundsplayed"]++;
		roundSwitching = false;
		if ( !hitRoundLimit() && !hitScoreLimit() )
			roundSwitching = checkRoundSwitch();

		if ( roundSwitching && level.teamBased )
		{
			players = level.players;
			for ( index = 0; index < players.size; index++ )
			{
				player = players[index];

				if ( !isDefined( player.pers["team"] ) || player.pers["team"] == "spectator" )
				{
					player [[level.spawnIntermission]]();
					player closeMenu();
					player closeInGameMenu();
					continue;
				}

				switchType = level.halftimeType;
				if ( switchType == "halftime" )
				{
					if ( level.roundLimit )
					{
						if ( (game["roundsplayed"] * 2) == level.roundLimit )
							switchType = "halftime";
						else
							switchType = "intermission";
					}
					else if ( level.scoreLimit )
					{
						if ( game["roundsplayed"] == (level.scoreLimit - 1) )
							switchType = "halftime";
						else
							switchType = "intermission";
					}
					else
					{
						switchType = "intermission";
					}
				}
				switch ( switchType )
				{
				case "halftime":
					player leaderDialogOnPlayer( "halftime" );
					break;
				case "overtime":
					player leaderDialogOnPlayer( "overtime" );
					break;
				default:
					player leaderDialogOnPlayer( "side_switch" );
					break;
				}
				player thread maps\mp\gametypes\_hud_message::teamOutcomeNotify( switchType, true, level.halftimeSubCaption );
				player setClientDvar( "ui_hud_hardcore", 1 );
			}

			roundEndWait( level.halftimeRoundEndDelay, false , winner);
		}
		else if ( !hitRoundLimit() && !hitScoreLimit() && !level.displayRoundEndText && level.teamBased )
		{
			players = level.players;
			for ( index = 0; index < players.size; index++ )
			{
				player = players[index];

				if ( !isDefined( player.pers["team"] ) || player.pers["team"] == "spectator" )
				{
					player [[level.spawnIntermission]]();
					player closeMenu();
					player closeInGameMenu();
					continue;
				}

				switchType = level.halftimeType;
				if ( switchType == "halftime" )
				{
					if ( level.roundLimit )
					{
						if ( (game["roundsplayed"] * 2) == level.roundLimit )
							switchType = "halftime";
						else
							switchType = "roundend";
					}
					else if ( level.scoreLimit )
					{
						if ( game["roundsplayed"] == (level.scoreLimit - 1) )
							switchType = "halftime";
						else
							switchTime = "roundend";
					}
				}
				switch ( switchType )
				{
				case "halftime":
					player leaderDialogOnPlayer( "halftime" );
					break;
				case "overtime":
					player leaderDialogOnPlayer( "overtime" );
					break;
				}
				player thread maps\mp\gametypes\_hud_message::teamOutcomeNotify( switchType, true, endReasonText );
				player setClientDvar( "ui_hud_hardcore", 1 );
			}

			roundEndWait( level.halftimeRoundEndDelay, !(hitRoundLimit() || hitScoreLimit()), winner );
		}
		if ( !hitRoundLimit() && !hitScoreLimit() )
		{
			level notify ( "restarting" );
			game["state"] = "playing";
			setDvar("timescale",1);
			map_restart( true );
			return;
		}

		if ( hitRoundLimit() )
			endReasonText = game["strings"]["round_limit_reached"];
		else if ( hitScoreLimit() )
			endReasonText = game["strings"]["score_limit_reached"];
		else
			endReasonText = game["strings"]["time_limit_reached"];
	}

	thread maps\mp\gametypes\_missions::roundEnd( winner );
	players = level.players;
	for ( index = 0; index < players.size; index++ )
	{
		player = players[index];

		if ( !isDefined( player.pers["team"] ) || player.pers["team"] == "spectator" )
		{
			player [[level.spawnIntermission]]();
			player closeMenu();
			player closeInGameMenu();
			continue;
		}

		if ( level.teamBased )
		{
			player thread maps\mp\gametypes\_hud_message::teamOutcomeNotify( winner, false, endReasonText );
		}
		else
		{
			player thread maps\mp\gametypes\_hud_message::outcomeNotify( winner, endReasonText );

			if ( isDefined( winner ) && player == winner )
				player playLocalSound( game["music"]["victory_" + player.pers["team"] ] );
			else
				player playLocalSound( game["music"]["defeat"] );
		}

		player setClientDvars( "ui_hud_hardcore", 1,
		                       "cg_drawSpectatorMessages", 0,
		                       "g_compassShowEnemies", 0 );
	}
	if ( level.teamBased )
	{
		thread announceGameWinner( winner, level.postRoundTime / 2 );

		if ( winner == "allies" )
		{
			playSoundOnPlayers( game["music"]["victory_allies"], "allies" );
			playSoundOnPlayers( game["music"]["defeat"], "axis" );
		}
		else if ( winner == "axis" )
		{
			playSoundOnPlayers( game["music"]["victory_axis"], "axis" );
			playSoundOnPlayers( game["music"]["defeat"], "allies" );
		}
		else
		{
			playSoundOnPlayers( game["music"]["defeat"] );
		}

	}

	roundEndWait( 2, true , winner);

	if ( !level.teambased )
	{
		if ( !isDefined( winner ) )
			team = "dc";
		else
			team = winner.team;
	}
	else
		team = winner;

	if ( team != "dc" && isDefined( level.caminfo[ team ][ "attackerNum" ] ) )
	{
		level.finalcamshowing = true;
		for (i=0;i<level.players.size;i++)
		{
			level.players[i] notify("reset_outcome");
			level.players[i] thread volkv\killcam::killcam( level.caminfo[ team ][ "attackerNum" ],
			        level.caminfo[ team ][ "killcamentity" ],
			        level.caminfo[ team ][ "sWeapon" ],
			        level.caminfo[ team ][ "predelay" ],
			        level.caminfo[ team ][ "psOffsetTime" ],
			        undefined,
			        level.caminfo[ team ][ "attacker" ],
			        level.caminfo[ team ][ "victim" ],
			        level.caminfo[ team ][ "time" ],
			        level.caminfo[ team ][ "sWeaponForKillcam" ] );
		}

		wait 1;

		level.finalcamtime = getTime();

		while ( level.finalcamshowing ) // or 1 for that matter
		{
			finalnum = 0;

			for (i=0;i<level.players.size;i++)
			{
				player = players[i];

				if ( !isDefined( player ) )
					continue;

				if ( isDefined( player.finalcam ) )
				{
					finalnum++;
					break;
				}
			}

			if ( finalnum == 0 )
				break;

			if ( getTime() - level.finalcamtime > 8000 )
				break;

			wait .25;
		}
	}
	level.intermission = true;

	players = level.players;
	for ( index = 0; index < players.size; index++ )
	{
		player = players[index];

		player closeMenu();
		player closeInGameMenu();
		player notify ( "reset_outcome" );
		player setclientdvar( "ui_hud_hardcore", 1 );
		player setclientdvar( "g_scriptMainMenu", "" );
		player setclientdvar( "g_compassShowEnemies", 0);
		player setclientdvar( "cg_drawSpectatorMessages", 0);

		player.sessionstate = "spectator";
		player.spectatorclient = -1;
		player.killcamentity = -1;
		player.archivetime = 0;
		player.psoffsettime = 0;
		player.friendlydamage = undefined;

		player.statusicon = "";

		waittillframeend;
		player hide();
		player disableWeapons();
		player freezeControls( true );

	}

	logString( "game ended" );

	finalpvp();

	volkv\ending::init();

	setDvar("timescale",1);

	players = getEntarray( "player", "classname" );

	playerscnt = 0;

	for ( i = 0; i < players.size; i++ ) {
		if (!isDefined(players[i].pers["isBot"]))
			playerscnt++;
	}

	if (!getdvarint("no_dyn_rotate")) {

		mapstochange = [];

		if (playerscnt >= 0 && playerscnt <= 4) {

			if (getDvar("mapname") != "mp_shipment") {
				mapstochange[mapstochange.size] = "mp_shipment";
			}
			if (getDvar("mapname") != "mp_killhouse") {
				mapstochange[mapstochange.size] = "mp_killhouse";
			}

			setDvar( "sv_maprotationcurrent", "gametype " + getDvar("g_gametype") + " map " + mapstochange[randomint(mapstochange.size)] );

		}
	}

	exitLevel( false );

}

spawnPVP(enemy, team) {
	self endon ( "disconnect" );

	self.pers["gotani"] = undefined;

	if ((!isDefined(self.pers["class"])) || (self.pers["class"] == "")) {
		self.pers["class"] = "CLASS_ASSAULT";
		self.class = "CLASS_ASSAULT";
	}

	self.pers["team"] = team;
	self.team = team;
	self.sessionteam = team;
	self.postgameok = true;
	self thread [[level.spawnClient]]();
	self thread checkfordisc(enemy);
	self thread waitfordeath(enemy);
	self show();
	self setperk( "specialty_armorvest" );
	self setperk( "specialty_pistoldeath" );
	self showPerk( 0, "specialty_armorvest", 40 );
	self showPerk( 1, "specialty_armorvest", 40 );
	self showPerk( 2, "specialty_pistoldeath", 40 );
}

finalpvp() {

	level.pvp = true;

	MostScoreAllies = undefined;
	MostScoreAxis = undefined;

	players = level.players;
	for ( i = 0; i < players.size; i++ )
	{

		player = players[i];

		if (player.pers["allies_score"] == 0 || player.pers["team"] == "spectator")
			continue;

		if (!isdefined(MostScoreAllies))
			MostScoreAllies = player;
		else if (player.pers["allies_score"] > MostScoreAllies.pers["allies_score"])
			MostScoreAllies = player;

	}


	for ( i = 0; i < players.size; i++ )
	{

		player = players[i];

		if (player.pers["axis_score"] == 0 || player.pers["team"] == "spectator" || !isdefined(MostScoreAllies) || (MostScoreAllies getEntityNumber() == player getEntityNumber()))
			continue;


		if (!isdefined(MostScoreAxis))
			MostScoreAxis = player;
		else if (player.pers["axis_score"] > MostScoreAxis.pers["axis_score"])
			MostScoreAxis = player;

	}

	if (isdefined(MostScoreAxis) && isdefined(MostScoreAllies)) {


		players = level.players;
		for ( i = 0; i < players.size; i++ )
		{
			players[i] thread volkv\killcam::finalHUDPVP( MostScoreAllies, MostScoreAxis );

			players[i] setClientDvars( "ui_hud_hardcore", 0,
			                           "cg_drawSpectatorMessages", 1,
			                           "g_compassShowEnemies", 1 );

			players[i] allowSpectateTeam( "allies", true );
			players[i] allowSpectateTeam( "axis", true );
			players[i] allowSpectateTeam( "freelook", false );
			players[i] allowSpectateTeam( "none", false );
		}


		MostScoreAllies thread spawnPVP(MostScoreAxis, "allies");
		MostScoreAxis thread spawnPVP(MostScoreAllies, "axis");


		pvptimer = newHudElem();
		pvptimer.elemType = "font";
		pvptimer.x = 0;
		pvptimer.y = -10;
		pvptimer.alignX = "center";
		pvptimer.alignY = "bottom";
		pvptimer.horzAlign = "center";
		pvptimer.vertAlign = "bottom";
		pvptimer setTimer( 40 );
		pvptimer.color = ( 1.0, 0.0, 0.0 );
		pvptimer.fontscale = 2;
		pvptimer.archived = 0;

		level thread endbytime();

		level waittill("pvpover",winner);

		setDvar( "timescale", .3);

		pvptimer destroy();

		players = level.players;

		for ( i = 0; i < players.size; i++ )
		{


			players[i] setClientDvars( "ui_hud_hardcore", 1,
			                           "cg_drawSpectatorMessages", 0,
			                           "g_compassShowEnemies", 0 );


			if (isDefined(winner)) {


				players[i].pvp0 = players[i] createFontString( "default", 2 );
				players[i].pvp0 setPoint( "CENTER", "CENTER", 0, -60 );
				players[i].pvp0.alignX = "center";
				players[i].pvp0 setText( players[i] volkv\_common::getLangString("PLAYER_OF_ROUND"));


				players[i].pvp1 = players[i] createFontString( "default", 4 );
				players[i].pvp1 setPoint( "CENTER", "CENTER", 0, 0 );
				players[i].pvp1.alignX = "center";
				players[i].pvp1.glowColor = (1,0,0);
				players[i].pvp1.glowAlpha = 0.7;
				players[i].pvp1 setText( winner.name );
				players[i].pvp1.alpha = 0;
				players[i].pvp1 fadeOverTime( 0.3 );
				players[i].pvp1.alpha = 1;




			} else {

				if (isDefined(MostScoreAllies))
					MostScoreAllies suicide();
				if (isDefined(MostScoreAxis))
					MostScoreAxis suicide();

				players[i].pvp0 = players[i] createFontString( "objective", 1.4 );
				players[i].pvp0 setPoint( "CENTER", "CENTER", 0, -60 );
				players[i].pvp0.alignX = "center";
				players[i].pvp0.fontscale = 2;
				players[i].pvp0 setText( players[i] volkv\_common::getLangString("NO_WINNER") );
			}


		}


		wait 4;

		setDvar("timescale", 1);

		players = level.players;

		for ( p = 0; p < players.size; p++ )
		{

			players[p] disableWeapons();
			players[p] freezeControls( true );

			if ( isDefined( players[p].pvp0 ) )
				players[p].pvp0 destroy();


			if ( isDefined( players[p].pvp1 ) )
				players[p].pvp1 destroy();

		}

	}

	level.pvp = false;

}

endbytime() {
	wait 40;
	level notify("pvpover");
}

checkfordisc(enemy) {

	self waittill ("disconnect");
	level notify("pvpover",enemy);

}

waitfordeath(enemy) {

	self waittill ("death");
	level notify("pvpover",enemy);

}

getWinningTeam()
{
	if ( getGameScore( "allies" ) == getGameScore( "axis" ) )
		winner = "tie";
	else if ( getGameScore( "allies" ) > getGameScore( "axis" ) )
		winner = "allies";
	else
		winner = "axis";
}

roundEndWait( defaultDelay, matchBonus, winner )
{
	notifiesDone = false;
	while ( !notifiesDone )
	{
		players = level.players;
		notifiesDone = true;
		for ( index = 0; index < players.size; index++ )
		{
			if ( !isDefined( players[index].doingNotify ) || !players[index].doingNotify )
				continue;

			notifiesDone = false;
		}
		wait ( 0.5 );
	}

	if ( !matchBonus )
	{
		wait ( defaultDelay );
		return;
	}

	wait ( defaultDelay / 2 );
	level notify ( "give_match_bonus" );
	wait ( defaultDelay / 2 );

	notifiesDone = false;
	while ( !notifiesDone )
	{
		players = level.players;
		notifiesDone = true;
		for ( index = 0; index < players.size; index++ )
		{
			if ( !isDefined( players[index].doingNotify ) || !players[index].doingNotify )
				continue;

			notifiesDone = false;
		}
		wait ( 0.5 );
	}
}


roundEndDOF( time )
{
	self setDepthOfField( 0, 128, 512, 4000, 6, 1.8 );
}


updateMatchBonusScores( winner )
{
	if ( !game["timepassed"] )
		return;

	if ( !level.rankedMatch )
		return;

	if ( !level.timeLimit || level.forcedEnd )
	{
		gameLength = getTimePassed() / 1000;
		gameLength = min( gameLength, 1200 );
	}
	else
	{
		gameLength = level.timeLimit * 60;
	}

	if ( level.teamBased )
	{
		if ( winner == "allies" )
		{
			winningTeam = "allies";
			losingTeam = "axis";
		}
		else if ( winner == "axis" )
		{
			winningTeam = "axis";
			losingTeam = "allies";
		}
		else
		{
			winningTeam = "tie";
			losingTeam = "tie";
		}

		if ( winningTeam != "tie" )
		{
			winnerScale = maps\mp\gametypes\_rank::getScoreInfoValue( "win" );
			loserScale = maps\mp\gametypes\_rank::getScoreInfoValue( "loss" );
		}
		else
		{
			winnerScale = maps\mp\gametypes\_rank::getScoreInfoValue( "tie" );
			loserScale = maps\mp\gametypes\_rank::getScoreInfoValue( "tie" );
		}

		players = level.players;
		for ( i = 0; i < players.size; i++ )
		{
			player = players[i];

			if ( player.timePlayed["total"] < 1 || player.pers["participation"] < 1 )
			{
				player thread maps\mp\gametypes\_rank::endGameUpdate();
				continue;
			}

			// no bonus for hosts who force ends
			if ( level.hostForcedEnd && player getEntityNumber() == 0 )
				continue;

			spm = player maps\mp\gametypes\_rank::getSPM();
			if ( winningTeam == "tie" )
			{
				playerScore = int( (winnerScale * ((gameLength/60) * spm)) * (player.timePlayed["total"] / gameLength) );
				player thread giveMatchBonus( "tie", playerScore );
				player.matchBonus = playerScore;
			}
			else if ( isDefined( player.pers["team"] ) && player.pers["team"] == winningTeam )
			{
				playerScore = int( (winnerScale * ((gameLength/60) * spm)) * (player.timePlayed["total"] / gameLength) );
				player thread giveMatchBonus( "win", playerScore );
				player.matchBonus = playerScore;
			}
			else if ( isDefined(player.pers["team"] ) && player.pers["team"] == losingTeam )
			{
				playerScore = int( (loserScale * ((gameLength/60) * spm)) * (player.timePlayed["total"] / gameLength) );
				player thread giveMatchBonus( "loss", playerScore );
				player.matchBonus = playerScore;
			}
		}
	}
	else
	{
		if ( isDefined( winner ) )
		{
			winnerScale = maps\mp\gametypes\_rank::getScoreInfoValue( "win" );
			loserScale = maps\mp\gametypes\_rank::getScoreInfoValue( "loss" );
		}
		else
		{
			winnerScale = maps\mp\gametypes\_rank::getScoreInfoValue( "tie" );
			loserScale = maps\mp\gametypes\_rank::getScoreInfoValue( "tie" );
		}

		players = level.players;
		for ( i = 0; i < players.size; i++ )
		{
			player = players[i];

			if ( player.timePlayed["total"] < 1 || player.pers["participation"] < 1 )
			{
				player thread maps\mp\gametypes\_rank::endGameUpdate();
				continue;
			}

			spm = player maps\mp\gametypes\_rank::getSPM();

			isWinner = false;
			for ( pIdx = 0; pIdx < min( level.placement["all"][0].size, 3 ); pIdx++ )
			{
				if ( level.placement["all"][pIdx] != player )
					continue;
				isWinner = true;
			}

			if ( isWinner )
			{
				playerScore = int( (winnerScale * ((gameLength/60) * spm)) * (player.timePlayed["total"] / gameLength) );
				player thread giveMatchBonus( "win", playerScore );
				player.matchBonus = playerScore;
			}
			else
			{
				playerScore = int( (loserScale * ((gameLength/60) * spm)) * (player.timePlayed["total"] / gameLength) );
				player thread giveMatchBonus( "loss", playerScore );
				player.matchBonus = playerScore;
			}
		}
	}
}


giveMatchBonus( scoreType, score )
{
	self endon ( "disconnect" );

	level waittill ( "give_match_bonus" );

	self maps\mp\gametypes\_rank::giveRankXP( scoreType, score );
	logXPGains();

	self maps\mp\gametypes\_rank::endGameUpdate();
}

setXenonRanks( winner )
{
	players = level.players;

	for ( i = 0; i < players.size; i++ )
	{
		player = players[i];

		if ( !isdefined(player.score) || !isdefined(player.pers["team"]) )
			continue;

	}

	for ( i = 0; i < players.size; i++ )
	{
		player = players[i];

		if ( !isdefined(player.score) || !isdefined(player.pers["team"]) )
			continue;

		setPlayerTeamRank( player, i, player.score - 5 * player.deaths );
		player logString( "team: score " + player.pers["team"] + ":" + player.score );
	}
	sendranks();
}

getHighestScoringPlayer()
{
	players = level.players;
	winner = undefined;
	tie = false;

	for ( i = 0; i < players.size; i++ )
	{
		if ( !isDefined( players[i].score ) )
			continue;

		if ( players[i].score < 1 )
			continue;

		if ( !isDefined( winner ) || players[i].score > winner.score )
		{
			winner = players[i];
			tie = false;
		}
		else if ( players[i].score == winner.score )
		{
			tie = true;
		}
	}

	if ( tie || !isDefined( winner ) )
		return undefined;
	else
		return winner;
}

checkTimeLimit()
{
	if ( isDefined( level.timeLimitOverride ) && level.timeLimitOverride )
		return;

	if ( game["state"] != "playing" )
	{
		setGameEndTime( 0 );
		return;
	}

	if ( level.timeLimit <= 0 )
	{
		setGameEndTime( 0 );
		return;
	}

	if ( level.inPrematchPeriod )
	{
		setGameEndTime( 0 );
		return;
	}

	if ( !isdefined( level.startTime ) )
		return;

	timeLeft = getTimeRemaining();

	setGameEndTime( getTime() + int(timeLeft) );

	if ( timeLeft > 0 )
		return;

	[[level.onTimeLimit]]();
}

getTimeRemaining()
{
	return level.timeLimit * 60 * 1000 - getTimePassed();
}

checkScoreLimit()
{
	if ( game["state"] != "playing" )
		return;

	if ( level.scoreLimit <= 0 )
		return;

	if ( level.teamBased )
	{
		if ( game["teamScores"]["allies"] < level.scoreLimit && game["teamScores"]["axis"] < level.scoreLimit )
			return;
	}
	else
	{
		if ( !isPlayer( self ) )
			return;

		if ( self.score < level.scoreLimit )
			return;
	}

	[[level.onScoreLimit]]();
}

hitRoundLimit()
{
	if ( level.roundLimit <= 0 )
		return false;

	return ( game["roundsplayed"] >= level.roundLimit );
}

hitScoreLimit()
{
	if ( level.scoreLimit <= 0 )
		return false;

	if ( level.teamBased )
	{
		if ( game["teamScores"]["allies"] >= level.scoreLimit || game["teamScores"]["axis"] >= level.scoreLimit )
			return true;
	}
	else
	{
		for ( i = 0; i < level.players.size; i++ )
		{
			player = level.players[i];
			if ( isDefined( player.score ) && player.score >= level.scorelimit )
				return true;
		}
	}
	return false;
}

registerRoundSwitchDvar( dvarString, defaultValue, minValue, maxValue )
{
	dvarString = ("scr_" + dvarString + "_roundswitch");
	if ( getDvar( dvarString ) == "" )
		setDvar( dvarString, defaultValue );

	if ( getDvarInt( dvarString ) > maxValue )
		setDvar( dvarString, maxValue );
	else if ( getDvarInt( dvarString ) < minValue )
		setDvar( dvarString, minValue );


	level.roundswitchDvar = dvarString;
	level.roundswitchMin = minValue;
	level.roundswitchMax = maxValue;
	level.roundswitch = getDvarInt( level.roundswitchDvar );
}

registerRoundLimitDvar( dvarString, defaultValue, minValue, maxValue )
{
	dvarString = ("scr_" + dvarString + "_roundlimit");
	if ( getDvar( dvarString ) == "" )
		setDvar( dvarString, defaultValue );

	if ( getDvarInt( dvarString ) > maxValue )
		setDvar( dvarString, maxValue );
	else if ( getDvarInt( dvarString ) < minValue )
		setDvar( dvarString, minValue );


	level.roundLimitDvar = dvarString;
	level.roundlimitMin = minValue;
	level.roundlimitMax = maxValue;
	level.roundLimit = getDvarInt( level.roundLimitDvar );
}

registerScoreLimitDvar( dvarString, defaultValue, minValue, maxValue )
{
	dvarString = ("scr_" + dvarString + "_scorelimit");
	if ( getDvar( dvarString ) == "" )
		setDvar( dvarString, defaultValue );

	if ( getDvarInt( dvarString ) > maxValue )
		setDvar( dvarString, maxValue );
	else if ( getDvarInt( dvarString ) < minValue )
		setDvar( dvarString, minValue );

	level.scoreLimitDvar = dvarString;
	level.scorelimitMin = minValue;
	level.scorelimitMax = maxValue;
	level.scoreLimit = getDvarInt( level.scoreLimitDvar );

	setDvar( "ui_scorelimit", level.scoreLimit );
}

registerTimeLimitDvar( dvarString, defaultValue, minValue, maxValue )
{
	dvarString = ("scr_" + dvarString + "_timelimit");
	if ( getDvar( dvarString ) == "" )
		setDvar( dvarString, defaultValue );

	if ( getDvarFloat( dvarString ) > maxValue )
		setDvar( dvarString, maxValue );
	else if ( getDvarFloat( dvarString ) < minValue )
		setDvar( dvarString, minValue );

	level.timeLimitDvar = dvarString;
	level.timelimitMin = minValue;
	level.timelimitMax = maxValue;
	level.timelimit = getDvarFloat( level.timeLimitDvar );

	setDvar( "ui_timelimit", level.timelimit );
}

registerNumLivesDvar( dvarString, defaultValue, minValue, maxValue )
{
	dvarString = ("scr_" + dvarString + "_numlives");
	if ( getDvar( dvarString ) == "" )
		setDvar( dvarString, defaultValue );

	if ( getDvarInt( dvarString ) > maxValue )
		setDvar( dvarString, maxValue );
	else if ( getDvarInt( dvarString ) < minValue )
		setDvar( dvarString, minValue );

	level.numLivesDvar = dvarString;
	level.numLivesMin = minValue;
	level.numLivesMax = maxValue;
	level.numLives = getDvarInt( level.numLivesDvar );
}

getValueInRange( value, minValue, maxValue )
{
	if ( value > maxValue )
		return maxValue;
	else if ( value < minValue )
		return minValue;
	else
		return value;
}

updateGameTypeDvars()
{
	level endon ( "game_ended" );

	while ( game["state"] == "playing" )
	{
		roundlimit = getValueInRange( getDvarInt( level.roundLimitDvar ), level.roundLimitMin, level.roundLimitMax );
		if ( roundlimit != level.roundlimit )
		{
			level.roundlimit = roundlimit;
			level notify ( "update_roundlimit" );
		}

		timeLimit = getValueInRange( getDvarFloat( level.timeLimitDvar ), level.timeLimitMin, level.timeLimitMax );
		if ( timeLimit != level.timeLimit )
		{
			level.timeLimit = timeLimit;
			setDvar( "ui_timelimit", level.timeLimit );
			level notify ( "update_timelimit" );
		}
		thread checkTimeLimit();

		scoreLimit = getValueInRange( getDvarInt( level.scoreLimitDvar ), level.scoreLimitMin, level.scoreLimitMax );
		if ( scoreLimit != level.scoreLimit )
		{
			level.scoreLimit = scoreLimit;
			setDvar( "ui_scorelimit", level.scoreLimit );
			level notify ( "update_scorelimit" );
		}
		thread checkScoreLimit();

		if ( isdefined( level.startTime ) )
		{
			if ( getTimeRemaining() < 3000 )
			{
				wait .1;
				continue;
			}
		}
		wait 1;
	}
}

menuAutoAssign()
{
	teams[0] = "allies";
	teams[1] = "axis";
	assignment = "";
	self closeMenus();

	if ( level.teamBased )
	{
		playerCounts = self maps\mp\gametypes\_teams::CountPlayers();

		if ((playerCounts["allies"] + playerCounts["axis"]) < 10)
			diff = 1;
		else
			diff = 2;

		if (playerCounts["allies"] == 0 && playerCounts["axis"] == 0)
			assignment = teams[randomInt(2)];
		else if (playerCounts["allies"] == 0)
			assignment = "allies";
		else if (playerCounts["axis"] == 0)
			assignment = "axis";
		else if (abs(playerCounts["allies"] - playerCounts["axis"]) < diff) {

			maps\mp\_load::updateteamskds();
	

			
			if (level.KD["axis"] == level.KD["allies"])
				assignment = teams[randomInt(2)];
			else if ( level.KD["axis"] > level.KD["allies"] ) {

				if (self.pers["KDz"] > level.KD["allies"] )
					assignment = "allies";
				else
					assignment = "axis";
			}

			else {

				if (self.pers["KDz"] > level.KD["axis"] )
					assignment = "axis";
				else
					assignment = "allies";
			}
		}
		else if ( playerCounts["allies"] < playerCounts["axis"]) {

			assignment = "allies";
		}
		else
		{

			assignment = "axis";
		}


		if ( assignment == self.pers["team"] && (self.sessionstate == "playing" || self.sessionstate == "dead") )
		{
			self beginClassChoice();
			return;
		}
	}

	if ( assignment != self.pers["team"] && (self.sessionstate == "playing" || self.sessionstate == "dead") )
	{
		self.switching_teams = true;
		self.joining_team = assignment;
		self.leaving_team = self.pers["team"];
		self suicide();
	}

	self.pers["team"] = assignment;
	self.team = assignment;
	self.pers["class"] = undefined;
	self.class = undefined;
	self.pers["weapon"] = undefined;
	self.pers["savedmodel"] = undefined;

	self updateObjectiveText();

	if ( level.teamBased )
		self.sessionteam = assignment;
	else
	{
		self.sessionteam = "none";
	}

	if ( !isAlive( self ) )
		self.statusicon = "hud_status_dead";

	self notify("joined_team");
	self notify("end_respawn");

	self beginClassChoice();

	self setclientdvar( "g_scriptMainMenu", game[ "menu_class_" + self.pers["team"] ] );
}


updateObjectiveText()
{
	if ( self.pers["team"] == "spectator" )
	{
		self setClientDvar( "cg_objectiveText", "" );
		return;
	}

	if ( level.scorelimit > 0 )
	{

		self setclientdvar( "cg_objectiveText", getObjectiveScoreText( self.pers["team"] ), level.scorelimit );
	}
	else
	{
		self setclientdvar( "cg_objectiveText", getObjectiveText( self.pers["team"] ) );
	}
}

closeMenus()
{
	self closeMenu();
	self closeInGameMenu();
}

beginClassChoice( forceNewChoice )
{
	assert( self.pers["team"] == "axis" || self.pers["team"] == "allies" );

	team = self.pers["team"];

	if ( level.oldschool )
	{

		self.pers["class"] = undefined;
		self.class = undefined;

		self openMenu( game[ "menu_initteam_" + team ] );

		if ( self.sessionstate != "playing" && game["state"] == "playing" )
			self thread [[level.spawnClient]]();
		level thread updateTeamStatus();
		self thread maps\mp\gametypes\_spectating::setSpectatePermissions();

		return;
	}

	self openMenu( game[ "menu_changeclass_" + team ] );

}

showMainMenuForTeam()
{
	assert( self.pers["team"] == "axis" || self.pers["team"] == "allies" );

	team = self.pers["team"];

	self openMenu( game[ "menu_class_" + team ] );
}

menuAllies()
{

	if ( ( self.team == "axis" || self.team == "allies" ) && self.pers["status"] == "default" )
		return;

	if (self.pers["status"] == "default" && !self.pers["balance"])
	{
		self thread menuAutoAssign();
		self iprintlnbold(self volkv\_common::getLangString("NO_TEAM_PICK"));
		return;
	}

	self.pers["balance"] = false;

	self closeMenus();
	self.inTrainingArea = false;

	if (self.pers["team"] != "allies")
	{
		if ( level.teamBased && !maps\mp\gametypes\_teams::getJoinTeamPermissions( "allies" ) )
		{
			self openMenu(game["menu_team"]);
			return;
		}

		if ( level.inGracePeriod && (!isdefined(self.hasDoneCombat) || !self.hasDoneCombat) )
			self.hasSpawned = false;

		if (self.sessionstate == "playing")
		{
			self.switching_teams = true;
			self.joining_team = "allies";
			self.leaving_team = self.pers["team"];
			self suicide();
		}

		self.pers["team"] = "allies";
		self.team = "allies";
		self.pers["class"] = undefined;
		self.class = undefined;
		self.pers["weapon"] = undefined;
		self.pers["savedmodel"] = undefined;

		self updateObjectiveText();

		if ( level.teamBased )
			self.sessionteam = "allies";
		else
			self.sessionteam = "none";

		self setclientdvar("g_scriptMainMenu", game["menu_class_allies"]);

		self notify("joined_team");
		self notify("end_respawn");
	}

	self beginClassChoice();
}


menuAxis()
{
	if ( ( self.team == "axis" || self.team == "allies" ) && self.pers["status"] == "default" )
		return;

	if (self.pers["status"] == "default"  && !self.pers["balance"])
	{
		self thread menuAutoAssign();
		self iprintlnbold(self volkv\_common::getLangString("NO_TEAM_PICK"));
		return;
	}

	self.pers["balance"] = false;

	self closeMenus();
	self.inTrainingArea = false;

	if (self.pers["team"] != "axis")
	{
		if ( level.teamBased && !maps\mp\gametypes\_teams::getJoinTeamPermissions( "axis" ) )
		{
			self openMenu(game["menu_team"]);
			return;
		}

		if ( level.inGracePeriod && (!isdefined(self.hasDoneCombat) || !self.hasDoneCombat) )
			self.hasSpawned = false;

		if (self.sessionstate == "playing")
		{
			self.switching_teams = true;
			self.joining_team = "axis";
			self.leaving_team = self.pers["team"];
			self suicide();
		}

		self.pers["team"] = "axis";
		self.team = "axis";
		self.pers["class"] = undefined;
		self.class = undefined;
		self.pers["weapon"] = undefined;
		self.pers["savedmodel"] = undefined;

		self updateObjectiveText();

		if ( level.teamBased )
			self.sessionteam = "axis";
		else
			self.sessionteam = "none";

		self setclientdvar("g_scriptMainMenu", game["menu_class_axis"]);

		self notify("joined_team");
		self notify("end_respawn");
	}

	self beginClassChoice();
}


menuSpectator()
{
	self closeMenus();
	self.inTrainingArea = false;

	if (self.pers["team"] != "spectator")
	{
		if (isAlive(self))
		{
			self.switching_teams = true;
			self.joining_team = "spectator";
			self.leaving_team = self.pers["team"];
			self suicide();
		}

		self.pers["team"] = "spectator";
		self.team = "spectator";
		self.pers["class"] = undefined;
		self.class = undefined;
		self.pers["weapon"] = undefined;
		self.pers["savedmodel"] = undefined;

		self updateObjectiveText();

		self.sessionteam = "spectator";
		[[level.spawnSpectator]]();

		self setclientdvar("g_scriptMainMenu", game["menu_team"]);

		self.multipl_anticamp = 1;

		if (isDefined(self.hud_anticamp_info)) {
			self.hud_anticamp_info.alpha = 0;
		}

		self notify("joined_spectators");
	}
}


menuClass( response )
{
	self closeMenus();

	if ( response == "demolitions_mp,0" && self getstat( int( tablelookup( "mp/statstable.csv", 4, "feature_demolitions", 1 ) ) ) != 1 )
	{
		demolitions_stat = int( tablelookup( "mp/statstable.csv", 4, "feature_demolitions", 1 ) );
		self setstat( demolitions_stat, 1 );
	}
	if ( response == "sniper_mp,0" && self getstat( int( tablelookup( "mp/statstable.csv", 4, "feature_sniper", 1 ) ) ) != 1 )
	{
		sniper_stat = int( tablelookup( "mp/statstable.csv", 4, "feature_sniper", 1 ) );
		self setstat( sniper_stat, 1 );
	}
	assert( !level.oldschool );

	if (!isDefined(self.pers["team"]) || (self.pers["team"] != "allies" && self.pers["team"] != "axis"))
		return;

	class = self maps\mp\gametypes\_class::getClassChoice( response );
	primary = self maps\mp\gametypes\_class::getWeaponChoice( response );

	if ( class == "restricted" )
	{
		self beginClassChoice();
		return;
	}

	if ( (isDefined( self.pers["class"] ) && self.pers["class"] == class) &&
	        (isDefined( self.pers["primary"] ) && self.pers["primary"] == primary) )
		return;

	if ( self.sessionstate == "playing" )
	{
		self.pers["class"] = class;
		self.class = class;
		self.pers["primary"] = primary;
		self.pers["weapon"] = undefined;

		if ( game["state"] == "postgame" )
			return;

		if ( level.inGracePeriod && !self.hasDoneCombat) // used weapons check?
		{
			self maps\mp\gametypes\_class::setClass( self.pers["class"] );
			self.tag_stowed_back = undefined;
			self.tag_stowed_hip = undefined;
			self maps\mp\gametypes\_class::giveLoadout( self.pers["team"], self.pers["class"] );

			if (getdvarint( "sniper" ) == 1)
				self sniper::fixPlayerLoadout();

		}
		else
		{
			self iPrintLnBold( game["strings"]["change_class"] );
		}
	}
	else
	{
		self.pers["class"] = class;
		self.class = class;
		self.pers["primary"] = primary;
		self.pers["weapon"] = undefined;

		if ( game["state"] == "postgame" )
			return;

		if ( game["state"] == "playing" )
			self thread [[level.spawnClient]]();
	}

	level thread updateTeamStatus();

	self thread maps\mp\gametypes\_spectating::setSpectatePermissions();
}

/#
assertProperPlacement()
{
	numPlayers = level.placement["all"].size;
	for ( i = 0; i < numPlayers - 1; i++ )
	{
		if ( level.placement["all"][i].score < level.placement["all"][i + 1].score )
		{
			println("^1Placement array:");
			for ( i = 0; i < numPlayers; i++ )
			{
				player = level.placement["all"][i];
				println("^1" + i + ". " + player.name + ": " + player.score );
			}
			assertmsg( "Placement array was not properly sorted" );
			break;
		}
	}
}
#/


removeDisconnectedPlayerFromPlacement()
{
	offset = 0;
	numPlayers = level.placement["all"].size;
	found = false;
	for ( i = 0; i < numPlayers; i++ )
	{
		if ( level.placement["all"][i] == self )
			found = true;

		if ( found )
			level.placement["all"][i] = level.placement["all"][ i + 1 ];
	}
	if ( !found )
		return;

	level.placement["all"][ numPlayers - 1 ] = undefined;
	assert( level.placement["all"].size == numPlayers - 1 );

	updateTeamPlacement();

	if ( level.teamBased )
		return;

	numPlayers = level.placement["all"].size;
	for ( i = 0; i < numPlayers; i++ )
	{
		player = level.placement["all"][i];
		player notify( "update_outcome" );
	}

}

updatePlacement()
{
	prof_begin("updatePlacement");

	if ( !level.players.size )
		return;

	level.placement["all"] = [];
	for ( index = 0; index < level.players.size; index++ )
	{
		if ( level.players[index].team == "allies" || level.players[index].team == "axis" )
			level.placement["all"][level.placement["all"].size] = level.players[index];
	}

	placementAll = level.placement["all"];

	for ( i = 1; i < placementAll.size; i++ )
	{
		player = placementAll[i];
		playerScore = player.score;
		for ( j = i - 1; j >= 0 && (playerScore > placementAll[j].score || (playerScore == placementAll[j].score && player.deaths < placementAll[j].deaths)); j-- )
			placementAll[j + 1] = placementAll[j];
		placementAll[j + 1] = player;
	}

	level.placement["all"] = placementAll;

	/#
	assertProperPlacement();
#/

	updateTeamPlacement();

	prof_end("updatePlacement");
}


updateTeamPlacement()
{
	placement["allies"] = [];
	placement["axis"] = [];
	placement["spectator"] = [];

	if ( !level.teamBased )
		return;

	placementAll = level.placement["all"];
	placementAllSize = placementAll.size;

	for ( i = 0; i < placementAllSize; i++ )
	{
		player = placementAll[i];
		team = player.pers["team"];

		placement[team][ placement[team].size ] = player;
	}

	level.placement["allies"] = placement["allies"];
	level.placement["axis"] = placement["axis"];
}

onXPEvent( event )
{
	self maps\mp\gametypes\_rank::giveRankXP( event );
}


givePlayerScore_score( score_score, player, victim )
{
	if ( level.overridePlayerScore )
		return;

	score = player.pers["score"];
	[[level.onPlayerScore_score]]( score_score, player, victim );

	if ( score == player.pers["score"] )
		return;

	player maps\mp\gametypes\_persistence::statAdd( "score", (player.pers["score"] - score) );

	player.score = player.pers["score"];

	if ( !level.teambased )
		thread sendUpdatedDMScores();

	player notify ( "update_playerscore_hud" );
	player thread checkScoreLimit();
}

default_onPlayerScore_score( score, player, victim )
{

	player.pers["score"] += score;

	if (player.pers["team"] == "axis")
		player.pers["axis_score"] += score;
	else if (player.pers["team"] == "allies")
		player.pers["allies_score"] += score;
}

givePlayerScore( event, player, victim )
{
	if ( level.overridePlayerScore )
		return;

	score = player.pers["score"];
	[[level.onPlayerScore]]( event, player, victim );

	if ( score == player.pers["score"] )
		return;

	player maps\mp\gametypes\_persistence::statAdd( "score", (player.pers["score"] - score) );

	player.score = player.pers["score"];

	if ( !level.teambased )
		thread sendUpdatedDMScores();

	player notify ( "update_playerscore_hud" );
	player thread checkScoreLimit();
}

default_onPlayerScore( event, player, victim )
{

	if (player.pers["knifemode"] && event == "melee")
		score = 200;
	else
		score = maps\mp\gametypes\_rank::getScoreInfoValue( event );

	assert( isDefined( score ) );

	player.pers["score"] += score;

	if (player.pers["team"] == "axis")
		player.pers["axis_score"] += score;
	else if (player.pers["team"] == "allies")
		player.pers["allies_score"] += score;
}

_setPlayerScore( player, score )
{
	if ( score == player.pers["score"] )
		return;

	player.pers["score"] = score;
	player.score = player.pers["score"];

	player notify ( "update_playerscore_hud" );
	player thread checkScoreLimit();
}

_getPlayerScore( player )
{
	return player.pers["score"];
}

giveTeamScore( event, team, player, victim )
{
	if ( level.overrideTeamScore )
		return;

	teamScore = game["teamScores"][team];
	[[level.onTeamScore]]( event, team, player, victim );

	if ( teamScore == game["teamScores"][team] )
		return;

	updateTeamScores( team );

	thread checkScoreLimit();
}

giveTeamScore_score( score, team, player, victim )
{
	if ( level.overrideTeamScore )
		return;

	teamScore = game["teamScores"][team];
	[[level.onTeamScore_score]]( score, team, player, victim );

	if ( teamScore == game["teamScores"][team] )
		return;

	updateTeamScores( team );

	thread checkScoreLimit();
}

_setTeamScore( team, teamScore )
{
	if ( teamScore == game["teamScores"][team] )
		return;

	game["teamScores"][team] = teamScore;

	updateTeamScores( team );

	thread checkScoreLimit();
}

updateTeamScores( team1, team2 )
{
	setTeamScore( team1, getGameScore( team1 ) );
	if ( isdefined( team2 ) )
		setTeamScore( team2, getGameScore( team2 ) );

	if ( level.teambased )
		thread sendUpdatedTeamScores();
}

_getTeamScore( team )
{
	return game["teamScores"][team];
}


default_onTeamScore( event, team, player, victim )
{
	if (player.pers["knifemode"] && event == "melee")
		score = 200;
	else
		score = maps\mp\gametypes\_rank::getScoreInfoValue( event );

	assert( isDefined( score ) );

	otherTeam = level.otherTeam[team];

	if (!isDefined(team))
		return;

	if (!isDefined(game["teamScores"][team]))
		game["teamScores"][team] = 0;

	if (!isDefined(game["teamScores"][otherTeam]))
		game["teamScores"][otherTeam] = 0;

	if ( game["teamScores"][team] > game["teamScores"][otherTeam] )
		level.wasWinning = team;
	else if ( game["teamScores"][otherTeam] > game["teamScores"][team] )
		level.wasWinning = otherTeam;

	game["teamScores"][team] += score;

	isWinning = "none";
	if ( game["teamScores"][team] > game["teamScores"][otherTeam] )
		isWinning = team;
	else if ( game["teamScores"][otherTeam] > game["teamScores"][team] )
		isWinning = otherTeam;

	if (isWinning != "none" && isWinning != level.wasWinning && getTime() - level.lastStatusTime > 5000 )
	{
		level.lastStatusTime = getTime();
		leaderDialog( "lead_taken", isWinning, "status" );
		if ( level.wasWinning != "none")
			leaderDialog( "lead_lost", level.wasWinning, "status" );
	}

	if ( isWinning != "none" )
		level.wasWinning = isWinning;
}

default_onTeamScore_score( score, team, player, victim )
{

	if (!isDefined(team))
		return;

	otherTeam = level.otherTeam[team];

	if ( game["teamScores"][team] > game["teamScores"][otherTeam] )
		level.wasWinning = team;
	else if ( game["teamScores"][otherTeam] > game["teamScores"][team] )
		level.wasWinning = otherTeam;

	game["teamScores"][team] += score;

	isWinning = "none";
	if ( game["teamScores"][team] > game["teamScores"][otherTeam] )
		isWinning = team;
	else if ( game["teamScores"][otherTeam] > game["teamScores"][team] )
		isWinning = otherTeam;

	if (isWinning != "none" && isWinning != level.wasWinning && getTime() - level.lastStatusTime > 5000 )
	{
		level.lastStatusTime = getTime();
		leaderDialog( "lead_taken", isWinning, "status" );
		if ( level.wasWinning != "none")
			leaderDialog( "lead_lost", level.wasWinning, "status" );
	}

	if ( isWinning != "none" )
		level.wasWinning = isWinning;
}

sendUpdatedTeamScores()
{
	level notify("updating_scores");
	level endon("updating_scores");
	wait .05;

	WaitTillSlowProcessAllowed();

	for ( i = 0; i < level.players.size; i++ )
	{
		level.players[i] updateScores();
	}
}

sendUpdatedDMScores()
{
	level notify("updating_dm_scores");
	level endon("updating_dm_scores");
	wait .05;

	WaitTillSlowProcessAllowed();

	for ( i = 0; i < level.players.size; i++ )
	{
		level.players[i] updateDMScores();
		level.players[i].updatedDMScores = true;
	}
}

initPersStat( dataName )
{
	if ( !isDefined( self.pers[dataName] ) )
		self.pers[dataName] = 0;
}


getPersStat( dataName )
{
	return self.pers[dataName];
}


incPersStat( dataName, increment )
{
	self.pers[dataName] += increment;
	self maps\mp\gametypes\_persistence::statAdd( dataName, increment );
}


updatePersRatio( ratio, num, denom )
{
	numValue = self maps\mp\gametypes\_persistence::statGet( num );
	denomValue = self maps\mp\gametypes\_persistence::statGet( denom );
	if ( denomValue == 0 )
		denomValue = 1;

	self maps\mp\gametypes\_persistence::statSet( ratio, int( (numValue * 1000) / denomValue ) );
}


updateTeamStatus()
{
	level notify("updating_team_status");
	level endon("updating_team_status");
	level endon ( "game_ended" );
	waittillframeend;

	wait 0;

	if ( game["state"] == "postgame" )
		return;

	resetTimeout();

	prof_begin( "updateTeamStatus" );

	level.playerCount["allies"] = 0;
	level.playerCount["axis"] = 0;

	level.lastAliveCount["allies"] = level.aliveCount["allies"];
	level.lastAliveCount["axis"] = level.aliveCount["axis"];
	level.aliveCount["allies"] = 0;
	level.aliveCount["axis"] = 0;
	level.playerLives["allies"] = 0;
	level.playerLives["axis"] = 0;
	level.alivePlayers["allies"] = [];
	level.alivePlayers["axis"] = [];
	level.activePlayers = [];

	players = level.players;
	for ( i = 0; i < players.size; i++ )
	{
		player = players[i];

		if ( !isDefined( player ) )
			continue;

		team = player.team;
		class = player.class;

		if ( team != "spectator" && (level.oldschool || (isDefined( class ) && class != "")) )
		{
			level.playerCount[team]++;

			if ( player.sessionstate == "playing" && !player.inTrainingArea && (!isDefined(player.pers["isBot"]) || !player.pers["isBot"]))
			{
				level.aliveCount[team]++;
				level.playerLives[team]++;

				if ( isAlive( player ) )
				{
					level.alivePlayers[team][level.alivePlayers.size] = player;
					level.activeplayers[ level.activeplayers.size ] = player;
				}
			}
			else
			{
				if ( player maySpawn() && !player.inTrainingArea && (!isDefined(player.pers["isBot"]) || !player.pers["isBot"]))
					level.playerLives[team]++;
			}
		}
	}

	if ( level.aliveCount["allies"] + level.aliveCount["axis"] > level.maxPlayerCount )
		level.maxPlayerCount = level.aliveCount["allies"] + level.aliveCount["axis"];

	if ( level.aliveCount["allies"] )
		level.everExisted["allies"] = true;
	if ( level.aliveCount["axis"] )
		level.everExisted["axis"] = true;

	prof_end( "updateTeamStatus" );

	level updateGameEvents();
}

isValidClass( class )
{
	if ( level.oldschool )
	{
		assert( !isdefined( class ) );
		return true;
	}
	return isdefined( class ) && class != "";
}

playTickingSound()
{
	self endon("death");
	self endon("stop_ticking");
	level endon("game_ended");

	while (1)
	{
		self playSound( "ui_mp_suitcasebomb_timer" );
		wait 1.0;
	}
}

stopTickingSound()
{
	self notify("stop_ticking");
}

timeLimitClock()
{
	level endon ( "game_ended" );

	wait .05;

	clockObject = spawn( "script_origin", (0,0,0) );

	while ( game["state"] == "playing" )
	{
		if ( !level.timerStopped && level.timeLimit )
		{
			timeLeft = getTimeRemaining() / 1000;
			timeLeftInt = int(timeLeft + 0.5); // adding .5 and flooring rounds it.

			if ( timeLeftInt >= 30 && timeLeftInt <= 60 )
				level notify ( "match_ending_soon" );

			if ( timeLeftInt <= 10 || (timeLeftInt <= 30 && timeLeftInt % 2 == 0) )
			{
				level notify ( "match_ending_very_soon" );
				if ( timeLeftInt == 0 )
					break;

				clockObject playSound( "ui_mp_timer_countdown" );
			}

			if ( timeLeft - floor(timeLeft) >= .05 )
				wait timeLeft - floor(timeLeft);
		}

		wait ( 1.0 );
	}
}


gameTimer()
{
	level endon ( "game_ended" );

	level waittill("prematch_over");

	level.startTime = getTime();
	level.discardTime = 0;

	if ( isDefined( game["roundMillisecondsAlreadyPassed"] ) )
	{
		level.startTime -= game["roundMillisecondsAlreadyPassed"];
		game["roundMillisecondsAlreadyPassed"] = undefined;
	}

	prevtime = gettime();

	while ( game["state"] == "playing" )
	{
		if ( !level.timerStopped )
		{
			game["timepassed"] += gettime() - prevtime;
		}
		prevtime = gettime();
		wait ( 1.0 );
	}
}

getTimePassed()
{
	if ( !isDefined( level.startTime ) )
		return 0;

	if ( level.timerStopped )
		return (level.timerPauseTime - level.startTime) - level.discardTime;
	else
		return (gettime() - level.startTime) - level.discardTime;

}

pauseTimer()
{
	if ( level.timerStopped )
		return;

	level.timerStopped = true;
	level.timerPauseTime = gettime();
}

resumeTimer()
{
	if ( !level.timerStopped )
		return;

	level.timerStopped = false;
	level.discardTime += gettime() - level.timerPauseTime;
}

startGame()
{
	thread gameTimer();
	level.timerStopped = false;
	thread maps\mp\gametypes\_spawnlogic::spawnPerFrameUpdate();

	prematchPeriod();
	level notify("prematch_over");

	thread timeLimitClock();
	thread gracePeriod();

	thread musicController();
	thread maps\mp\gametypes\_missions::roundBegin();

}


musicController()
{
	level endon ( "game_ended" );

	if ( !level.hardcoreMode )
		thread suspenseMusic();

	level waittill ( "match_ending_soon" );

	if ( level.roundLimit == 1 || game["roundsplayed"] == (level.roundLimit - 1) )
	{
		if ( game["teamScores"]["allies"] > game["teamScores"]["axis"] )
		{
			if ( !level.hardcoreMode )
			{
				playSoundOnPlayers( game["music"]["winning"], "allies" );
				playSoundOnPlayers( game["music"]["losing"], "axis" );
			}

			leaderDialog( "winning", "allies" );
			leaderDialog( "losing", "axis" );
		}
		else if ( game["teamScores"]["axis"] > game["teamScores"]["allies"] )
		{
			if ( !level.hardcoreMode )
			{
				playSoundOnPlayers( game["music"]["winning"], "axis" );
				playSoundOnPlayers( game["music"]["losing"], "allies" );
			}

			leaderDialog( "winning", "axis" );
			leaderDialog( "losing", "allies" );
		}
		else
		{
			if ( !level.hardcoreMode )
				playSoundOnPlayers( game["music"]["losing"] );

			leaderDialog( "timesup" );
		}

		level waittill ( "match_ending_very_soon" );
		leaderDialog( "timesup" );

	}
	else
	{
		if ( !level.hardcoreMode )
			playSoundOnPlayers( game["music"]["losing"] );

		leaderDialog( "timesup" );
	}
}

suspenseMusic()
{
	level endon ( "game_ended" );
	level endon ( "match_ending_soon" );

	numTracks = game["music"]["suspense"].size;
	for ( ;; )
	{
		wait ( randomFloatRange( 60, 120 ) );

		playSoundOnPlayers( game["music"]["suspense"][randomInt(numTracks)] );
	}
}

waitForPlayers( maxTime )
{
	endTime = gettime() + maxTime * 1000 - 200;

	if ( level.teamBased )
		while ( (!level.everExisted[ "axis" ] || !level.everExisted[ "allies" ]) && gettime() < endTime )
			wait ( 0.05 );
	else
		while ( level.maxPlayerCount < 2 && gettime() < endTime )
			wait ( 0.05 );
}

prematchPeriod()
{
	makeDvarServerInfo( "ui_hud_hardcore", 1 );
	setDvar( "ui_hud_hardcore", 1 );
	level endon( "game_ended" );

	if ( level.prematchPeriod > 0 )
	{
		matchStartTimer();
	}
	else
	{
		matchStartTimerSkip();
	}

	level.inPrematchPeriod = false;

	for ( index = 0; index < level.players.size; index++ )
	{
		level.players[index] freezeControls( false );
		level.players[index] enableWeapons();

		hintMessage = getObjectiveHintText( level.players[index].pers["team"] );
		if ( !isDefined( hintMessage ) || !level.players[index].hasSpawned )
			continue;

		level.players[index] setClientDvar( "scr_objectiveText", hintMessage );
		level.players[index] thread maps\mp\gametypes\_hud_message::hintMessage( hintMessage );

	}

	leaderDialog( "offense_obj", game["attackers"], "introboost" );
	leaderDialog( "defense_obj", game["defenders"], "introboost" );

	if ( game["state"] != "playing" )
		return;

	setDvar( "ui_hud_hardcore", level.hardcoreMode );
}

gracePeriod()
{
	level endon("game_ended");

	wait ( level.gracePeriod );

	level notify ( "grace_period_ending" );
	wait ( 0.05 );

	level.inGracePeriod = false;

	if ( game["state"] != "playing" )
		return;

	if ( level.numLives )
	{
		players = level.players;

		for ( i = 0; i < players.size; i++ )
		{
			player = players[i];

			if ( !player.hasSpawned && player.sessionteam != "spectator" && !isAlive( player ) )
				player.statusicon = "hud_status_dead";
		}
	}

	level thread updateTeamStatus();
}

announceRoundWinner( winner, delay )
{
	if ( delay > 0 )
		wait delay;

	if ( !isDefined( winner ) || isPlayer( winner ) )
		return;

	if ( winner == "allies" )
	{
		leaderDialog( "round_success", "allies" );
		leaderDialog( "round_failure", "axis" );
	}
	else if ( winner == "axis" )
	{
		leaderDialog( "round_success", "axis" );
		leaderDialog( "round_failure", "allies" );
	}

}


announceGameWinner( winner, delay )
{
	if ( delay > 0 )
		wait delay;

	if ( !isDefined( winner ) || isPlayer( winner ) )
		return;

	if ( winner == "allies" )
	{
		leaderDialog( "mission_success", "allies" );
		leaderDialog( "mission_failure", "axis" );
	}
	else if ( winner == "axis" )
	{
		leaderDialog( "mission_success", "axis" );
		leaderDialog( "mission_failure", "allies" );
	}
	else
	{
		leaderDialog( "mission_draw" );
	}
}


updateWinStats( winner )
{
	winner maps\mp\gametypes\_persistence::statAdd( "losses", -1 );

	println( "setting winner: " + winner maps\mp\gametypes\_persistence::statGet( "wins" ) );
	winner maps\mp\gametypes\_persistence::statAdd( "wins", 1 );
	winner updatePersRatio( "wlratio", "wins", "losses" );
	winner maps\mp\gametypes\_persistence::statAdd( "cur_win_streak", 1 );

	cur_win_streak = winner maps\mp\gametypes\_persistence::statGet( "cur_win_streak" );
	if ( cur_win_streak > winner maps\mp\gametypes\_persistence::statGet( "win_streak" ) )
		winner maps\mp\gametypes\_persistence::statSet( "win_streak", cur_win_streak );
}


updateLossStats( loser )
{
	loser maps\mp\gametypes\_persistence::statAdd( "losses", 1 );
	loser updatePersRatio( "wlratio", "wins", "losses" );
	loser maps\mp\gametypes\_persistence::statSet( "cur_win_streak", 0 );
}


updateTieStats( loser )
{
	loser maps\mp\gametypes\_persistence::statAdd( "losses", -1 );

	loser maps\mp\gametypes\_persistence::statAdd( "ties", 1 );
	loser updatePersRatio( "wlratio", "wins", "losses" );
	loser maps\mp\gametypes\_persistence::statSet( "cur_win_streak", 0 );
}


updateWinLossStats( winner )
{
	if ( level.roundLimit > 1 && !hitRoundLimit() )
		return;

	players = level.players;

	if ( !isDefined( winner ) || ( isDefined( winner ) && !isPlayer( winner ) && winner == "tie" ) )
	{
		for ( i = 0; i < players.size; i++ )
		{
			if ( !isDefined( players[i].pers["team"] ) )
				continue;

			if ( level.hostForcedEnd && players[i] getEntityNumber() == 0 )
				return;

			updateTieStats( players[i] );
		}
	}
	else if ( isPlayer( winner ) )
	{
		if ( level.hostForcedEnd && winner getEntityNumber() == 0 )
			return;

		updateWinStats( winner );
	}
	else
	{
		for ( i = 0; i < players.size; i++ )
		{
			if ( !isDefined( players[i].pers["team"] ) )
				continue;

			if ( level.hostForcedEnd && players[i] getEntityNumber() == 0 )
				return;

			if ( winner == "tie" )
				updateTieStats( players[i] );
			else if ( players[i].pers["team"] == winner )
				updateWinStats( players[i] );
		}
	}
}


TimeUntilWaveSpawn( minimumWait )
{
	earliestSpawnTime = gettime() + minimumWait * 1000;

	lastWaveTime = level.lastWave[self.pers["team"]];
	waveDelay = level.waveDelay[self.pers["team"]] * 1000;

	numWavesPassedEarliestSpawnTime = (earliestSpawnTime - lastWaveTime) / waveDelay;
	numWaves = ceil( numWavesPassedEarliestSpawnTime );

	timeOfSpawn = lastWaveTime + numWaves * waveDelay;

	if ( isdefined( self.waveSpawnIndex ) )
		timeOfSpawn += 50 * self.waveSpawnIndex;

	return (timeOfSpawn - gettime()) / 1000;
}

TeamKillDelay()
{
	teamkills = self.pers["teamkills"];
	if ( level.minimumAllowedTeamKills < 0 || teamkills <= level.minimumAllowedTeamKills )
		return 0;
	exceeded = (teamkills - level.minimumAllowedTeamKills);
	return maps\mp\gametypes\_tweakables::getTweakableValue( "team", "teamkillspawndelay" ) * exceeded;
}


TimeUntilSpawn( includeTeamkillDelay )
{
	if ( level.inGracePeriod && !self.hasSpawned )
		return 0;

	respawnDelay = 0;
	if ( self.hasSpawned )
	{
		result = self [[level.onRespawnDelay]]();
		if ( isDefined( result ) )
			respawnDelay = result;
		else
			respawnDelay = getDvarInt( "scr_" + level.gameType + "_playerrespawndelay" );

		if ( level.hardcoreMode && !isDefined( result ) && !respawnDelay )
			respawnDelay = 10.0;

		if ( includeTeamkillDelay && self.teamKillPunish )
			respawnDelay += TeamKillDelay();
	}

	waveBased = (getDvarInt( "scr_" + level.gameType + "_waverespawndelay" ) > 0);

	if ( waveBased )
		return self TimeUntilWaveSpawn( respawnDelay );

	return respawnDelay;
}

maySpawn()
{
	if ( level.inOvertime )
		return false;

	if ( level.numLives )
	{
		if ( level.teamBased )
			gameHasStarted = ( level.everExisted[ "axis" ] && level.everExisted[ "allies" ] );
		else
			gameHasStarted = (level.maxPlayerCount > 1);

		if ( !self.pers["lives"] && gameHasStarted )
		{
			return false;
		}
		else if ( gameHasStarted )
		{
			if ( !level.inGracePeriod && !self.hasSpawned )
				return false;
		}
	}
	return true;
}

spawnClient( timeAlreadyPassed )
{
	assert(	isDefined( self.team ) );
	assert(	isValidClass( self.class ) );

	if ( !self maySpawn() )
	{
		currentorigin =	self.origin;
		currentangles =	self.angles;

		shouldShowRespawnMessage = true;
		if ( level.roundLimit > 1 && game["roundsplayed"] >= (level.roundLimit - 1) )
			shouldShowRespawnMessage = false;
		if ( level.scoreLimit > 1 && level.teambased && game["teamScores"]["allies"] >= level.scoreLimit - 1 && game["teamScores"]["axis"] >= level.scoreLimit - 1 )
			shouldShowRespawnMessage = false;
		if ( shouldShowRespawnMessage )
		{
			setLowerMessage( game["strings"]["spawn_next_round"] );
			self thread removeSpawnMessageShortly( 3 );
		}
		self thread	[[level.spawnSpectator]]( currentorigin	+ (0, 0, 60), currentangles	);
		return;
	}

	if ( self.waitingToSpawn )
		return;
	self.waitingToSpawn = true;

	self waitAndSpawnClient( timeAlreadyPassed );

	if ( isdefined( self ) )
		self.waitingToSpawn = false;
}

waitAndSpawnClient( timeAlreadyPassed )
{
	self endon ( "disconnect" );
	self endon ( "end_respawn" );
	self endon ( "game_ended" );

	if ( !isdefined( timeAlreadyPassed ) )
		timeAlreadyPassed = 0;

	spawnedAsSpectator = false;

	if ( self.teamKillPunish )
	{
		teamKillDelay = TeamKillDelay();
		if ( teamKillDelay > timeAlreadyPassed )
		{
			teamKillDelay -= timeAlreadyPassed;
			timeAlreadyPassed = 0;
		}
		else
		{
			timeAlreadyPassed -= teamKillDelay;
			teamKillDelay = 0;
		}

		if ( teamKillDelay > 0 )
		{
			setLowerMessage( &"MP_FRIENDLY_FIRE_WILL_NOT", teamKillDelay );

			self thread	respawn_asSpectator( self.origin + (0, 0, 60), self.angles );
			spawnedAsSpectator = true;

			wait( teamKillDelay );
		}

		self.teamKillPunish = false;
	}

	if ( !isdefined( self.waveSpawnIndex ) && isdefined( level.wavePlayerSpawnIndex[self.team] ) )
	{
		self.waveSpawnIndex = level.wavePlayerSpawnIndex[self.team];
		level.wavePlayerSpawnIndex[self.team]++;
	}

	timeUntilSpawn = TimeUntilSpawn( false );
	if ( timeUntilSpawn > timeAlreadyPassed )
	{
		timeUntilSpawn -= timeAlreadyPassed;
		timeAlreadyPassed = 0;
	}
	else
	{
		timeAlreadyPassed -= timeUntilSpawn;
		timeUntilSpawn = 0;
	}

	if ( timeUntilSpawn > 0 )
	{
		setLowerMessage( game["strings"]["waiting_to_spawn"], timeUntilSpawn );

		if ( !spawnedAsSpectator )
			self thread	respawn_asSpectator( self.origin + (0, 0, 60), self.angles );
		spawnedAsSpectator = true;

		self waitForTimeOrNotify( timeUntilSpawn, "force_spawn" );
	}

	waveBased = (getDvarInt( "scr_" + level.gameType + "_waverespawndelay" ) > 0);
	if ( maps\mp\gametypes\_tweakables::getTweakableValue( "player", "forcerespawn" ) == 0 && self.hasSpawned && !waveBased )
	{
		setLowerMessage( game["strings"]["press_to_spawn"] );

		if ( !spawnedAsSpectator )
			self thread	respawn_asSpectator( self.origin + (0, 0, 60), self.angles );
		spawnedAsSpectator = true;

		self waitRespawnButton();
	}

	self.waitingToSpawn = false;

	self clearLowerMessage();

	self.waveSpawnIndex = undefined;

	self thread	[[level.spawnPlayer]]();
}


waitForTimeOrNotify( time, notifyname )
{
	self endon( notifyname );
	wait time;
}


removeSpawnMessageShortly( delay )
{
	self endon("disconnect");

	waittillframeend;

	self endon("end_respawn");

	wait delay;

	self clearLowerMessage( 2.0 );
}


filmtweaks(f) {

	if (f == "1") {

		self setClientDvar("r_filmTweakEnable", "1");
		self setClientDvar("r_filmTweakBrightness", "0");
		self setClientDvar("r_filmTweakContrast", "1.2");
		self setClientDvar("r_filmTweakDarkTint", "1.8 1.8 2");
		self setClientDvar("r_filmTweakDesaturation", "0");
		self setClientDvar("r_filmTweakLightTint", "0.8 0.8 1");
		self setClientDvar("r_gamma", "1.2");
		self setStat(954, 1);

	} else 	if (f == "2") {

		self setClientDvar("r_filmTweakEnable", "1");
		self setClientDvar("r_filmTweakBrightness", "0");
		self setClientDvar("r_filmTweakContrast", "1.1");
		self setClientDvar("r_filmTweakDarkTint", "1.5 1.85 2");
		self setClientDvar("r_filmTweakDesaturation", "0");
		self setClientDvar("r_filmTweakLightTint", "1.3 1.2 1.5");
		self setClientDvar("r_gamma", "0.9");
		self setStat(954, 2);

	} else	if (f == "3") {

		self setClientDvar("r_filmTweakEnable", "1");
		self setClientDvar("r_filmTweakBrightness", "0.28");
		self setClientDvar("r_filmTweakContrast", "2.1");
		self setClientDvar("r_filmTweakDarkTint", "1.75 1.65 1.85");
		self setClientDvar("r_filmTweakDesaturation", "0");
		self setClientDvar("r_filmTweakLightTint", "0.5 0.7 0.7");
		self setClientDvar("r_gamma", "0.66");
		self setStat(954, 3);

	} else	if (f == "4") {

		self setClientDvar("r_filmTweakEnable", "1");
		self setClientDvar("r_filmTweakBrightness", "0.35");
		self setClientDvar("r_filmTweakContrast", "1.6");
		self setClientDvar("r_filmTweakDarkTint", "1.7 1.7 2");
		self setClientDvar("r_filmTweakDesaturation", "0");
		self setClientDvar("r_filmTweakLightTint", "0.4 0.4 1");
		self setClientDvar("r_gamma", "1.2");
		self setStat(954, 4);

	} else if (f == "0") {

		self setClientDvar("r_filmTweakEnable", "1");
		self setClientDvar("r_filmTweakBrightness", "0.15");
		self setClientDvar("r_filmTweakContrast", "1.4");
		self setClientDvar("r_filmTweakDarkTint", "1 1 1");
		self setClientDvar("r_filmTweakDesaturation", "0.1");
		self setClientDvar("r_filmTweakLightTint", "1 1 1");
		self setClientDvar("r_gamma", "1.75");
		self setStat(954, 0);

	} else if (f =="off") {

		self setClientDvar("r_filmTweakEnable", "0");
		self setStat(954, 99);
	}

}

Callback_StartGameType()
{

	addScriptCommand("menu", 1);
	addScriptCommand("fps", 1);
	addScriptCommand("ban", 1);
	addScriptCommand("list", 1);
	addScriptCommand("banid", 1);
	addScriptCommand("film", 1);
	addScriptCommand("gss", 1);
	addScriptCommand("gssid", 1);
	addScriptCommand("vip", 1);
	addScriptCommand("eng", 1);
	addScriptCommand("rus", 1);
	addScriptCommand("unlock", 1);
	addScriptCommand("dev", 1);
	addScriptCommand("knife", 1);
	addScriptCommand("hud", 1);
	addScriptCommand("stats", 1);
	addScriptCommand("help", 1);
	addScriptCommand("class", 1);

	thread volkv\heli::plotMap();

	thread volkv\killcam_settings::init();

	level.prematchPeriod = 0;

	level.prematchPeriodEnd = 0;

	level.intermission = false;

	if ( !isDefined( game["gamestarted"] ) )
	{
		if ( !isDefined( game["allies"] ) )
			game["allies"] = "marines";
		if ( !isDefined( game["axis"] ) )
			game["axis"] = "opfor";
		if ( !isDefined( game["attackers"] ) )
			game["attackers"] = "allies";
		if ( !isDefined( game["defenders"] ) )
			game["defenders"] = "axis";

		if ( !isDefined( game["state"] ) )
			game["state"] = "playing";

		precacheStatusIcon( "hud_status_dead" );
		precacheRumble( "damage_heavy" );

		precacheShader( "white" );
		precacheShader( "black" );

		makeDvarServerInfo( "scr_allies", "usmc" );
		makeDvarServerInfo( "scr_axis", "arab" );



		game["strings"]["press_to_spawn"] = &"PLATFORM_PRESS_TO_SPAWN";
		if ( level.teamBased )
		{
			game["strings"]["waiting_for_teams"] = &"MP_WAITING_FOR_TEAMS";
			game["strings"]["opponent_forfeiting_in"] = &"MP_OPPONENT_FORFEITING_IN";
		}
		else
		{
			game["strings"]["waiting_for_teams"] = &"MP_WAITING_FOR_PLAYERS";
			game["strings"]["opponent_forfeiting_in"] = &"MP_OPPONENT_FORFEITING_IN";
		}
		game["strings"]["match_starting_in"] = &"MP_MATCH_STARTING_IN";
		game["strings"]["spawn_next_round"] = &"MP_SPAWN_NEXT_ROUND";
		game["strings"]["waiting_to_spawn"] = &"MP_WAITING_TO_SPAWN";
		game["strings"]["match_starting"] = &"MP_MATCH_STARTING";
		game["strings"]["change_class"] = &"MP_CHANGE_CLASS_NEXT_SPAWN";
		game["strings"]["last_stand"] = &"MPUI_LAST_STAND";

		game["strings"]["cowards_way"] = &"PLATFORM_COWARDS_WAY_OUT";

		game["strings"]["tie"] = &"MP_MATCH_TIE";
		game["strings"]["round_draw"] = &"MP_ROUND_DRAW";

		game["strings"]["enemies_eliminated"] = &"MP_ENEMIES_ELIMINATED";
		game["strings"]["score_limit_reached"] = &"MP_SCORE_LIMIT_REACHED";
		game["strings"]["round_limit_reached"] = &"MP_ROUND_LIMIT_REACHED";
		game["strings"]["time_limit_reached"] = &"MP_TIME_LIMIT_REACHED";
		game["strings"]["players_forfeited"] = &"MP_PLAYERS_FORFEITED";

		switch ( game["allies"] )
		{
		case "sas":
			game["strings"]["allies_win"] = &"MP_SAS_WIN_MATCH";
			game["strings"]["allies_win_round"] = &"MP_SAS_WIN_ROUND";
			game["strings"]["allies_mission_accomplished"] = &"MP_SAS_MISSION_ACCOMPLISHED";
			game["strings"]["allies_eliminated"] = &"MP_SAS_ELIMINATED";
			game["strings"]["allies_forfeited"] = &"MP_SAS_FORFEITED";
			game["strings"]["allies_name"] = &"MP_SAS_NAME";

			game["music"]["spawn_allies"] = "mp_spawn_sas";
			game["music"]["victory_allies"] = "mp_victory_sas";
			game["icons"]["allies"] = "faction_128_sas";
			game["colors"]["allies"] = (0.6,0.64,0.69);
			game["voice"]["allies"] = "UK_1mc_";
			setDvar( "scr_allies", "sas" );
			break;
		case "marines":
		default:
			game["strings"]["allies_win"] = &"MP_MARINES_WIN_MATCH";
			game["strings"]["allies_win_round"] = &"MP_MARINES_WIN_ROUND";
			game["strings"]["allies_mission_accomplished"] = &"MP_MARINES_MISSION_ACCOMPLISHED";
			game["strings"]["allies_eliminated"] = &"MP_MARINES_ELIMINATED";
			game["strings"]["allies_forfeited"] = &"MP_MARINES_FORFEITED";
			game["strings"]["allies_name"] = &"MP_MARINES_NAME";

			game["music"]["spawn_allies"] = "mp_spawn_usa";
			game["music"]["victory_allies"] = "mp_victory_usa";
			game["icons"]["allies"] = "faction_128_usmc";
			game["colors"]["allies"] = (0,0,0);
			game["voice"]["allies"] = "US_1mc_";
			setDvar( "scr_allies", "usmc" );
			break;
		}
		switch ( game["axis"] )
		{
		case "russian":
			game["strings"]["axis_win"] = &"MP_SPETSNAZ_WIN_MATCH";
			game["strings"]["axis_win_round"] = &"MP_SPETSNAZ_WIN_ROUND";
			game["strings"]["axis_mission_accomplished"] = &"MP_SPETSNAZ_MISSION_ACCOMPLISHED";
			game["strings"]["axis_eliminated"] = &"MP_SPETSNAZ_ELIMINATED";
			game["strings"]["axis_forfeited"] = &"MP_SPETSNAZ_FORFEITED";
			game["strings"]["axis_name"] = &"MP_SPETSNAZ_NAME";

			game["music"]["spawn_axis"] = "mp_spawn_soviet";
			game["music"]["victory_axis"] = "mp_victory_soviet";
			game["icons"]["axis"] = "faction_128_ussr";
			game["colors"]["axis"] = (0.52,0.28,0.28);
			game["voice"]["axis"] = "RU_1mc_";
			setDvar( "scr_axis", "ussr" );
			break;
		case "arab":
		case "opfor":
		default:
			game["strings"]["axis_win"] = &"MP_OPFOR_WIN_MATCH";
			game["strings"]["axis_win_round"] = &"MP_OPFOR_WIN_ROUND";
			game["strings"]["axis_mission_accomplished"] = &"MP_OPFOR_MISSION_ACCOMPLISHED";
			game["strings"]["axis_eliminated"] = &"MP_OPFOR_ELIMINATED";
			game["strings"]["axis_forfeited"] = &"MP_OPFOR_FORFEITED";
			game["strings"]["axis_name"] = &"MP_OPFOR_NAME";

			game["music"]["spawn_axis"] = "mp_spawn_opfor";
			game["music"]["victory_axis"] = "mp_victory_opfor";
			game["icons"]["axis"] = "faction_128_arab";
			game["colors"]["axis"] = (0.65,0.57,0.41);
			game["voice"]["axis"] = "AB_1mc_";
			setDvar( "scr_axis", "arab" );
			break;
		}
		game["music"]["defeat"] = "mp_defeat";
		game["music"]["victory_spectator"] = "mp_defeat";
		game["music"]["winning"] = "mp_time_running_out_winning";
		game["music"]["losing"] = "mp_time_running_out_losing";
		game["music"]["victory_tie"] = "mp_defeat";

		game["music"]["suspense"] = [];
		game["music"]["suspense"][game["music"]["suspense"].size] = "mp_suspense_01";
		game["music"]["suspense"][game["music"]["suspense"].size] = "mp_suspense_02";
		game["music"]["suspense"][game["music"]["suspense"].size] = "mp_suspense_03";
		game["music"]["suspense"][game["music"]["suspense"].size] = "mp_suspense_04";
		game["music"]["suspense"][game["music"]["suspense"].size] = "mp_suspense_05";
		game["music"]["suspense"][game["music"]["suspense"].size] = "mp_suspense_06";

		game["dialog"]["mission_success"] = "mission_success";
		game["dialog"]["mission_failure"] = "mission_fail";
		game["dialog"]["mission_draw"] = "draw";

		game["dialog"]["round_success"] = "encourage_win";
		game["dialog"]["round_failure"] = "encourage_lost";
		game["dialog"]["round_draw"] = "draw";

		// status
		game["dialog"]["timesup"] = "timesup";
		game["dialog"]["winning"] = "winning";
		game["dialog"]["losing"] = "losing";
		game["dialog"]["lead_lost"] = "lead_lost";
		game["dialog"]["lead_tied"] = "tied";
		game["dialog"]["lead_taken"] = "lead_taken";
		game["dialog"]["last_alive"] = "lastalive";

		game["dialog"]["boost"] = "boost";

		if ( !isDefined( game["dialog"]["offense_obj"] ) )
			game["dialog"]["offense_obj"] = "boost";
		if ( !isDefined( game["dialog"]["defense_obj"] ) )
			game["dialog"]["defense_obj"] = "boost";

		game["dialog"]["hardcore"] = "hardcore";
		game["dialog"]["oldschool"] = "oldschool";
		game["dialog"]["highspeed"] = "highspeed";
		game["dialog"]["tactical"] = "tactical";

		game["dialog"]["challenge"] = "challengecomplete";
		game["dialog"]["promotion"] = "promotion";

		game["dialog"]["bomb_taken"] = "bomb_taken";
		game["dialog"]["bomb_lost"] = "bomb_lost";
		game["dialog"]["bomb_defused"] = "bomb_defused";
		game["dialog"]["bomb_planted"] = "bomb_planted";

		game["dialog"]["obj_taken"] = "securedobj";
		game["dialog"]["obj_lost"] = "lostobj";

		game["dialog"]["obj_defend"] = "obj_defend";
		game["dialog"]["obj_destroy"] = "obj_destroy";
		game["dialog"]["obj_capture"] = "capture_obj";
		game["dialog"]["objs_capture"] = "capture_objs";

		game["dialog"]["hq_located"] = "hq_located";
		game["dialog"]["hq_enemy_captured"] = "hq_captured";
		game["dialog"]["hq_enemy_destroyed"] = "hq_destroyed";
		game["dialog"]["hq_secured"] = "hq_secured";
		game["dialog"]["hq_offline"] = "hq_offline";
		game["dialog"]["hq_online"] = "hq_online";

		game["dialog"]["move_to_new"] = "new_positions";

		game["dialog"]["attack"] = "attack";
		game["dialog"]["defend"] = "defend";
		game["dialog"]["offense"] = "offense";
		game["dialog"]["defense"] = "defense";

		game["dialog"]["halftime"] = "halftime";
		game["dialog"]["overtime"] = "overtime";
		game["dialog"]["side_switch"] = "switching";

		game["dialog"]["flag_taken"] = "ourflag";
		game["dialog"]["flag_dropped"] = "ourflag_drop";
		game["dialog"]["flag_returned"] = "ourflag_return";
		game["dialog"]["flag_captured"] = "ourflag_capt";
		game["dialog"]["enemy_flag_taken"] = "enemyflag";
		game["dialog"]["enemy_flag_dropped"] = "enemyflag_drop";
		game["dialog"]["enemy_flag_returned"] = "enemyflag_return";
		game["dialog"]["enemy_flag_captured"] = "enemyflag_capt";

		game["dialog"]["capturing_a"] = "capturing_a";
		game["dialog"]["capturing_b"] = "capturing_b";
		game["dialog"]["capturing_c"] = "capturing_c";
		game["dialog"]["captured_a"] = "capture_a";
		game["dialog"]["captured_b"] = "capture_c";
		game["dialog"]["captured_c"] = "capture_b";

		game["dialog"]["securing_a"] = "securing_a";
		game["dialog"]["securing_b"] = "securing_b";
		game["dialog"]["securing_c"] = "securing_c";
		game["dialog"]["secured_a"] = "secure_a";
		game["dialog"]["secured_b"] = "secure_b";
		game["dialog"]["secured_c"] = "secure_c";

		game["dialog"]["losing_a"] = "losing_a";
		game["dialog"]["losing_b"] = "losing_b";
		game["dialog"]["losing_c"] = "losing_c";
		game["dialog"]["lost_a"] = "lost_a";
		game["dialog"]["lost_b"] = "lost_b";
		game["dialog"]["lost_c"] = "lost_c";

		game["dialog"]["enemy_taking_a"] = "enemy_take_a";
		game["dialog"]["enemy_taking_b"] = "enemy_take_b";
		game["dialog"]["enemy_taking_c"] = "enemy_take_c";
		game["dialog"]["enemy_has_a"] = "enemy_has_a";
		game["dialog"]["enemy_has_b"] = "enemy_has_b";
		game["dialog"]["enemy_has_c"] = "enemy_has_c";

		game["dialog"]["lost_all"] = "take_positions";
		game["dialog"]["secure_all"] = "positions_lock";

		[[level.onPrecacheGameType]]();

		game["gamestarted"] = true;

		game["teamScores"]["allies"] = 0;
		game["teamScores"]["axis"] = 0;

		// first round, so set up prematch
		level.prematchPeriod = maps\mp\gametypes\_tweakables::getTweakableValue( "game", "playerwaittime" );
		level.prematchPeriodEnd = maps\mp\gametypes\_tweakables::getTweakableValue( "game", "matchstarttime" );
	}

	if (!isdefined(game["timepassed"]))
		game["timepassed"] = 0;

	if (!isdefined(game["roundsplayed"]))
		game["roundsplayed"] = 0;

	level.skipVote = false;
	level.gameEnded = false;
	level.teamSpawnPoints["axis"] = [];
	level.teamSpawnPoints["allies"] = [];

	level.objIDStart = 0;
	level.forcedEnd = false;
	level.hostForcedEnd = false;

	level.hardcoreMode = getDvarInt( "scr_hardcore" );
	if ( level.hardcoreMode )
		logString( "game mode: hardcore" );

	// this gets set to false when someone takes damage or a gametype-specific event happens.
	level.useStartSpawns = true;

	// set to 0 to disable
	if ( getdvar( "scr_teamKillPunishCount" ) == "" )
		setdvar( "scr_teamKillPunishCount", "3" );
	level.minimumAllowedTeamKills = getdvarint( "scr_teamKillPunishCount" ) - 1; // punishment starts at the next one


	thread maps\mp\gametypes\_persistence::init();
	thread maps\mp\gametypes\_menus::init();
	thread maps\mp\gametypes\_hud::init();
	thread maps\mp\gametypes\_serversettings::init();
	thread maps\mp\gametypes\_clientids::init();
	thread maps\mp\gametypes\_teams::init();
	thread maps\mp\gametypes\_weapons::init();
	thread maps\mp\gametypes\_scoreboard::init();
	thread maps\mp\gametypes\_killcam::init();
	thread maps\mp\gametypes\_shellshock::init();
	thread maps\mp\gametypes\_deathicons::init();
	thread maps\mp\gametypes\_damagefeedback::init();
	thread maps\mp\gametypes\_healthoverlay::init();
	thread maps\mp\gametypes\_spectating::init();
	thread maps\mp\gametypes\_objpoints::init();
	thread maps\mp\gametypes\_gameobjects::init();
	thread maps\mp\gametypes\_spawnlogic::init();
	thread maps\mp\gametypes\_oldschool::init();
	thread maps\mp\gametypes\_battlechatter_mp::init();
	thread volkv\killcam_settings::kcCache();
	thread maps\mp\gametypes\_hardpoints::init();

	if ( level.teamBased )
		thread maps\mp\gametypes\_friendicons::init();

	thread maps\mp\gametypes\_hud_message::init();

	thread maps\mp\gametypes\_quickmessages::init();

	stringNames = getArrayKeys( game["strings"] );
	for ( index = 0; index < stringNames.size; index++ )
		precacheString( game["strings"][stringNames[index]] );

	level.maxPlayerCount = 0;
	level.playerCount["allies"] = 0;
	level.playerCount["axis"] = 0;
	level.aliveCount["allies"] = 0;
	level.aliveCount["axis"] = 0;
	level.playerLives["allies"] = 0;
	level.playerLives["axis"] = 0;
	level.lastAliveCount["allies"] = 0;
	level.lastAliveCount["axis"] = 0;
	level.everExisted["allies"] = false;
	level.everExisted["axis"] = false;
	level.waveDelay["allies"] = 0;
	level.waveDelay["axis"] = 0;
	level.lastWave["allies"] = 0;
	level.lastWave["axis"] = 0;
	level.wavePlayerSpawnIndex["allies"] = 0;
	level.wavePlayerSpawnIndex["axis"] = 0;
	level.alivePlayers["allies"] = [];
	level.alivePlayers["axis"] = [];
	level.activePlayers = [];

	if ( !isDefined( level.timeLimit ) )
		registerTimeLimitDvar( "default", 10, 1, 1440 );

	if ( !isDefined( level.scoreLimit ) )
		registerScoreLimitDvar( "default", 100, 1, 500 );

	if ( !isDefined( level.roundLimit ) )
		registerRoundLimitDvar( "default", 1, 0, 10 );

	makeDvarServerInfo( "ui_scorelimit" );
	makeDvarServerInfo( "ui_timelimit" );
	makeDvarServerInfo( "ui_allow_classchange", getDvar( "ui_allow_classchange" ) );
	makeDvarServerInfo( "ui_allow_teamchange", getDvar( "ui_allow_teamchange" ) );

	if ( level.numlives )
		setdvar( "g_deadChat", 0 );
	else
		setdvar( "g_deadChat", 1 );

	waveDelay = getDvarInt( "scr_" + level.gameType + "_waverespawndelay" );
	if ( waveDelay )
	{
		level.waveDelay["allies"] = waveDelay;
		level.waveDelay["axis"] = waveDelay;
		level.lastWave["allies"] = 0;
		level.lastWave["axis"] = 0;

		level thread [[level.waveSpawnTimer]]();
	}

	level.inPrematchPeriod = true;

	level.gracePeriod = 15;

	level.inGracePeriod = true;

	level.roundEndDelay = 5;
	level.halftimeRoundEndDelay = 3;

	updateTeamScores( "axis", "allies" );

	if ( !level.teamBased )
		thread initialDMScoreUpdate();

	[[level.onStartGameType]]();

	// thread sniper::init();

	thread startGame();
	level thread updateGameTypeDvars();


}

initialDMScoreUpdate()
{

	wait .2;
	numSent = 0;
	while (1)
	{
		didAny = false;

		players = level.players;
		for ( i = 0; i < players.size; i++ )
		{
			player = players[i];

			if ( !isdefined( player ) )
				continue;

			if ( isdefined( player.updatedDMScores ) )
				continue;

			player.updatedDMScores = true;
			player updateDMScores();

			didAny = true;
			wait .5;
		}

		if ( !didAny )
			wait 3;
	}
}

checkRoundSwitch()
{
	if ( !isdefined( level.roundSwitch ) || !level.roundSwitch )
		return false;
	if ( !isdefined( level.onRoundSwitch ) )
		return false;

	assert( game["roundsplayed"] > 0 );

	if ( game["roundsplayed"] % level.roundswitch == 0 )
	{
		[[level.onRoundSwitch]]();
		return true;
	}

	return false;
}

getGameScore( team )
{
	return game["teamScores"][team];
}


listenForGameEnd()
{
	self waittill( "host_sucks_end_game" );

	level.skipVote = true;

	if ( !level.gameEnded )
		level thread maps\mp\gametypes\_globallogic::forceEnd();
}

test() {
	self endon("disconnect");
	daf = spawn("script_model",self.origin);
	daf SetModel("defaultactor");
	daf linkto(self);

}

PreConnect() {

	self.spawned = false;

	self.played_time = 0;

	self.fpsconfig = false;
	self.statusIcon = "";

	maguid = self getguid();

	if (maguid != "0") {

		self.d = newClientHudElem(self);
		self.d.vertAlign = "bottom";
		self.d.horzAlign = "left";
		self.d.alignX = "left";
		self.d.alignY = "bottom";
		self.d.y = -59;
		self.d.x = 6;
		self.d.fontScale = 1.4;
		self.d.alpha = .6;

		while (level.mysqlwait) {
			wait .05;
		}

		level.handle = mysql_real_connect("localhost", "login", "password", "cod4stats");

		mysql_query(level.handle,"SELECT Coalesce(v.cheated, 0) cheated, Coalesce(v.boss, 0) boss, Coalesce(v.admin, 0) admin, Coalesce(v.days, 0) days, s_kills, s_deaths, s_skill from stats left join vip v on v.guid=s_guid where s_guid = '" + maguid + "' and s_server = '" + getdvar("mysql_server") + "'");

		if (mysql_num_rows(level.handle) != 0) {

			arr = mysql_fetch_row(level.handle);
			keys = getArrayKeys(arr);

			s_days = arr[keys[3]];
			s_admin = arr[keys[4]];
			s_boss = arr[keys[5]];
			s_cheated = arr[keys[6]];

			self.pers["killz"] = int(arr[keys[2]]);
			self.pers["deathz"] = int(arr[keys[1]]);
			self.pers["skill"] = int(arr[keys[0]]);

cheated = "";
if (int(s_cheated) > 0)
	cheated = " ^1[CHEATED]";

			if (int(s_days) > 0) {

				if (s_admin == "1") {

					self.pers["status"] = "vipadmin";
					self.d setText("^2CoD4Narod^3.RU ^7| ^3ADMIN VIP ^2[" +s_days + "]"+cheated);
					self.dont_auto_balance = true;
					iPrintLn(&"MP_CONNECTED", "^2" + self.name + " ^1[VIP ADMIN] ^3["+getSubStr(self.pers["skill"], 0, 4) +"]"+cheated+"^7");
				} else  {

					self.pers["status"] = "vip";
					self.d setText("^2CoD4Narod^3.RU ^7| ^3VIP ^2[" + s_days + "]"+cheated);
					self.dont_auto_balance = true;
					iPrintLn(&"MP_CONNECTED", "^2" + self.name + " ^1[VIP] ^3["+getSubStr(self.pers["skill"], 0, 4) +"]"+cheated+"^7");

				}

			} else if (s_admin == "1") {
				self.pers["status"] = "admin";
				self.d setText("^2CoD4Narod^3.RU ^9| ^3ADMIN"+cheated);
				self.dont_auto_balance = true;
				iPrintLn(&"MP_CONNECTED", "^2" + self.name + " ^1[ADMIN] ^3["+getSubStr(self.pers["skill"], 0, 4) +"]"+cheated+"^7");

			} else if  (s_boss == "1") {

				self.pers["status"] = "boss";
				self.d setText("^2CoD4Narod^3.RU ^7| ^3BOSS"+cheated);
				self.dont_auto_balance = true;
				iPrintLn(&"MP_CONNECTED", "^2" + self.name + " ^1[BOSS] ^3["+getSubStr(self.pers["skill"], 0, 4) +"]"+cheated+"^7");
			} else {
				self.pers["status"] = "default";
				self.d setText("^2CoD4Narod^3.RU"+cheated);
				iPrintLn(&"MP_CONNECTED", "^2" + self.name + " ^3["+getSubStr(self.pers["skill"], 0, 4) +"]"+cheated+"^7");
			}
			
			

			if (self.pers["deathz"] > 0) {
				self.pers["KDz"] = (self.pers["killz"] / self.pers["deathz"]);
			} else {
				self.pers["KDz"] = 1;
			}

		} else {
			self.pers["killz"] = 0;
			self.pers["deathz"] = 0;
			self.pers["KDz"] = .9;
			self.pers["skill"] = 1600;

			self.pers["status"] = "default";
			self.d setText("^2CoD4Narod^3.RU");
			iPrintLn(&"MP_CONNECTED", "^2" + self.name + " ^1[NEW] ^3["+getSubStr(self.pers["skill"], 0, 4) +"]^7");

		}

		mysql_close(level.handle);

	} else {
		self.pers["killz"] = 200 + randomint(400);
		self.pers["deathz"] = 0;
		self.pers["KDz"] = .3 + randomfloat(3);
		self.pers["skill"] = 1600 + randomint(300);

		self.pers["status"] = "default";
		iPrintLn(&"MP_CONNECTED", "^2" + self.name + " ^1[BOT] ^3["+getSubStr(self.pers["skill"], 0, 4) +"]^7");
	}

	if (getsubstr( tolower(self.name), 0, 7 ) == "uncool" && maguid != "2310346615860255566" && maguid != "2310346614414147501" && maguid != "2310346617427384482")
		exec("tempban " + maguid + " 1m ^3Nickname ^1"+ self.name +" ^2is Reserved. ^3Please change and rejoin. ^2CoD4Narod^3.RU");

	self.pers["skill_init"] = self.pers["skill"];

	self.pers["knife"] = false;

	self.pers["balance"] = false;

	if (self getStat(965) != 1)
		self thread volkv\statshud::ShowKDRatio();


	if (self.pers["killz"] < 2000)
		self.spawnedSS = false;
	else if (self.pers["killz"] < 10000 && randomint(2) == 0)
		self.spawnedSS = true;
	else if (self.pers["killz"] < 20000 && randomint(3) != 0)
		self.spawnedSS = true;
	else if (self.pers["killz"] < 50000 && randomint(4) != 0)
		self.spawnedSS = true;
	else if (randomint(5) != 0)
		self.spawnedSS = true;
	else
		self.spawnedSS = false;

	self.getss = 0;
	self.HPbonus = 0;

	if (self.pers["KDz"] < .8) {


		if (self.pers["KDz"] <= .3) {
			self.HPbonus = 30;

		}	else if (self.pers["KDz"] > .3 && self.pers["KDz"] <= .6) {
			self.HPbonus = 20;

		} else if (self.pers["KDz"] > 0.6 && self.pers["KDz"] < .8) {
			self.HPbonus = 10;
		}

		if ( level.hardcoreMode ) {
			self.HPbonus = int(self.HPbonus / 2);
		} else if ( level.oldschool ) {
			self.HPbonus = int(self.HPbonus * 2);

		}

	}

	if (self.pers["killz"] > 300) {

		if (self.pers["KDz"] >= 0 && self.pers["KDz"] < 0.6) 			 {
			self.pers["statusIcon"] = "rank_prestige1";
		} else if (self.pers["KDz"] >= 0.6 && self.pers["KDz"] < 0.8) {
			self.pers["statusIcon"] = "rank_prestige6";
		} else if (self.pers["KDz"] >= 0.8 && self.pers["KDz"] < 1.2) {
			self.pers["statusIcon"] = "rank_prestige2";
		} else if (self.pers["KDz"] >= 1.2 && self.pers["KDz"] < 1.6) {
			self.pers["statusIcon"] = "rank_prestige4";
		} else if (self.pers["KDz"] >= 1.6 && self.pers["KDz"] < 2.0) {
			self.pers["statusIcon"] = "rank_prestige8";
		} else if (self.pers["KDz"] >= 2.0 && self.pers["KDz"] < 2.6) {
			self.pers["statusIcon"] = "rank_prestige9";
		} else if (self.pers["KDz"] >= 2.6) {
			self.pers["statusIcon"] = "rank_prestige10";
		} else {
			self.pers["statusIcon"] = "";
		}

	} else {
		self.pers["statusIcon"] = "";
	}

	self.statusIcon = self.pers["statusIcon"];


	level notify( "connected", self );

	if (getdvarint( "sniper" ) == 1) {
		self.canApplyDamageToNext = false;
		self.extraspectator = false;
	}
}

Callback_PlayerConnect()
{
	self thread notifyConnecting();

	self waittill( "begin" );

	self thread PreConnect();

	self.inTrainingArea = false;
	self.reaper = false;
	self.inPredator = false;
	self.firstbloodinprogress = false;

	if (self getStat(955) != 1) {
		self setStat(955,1);

		self filmtweaks("0");
	}

	if (isDefined(self getStat(954)) && self getStat(954) != 99 && self getStat(954) != 0) {

		self filmtweaks(self getStat(954) + "");
	}

	setExpFog( 100000000000, 100000000001, 0, 0, 0, 0 );

	if (self getEntityNumber() == 0 )
		self thread listenForGameEnd();



	lpselfnum = self getEntityNumber();
	lpGuid = self getGuid();

	self setClientDvars( "cg_drawSpectatorMessages", 1,
	                     "ui_hud_hardcore", getDvar( "ui_hud_hardcore" ),
	                     "player_sprintTime", getDvar( "scr_player_sprinttime" ),
	                     "ui_uav_client", getDvar( "ui_uav_client" ) );

	if ( level.hardcoreMode )
	{
		self setClientDvars( "cg_drawTalk", 3,
		                     "cg_drawCrosshairNames", 1,
		                     "cg_drawCrosshair", 0,
		                     "cg_hudGrenadeIconMaxRangeFrag", 0 );
	}
	else
	{
		self setClientDvars( "cg_drawCrosshair", 1,
		                     "cg_drawCrosshairNames", 1,
		                     "cg_hudGrenadeIconMaxRangeFrag", 250 );
	}

	self setClientDvars("cg_hudGrenadeIconHeight", "25",
	                    "cg_hudGrenadeIconWidth", "25",
	                    "cg_hudGrenadeIconOffset", "50",
	                    "cg_hudGrenadePointerHeight", "12",
	                    "cg_hudGrenadePointerWidth", "25",
	                    "cg_hudGrenadePointerPivot", "12 27",
	                    "cg_fovscale", "1");

	if ( level.oldschool )
	{
		self setClientDvars( "ragdoll_explode_force", 60000,
		                     "ragdoll_explode_upbias", 0.8,
		                     "bg_fallDamageMinHeight", 256,
		                     "bg_fallDamageMaxHeight", 512 );
	}

	self setClientDvar("r_filmusetweaks","1");
	self setClientDvar("r_blur", 0);

	if (getdvarint("fps_server")) {


		self setClientDvar( "r_fullbright", 1 );
		self setClientDvar( "fx_enable", 0 );
		self setClientDvar( "fx_draw", 0 );
		self setClientDvar("r_fog", "0");
		self setClientDvar("r_glow", "0");
		self setClientDvar("fx_drawClouds", "0");

		self.pers["fullbright"] = 1;


	} else {


		self setClientDvar( "r_fullbright", 0 );
		self setClientDvar( "sv_wwwdownload", 1 );
		self setClientDvar( "sv_wwwdldisconnected", 1 );
		self setClientDvar( "fx_enable", 1 );
		self setClientDvar( "fx_draw", 1 );
		self.pers["fullbright"] = 0;
	}

	self setstat(1222,0);



	self setClientDvar( "sv_cheats", 0 );
	self setClientDvar( "cg_fovscale", 1 );

	if (self.pers["status"] == "boss") {

		self setClientDvar("fx_enable", 0);
		self setClientDvar("fx_draw", 0);
		self setClientDvar("r_fullbright", 1);
		self setClientDvar("r_fog", "0");
		self setClientDvar("r_glow", "0");
		self setClientDvar("fx_drawClouds", "0");

	}

	self.pers["allies_score"] = 0;
	self.pers["axis_score"] = 0;

	self initPersStat( "score" );
	self.score = self.pers["score"];

	self initPersStat( "deaths" );
	self.deaths = self getPersStat( "deaths" );

	self initPersStat( "suicides" );
	self.suicides = self getPersStat( "suicides" );

	self initPersStat( "kills" );
	self.kills = self getPersStat( "kills" );

	self initPersStat( "headshots" );
	self.headshots = self getPersStat( "headshots" );

	self initPersStat( "assists" );
	self.assists = self getPersStat( "assists" );

	self initPersStat( "teamkills" );
	self.teamKillPunish = false;
	if ( level.minimumAllowedTeamKills >= 0 && self.pers["teamkills"] > level.minimumAllowedTeamKills )
		self thread reduceTeamKillsOverTime();

	if ( getdvar( "r_reflectionProbeGenerate" ) == "1" )
		level waittill( "eternity" );

	self.killedPlayers = [];
	self.killedPlayersCurrent = [];
	self.killedBy = [];

	self.leaderDialogQueue = [];
	self.leaderDialogActive = false;
	self.leaderDialogGroups = [];
	self.leaderDialogGroup = "";

	self.pers["max_kill_streak"] = 0;
	self.cur_kill_streak = 0;
	self.cur_death_streak = 0;
	self.death_streak = self maps\mp\gametypes\_persistence::statGet( "death_streak" );
	self.kill_streak = self maps\mp\gametypes\_persistence::statGet( "kill_streak" );
	self.lastGrenadeSuicideTime = -1;

	self.teamkillsThisRound = 0;

	self.pers["lives"] = level.numLives;

	self.hasSpawned = false;
	self.waitingToSpawn = false;
	self.deathCount = 0;

	self.wasAliveAtMatchStart = false;

	self thread maps\mp\_flashgrenades::monitorFlash();

	if ( level.numLives )
	{
		self setClientDvars("cg_deadChatWithDead", 1,
		                    "cg_deadChatWithTeam", 0,
		                    "cg_deadHearTeamLiving", 0,
		                    "cg_deadHearAllLiving", 0,
		                    "cg_everyoneHearsEveryone", 0 );
	}
	else
	{
		self setClientDvars("cg_deadChatWithDead", 0,
		                    "cg_deadChatWithTeam", 1,
		                    "cg_deadHearTeamLiving", 1,
		                    "cg_deadHearAllLiving", 0,
		                    "cg_everyoneHearsEveryone", 0 );
	}

	level.players[level.players.size] = self;


	if ( level.teambased )
		self updateScores();

	if ( game["state"] == "postgame" )
	{
		self.pers["team"] = "spectator";
		self.team = "spectator";

		self setClientDvars( "ui_hud_hardcore", 1,
		                     "cg_drawSpectatorMessages", 0 );

		[[level.spawnIntermission]]();
		self closeMenu();
		self closeInGameMenu();
		return;
	}

	updateLossStats( self );

	level endon( "game_ended" );

	if ( level.oldschool )
	{
		self.pers["class"] = undefined;
		self.class = self.pers["class"];
	}

	if ( isDefined( self.pers["team"] ) )
		self.team = self.pers["team"];

	if ( isDefined( self.pers["class"] ) )
		self.class = self.pers["class"];

	if ( !isDefined( self.pers["team"] ) )
	{
		self.pers["team"] = "spectator";
		self.team = "spectator";
		self.sessionstate = "dead";

		self updateObjectiveText();

		[[level.spawnSpectator]]();

		self setclientdvar( "g_scriptMainMenu", game["menu_team"] );
		self openMenu( game["menu_team"] );


		if ( self.pers["team"] == "spectator" )
			self.sessionteam = "spectator";

		if ( level.teamBased )
		{
			self.sessionteam = self.pers["team"];
			if ( !isAlive( self ) )
				self.statusicon = "hud_status_dead";
			self thread maps\mp\gametypes\_spectating::setSpectatePermissions();
		}
	}
	else if ( self.pers["team"] == "spectator" )
	{
		self setclientdvar( "g_scriptMainMenu", game["menu_team"] );
		self.sessionteam = "spectator";
		self.sessionstate = "spectator";
		[[level.spawnSpectator]]();
	}
	else
	{
		self.sessionteam = self.pers["team"];
		self.sessionstate = "dead";

		self updateObjectiveText();

		[[level.spawnSpectator]]();

		if ( isValidClass( self.pers["class"] ) )
		{
			self thread [[level.spawnClient]]();
		}
		else
		{
			self showMainMenuForTeam();
		}

		self thread maps\mp\gametypes\_spectating::setSpectatePermissions();
	}

	if ( isDefined( self.pers["isBot"] ) )
		return;

	for ( i=0; i<5; i++ )
	{
		if ( self getstat( 205+(i*10) ) == 0 )
		{
			kick( self getentitynumber() );
			return;
		}
	}
}

forceSpawn()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	self endon ( "spawned" );

	wait ( 60.0 );

	if ( self.hasSpawned )
		return;

	if ( self.pers["team"] == "spectator" )
		return;

	if ( !isValidClass( self.pers["class"] ) )
	{
		if ( getDvarInt( "onlinegame" ) )
			self.pers["class"] = "CLASS_CUSTOM1";
		else
			self.pers["class"] = "CLASS_ASSAULT";

		self.class = self.pers["class"];
	}

	self closeMenus();
	self thread [[level.spawnClient]]();
}

Callback_PlayerDisconnect()
{
	self removePlayerOnDisconnect();


	if ( !level.gameEnded )
		self logXPGains();

	[[level.onPlayerDisconnect]]();

	lpselfnum = self getEntityNumber();

	for ( entry = 0; entry < level.players.size; entry++ )
	{
		if ( level.players[entry] == self )
		{
			while ( entry < level.players.size-1 )
			{
				level.players[entry] = level.players[entry+1];
				entry++;
			}
			level.players[entry] = undefined;
			break;
		}
	}

	if ( isDefined( self.clientid ) ) {

		for ( entry = 0; entry < level.players.size; entry++ )
		{


			if ( isDefined( level.players[entry].killedPlayers[""+self.clientid] ) )
				level.players[entry].killedPlayers[""+self.clientid] = undefined;

			if ( isDefined( level.players[entry].killedPlayersCurrent[""+self.clientid] ) )
				level.players[entry].killedPlayersCurrent[""+self.clientid] = undefined;

			if ( isDefined( level.players[entry].killedBy[""+self.clientid] ) )
				level.players[entry].killedBy[""+self.clientid] = undefined;
		}

	}

	if ( level.gameEnded )
		self removeDisconnectedPlayerFromPlacement();

	level thread updateTeamStatus();
}

removePlayerOnDisconnect()
{
	for ( entry = 0; entry < level.players.size; entry++ )
	{
		if ( level.players[entry] == self )
		{
			while ( entry < level.players.size-1 )
			{
				level.players[entry] = level.players[entry+1];
				entry++;
			}
			level.players[entry] = undefined;
			break;
		}
	}
}

isHeadShot( sWeapon, sHitLoc, sMeansOfDeath )
{
	return (sHitLoc == "head" || sHitLoc == "helmet") && sMeansOfDeath != "MOD_MELEE" && sMeansOfDeath != "MOD_IMPACT" && !isMG( sWeapon );
}

isallowedWep(wep) {
	if (wep == "claymore_mp" || isSubStr(wep,"grenade") || wep == "c4_mp" || wep == "rpg_mp" || wep == "knife_mp")
		return false;
	return true;
}

getHitLocMulti(sHitLoc) {
	switch (sHitLoc) {

	case "head":
	case "helmet":
		return 1.5;
	case "neck":
		return 1.3;
	case "torso_upper":
		return 1.2;
	case "torso_lower":
		return 1;

	case "right_arm_upper":
	case "left_arm_upper":
	case "right_leg_upper":
	case "left_leg_upper":

	case "right_arm_lower":
	case "left_arm_lower":
	case "right_leg_lower":
	case "left_leg_lower":

	case "right_foot":
	case "left_foot":
	case "right_hand":
	case "left_hand":
	case "gun":

		return 0.8;

	}
	return 1;
}

Callback_PlayerDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime )
{
	if (isDefined(self.inTrainingArea) && isDefined(eAttacker) && isDefined(eAttacker.inTrainingArea) && self.inTrainingArea != eAttacker.inTrainingArea)
		return;

	if (isDefined(game["only_weapons"]) && isDefined(sWeapon) && ((!isSubStr(game["only_weapons"],sWeapon) && game["only_weapons"] != "knife_mp") || (sMeansOfDeath == "MOD_MELEE" && game["only_weapons"] != "knife_mp")) && isDefined(eAttacker) && eAttacker != self)
		return;

	if ((!isDefined(self.reflect_damage) || !self.reflect_damage ) && isPlayer(eAttacker) && isDefined(eAttacker.reflect_damage) && eAttacker.reflect_damage) {
		eAttacker Callback_PlayerDamage( eAttacker, eAttacker, int(iDamage / 5), iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime );
		return;
	}

	iDamage = maps\mp\gametypes\_class::cac_modified_damage( self, eAttacker, iDamage, sMeansOfDeath );

	
		
	if (sMeansOfDeath == "MOD_IMPACT" || sMeansOfDeath == "MOD_MELEE")
		iDamage = int( iDamage * 5);

	if (level.event && (sWeapon == "saw_bipod_crouch_mp" || sWeapon == "saw_bipod_stand_mp"))
		return;

	multipl = getHitLocMulti(sHitLoc);

	if (isDefined(eAttacker) && isDefined(eAttacker.multipl_anticamp)) {
		multipl_anticamp = eAttacker.multipl_anticamp;
	} else {
		multipl_anticamp = 1;
	}

	iDamage = int( iDamage * multipl);

	if (multipl_anticamp != 1)
		iDamage = int(iDamage * multipl_anticamp);

	self.iDFlags = iDFlags;
	self.iDFlagsTime = getTime();

	if (getdvarint( "sniper" ) == 1) {

		if ( level.fixPlayerLoadoutEnabled && !sniper::isAllowedWeapon( sWeapon ) && sMeansOfDeath != "MOD_MELEE" )
			return;

		if ( level.fixExplosiveDamageEnabled && ( sWeapon == "rpg_mp" || sWeapon == "frag_grenade_mp" ) )
			return;

		if ( !level.m21RecoilFix && (sWeapon == "m21_mp" || sWeapon == "m21_acog_mp" ) )
			return;
	}

	if ( game["state"] == "postgame" && !level.pvp )
		return;

	if ( self.sessionteam == "spectator" )
		return;

	if ( isDefined( self.canDoCombat ) && !self.canDoCombat )
		return;

	if ( isDefined( eAttacker ) && isPlayer( eAttacker ) && isDefined( eAttacker.canDoCombat ) && !eAttacker.canDoCombat )
		return;

	prof_begin( "Callback_PlayerDamage flags/tweaks" );

	if ( !isDefined( vDir ) )
		iDFlags |= level.iDFLAGS_NO_KNOCKBACK;

	friendly = false;

	if ( (level.teamBased && (self.health == self.maxhealth)) || !isDefined( self.attackers ) )
	{
		self.attackers = [];
		self.attackerData = [];
	}

	if ( isHeadShot( sWeapon, sHitLoc, sMeansOfDeath ) )
		sMeansOfDeath = "MOD_HEAD_SHOT";

	if ( sWeapon == "none" && isDefined( eInflictor ) )
	{
		if ( isDefined( eInflictor.targetname ) && eInflictor.targetname == "explodable_barrel" )
			sWeapon = "explodable_barrel";
		else if ( isDefined( eInflictor.destructible_type ) && isSubStr( eInflictor.destructible_type, "vehicle_" ) )
			sWeapon = "destructible_car";
		if (getdvarint( "sniper" ) == 1) {
			if ( level.fixExplosiveDamageEnabled )
				return;
		}
	}

	prof_end( "Callback_PlayerDamage flags/tweaks" );

	if ( !(iDFlags & level.iDFLAGS_NO_PROTECTION) )
	{

		if ( (isSubStr( sMeansOfDeath, "MOD_GRENADE" ) || isSubStr( sMeansOfDeath, "MOD_EXPLOSIVE" ) || isSubStr( sMeansOfDeath, "MOD_PROJECTILE" )) && isDefined( eInflictor ) )
		{
				if (getDvar("mapname") == "mp_killhouse")	{
			iDamage =  int(iDamage / 2);
		}
		
			if (level.weak[self.pers["team"]] == true)
				iDamage = int(iDamage / 2);


			if ( eInflictor.classname == "grenade" && (self.lastSpawnTime + 3500) > getTime() && distance( eInflictor.origin, self.lastSpawnPoint.origin ) < 250 )
			{
				prof_end( "Callback_PlayerDamage player" );
				return;
			}

			self.explosiveInfo = [];
			self.explosiveInfo["damageTime"] = getTime();
			self.explosiveInfo["damageId"] = eInflictor getEntityNumber();
			self.explosiveInfo["returnToSender"] = false;
			self.explosiveInfo["counterKill"] = false;
			self.explosiveInfo["chainKill"] = false;
			self.explosiveInfo["cookedKill"] = false;
			self.explosiveInfo["throwbackKill"] = false;
			self.explosiveInfo["weapon"] = sWeapon;

			isFrag = isSubStr( sWeapon, "frag_" );

			if ( eAttacker != self )
			{
				if ( (isSubStr( sWeapon, "c4_" ) || isSubStr( sWeapon, "claymore_" )) && isDefined( eAttacker ) && isDefined( eInflictor.owner ) )
				{
					self.explosiveInfo["returnToSender"] = (eInflictor.owner == self);
					self.explosiveInfo["counterKill"] = isDefined( eInflictor.wasDamaged );
					self.explosiveInfo["chainKill"] = isDefined( eInflictor.wasChained );
					self.explosiveInfo["bulletPenetrationKill"] = isDefined( eInflictor.wasDamagedFromBulletPenetration );
					self.explosiveInfo["cookedKill"] = false;
				}
				if ( isDefined( eAttacker.lastGrenadeSuicideTime ) && eAttacker.lastGrenadeSuicideTime >= gettime() - 50 && isFrag )
				{
					self.explosiveInfo["suicideGrenadeKill"] = true;
				}
				else
				{
					self.explosiveInfo["suicideGrenadeKill"] = false;
				}
			}

			if ( isFrag )
			{
				self.explosiveInfo["cookedKill"] = isDefined( eInflictor.isCooked );
				self.explosiveInfo["throwbackKill"] = isDefined( eInflictor.threwBack );
			}
		}

		if ( isPlayer( eAttacker ) )
			eAttacker.pers["participation"]++;

		prevHealthRatio = self.health / self.maxhealth;

		if ( level.teamBased && isPlayer( eAttacker ) && (self != eAttacker) && (self.pers["team"] == eAttacker.pers["team"]) )
		{
			prof_begin( "Callback_PlayerDamage player" );
			if ( level.friendlyfire == 0 )
			{
				if ( sWeapon == "artillery_mp" )
					self damageShellshockAndRumble( eInflictor, sWeapon, sMeansOfDeath, iDamage );
				return;
			}
			else if ( level.friendlyfire == 1 )
			{
				if ( iDamage < 1 )
					iDamage = 1;

				self.lastDamageWasFromEnemy = false;

				self finishPlayerDamageWrapper(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime);
			}
			else if ( level.friendlyfire == 2 && isAlive( eAttacker ) )
			{
				iDamage = int(iDamage / 2);

				if (iDamage < 1)
					iDamage = 1;

				eAttacker.lastDamageWasFromEnemy = false;

				eAttacker.friendlydamage = true;
				eAttacker finishPlayerDamageWrapper(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime);
				eAttacker.friendlydamage = undefined;
			}
			else if ( level.friendlyfire == 3 && isAlive( eAttacker ) )
			{
				iDamage = int(iDamage * .5);

				if ( iDamage < 1 )
					iDamage = 1;

				self.lastDamageWasFromEnemy = false;
				eAttacker.lastDamageWasFromEnemy = false;

				self finishPlayerDamageWrapper(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime);
				if ( isAlive( eAttacker ) )
				{
					eAttacker.friendlydamage = true;
					eAttacker finishPlayerDamageWrapper(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime);
					eAttacker.friendlydamage = undefined;
				}
			}

			friendly = true;
		}
		else
		{
			prof_begin( "Callback_PlayerDamage world" );
			if (iDamage < 1)
				iDamage = 1;

			if ( level.teamBased && isDefined( eAttacker ) && isPlayer( eAttacker ) )
			{
				if ( !isdefined( self.attackerData[eAttacker.clientid] ) )
				{
					self.attackers[ self.attackers.size ] = eAttacker;
					self.attackerData[eAttacker.clientid] = false;
				}
				if ( maps\mp\gametypes\_weapons::isPrimaryWeapon( sWeapon ) )
					self.attackerData[eAttacker.clientid] = true;
			}

			if ( isdefined( eAttacker ) )
				level.lastLegitimateAttacker = eAttacker;

			if ( isdefined( eAttacker ) && isPlayer( eAttacker ) && isDefined( sWeapon ) )
				eAttacker maps\mp\gametypes\_weapons::checkHit( sWeapon );

			if ( issubstr( sMeansOfDeath, "MOD_GRENADE" ) && isDefined( eInflictor.isCooked ) )
				self.wasCooked = getTime();
			else
				self.wasCooked = undefined;
			self.lastDamageWasFromEnemy = (isDefined( eAttacker ) && (eAttacker != self));

			if (getdvarint( "sniper" ) == 1) {
				if (iDFlags != 8 || iDFlags == 8 && eAttacker.canApplyDamageToNext)
				{
					self finishPlayerDamageWrapper( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime );

					if (isDefined(eAttacker))
						eAttacker thread lookForNextDamage();
				}
			} else {
				self finishPlayerDamageWrapper(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime);

			}

			self thread maps\mp\gametypes\_missions::playerDamaged(eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, sHitLoc );

			prof_end( "Callback_PlayerDamage world" );
		}

		if ( isdefined(eAttacker) && eAttacker != self )
		{

			hasBodyArmor = false;
			if ( self hasPerk( "specialty_armorvest" ) )
			{
				hasBodyArmor = true;
			}

			if (getdvarint( "sniper" ) == 1) {
				if ( iDamage > 0 && iDFlags != 8 )
					eAttacker thread maps\mp\gametypes\_damagefeedback::updateDamageFeedback( hasBodyArmor, iDamage);
			} else {
				if ( iDamage > 0 )
					eAttacker thread maps\mp\gametypes\_damagefeedback::updateDamageFeedback( hasBodyArmor, iDamage);
			}
		}

		self.hasDoneCombat = true;
	}

	if ( isdefined( eAttacker ) && eAttacker != self && !friendly )
		level.useStartSpawns = false;

	prof_begin( "Callback_PlayerDamage log" );

	// Do debug print if its enabled
	//iprintln(" damage:" + iDamage + " hitLoc:" + sHitLoc + " MULTI: " + multipl + " MULTI_ANTIKEMP: " + multipl_anticamp + " MEANS: " + sMeansOfDeath + " WEAPON: " + sWeapon);

	if (self.sessionstate != "dead")
	{
		lpselfnum = self getEntityNumber();
		lpselfname = self.name;
		lpselfteam = self.pers["team"];
		lpselfGuid = self getGuid();
		lpattackerteam = "";

		if (isPlayer(eAttacker))
		{
			lpattacknum = eAttacker getEntityNumber();
			lpattackGuid = eAttacker getGuid();
			lpattackname = eAttacker.name;
			lpattackerteam = eAttacker.pers["team"];
		}
		else
		{
			lpattacknum = -1;
			lpattackGuid = "";
			lpattackname = "";
			lpattackerteam = "world";
		}

	}

	prof_end( "Callback_PlayerDamage log" );
}

lookForNextDamage()
{
	self.canApplyDamageToNext = true;
	wait 0.05;
	self.canApplyDamageToNext = false;
}

finishPlayerDamageWrapper( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime )
{
	self finishPlayerDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime );

	self damageShellshockAndRumble( eInflictor, sWeapon, sMeansOfDeath, iDamage );
}

damageShellshockAndRumble( eInflictor, sWeapon, sMeansOfDeath, iDamage )
{
	self thread maps\mp\gametypes\_weapons::onWeaponDamage( eInflictor, sWeapon, sMeansOfDeath, iDamage );
	self PlayRumbleOnEntity( "damage_heavy" );
}

multiKillCount() {

	self endon ( "disconnect" );
	level endon ( "game_ended" );

	self notify ( "updateRecentKills" );

	self endon ( "updateRecentKills" );

	self.recentKillCount++;

	wait ( 3 + (self.recentKillCount / 3 ) );

	if ( self.recentKillCount > 3) {

		if ( self.recentKillCount < 6 ) {
			self thread volkv\_languages::iPrintBigTeams("MULTIKILL", "PLAYER", self.name, "COUNT", self.recentKillCount);
		} else if ( self.recentKillCount < 9 ) {
			self thread volkv\_languages::iPrintBigTeams("ULTRAKILL", "PLAYER", self.name, "COUNT", self.recentKillCount);
		} else if ( self.recentKillCount < 12) {
			self thread volkv\_languages::iPrintBigTeams("MONSTERKILL", "PLAYER", self.name, "COUNT", self.recentKillCount);
		} else {
			self thread volkv\_languages::iPrintBigTeams("RAMPAGE", "PLAYER", self.name, "COUNT", self.recentKillCount);
		}

	}

	self.recentKillCount = 0;

}

Callback_PlayerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration)
{

	skillbonus = 0;

	if (isDefined(self.inTrainingArea) && isDefined(attacker) && isDefined(attacker.inTrainingArea) && self.inTrainingArea != attacker.inTrainingArea)
		return;

	if (isDefined(self) && isDefined(self.isGod) && self.isGod)
		return;

	if (isDefined(game["only_weapons"]) && isDefined(sWeapon) && ((!isSubStr(game["only_weapons"],sWeapon) && game["only_weapons"] != "knife_mp") || (sMeansOfDeath == "MOD_MELEE" && game["only_weapons"] != "knife_mp")) && isDefined(attacker) && attacker != self)
		return;

	self endon( "spawned" );
	self notify( "killed_player" );

	if ( self.sessionteam == "spectator" )
		return;

	if ( game["state"] == "postgame" && !level.pvp )
		return;

	prof_begin( "PlayerKilled pre constants" );

	deathTimeOffset = 0;
	if ( isdefined( self.useLastStandParams ) )
	{
		self.useLastStandParams = undefined;

		assert( isdefined( self.lastStandParams ) );

		eInflictor = self.lastStandParams.eInflictor;
		attacker = self.lastStandParams.attacker;
		iDamage = self.lastStandParams.iDamage;
		sMeansOfDeath = self.lastStandParams.sMeansOfDeath;
		sWeapon = self.lastStandParams.sWeapon;
		vDir = self.lastStandParams.vDir;
		sHitLoc = self.lastStandParams.sHitLoc;

		deathTimeOffset = (gettime() - self.lastStandParams.lastStandStartTime) / 1000;

		self.lastStandParams = undefined;
	}

	if ( attacker.classname == "script_vehicle" && isDefined( attacker.owner ) )
		attacker = attacker.owner;
	if (isDefined(attacker) && isPlayer(attacker) && isDefined(self) && isPlayer(self) && isDefined(sMeansofDeath) && isDefined(sWeapon) && isDefined(sHitLoc))

		if ( isHeadShot( sWeapon, sHitLoc, sMeansOfDeath ) )
			sMeansOfDeath = "MOD_HEAD_SHOT";

	if ( level.teamBased && isDefined( attacker.pers ) && self.team == attacker.team && sMeansOfDeath == "MOD_GRENADE" && level.friendlyfire == 0 && !isDefined(self.pers["isBot"]) && volkv\_common::isFalse(self.inTrainingArea))
		obituary(self, self, sWeapon, sMeansOfDeath);
	else if (!isDefined(self.pers["isBot"]) && volkv\_common::isFalse(self.inTrainingArea))
		obituary(self, attacker, sWeapon, sMeansOfDeath);
	else if (!isDefined(self.pers["isBot"]) && volkv\_common::isTrue(self.inTrainingArea))
		killnotify(attacker,self);


	if ( !level.inGracePeriod )
	{
		self maps\mp\gametypes\_weapons::dropWeaponForDeath( attacker );
		self maps\mp\gametypes\_weapons::dropOffhand();
	}

	maps\mp\gametypes\_spawnlogic::deathOccured(self, attacker);

	self.sessionstate = "dead";
	self.statusicon = "hud_status_dead";

	self.pers["weapon"] = undefined;

	self.killedPlayersCurrent = [];

	self.deathCount++;

	if ( !isDefined( self.switching_teams ) )
	{
		if ( isPlayer( attacker ) && level.teamBased && ( attacker != self ) && ( self.pers["team"] == attacker.pers["team"] ) )
		{
			if (self.cur_kill_streak > self.pers["max_kill_streak"]) {
				self.pers["max_kill_streak"] = self.cur_kill_streak;
			}
			self.cur_kill_streak = 0;
		}
		else
		{
			self incPersStat( "deaths", 1 );
			self.deaths = self getPersStat( "deaths" );
			self updatePersRatio( "kdratio", "kills", "deaths" );

			if (self.cur_kill_streak > self.pers["max_kill_streak"]) {
				self.pers["max_kill_streak"] = self.cur_kill_streak;
			}

			self.cur_kill_streak = 0;
			self.cur_death_streak++;

			if ( self.cur_death_streak > self.death_streak )
			{
				self maps\mp\gametypes\_persistence::statSet( "death_streak", self.cur_death_streak );
				self.death_streak = self.cur_death_streak;
			}
		}
	}

	lpselfnum = self getEntityNumber();
	lpselfname = self.name;
	lpattackGuid = "";
	lpattackname = "";
	lpselfteam = "";
	lpselfguid = self getGuid();
	lpattackerteam = "";

	lpattacknum = -1;

	prof_end( "PlayerKilled pre constants" );

	if ( isPlayer( attacker ) )
	{
		lpattackGuid = attacker getGuid();
		lpattackname = attacker.name;

		if ( attacker == self )
		{
			doKillcam = false;

			if ( isDefined( self.switching_teams ) )
			{
				if ( !level.teamBased && ((self.leaving_team == "allies" && self.joining_team == "axis") || (self.leaving_team == "axis" && self.joining_team == "allies")) )
				{
					playerCounts = self maps\mp\gametypes\_teams::CountPlayers();
					playerCounts[self.leaving_team]--;
					playerCounts[self.joining_team]++;

					if ( (playerCounts[self.joining_team] - playerCounts[self.leaving_team]) > 1 )
					{
						self thread [[level.onXPEvent]]( "suicide" );
						self incPersStat( "suicides", 1 );
						self.suicides = self getPersStat( "suicides" );
					}
				}
			}
			else
			{
				self thread [[level.onXPEvent]]( "suicide" );
				self incPersStat( "suicides", 1 );
				self.suicides = self getPersStat( "suicides" );

				if ( sMeansOfDeath == "MOD_SUICIDE" && sHitLoc == "none" && self.throwingGrenade )
				{
					self.lastGrenadeSuicideTime = gettime();
				}

				value = maps\mp\gametypes\_rank::getScoreInfoValue( "suicide" );
				givePlayerScore( "suicide", attacker, self );
				giveTeamScore( "suicide", attacker.pers["team"], attacker, self );
			}

			if ( isDefined( self.friendlydamage ) )
				self iPrintLn(&"MP_FRIENDLY_FIRE_WILL_NOT");
		}
		else
		{
			prof_begin( "PlayerKilled attacker" );

			lpattacknum = attacker getEntityNumber();

			doKillcam = true;

			if ( level.teamBased && self.pers["team"] == attacker.pers["team"] ) // killed by a friendly
			{
				attacker thread [[level.onXPEvent]]( "teamkill" );

				attacker.pers["teamkills"] += 1.0;

				attacker.teamkillsThisRound++;

				if ( maps\mp\gametypes\_tweakables::getTweakableValue( "team", "teamkillpointloss" ) )
				{
					scoreSub = maps\mp\gametypes\_rank::getScoreInfoValue( "kill" );
					_setPlayerScore( attacker, _getPlayerScore( attacker ) - scoreSub );
				}

				if ( getTimePassed() < 5000 )
					teamKillDelay = 1;
				else if ( attacker.pers["teamkills"] > 1 && getTimePassed() < (8000 + (attacker.pers["teamkills"] * 1000)) )
					teamKillDelay = 1;
				else
					teamKillDelay = attacker TeamKillDelay();

				if ( teamKillDelay > 0 )
				{
					attacker.teamKillPunish = true;
					attacker suicide();
					attacker thread reduceTeamKillsOverTime();
				}
			}
			else
			{
				prof_begin( "pks1" );

				if ( sMeansOfDeath == "MOD_MELEE" ) {
					if (attacker.pers["knifemode"])
						value = 200;
					else
						value = maps\mp\gametypes\_rank::getScoreInfoValue( "melee" );

					attacker thread maps\mp\gametypes\_rank::giveRankXP( "melee", value );
					givePlayerScore( "melee", attacker, self );
					giveTeamScore( "melee", attacker.pers["team"], attacker, self );
					attacker.pers[ "meleekills" ]++;

				} else if ( sMeansOfDeath == "MOD_HEAD_SHOT" )	{
					attacker incPersStat( "headshots", 1 );
					attacker.headshots = attacker getPersStat( "headshots" );
					value = maps\mp\gametypes\_rank::getScoreInfoValue( "headshot" );
					attacker thread maps\mp\gametypes\_rank::giveRankXP( "headshot", value );
					givePlayerScore( "headshot", attacker, self );
					giveTeamScore( "headshot", attacker.pers["team"], attacker, self );
					attacker playLocalSound( "bullet_impact_headshot_2" );
				} else if ( sMeansOfDeath == "MOD_IMPACT") {
					value = maps\mp\gametypes\_rank::getScoreInfoValue( "impact" );
					attacker thread maps\mp\gametypes\_rank::giveRankXP( "impact", value );
					givePlayerScore( "impact", attacker, self );
					giveTeamScore( "impact", attacker.pers["team"], attacker, self );

				} else if (sMeansOfDeath == "MOD_GRENADE" || sMeansOfDeath == "MOD_GRENADE_SPLASH") {

					value = maps\mp\gametypes\_rank::getScoreInfoValue( "explosive" );
					attacker thread maps\mp\gametypes\_rank::giveRankXP( "explosive", value );
					givePlayerScore( "explosive", attacker, self );
					giveTeamScore( "explosive", attacker.pers["team"], attacker, self );
					attacker.pers[ "grenadekills" ]++;

				} else if (sMeansOfDeath == "MOD_EXPLOSIVE" || sMeansOfDeath == "MOD_PROJECTILE_SPLASH") {

					value = maps\mp\gametypes\_rank::getScoreInfoValue( "explosive" );
					attacker thread maps\mp\gametypes\_rank::giveRankXP( "explosive", value );
					givePlayerScore( "explosive", attacker, self );
					giveTeamScore( "explosive", attacker.pers["team"], attacker, self );
				}
				else {
					value = maps\mp\gametypes\_rank::getScoreInfoValue( "kill" );
					attacker thread maps\mp\gametypes\_rank::giveRankXP( "kill", value );
					givePlayerScore( "kill", attacker, self );
					giveTeamScore( "kill", attacker.pers["team"], attacker, self );

					if ( level.teamBased && isdefined( level.chopper ) && isdefined( Attacker ) && Attacker == level.chopper )
						giveTeamScore( "explosive", attacker.team, attacker, self );

				}

				attacker thread maps\mp\gametypes\_rank::incRankXP(1);

				attacker incPersStat( "kills", 1 );
				attacker.kills = attacker getPersStat( "kills" );
				attacker updatePersRatio( "kdratio", "kills", "deaths" );

				if ( isAlive( attacker ) )
				{
					if ( !isDefined( eInflictor ) || !isDefined( eInflictor.requiredDeathCount ) || attacker.deathCount == eInflictor.requiredDeathCount )
						if (sWeapon != "artillery_mp" && sWeapon != "cobra_20mm_mp" && sWeapon != "cobra_ffar_mp" && sWeapon != "hind_ffar_mp") {

							if (attacker.cur_kill_streak > attacker.pers["max_kill_streak"]) {
								attacker.pers["max_kill_streak"] = attacker.cur_kill_streak;
							}


							attacker notify("killedPlayer");

							attacker.cur_kill_streak++;
							attacker thread maps\mp\gametypes\_hardpoints::giveHardpointItemForStreak();

							///SKILL

							atkSkill = attacker.pers["skill"];

							if (!isDefined(atkSkill))
								atkSkill = 1600;

							selfSkill = self.pers["skill"];

							if (!isDefined(selfSkill))
								selfSkill = 1600;

							atkteamKD= level.KD[attacker.pers["team"]];

							if (!isDefined(atkteamKD))
								atkteamKD = 1;

							selfteamKD = level.KD[self.pers["team"]];

							if (!isDefined(selfteamKD))
								selfteamKD = 1;

							skillbonus = ((0.5 - tanh((atkSkill-selfSkill)/1000)) + (0.5 - tanh((atkteamKD - selfteamKD)/5))) / 2;

							if (skillbonus < 0.1)
							skillbonus = 0.1;
							
							if (sMeansOfDeath == "MOD_MELEE" && attacker.pers["knifemode"])
								skillbonus += (skillbonus * .2);
							else if (sMeansOfDeath == "MOD_MELEE")
								skillbonus += (skillbonus * .5);
							else if (sMeansOfDeath == "MOD_EXPLOSIVE")
								skillbonus -= (skillbonus * .2);
							else if (sMeansOfDeath == "MOD_HEAD_SHOT")
								skillbonus += (skillbonus * .2);

							if (!isDefined(skillbonus))
								skillbonus = 0;

							//    iprintln("ATTK SK " +atkSkill + " VICT SK: " + selfSkill + " ATK T KD: " + atkteamKD + " VICT T KD: " + selfteamKD + " SB : " + skillbonus );

							attacker.pers["skill"] += skillbonus ;

							self.pers["skill"] -= skillbonus;

							////// MULITKILL
							attacker thread multiKillCount();
						}
				}

				attacker.cur_death_streak = 0;

				if ( attacker.cur_kill_streak > attacker.kill_streak )
				{
					attacker maps\mp\gametypes\_persistence::statSet( "kill_streak", attacker.cur_kill_streak );
					attacker.kill_streak = attacker.cur_kill_streak;
				}


				name = ""+self.clientid;
				if ( !isDefined( attacker.killedPlayers[name] ) )
					attacker.killedPlayers[name] = 0;

				if ( !isDefined( attacker.killedPlayersCurrent[name] ) )
					attacker.killedPlayersCurrent[name] = 0;

				attacker.killedPlayers[name]++;
				attacker.killedPlayersCurrent[name]++;

				attackerName = ""+attacker.clientid;
				if ( !isDefined( self.killedBy[attackerName] ) )
					self.killedBy[attackerName] = 0;

				self.killedBy[attackerName]++;


				level thread maps\mp\gametypes\_battlechatter_mp::sayLocalSoundDelayed( attacker, "kill", 0.75 );

				prof_end( "pks1" );

				if ( level.teamBased )
				{
					prof_begin( "PlayerKilled assists" );

					if ( isdefined( self.attackers ) )
					{
						for ( j = 0; j < self.attackers.size; j++ )
						{
							player = self.attackers[j];

							if ( !isDefined( player ) )
								continue;

							if ( player == attacker )
								continue;

							player thread processAssist( self );
						}
						self.attackers = [];
					}

					prof_end( "PlayerKilled assists" );
				}
			}

			prof_end( "PlayerKilled attacker" );
		}
	}
	else
	{
		doKillcam = false;
		killedByEnemy = false;

		lpattacknum = -1;
		lpattackguid = "";
		lpattackname = "";
		lpattackerteam = "world";

		if ( isDefined( attacker ) && isDefined( attacker.team ) && (attacker.team == "axis" || attacker.team == "allies") )
		{
			if ( attacker.team != self.pers["team"] )
			{
				killedByEnemy = true;
				if ( level.teamBased )
					giveTeamScore( "kill", attacker.team, attacker, self );
			}
		}
	}
	atkplayed_time = 0;
	victplayed_time = 0;
	cur_kill_streak = 0;
	cur_death_streak = 0;

	if (!isDefined(attacker))
		atkplayed_time = 0;
	else if (isDefined(attacker.played_time))
		atkplayed_time = attacker.played_time;

	if (!isDefined(self.played_time))
		victplayed_time = 0;
	else if (isDefined(self.played_time))
		victplayed_time = self.played_time;

	if (!isDefined(attacker))
		cur_kill_streak = 0;
	else if (isDefined(attacker.cur_kill_streak))
		cur_kill_streak = attacker.cur_kill_streak;

	if (!isDefined(self.cur_death_streak))
		cur_death_streak = 0;
	else if (isDefined(self.cur_death_streak))
		cur_death_streak = self.cur_death_streak;

	prof_begin( "PlayerKilled post constants" );

	if ( isDefined( attacker ) && isPlayer( attacker ) && attacker != self && (!level.teambased || attacker.pers["team"] != self.pers["team"]) )
		self thread maps\mp\gametypes\_missions::playerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, sHitLoc );
	else
		self notify("playerKilledChallengesProcessed");

	logPrint( "K;" + lpselfguid + ";" + lpattackguid + ";" + sWeapon + ";" + sMeansOfDeath + ";" + cur_kill_streak + ";" + cur_death_streak +";" + atkplayed_time + ";" + victplayed_time + ";" + skillbonus +"\n" );

	attacker.played_time = 0;
	self.played_time = 0;

	attackerString = "none";
	if ( isPlayer( attacker ) )
		attackerString = attacker getXuid() + "(" + lpattackname + ")";

	level thread updateTeamStatus();

	self maps\mp\gametypes\_gameobjects::detachUseModels();

	body = self clonePlayer( deathAnimDuration );
	if ( self isOnLadder() || self isMantling() )
		body startRagDoll();

	thread delayStartRagdoll( body, sHitLoc, vDir, sWeapon, eInflictor, sMeansOfDeath );

	self.body = body;
	if ( !isDefined( self.switching_teams ) )
		thread maps\mp\gametypes\_deathicons::addDeathicon( body, self, self.pers["team"], 5.0 );

	self.switching_teams = undefined;
	self.joining_team = undefined;
	self.leaving_team = undefined;

	self thread [[level.onPlayerKilled]](eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration);

	if ( isDefined( attacker ) && attacker != self && isPlayer( attacker ) )
	{
		attID = attacker getPlayerID();
		vicID = self getPlayerID();

		if ( !isDefined( self.pers[ "youVSfoe" ][ "killedBy" ][ attID ] ) )
			self.pers[ "youVSfoe" ][ "killedBy" ][ attID ] = 0;

		if ( !isDefined( self.pers[ "youVSfoe" ][ "killed" ][ attID ] ) )
			self.pers[ "youVSfoe" ][ "killed" ][ attID ] = 0;

		if ( !isDefined( attacker.pers[ "youVSfoe" ][ "killed" ][ vicID ] ) )
			attacker.pers[ "youVSfoe" ][ "killed" ][ vicID ] = 0;

		self.pers[ "youVSfoe" ][ "killedBy" ][ attID ]++;
		attacker.pers[ "youVSfoe" ][ "killed" ][ vicID ]++;
	}

	self thread volkv\events::onPlayerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration);

	if ( sWeapon == "frag_grenade_short_mp" )
		doKillcam = false;

	if ( sWeapon != "frag_grenade_short_mp" && isdefined( eInflictor ) && eInflictor != attacker )
	{
		killcamentity = eInflictor getEntityNumber();
		doKillcam = true;
	}
	else
	{
		killcamentity = -1;
	}

	self.deathTime = getTime();

	if ( isDefined( attacker.hardpointVision ) )
		self.hardpointVisionA = true;


	attacker notify( "player_killed" , self);

	postDeathDelay = 1.75;
	wait postDeathDelay;
	self notify ( "death_delay_finished" );

	if ( game["state"] != "playing" )
		return;

	respawnTimerStartTime = gettime();

	self maps\mp\gametypes\_killcam::killcam( lpattacknum, killcamentity, sWeapon, postDeathDelay + deathTimeOffset, psOffsetTime, true, timeUntilRoundEnd(), undefined, attacker, sMeansOfDeath );


	prof_end( "PlayerKilled post constants" );

	if ( game["state"] != "playing" )
	{
		self.sessionstate = "dead";
		self.spectatorclient = -1;
		self.killcamentity = -1;
		self.archivetime = 0;
		self.psoffsettime = 0;
		return;
	}


	if ( isValidClass( self.class ) )
	{
		timePassed = (gettime() - respawnTimerStartTime) / 1000;
		self thread [[level.spawnClient]]( timePassed );
	}
}


cancelKillCamOnUse()
{
	self endon ( "death_delay_finished" );
	self endon ( "disconnect" );
	level endon ( "game_ended" );

	for ( ;; )
	{
		if ( !self UseButtonPressed() )
		{
			wait ( 0.05 );
			continue;
		}

		buttonTime = 0;
		while ( self UseButtonPressed() )
		{
			buttonTime += 0.05;
			wait ( 0.05 );
		}

		if ( buttonTime >= 0.5 )
			continue;

		buttonTime = 0;

		while ( !self UseButtonPressed() && buttonTime < 0.5 )
		{
			buttonTime += 0.05;
			wait ( 0.05 );
		}

		if ( buttonTime >= 0.5 )
			continue;

		self.cancelKillcam = true;
		return;
	}
}

waitForTimeOrNotifies( desiredDelay )
{
	startedWaiting = getTime();

	waitedTime = (getTime() - startedWaiting)/1000;

	if ( waitedTime < desiredDelay )
	{
		wait desiredDelay - waitedTime;
		return desiredDelay;
	}
	else
	{
		return waitedTime;
	}
}

reduceTeamKillsOverTime()
{
	timePerOneTeamkillReduction = 20.0;
	reductionPerSecond = 1.0 / timePerOneTeamkillReduction;

	while (1)
	{
		if ( isAlive( self ) )
		{
			self.pers["teamkills"] -= reductionPerSecond;
			if ( self.pers["teamkills"] < level.minimumAllowedTeamKills )
			{
				self.pers["teamkills"] = level.minimumAllowedTeamKills;
				break;
			}
		}
		wait 1;
	}
}

getPerks( player )
{
	perks[0] = "specialty_null";
	perks[1] = "specialty_null";
	perks[2] = "specialty_null";


	if ( isPlayer( player ) && !level.oldschool )
	{
		if (player.inTrainingArea) {
			perks[0] = "specialty_quieter";
			perks[1] = "specialty_gpsjammer";
			perks[2] = "specialty_longersprint";
		}
		else if ( level.onlineGame && !isdefined( player.pers["isBot"] ) && isSubstr( player.curClass, "CLASS_CUSTOM" ) && isdefined(player.custom_class) )
		{

			class_num = player.class_num;
			if ( isDefined( player.custom_class[class_num]["specialty1"] ) )
				perks[0] = player.custom_class[class_num]["specialty1"];
			if ( isDefined( player.custom_class[class_num]["specialty2"] ) )
				perks[1] = player.custom_class[class_num]["specialty2"];
			if ( isDefined( player.custom_class[class_num]["specialty3"] ) )
				perks[2] = player.custom_class[class_num]["specialty3"];
		}
		else
		{
			if (!isDefined(player.curClass))
				return perks;
			if ( isDefined( level.default_perk[player.curClass][0] ) )
				perks[0] = level.default_perk[player.curClass][0];
			if ( isDefined( level.default_perk[player.curClass][1] ) )
				perks[1] = level.default_perk[player.curClass][1];
			if ( isDefined( level.default_perk[player.curClass][2] ) )
				perks[2] = level.default_perk[player.curClass][2];
		}
	}

	return perks;
}

processAssist( killedplayer )
{
	self endon("disconnect");
	killedplayer endon("disconnect");

	wait .05;
	WaitTillSlowProcessAllowed();

	if ( self.pers["team"] != "axis" && self.pers["team"] != "allies" )
		return;

	if ( self.pers["team"] == killedplayer.pers["team"] )
		return;

	self thread [[level.onXPEvent]]( "assist" );
	self incPersStat( "assists", 1 );
	self.assists = self getPersStat( "assists" );

	givePlayerScore( "assist", self, killedplayer );

	self thread maps\mp\gametypes\_missions::playerAssist();
}

Callback_PlayerLastStand( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
	self.health = 1;

	self.lastStandParams = spawnstruct();
	self.lastStandParams.eInflictor = eInflictor;
	self.lastStandParams.attacker = attacker;
	self.lastStandParams.iDamage = iDamage;
	self.lastStandParams.sMeansOfDeath = sMeansOfDeath;
	self.lastStandParams.sWeapon = sWeapon;
	self.lastStandParams.vDir = vDir;
	self.lastStandParams.sHitLoc = sHitLoc;
	self.lastStandParams.lastStandStartTime = gettime();

	mayDoLastStand = mayDoLastStand( sWeapon, sMeansOfDeath, sHitLoc );

	if ( !mayDoLastStand )
	{
		self.useLastStandParams = true;
		self ensureLastStandParamsValidity();
		self suicide();
		return;
	}

	weaponslist = self getweaponslist();
	assertex( isdefined( weaponslist ) && weaponslist.size > 0, "Players weapon(s) missing before dying -=Last Stand=-" );

	self thread maps\mp\gametypes\_gameobjects::onPlayerLastStand();

	self maps\mp\gametypes\_weapons::dropWeaponForDeath( attacker );

	notifyData = spawnStruct();
	notifyData.titleText = game["strings"]["last_stand"]; //"Last Stand!";
	notifyData.iconName = "specialty_pistoldeath";
	notifyData.glowColor = (1,0,0);
	notifyData.sound = "mp_last_stand";
	notifyData.duration = 2.0;

	self thread maps\mp\gametypes\_hud_message::notifyMessage( notifyData );

	grenadeTypePrimary = "frag_grenade_mp";

	for ( i = 0; i < weaponslist.size; i++ )
	{
		weapon = weaponslist[i];
		if ( maps\mp\gametypes\_weapons::isPistol( weapon ) )
		{
			self takeallweapons();
			self maps\mp\gametypes\_hardpoints::giveOwnedHardpointItem();
			self giveweapon( weapon );
			self giveMaxAmmo( weapon );
			self switchToWeapon( weapon );
			self GiveWeapon( grenadeTypePrimary );
			self SetWeaponAmmoClip( grenadeTypePrimary, 0 );
			self SwitchToOffhand( grenadeTypePrimary );
			self thread lastStandTimer( 10 );
			return;
		}
	}
	self takeallweapons();
	self maps\mp\gametypes\_hardpoints::giveOwnedHardpointItem();
	self giveWeapon( "beretta_mp" );
	self giveMaxAmmo( "beretta_mp" );
	self switchToWeapon( "beretta_mp" );
	self GiveWeapon( grenadeTypePrimary );
	self SetWeaponAmmoClip( grenadeTypePrimary, 0 );
	self SwitchToOffhand( grenadeTypePrimary );
	self thread lastStandTimer( 10 );
}


lastStandTimer( delay )
{
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "game_ended" );

	self thread lastStandWaittillDeath();

	self.lastStand = true;
	self setLowerMessage( &"PLATFORM_COWARDS_WAY_OUT" );

	self thread lastStandAllowSuicide();
	self thread lastStandKeepOverlay();

	wait delay;

	self thread LastStandBleedOut();
}

LastStandBleedOut()
{
	self.useLastStandParams = true;
	self ensureLastStandParamsValidity();
	self suicide();
}

lastStandAllowSuicide()
{
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "game_ended" );

	while (1)
	{
		if ( self useButtonPressed() )
		{
			pressStartTime = gettime();
			while ( self useButtonPressed() )
			{
				wait .05;
				if ( gettime() - pressStartTime > 700 )
					break;
			}
			if ( gettime() - pressStartTime > 700 )
				break;
		}
		wait .05;
	}

	self thread LastStandBleedOut();
}

lastStandKeepOverlay()
{
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "game_ended" );

	while (1)
	{
		self.health = 2;
		wait .05;
		self.health = 1;
		wait .5;
	}
}

lastStandWaittillDeath()
{
	self endon( "disconnect" );

	self waittill( "death" );

	self clearLowerMessage();
	self.lastStand = undefined;
}

mayDoLastStand( sWeapon, sMeansOfDeath, sHitLoc )
{
	if ( sMeansOfDeath != "MOD_PISTOL_BULLET" && sMeansOfDeath != "MOD_RIFLE_BULLET" && sMeansOfDeath != "MOD_FALLING" )
		return false;

	if ( isHeadShot( sWeapon, sHitLoc, sMeansOfDeath ) )
		return false;

	return true;
}

ensureLastStandParamsValidity()
{
	if ( !isDefined( self.lastStandParams.attacker ) )
		self.lastStandParams.attacker = self;
}

setSpawnVariables()
{
	resetTimeout();

	self StopShellshock();
	self StopRumble( "damage_heavy" );
}

notifyConnecting()
{
	waittillframeend;

	if ( isDefined( self ) )
		level notify( "connecting", self );
}


setObjectiveText( team, text )
{
	game["strings"]["objective_"+team] = text;
	precacheString( text );
}

setObjectiveScoreText( team, text )
{
	game["strings"]["objective_score_"+team] = text;
	precacheString( text );
}

setObjectiveHintText( team, text )
{
	game["strings"]["objective_hint_"+team] = text;
	precacheString( text );
}

getObjectiveText( team )
{
	return game["strings"]["objective_"+team];
}

getObjectiveScoreText( team )
{
	return game["strings"]["objective_score_"+team];
}

getObjectiveHintText( team )
{
	return game["strings"]["objective_hint_"+team];
}

getHitLocHeight( sHitLoc )
{
	switch ( sHitLoc )
	{
	case "helmet":
	case "head":
	case "neck":
		return 60;
	case "torso_upper":
	case "right_arm_upper":
	case "left_arm_upper":
	case "right_arm_lower":
	case "left_arm_lower":
	case "right_hand":
	case "left_hand":
	case "gun":
		return 48;
	case "torso_lower":
		return 40;
	case "right_leg_upper":
	case "left_leg_upper":
		return 32;
	case "right_leg_lower":
	case "left_leg_lower":
		return 10;
	case "right_foot":
	case "left_foot":
		return 5;
	}
	return 48;
}

debugLine( start, end )
{
	for ( i = 0; i < 50; i++ )
	{
		line( start, end );
		wait .05;
	}
}

delayStartRagdoll( ent, sHitLoc, vDir, sWeapon, eInflictor, sMeansOfDeath )
{
	if ( isDefined( ent ) )
	{
		deathAnim = ent getcorpseanim();
		if ( animhasnotetrack( deathAnim, "ignore_ragdoll" ) )
			return;
	}

	if ( level.oldschool )
	{
		if ( !isDefined( vDir ) )
			vDir = (0,0,0);

		explosionPos = ent.origin + ( 0, 0, getHitLocHeight( sHitLoc ) );
		explosionPos -= vDir * 20;
		explosionRadius = 40;
		explosionForce = .75;
		if ( sMeansOfDeath == "MOD_IMPACT" || sMeansOfDeath == "MOD_EXPLOSIVE" || isSubStr(sMeansOfDeath, "MOD_GRENADE") || isSubStr(sMeansOfDeath, "MOD_PROJECTILE") || sHitLoc == "head" || sHitLoc == "helmet" )
		{
			explosionForce = 2.5;
		}

		ent startragdoll( 1 );

		wait .05;

		if ( !isDefined( ent ) )
			return;

		// apply extra physics force to make the ragdoll go crazy
		physicsExplosionSphere( explosionPos, explosionRadius, explosionRadius/2, explosionForce );
		return;
	}

	wait( 0.2 );

	if ( !isDefined( ent ) )
		return;

	if ( ent isRagDoll() )
		return;

	deathAnim = ent getcorpseanim();

	startFrac = 0.35;

	if ( animhasnotetrack( deathAnim, "start_ragdoll" ) )
	{
		times = getnotetracktimes( deathAnim, "start_ragdoll" );
		if ( isDefined( times ) )
			startFrac = times[0];
	}

	waitTime = startFrac * getanimlength( deathAnim );
	wait( waitTime );

	if ( isDefined( ent ) )
	{
		println( "Ragdolling after " + waitTime + " seconds" );
		ent startragdoll( 1 );
	}
}


isExcluded( entity, entityList )
{
	for ( index = 0; index < entityList.size; index++ )
	{
		if ( entity == entityList[index] )
			return true;
	}
	return false;
}

leaderDialog( dialog, team, group, excludeList )
{
	assert( isdefined( level.players ) );

	if ( !isDefined( team ) )
	{
		leaderDialogBothTeams( dialog, "allies", dialog, "axis", group, excludeList );
		return;
	}

	if ( isDefined( excludeList ) )
	{
		for ( i = 0; i < level.players.size; i++ )
		{
			player = level.players[i];
			if ( (isDefined( player.pers["team"] ) && (player.pers["team"] == team )) && !isExcluded( player, excludeList ) )
				player leaderDialogOnPlayer( dialog, group );
		}
	}
	else
	{
		for ( i = 0; i < level.players.size; i++ )
		{
			player = level.players[i];
			if ( isDefined( player.pers["team"] ) && (player.pers["team"] == team ) )
				player leaderDialogOnPlayer( dialog, group );
		}
	}
}

leaderDialogBothTeams( dialog1, team1, dialog2, team2, group, excludeList )
{
	assert( isdefined( level.players ) );

	if ( isDefined( excludeList ) )
	{
		for ( i = 0; i < level.players.size; i++ )
		{
			player = level.players[i];
			team = player.pers["team"];

			if ( !isDefined( team ) )
				continue;

			if ( isExcluded( player, excludeList ) )
				continue;

			if ( team == team1 )
				player leaderDialogOnPlayer( dialog1, group );
			else if ( team == team2 )
				player leaderDialogOnPlayer( dialog2, group );
		}
	}
	else
	{
		for ( i = 0; i < level.players.size; i++ )
		{
			player = level.players[i];
			team = player.pers["team"];

			if ( !isDefined( team ) )
				continue;

			if ( team == team1 )
				player leaderDialogOnPlayer( dialog1, group );
			else if ( team == team2 )
				player leaderDialogOnPlayer( dialog2, group );
		}
	}
}

leaderDialogOnPlayer( dialog, group )
{
	team = self.pers["team"];

	if ( !isDefined( team ) )
		return;

	if ( team != "allies" && team != "axis" )
		return;

	if ( isDefined( group ) )
	{
		if ( self.leaderDialogGroup == group )
			return;

		hadGroupDialog = isDefined( self.leaderDialogGroups[group] );

		self.leaderDialogGroups[group] = dialog;
		dialog = group;

		if ( hadGroupDialog )
			return;
	}

	if ( !self.leaderDialogActive )
		self thread playLeaderDialogOnPlayer( dialog, team );
	else
		self.leaderDialogQueue[self.leaderDialogQueue.size] = dialog;
}

playLeaderDialogOnPlayer( dialog, team )
{
	self endon ( "disconnect" );

	self.leaderDialogActive = true;
	if ( isDefined( self.leaderDialogGroups[dialog] ) )
	{
		group = dialog;
		dialog = self.leaderDialogGroups[group];
		self.leaderDialogGroups[group] = undefined;
		self.leaderDialogGroup = group;
	}

	self playLocalSound( game["voice"][team]+game["dialog"][dialog] );

	wait ( 3.0 );
	self.leaderDialogActive = false;
	self.leaderDialogGroup = "";

	if ( self.leaderDialogQueue.size > 0 )
	{
		nextDialog = self.leaderDialogQueue[0];

		for ( i = 1; i < self.leaderDialogQueue.size; i++ )
			self.leaderDialogQueue[i-1] = self.leaderDialogQueue[i];
		self.leaderDialogQueue[i-1] = undefined;

		self thread playLeaderDialogOnPlayer( nextDialog, team );
	}
}

getMostKilledBy()
{
	mostKilledBy = "";
	killCount = 0;

	killedByNames = getArrayKeys( self.killedBy );

	for ( index = 0; index < killedByNames.size; index++ )
	{
		killedByName = killedByNames[index];
		if ( self.killedBy[killedByName] <= killCount )
			continue;

		killCount = self.killedBy[killedByName];
		mostKilleBy = killedByName;
	}

	return mostKilledBy;
}

getMostKilled()
{
	mostKilled = "";
	killCount = 0;

	killedNames = getArrayKeys( self.killedPlayers );

	for ( index = 0; index < killedNames.size; index++ )
	{
		killedName = killedNames[index];
		if ( self.killedPlayers[killedName] <= killCount )
			continue;

		killCount = self.killedPlayers[killedName];
		mostKilled = killedName;
	}

	return mostKilled;
}

killnotify(attacker,killed) {
	if (!isDefined(attacker) || !isDefined(killed))
		return;
	attacker thread KillText(killed,attacker volkv\_common::getLangString("KILLED_PLAYER"));
	killed thread KillText(attacker,killed volkv\_common::getLangString("GOT_KILLED"));
}

KillText(who,text) {
	self endon("disconnect");
	self notify("new_killtext_instanze");
	self endon("new_killtext_instanze");
	if (isDefined(self.killtext))
		self.killtext destroy();
	self.killtext = volkv\_common::addTextHud( self, 0, 140, 1, "center", "middle", "center", "middle", 1.8, 1 );
	self.killtext.label = text;
	self.killtext SetPlayerNameString(who);
	wait 5;
	self.killtext destroy();

}