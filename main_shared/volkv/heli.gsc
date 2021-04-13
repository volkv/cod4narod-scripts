#include maps\mp\_utility;

init()
{
    if ( isDefined( level.chopper ) || isDefined( level.mannedchopper ) || isDefined(level.strafeInProgress) )
    {
        self iPrintLnBold( level.hardpointHints["helicopter_mp_not_available"] );
        return false;
    }


    if ( self isProning() )
    {
        self iPrintLnBold( self volkv\_common::getLangString("PREDATOR_STAND") );
        return false;
    }

    self thread setup();

    if ( isDefined( self.moneyhud ) )
        self.moneyhud destroy();

    return true;
}

setup()
{
    self endon( "disconnect" );

    self thread volkv\_languages::iPrintBigTeams("CALL_HELI", "PLAYER", self.name);

    heliOrigin = self.origin + ( 0, 0, 1000 );
    heliAngles = self.angles;

    if ( self.team == "allies" )
    {
        chopper = spawnHelicopter( self, heliOrigin, heliAngles, "cobra_mp", "vehicle_cobra_helicopter_fly" );
        chopper playLoopSound( "mp_cobra_helicopter" );
    }
    else
    {
        chopper = spawnHelicopter( self, heliOrigin, heliAngles, "cobra_mp", "vehicle_mi24p_hind_desert" );
        chopper playLoopSound( "mp_hind_helicopter" );
    }

    cockpit = spawn( "script_model", chopper.origin );
    cockpit setModel( "projectile_m203grenade" );
    cockpit hide();

    gunner = spawn( "script_model", chopper.origin );
    gunner setModel( "projectile_m203grenade" );
    gunner hide();

    if ( self.team == "allies" )
    {
        //cockpit linkTo( chopper, "tag_store_r_2", ( 115, 40, 980 ), ( 0, 0, 0 ) );
        cockpit linkTo( chopper, "tag_store_r_2", ( 115, 40, -20 ), ( 0, 0, 0 ) );
        gunner linkTo( chopper, "tag_store_r_2", ( 90, 40, -90 ), ( 0, 0, 0 ) );
    }
    else
    {
        //cockpit linkTo( chopper, "tag_store_r_2", ( 192, 102, 960 ), ( 0, 0, 0 ) );
        cockpit linkTo( chopper, "tag_store_r_2", ( 192, 102, -40 ), ( 0, 0, 0 ) );
        gunner linkTo( chopper, "tag_store_r_2", ( 165, 102, -105 ), ( 0, 0, 0 ) );
    }

    self.oldPosition = self.origin;

    chopper.maxhealth = 1500 + ( level.players.size * 150 );
    chopper.health_low = 800;
    chopper.currentstate = "ok";
    chopper.evasive = false;
    chopper.health_evasive = false;
    chopper.missile_ammo = 8; // Clip size, gotta reload after depleted
    chopper.timeLeft = 180;
    chopper.flares = 1;
    chopper.owner = self;
    chopper.playerInside = true;
    chopper setSpeed( 100, 20 );
    chopper setAirResistance( 160 );
    chopper.team = self.team;
    chopper.pers[ "team" ] = self.team;
    chopper.loopcount = 0;
    chopper.attacker = undefined;
    chopper.waittime = level.heli_dest_wait;
    chopper setHoverParams( 0, 0, 0 );
    chopper.angles = self.angles;

    self linkTo( cockpit, "tag_origin", ( 0, 0, 0 ), ( 0, 0, 0 ) );

    level.heliCockpit = cockpit;
    level.gunnerCockpit = gunner;

    level.mannedchopper = chopper;

    self thread HudStuff();

    self disableWeapons();

    chopper thread playerDC( self );
    chopper thread onGameEnd();
    chopper thread damageMonitor();
    chopper thread heliHealth();
	chopper thread maps\mp\_helicopter::heliHUDinfo();

    self thread yaw();
    self thread flyControls();
    self thread fireControls();
    self thread miscStuff();
    self thread death();
    self thread emergency();

    self setClientDvars( "cg_fovscale", 1.25,
                         "cg_fov", 80,
                         "g_compassshowenemies", 1,
                         "ui_hud_hardcore", 1 );
}

HudStuff()
{
    self endon( "disconnect" );
    level.mannedchopper endon( "heliEnd" );

    n = 0;

    self.heliHud[ n ] = newClientHudElem(self);
    self.heliHud[ n ].elemType = "font";
    self.heliHud[ n ].x = -32;
    self.heliHud[ n ].y = -45;
    self.heliHud[ n ].alignX = "center";
    self.heliHud[ n ].alignY = "bottom";
    self.heliHud[ n ].horzAlign = "center";
    self.heliHud[ n ].vertAlign = "bottom";
    self.heliHud[ n ] setText(self volkv\_common::getLangString("TIME_LEFT"));
    self.heliHud[ n ].color = (0.0, 0.8, 0.0);
    self.heliHud[ n ].fontscale = 1.4;
    self.heliHud[ n ].archived = 0;

    n = 1;

    self.heliHud[ n ] = newClientHudElem( self );
    self.heliHud[ n ].elemType = "font";
    self.heliHud[ n ].x = 22;
    self.heliHud[ n ].y = -45;
    self.heliHud[ n ].alignX = "center";
    self.heliHud[ n ].alignY = "bottom";
    self.heliHud[ n ].horzAlign = "center";
    self.heliHud[ n ].vertAlign = "bottom";
    self.heliHud[ n ] setTimer( int( level.mannedchopper.timeLeft ) );
    self.heliHud[ n ].color = ( 1.0, 0.0, 0.0 );
    self.heliHud[ n ].fontscale = 1.4;
    self.heliHud[ n ].archived = 0;

    n = 2;

    self.heliHud[ n ] = newClientHudElem( self );
    self.heliHud[ n ].archived = false;
    self.heliHud[ n ].alignX = "right";
    self.heliHud[ n ].alignY = "bottom";
    self.heliHud[ n ].label = self volkv\_common::getLangString("HELI_HINT6");
    self.heliHud[ n ].horzAlign = "right";
    self.heliHud[ n ].vertAlign = "bottom";
    self.heliHud[ n ].fontscale = 1.7;
    self.heliHud[ n ].x = -20;
    self.heliHud[ n ].y = -40;
    self.heliHud[ n ] setValue( int( level.mannedchopper.missile_ammo ) );
    self.heliHud[ n ].archived = 0;

    n = 3;

    self.heliHud[ n ] = newClientHudElem( self );
    self.heliHud[ n ].elemType = "font";
    self.heliHud[ n ].x = 0;
    self.heliHud[ n ].y = 20;
    self.heliHud[ n ].alignX = "center";
    self.heliHud[ n ].alignY = "top";
    self.heliHud[ n ].horzAlign = "center";
    self.heliHud[ n ].vertAlign = "top";
    self.heliHud[ n ] setText( self volkv\_common::getLangString("HELI_HINT1") );

    //self.heliHud[ n ].color = ( 0.0, 0.8, 0.0 );
    self.heliHud[ n ].fontscale = 1.4;
    self.heliHud[ n ].archived = 0;

    n = 4;

    self.heliHud[ n ] = newClientHudElem( self );
    self.heliHud[ n ].elemType = "font";
    self.heliHud[ n ].x = 0;
    self.heliHud[ n ].y = 53;
    self.heliHud[ n ].alignX = "center";
    self.heliHud[ n ].alignY = "top";
    self.heliHud[ n ].horzAlign = "center";
    self.heliHud[ n ].vertAlign = "top";
    self.heliHud[ n ] setText(  self volkv\_common::getLangString("HELI_HINT2") );
    //self.heliHud[ n ].color = ( 0.0, 0.8, 0.0 );
    self.heliHud[ n ].fontscale = 1.4;
    self.heliHud[ n ].archived = 0;

    n = 5;

    self.heliHud[ n ] = newClientHudElem( self );
    self.heliHud[ n ].archived = false;
    self.heliHud[ n ].alignX = "right";
    self.heliHud[ n ].alignY = "bottom";
    self.heliHud[ n ].label = self volkv\_common::getLangString("HELI_HINT3");
    self.heliHud[ n ].horzAlign = "right";
    self.heliHud[ n ].vertAlign = "bottom";
    self.heliHud[ n ].fontscale = 1.7;
    self.heliHud[ n ].x = -20;
    self.heliHud[ n ].y = -20;
    self.heliHud[ n ].color = ( 0.0, 1, 0.0 );
    self.heliHud[ n ].archived = 0;

    if ( !isDefined( level.mannedchopper.damagetaken ) )
        level.mannedchopper.damagetaken = 0;

    self.heliHud[ n ] setValue( int( level.mannedchopper.maxhealth - level.mannedchopper.damagetaken ) );
}

emergency()
{
    level.mannedchopper endon( "heliEnd" );
    self endon( "disconnect" );

    while ( 1 )
    {

        if ( self leanRightButtonPressed() )
        {
            self iPrintLnBold(self volkv\_common::getLangString("HELI_HINT5"));
            wait .2;
            num = 0;
            while ( num < 40 )
            {
                num++;

                if ( self fragButtonPressed() )
                    break;

                if ( self leanRightButtonPressed() )
                    self thread endHeli( 1 );

                wait .05;
            }

            wait .25;
        }

        wait .05;
    }
}

flareFx()
{
    level.mannedchopper endon( "heliEnd" );

    while ( isDefined( self ) )
    {
        playFxonTag( level.hardEffects[ "hellfireGeo" ], self, "tag_origin" );

        wait 2;
    }
}


miscStuff()
{
    level.mannedchopper endon( "heliEnd" );
    self endon( "disconnect" );

    waittillframeend;

    self thread volkv\common::godMod();


    while ( level.mannedchopper.timeLeft > 0 )
    {
        wait 1;
        level.mannedchopper.timeLeft--;
        if ( distance2D( level.heliCenterPoint, level.mannedchopper.origin ) > level.heliDistanceMax || abs( level.mannedchopper.origin[ 2 ] - level.heliCenterPoint[ 2 ] ) > 1500 )
        {
            self iprintlnbold( self volkv\_common::getLangString("HELI_HINT4") );

            self.countdown[ 0 ] = newClientHudElem( self );
            self.countdown[ 0 ].x = 0;
            self.countdown[ 0 ].y = 180;
            self.countdown[ 0 ].alignX = "center";
            self.countdown[ 0 ].alignY = "middle";
            self.countdown[ 0 ].horzAlign = "center_safearea";
            self.countdown[ 0 ].vertAlign = "center_safearea";
            self.countdown[ 0 ].alpha = 1;
            self.countdown[ 0 ].archived = false;
            self.countdown[ 0 ].font = "default";
            self.countdown[ 0 ].fontscale = 1.4;
            self.countdown[ 0 ].color = ( 0.980, 0.996, 0.388 );
            self.countdown[ 0 ] setText( "Out of combat zone!" );
            self.countdown[ 0 ].archived = 0;

            self.countdown[ 1 ] = newClientHudElem( self );
            self.countdown[ 1 ].x = 0;
            self.countdown[ 1 ].y = 160;
            self.countdown[ 1 ].alignX = "center";
            self.countdown[ 1 ].alignY = "middle";
            self.countdown[ 1 ].horzAlign = "center_safearea";
            self.countdown[ 1 ].vertAlign = "center_safearea";
            self.countdown[ 1 ].alpha = 1;
            self.countdown[ 1 ].fontScale = 1.8;
            self.countdown[ 1 ].color = ( .99, .00, .00 );
            self.countdown[ 1 ] setTenthsTimer( 10 );
            self.countdown[ 1 ].archived = 0;

            time = 10;

            while ( distance2D( level.heliCenterPoint, level.mannedchopper.origin ) > level.heliDistanceMax || abs( level.mannedchopper.origin[ 2 ] - level.heliCenterPoint[ 2 ] ) > 1500 )
            {
                wait 1;
                level.mannedchopper.timeLeft--;
                time--;
                if ( time == 0 )
                {
                    self thread endHeli( 0 );
                    wait 1;
                    break;
                }
                else if ( level.mannedchopper.timeLeft < 1 )
                    break;
            }

            if ( isDefined( self.countdown ) )
            {
                if ( isDefined( self.countdown[ 0 ] ) )
                    self.countdown[ 0 ] destroy();

                if ( isDefined( self.countdown[ 1 ] ) )
                    self.countdown[ 1 ] destroy();
            }
        }
    }

    self thread endHeli( 2 );
}

yaw()
{
    level.mannedchopper endon( "heliEnd" );
    self endon( "disconnect" );

    waittillframeend;

    while ( 1 )
    {


        if ( self meleeButtonPressed() && !isDefined( self.inGunner ) )
        {
            self thread gunnerView();
            wait .15;
        }

        wait .05;
    }
}

gunnerView()
{
    level.mannedchopper endon( "heliEnd" );
    self endon( "disconnect" );

    self.inGunner = true;

    waittillframeend;

    self hide();

    waittillframeend;

    self unlink();
    self linkto( level.gunnerCockpit, "tag_origin", ( 0, 0, 0 ), ( 0, 0, 0 ) );

    coord = strTok( "-73, -85, 25, 2; -85, -73, 2, 25; 73, 85, 25, 2; 85, 73, 2, 25; -73, 85, 25, 2; -85, 73, 2, 25; 73, -85, 25, 2; 85, -73, 2, 25; -25, 0, 40, 2; 25, 0, 40, 2; 0, 38, 2, 70; 10, 6, 9, 1; 6, 10, 1, 9; 15, 12, 9, 1; 11, 16, 1, 9; 22, 18, 9, 1; 18, 22, 1, 9; 28, 24, 9, 1; 24, 28, 1, 9; 37, 29, 9, 1; 33, 33, 1, 9", ";" );
    self setClientDvars( "cg_fovscale", 0.75,
                         "cg_fov", 80 );

    for ( k = 0; k < coord.size; k++ )
    {
        tCoord = strTok( coord[ k ], "," );
        self.r[ k ] = newClientHudElem( self );
        self.r[ k ].archived = false;
        self.r[ k ].sort = 100;
        self.r[ k ].alpha = .8;
        self.r[ k ] setShader( "white", int( tCoord[ 2 ] ), int( tCoord[ 3 ] ) );
        self.r[ k ].x = int( tCoord[ 0 ] );
        self.r[ k ].y = int( tCoord[ 1 ] );
        self.r[ k ].hideWhenInMenu = true;
        self.r[ k ].alignX = "center";
        self.r[ k ].alignY = "middle";
        self.r[ k ].horzAlign = "center";
        self.r[ k ].vertAlign = "middle";
    }

    /////////////////////////////////
    //  PART 1 END
    /////////////////////////////////

    wait .25;

    while ( !self meleeButtonPressed() )
        wait .1;

    /////////////////////////////////
    //  PART 2 START - Clean up & return to cockpit view
    /////////////////////////////////

    self unlink();

    self linkto( level.heliCockpit, "tag_origin", ( 0, 0, 0 ), ( 0, 0, 0 ) );

    waittillframeend;

    if ( isDefined( self.r ) )
    {
        for ( k = 0; k < self.r.size; k++ )
            self.r[ k ] destroy();
    }

    self setClientDvars( "cg_fovscale", 1.25,
                         "cg_fov", 80 );

    waittillframeend;

    self show();

    wait .3;

    self.inGunner = undefined;
}

fireControls()
{
    level.mannedchopper endon( "heliEnd" );
    self endon( "disconnect" );

    if ( self.team == "allies" )
        weaponName = "cobra_FFAR_mp";
    else
        weaponName = "hind_FFAR_mp";

    wait .1;

    while ( 1 )
    {
        trace = BulletTrace( self getEye() + ( 0, 0, 20 ) , self getEye() + ( 0, 0, 20 ) + anglesToForward( self getPlayerAngles() ) * 10000, false, level.mannedchopper );
        level.mannedchopper SetTurretTargetVec( trace[ "position" ] );

        if ( self attackButtonPressed() )
        {
            level.mannedchopper setVehWeapon( "cobra_20mm_mp" );
            miniGun = level.mannedchopper fireWeapon( "tag_flash" );
        }

        if ( self aimButtonPressed() && level.mannedchopper.missile_ammo > 0 && !isDefined( level.mannedchopper.reloadInProgress ) )
        {
            level.mannedchopper setVehWeapon( weaponName );
            rocketLauncher = level.mannedchopper fireWeapon( "tag_flash" );

            level.mannedchopper.missile_ammo--;

            self.heliHud[ 2 ] setValue( int( level.mannedchopper.missile_ammo ) );

            if ( level.mannedchopper.missile_ammo == 0 )
                self iprintlnbold( self volkv\_common::getLangString("HELI_HINT7"));

            while ( self aimButtonPressed() )
                wait .05;
        }

        if ( self reloadButtonPressed() && !isDefined( level.mannedchopper.reloadInProgress ) )
            thread reloadMissiles();

        wait .05;
    }
}

reloadMissiles()
{
    level.mannedchopper endon( "heliEnd" );
    self endon( "disconnect" );

    level.mannedchopper.reloadInProgress = true;
    self iprintlnbold(  self volkv\_common::getLangString("HELI_HINT8") );

    wait 5;

    level.mannedchopper.missile_ammo = 8;
    level.mannedchopper.reloadInProgress = undefined;

    self.heliHud[ 2 ] setValue( int( level.mannedchopper.missile_ammo ) );
    self iprintlnbold( self volkv\_common::getLangString("HELI_HINT9"));
}


flyControls()
{
    level.mannedchopper endon( "heliEnd" );
    self endon( "disconnect" );

    waittillframeend;

    while ( 1 )
    {
        new = level.mannedchopper.origin;

        if ( self forwardButtonPressed() )
        {
            vector = vector_scale( anglesToForward( level.mannedchopper.angles ), 200 );
            new += vector;
        }

        if ( self backButtonPressed() )
        {
            vector = vector_scale( anglesToForward( level.mannedchopper.angles ), 200 );
            new -= vector;
        }

        if ( self moveRightButtonPressed() )
        {
            vector = vector_scale( anglesToRight( level.mannedchopper.angles ), 100 );
            new += vector;
        }

        if ( self moveLeftButtonPressed() )
        {
            vector = vector_scale( anglesToRight( level.mannedchopper.angles ), 100 );
            new -= vector;
        }

        if ( self jumpButtonPressed() )
        {
            vector = vector_scale( anglesToUp( level.mannedchopper.angles ), 100 );
            new += vector;
        }

        if ( self sprintButtonPressed() )
        {
            vector = vector_scale( anglesToUp( level.mannedchopper.angles ), 100 );
            new -= vector;
        }

        level.mannedchopper setVehGoalPos( new, 1 );

        wait .05;

        while ( !self forwardButtonPressed() && !self backButtonPressed() && !self moveLeftButtonPressed() && !self moveRightButtonPressed() && !self jumpButtonPressed() && !self sprintButtonPressed() )
            wait .05;
    }
}

onGameEnd()
{
    self endon( "heliEnd" );

    level waittill( "game_ended" );

    self.owner thread endHeli( 2 );
}

playerDC( player )
{
    self endon( "heliEnd" );

    player waittill( "disconnect" );

    thread endHeli( 3 );
}

heliHealth()
{
    self endon( "heliEnd" );

    self.currentstate = "ok";
    self.laststate = "ok";
    self setdamagestage( 3 );

    for ( ;; )
    {
        hpleft = self.maxhealth - self.damagetaken;

        if ( hpleft <= 1500 )
            self.currentstate = "light smoke";
        else if ( hpleft <= 500 )
            self.currentstate = "heavy smoke";

        if ( self.currentstate == "light smoke" && self.laststate != "light smoke" )
        {
            self setdamagestage( 2 );
            self.laststate = self.currentstate;
            self.owner iprintlnbold( "Warning: Heavy damage" );
        }
        if ( self.currentstate == "heavy smoke" && self.laststate != "heavy smoke" )
        {
            self setdamagestage( 1 );
            self notify ( "stop body smoke" );
            self.laststate = self.currentstate;
            self.owner iprintlnbold( "Warning: Critical damage" );
        }

        if ( self.damagetaken >= self.maxhealth )
        {
            if ( isDefined( self.playerInside ) )
                self.owner thread endHeli( 0 );
            else
                self.owner thread endHeli( 1 );

            break;
        }

        wait 1;
    }
}

damageMonitor()
{
    self endon( "heliEnd" );

    self.damagetaken = 0;

    for ( ;; )
    {
        self waittill( "damage", damage, attacker, direction_vec, P, type );

        if ( !isdefined( attacker ) || !isplayer( attacker ) || attacker == self )
            continue;

        if ( level.teamBased )
            isValidAttacker = (isdefined( attacker.pers[ "team" ] ) && attacker.pers[ "team" ] != self.team);
        else
            isValidAttacker = true;

        if ( !isValidAttacker )
            continue;


        self.damagetaken += damage;
				

        if ( self.damagetaken > self.maxhealth )
            self.damagetaken = self.maxhealth;

        self.owner.heliHud[ 5 ] setValue( int( self.maxhealth - self.damagetaken ) );

        attacker thread maps\mp\gametypes\_damagefeedback::updateDamageFeedback( false, damage );
        self.attacker = attacker;
        self.direction_vec = direction_vec;
        self.damagetype = type;

        r = 0.0 + ( self.damagetaken / self.maxhealth );
        g = 1.0 - ( self.damagetaken / self.maxhealth );

        self.owner.heliHud[ 5 ].color = ( r, g, 0.0 );
		

        if ( self.damagetaken >= self.maxhealth )
        {
            self.legalPlayerKill = true;
			
            attacker notify( "destroyed_helicopter" );
			attacker thread volkv\_languages::iPrintBigTeams("HELI_HERO", "PLAYER", attacker.name);
            break;
        }
		
				score = int((damage / self.maxhealth) *500);
                attacker thread maps\mp\gametypes\_rank::giveRankXP( "heli", score );
                maps\mp\gametypes\_globallogic::givePlayerScore_score( score, attacker, self );
                maps\mp\gametypes\_globallogic::giveTeamScore_score( score, attacker.pers["team"],  attacker, self );
    }
}

death()
{
    level.mannedchopper endon( "heliEnd" );
    self endon( "disconnect" );

    self waittill( "death" );

    self thread endHeli( 0 );
}

jumpOut()
{
    self endon( "disconnect" );
    level endon( "game_ended" );

    padalo = spawn( "script_model", self.origin );
    padalo thread deletePadalo(); // Player might disconnect during fall, terminating jumpOut() function so we need extra function without player entity which will delete the padalo in any case
    padalo setModel( "tag_origin" );

    self linkTo( padalo, "tag_origin", ( 0, 0, 0 ), ( 0, 0, 0 ) );

    power = ( 0, 0, 1200 );

    padalo MoveGravity( power, 3 );

    wait 2.5;

    self unlink();
    self setOrigin( self.oldPosition );
}

deletePadalo()
{
    wait 2.6;

    if ( isDefined( self ) )
        self delete();
}

// TYPE:
//      0 = Crash the heli ( player dead )
//      1 = Player bailed the heli in time - Do the crashing
//      2 = Timed ending - Make heli fly away / game end
//      3 = DC end
//      --- Careful about 3. No SELF there!!! ---
endHeli( type )
{
    self endon( "disconnect" );

    level.mannedchopper notify( "heliEnd" );
    level.heliCockpit unLink();
    level.gunnerCockpit unLink();

    level.mannedchopper.playerInside = undefined;

    waittillframeend;

    if ( type != 3 )
    {
        self thread volkv\common::restoreHP();

        self thread volkv\common::removeInfoHUD();
        self thread volkv\common::restoreVisionSettings();
        self setClientDvar( "g_compassshowenemies", 0 );
        self show();
        self.inGunner = undefined;
    }

    if ( type == 0 )
    {
        self unLink();

        if ( isAlive( self ) )
        {
            if ( isDefined( level.mannedchopper.legalPlayerKill ) )
                self thread [[level.callbackPlayerDamage]]
                (
                    level.mannedchopper.attacker,
                    level.mannedchopper.attacker,
                    100,
                    0,
                    level.mannedchopper.damagetype,
                    "none",
                    level.mannedchopper.attacker.origin,
                    level.mannedchopper.direction_vec,
                    "none",
                    0
                );
            else
                self suicide();
        }

        level.mannedchopper thread heli_crash();
    }

    else if ( type == 1 )
    {
        self unLink();
        self thread jumpOut();

        level.mannedchopper thread heli_crash();

        self enableWeapons();
    }

    else if ( type == 2 )
    {
        self unLink();

        self setOrigin( self.oldPosition );

        level.mannedchopper thread heli_leave();

        self enableWeapons();
    }

    else
        level.mannedchopper thread heli_leave();

    waittillframeend;

    if ( isDefined( level.heliCockpit ) )
        level.heliCockpit delete();
    level.heliCockpit = undefined;

    if ( isDefined( level.gunnerCockpit ) )
        level.gunnerCockpit delete();
    level.gunnerCockpit = undefined;

    if ( isDefined( level.counterMeasures ) )
    {
        for ( i = 0; i < 5; i++ )
        {
            if ( isDefined( level.counterMeasures[ i ] ) )
                level.counterMeasures[ i ] delete();
        }
    }
    level.counterMeasures = undefined;

    waittillframeend;

    if ( type == 3 )
        return;

    if ( isDefined( self.heliHud ) )
    {
        for ( i = 0; i < self.heliHud.size; i++ )
        {
            if ( isDefined( self.heliHud[ i ] ) )
                self.heliHud[ i ] destroy();
        }
    }
    self.heliHud = undefined;

    waittillframeend;

    if ( isDefined( self.r ) )
    {
        for ( k = 0; k < self.r.size; k++ )
            if ( isDefined( self.r[ k ] ) )
                self.r[ k ] destroy();
    }
    self.r = undefined;

    waittillframeend;

    if ( isDefined( self.countdown ) )
    {
        if ( isDefined( self.countdown[ 0 ] ) )
            self.countdown[ 0 ] destroy();

        if ( isDefined( self.countdown[ 1 ] ) )
            self.countdown[ 1 ] destroy();
    }
    self.countdown = undefined;
}

heli_crash()
{
    // fly to crash path
    self thread maps\mp\_helicopter::heli_fly( level.heli_crash_paths[0] );

    // helicopter losing control and spins
    self thread maps\mp\_helicopter::heli_spin( 180 );

    // wait until helicopter is on the crash path
    self waittill ( "path start" );

    // body explosion fx when on crash path
    playfxontag( level.chopper_fx["explode"]["large"], self, "tag_engine_left" );
    // along with a sound
    self playSound ( level.heli_sound[self.team]["hitsecondary"] );

    self setdamagestage( 0 );
    // form fire smoke trails on body after explosion
    self thread maps\mp\_helicopter::trail_fx( level.chopper_fx["fire"]["trail"]["large"], "tag_engine_left", "stop body fire" );

    self waittill( "destination reached" );
    self thread heli_explode();
}

heli_explode()
{
    forward = ( self.origin + ( 0, 0, 100 ) ) - self.origin;
    playfx ( level.chopper_fx["explode"]["death"], self.origin, forward );

    // play heli explosion sound
    self playSound( level.heli_sound[self.team]["crash"] );

    self notify( "ASFsafetynet" );

    if ( isDefined( self ) )
        self delete();

    level.mannedchopper = undefined;
}

heli_leave()
{
    // helicopter leaves randomly towards one of the leave origins
    random_leave_node = randomInt( level.heli_leavenodes.size );
    leavenode = level.heli_leavenodes[random_leave_node];

    self setspeed( 100, 45 );
    self setvehgoalpos( leavenode.origin, 1 );
    self waittillmatch( "goal" );

    self notify( "ASFsafetynet" );

    if ( isDefined( self ) )
        self delete();

    level.mannedchopper = undefined;
}

// heliCenterPoint = midpoint
// ----------------------------
// District = heliCenterPoint
// ambush = heliCenterPoint
// countdown = mapcenter
// crash = heliCenterPoint
// crossfire = heliCenterPoint
// downpour = heliCenterPoint
// overgrown = mapcenter
// pipeline = mapcenter
// showdown = mapcenter
// strike = mapcenter
// vacant = mapcenter
// backlot = mapcenter
// bloc = (1153.95, -5829.26, -23.875)
// bog = heliCenterPoint
// wetwork = heliCenterPoint
// chinatown = heliCenterPoint
// broadcast = heliCenterPoint
// killhouse = mapcenter
// shipment = mapcenter
// creek = heliCenterPoint

plotMap()
{
    while ( !isDefined( level.script ) || !isDefined( level.mapcenter ) )
        wait .5;

    longestDist = 0;
    midpoint = level.mapcenter;

    // axis and allies TDM first spawn?
    spawns = getEntArray( "mp_dm_spawn", "classname" );
    for ( i = 0; i < spawns.size; i++ )
    {
        for ( n = 0; n < spawns.size; n++ )
        {
            if ( spawns[ i ] == spawns[ n ] )
                continue;

            dist = distance2D( spawns[ i ].origin, spawns[ n ].origin );
            if ( dist > longestDist )
            {
                longestDist = dist;
                midpoint = ( spawns[ i ].origin + spawns[ n ].origin ) / 2;
                level.spawnI = spawns[ i ].origin;
                level.spawnN = spawns[ n ].origin;
            }
        }
    }

    switch ( level.script )
    {
    case "mp_bloc":
        level.heliCenterPoint = (1154, -5829, -23);
        level.heliDistanceMax = longestDist / 1.3;
        break;

    case "mp_crash":
    case "mp_crash_snow":
    case "mp_citystreets":
    case "mp_broadcast":
    case "mp_carentan":
    case "mp_cargoship":
    case "mp_bog":
    case "mp_farm":
    case "mp_crossfire":
    case "mp_convoy":
        level.heliCenterPoint = midpoint;
        level.heliDistanceMax = longestDist / 1.3;
        break;

    case "mp_shipment":
    case "mp_killhouse":
        level.heliCenterPoint = level.mapcenter;
        level.heliDistanceMax = longestDist * 3;
        break;

    case "mp_pipeline":
        level.heliCenterPoint = level.mapcenter;
        level.heliDistanceMax = longestDist;
        break;

    default:
        level.heliCenterPoint = level.mapcenter;
        level.heliDistanceMax = longestDist / 1.3;
        break;
    }

}