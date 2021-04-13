#include volkv\file;

init()
{

	logprint("ENDING_1_1\n");

	sLoc = getLoc();
	sAng = getAng();

	level.credits = randomint(5);


	players = getEntArray( "player", "classname" );


	for ( p = 0; p < players.size; p++ )
	{
		player = players[p];

		player thread maps\mp\gametypes\_globallogic::spawnSpectator( sLoc, sAng );

		player setclientdvar( "ui_hud_hardcore", 1 );
		player setclientdvar( "g_scriptMainMenu", "" );
		player setclientdvar( "g_compassShowEnemies", 0);
		player setclientdvar( "cg_drawSpectatorMessages", 0);

		if ( isDefined( player.mc_kdratio ) )	player.mc_kdratio Destroy();
		if ( isDefined( player.mc_skill ) )	player.mc_skill Destroy();
		if ( isDefined( player.mc_streak ) )	player.mc_streak Destroy();

		player freezeControls( true );
	}

	logprint("ENDING_2\n");

	level.bestplayers = [];
	level.bestplayers[ 0 ] = [];
	level.bestplayers[ 1 ] = [];

	level.bestplayers[ 0 ][ 0 ] = "";  //score
	level.bestplayers[ 0 ][ 1 ] = "";  //kills
	level.bestplayers[ 0 ][ 2 ] = "";  //streak
	level.bestplayers[ 0 ][ 3 ] = "";  //deaths
	level.bestplayers[ 0 ][ 4 ] = "";  //melee
	level.bestplayers[ 0 ][ 5 ] = "";  //headshots
	level.bestplayers[ 0 ][ 6 ] = "";  //grenades

	level.bestplayers[ 1 ][ 0 ] = 0;
	level.bestplayers[ 1 ][ 1 ] = 0;
	level.bestplayers[ 1 ][ 2 ] = 0;
	level.bestplayers[ 1 ][ 3 ] = 0;
	level.bestplayers[ 1 ][ 4 ] = 0;
	level.bestplayers[ 1 ][ 5 ] = 0;
	level.bestplayers[ 1 ][ 6 ] = 0;

	waittillframeend;

	players = getEntArray( "player", "classname" );

	for ( p = 0; p < players.size; p++ )
	{
		player = players[p];

		topname= [];
		player.topname[0] = player volkv\_common::getLangString("TOP_SCORE");
		player.topname[1] = player volkv\_common::getLangString("TOP_KILLS");
		player.topname[2] = player volkv\_common::getLangString("TOP_KILLSTREAK");
		player.topname[3] = player volkv\_common::getLangString("TOP_DEATHS");
		player.topname[4] = player volkv\_common::getLangString("TOP_KNIVES");
		player.topname[5] = player volkv\_common::getLangString("TOP_HEASHOTS");
		player.topname[6] = player volkv\_common::getLangString("TOP_GRENADES");

		player thread Blur();


		if ( level.bestplayers[ 1 ][ 0 ] < player.pers[ "score" ] )
		{
			level.bestplayers[ 1 ][ 0 ] = player.pers[ "score" ];
			level.bestplayers[ 0 ][ 0 ] = player.name;
		}

		if ( level.bestplayers[ 1 ][ 1 ] < player.pers[ "kills" ] )
		{
			level.bestplayers[ 1 ][ 1 ] = player.pers[ "kills" ];
			level.bestplayers[ 0 ][ 1 ] = player.name;
		}

		if ( level.bestplayers[ 1 ][ 2 ] < player.pers["max_kill_streak"] )
		{
			level.bestplayers[ 1 ][ 2 ] = player.pers["max_kill_streak"];
			level.bestplayers[ 0 ][ 2 ] = player.name;
		}

		if ( level.bestplayers[ 1 ][ 3 ] < player.pers[ "deaths" ] )
		{
			level.bestplayers[ 1 ][ 3 ] = player.pers[ "deaths" ];
			level.bestplayers[ 0 ][ 3 ] = player.name;
		}

		if ( level.bestplayers[ 1 ][ 4 ] < player.pers[ "meleekills" ] )
		{
			level.bestplayers[ 1 ][ 4 ] = player.pers[ "meleekills" ];
			level.bestplayers[ 0 ][ 4 ] = player.name;
		}

		if ( level.bestplayers[ 1 ][ 5 ] < player.pers[ "headshots" ] )
		{
			level.bestplayers[ 1 ][ 5 ] = player.pers[ "headshots" ];
			level.bestplayers[ 0 ][ 5 ] = player.name;
		}

		if ( level.bestplayers[ 1 ][ 6 ] < player.pers[ "grenadekills" ] )
		{
			level.bestplayers[ 1 ][ 6 ] = player.pers[ "grenadekills" ];
			level.bestplayers[ 0 ][ 6 ] = player.name;
		}


		waittillframeend;
	}

	logprint("ENDING_3\n");
	AmbientStop( 1 );

	bestplayers();

}


bestplayers()
{
	prefix = toLower( getDvar( "mapname" ) );

	var = [];
	var[ 0 ] = prefix + "_score";
	var[ 1 ] = prefix + "_kills";
	var[ 2 ] = prefix + "_killstreak";
	var[ 3 ] = prefix + "_deaths";
	var[ 4 ] = prefix + "_knives";
	var[ 5 ] = prefix + "_headshots";
	var[ 6 ] = prefix + "_grenades";

	icon= [];
	icon[0] = "ui_host";
	icon[1] = "killiconimpact";
	icon[2] = "hud_bullets_spread";
	icon[3] = "killicondied";
	icon[4] = "killiconmelee";
	icon[5] = "killiconheadshot";
	icon[6] = "hud_us_grenade";


	data = [];
	data[ 0 ] = getCvarTop( var[ 0 ] );
	data[ 1 ] = getCvarTop( var[ 1 ] );
	data[ 2 ] = getCvarTop( var[ 2 ] );
	data[ 3 ] = getCvarTop( var[ 3 ] );
	data[ 4 ] = getCvarTop( var[ 4 ] );
	data[ 5 ] = getCvarTop( var[ 5 ] );
	data[ 6 ] = getCvarTop( var[ 6 ] );

	new = [];
	new[ 0 ] = undefined;
	new[ 1 ] = undefined;
	new[ 2 ] = undefined;
	new[ 3 ] = undefined;
	new[ 4 ] = undefined;
	new[ 5 ] = undefined;
	new[ 6 ] = undefined;

	split = [];

	for ( i = 0; i < data.size; i++ )
	{

		if ( data[ i ] != "" )
		{
			split[ i ] = strTok( data[ i ], ";" );

			if ( level.bestplayers[ 0 ][ i ] != "" && int( split[ i ][ 1 ] ) < level.bestplayers[ 1 ][ i ] )
			{
				data[ i ] = level.bestplayers[ 0 ][ i ] + ";" + level.bestplayers[ 1 ][ i ];
				new[ i ] = true;
				setCvarTop( var[ i ], data[ i ] );
			}
			else
				continue;
		}

		else
		{
			if ( level.bestplayers[ 0 ][ i ] != "" )
			{
				data[ i ] = level.bestplayers[ 0 ][ i ] + ";" + level.bestplayers[ 1 ][ i ];
				new[ i ] = true;
				setCvarTop( var[ i ], data[ i ] );
			} else if ( level.bestplayers[ 0 ][ i ] == "" )
			{
				data[ i ] = " ; ";
			}

		}

		waittillframeend;
	}

	logprint("ENDING_4\n");
	players = getEntArray( "player", "classname" );

	for ( p = 0; p < players.size; p++ )

	{

		players[p] thread showTop(var,data,new,icon);

	}


	wait 20;

}

showTop(var,data,new,icon) {

	self endon("disconnect");

	self.topTitle = newClientHudElem(self);
	self.topTitle.vertAlign = "top";
	self.topTitle.horzAlign = "center";
	self.topTitle.alignX = "center";
	self.topTitle.alignY = "middle";
	self.topTitle.y = 50;
	self.topTitle.x = 0;
	self.topTitle.alpha = 0;
	self.topTitle setText(self volkv\_common::getLangString("TOP_TITLE"));
	self.topTitle.fontScale = 4;
	self.topTitle.alpha = 1;
	self.topTitle fadeOverTime( 1 );


///////////////////////////OUTPUT/////////////////////////////////

	for ( i = 0; i < var.size; i++ )
	{


		self.endingIcon[ i ] = newClientHudElem(self);
		self.endingIcon[ i ].alignx = "center";
		self.endingIcon[ i ].alignY = "middle";
		self.endingIcon[ i ].horzAlign = "center";
		self.endingIcon[ i ].vertAlign = "middle";
		self.endingIcon[ i ].y = -120 + (i * 50);
		self.endingIcon[ i ].x = -150;
		self.endingIcon[ i ] setShader( icon[i], 32, 32 );
		self.endingIcon[ i ].alpha = 1;
		self.endingIcon[ i ].archived = false;

		self.ending[ i ] = newClientHudElem(self);
		self.ending[ i ].horzAlign = "center";
		self.ending[ i ].vertAlign = "middle";
		self.ending[ i ].alignX = "left";
		self.ending[ i ].alignY = "middle";
		self.ending[ i ].y = -130 + (i * 50);
		self.ending[ i ].x = -120;
		self.ending[ i ].glowAlpha = 0;
		self.ending[ i ].fontScale = 1.8;
		self.ending[ i ].alpha = 0;
		self.ending[ i ].archived = false;

		self.endingRecord[ i ] = newClientHudElem(self);
		self.endingRecord[ i ].horzAlign = "center";
		self.endingRecord[ i ].vertAlign = "middle";
		self.endingRecord[ i ].alignX = "left";
		self.endingRecord[ i ].alignY = "middle";
		self.endingRecord[ i ].y = -110 + (i * 50);
		self.endingRecord[ i ].x = -120;
		self.endingRecord[ i ].glowAlpha = 0;
		self.endingRecord[ i ].fontScale = 1.4;
		self.endingRecord[ i ].alpha = 0;
		self.endingRecord[ i ].archived = false;

		split[ i ] = strTok( data[ i ], ";" );

		if ( data[ i ] != "" && isDefined(new[ i ]) && int( level.bestplayers[ 1 ][ i ] ) > 0 ) {

			self.ending[ i ] setText( "^5"+self.topname[i] + self volkv\_common::getLangString("TOP_NEW_REC") + level.bestplayers[ 0 ][ i ] + " ^3- ^1" + level.bestplayers[ 1 ][ i ]);
			self.endingRecord[ i ] setText("^3"+self volkv\_common::getLangString("TOP_MAP_REC")+" ^2" + split[ i ][ 0 ] + " ^3- ^1" + split[ i ][ 1 ]);

		} else if ( data[ i ] != "" && int( level.bestplayers[ 1 ][ i ] ) > 0 ) {

			self.ending[ i ] setText( "^5"+self.topname[i]+" ^2" + level.bestplayers[ 0 ][ i ] + " ^3- ^1" + level.bestplayers[ 1 ][ i ]);
			self.endingRecord[ i ] setText("^3"+self volkv\_common::getLangString("TOP_MAP_REC")+" ^2" + split[ i ][ 0 ] + " ^3- ^1" + split[ i ][ 1 ]);

		} else if ( data[ i ] != "" && int( level.bestplayers[ 1 ][ i ] ) == 0 && int( split[ i ][ 1 ] ) > 0  ) {

			self.ending[ i ] setText( "^5"+self.topname[i]+" ^2"+self volkv\_common::getLangString("TOP_NO_REC"));
			self.endingRecord[ i ] setText("^3"+self volkv\_common::getLangString("TOP_MAP_REC")+" ^2" + split[ i ][ 0 ] + " ^3- ^1" + split[ i ][ 1 ]);

		} else {
			self.ending[ i ] setText( "^5"+self.topname[i]+" ^2"+self volkv\_common::getLangString("TOP_NO_REC") );
		}

		self.ending[ i ] fadeOverTime( 1 );
		self.endingRecord[ i ] fadeOverTime( 1 );

		self.ending[ i ].alpha = 1;
		self.endingRecord[ i ].alpha = .7;
	}


	wait 10;

	for ( i = 0; i < self.ending.size; i++ )
	{

		self.endingIcon[ i ] fadeOverTime( 1 );
		self.endingIcon[ i ].alpha = 0;

		self.ending[ i ] fadeOverTime( 1 );
		self.ending[ i ].alpha = 0;

		self.endingRecord[ i ] fadeOverTime( 1 );
		self.endingRecord[ i ].alpha = 0;

	}

	self.topTitle fadeOverTime( 1 );
	self.topTitle.alpha = 0;


	wait 1;


	self.topTitle destroy();



	for ( i = 0; i < self.ending.size; i++ )
	{
		self.ending[ i ] destroy();
		self.endingRecord[ i ] destroy();
		self.endingIcon[ i ] destroy();
	}

	logprint("ENDING_5\n");
	if (level.credits == 0) {

		self thread credits2();

	} else if (level.credits == 1) {
		self thread credits3();
	}  else if (level.credits == 2) {
		self thread credits();
	} else if (level.credits == 3) {
		self thread credits4();
	}  else if (level.credits == 4) {
		self thread credits5();
	}

	logprint("ENDING_6\n");
}

credits3() {

	self endon("disconnect");


	creditText[0] = newClientHudElem(self);
	creditText[0].horzAlign = "center";
	creditText[0].vertAlign = "middle";
	creditText[0].alignX = "center";
	creditText[0].alignY = "middle";
	creditText[0].y = -190;
	creditText[0].x = 0;
	creditText[0].fontScale = 3;
	creditText[0].alpha = 0;
	creditText[0].archived = false;
	creditText[0] setText( self volkv\_common::getLangString("CREDITS_VIP1") );
	creditText[0] fadeOverTime(1);
	creditText[0].alpha = 1;



	var[0] = "CREDITS_VIP2";
	var[1] = "CREDITS_VIP3";
	var[2] = "CREDITS_VIP4";
	var[3] = "CREDITS_VIP5";
	var[4] = "CREDITS_VIP6";
	var[5] = "CREDITS_VIP7";



	for ( i = 0; i < var.size; i++ )
	{

		self.prestigeIcon[ i ] = newClientHudElem(self);
		self.prestigeIcon[ i ].horzAlign = "center";
		self.prestigeIcon[ i ].vertAlign = "middle";
		self.prestigeIcon[ i ].alignx = "center";
		self.prestigeIcon[ i ].alignY = "middle";
		self.prestigeIcon[ i ].y = -135 + (i * 43);
		self.prestigeIcon[ i ].x = -240;
		self.prestigeIcon[ i ] setShader("hud_teamcaret", 38, 38 );
		self.prestigeIcon[ i ].alpha = 0;
		self.prestigeIcon[ i ].archived = false;
		self.prestigeIcon[ i ] fadeOverTime( 1 );
		self.prestigeIcon[ i ].alpha = 1;

		self.prestigeText[ i ] = newClientHudElem(self);
		self.prestigeText[ i ].horzAlign = "center";
		self.prestigeText[ i ].vertAlign = "middle";
		self.prestigeText[ i ].alignX = "left";
		self.prestigeText[ i ].alignY = "middle";
		self.prestigeText[ i ].y = -135 + (i * 43);
		self.prestigeText[ i ].x = -210;
		self.prestigeText[ i ].fontScale = 2;
		self.prestigeText[ i ].alpha = 0;
		self.prestigeText[ i ].archived = false;
		self.prestigeText[ i ] setText( self volkv\_common::getLangString(var[i]) );
		self.prestigeText[ i ] fadeOverTime( 1 );
		self.prestigeText[ i ].alpha = 1;


		wait .2;


	}


	creditText[1] = newClientHudElem(self);
	creditText[1].horzAlign = "right";
	creditText[1].vertAlign = "middle";
	creditText[1].alignX = "right";
	creditText[1].alignY = "middle";
	creditText[1].y = 125;
	creditText[1].x = -220;
	creditText[1].fontScale = 1.8;
	creditText[1].alpha = 0;
	creditText[1].archived = false;
	creditText[1] setText( self volkv\_common::getLangString("CREDIT_6") );

	creditText[1] fadeOverTime(1);
	creditText[1].alpha = 1;

	wait .2;



	creditText[2] = newClientHudElem(self);

	creditText[2].horzAlign = "right";

	creditText[2].vertAlign = "middle";

	creditText[2].alignX = "right";

	creditText[2].alignY = "middle";

	creditText[2].y = 125;

	creditText[2].x = -180;

	creditText[2] setShader( "ui_host", 32, 32 );

	creditText[2].alpha = 0;

	creditText[2].archived = false;



	creditText[2] fadeOverTime(1);

	creditText[2].alpha = 1;


	wait .2;


	creditText[3] = newClientHudElem(self);
	creditText[3].horzAlign = "center";
	creditText[3].vertAlign = "middle";
	creditText[3].alignX = "center";
	creditText[3].alignY = "middle";
	creditText[3].y = 185;
	creditText[3].x = 0;
	creditText[3] setShader( "ui_slider2", 450, 64 );
	creditText[3].color = (.392,.764,.2);
	creditText[3].alpha = 0;
	creditText[3].archived = false;

	creditText[3] fadeOverTime(1);
	creditText[3].alpha = 1;


	creditText[4] = newClientHudElem(self);
	creditText[4].horzAlign = "center";
	creditText[4].vertAlign = "middle";
	creditText[4].alignX = "center";
	creditText[4].alignY = "middle";
	creditText[4].y = 185;
	creditText[4].x = 0;
	creditText[4].fontScale = 4;
	creditText[4].alpha = 0;
	creditText[4].archived = false;
	creditText[4] setText( "^3CoD4Narod.RU/^2donate");
	creditText[4] fadeOverTime(1);
	creditText[4].alpha = 1;


}

credits5() {

	self endon("disconnect");


	creditText[0] = newClientHudElem(self);
	creditText[0].horzAlign = "center";
	creditText[0].vertAlign = "middle";
	creditText[0].alignX = "center";
	creditText[0].alignY = "middle";
	creditText[0].y = -195;
	creditText[0].x = 0;
	creditText[0].fontScale = 4;
	creditText[0].alpha = 0;
	creditText[0].archived = false;
	creditText[0] setText( self volkv\_common::getLangString("CREDIT_SERVERS") );
	creditText[0] fadeOverTime(1);
	creditText[0].alpha = 1;

	server[0] = "^2CoD4Narod^3.RU ^0| ^1TDM";
	serverip[0] = "\\connect C4N.RU:28960";
	server[1] = "^2CoD4Narod^3.RU ^0| ^1DOM";
	serverip[1] = "\\connect C4N.RU:28961";
	server[2] = "^2C4N^0 | ^1VACANT-BACKLOT";
	serverip[2] = "\\connect C4N.RU:28962";
	server[3] = "^2CoD4Narod^0 | ^1CROSSFIRE";
	serverip[3] = "\\connect C4N.RU:28963";
	server[4] = "^2CoD4Narod ^0| ^1DOM HARD";
	serverip[4] = "\\connect C4N.RU:28964";
	server[5] = "^2CoD4Narod^3.RU ^0| ^1CRASH";
	serverip[5] = "\\connect C4N.RU:28966";
	server[6] = "^2C4N^0 | ^1CROSSFIRE HARD";
	serverip[6] = "\\connect C4N.RU:28967";
	server[7] = "^2CoD4Narod^0 | ^1KILLHOUSE";
	serverip[7] = "\\connect C4N.RU:28969";



	for ( i = 0; i < server.size; i++ )
	{

		self.serverText[ i ] = newClientHudElem(self);
		self.serverText[ i ].horzAlign = "center";
		self.serverText[ i ].vertAlign = "middle";
		self.serverText[ i ].alignX = "center";
		self.serverText[ i ].alignY = "middle";
		self.serverText[ i ].y = -152 + (i * 45);
		self.serverText[ i ].x = 0;
		self.serverText[ i ].fontScale = 2;
		self.serverText[ i ].alpha = 0;
		self.serverText[ i ].archived = false;
		self.serverText[ i ] setText( server[i] );
		self.serverText[ i ] fadeOverTime( 1 );
		self.serverText[ i ].alpha = 1;

		self.serverIP[ i ] = newClientHudElem(self);
		self.serverIP[ i ].horzAlign = "center";
		self.serverIP[ i ].vertAlign = "middle";
		self.serverIP[ i ].alignX = "center";
		self.serverIP[ i ].alignY = "middle";
		self.serverIP[ i ].y = -130 + (i * 45);
		self.serverIP[ i ].x = 0;
		self.serverIP[ i ].fontScale = 1.4;
		self.serverIP[ i ].alpha = 0;
		self.serverIP[ i ].archived = false;
		self.serverIP[ i ] setText( serverip[i] );
		self.serverIP[ i ] fadeOverTime( 1 );
		self.serverIP[ i ].alpha = .8;

		wait .2;

	}


}


credits4() {

	self endon("disconnect");


	creditText[0] = newClientHudElem(self);
	creditText[0].horzAlign = "center";
	creditText[0].vertAlign = "middle";
	creditText[0].alignX = "center";
	creditText[0].alignY = "middle";
	creditText[0].y = -195;
	creditText[0].x = 0;
	creditText[0].fontScale = 4;
	creditText[0].alpha = 0;
	creditText[0].archived = false;
	creditText[0] setText( self volkv\_common::getLangString("CREDITS_FORUM") );
	creditText[0] fadeOverTime(1);
	creditText[0].alpha = 1;

	creditText[1] = newClientHudElem(self);
	creditText[1].horzAlign = "center";
	creditText[1].vertAlign = "middle";
	creditText[1].alignX = "center";
	creditText[1].alignY = "middle";
	creditText[1].y = -145;
	creditText[1].x = 0;
	creditText[1].fontScale = 2;
	creditText[1].alpha = 0;
	creditText[1].archived = false;
	creditText[1] setText( self volkv\_common::getLangString("CREDITS_FORUM_DESC") );
	creditText[1] fadeOverTime(1);
	creditText[1].alpha = 1;

	var[0] = "CREDITS_FORUM1";
	var[1] = "CREDITS_FORUM2";
	var[2] = "CREDITS_FORUM3";
	var[3] = "CREDITS_FORUM4";
	var[4] = "CREDITS_FORUM5";
	var[5] = "CREDITS_FORUM6";
	var[6] = "CREDITS_FORUM7";


	for ( i = 0; i < var.size; i++ )
	{

		self.prestigeIcon[ i ] = newClientHudElem(self);
		self.prestigeIcon[ i ].horzAlign = "center";
		self.prestigeIcon[ i ].vertAlign = "middle";
		self.prestigeIcon[ i ].alignx = "center";
		self.prestigeIcon[ i ].alignY = "middle";
		self.prestigeIcon[ i ].y = -100 + (i * 38);
		self.prestigeIcon[ i ].x = -240;
		self.prestigeIcon[ i ] setShader("hud_teamcaret", 32, 32 );
		self.prestigeIcon[ i ].alpha = 0;
		self.prestigeIcon[ i ].archived = false;
		self.prestigeIcon[ i ] fadeOverTime( 1 );
		self.prestigeIcon[ i ].alpha = 1;

		self.prestigeText[ i ] = newClientHudElem(self);
		self.prestigeText[ i ].horzAlign = "center";
		self.prestigeText[ i ].vertAlign = "middle";
		self.prestigeText[ i ].alignX = "left";
		self.prestigeText[ i ].alignY = "middle";
		self.prestigeText[ i ].y = -100 + (i * 38);
		self.prestigeText[ i ].x = -210;
		self.prestigeText[ i ].fontScale = 1.8;
		self.prestigeText[ i ].alpha = 0;
		self.prestigeText[ i ].archived = false;
		self.prestigeText[ i ] setText( self volkv\_common::getLangString(var[i]) );
		self.prestigeText[ i ] fadeOverTime( 1 );
		self.prestigeText[ i ].alpha = 1;


		wait .2;


	}

	wait .2;

	creditText[2] = newClientHudElem(self);
	creditText[2].horzAlign = "center";
	creditText[2].vertAlign = "middle";
	creditText[2].alignX = "center";
	creditText[2].alignY = "middle";
	creditText[2].y = 190;
	creditText[2].x = 0;
	creditText[2] setShader( "ui_slider2", 310, 64 );
	creditText[2].color = (.392,.764,.2);
	creditText[2].alpha = 0;
	creditText[2].archived = false;
	creditText[2] fadeOverTime(1);
	creditText[2].alpha = 1;


	creditText[3] = newClientHudElem(self);
	creditText[3].vertAlign = "middle";
	creditText[3].horzAlign = "center";
	creditText[3].alignX = "center";
	creditText[3].alignY = "middle";
	creditText[3].y = 190;
	creditText[3].x = 0;
	creditText[3] setText("^3CoD4Narod.RU");
	creditText[3].fontScale = 4;
	creditText[3].alpha = 0;
	creditText[3] fadeOverTime(1);
	creditText[3].alpha = 1;


}

credits2() {

	self endon("disconnect");

	creditText[0] = newClientHudElem(self);
	creditText[0].horzAlign = "center";
	creditText[0].vertAlign = "middle";
	creditText[0].alignX = "center";
	creditText[0].alignY = "middle";
	creditText[0].y = -200;
	creditText[0].x = 0;
	creditText[0].fontScale = 1.8;
	creditText[0].alpha = 0;
	creditText[0].archived = false;
	creditText[0] setText( self volkv\_common::getLangString("CREDITS_PRESTIGES") );
	creditText[0] fadeOverTime(1);
	creditText[0].alpha = 1;

	wait .2;

	creditText[1] = newClientHudElem(self);
	creditText[1].horzAlign = "center";
	creditText[1].vertAlign = "middle";
	creditText[1].alignX = "center";
	creditText[1].alignY = "middle";
	creditText[1].y = -170;
	creditText[1].x = 0;
	creditText[1].fontScale = 1.8;
	creditText[1].alpha = 0;
	creditText[1].archived = false;
	creditText[1] setText( self volkv\_common::getLangString("CREDITS_PRESTIGES2") );
	creditText[1] fadeOverTime(1);
	creditText[1].alpha = 1;

	wait .2;

	creditText[1] = newClientHudElem(self);
	creditText[1].horzAlign = "center";
	creditText[1].vertAlign = "middle";
	creditText[1].alignX = "center";
	creditText[1].alignY = "middle";
	creditText[1].y = -140;
	creditText[1].x = 0;
	creditText[1].fontScale = 1.8;
	creditText[1].alpha = 0;
	creditText[1].archived = false;
	creditText[1] setText( self volkv\_common::getLangString("CREDITS_PRESTIGES3") );
	creditText[1] fadeOverTime(1);
	creditText[1].alpha = 1;

	wait .2;

	table[1] = newClientHudElem(self);
	table[1].horzAlign = "center";
	table[1].vertAlign = "middle";
	table[1].alignX = "center";
	table[1].alignY = "middle";
	table[1].y = -100;
	table[1].x = -100;
	table[1].color = (0,0,1);
	table[1].fontScale = 1.6;
	table[1].alpha = 0;
	table[1].archived = false;
	table[1] setText(self volkv\_common::getLangString("PRESTIGE_TABLE1"));
	table[1] fadeOverTime( 1 );
	table[1].alpha = 1;

	table[2] = newClientHudElem(self);
	table[2].horzAlign = "center";
	table[2].vertAlign = "middle";
	table[2].alignX = "left";
	table[2].alignY = "middle";
	table[2].y = -100;
	table[2].x = -20;
	table[2].color = (0,0,1);
	table[2].fontScale = 1.6;
	table[2].alpha = 0;
	table[2].archived = false;
	table[2] setText(self volkv\_common::getLangString("PRESTIGE_TABLE2"));
	table[2] fadeOverTime( 1 );
	table[2].alpha = 1;


	var = [];


	var[0] = "rank_prestige10";
	var[1] = "rank_prestige9";
	var[2] = "rank_prestige8";
	var[3] = "rank_prestige4";
	var[4] = "rank_prestige2";
	var[5] = "rank_prestige6";
	var[6] = "rank_prestige1";


	kd[0] = "2.6+";
	kd[1] = "2.0-2.6";
	kd[2] = "1.6-2.0";
	kd[3] = "1.2-1.6";
	kd[4] = "0.8-1.2";
	kd[5] = "0.6-0.8";
	kd[6] = "0.0-0.6";

	col[0] = (0.8, 0, 0.8);
	col[1] = (0, 1, 0);
	col[2] = (0, 0.7, 0 );
	col[3] = (0.9, 0.8, 0);
	col[4] = (0.9, 0.5, 0);
	col[5] = (0.7, 0, 0);
	col[6] = (0.9, 0, 0);


	for ( i = 0; i < var.size; i++ )
	{


		self.prestigeKD[ i ] = newClientHudElem(self);
		self.prestigeKD[ i ].horzAlign = "center";
		self.prestigeKD[ i ].vertAlign = "middle";
		self.prestigeKD[ i ].alignX = "center";
		self.prestigeKD[ i ].alignY = "middle";
		self.prestigeKD[ i ].y = -70 + (i * 35);
		self.prestigeKD[ i ].x = -100;
		self.prestigeKD[ i ].color = col[i];
		self.prestigeKD[ i ].fontScale = 1.6;
		self.prestigeKD[ i ].alpha = 0;
		self.prestigeKD[ i ].archived = false;
		self.prestigeKD[ i ] setText(kd[i]);
		self.prestigeKD[ i ] fadeOverTime( 1 );
		self.prestigeKD[ i ].alpha = 1;

		self.prestigeIcon[ i ] = newClientHudElem(self);
		self.prestigeIcon[ i ].horzAlign = "center";
		self.prestigeIcon[ i ].vertAlign = "middle";
		self.prestigeIcon[ i ].alignx = "center";
		self.prestigeIcon[ i ].alignY = "middle";
		self.prestigeIcon[ i ].y = -70 + (i * 35);
		self.prestigeIcon[ i ].x = -40;
		self.prestigeIcon[ i ] setShader( var[i], 28, 28  );
		self.prestigeIcon[ i ].alpha = 0;
		self.prestigeIcon[ i ].archived = false;
		self.prestigeIcon[ i ] fadeOverTime( 1 );
		self.prestigeIcon[ i ].alpha = 1;

		self.prestigeText[ i ] = newClientHudElem(self);
		self.prestigeText[ i ].horzAlign = "center";
		self.prestigeText[ i ].vertAlign = "middle";
		self.prestigeText[ i ].alignX = "left";
		self.prestigeText[ i ].alignY = "middle";
		self.prestigeText[ i ].y = -70 + (i * 35);
		self.prestigeText[ i ].x = 0;
		self.prestigeText[ i ].color = col[i];
		self.prestigeText[ i ].fontScale = 1.6;
		self.prestigeText[ i ].alpha = 0;
		self.prestigeText[ i ].archived = false;
		self.prestigeText[ i ] setText(self volkv\_common::getLangString(var[i]));
		self.prestigeText[ i ] fadeOverTime( 1 );
		self.prestigeText[ i ].alpha = 1;


		wait .2;

	}


	creditText[2] = newClientHudElem(self);
	creditText[2].horzAlign = "center";
	creditText[2].vertAlign = "middle";
	creditText[2].alignX = "center";
	creditText[2].alignY = "middle";
	creditText[2].y = 190;
	creditText[2].x = 0;
	creditText[2] setShader( "ui_slider2", 310, 64 );
	creditText[2].color = (.392,.764,.2);
	creditText[2].alpha = 0;
	creditText[2].archived = false;
	creditText[2] fadeOverTime(1);
	creditText[2].alpha = 1;


	creditText[3] = newClientHudElem(self);
	creditText[3].vertAlign = "middle";
	creditText[3].horzAlign = "center";
	creditText[3].alignX = "center";
	creditText[3].alignY = "middle";
	creditText[3].y = 190;
	creditText[3].x = 0;
	creditText[3] setText("^3CoD4Narod.RU");
	creditText[3].fontScale = 4;
	creditText[3].alpha = 0;
	creditText[3] fadeOverTime(1);
	creditText[3].alpha = 1;

}

credits()
{
	self endon("disconnect");

	creditText[0] = newClientHudElem(self);
	creditText[0].horzAlign = "center";
	creditText[0].vertAlign = "middle";
	creditText[0].alignX = "center";
	creditText[0].alignY = "middle";
	creditText[0].y = -175;
	creditText[0].x = 0;
	creditText[0].fontScale = 4;
	creditText[0].alpha = 0;
	creditText[0].archived = false;
	creditText[0] setText( "^8"+ self.name + " !" );
	creditText[0] fadeOverTime(1);
	creditText[0].alpha = 1;


	wait .1;

	creditText[1] = newClientHudElem(self);
	creditText[1].horzAlign = "center";
	creditText[1].vertAlign = "middle";
	creditText[1].alignX = "center";
	creditText[1].alignY = "middle";
	creditText[1].y = -120;
	creditText[1].x = 0;
	creditText[1].fontScale = 2.2;
	creditText[1].alpha = 0;
	creditText[1].archived = false;
	creditText[1] setText(self volkv\_common::getLangString("CREDIT_1") );

	creditText[1] fadeOverTime(1);
	creditText[1].alpha = 1;


	wait .1;

	creditText[2] = newClientHudElem(self);
	creditText[2].horzAlign = "center";
	creditText[2].vertAlign = "middle";
	creditText[2].alignX = "center";
	creditText[2].alignY = "middle";
	creditText[2].y = -75;
	creditText[2].x = 0;
	creditText[2].fontScale = 2.2;
	creditText[2].alpha = 0;
	creditText[2].archived = false;
	creditText[2] setText( self volkv\_common::getLangString("CREDIT_2") );

	creditText[2] fadeOverTime(1);
	creditText[2].alpha = 1;


	wait .1;

	creditText[3] = newClientHudElem(self);
	creditText[3].horzAlign = "center";
	creditText[3].vertAlign = "middle";
	creditText[3].alignX = "center";
	creditText[3].alignY = "middle";
	creditText[3].y = -25;
	creditText[3].x = 0;
	creditText[3].fontScale = 2.2;
	creditText[3].alpha = 0;
	creditText[3].archived = false;
	creditText[3] setText( self volkv\_common::getLangString("CREDIT_3") );

	creditText[3] fadeOverTime(1);
	creditText[3].alpha = 1;


	wait .1;

	creditText[4] = newClientHudElem(self);
	creditText[4].horzAlign = "center";
	creditText[4].vertAlign = "middle";
	creditText[4].alignX = "center";
	creditText[4].alignY = "middle";
	creditText[4].y = 20;
	creditText[4].x = 0;
	creditText[4].fontScale = 2.2;
	creditText[4].alpha = 0;
	creditText[4].archived = false;
	creditText[4] setText( self volkv\_common::getLangString("CREDIT_4") );

	creditText[4] fadeOverTime(1);
	creditText[4].alpha = 1;

	wait .1;

	creditText[4] = newClientHudElem(self);
	creditText[4].horzAlign = "center";
	creditText[4].vertAlign = "middle";
	creditText[4].alignX = "center";
	creditText[4].alignY = "middle";
	creditText[4].y = 70;
	creditText[4].x = 0;
	creditText[4].fontScale = 2.7;
	creditText[4].alpha = 0;
	creditText[4].archived = false;
	creditText[4] setText( self volkv\_common::getLangString("CREDIT_5") );

	creditText[4] fadeOverTime(1);
	creditText[4].alpha = 1;


	creditText[8] = newClientHudElem(self);
	creditText[8].horzAlign = "center";
	creditText[8].vertAlign = "middle";
	creditText[8].alignX = "center";
	creditText[8].alignY = "middle";
	creditText[8].y = 125;
	creditText[8].x = 0;
	creditText[8] setShader( "ui_slider2", 450, 64 );
	creditText[8].color = (.392,.764,.2);
	creditText[8].alpha = 0;
	creditText[8].archived = false;

	creditText[8] fadeOverTime(1);
	creditText[8].alpha = 1;


	creditText[5] = newClientHudElem(self);
	creditText[5].vertAlign = "middle";
	creditText[5].horzAlign = "center";
	creditText[5].alignX = "center";
	creditText[5].alignY = "middle";
	creditText[5].y = 125;
	creditText[5].x = 0;
	creditText[5] setText("^3CoD4Narod.RU/^2donate");
	creditText[5].fontScale = 4;
	creditText[5].alpha = 0;
	creditText[5] fadeOverTime(1);
	creditText[5].alpha = 1;

	wait 4;

	self playlocalSound("mp_ingame_summary");

	creditText[6] = newClientHudElem(self);
	creditText[6].horzAlign = "right";
	creditText[6].vertAlign = "middle";
	creditText[6].alignX = "right";
	creditText[6].alignY = "middle";
	creditText[6].y = 180;
	creditText[6].x = -200;
	creditText[6].fontScale = 1.8;
	creditText[6].alpha = 0;
	creditText[6].archived = false;
	creditText[6] setText( self volkv\_common::getLangString("CREDIT_6") );

	creditText[6] fadeOverTime(1);
	creditText[6].alpha = 1;

	wait 2;

	self playlocalSound("mp_ingame_summary");
	creditText[7] = newClientHudElem(self);
	creditText[7].horzAlign = "right";
	creditText[7].vertAlign = "middle";
	creditText[7].alignX = "right";
	creditText[7].alignY = "middle";
	creditText[7].y = 180;
	creditText[7].x = -160;
	creditText[7] setShader( "ui_host", 32, 32 );
	creditText[7].alpha = 0;
	creditText[7].archived = false;

	creditText[7] fadeOverTime(1);
	creditText[7].alpha = 1;


}

/*
	Some of this positions and angles are a bit off
	Depending on CoD switch vs if statements performance adjust below code accordingly
	missing: Killhouse, shipment, chinatown
*/

getLoc()
{
	loc = undefined;

	map = getDvar( "mapname" );

	switch (map)
	{
	case "mp_backlot":
		loc = (656.731, 1853.1, 64.125);
		break;
	case "mp_bloc":
		loc = (-655.601, -1547.25, 571.784);
		break;
	case "mp_bog":
		loc = (-4415.65, -15.6626, 52.552);
		break;
	case "mp_cargoship":
		loc = (1838.28, 349.865, 165.437);
		break;
	case "mp_citystreets":
		loc = (5257.22, -151.651, 281.967);
		break;
	case "mp_convoy":
		loc = (4521.64, 3391.34, 109.336);
		break;
	case "mp_countdown":
		loc = (6619.84, -4082.8, 1109.13);
		break;
	case "mp_crash":
	case "mp_crash_snow":
		loc = (2179.16, 29.1966, 95.4196);
		break;
	case "mp_crossfire":
		loc = (3255.58, 305.262, -25.875);
		break;
	case "mp_downpour":
		loc = (-1463.01, -2571.35, 161.825);
		break;
	case "mp_overgrown":
		loc = (-2078.23, -5482.13, -139.344);
		break;
	case "mp_pipeline":
		loc = (2715.33, 3153.56, 291.236);
		break;
	case "mp_showdown":
		loc = (11.0894, 2090.79, -1.875);
		break;
	case "mp_strike":
		loc = (-2894.76, 1397.75, 1.63746);
		break;
	case "mp_vacant":
		loc = (2583.85, -136.047, -91.875);
		break;
	default:
		loc = loc;
		break;
	}

	return loc;
}

getAng()
{
	ang = undefined;

	map = getDvar( "mapname" );

	switch (map)
	{
	case "mp_backlot":
		ang = (0, 34.8267, 0);
		break;
	case "mp_bloc":
		ang = (0, -72.9053, 0);
		break;
	case "mp_bog":
		ang = (0, -144.456, 0);
		break;
	case "mp_cargoship":
		ang = (0, -22.8978, 0);
		break;
	case "mp_citystreets":
		ang = (0, -133.577, 0);
		break;
	case "mp_convoy":
		ang = (0, -127.947, 0);
		break;
	case "mp_countdown":
		ang = (0, 144.69, 0);
		break;
	case "mp_crash":
	case "mp_crash_snow":
		ang = (0, -1.57104, 0);
		break;
	case "mp_crossfire":
		ang = (0, 90.3735, 0);
		break;
	case "mp_downpour":
		ang = (0, -145.764, 0);
		break;
	case "mp_overgrown":
		ang = (0, -79.0173, 0);
		break;
	case "mp_pipeline":
		ang = (0, 55.7287, 0);
		break;
	case "mp_showdown":
		ang = (0, 90.4779, 0);
		break;
	case "mp_strike":
		ang = (0, -1.1261, 0);
		break;
	case "mp_vacant":
		ang = (0, 179.654, 0);
		break;
	default:
		ang = ang;
		break;
	}

	return ang;
}

Blur() {

	self endon("disconnect");

	for (i=0;i<14;i++) {
		self setClientDvar("r_blur", i / 2);
		wait .05;
	}

}

