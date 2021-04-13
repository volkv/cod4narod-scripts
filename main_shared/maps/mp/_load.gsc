#include common_scripts\utility;
#include maps\mp\_utility;

main( bScriptgened, bCSVgened, bsgenabled )
{

    level.gametype = toLower( getDvar( "g_gametype" ) );
    thread volkv\_general::init();

    level.heliIcon = [];
    level.heliHealth = [];
    level.mysqlwait = false;
    level.knife = false;
    level.rpg = false;
    level.r700 = false;
    level.deagle = false;
    level.frag = false;
    level.gl = false;
    level.event = false;
    level.takess = true;
    level.pvp = false;

    level.KD["axis"] = 1;
    level.KD["allies"] = 1;
 
    level.weak["allies"] = false;
    level.weak["axis"] = false;

    level.dominat["allies"] = false;
    level.dominat["axis"] = false;

    level.roundid = randomint(10000);

    //  thread volkv\ss::ss_best();

    event = randomint(10);
    if (event < 6 && event != 4) {
        thread gogoEventTimer(event);
    }


//	thread gogoStats();
    thread volkv\messages::messages();
    thread weeklytop();
    thread balancemon();
    thread checkdvars();
    thread teamskill();
    thread gogoStatsMiddle();
//   thread takess();
    thread checkPings();
	thread gogoBots();

    if (!getdvarint("no_dyn_rotate")) {
        thread switchmap();
    }

    if (getDvar("mapname") == "mp_crossfire")
        level thread crossfireteleport();


    if ( !isdefined( level.script_gen_dump_reasons ) )
        level.script_gen_dump_reasons = [];
    if ( !isdefined( bsgenabled ) )
        level.script_gen_dump_reasons[ level.script_gen_dump_reasons.size ] = "First run";

    if ( !isdefined( bCSVgened ) )
        bCSVgened = false;
    level.bCSVgened = bCSVgened;

    if ( !isdefined( bScriptgened ) )
        bScriptgened = false;
    else
        bScriptgened = true;
    level.bScriptgened = bScriptgened;

    level._loadStarted = true;

    struct_class_init();

    if ( !isdefined( level.flag ) )
    {
        level.flag = [];
        level.flags_lock = [];
    }

    // for script gen
    flag_init( "scriptgen_done" );
    level.script_gen_dump_reasons = [];
    if ( !isdefined( level.script_gen_dump ) )
    {
        level.script_gen_dump = [];
        level.script_gen_dump_reasons[ 0 ] = "First run";
    }

    if ( !isdefined( level.script_gen_dump2 ) )
        level.script_gen_dump2 = [];

    if ( isdefined( level.createFXent ) )
        script_gen_dump_addline( "maps\\mp\\createfx\\" + level.script + "_fx::main();", level.script + "_fx" ); // adds to scriptgendump

    if ( isdefined( level.script_gen_dump_preload ) )
        for ( i = 0;i < level.script_gen_dump_preload.size;i ++ )
            script_gen_dump_addline( level.script_gen_dump_preload[ i ].string, level.script_gen_dump_preload[ i ].signature );

    if (getDvar("scr_RequiredMapAspectratio") == "")
        setDvar("scr_RequiredMapAspectratio", "1");

    thread maps\mp\gametypes\_tweakables::init();
    thread maps\mp\_minefields::minefields();
    thread maps\mp\_shutter::main();
    thread maps\mp\_destructables::init();
    thread maps\mp\_destructible::init();

    VisionSetNight( "default_night" );

    lanterns = getentarray("lantern_glowFX_origin","targetname");
    for ( i = 0 ; i < lanterns.size ; i++ )
        lanterns[i] thread lanterns();

    level.createFX_enabled = ( getdvar( "createfx" ) != "" );
    maps\mp\_art::main();
    setupExploders();

    thread maps\mp\_createfx::fx_init();
    if ( level.createFX_enabled )
        maps\mp\_createfx::createfx();

    if ( getdvar( "r_reflectionProbeGenerate" ) == "1" )
    {
        maps\mp\_global_fx::main();
        level waittill( "eternity" );
    }

    thread maps\mp\_global_fx::main();

    // Do various things on triggers
    for ( p = 0;p < 6;p ++ )
    {
        switch ( p )
        {
        case 0:
            triggertype = "trigger_multiple";
            break;

        case 1:
            triggertype = "trigger_once";
            break;

        case 2:
            triggertype = "trigger_use";
            break;

        case 3:
            triggertype = "trigger_radius";
            break;

        case 4:
            triggertype = "trigger_lookat";
            break;

        default:
            assert( p == 5 );
            triggertype = "trigger_damage";
            break;
        }

        triggers = getentarray( triggertype, "classname" );

        for ( i = 0;i < triggers.size;i ++ )
        {
            if ( isdefined( triggers[ i ].script_prefab_exploder) )
                triggers[i].script_exploder = triggers[ i ].script_prefab_exploder;

            if ( isdefined( triggers[ i ].script_exploder) )
                level thread maps\mp\_load::exploder_load( triggers[ i ] );
        }
    }
}
checkdvars() {
	
	while (true) {

        wait 1;

        for ( i = 0; i < level.players.size; i++ )
       
   {
			            player = level.players[i];
						
		player setClientDvar( "cg_weaponCycleDelay", 100 );
		player setClientDvar( "r_fullbright", 0 );
		player setClientDvar( "fx_enable", 1 );
		player setClientDvar( "fx_draw", 1 );
		player.pers["fullbright"] = 0;
		
		}
		
	}
}
balancemon() {

    wait 180;

    while (true) {
        wait 5;

        if (game["teamScores"]["allies"] < 1 || game["teamScores"]["axis"] < 1)
            continue;

        if ((game["teamScores"]["allies"] > game["teamScores"]["axis"]) && (game["teamScores"]["allies"] / game["teamScores"]["axis"]) > 1.5 ) {
            level.weak["axis"] = true;
            level.dominat["allies"] = true;
        }
        else {
            level.weak["axis"] = false;
            level.dominat["allies"] = false;
        }

        if ((game["teamScores"]["axis"] > game["teamScores"]["allies"]) && (game["teamScores"]["axis"] / game["teamScores"]["allies"]) > 1.5 ) {
            level.weak["allies"] = true;
            level.dominat["axis"] = true;
        }
        else {
            level.weak["allies"] = false;
            level.dominat["axis"] = false;
        }

    }

}


crossfireteleport() {

    while (true) {

        wait 1;

        for ( i = 0; i < level.players.size; i++ )
        {

            player = level.players[i];

            if (isDefined(player) && isAlive(player)) {

                origin_0 = player.origin[0];
                origin_1 = player.origin[1];
                origin_2 = player.origin[2];

                if (origin_0 > 3116 && origin_0 < 3173 &&  origin_1 < -3026 && origin_1 > -3059 &&  origin_2 < -133.5 && origin_2 > -134.5)
                    player setOrigin((3088,-3132,-136));

                else if (origin_0 > 3082 && origin_0 < 3135 &&  origin_1 < -3080 && origin_1 > -3115  &&  origin_2 < -133 && origin_2 > -136)
                    player setOrigin((3166,-3004,-136));

                else if (origin_0 > 3465 && origin_0 < 3495 &&  origin_1 < -4489 && origin_1 > -4610  &&  origin_2 < -135.9 && origin_2 > -136.2)
                    player setOrigin((origin_0+108,origin_1 - 28,-138));

                else if (origin_0 > 3530 && origin_0 < 3568 &&  origin_1 < -4510 && origin_1 > -4654  &&  origin_2 < -136.5 && origin_2 > -136.8)
                    player setOrigin((origin_0-108,origin_1 + 28,-137));
                else
                    continue;

                player playSound( "RU_mp_cmd_movein" );

            }
        }
    }
}

teamskill() {

    level endon("game_ended");

    wait 5;

    updateteamskds();

    while (true) {

        wait 10;

        updateteamskds();

    }

}

updateteamskds() {

    alliesKD = 0;
    axisKD = 0;
    alliesKDs = [];
    axisKDs = [];

    for ( i = 0; i < level.players.size; i++ )
    {
        player = level.players[i];

        if ((isdefined(player.pers["team"])) && (player.pers["team"] == "allies") && isAlive(player)) {
            if (player.pers["killz"] > 100)
                alliesKDs[alliesKDs.size] = player.pers["KDz"];
        }
        else if ((isdefined(player.pers["team"])) && (player.pers["team"] == "axis") && isAlive(player)) {
            if (player.pers["killz"] > 100)
                axisKDs[axisKDs.size] = player.pers["KDz"];
        }
    }

    if (alliesKDs.size > 0) {
        for ( i = 0; i < alliesKDs.size; i++ )
            alliesKD += alliesKDs[i];

        level.KD["allies"] = alliesKD / alliesKDs.size;
    } else
        level.KD["allies"] = 1;

    if (axisKDs.size > 0) {
        for ( i = 0; i < axisKDs.size; i++ )
            axisKD += axisKDs[i];

        level.KD["axis"] = axisKD / axisKDs.size;
    } else
        level.KD["axis"] = 1;

}

checkPings() {

    level endon("game_ended");

    while (true) {

        wait 10;

        players = getentarray("player", "classname");

        for (i=0;i<players.size;i++) {

            if (isDefined(players[i]) && isAlive(players[i]) && players[i].pers["status"] == "default") {

                if (!isDefined(players[i].pingcnt))
                    players[i].pingcnt = 0;

                players[i].ping = players[i] GetPing();

                if (players[i].ping > 350)
                    players[i].pingcnt++;


                if (players[i].pingcnt > 10) {

                    logprint("say;"+players[i] GetGuid()+";" + players[i] GetEntityNumber() + ";" + players[i].name +";^1���� ������� �� ������� ������� ���� ^3(" + players[i].ping+ "��)\n");
                    exec("kick " + players[i] GetGuid() + " ^3Your ^2Ping ^3is too ^1High ^3(^1" + players[i].ping+ "ms^3)");

                }

            }

            wait .05;

        }

    }

}


weeklytop() {

    wait 5;

    keys = "";
    level.weeklytopKills["player"] = [];
    level.weeklytopKills["kills"] = [];
    level.weeklytopKD["player"] = [];
    level.weeklytopKD["kd"] = [];
    level.weeklytopKPM["player"] = [];
    level.weeklytopKPM["kpm"] = [];
    level.weeklytopKnives["player"] = [];
    level.weeklytopKnives["knives"] = [];
    level.topSkill["player"] = [];
    level.topSkill["skill"] = [];

//KILLS

    level.mysqlwait = true;

    level.handle = mysql_real_connect("localhost", "login", "password", "cod4stats");

    mysql_query(level.handle,"set names 'cp1251'");

    mysql_query(level.handle,"SELECT s_player player, (s_kills - s_kills_w) kills FROM `stats` where s_server = '" + getdvar("mysql_server") + "' ORDER BY kills desc limit 3");

    arr = mysql_fetch_row(level.handle);

    if (isDefined(arr))
        keys = getArrayKeys(arr);

    while (isDefined(arr)) {

        for (j = 0; j < keys.size; j++)
        {
            if (keys[j] == "player")
                level.weeklytopKills["player"][level.weeklytopKills["player"].size] = arr[keys[j]];

            else if (keys[j] == "kills")
                level.weeklytopKills["kills"][level.weeklytopKills["kills"].size] = arr[keys[j]];

        }

        wait .05;
        arr = mysql_fetch_row(level.handle);
        if (isDefined(arr))
            keys = getArrayKeys(arr);

    }


    wait .3;
//KD

    mysql_query(level.handle,"SELECT s_player player,(s_kills - s_kills_w) / (s_deaths - s_deaths_w) kd FROM `stats` where s_server = '" + getdvar("mysql_server") + "' AND ((s_kills - s_kills_w) > (SELECT value FROM `metrics` WHERE metric = '" + getdvar("mysql_server") + "')) AND (s_kills - s_kills_w) / (s_deaths - s_deaths_w) is not null ORDER BY kd desc limit 3");

    arr = mysql_fetch_row(level.handle);

    if (isDefined(arr))
        keys = getArrayKeys(arr);

    while (isDefined(arr)) {

        for (j = 0; j < keys.size; j++)
        {

            if (keys[j] == "player")
                level.weeklytopKD["player"][level.weeklytopKD["player"].size] = arr[keys[j]];
            else if (keys[j] == "kd")
                level.weeklytopKD["kd"][level.weeklytopKD["kd"].size] = arr[keys[j]];

        }

        wait .05;
        arr = mysql_fetch_row(level.handle);
        if (isDefined(arr))
            keys = getArrayKeys(arr);
    }

    wait .3;

    //KillsPerMinute

    mysql_query(level.handle,"SELECT s_player player, COALESCE((s_kills - s_kills_w) / (s_playedtime - s_playedtime_w) * 60, 0) kpm FROM `stats` where s_server = '" + getdvar("mysql_server") + "' AND ((s_kills - s_kills_w) > (SELECT value FROM `metrics` WHERE metric = '" + getdvar("mysql_server") + "')) AND (s_playedtime - s_playedtime_w) / (s_kills - s_kills_w) is not null ORDER BY kpm desc limit 3");

    arr = mysql_fetch_row(level.handle);

    if (isDefined(arr))
        keys = getArrayKeys(arr);

    while (isDefined(arr)) {

        for (j = 0; j < keys.size; j++)
        {

            if (keys[j] == "player")
                level.weeklytopKPM["player"][level.weeklytopKPM["player"].size] = arr[keys[j]];
            else if (keys[j] == "kpm")
                level.weeklytopKPM["kpm"][level.weeklytopKPM["kpm"].size] = arr[keys[j]];

        }

        wait .05;
        arr = mysql_fetch_row(level.handle);
        if (isDefined(arr))
            keys = getArrayKeys(arr);
    }

    wait .3;

    //KNIVES

    mysql_query(level.handle,"SELECT s_player player, (s_melle - s_melle_w) knives FROM `stats` where s_server = '" + getdvar("mysql_server") + "' ORDER BY knives desc limit 3");

    arr = mysql_fetch_row(level.handle);

    if (isDefined(arr))
        keys = getArrayKeys(arr);

    while (isDefined(arr)) {

        for (j = 0; j < keys.size; j++)
        {
            if (keys[j] == "player")
                level.weeklytopKnives["player"][level.weeklytopKnives["player"].size] = arr[keys[j]];

            else if (keys[j] == "knives")
                level.weeklytopKnives["knives"][level.weeklytopKnives["knives"].size] = arr[keys[j]];

        }

        wait .05;
        arr = mysql_fetch_row(level.handle);
        if (isDefined(arr))
            keys = getArrayKeys(arr);

    }

    wait .3;

    //SKILL

    mysql_query(level.handle,"SELECT s_player player, s_skill skill FROM `stats` where s_server = '" + getdvar("mysql_server") + "' AND ((s_kills - s_kills_w) > (SELECT value FROM `metrics` WHERE metric = '" + getdvar("mysql_server") + "')) ORDER BY s_skill desc limit 3");

    arr = mysql_fetch_row(level.handle);

    if (isDefined(arr))
        keys = getArrayKeys(arr);

    while (isDefined(arr)) {

        for (j = 0; j < keys.size; j++)
        {
            if (keys[j] == "player")
                level.topSkill["player"][level.topSkill["player"].size] = arr[keys[j]];

            else if (keys[j] == "skill")
                level.topSkill["skill"][level.topSkill["skill"].size] = arr[keys[j]];

        }

        wait .05;
        arr = mysql_fetch_row(level.handle);
        if (isDefined(arr))
            keys = getArrayKeys(arr);

    }

    mysql_close(level.handle);

    level.mysqlwait = false;
}
gogoEventTimer(event) {

    wait (120 + randomint(800));
    gogoEvent(event);

}
gogoEvent(event) {

    if (level.event == true)
        return;

    eventShader = "killiconmelee";

    if (event == 0)	{
        eventShader = "killiconmelee";
    }
    else if (event == 1 ) {
        eventShader = "weapon_rpg7";
    }
    else if (event == 2 ) {
        eventShader = "weapon_remington700";
    }	else if (event == 3 ) {
        eventShader = "weapon_desert_eagle_gold";
    }	else if (event == 4 ) {
        eventShader = "weapon_fraggrenade";
    } else if (event == 5 ) {
        eventShader = "weapon_attachment_m203";
    }

    players = getentarray("player", "classname");

    for (i=0;i<players.size;i++) {

        if ( isDefined( players[i] )) {

            if (event == 0)	{
                players[i] maps\mp\gametypes\_hud_message::oldNotifyMessage(players[i] volkv\_common::getLangString("KNIFE_TIME_PREPARE"));

            }
            else if (event == 1) {
                players[i] maps\mp\gametypes\_hud_message::oldNotifyMessage(players[i] volkv\_common::getLangString("RPG_TIME_PREPARE"));

            }
            else if (event == 2) {
                players[i] maps\mp\gametypes\_hud_message::oldNotifyMessage(players[i] volkv\_common::getLangString("R700_TIME_PREPARE"));

            }	else if (event == 3) {
                players[i] maps\mp\gametypes\_hud_message::oldNotifyMessage(players[i] volkv\_common::getLangString("deagle_TIME_PREPARE"));

            } else if (event == 4) {
                players[i] maps\mp\gametypes\_hud_message::oldNotifyMessage(players[i] volkv\_common::getLangString("FRAG_TIME_PREPARE"));

            } else if (event == 5) {
                players[i] maps\mp\gametypes\_hud_message::oldNotifyMessage(players[i] volkv\_common::getLangString("GL_TIME_PREPARE"));

            }
        }
    }


    shaderIcon = newHudElem();
    shaderIcon.x = 14;
    shaderIcon.y = -15;
    shaderIcon.hidden = false;
    shaderIcon.horzAlign = "center";
    shaderIcon.vertAlign = "bottom";
    shaderIcon.alignx = "center";
    shaderIcon.alignY = "bottom";
    shaderIcon.alpha = 0;
    shaderIcon.archived = false;
    shaderIcon fadeOverTime( .5 );
    shaderIcon.alpha = 1;
    shaderIcon setShader( eventShader, 48, 48 );


    knifeTimerPre = newHudElem();
    knifeTimerPre.elemType = "font";
    knifeTimerPre.x = 14;
    knifeTimerPre.y = -60;
    knifeTimerPre.alignX = "center";
    knifeTimerPre.alignY = "bottom";
    knifeTimerPre.horzAlign = "center";
    knifeTimerPre.vertAlign = "bottom";
    knifeTimerPre setTimer( 10 );
    knifeTimerPre.color = ( 1.0, 0.0, 0.0 );
    knifeTimerPre.fontscale = 2;
    knifeTimerPre.archived = 0;

    playSoundOnPlayers( "ui_mp_suitcasebomb_timer" );
    wait 1;
    playSoundOnPlayers( "ui_mp_suitcasebomb_timer" );
    wait 1;
    playSoundOnPlayers( "ui_mp_suitcasebomb_timer" );
    wait 1;
    playSoundOnPlayers( "ui_mp_suitcasebomb_timer" );
    wait 1;
    playSoundOnPlayers( "ui_mp_suitcasebomb_timer" );
    wait 1;
    playSoundOnPlayers( "ui_mp_suitcasebomb_timer" );
    wait 1;
    playSoundOnPlayers( "ui_mp_suitcasebomb_timer" );
    wait 1;
    playSoundOnPlayers( "ui_mp_suitcasebomb_timer" );
    wait 1;
    playSoundOnPlayers( "ui_mp_suitcasebomb_timer" );
    wait 1;
    playSoundOnPlayers( "ui_mp_suitcasebomb_timer" );
    wait 1;

    playSoundOnPlayers( "mp_challenge_complete" );

    knifeTimerPre destroy();

    if (event == 0)	{
        level.knife = true;
    } else if (event == 1 ) {
        level.rpg = true;
    } else if (event == 2 ) {
        level.r700 = true;
    } else if (event == 3 ) {
        level.deagle = true;
    } else if (event == 4 ) {
        level.frag = true;
    } else if (event == 5 ) {
        level.gl = true;
    }

    level.event = true;

    players = getentarray("player", "classname");


    for (i=0;i<players.size;i++) {
        if (isDefined( players[i] )) {
            players[i] setClientDvar("g_compassShowEnemies",1);
        }



        if ( isDefined( players[i] ) &&  isAlive( players[i] )) {
			
			
		if (players[i].pers["knifemode"]) {

            players[i] setMoveSpeedScale(1);
			players[i] setClientDvar( "player_sprintUnlimited", 0 );  
            players[i].pers["knifemode"] = false;
            players[i] maps\mp\gametypes\_globallogic::defaultHealth();
        }
		

            if (event == 0)
                players[i] maps\mp\gametypes\_hud_message::oldNotifyMessage(players[i] volkv\_common::getLangString("KNIFE_TIME"));
            else if (event == 1)
                players[i] maps\mp\gametypes\_hud_message::oldNotifyMessage(players[i] volkv\_common::getLangString("RPG_TIME"));
            else if (event == 2)
                players[i] maps\mp\gametypes\_hud_message::oldNotifyMessage(players[i] volkv\_common::getLangString("R700_TIME"));
            else if (event == 3)
                players[i] maps\mp\gametypes\_hud_message::oldNotifyMessage(players[i] volkv\_common::getLangString("deagle_TIME"));
            else if (event == 4)
                players[i] maps\mp\gametypes\_hud_message::oldNotifyMessage(players[i] volkv\_common::getLangString("FRAG_TIME"));
            else if (event == 5)
                players[i] maps\mp\gametypes\_hud_message::oldNotifyMessage(players[i] volkv\_common::getLangString("GL_TIME"));

            players[i] takeweapons();

            players[i] clearPerks();
            players[i] setperk( "specialty_longersprint" );

            posi = 80;
            if (event == 2)
                posi = 60;

            players[i] maps\mp\gametypes\_hud_util::showPerk( 0, "specialty_longersprint", posi );

            players[i] thread maps\mp\gametypes\_globallogic::hidePerksAfterTime( 1 );
            players[i] thread maps\mp\gametypes\_globallogic::hidePerksOnDeath();


            if (event == 0)	{

                players[i] giveWeapon("c4_mp");
                players[i] setWeaponAmmoClip( "c4_mp", 0 );
                players[i] switchToWeapon("c4_mp");
                players[i] setSpawnWeapon( "c4_mp" );
                players[i] SetActionSlot( 3, "weapon","c4_mp");
                players[i] thread weapondropKnife();
            }

            else if (event == 1)	 {

                players[i] giveWeapon("rpg_mp");
                players[i] giveMaxAmmo( "rpg_mp" );
                players[i] SetActionSlot( 1, "weapon","rpg_mp");
                players[i] switchToWeapon("rpg_mp");
                players[i] setSpawnWeapon( "rpg_mp" );
                players[i] thread rpgAmmo();
                players[i] thread weapondropRPG();
            }

            else if (event == 2) {
                players[i] setperk( "specialty_holdbreath" );
                players[i] maps\mp\gametypes\_hud_util::showPerk( 1, "specialty_holdbreath", 60 );
                players[i] giveWeapon("remington700_mp");
                players[i] giveMaxAmmo( "remington700_mp" );
                players[i] switchToWeapon("remington700_mp");
                players[i] setSpawnWeapon( "remington700_mp" );
                players[i] thread R700Ammo();
                players[i] thread weapondropR700();

            }
            else if (event == 3) {

                players[i] giveWeapon("deserteaglegold_mp");
                players[i] giveMaxAmmo( "deserteaglegold_mp" );
                players[i] switchToWeapon("deserteaglegold_mp");
                players[i] setSpawnWeapon( "deserteaglegold_mp" );
                players[i] thread deagleAmmo();
                players[i] thread weapondropdeagle();

            }  else if (event == 4) {

                players[i] maps\mp\_load::takeweapons();
                players[i] giveWeapon("frag_grenade_mp");
                players[i] giveMaxAmmo( "frag_grenade_mp");
                players[i] switchToWeapon("frag_grenade_mp");
                players[i] setSpawnWeapon( "frag_grenade_mp" );
                players[i] thread maps\mp\_load::fragAmmo();
                players[i] thread maps\mp\_load::weapondropfrag();

            }   else if (event == 5) {

                players[i] maps\mp\_load::takeweapons();
                players[i] giveWeapon("gl_g36c_mp");
                players[i] giveMaxAmmo( "gl_g36c_mp");
                players[i] switchToWeapon("gl_g36c_mp");
                players[i] setSpawnWeapon( "gl_g36c_mp" );
                players[i] thread maps\mp\_load::glAmmo();
                players[i] thread maps\mp\_load::weapondropgl();
            }
        }
    }

    shaderIcon.x = 110;
    shaderIcon.y = -430;
    shaderIcon.horzAlign = "left";
    shaderIcon.vertAlign = "bottom";
    shaderIcon.alignx = "left";
    shaderIcon.alignY = "middle";
    shaderIcon setShader( eventShader, 32, 32 );

    knifeTimer = newHudElem();
    knifeTimer.elemType = "font";
    knifeTimer.x = 147;
    knifeTimer.y = -430;
    knifeTimer.alignX = "left";
    knifeTimer.alignY = "middle";
    knifeTimer.horzAlign = "left";
    knifeTimer.vertAlign = "bottom";
    knifeTimer setTimer( 90 );
    knifeTimer.color = ( 0.8, 0.0, 0.0 );
    knifeTimer.fontscale = 1.4;
    knifeTimer.archived = 0;

    wait 90;

    playSoundOnPlayers( "mp_challenge_complete" );
    shaderIcon destroy();
    knifeTimer destroy();

    level.event = false;
    level.knife = false;
    level.rpg = false;
    level.r700 = false;
    level.deagle = false;
    level.gl = false;
    level.frag = false;

    players = getentarray("player", "classname");

    for (i=0;i<players.size;i++) {

        if (isDefined( players[i] ))
            players[i] setClientDvar("g_compassShowEnemies",0);



        if (isDefined( players[i] ) && isDefined(players[i].team) &&  isAlive( players[i])) {

            if (players[i].pers["knife"]) {

                players[i] takeweapons();
                players[i] giveWeapon("c4_mp");
                players[i] setWeaponAmmoClip( "c4_mp", 0 );
                players[i] switchToWeapon("c4_mp");
                players[i] setSpawnWeapon( "c4_mp" );
                players[i] SetActionSlot( 3, "weapon","c4_mp");
                

                players[i] setMoveSpeedScale(1.1);
				players[i] setperk( "specialty_longersprint" );
				players[i] setperk( "specialty_gpsjammer" );
				players[i] setClientDvar( "player_sprintUnlimited", 1 );  
                players[i].pers["knifemode"] = true;
				players[i] thread weapondropButcher();
                players[i] maps\mp\gametypes\_globallogic::defaultHealth();
				
            } else {


                if (!isDefined(players[i].pers["primaryWeapon"]) || !isDefined(players[i].class)) {

                    players[i] maps\mp\gametypes\_class::setClass( "assault");
                    players[i] maps\mp\gametypes\_teams::playerModelForWeapon( "ak47_mp" );
                }

                players[i] maps\mp\gametypes\_class::giveLoadout( players[i].team, players[i].class );

            }
        }

    }

}

takeweapons() {

    weaponsList = self getWeaponsList();

    if (self hasWeapon("c4_mp"))
        self takeWeapon("c4_mp");
    if (self hasWeapon("claymore_mp"))
        self takeWeapon("claymore_mp");
    if (self hasWeapon("rpg_mp"))
        self takeWeapon("rpg_mp");

    for ( idx = 0; idx < weaponsList.size; idx++ )
    {
        if ((isdefined( level.primary_weapon_array[weaponsList[idx]] ) || isdefined( level.side_arm_array[weaponsList[idx]] ) || isdefined( level.grenade_array[weaponsList[idx]] )) && self hasWeapon(weaponsList[idx]))  {
            self takeWeapon(weaponsList[idx]);
        }
    }

}

weapondropfrag() {

    self endon( "disconnect" );

    while (level.frag) {

        self waittill( "weapon_change", newWeapon );
        if (level.frag) {
            self takeweapons();
            self giveWeapon("frag_grenade_mp");
            self giveMaxAmmo( "frag_grenade_mp");
            self switchToWeapon("frag_grenade_mp");
            self setSpawnWeapon( "frag_grenade_mp" );
        }
    }

}

weapondropgl() {

    self endon( "disconnect" );

    while (level.gl) {

        self waittill( "weapon_change", newWeapon );
        if (level.gl) {
            self takeweapons();
            self giveWeapon("gl_g36c_mp");
            self giveMaxAmmo( "gl_g36c_mp");
            self switchToWeapon("gl_g36c_mp");
            self setSpawnWeapon( "gl_g36c_mp" );
        }
    }

}

weapondropdeagle() {

    self endon( "disconnect" );

    while (level.deagle) {

        self waittill( "weapon_change", newWeapon );
        if (level.deagle) {
            self takeweapons();
            self giveWeapon("deserteaglegold_mp");
            self giveMaxAmmo( "deserteaglegold_mp");
            self switchToWeapon("deserteaglegold_mp");
            self setSpawnWeapon( "deserteaglegold_mp" );
        }
    }

}

weapondropKnife() {

    self endon( "disconnect" );


    while (level.knife) {

        self waittill( "weapon_change", newWeapon );
        if (level.knife) {
            self takeweapons();
            self giveWeapon("c4_mp");
            self setWeaponAmmoClip( "c4_mp", 0 );
            self switchToWeapon("c4_mp");
            self setSpawnWeapon( "c4_mp" );
            self SetActionSlot( 3, "weapon","c4_mp");
        }
    }

}
weapondropButcher() {

    self notify("butchermode");
    self endon("butchermode");

    self endon( "disconnect" );

    while (self.pers["knifemode"]) {

        self waittill( "weapon_change", newWeapon );
        if (self.pers["knifemode"]) {
            self takeweapons();
            self giveWeapon("c4_mp");
            self setWeaponAmmoClip( "c4_mp", 0 );
            self switchToWeapon("c4_mp");
            self setSpawnWeapon( "c4_mp" );
            self SetActionSlot( 3, "weapon","c4_mp");
        }
    }

}

weapondropRPG() {

    self endon( "disconnect" );

    while (level.rpg) {


        self waittill( "weapon_change", newWeapon );
        if (level.rpg) {
            self takeweapons();
            self giveWeapon("rpg_mp");
            self giveMaxAmmo( "rpg_mp" );
            self SetActionSlot( 1, "weapon","rpg_mp");

            self switchToWeapon("rpg_mp");
            self setSpawnWeapon( "rpg_mp" );
        }
    }

}

weapondropR700() {

    self endon( "disconnect" );

    while (level.r700) {

        self waittill( "weapon_change", newWeapon );

        if (level.r700 && newWeapon != "remington700_mp") {
            self takeweapons();
            self giveWeapon("remington700_mp");
            self giveMaxAmmo( "remington700_mp" );

            self switchToWeapon("remington700_mp");
            self setSpawnWeapon( "remington700_mp" );
        }
    }

}


fragAmmo() {
    self endon("disconnect");
    level endon("game_ended");
    self endon("death");

    while (level.frag) {
        wait 3;
        self giveMaxAmmo( "frag_grenade_mp" );
    }

}

glAmmo() {
    self endon("disconnect");
    level endon("game_ended");
    self endon("death");

    while (level.gl) {
        wait 3;
        self giveMaxAmmo( "gl_g36c_mp" );
    }

}

deagleAmmo() {
    self endon("disconnect");
    level endon("game_ended");
    self endon("death");

    while (level.deagle) {
        wait 3;
        self giveMaxAmmo( "deserteaglegold_mp" );
    }

}

rpgAmmo() {
    self endon("disconnect");
    level endon("game_ended");
    self endon("death");

    while (level.rpg) {
        wait 3;
        self giveMaxAmmo( "rpg_mp" );
    }

}

R700Ammo() {
    self endon("disconnect");
    level endon("game_ended");
    self endon("death");

    while (level.r700) {
        wait 5;
        self giveMaxAmmo( "remington700_mp" );
    }

}


switchmap() {
    level endon("game_ended");

    for ( ;; )	{

        wait 35;

        players = getEntarray( "player", "classname" );
        playerscnt = 0;

        for ( i = 0; i < players.size; i++ ) {
            if (!isDefined(players[i].pers["isBot"]))
                playerscnt++;
        }
        if (playerscnt < 4 && (getDvar("mapname") != "mp_shipment") && (getDvar("mapname") != "mp_killhouse")) {

            map = randomint(2);

            if (map == 0) {

                if (getDvar("mapname") != "mp_shipment") {
                    setDvar( "sv_maprotationcurrent", "gametype " + getDvar("g_gametype") + " map mp_shipment");
                } else {
                    setDvar( "sv_maprotationcurrent", "gametype " + getDvar("g_gametype") + " map mp_killhouse");
                }

            } else {
                if (getDvar("mapname") != "mp_killhouse") {
                    setDvar( "sv_maprotationcurrent", "gametype " + getDvar("g_gametype") + " map mp_killhouse");
                } else {
                    setDvar( "sv_maprotationcurrent", "gametype " + getDvar("g_gametype") + " map mp_shipment");
                }

            }

            exitLevel( false );


        }

    }

}

addBotClient() {

    botNames = [];
botNames[0]="CullingCard";
botNames[1]="TheFinalCount";
botNames[2]="SeekNDstroy";
botNames[3]="Bulletz4Break";
botNames[4]="BigDamnHero";
botNames[5]="LaidtoRest";
botNames[6]="IronMAN77";
botNames[7]="Xenomorphing";
botNames[8]="TylerDurden";
botNames[9]="PennywiseTheC";
botNames[10]="BluntMachete";
botNames[11]="SniperLyfe";
botNames[12]="SilentWraith";
botNames[13]="BloodyAssault";
botNames[14]="FightClubAlum";
botNames[15]="KillSwitch";
botNames[16]="ExecuteElect";
botNames[17]="BadBaneCat";
botNames[18]="IndominusRexxx";
botNames[19]="AzogtheDefiler";
botNames[20]="BadassStickBug";
botNames[21]="EngineThatCou";
botNames[22]="FlatDietSoda";
botNames[23]="PervertPeewee";
botNames[24]="TubbyCandyHoar";
botNames[25]="GotASegway";
botNames[26]="LookWhatICanDo";
botNames[27]="IPlayFarmHero";
botNames[28]="EatingHawaiian";
botNames[29]="YOURnameHERE";
botNames[30]="TickleMeElmo";
botNames[31]="EasyHUIsy";
botNames[32]="BepHuTeCaMoKaT";
botNames[33]="JIbICbIu";
botNames[34]="TvoSI";
botNames[35]="Mamka";
botNames[36]="Your_perdAk";
botNames[37]="sexy";
botNames[38]="6aTaH";
botNames[39]="MoX";
botNames[40]="Pukan_V_Ogne";
botNames[41]="Peppa";
botNames[42]="KurWa";
botNames[43]="RectumRanger";
botNames[44]="BobScare";
botNames[45]="TubgirI";
botNames[46]="werdafukarwi";
botNames[47]="BorgCollectiv";
botNames[48]="MouseRatRock";
botNames[49]="ShittinBullet";
botNames[50]="WarningLow";
botNames[51]="Kudesn1k";
botNames[52]="Granny4theWIN";
botNames[53]="PookieChips";
botNames[54]="TheMustardCat";
botNames[55]="DnknDonuts";
botNames[56]="EdgarAllenPoo";
botNames[57]="PickingBooger";
botNames[58]="BeanieWeenees";
botNames[59]="BitchWhoDont";
botNames[60]="LilianaVess";
botNames[61]="MrZadrot";
botNames[62]="GunnerrGurrl";
botNames[63]="SevenofNine";
botNames[64]="CandyStripper";
botNames[65]="SmokinHotChick";
botNames[66]="MadBabyMaker";
botNames[67]="PistolPrincess";
botNames[68]="TiaraONtop";
botNames[69]="SuperGurl3000";
botNames[70]="GlitterGunner";
botNames[71]="PurpleBunnySl";
botNames[72]="ImTheBirthday";
botNames[73]="FlameThrower";
botNames[74]="SmittenKitten";
botNames[75]="SniperPrinces";
botNames[76]="SexyShooter";
botNames[77]="BluberriMuff";
botNames[78]="CutiePatooti";
botNames[79]="MsPiggysREVE";
botNames[80]="ShotHottie33";
botNames[81]="PyKA_B_TPyCAX";
botNames[82]="Unerrawan";
botNames[83]="Raometh";
botNames[84]="GreatBallsOf";
botNames[85]="Laralilith";
botNames[86]="Lalissi";
botNames[87]="Aaeb";
botNames[88]="massivegenit";
botNames[89]="MW3";
botNames[90]="iGrAnDpA";
botNames[91]="Apaul";
botNames[92]="Me";
botNames[93]="Deke";
botNames[94]="Yuri";
botNames[95]="Nator";
botNames[96]="Hugh";
botNames[97]="Ass";
botNames[98]="Hugh";
botNames[99]="Recksh";
botNames[100]="Yum";
botNames[101]="Cow";
botNames[102]="Turd";
botNames[103]="FearMikeHawk";
botNames[104]="SuluToeChees";
botNames[105]="Bovine";
botNames[106]="Scat";
botNames[107]="Gwoacia";
botNames[108]="Drigonyth";
botNames[109]="MacTep_Yoba";
botNames[110]="Umamma";
botNames[111]="Cyxue_Tpycuku";
botNames[112]="Stafilak0k";
botNames[113]="TeH";
botNames[114]="Boobinat";
botNames[115]="RulzorOvdain";
botNames[116]="Yourworstnig";
botNames[117]="SatanMyMaster";
botNames[118]="MassiveBloke";
botNames[119]="HakzUrC0mp00";
botNames[120]="StabMyhear";
botNames[121]="Seran";
botNames[122]="Legililoth";
botNames[123]="luntik";
botNames[124]="Major_Pain";
botNames[125]="CTAPyXu_CMOTP";
botNames[126]="LEHUH_B_TAHKE";
botNames[127]="KAKASHKA";
botNames[128]="70_JIeT";
botNames[129]="TRTR";
botNames[130]="Namatrasnik";
botNames[131]="KOKOC";
botNames[132]="3JIbIe_Tanku";
botNames[133]="NoSOk_V_NoZ";
botNames[134]="Drova1990";
botNames[135]="edrillo";


    bot = AddTestClient(botNames[randomInt( botNames.size )]);
    bot.pers["isBot"] = true;
    wait .5;


    bot.sessionteam = "spectator";
    bot.sessionstate = "spectator";
    bot.pers["team"] = "spectator";
    wait .5;

    bot setRank(randomint(5));

    // 1337 stats
    bot.pers["score"] = 0;
    bot.pers["kills"] = 0;
    bot.pers["assists"] = 0;
    bot.pers["deaths"] = 0;
    bot.score = 0;
    bot.kills = 0;
    bot.assists = 0;
    bot.deaths = 0;
}


addBotz(num) {

    //  removeAllTestClients();

    wait 1;

    for (i = 0; i < num; i++)
    {
        thread addBotClient();
        wait 1;
    }

}

gogoBots() {

    wait 10;


    wait (1 + randomint(3));

    players = getentarray("player", "classname");

    if (players.size < 24) {
        thread addBotz(4 - randomint(2));

    }

}

gogoStats() {

    if (getDvar("g_gametype") != "sab" && getDvar("g_gametype") != "sd") {

        wait 30;

        file = FS_FOpen( "stats.db", "append" );

        if ( !isDefined( file ) )
            return false;

        players = getEntarray( "player", "classname" );

        playerscnt = 0;

        for ( i = 0; i < players.size; i++ ) {
            if (!isDefined(players[i].pers["isBot"]))
                playerscnt++;
        }


        FS_WriteLine( file,  "START " + getDvar("mapname") + " " + playerscnt );

        FS_FClose( file );

    }
}

gogoStatsMiddle() {

    level endon("game_ended");

    wait 360;

    players = getEntarray( "player", "classname" );
    playerscnt = 0;

    for ( i = 0; i < players.size; i++ ) {
        if (!isDefined(players[i].pers["isBot"]))
            playerscnt++;
    }

    logPrint("STAT;2310;" + GetRealTime() + ";" + getdvar("mysql_server") + ";" + getDvar("mapname") + ";" + playerscnt  + "\n");

    wait 360;

    players = getEntarray( "player", "classname" );
    playerscnt = 0;

    for ( i = 0; i < players.size; i++ ) {
        if (!isDefined(players[i].pers["isBot"]))
            playerscnt++;
    }

    logPrint("STAT;2310;" + GetRealTime() + ";" + getdvar("mysql_server") + ";" + getDvar("mapname") + ";" + playerscnt  + "\n");
}

exploder_load( trigger )
{
    level endon( "killexplodertridgers" + trigger.script_exploder );
    trigger waittill( "trigger" );
    if ( isdefined( trigger.script_chance ) && randomfloat( 1 ) > trigger.script_chance )
    {
        if ( isdefined( trigger.script_delay ) )
            wait trigger.script_delay;
        else
            wait 4;
        level thread exploder_load( trigger );
        return;
    }
    maps\mp\_utility::exploder( trigger.script_exploder );
    level notify( "killexplodertridgers" + trigger.script_exploder );
}


setupExploders()
{
    // Hide exploder models.
    ents = getentarray( "script_brushmodel", "classname" );
    smodels = getentarray( "script_model", "classname" );
    for ( i = 0;i < smodels.size;i ++ )
        ents[ ents.size ] = smodels[ i ];

    for ( i = 0;i < ents.size;i ++ )
    {
        if ( isdefined( ents[ i ].script_prefab_exploder ) )
            ents[ i ].script_exploder = ents[ i ].script_prefab_exploder;

        if ( isdefined( ents[ i ].script_exploder ) )
        {
            if ( ( ents[ i ].model == "fx" ) && ( ( !isdefined( ents[ i ].targetname ) ) || ( ents[ i ].targetname != "exploderchunk" ) ) )
                ents[ i ] hide();
            else if ( ( isdefined( ents[ i ].targetname ) ) && ( ents[ i ].targetname == "exploder" ) )
            {
                ents[ i ] hide();
                ents[ i ] notsolid();
                //if ( isdefined( ents[ i ].script_disconnectpaths ) )
                //ents[ i ] connectpaths();
            }
            else if ( ( isdefined( ents[ i ].targetname ) ) && ( ents[ i ].targetname == "exploderchunk" ) )
            {
                ents[ i ] hide();
                ents[ i ] notsolid();
                //if ( isdefined( ents[ i ].spawnflags ) && ( ents[ i ].spawnflags & 1 ) )
                //ents[ i ] connectpaths();
            }
        }
    }

    script_exploders = [];

    potentialExploders = getentarray( "script_brushmodel", "classname" );
    for ( i = 0;i < potentialExploders.size;i ++ )
    {
        if ( isdefined( potentialExploders[ i ].script_prefab_exploder ) )
            potentialExploders[ i ].script_exploder = potentialExploders[ i ].script_prefab_exploder;

        if ( isdefined( potentialExploders[ i ].script_exploder ) )
            script_exploders[ script_exploders.size ] = potentialExploders[ i ];
    }

    potentialExploders = getentarray( "script_model", "classname" );
    for ( i = 0;i < potentialExploders.size;i ++ )
    {
        if ( isdefined( potentialExploders[ i ].script_prefab_exploder ) )
            potentialExploders[ i ].script_exploder = potentialExploders[ i ].script_prefab_exploder;

        if ( isdefined( potentialExploders[ i ].script_exploder ) )
            script_exploders[ script_exploders.size ] = potentialExploders[ i ];
    }

    potentialExploders = getentarray( "item_health", "classname" );
    for ( i = 0;i < potentialExploders.size;i ++ )
    {
        if ( isdefined( potentialExploders[ i ].script_prefab_exploder ) )
            potentialExploders[ i ].script_exploder = potentialExploders[ i ].script_prefab_exploder;

        if ( isdefined( potentialExploders[ i ].script_exploder ) )
            script_exploders[ script_exploders.size ] = potentialExploders[ i ];
    }

    if ( !isdefined( level.createFXent ) )
        level.createFXent = [];

    acceptableTargetnames = [];
    acceptableTargetnames[ "exploderchunk visible" ] = true;
    acceptableTargetnames[ "exploderchunk" ] = true;
    acceptableTargetnames[ "exploder" ] = true;

    for ( i = 0; i < script_exploders.size; i ++ )
    {
        exploder = script_exploders[ i ];
        ent = createExploder( exploder.script_fxid );
        ent.v = [];
        ent.v[ "origin" ] = exploder.origin;
        ent.v[ "angles" ] = exploder.angles;
        ent.v[ "delay" ] = exploder.script_delay;
        ent.v[ "firefx" ] = exploder.script_firefx;
        ent.v[ "firefxdelay" ] = exploder.script_firefxdelay;
        ent.v[ "firefxsound" ] = exploder.script_firefxsound;
        ent.v[ "firefxtimeout" ] = exploder.script_firefxtimeout;
        ent.v[ "earthquake" ] = exploder.script_earthquake;
        ent.v[ "damage" ] = exploder.script_damage;
        ent.v[ "damage_radius" ] = exploder.script_radius;
        ent.v[ "soundalias" ] = exploder.script_soundalias;
        ent.v[ "repeat" ] = exploder.script_repeat;
        ent.v[ "delay_min" ] = exploder.script_delay_min;
        ent.v[ "delay_max" ] = exploder.script_delay_max;
        ent.v[ "target" ] = exploder.target;
        ent.v[ "ender" ] = exploder.script_ender;
        ent.v[ "type" ] = "exploder";
// 		ent.v[ "worldfx" ] = true;
        if ( !isdefined( exploder.script_fxid ) )
            ent.v[ "fxid" ] = "No FX";
        else
            ent.v[ "fxid" ] = exploder.script_fxid;
        ent.v[ "exploder" ] = exploder.script_exploder;
        assertEx( isdefined( exploder.script_exploder ), "Exploder at origin " + exploder.origin + " has no script_exploder" );

        if ( !isdefined( ent.v[ "delay" ] ) )
            ent.v[ "delay" ] = 0;

        if ( isdefined( exploder.target ) )
        {
            org = getent( ent.v[ "target" ], "targetname" ).origin;
            ent.v[ "angles" ] = vectortoangles( org - ent.v[ "origin" ] );
// 			forward = anglestoforward( angles );
// 			up = anglestoup( angles );
        }

        // this basically determines if its a brush / model exploder or not
        if ( exploder.classname == "script_brushmodel" || isdefined( exploder.model ) )
        {
            ent.model = exploder;
            ent.model.disconnect_paths = exploder.script_disconnectpaths;
        }

        if ( isdefined( exploder.targetname ) && isdefined( acceptableTargetnames[ exploder.targetname ] ) )
            ent.v[ "exploder_type" ] = exploder.targetname;
        else
            ent.v[ "exploder_type" ] = "normal";

        ent maps\mp\_createfx::post_entity_creation_function();
    }
}

lanterns()
{
    if (!isdefined(level._effect["lantern_light"]))
        level._effect["lantern_light"]	= loadfx("props/glow_latern");
    maps\mp\_fx::loopfx("lantern_light", self.origin, 0.3, self.origin + (0,0,1));
}

script_gen_dump_checksaved()
{
    signatures = getarraykeys( level.script_gen_dump );
    for ( i = 0;i < signatures.size;i ++ )
        if ( !isdefined( level.script_gen_dump2[ signatures[ i ] ] ) )
        {
            level.script_gen_dump[ signatures[ i ] ] = undefined;
            level.script_gen_dump_reasons[ level.script_gen_dump_reasons.size ] = "Signature unmatched( removed feature ): " + signatures[ i ];

        }
}

script_gen_dump()
{
    // initialize scriptgen dump
    /#

    script_gen_dump_checksaved();// this checks saved against fresh, if there is no matching saved value then something has changed and the dump needs to happen again.

    if ( !level.script_gen_dump_reasons.size )
    {
        flag_set( "scriptgen_done" );
        return;// there's no reason to dump the file so exit
    }

    firstrun = false;
    if ( level.bScriptgened )
    {
        println( " " );
        println( " " );
        println( " " );
        println( "^2 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- " );
        println( "^3Dumping scriptgen dump for these reasons" );
        println( "^2 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- " );
        for ( i = 0;i < level.script_gen_dump_reasons.size;i ++ )
        {
            if ( issubstr( level.script_gen_dump_reasons[ i ], "nowrite" ) )
            {
                substr = getsubstr( level.script_gen_dump_reasons[ i ], 15 );// I don't know why it's 15, maybe investigate - nate
                println( i + ". ) " + substr );

            }
            else
                println( i + ". ) " + level.script_gen_dump_reasons[ i ] );
            if ( level.script_gen_dump_reasons[ i ] == "First run" )
                firstrun = true;
        }
        println( "^2 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- " );
        println( " " );
        if ( firstrun )
        {
            println( "for First Run make sure you delete all of the vehicle precache script calls, createart calls, createfx calls( most commonly placed in maps\\" + level.script + "_fx.gsc ) " );
            println( " " );
            println( "replace:" );
            println( "maps\\\_load::main( 1 );" );
            println( " " );
            println( "with( don't forget to add this file to P4 ):" );
            println( "maps\\scriptgen\\" + level.script + "_scriptgen::main();" );
            println( " " );
        }
// 		println( "make sure this is in your " + level.script + ".csv:" );
// 		println( "rawfile, maps / scriptgen/" + level.script + "_scriptgen.gsc" );
        println( "^2 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- " );
        println( " " );
        println( "^2 / \\ / \\ / \\" );
        println( "^2scroll up" );
        println( "^2 / \\ / \\ / \\" );
        println( " " );
    }
    else
    {
        /* 		println( " " );
           	println( " " );
           	println( "^3for legacy purposes I'm printing the would be script here, you can copy this stuff if you'd like to remain a dinosaur:" );
           	println( "^3otherwise, you should add this to your script:" );
           	println( "^3maps\\\_load::main( 1 );" );
           	println( " " );
           	println( "^3rebuild the fast file and the follow the assert instructions" );
           	println( " " );

           	 */
        return;
    }

    filename = "scriptgen/" + level.script + "_scriptgen.gsc";
    csvfilename = "zone_source/" + level.script + ".csv";

    if ( level.bScriptgened )
        file = openfile( filename, "write" );
    else
        file = 0;

    assertex( file != -1, "File not writeable( check it and and restart the map ): " + filename );

    script_gen_dumpprintln( file, "// script generated script do not write your own script here it will go away if you do." );
    script_gen_dumpprintln( file, "main()" );
    script_gen_dumpprintln( file, "{" );
    script_gen_dumpprintln( file, "" );
    script_gen_dumpprintln( file, "\tlevel.script_gen_dump = [];" );
    script_gen_dumpprintln( file, "" );

    signatures = getarraykeys( level.script_gen_dump );
    for ( i = 0;i < signatures.size;i ++ )
        if ( !issubstr( level.script_gen_dump[ signatures[ i ] ], "nowrite" ) )
            script_gen_dumpprintln( file, "\t" + level.script_gen_dump[ signatures[ i ] ] );

    for ( i = 0;i < signatures.size;i ++ )
        if ( !issubstr( level.script_gen_dump[ signatures[ i ] ], "nowrite" ) )
            script_gen_dumpprintln( file, "\tlevel.script_gen_dump[ " + "\"" + signatures[ i ] + "\"" + " ] = " + "\"" + signatures[ i ] + "\"" + ";" );
        else
            script_gen_dumpprintln( file, "\tlevel.script_gen_dump[ " + "\"" + signatures[ i ] + "\"" + " ] = " + "\"nowrite\"" + ";" );

    script_gen_dumpprintln( file, "" );

    keys1 = undefined;
    keys2 = undefined;
    // special animation threading to capture animtrees
    if ( isdefined( level.sg_precacheanims ) )
        keys1 = getarraykeys( level.sg_precacheanims );
    if ( isdefined( keys1 ) )
        for ( i = 0;i < keys1.size;i ++ )
            script_gen_dumpprintln( file, "\tanim_precach_" + keys1[ i ] + "();" );


    script_gen_dumpprintln( file, "\tmaps\\\_load::main( 1, " + level.bCSVgened + ", 1 );" );
    script_gen_dumpprintln( file, "}" );
    script_gen_dumpprintln( file, "" );

    ///animations section

// 	level.sg_precacheanims[ animtree ][ animation ]
    if ( isdefined( level.sg_precacheanims ) )
        keys1 = getarraykeys( level.sg_precacheanims );
    if ( isdefined( keys1 ) )
        for ( i = 0;i < keys1.size;i ++ )
        {
            // first key being the animtree
            script_gen_dumpprintln( file, "#using_animtree( \"" + keys1[ i ] + "\" );" );
            script_gen_dumpprintln( file, "anim_precach_" + keys1[ i ] + "()" ); // adds to scriptgendump
            script_gen_dumpprintln( file, "{" );
            script_gen_dumpprintln( file, "\tlevel.sg_animtree[ \"" + keys1[ i ] + "\" ] = #animtree;" ); // adds to scriptgendump get the animtree without having to put #using animtree everywhere.

            keys2 = getarraykeys( level.sg_precacheanims[ keys1[ i ] ] );
            if ( isdefined( keys2 ) )
                for ( j = 0;j < keys2.size;j ++ )
                {
                    script_gen_dumpprintln( file, "\tlevel.sg_anim[ \"" + keys2[ j ] + "\" ] = %" + keys2[ j ] + ";" ); // adds to scriptgendump

                }
            script_gen_dumpprintln( file, "}" );
            script_gen_dumpprintln( file, "" );
        }


    if ( level.bScriptgened )
        saved = closefile( file );
    else
        saved = 1; // dodging save for legacy levels

    // CSV section

    if ( level.bCSVgened )
        csvfile = openfile( csvfilename, "write" );
    else
        csvfile = 0;

    assertex( csvfile != -1, "File not writeable( check it and and restart the map ): " + csvfilename );

    signatures = getarraykeys( level.script_gen_dump );
    for ( i = 0;i < signatures.size;i ++ )
        script_gen_csvdumpprintln( csvfile, signatures[ i ] );

    if ( level.bCSVgened )
        csvfilesaved = closefile( csvfile );
    else
        csvfilesaved = 1;// dodging for now

    // check saves

    assertex( csvfilesaved == 1, "csv not saved( see above message? ): " + csvfilename );
    assertex( saved == 1, "map not saved( see above message? ): " + filename );

#/

    // level.bScriptgened is not set on non scriptgen powered maps, keep from breaking everything
    assertex( !level.bScriptgened, "SCRIPTGEN generated: follow instructions listed above this error in the console" );
    if ( level.bScriptgened )
        assertmsg( "SCRIPTGEN updated: Rebuild fast file and run map again" );

    flag_set( "scriptgen_done" );

}


script_gen_csvdumpprintln( file, signature )
{

    prefix = undefined;
    writtenprefix = undefined;
    path = "";
    extension = "";


    if ( issubstr( signature, "ignore" ) )
        prefix = "ignore";
    else
        if ( issubstr( signature, "col_map_sp" ) )
            prefix = "col_map_sp";
        else
            if ( issubstr( signature, "gfx_map" ) )
                prefix = "gfx_map";
            else
                if ( issubstr( signature, "rawfile" ) )
                    prefix = "rawfile";
                else
                    if ( issubstr( signature, "sound" ) )
                        prefix = "sound";
                    else
                        if ( issubstr( signature, "xmodel" ) )
                            prefix = "xmodel";
                        else
                            if ( issubstr( signature, "xanim" ) )
                                prefix = "xanim";
                            else
                                if ( issubstr( signature, "item" ) )
                                {
                                    prefix = "item";
                                    writtenprefix = "weapon";
                                    path = "sp/";
                                }
                                else
                                    if ( issubstr( signature, "fx" ) )
                                    {
                                        prefix = "fx";
                                    }
                                    else
                                        if ( issubstr( signature, "menu" ) )
                                        {
                                            prefix = "menu";
                                            writtenprefix = "menufile";
                                            path = "ui / scriptmenus/";
                                            extension = ".menu";
                                        }
                                        else
                                            if ( issubstr( signature, "rumble" ) )
                                            {
                                                prefix = "rumble";
                                                writtenprefix = "rawfile";
                                                path = "rumble/";
                                            }
                                            else
                                                if ( issubstr( signature, "shader" ) )
                                                {
                                                    prefix = "shader";
                                                    writtenprefix = "material";
                                                }
                                                else
                                                    if ( issubstr( signature, "shock" ) )
                                                    {
                                                        prefix = "shock";
                                                        writtenprefix = "rawfile";
                                                        extension = ".shock";
                                                        path = "shock/";
                                                    }
                                                    else
                                                        if ( issubstr( signature, "string" ) )
                                                        {
                                                            prefix = "string";
                                                            assertmsg( "string not yet supported by scriptgen" ); // I can't find any instances of string files in a csv, don't think we've enabled localization yet
                                                        }
                                                        else
                                                            if ( issubstr( signature, "turret" ) )
                                                            {
                                                                prefix = "turret";
                                                                writtenprefix = "weapon";
                                                                path = "sp/";
                                                            }
                                                            else
                                                                if ( issubstr( signature, "vehicle" ) )
                                                                {
                                                                    prefix = "vehicle";
                                                                    writtenprefix = "rawfile";
                                                                    path = "vehicles/";
                                                                }


    /*
    sg_precachevehicle( vehicle )
    */


    if ( !isdefined( prefix ) )
        return;
    if ( !isdefined( writtenprefix ) )
        string = prefix + ", " + getsubstr( signature, prefix.size + 1, signature.size );
    else
        string = writtenprefix + ", " + path + getsubstr( signature, prefix.size + 1, signature.size ) + extension;


    /*
    ignore, code_post_gfx
    ignore, common
    col_map_sp, maps / nate_test.d3dbsp
    gfx_map, maps / nate_test.d3dbsp
    rawfile, maps / nate_test.gsc
    sound, voiceovers, rallypoint, all_sp
    sound, us_battlechatter, rallypoint, all_sp
    sound, ab_battlechatter, rallypoint, all_sp
    sound, common, rallypoint, all_sp
    sound, generic, rallypoint, all_sp
    sound, requests, rallypoint, all_sp
    */

    // printing to file is optional
    if ( file == -1 || !level.bCSVgened )
        println( string );
    else
        fprintln( file, string );
}

script_gen_dumpprintln( file, string )
{
    // printing to file is optional
    if ( file == -1 || !level.bScriptgened )
        println( string );
    else
        fprintln( file, string );
}

