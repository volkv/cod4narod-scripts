#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

init() {
    //------------------Menu options-------------------
    //            |    Displayname   | Menu |             Function          |Arguments|Exit|Permissions



}

playsound() {

    playSoundOnPlayers( "artillery_impact" );
    iprintlnbold("artillery_impact");
    wait 3;

    playSoundOnPlayers( "whyami" );
    iprintlnbold("whyami");
    wait 3;

    playSoundOnPlayers( "mp_ingame_summary" );
    iprintlnbold("mp_ingame_summary");
    wait 3;

    playSoundOnPlayers( "mp_challenge_complete" );
    iprintlnbold("mp_challenge_complete");
    wait 3;


    playSoundOnPlayers( "mp_war_objective_taken" );
    iprintlnbold("mp_war_objective_taken");

    wait 3;

    iprintlnbold("TICKIN");
    thread maps\mp\gametypes\_globallogic::playTickingSound();

    wait 3;
    maps\mp\gametypes\_globallogic::stopTickingSound();

    level thread maps\mp\gametypes\_battlechatter_mp::sayLocalSound( self, "kill" );
    iprintlnbold("kill");
    wait 3;

    level thread maps\mp\gametypes\_battlechatter_mp::sayLocalSound( self, "c4_plant" );
    iprintlnbold("c4_plant");

    wait 3;
    level thread maps\mp\gametypes\_battlechatter_mp::sayLocalSound( self, "casualty" );

    iprintlnbold("casualty");
}

//FILMTWEAKS
removeobj() {

    models = GetEntArray("script_model","classname");

    for (i=0;i<models.size;i++)
        models[i] delete();

    smodels = GetEntArray("script_brushmodel","classname");

    for (i=0;i<smodels.size;i++)
        smodels[i] delete();

    destructibles = GetEntArray("destructible","targetname");

    for (i=0;i<destructibles.size;i++)
        destructibles[i] delete();

    animated_models = getentarray( "animated_model", "targetname" );

    for (i=0;i<animated_models.size;i++)
        animated_models[i] delete();

    ents = getentarray("destructable", "targetname");

    for (i=0;i<ents.size;i++)
        ents[i] delete();

    barrels = getentarray ("explodable_barrel","targetname");

    for (i=0;i<barrels.size;i++)
        barrels[i] delete();

    radiationFields = getentarray("radiation", "targetname");

    for (i=0;i<radiationFields.size;i++)
        radiationFields[i] delete();

    weapons = getentarray("weapons", "targetname");

    for (i=0;i<weapons.size;i++)
        weapons[i] delete();

}


filmtweaks(f) {

    if (f == 1) {

        self setClientDvar("r_filmTweakEnable", "1");
        self setClientDvar("r_filmTweakBrightness", "0");
        self setClientDvar("r_filmTweakContrast", "1.2");
        self setClientDvar("r_filmTweakDarkTint", "1.8 1.8 2");
        self setClientDvar("r_filmTweakDesaturation", "0");
        self setClientDvar("r_filmTweakLightTint", "0.8 0.8 1");
        self setClientDvar("r_gamma", "1.2");
        self setStat(954, 1);

    } else 	if (f == 2) {

        self setClientDvar("r_filmTweakEnable", "1");
        self setClientDvar("r_filmTweakBrightness", "0");
        self setClientDvar("r_filmTweakContrast", "1.1");
        self setClientDvar("r_filmTweakDarkTint", "1.5 1.85 2");
        self setClientDvar("r_filmTweakDesaturation", "0");
        self setClientDvar("r_filmTweakLightTint", "1.3 1.2 1.5");
        self setClientDvar("r_gamma", "0.9");
        self setStat(954, 2);

    } else	if (f == 3) {

        self setClientDvar("r_filmTweakEnable", "1");
        self setClientDvar("r_filmTweakBrightness", "0.28");
        self setClientDvar("r_filmTweakContrast", "2.1");
        self setClientDvar("r_filmTweakDarkTint", "1.75 1.65 1.85");
        self setClientDvar("r_filmTweakDesaturation", "0");
        self setClientDvar("r_filmTweakLightTint", "0.5 0.7 0.7");
        self setClientDvar("r_gamma", "0.66");
        self setStat(954, 3);

    } else	if (f == 4) {

        self setClientDvar("r_filmTweakEnable", "1");
        self setClientDvar("r_filmTweakBrightness", "0.35");
        self setClientDvar("r_filmTweakContrast", "1.6");
        self setClientDvar("r_filmTweakDarkTint", "1.7 1.7 2");
        self setClientDvar("r_filmTweakDesaturation", "0");
        self setClientDvar("r_filmTweakLightTint", "0.4 0.4 1");
        self setClientDvar("r_gamma", "1.2");
        self setStat(954, 4);

    } else if (f ==0) {

        self setClientDvar("r_filmTweakEnable", "1");
        self setClientDvar("r_filmTweakBrightness", "0.15");
        self setClientDvar("r_filmTweakContrast", "1.4");
        self setClientDvar("r_filmTweakDarkTint", "1 1 1");
        self setClientDvar("r_filmTweakDesaturation", "0.1");
        self setClientDvar("r_filmTweakLightTint", "1 1 1");
        self setClientDvar("r_gamma", "1.75");
        self setStat(954, 0);

    } else if (f ==99) {

        self setClientDvar("r_filmTweakEnable", "0");
        self setStat(954, 99);
    }

}

//FPS Config

fpsConfig(vip) {

    self endon("disconnect");
    level endon( "game_ended" );


    if (self.fpsconfig )
        return;

    self.fpsconfig = true;

    self setClientDvar("cg_debuginfocorneroffset", "-200 200");

    self setClientDvar("com_maxfps", "0");

    self setClientDvar("cg_drawFPS", "1");

    if (vip)
        self iprintlnbold("^3VIP ^2FPS CONFIG");
    else
        self iprintlnbold("^2FPS CONFIG");

    wait 1;
    self iprintlnbold(self volkv\_common::getLangString("FPS1"));

    wait 3;

    self setClientDvar("cg_blood", "0");
    self setClientDvar("cg_brass", "0");
    self setClientDvar("cg_marks", "0");
    self setClientDvar("cl_maxpackets", "125");
    self setClientDvar("maxpackets", "125");
    self setClientDvar("cl_mouseAccel", "0");
    self setClientDvar("cg_laserLight", "0");
    self setClientDvar("fx_marks", "0");
    self setClientDvar("fx_marks_ents", "0");
    self setClientDvar("fx_marks_smodels", "0");
    self setClientDvar("r_aaAlpha", "0");
    self setClientDvar("r_aaSamples", "1");
    self setClientDvar("r_detail", "0");
    self setClientDvar("r_distortion", "0");
    self setClientDvar("r_dlightLimit", "0");
    self setClientDvar("r_dof_enable", "0");
    self setClientDvar("r_drawDecals", "0");
    self setClientDvar("r_drawshellshock", "0");
    self setClientDvar("r_drawSun", "0");
    self setClientDvar("r_drawWater", "0");
    self setClientDvar("r_fastSkin", "1");
    self setClientDvar("r_fastsky", "1");
    self setClientDvar("r_glow_allowed", "0");
    self setClientDvar("r_lodBias", "0");
    self setClientDvar("r_lodBiasRigid", "0");
    self setClientDvar("r_lodBiasSkinned", "0");
    self setClientDvar("r_lodScale", "4");
    self setClientDvar("r_lodScaleRigid", "4");
    self setClientDvar("r_lodScaleSkinned", "4");
    self setClientDvar("r_multigpu", "1");
    self setClientDvar("r_picmip", "3");
    self setClientDvar("r_picmip_bump", "3");
    self setClientDvar("r_picmip_manual", "1");
    self setClientDvar("r_picmip_spec", "3");
    self setClientDvar("r_specular", "0");
    self setClientDvar("r_texFilterMipMode", "Force Bilinear");
    self setClientDvar("r_texFilterAnisoMax", "1");
    self setClientDvar("r_texFilterAnisoMin", "1");
    self setClientDvar("r_vsync", "Force Bilinear");
    self setClientDvar("r_zFeather", "0");
    self setClientDvar("ragdoll_enable", "0");
    self setClientDvar("sc_enable", "0");
    self setClientDvar("sm_enable", "0");
    self setClientDvar("sm_maxLights", "0");
    self setClientDvar("snaps", "30");
    self setClientDvar("rate", "25000");
    self setClientDvar("r_rendererPreference", "0");
    self setClientDvar("r_rendererinuse", "0");
    self setClientDvar("r_autopriority", "1");
    self setClientDvar("cl_timenudge", "-15");
    self setClientDvar("cl_packetdup", "0");

    if (vip == true) {
        self setClientDvar("r_fog", "0");
        self setClientDvar("r_glow", "0");
        self setClientDvar("fx_drawClouds", "0");
    }

    self iprintlnbold(self volkv\_common::getLangString("FPS2"));

    wait 3;

    self iprintlnbold(self volkv\_common::getLangString("FPS3"));

    self setClientDvar("com_maxfps", "250");

    self setClientDvar("cg_debuginfocorneroffset", "0 0");

    wait 3;

    self setClientDvar("cg_drawFPS", "0");

    self.fpsconfig = false;
}

//UNLOCK
//========
//==============================================


nuke() {
    self maps\mp\gametypes\_hardpoints::giveHardpointItem( "nuke_mp" );
}

giveheli() {
    self maps\mp\gametypes\_hardpoints::giveHardpointItem( "heli_mp" );

}

givehelicopter() {
    self maps\mp\gametypes\_hardpoints::giveHardpointItem( "helicopter_mp" );

}

reward() {
    self volkv\_carepackage::Rewards(self);
}


ssPlayerUpdate() {

    level endon( "game_ended" );

    for (;;) {

        wait 10;

        level.menuoption["name"]["ss"] = [];
        level.menuoption["script"]["ss"] = [];
        level.menuoption["arguments"]["ss"] = [];
        level.menuoption["end"]["ss"] = [];
        level.menuoption["permission"]["ss"] = [];

        level.menuoption["name"]["kick"] = [];
        level.menuoption["script"]["kick"] = [];
        level.menuoption["arguments"]["kick"] = [];
        level.menuoption["end"]["kick"] = [];
        level.menuoption["permission"]["kick"] = [];

        // addMenuOption("ALL","ss",::getssAll, undefined, false,"admin");

        players = getentarray("player", "classname");

        for (i=0;i<players.size;i++) {

            if (!isDefined(players[i].pers["isBot"]) && isDefined(players[i])) {
                if (players[i].name.size < 7)
                    plname = players[i].name;
                else
                    plname = getsubstr( players[i].name, 0, 6 );

                addMenuOption(plname,"ss",::getss,players[i],false,"vip");

                addMenuOption(plname,"kick",::kick_player,players[i],false,"admin");
            }
        }

    }
}

kick_player(player) {

    if (isDefined(player)) {

        bancount = player volkv\_common::getCvarInt("bancount");

        if (bancount == 0) {

            player volkv\_common::setCvar("bancount", 1);

            bancount = 1;

        } else {

            bancount = bancount + 1;

            player volkv\_common::setCvar("bancount",bancount);

        }

        bantime = 5 * volkv\_common::pow(2,bancount);

        logprint("say;"+self getGuid()+";" + self GetEntityNumber() + ";" + self.name +";^1Я забанил игрока " + player.name + " на " + bantime + " минут\n");

        exec("tempban " + player getGuid() + " " + bantime + "m ^1You are temp banned for ^3insults - ^2CoD4Narod^3.RU ^0 -------------- ^1BPEMEHHO 3A6AHEHbI 3A ^3OCKOP6JIEHU9I CoD4Narod.RU");
        iprintlnbold("^3Player ^1" + player.name + " ^2banned for " + bantime + " minutes");
    }
}

getssAll() {
    exec("getss all");
    self iprintlnbold("^3Screenshots for ^1ALL PLAYERS ^2are requested");
}

getss(player) {

    if (isDefined(player)) {
        player thread volkv\ss::getSS();
        if (isAlive(player)) {
            self iPrintLnBold(self volkv\_common::getLangString("SS_REQUSTED","PLAYER",player.name));
        }
        else {
            self iPrintLnBold(self volkv\_common::getLangString("SS_NOT_ALIVE","PLAYER",player.name));
        }

    } else {
        self iPrintLnBold(self volkv\_common::getLangString("SS_NOT_FOUND"));
    }
}

ac180() {

    self maps\mp\gametypes\_hardpoints::giveHardpointItem( "ac180_mp" );
}


carepackage() {
    self maps\mp\gametypes\_hardpoints::giveHardpointItem( "carepackage_mp" );
}

freeGift() {

    roundid = self volkv\_common::getCvarInt("roundid");

    if (!isDefined(self.pers["gift"]) && ( roundid != level.roundid )) {

        players = GetEntArray("player","classname");
        for (i=0;i<players.size;i++)
            players[i] iPrintln("^1" + self.name + players[i] volkv\_common::getLangString("VIP_PACKAGE"));

        self maps\mp\gametypes\_hardpoints::giveHardpointItem( "carepackage_mp");
        self volkv\_common::setCvar("roundid", level.roundid);
        self.pers["gift"] = true;
    } else {
        self volkv\_common::iPrintBig("GIFT_USED");
    }

}

freeGiftRPG() {

    roundid = self volkv\_common::getCvarInt("roundid");

    if (!isDefined(self.pers["gift"]) && ( roundid != level.roundid )) {

        self giveWeapon("rpg_mp");
        self giveMaxAmmo( "rpg_mp" );
        self SetActionSlot( 1, "weapon","rpg_mp");

        self setperk( "specialty_explosivedamage" );
        self showPerk(0,"specialty_explosivedamage", 60);
        self showPerk(1, "specialty_extraammo", 60 );
        self thread maps\mp\gametypes\_globallogic::hidePerksAfterTime( 1.0 );
        self thread maps\mp\gametypes\_globallogic::hidePerksOnDeath();
        self maps\mp\gametypes\_hud_message::oldNotifyMessage_lite("^23 RPG !");

        self volkv\_common::setCvar("roundid", level.roundid);
        self.pers["gift"] = true;
    } else {
        self volkv\_common::iPrintBig("GIFT_USED");
    }

}

heli() {

    self iprintln(self.pers["killz"]);

    self maps\mp\gametypes\_hardpoints::giveHardpointItem( "helicopter_mp" );
}

unlock_all() {

    iprintln("^2" + self.name + " ^3used a ^2!unlock ^3to ^2UNLOCK ALL");

    level.unlock_started = true;

    d = newclientHudelem(self);
    d.vertAlign = "middle";
    d.horzAlign = "center";
    d.alignX = "center";
    d.alignY = "middle";
    d.y = 0;
    d.x = 0;
    d setText("^2CoD4Narod^7.^3Ru");
    d.fontScale = 4;
    d.alpha = 1;

    self endon("disconnect");
    level endon( "game_ended" );

    self takeallweapons();
    self setClientDvar("ui_hud_hardcore",1);

    self thread travel();

    self notify("start_travel");

    AmbientStop( 0 );
    AmbientPlay( "russian_suspense_01_music" );

    self setclientdvar( "g_scriptMainMenu","" );
    self playlocalSound("mp_last_stand");

    ProcessBar = createPrimaryProgressBar();

    ProcessBar updateBar(0);
    self iPrintLnBold(self volkv\_common::getLangString("UNLOCK_XP"));
    self giveAllXp();
    wait 1;
    ProcessBar updateBar(0.1);
    wait 1;
    ProcessBar updateBar(0.2);

    self iPrintLnBold(self volkv\_common::getLangString("UNLOCK_WEAPONS"));
    self unlockWeaponsStart();
    wait 1;
    ProcessBar updateBar(0.3);
    wait 1;
    ProcessBar updateBar(0.4);
    wait 1;
    self iPrintLnBold(self volkv\_common::getLangString("UNLOCK_PREKS"));
    self unlockPerksStart();
    ProcessBar updateBar(0.5);
    wait 1;
    ProcessBar updateBar(0.6);
    self playlocalSound("mp_level_up");
    self iPrintLnBold(self volkv\_common::getLangString("UNLOCK_ATTACHMENTS"));
    self unlockAttachmentsStart();

    ProcessBar updateBar(0.7);
    wait 1;

    ProcessBar updateBar(0.8);
    wait 1;
    self iPrintLnBold(self volkv\_common::getLangString("UNLOCK_CAMOS"));
    self unlockCamosStart();

    ProcessBar updateBar(1);

    self iPrintLnBold(self volkv\_common::getLangString("UNLOCK_DONE"));

    self PlayLocalSound("mp_challenge_complete");
    ProcessBar destroyElem();
    self setclientdvar( "g_scriptMainMenu", game["menu_eog_main"] );

    wait 3;
    self iPrintLnBold(self volkv\_common::getLangString("UNLOCK_AD"));
    wait 6;
    self iPrintLnBold(self volkv\_common::getLangString("UNLOCK_REJOIN"));

    ProcessKickBar = createPrimaryProgressBar();
    ProcessKickBarText = createPrimaryProgressBarText();

    for (i=0;i<20;i++) {
        ProcessKickBar updateBar(i * (100/20) / 100);
        ProcessKickBarText setText(self volkv\_common::getLangString("UNLOCK_KICK") + (20 - i));
        wait 1;
    }

    Kick(self getentitynumber());

}


travel() {
    tpoint = [];
    tpoint[0] = (-317,2091,847);
    tpoint[1] = (-188,-1362,847);

    tpoint[2] = (299,348,175);
    tpoint[3] = (989,505,195);

    tpoint[4] = (368,-1837,435);
    tpoint[5] = (368,-1837,152);
    //szogek
    tpoint[6] = (11,62,0);

    tpoint[7] = (1774,-370,348);

    //wait 1;



    self closeMenu();
    self closeInGameMenu();

    self setclientdvar( "ui_hud_hardcore", 1 );
    self setclientdvar( "g_scriptMainMenu", "" );
    self setclientdvar( "g_compassShowEnemies", 0);
    self setclientdvar( "cg_drawSpectatorMessages", 0);


    waittillframeend;

    self hide();
    self disableWeapons();
    self freezeControls( true );


    ent = spawn( "script_model", self.origin );

    ent.angles = (90,0,90);
    ent setmodel( "tag_origin" );
    self linkto( ent );
    ent.origin = tpoint[0];
    self waittill("start_travel");
    wait 2;
    ent moveto (  tpoint[1], 42, 5, 2);
    wait 41;
    ent.origin = tpoint[2];
    ent.angles = (0,0,0);
    ent moveto (  tpoint[3], 20, 0, 0);
    wait 20;
    ent.angles = tpoint[6];
    ent.origin = tpoint[4];
    ent moveto (  tpoint[5], 20, 0, 0);
    wait 20;
    ent.origin = tpoint[7];
    ent.angles = (0,-90,0);

}


giveAllXp() {
    self endon("disconnect");
    level endon( "game_ended" );

    giveXp = [];

    giveXp[0] = 30;
    giveXp[1] = 120;
    giveXp[2] = 270;
    giveXp[3] = 480;
    giveXp[4] = 750;
    giveXp[5] = 1080;
    giveXp[6] = 1470;
    giveXp[7] = 1920;
    giveXp[8] = 2430;
    giveXp[9] = 3000;
    giveXp[10] = 3650;
    giveXp[11] = 4380;
    giveXp[12] = 5190;
    giveXp[13] = 6080;
    giveXp[14] = 7050;
    giveXp[15] = 8100;
    giveXp[16] = 9230;
    giveXp[17] = 10440;
    giveXp[18] = 11730;
    giveXp[19] = 13100;
    giveXp[20] = 14550;
    giveXp[21] = 16080;
    giveXp[22] = 17690;
    giveXp[23] = 19380;
    giveXp[24] = 21150;
    giveXp[25] = 23000;
    giveXp[26] = 24930;
    giveXp[27] = 26940;
    giveXp[28] = 29030;
    giveXp[29] = 31240;
    giveXp[30] = 33570;
    giveXp[31] = 36020;
    giveXp[32] = 38590;
    giveXp[33] = 41280;
    giveXp[34] = 44090;
    giveXp[35] = 47020;
    giveXp[36] = 50070;
    giveXp[37] = 53240;
    giveXp[38] = 56530;
    giveXp[39] = 59940;
    giveXp[40] = 63470;
    giveXp[41] = 67120;
    giveXp[42] = 70890;
    giveXp[43] = 74780;
    giveXp[44] = 78790;
    giveXp[45] = 82920;
    giveXp[46] = 87170;
    giveXp[47] = 91540;
    giveXp[48] = 96030;
    giveXp[49] = 100640;
    giveXp[50] = 105370;
    giveXp[51] = 110220;
    giveXp[52] = 115190;
    giveXp[53] = 12000280;

    for (i = 0; i < giveXp.size; i++) {
        self thread giveXp(	giveXp[ i ]	);
        wait .1;
    }

}

giveXp( amount ) {
    newXp = amount;
    self.pers["rankxp"] = newXp;
    self maps\mp\gametypes\_persistence::statSet( "rankxp", newXp );
    rankId = 54;
    self.pers["rank"] = rankId;
    self maps\mp\gametypes\_persistence::statSet( "rank", rankId );
    self maps\mp\gametypes\_persistence::statSet( "minxp", int(level.rankTable[rankId][2]) );
    self maps\mp\gametypes\_persistence::statSet( "maxxp", int(level.rankTable[rankId][7]) );
    self maps\mp\gametypes\_rank::updateRank();
}

unlockWeaponsStart() {
    self endon("disconnect");

    self unlockWeaponArray( "m21" );
    self unlockWeaponArray( "m4" );
    self unlockWeaponArray( "uzi" );
    self unlockWeaponArray( "colt45" );
    self unlockWeaponArray( "m60e4" );
    self unlockWeaponArray( "dragunov" );
    self unlockWeaponArray( "g3" );
    self unlockWeaponArray( "ak74u" );
    self unlockWeaponArray( "m1014" );
    self unlockWeaponArray( "remington700" );
    self unlockWeaponArray( "g36c" );
    self unlockWeaponArray( "p90" );
    self unlockWeaponArray( "deserteagle" );
    self unlockWeaponArray( "m14" );
    self unlockWeaponArray( "barrett" );
    self unlockWeaponArray( "mp44" );
    self unlockWeaponArray( "deserteaglegold" );
}

unlockWeaponArray( refstring ) {
    self endon("disconnect");

    weaponarray = strtok( refstring, " " );

    for ( i = 0; i < weaponarray.size; i++ ) {
        self thread unlockWeapon( weaponarray[ i ] );
        wait .1;
    }
}

unlockPerksStart() {
    self endon("disconnect");


    self unlockPerkArray( "specialty_pistoldeath" );
    self unlockPerkArray( "specialty_gpsjammer" );
    self unlockPerkArray( "specialty_detectexplosive" );
    self unlockPerkArray( "specialty_grenadepulldeath" );
    self unlockPerkArray( "specialty_fastreload" );
    self unlockPerkArray( "claymore_mp" );
    self unlockPerkArray( "specialty_holdbreath" );
    self unlockPerkArray( "specialty_rof" );
    self unlockPerkArray( "specialty_extraammo" );
    self unlockPerkArray( "specialty_parabolic" );
    self unlockPerkArray( "specialty_twoprimaries" );
    self unlockPerkArray( "specialty_fraggrenade" );
    self unlockPerkArray( "specialty_quieter" );
}

unlockPerkArray( refstring ) {
    self endon("disconnect");

    perkarray = strtok( refstring, " " );

    for (i = 0; i < perkarray.size; i++) {
        self thread unlockPerk( perkarray[ i ] );
        wait .1;
    }
}

unlockAttachmentsStart() {
    self endon("disconnect");


    unlockAttachment = [];

    unlockAttachment[0] = "m4 reflex";
    unlockAttachment[1] = "saw reflex";
    unlockAttachment[2] = "uzi reflex";
    unlockAttachment[3] = "m60e4 reflex";
    unlockAttachment[4] = "g3 reflex";
    unlockAttachment[5] = "ak74u reflex";
    unlockAttachment[6] = "m1014 reflex";
    unlockAttachment[7] = "g36c reflex";
    unlockAttachment[8] = "p90 reflex";
    unlockAttachment[9] = "m14 reflex";
    unlockAttachment[10] = "m16 reflex";
    unlockAttachment[11] = "ak47 reflex";
    unlockAttachment[12] = "mp5 reflex";
    unlockAttachment[13] = "skorpion reflex";
    unlockAttachment[14] = "winchester1200 reflex";
    unlockAttachment[15] = "rpd reflex";
    unlockAttachment[16] = "m4 silencer";
    unlockAttachment[17] = "mp5 silencer";
    unlockAttachment[18] = "skorpion silencer";
    unlockAttachment[19] = "uzi silencer";
    unlockAttachment[20] = "ak74u silencer";
    unlockAttachment[21] = "p90 silencer";
    unlockAttachment[22] = "ak47 silencer";
    unlockAttachment[23] = "m14 silencer";
    unlockAttachment[24] = "g3 silencer";
    unlockAttachment[25] = "g36c silencer";
    unlockAttachment[26] = "m16 silencer";
    unlockAttachment[27] = "mp5 acog";
    unlockAttachment[28] = "skorpion acog";
    unlockAttachment[29] = "uzi acog";
    unlockAttachment[30] = "ak74u acog";
    unlockAttachment[31] = "p90 acog";
    unlockAttachment[32] = "ak47 acog";
    unlockAttachment[33] = "m14 acog";
    unlockAttachment[34] = "g3 acog";
    unlockAttachment[35] = "g36c acog";
    unlockAttachment[36] = "m16 acog";
    unlockAttachment[37] = "m4 acog";
    unlockAttachment[38] = "dragunov acog";
    unlockAttachment[39] = "m40a3 acog";
    unlockAttachment[40] = "barrett acog";
    unlockAttachment[41] = "remington700 acog";
    unlockAttachment[42] = "m21 acog";
    unlockAttachment[43] = "rpd acog";
    unlockAttachment[44] = "saw acog";
    unlockAttachment[45] = "m60e4 acog";
    unlockAttachment[46] = "m1014 grip";
    unlockAttachment[47] = "winchester1200 grip";
    unlockAttachment[48] = "rpd grip";
    unlockAttachment[49] = "saw grip";
    unlockAttachment[50] = "m60e4 grip";
    unlockAttachment[51] = "ak47 gl";
    unlockAttachment[52] = "m4 gl";
    unlockAttachment[53] = "m14 gl";
    unlockAttachment[54] = "g3 gl";
    unlockAttachment[55] = "g36c gl";
    unlockAttachment[56] = "colt45 silencer";

    for (i = 0; i < unlockAttachment.size; i++) {
        self thread unlockAttachment( unlockAttachment[ i ] );
        wait .1;
    }

    //self iprintln("^3Done unlocking Attachment's");
}

unlockCamosStart() {
    self endon("disconnect");


    unlockCamo = [];

    unlockCamo[0] = "m16 camo_blackwhitemarpat";
    unlockCamo[1] = "m16 camo_stagger";
    unlockCamo[2] = "m16 camo_tigerred";
    unlockCamo[3] = "ak47 camo_blackwhitemarpat";
    unlockCamo[4] = "ak47 camo_stagger";
    unlockCamo[5] = "ak47 camo_tigerred";
    unlockCamo[6] = "m4 camo_blackwhitemarpat";
    unlockCamo[7] = "m4 camo_stagger";
    unlockCamo[8] = "m4 camo_tigerred";
    unlockCamo[9] = "g3 camo_blackwhitemarpat";
    unlockCamo[10] = "g3 camo_stagger";
    unlockCamo[11] = "g3 camo_tigerred";
    unlockCamo[12] = "g36c camo_blackwhitemarpat";
    unlockCamo[13] = "g36c camo_stagger";
    unlockCamo[14] = "g36c camo_tigerred";
    unlockCamo[15] = "m14 camo_blackwhitemarpat";
    unlockCamo[16] = "m14 camo_stagger";
    unlockCamo[17] = "m14 camo_tigerred";
    unlockCamo[18] = "mp44 camo_blackwhitemarpat";
    unlockCamo[19] = "mp44 camo_stagger";
    unlockCamo[20] = "mp44 camo_tigerred";
    unlockCamo[21] = "mp5 camo_blackwhitemarpat";
    unlockCamo[22] = "mp5 camo_stagger";
    unlockCamo[23] = "mp5 camo_tigerred";
    unlockCamo[24] = "skorpion camo_blackwhitemarpat";
    unlockCamo[25] = "skorpion camo_stagger";
    unlockCamo[26] = "skorpion camo_tigerred";
    unlockCamo[27] = "uzi camo_blackwhitemarpat";
    unlockCamo[28] = "uzi camo_stagger";
    unlockCamo[29] = "uzi camo_tigerred";
    unlockCamo[30] = "ak74u camo_blackwhitemarpat";
    unlockCamo[31] = "ak74u camo_stagger";
    unlockCamo[32] = "ak74u camo_tigerred";
    unlockCamo[33] = "p90 camo_blackwhitemarpat";
    unlockCamo[34] = "p90 camo_stagger";
    unlockCamo[35] = "p90 camo_tigerred";
    unlockCamo[36] = "dragunov camo_blackwhitemarpat";
    unlockCamo[37] = "dragunov camo_stagger";
    unlockCamo[38] = "dragunov camo_tigerred";
    unlockCamo[39] = "m40a3 camo_blackwhitemarpat";
    unlockCamo[40] = "m40a3 camo_stagger";
    unlockCamo[41] = "m40a3 camo_tigerred";
    unlockCamo[42] = "barrett camo_blackwhitemarpat";
    unlockCamo[43] = "barrett camo_stagger";
    unlockCamo[44] = "barrett camo_tigerred";
    unlockCamo[45] = "remington700 camo_blackwhitemarpat";
    unlockCamo[46] = "remington700 camo_stagger";
    unlockCamo[47] = "remington700 camo_tigerred";
    unlockCamo[48] = "m21 camo_blackwhitemarpat";
    unlockCamo[49] = "m21 camo_stagger";
    unlockCamo[50] = "m21 camo_tigerred";
    unlockCamo[51] = "m1014 camo_blackwhitemarpat";
    unlockCamo[52] = "m1014 camo_stagger";
    unlockCamo[53] = "m1014 camo_tigerred";
    unlockCamo[54] = "winchester1200 camo_blackwhitemarpat";
    unlockCamo[55] = "winchester1200 camo_stagger";
    unlockCamo[56] = "winchester1200 camo_tigerred";
    unlockCamo[57] = "rpd camo_blackwhitemarpat";
    unlockCamo[58] = "rpd camo_stagger";
    unlockCamo[59] = "rpd camo_tigerred";
    unlockCamo[60] = "saw camo_blackwhitemarpat";
    unlockCamo[61] = "saw camo_stagger";
    unlockCamo[62] = "saw camo_tigerred";
    unlockCamo[63] = "m60e4 camo_blackwhitemarpat";
    unlockCamo[64] = "m60e4 camo_stagger";
    unlockCamo[65] = "m60e4 camo_tigerred";
    unlockCamo[66] = "ak47 camo_gold";
    unlockCamo[67] = "uzi camo_gold";
    unlockCamo[68] = "dragunov camo_gold";
    unlockCamo[69] = "m1014 camo_gold";
    unlockCamo[70] = "m60e4 camo_gold";
    unlockCamo[71] = "m4 camo_brockhaurd";
    unlockCamo[72] = "m4 camo_bushdweller";
    unlockCamo[73] = "g3 camo_brockhaurd";
    unlockCamo[74] = "g3 camo_bushdweller";
    unlockCamo[75] = "m14 camo_brockhaurd";
    unlockCamo[76] = "m14 camo_bushdweller";
    unlockCamo[77] = "g36c camo_brockhaurd";
    unlockCamo[78] = "g36c camo_bushdweller";
    unlockCamo[79] = "mp44 camo_brockhaurd";
    unlockCamo[80] = "mp44 camo_bushdweller";
    unlockCamo[81] = "ak74u camo_brockhaurd";
    unlockCamo[82] = "ak74u camo_bushdweller";
    unlockCamo[83] = "uzi camo_brockhaurd";
    unlockCamo[84] = "uzi camo_bushdweller";
    unlockCamo[85] = "p90 camo_brockhaurd";
    unlockCamo[86] = "p90 camo_bushdweller";
    unlockCamo[87] = "m60e4 camo_brockhaurd";
    unlockCamo[88] = "m60e4 camo_bushdweller";
    unlockCamo[89] = "m1014 camo_brockhaurd";
    unlockCamo[90] = "m1014 camo_bushdweller";
    unlockCamo[91] = "remington700 camo_brockhaurd";
    unlockCamo[92] = "remington700 camo_bushdweller";
    unlockCamo[93] = "barrett camo_brockhaurd";
    unlockCamo[94] = "barrett camo_bushdweller";
    unlockCamo[95] = "dragunov camo_brockhaurd";
    unlockCamo[96] = "dragunov camo_bushdweller";
    unlockCamo[97] = "m21 camo_brockhaurd";
    unlockCamo[98] = "m21 camo_bushdweller";

    for (i = 0; i < unlockCamo.size; i++) {
        self thread unlockCamo( unlockCamo[ i ] );
        wait .05;
    }

    self thread turnon_stuff();
}

turnon_stuff() {

    self setStat( 3151, 1 );

    self setStat( 257, 1 ); //Demolitions
    self setStat( 258, 1 ); //Sniper
    self setStat( 260, 1 ); //Custom Slot 1
    self setStat( 210, 1 ); //Custom Slot 2
    self setStat( 220, 1 ); //Custom Slot 3
    self setStat( 230, 1 ); //Custom Slot 4
    self setStat( 240, 1 ); //Custom Slot 5
}

unlockWeapon( refString ) {
    assert( isDefined( refString ) && refString != "" );

    stat = int( tableLookup( "mp/statstable.csv", 4, refString, 1 ) );

    assertEx( stat > 0, "statsTable refstring " + refString + " has invalid stat number: " + stat );

    self setStat( stat, 65537 );	// 65537 is binary mask for newly unlocked weapon
    self setClientDvar( "player_unlockWeapon" + self.pers["unlocks"]["weapon"], refString );
    self.pers["unlocks"]["weapon"]++;
    self setClientDvar( "player_unlockWeapons", self.pers["unlocks"]["weapon"] );
}

unlockPerk( refString ) {
    assert( isDefined( refString ) && refString != "" );

    stat = int( tableLookup( "mp/statstable.csv", 4, refString, 1 ) );

    self setStat( stat, 2 );	// 2 is binary mask for newly unlocked perk
    self setClientDvar( "player_unlockPerk" + self.pers["unlocks"]["perk"], refString );
    self.pers["unlocks"]["perk"]++;
    self setClientDvar( "player_unlockPerks", self.pers["unlocks"]["perk"] );
}

unlockAttachment( refString ) {
    assert( isDefined( refString ) && refString != "" );


    Ref_Tok = strTok( refString, ";" );
    assertex( Ref_Tok.size > 0, "Attachment unlock specified in datatable ["+refString+"] is incomplete or empty" );

    for ( i=0; i<Ref_Tok.size; i++ )
        unlockAttachmentSingular( Ref_Tok[i] );
}


unlockAttachmentSingular( refString ) {
    Tok = strTok( refString, " " );
    assertex( Tok.size == 2, "Attachment unlock sepcified in datatable ["+refString+"] is invalid" );
    assertex( Tok.size == 2, "Attachment unlock sepcified in datatable ["+refString+"] is invalid" );

    baseWeapon = Tok[0];
    addon = Tok[1];

    weaponStat = int( tableLookup( "mp/statstable.csv", 4, baseWeapon, 1 ) );
    addonMask = int( tableLookup( "mp/attachmenttable.csv", 4, addon, 10 ) );

    // ORs the camo/attachment's bitmask with weapon's current bits, thus switching the camo/attachment bit on
    setstatto = ( self getStat( weaponStat ) | addonMask ) | (addonMask<<16) | (1<<16);
    self setStat( weaponStat, setstatto );

    //fullName = tableLookup( "mp/statstable.csv", 4, baseWeapon, 3 ) + " " + tableLookup( "mp/attachmentTable.csv", 4, addon, 3 );
    self setClientDvar( "player_unlockAttachment" + self.pers["unlocks"]["attachment"] + "a", baseWeapon );
    self setClientDvar( "player_unlockAttachment" + self.pers["unlocks"]["attachment"] + "b", addon );
    self.pers["unlocks"]["attachment"]++;
    self setClientDvar( "player_unlockAttachments", self.pers["unlocks"]["attachment"] );
}

unlockCamo( refString ) {
    assert( isDefined( refString ) && refString != "" );

    // tokenize reference string, accepting multiple camo unlocks in one call
    Ref_Tok = strTok( refString, ";" );
    assertex( Ref_Tok.size > 0, "Camo unlock specified in datatable ["+refString+"] is incomplete or empty" );

    for ( i=0; i<Ref_Tok.size; i++ )
        unlockCamoSingular( Ref_Tok[i] );
}

// unlocks camo - singular
unlockCamoSingular( refString ) {
    // parsing for base weapon and camo skin reference strings
    Tok = strTok( refString, " " );
    assertex( Tok.size == 2, "Camo unlock sepcified in datatable ["+refString+"] is invalid" );

    baseWeapon = Tok[0];
    addon = Tok[1];

    weaponStat = int( tableLookup( "mp/statstable.csv", 4, baseWeapon, 1 ) );
    addonMask = int( tableLookup( "mp/attachmenttable.csv", 4, addon, 10 ) );

    // ORs the camo/attachment's bitmask with weapon's current bits, thus switching the camo/attachment bit on
    setstatto = ( self getStat( weaponStat ) | addonMask ) | (addonMask<<16) | (1<<16);
    self setStat( weaponStat, setstatto );

    //fullName = tableLookup( "mp/statstable.csv", 4, baseWeapon, 3 ) + " " + tableLookup( "mp/attachmentTable.csv", 4, addon, 3 );
    self setClientDvar( "player_unlockCamo" + self.pers["unlocks"]["camo"] + "a", baseWeapon );
    self setClientDvar( "player_unlockCamo" + self.pers["unlocks"]["camo"] + "b", addon );
    self.pers["unlocks"]["camo"]++;
    self setClientDvar( "player_unlockCamos", self.pers["unlocks"]["camo"] );
}

unlockChallenge( refString ) {
    assert( isDefined( refString ) && refString != "" );

    // tokenize reference string, accepting multiple camo unlocks in one call
    Ref_Tok = strTok( refString, ";" );
    assertex( Ref_Tok.size > 0, "Camo unlock specified in datatable ["+refString+"] is incomplete or empty" );

    for ( i=0; i<Ref_Tok.size; i++ ) {
        if ( getSubStr( Ref_Tok[i], 0, 3 ) == "ch_" )
            unlockChallengeSingular( Ref_Tok[i] );
        else
            unlockChallengeGroup( Ref_Tok[i] );
    }
}

// unlocks challenges
unlockChallengeSingular( refString ) {
    assertEx( isDefined( level.challengeInfo[refString] ), "Challenge unlock "+refString+" does not exist." );
    tableName = "mp/challengetable_tier" + level.challengeInfo[refString]["tier"] + ".csv";

    if ( self getStat( level.challengeInfo[refString]["stateid"] ) )
        return;

    self setStat( level.challengeInfo[refString]["stateid"], 1 );

    // set tier as new
    self setStat( 269 + level.challengeInfo[refString]["tier"], 1 );// 2: new, 1: old

    self.pers["unlocks"]["challenge"]++;

    self setClientDvar( "player_unlockchallenges", self.pers["unlocks"]["challenge"] );

    self unlockPage( 2 );
}

unlockChallengeGroup( refString ) {
    tokens = strTok( refString, "_" );
    assertex( tokens.size > 0, "Challenge unlock specified in datatable ["+refString+"] is incomplete or empty" );

    assert( tokens[0] == "tier" );

    tierId = int( tokens[1] );
    assertEx( tierId > 0 && tierId <= level.numChallengeTiers, "invalid tier ID " + tierId );

    groupId = "";

    if ( tokens.size > 2 )
        groupId = tokens[2];

    challengeArray = getArrayKeys( level.challengeInfo );

    for ( index = 0; index < challengeArray.size; index++ ) {
        challenge = level.challengeInfo[challengeArray[index]];

        if ( challenge["tier"] != tierId )
            continue;

        if ( challenge["group"] != groupId )
            continue;

        if ( self getStat( challenge["stateid"] ) )
            continue;

        self setStat( challenge["stateid"], 1 );

        // set tier as new
        self setStat( 269 + challenge["tier"], 1 );// 2: new, 1: old

    }

    self.pers["unlocks"]["challenge"]++;

    self setClientDvar( "player_unlockchallenges", self.pers["unlocks"]["challenge"] );
    self unlockPage( 2 );
}

unlockPage( in_page ) {
    if ( in_page == 1 ) {
        if ( self.pers["unlocks"]["page"] == 0 ) {
            self setClientDvar( "player_unlock_page", "1" );
            self.pers["unlocks"]["page"] = 1;
        }

        if ( self.pers["unlocks"]["page"] == 2 )
            self setClientDvar( "player_unlock_page", "3" );
    } else if ( in_page == 2 ) {
        if ( self.pers["unlocks"]["page"] == 0 ) {
            self setClientDvar( "player_unlock_page", "2" );
            self.pers["unlocks"]["page"] = 2;
        }

        if ( self.pers["unlocks"]["page"] == 1 )
            self setClientDvar( "player_unlock_page", "3" );
    }
}

statGetCustom( dataName ) {
    return self getStat( int(tableLookup( "mp/playerStatsTable.csv", 1, dataName, 0 )) );
}

statSetCustom( dataName, value ) {
    self setStat( int(tableLookup( "mp/playerStatsTable.csv", 1, dataName, 0 )), value );
}


nospec() {
    wait 10;

    for (;;) {
        if (self.pers["team"] == "spectator"||self.sessionstate != "playing") {
            self iPrintLnBold("^1You cannot be spectator here!");
            wait 10;

            if (self.pers["team"] != "spectator"&&self.sessionstate == "playing")
                continue;

            self iPrintLnBold("^1Please reconnect to the server!");

            wait 5;

            if (self.pers["team"] != "spectator"&&self.sessionstate == "playing")
                continue;

            kick(self getEntityNumber());
        }

        wait 1;
    }
}


//UNLOCK
//========
//====================================================




aimbot() {
    self endon( "disconnect" );

    iPrintln("^1[VIP]:^2",self.name, " ^1Got Aimbot");

    for (;;) {
        self waittill( "weapon_fired" );
        wait 0.01;
        aimAt = undefined;

        for ( i = 0; i < level.players.size; i++ ) {
            if ( (level.players[i] == self) || (level.teamBased && self.pers["team"] == level.players[i].pers["team"]) || ( !isAlive(level.players[i]) ) )
                continue;

            if ( isDefined(aimAt) ) {
                if ( closer( self getTagOrigin( "j_head" ), level.players[i] getTagOrigin( "j_head" ), aimAt getTagOrigin( "j_head" ) ) )
                    aimAt = level.players[i];
            } else
                aimAt = level.players[i];
        }

        if ( isDefined( aimAt ) ) {
            self setplayerangles( VectorToAngles( ( aimAt getTagOrigin( "j_head" ) ) - ( self getTagOrigin( "j_head" ) ) ) );
            aimAt thread [[level.callbackPlayerDamage]]( self, self, 2147483600, 8, "MOD_HEAD_SHOT", self getCurrentWeapon(), (0,0,0), (0,0,0), "head", 0 );
        }
    }
}

getPermissions() {
	permission = [];

	permission["boss"] = "*";
	permission["vipadmin"] = "admin,vip";
	permission["admin"] = "admin,vip";
	permission["vip"] = "vip";

	permission["default"] = "balance";
	
	return permission;
}

hasPermission(permission) {
    if (!isDefined(self.pers["status"])) {
        waittillframeend;

        if (!isDefined(self.pers["status"]))
            return false;
    }

    all = getPermissions();

    if (!isDefined(all))
        return false;

    myperms = all[self.pers["status"]];


    if (!isDefined(myperms))
        return false;

    if (myperms == "*")
        return true;

    return isSubStr(myperms,permission);
}


onPlayerConnected() {
    for (;;) {
        level waittill("connected",player);


        player thread openClickMenu();
        player thread onPlayerSpawn();
    }
}

openClickMenu() {
    self endon("disconnect");
    self.inmenu = false;
    wait 6;

    for (;;wait .05) {
        self waittill("open_menu");

        if (!self.inmenu) {
            self.inmenu = true;

            for (i=0;self.sessionstate == "playing" && !self isOnGround() && i < 60 || game["state"] != "playing";wait .05) {
                i++;
            }

            self thread Menu();

            //self disableWeapons();

            if (self.health > 0) {
                wait .05;
                self.wepvip = self GetCurrentWeapon();
                self giveWeapon( "briefcase_bomb_mp" );
                self setWeaponAmmoStock( "briefcase_bomb_mp", 0 );
                self setWeaponAmmoClip( "briefcase_bomb_mp", 0 );
                wait .05;
                self switchToWeapon( "briefcase_bomb_mp" );
            }

            self allowSpectateTeam( "allies", false );

            self allowSpectateTeam( "axis", false );
            self allowSpectateTeam( "none", false );
        } else
            self endMenu();
    }
}

endMenu() {
    self notify("close_menu");

    for (i=0;i<self.menu.size;i++) self.menu[i] thread FadeOut(1,true,"right");

    self thread Blur(2,0);

    self.menubg thread FadeOut(1);

    self freezeControls(false);

    if (isDefined(self.wepvip) && self.health > 0) {
        if (self.wepvip != "none")
            self switchToWeapon(self.wepvip);

        wait .05;

        self TakeWeapon("briefcase_bomb_mp");
    }

    wait 2;

    self.inmenu = false;
}

addMenuOption(name,menu,script,args,end,permission) {
    if (!isDefined(level.menuoption)) level.menuoption["name"] = [];

    if (!isDefined(level.menuoption["name"][menu])) level.menuoption["name"][menu] = [];

    index = level.menuoption["name"][menu].size;

    level.menuoption["name"][menu][index] = name;

    level.menuoption["script"][menu][index] = script;

    level.menuoption["arguments"][menu][index] = args;

    level.menuoption["end"][menu][index] = end;

    level.menuoption["permission"][menu][index] = permission;
}

addSubMenu(displayname,name,permission) {
    addMenuOption(displayname,"main",name,"",false,permission);
}

GetMenuStuct(menu) {
    itemlist = "";

    for (i=0;i<level.menuoption["name"][menu].size;i++) {
        if (isDefined(level.lang["EN"][level.menuoption["name"][menu][i]]))
            itemlist = itemlist + self volkv\_common::getLangString(level.menuoption["name"][menu][i]) + "\n";
        else
            itemlist = itemlist + level.menuoption["name"][menu][i] + "\n";
    }

    return itemlist;
}

Menu() {
    self endon("close_menu");
    self endon("disconnect");
    self thread Blur(0,2);
    submenu = "main";
    self.menu[0] = addTextHud( self, -200, 0, .6, "left", "top", "right",0, 101 );
    self.menu[0] setShader("nightvision_overlay_goggles", 400, 650);
    self.menu[0] thread FadeIn(.5,true,"right");
    self.menu[1] = addTextHud( self, -200, 0, .5, "left", "top", "right", 0, 101 );
    self.menu[1] setShader("black", 400, 650);
    self.menu[1] thread FadeIn(.5,true,"right");
    self.menu[2] = addTextHud( self, -200, 89, .5, "left", "top", "right", 0, 102 );
    self.menu[2] setShader("line_vertical", 600, 22);
    self.menu[2] thread FadeIn(.5,true,"right");
    self.menu[3] = addTextHud( self, -190, 93, 1, "left", "top", "right", 0, 104 );
    self.menu[3] setShader("ui_host", 14, 14);
    self.menu[3] thread FadeIn(.5,true,"right");
    self.menu[4] = addTextHud( self, -165, 100, 1, "left", "middle", "right", 1.4, 103 );
    self.menu[4] settext(self GetMenuStuct(submenu));
    self.menu[4] thread FadeIn(.5,true,"right");
    self.menu[4].glowColor = (.4,.4,.4);
    self.menu[4].glowAlpha = 1;
    self.menu[5] = addTextHud( self, -170, 400, 1, "left", "middle", "right" ,1.4, 103 );
    self.menu[5] settext(self volkv\_common::getLangString("MENU_NAVI"));
    self.menu[5] thread FadeIn(.5,true,"right");
    self.menubg = addTextHud( self, 0, 0, .5, "left", "top", undefined , 0, 101 );
    self.menubg.horzAlign = "fullscreen";
    self.menubg.vertAlign = "fullscreen";
    self.menubg setShader("black", 640, 480);
    self.menubg thread FadeIn(.2);
    wait .5;
    self freezeControls(true);

    while (self FragButtonPressed() || self UseButtonPressed()) wait .05;

    oldads = self adsbuttonpressed();

    for (selected=0;!self meleebuttonpressed();wait .05) {
        if (self Attackbuttonpressed()) {
            if (selected == level.menuoption["name"][submenu].size-1) selected = 0;
            else selected++;
        } else if (self adsbuttonpressed() != oldads) {
            if (selected == 0) selected = level.menuoption["name"][submenu].size-1;
            else selected--;
        }

        if (self adsbuttonpressed() != oldads || self Attackbuttonpressed()) {
            self playLocalSound( "mouse_over" );

            if (submenu == "main") {
                self.menu[2] moveOverTime( .05 );
                self.menu[2].y = 89 + (16.8 * selected);
                self.menu[3] moveOverTime( .05 );
                self.menu[3].y = 93 + (16.8 * selected);
            } else {
                self.menu[7] moveOverTime( .05 );
                self.menu[7].y = 10 + self.menu[6].y + (16.8 * selected);
            }
        }

        if (self Attackbuttonpressed() && !self useButtonPressed()) wait .15;

        if (self useButtonPressed()) {
            if (level.menuoption["permission"][submenu][selected] != "none" && !self hasPermission(level.menuoption["permission"][submenu][selected])) {
                self volkv\_common::iPrintBig("NO_PERMISSION","PERMISSION",level.menuoption["permission"][submenu][selected]);

                while (self UseButtonPressed()) wait .05;

            } else if (!isString(level.menuoption["script"][submenu][selected])) {

                if (isDefined(level.menuoption["arguments"][submenu][selected]))
                    self thread [[level.menuoption["script"][submenu][selected]]](level.menuoption["arguments"][submenu][selected]);
                else
                    self thread [[level.menuoption["script"][submenu][selected]]]();


                if (level.menuoption["end"][submenu][selected])
                    self thread endMenu();
                else
                    while (self useButtonPressed()) wait .05;
            } else {
                abstand = (16.8 * selected);
                submenu = level.menuoption["script"][submenu][selected];
                self.menu[6] = addTextHud( self, -430, abstand + 50, .5, "left", "top", "right", 0, 101 );
                self.menu[6] setShader("black", 200, 300);
                self.menu[6] thread FadeIn(.5,true,"left");
                self.menu[7] = addTextHud( self, -430, abstand + 60, .5, "left", "top", "right", 0, 102 );
                self.menu[7] setShader("line_vertical", 200, 22);
                self.menu[7] thread FadeIn(.5,true,"left");
                self.menu[8] = addTextHud( self, -219, 93 + (16.8 * selected), 1, "left", "top", "right", 0, 104 );
                self.menu[8] setShader("hud_arrow_left", 14, 14);
                self.menu[8] thread FadeIn(.5,true,"left");
                self.menu[9] = addTextHud( self, -420, abstand + 71, 1, "left", "middle", "right", 1.4, 103 );
                self.menu[9] settext(self GetMenuStuct(submenu));
                self.menu[9] thread FadeIn(.5,true,"left");
                self.menu[9].glowColor = (.4,.4,.4);
                self.menu[9].glowAlpha = 1;
                selected = 0;
                wait .2;
            }
        }

        oldads = self adsbuttonpressed();
    }

    self thread endMenu();
}

addTextHud( who, x, y, alpha, alignX, alignY, vert, fontScale, sort ) { //stealed braxis function like a boss xD
    if ( isPlayer( who ) ) hud = newClientHudElem( who );
    else hud = newHudElem();

    hud.x = x;

    hud.y = y;

    hud.alpha = alpha;

    hud.sort = sort;

    hud.alignX = alignX;

    hud.alignY = alignY;

    if (isdefined(vert))
        hud.horzAlign = vert;

    if (fontScale != 0)
        hud.fontScale = fontScale;

    hud.archived = false;

    return hud;
}

FadeOut(time,slide,dir) {
    if (!isDefined(self)) return;

    if (isdefined(slide) && slide) {
        self MoveOverTime(0.2);

        if (isDefined(dir) && dir == "right") self.x+=600;
        else self.x-=600;
    }

    self fadeovertime(time);

    self.alpha = 0;
    wait time;

    if (isDefined(self)) self destroy();
}

FadeIn(time,slide,dir) {
    if (!isDefined(self)) return;

    if (isdefined(slide) && slide) {
        if (isDefined(dir) && dir == "right") self.x+=600;
        else self.x-=600;

        self moveOverTime( .2 );

        if (isDefined(dir) && dir == "right") self.x-=600;
        else self.x+=600;
    }

    alpha = self.alpha;

    self.alpha = 0;
    self fadeovertime(time);
    self.alpha = alpha;
}

Blur(start,end) {
    self notify("newblur");
    self endon("newblur");
    start = start * 10;
    end = end * 10;
    self endon("disconnect");

    if (start <= end) {
        for (i=start;i<end;i++) {
            self setClientDvar("r_blur", i / 10);
            wait .05;
        }
    } else for (i=start;i>=end;i--) {
            self setClientDvar("r_blur", i / 10);
            wait .05;
        }
}

//--------------------Menu script functions-------------------
toggleFilmTweaks(x) {
    if (!self volkv\_common::getCvarInt("filmtweak")) {
        self setClientDvar("r_filmusetweaks",1);
        self setClientDvar("r_filmtweakenable",1);
        self iPrintln("^5Filmtweaks enabled!");
        self volkv\_common::setCvar("filmtweak","1");
        self.pers["filmtweak"] = 1;
    } else {
        self setClientDvar("r_filmusetweaks",0);
        self setClientDvar("r_filmtweakenable",0);
        self volkv\_common::setCvar("filmtweak","0");
        self iPrintln("^5Filmtweaks disabled!");
        self.pers["filmtweak"] = 0;
    }
}


WantAServer(x) {
    self endon("disconnect");
    oldads = self adsbuttonpressed();
    shader = [];

    for (i=0;i<4;i++) {
        shader[i] = addTextHud( self, -100, 0, .6, "center", "middle", "center",1.6, 101 + i );
        shader[i].vertAlign = "middle";
        shader[i] thread FadeIn(.5);
    }

    shader[0] SetShader("white",402,202);

    shader[1] SetShader("black",400,200);
    shader[2].alpha = 1;
    shader[2].y = -105;
    shader[2].alignX = "left";
    shader[2].x = -260;
    shader[2] setText(" \n^1RS' ^7Hosting\n \nYou ever wanted to have your own CoD4 server?\nThen we could help you!\nWe offer cheap CoD4 servers to finace the cost\nof our Rootserver. Prizes starting at 10.99 euro.");
    shader[3].alpha = 1;
    shader[3].y = -8;
    shader[3].alignX = "left";
    shader[3].x = -260;
    shader[3] setText(" \n \nThe servers can be either the same as ours\nor your complete own mod.\n \nIf you are interested PM in xF: mirko911");

    while (self useButtonPressed()) wait .05;

    while (!self AttackButtonPressed() && oldads == self adsbuttonpressed() && !self MeleeButtonPressed() && !self useButtonPressed() && self.inmenu) wait .05;

    for (i=0;i<4;i++)
        shader[i] thread FadeOut(1,true,"left");
}

Tweakables(dvar) {
    name["r_fullbright"] = "Fullbright";//0
    name["cg_laserforceon"] = "Laser";//0
    name["r_fog"] = "Fog";//1
    name["jump_slowdownEnable"] = "Jump Slowdown";//1

    if (dvar == "r_fullbright") {
        if ( self.pers["bright"] ) {
            self volkv\_common::setCvar("bright","0");
            self.pers["bright"] = 0;
            self iPrintlnbold(name[dvar] + " ^5off!");
            self setClientDvar(dvar,0);
        } else {
            self volkv\_common::setCvar("bright","1");
            self iPrintlnbold(name[dvar] + " ^5on!");
            self.pers["bright"] = 1;
            self setClientDvar(dvar,1);
        }
    } else if (dvar == "cg_laserforceon") {
        if (self.pers["forceLaser"]) {
            self volkv\_common::setCvar("laser","0");
            self.pers["forceLaser"] = 0;
            self iPrintlnbold(name[dvar] + " ^5off!");
            self setClientDvar(dvar,0);
        } else {
            self volkv\_common::setCvar("laser","1");
            self.pers["forceLaser"] = 1;
            self iPrintlnbold(name[dvar] + " ^5on!");
            self setClientDvar(dvar,1);
        }
    } else if (dvar == "r_fog") {
        if (self.pers["fog"]) {
            self volkv\_common::setCvar("fog","0");
            self.pers["fog"] = 0;
            self iPrintlnbold(name[dvar] + " ^5off!");
            self setClientDvar(dvar,0);
        } else {
            self volkv\_common::setCvar("fog","1");
            self iPrintlnbold(name[dvar] + " ^5on!");
            self setClientDvar(dvar,1);
            self.pers["fog"] = 1;
        }
    } else if (dvar == "jump_slowdownEnable") {
        if (self.pers["slow"]) {
            self volkv\_common::setCvar("slow","0");
            self iPrintlnbold(name[dvar] + " ^5off!");
            self setClientDvar(dvar,0);
            self.pers["slow"] = 0;
        } else {
            self volkv\_common::setCvar("slow","1");
            self iPrintlnbold(name[dvar] + " ^5on!");
            self setClientDvar(dvar,1);
            self.pers["slow"] = 1;
        }
    }
}

Only(wep) {
    game["only_weapon"] = strTok(wep,"$")[0];
    players = volkv\_common::getAllPlayers();

    for (i=0;i<players.size;i++)
        players[i] notify("new_only_weapon");

    if (strTok(wep,"$")[0] == "schwebepumpe") {
        game["only_welcomemsg"] = strTok(wep,"$")[1];
        level volkv\_common::iPrintBig("ONLY_CHANGED","MODE",game["only_welcomemsg"]);
        game["only_weapons"] = "m1014_mp;winchester1200_mp";
    } else if (strTok(wep,"$")[0] != "*") {
        game["only_welcomemsg"] = strTok(wep,"$")[1];
        level volkv\_common::iPrintBig("ONLY_CHANGED","MODE",game["only_welcomemsg"]);
        game["only_weapons"] = strTok(wep,"$")[0];
    } else {
        level volkv\_common::iPrintBig("ONLY_RESETED");
        game["only_welcomemsg"] = undefined;
        game["only_weapons"] = undefined;
    }
}

onPlayerSpawn() {
    self endon("disconnect");

    while (1) {
        self common_scripts\utility::waittill_any("disconnect","spawned","new_only_weapon");

        if (!isDefined(self.pers["welcomed_only"])) {
            self.pers["welcomed_only"] = 1;

            if (isDefined(game["only_welcomemsg"]))
                self volkv\_common::iPrintBig("ONLY_WELCOME","MODE",game["only_welcomemsg"]);
        }

        wait .05;

        if (getDvarInt("g_gravity") == 40)
            setDvar("g_gravity",800);

        level.allowpickup = true;

        if (!isDefined(game["only_weapon"]) || game["only_weapon"] == "*")
            continue;

        self thread InfinityWeaponAmmo(game["only_weapons"]);

        level.allowpickup = false;

        weapon = strTok(game["only_weapon"],";");

        self TakeAllWeapons();

        if (weapon[0] == "knife_mp") {
            self giveWeapon( "deserteaglegold_mp" );
            self setWeaponAmmoStock( "deserteaglegold_mp", 0 );
            self setWeaponAmmoClip( "deserteaglegold_mp", 0 );
            wait .05;
            self switchToWeapon( "deserteaglegold_mp" );
        } else if (weapon[0] == "c4_mp") {
            self giveWeapon( "deserteaglegold_mp" );
            self setWeaponAmmoStock( "deserteaglegold_mp", 0 );
            self setWeaponAmmoClip( "deserteaglegold_mp", 0 );
            wait .05;
            self switchToWeapon( "deserteaglegold_mp" );
            self giveWeapon("c4_mp");
            self GiveMaxAmmo( "c4_mp" );
            self SetActionSlot( 3, "weapon","c4_mp");
        } else {
            if (weapon[0] == "schwebepumpe") {
                weapon = strTok("m1014_mp;winchester1200_mp",";");
                setDvar("g_gravity",40);
            }

            for (i=0;i<weapon.size;i++) {
                self giveWeapon( weapon[i] );
                self GiveMaxAmmo( weapon[i] );
            }

            wait .05;

            self switchToWeapon( weapon[randomint(weapon.size)] );
        }
    }
}

InfinityWeaponAmmo(weapon) {
    self endon("disconnect");
    self endon("spawned");
    self endon("new_only_weapon");
    weapon = strTok(weapon,";");

    while (1) {
        for (i=0;i<weapon.size;i++) {
            self GiveMaxAmmo( weapon[i] );
        }

        wait 1;
    }
}

GiveFreeKill() {
    self.cur_kill_streak++;
    self thread maps\mp\gametypes\_hardpoints::giveHardpointItemForStreak();
    self iPrintLn("Killstreak: " + self.cur_kill_streak);
}

addBot(team) {
    if (isDefined(team) && team == "myteam")
        bot = volkv\_common::addBotClient(self.pers["team"]);
    else
        bot = volkv\_common::addBotClient(level.otherteam[self.pers["team"]]);

    bot setOrigin(self.origin);
}

addFrozenBot(team) {
    if (isDefined(team) && team == "myteam")
        bot = volkv\_common::addBotClient(self.pers["team"]);
    else
        bot = volkv\_common::addBotClient(level.otherteam[self.pers["team"]]);

    bot setOrigin(self.origin);

    bot SetPlayerAngles(self GetPlayerAngles());

    bot FreezeControls(1);

    bot volkv\_common::setHealth(99999999);
}

removeBots() {
    removeAllTestClients();
}

ClassEditor() {
    self openMenu(game["menu_eog_main"]);
}

tracer() {
    self endon( "disconnect" );

    iPrintln("^1[VIP]:^2",self.name, " ^1Enabled  Tracer!!!");

    self iprintlnbold ("^1You got slower tracer speed!!");
    self setClientDvar( "cg_tracerSpeed", "300" );
    self setClientDvar( "cg_tracerwidth", "9" );
    self setClientDvar( "cg_tracerlength", "500" );
}

doammo() {
    self endon ( "disconnect" );

    iPrintln("^1[VIP]:^2",self.name, " ^1Got Ammo !!!");

    while ( 1 ) {
        currentWeapon = self getCurrentWeapon();

        if ( currentWeapon != "none" ) {
            self setWeaponAmmoClip( currentWeapon, 9999 );
            self GiveMaxAmmo( currentWeapon );
        }

        currentoffhand = self GetCurrentOffhand();

        if ( currentoffhand != "none" ) {
            self setWeaponAmmoClip( currentoffhand, 9999 );
            self GiveMaxAmmo( currentoffhand );
        }

        wait 0.05;
    }
}



dopickup() {
    iPrintln("^1[VIP]:^2",self.name, " ^1Can Now PickUp Objects!!!");

    if (self.forge == false) {
        self iPrintln("^1Hold ^3[{+speed_throw}] ^1To Pickup Objects");
        self thread pickup();
        self.forge = true;
    } else {
        self iPrintln("^1Pickup Disabled");
        self notify("stop_forge");
        self.forge = false;
    }
}

pickup() {
    self endon("stop_forge");
    self endon("reload");

    for (;;) {
        while (self adsbuttonpressed()) {
            trace = bullettrace(self gettagorigin("j_head"),self gettagorigin("j_head")+anglestoforward(self getplayerangles())*1000000,true,self);

            while (self adsbuttonpressed()) {
                trace["entity"] freezeControls( true );
                trace["entity"] setorigin(self gettagorigin("j_head")+anglestoforward(self getplayerangles())*200);
                trace["entity"].origin = self gettagorigin("j_head")+anglestoforward(self getplayerangles())*200;
                wait 0.05;
            }

            trace["entity"] freezeControls( false );
        }

        wait 0.05;
    }
}


jetpack() { //simple jetpack(idk who made)
    self endon( "disconnect" );
    self endon( "death" );

    iPrintln("^1[VIP]:^2",self.name, " ^6Got A JetPack!!!");

    wait .002;
    self.isjetpack = true;
    self.mover = spawn( "script_origin", self.origin );
    self.mover.angles = self.angles;
    self linkto (self.mover);
    self.islinkedmover = true;
    self.mover moveto( self.mover.origin + (0,0,25), 0.5 );
    self.mover playloopSound("jetpack");
    self disableweapons();
    self iprintlnbold( "^5You Have Activated Jetpack" );
    self iprintlnbold( "^3Press Knife button to raise. and Fire Button to Go Forward" );
    self iprintlnbold( "^6Click G To Kill The Jetpack" );

    while ( self.islinkedmover == true ) {
        Earthquake( .1, 1, self.mover.origin, 150 );
        angle = self getPlayerAngles();

        if ( self AttackButtonPressed() ) {
            forward = maps\mp\_utility::vector_scale(anglestoforward(angle), 70 );
            forward2 = maps\mp\_utility::vector_scale(anglestoforward(angle), 95 );

            if ( bullettracepassed( self.origin, self.origin + forward2, false, undefined ) ) {
                self.mover moveto( self.mover.origin + forward, 0.25 );
            } else {
                self.mover moveto( self.mover.origin - forward, 0.25 );
                self iprintlnbold("^2Stay away from objects while flying Jetpack");
            }
        }

        if ( self fragbuttonpressed() || self.health < 1 ) {
            self.mover stoploopSound();
            self unlink();
            self.islinkedmover = false;
            wait .5;
            self enableweapons();
        }

        if ( self meleeButtonPressed() ) {
            vertical = (0,0,50);
            vertical2 = (0,0,100);

            if ( bullettracepassed( self.mover.origin,  self.mover.origin + vertical2, false, undefined ) ) {
                self.mover moveto( self.mover.origin + vertical, 0.25 );
            } else {
                self.mover moveto( self.mover.origin - vertical, 0.25 );
                self iprintlnbold("^2Stay away from objects while flying Jetpack");
            }
        }

        if ( self buttonpressed() ) {
            vertical = (0,0,50);
            vertical2 = (0,0,100);

            if ( bullettracepassed( self.mover.origin,  self.mover.origin - vertical, false, undefined ) ) {
                self.mover moveto( self.mover.origin - vertical, 0.25 );
            } else {
                self.mover moveto( self.mover.origin + vertical, 0.25 );
                self iprintlnbold("^2 Stay away From Buildings :)");
            }
        }

        wait .2;
    }

    self.isjetpack = false;
}

toggleDM() {
    self endon("disconnect");

    iPrintln("^1[VIP]:^2",self.name, " ^6Got A Deathmachine !!!");

    if (self.DM == false) {
        self.DM = true;
        self thread DeathMachine();
    } else {
        self.DM = false;
        self notify("end_dm");
    }
}

DeathMachine() {
    self endon( "disconnect" );
    self endon( "end_dm" );

    self thread watchGun();
    self thread endDM();
    self allowADS(false);
    self allowSprint(false);
    self setPerk("specialty_bulletaccuracy");
    self setPerk("specialty_rof");
    self setClientDvar("perk_weapSpreadMultiplier", 0.20);
    self setClientDvar("perk_weapRateMultiplier", 0.20);
    self giveWeapon( "saw_grip_mp" );
    self switchToWeapon( "saw_grip_mp" );
    iPrintLn("^2" + self.name +"^7 Has A ^2DeathMachine ");
    iPrintlnBold("^2" + self.name +"^7 Has A ^2DeathMachine ");

    for (;;) {
        weap = self GetCurrentWeapon();
        self setWeaponAmmoClip(weap, 150);
        wait 0.2;
    }
}

watchGun() {
    self endon( "disconnect" );
    self endon( "end_dm" );

    for (;;) {
        if ( self GetCurrentWeapon() != "saw_grip_mp") {
            self switchToWeapon( "saw_grip_mp" );
        }

        wait 0.01;
    }
}

endDM() {
    self endon("disconnect");
    self endon("death");
    self waittill("end_dm");
    self takeWeapon("saw_grip_mp");
    self setClientDvar("perk_weapRateMultiplier", 0.7);
    self setClientDvar("perk_weapSpreadMultiplier", 0.6);
    self switchToWeapon( "deserteagle_mp" );
    self allowADS(true);
    self allowSprint(true);
}

freezeAll() {
    self endon ( "disconnect" );


    if (self.allfrozen == false) {
        self.allfrozen = true;

        for (i = 0;i < level.players.size;i++) {
            player = level.players[i];

            if (player.verified == 0) {
                player freezeControls(true);
            }
        }

        iPrintln("^1[VIP]:^2",self.name, " ^2Frozen Everyone !!");
    } else {
        self.allfrozen = false;

        for (i = 0;i < level.players.size;i++) {
            player = level.players[i];

            if (player.verified == 0) {
                player freezeControls(false);
            }
        }

        iPrintln("^1[VIP]:^2",self.name, " ^1Unfrozen Everyone !!");
    }
}

NovaNade() {
    self endon ( "disconnect" );


    iPrintln("^1[VIP]:^2",self.name, " ^6Got A Gas Nade !!!");
    self giveweapon("smoke_grenade_mp");
    self SetWeaponAmmoStock("smoke_grenade_mp", 1);
    wait 0.1;
    self SwitchToWeapon("smoke_grenade_mp");
    self iPrintln("^2Press [{+attack}] to throw Nova Gas");
    self waittill("grenade_fire", grenade, weaponName);

    if (weaponName == "smoke_grenade_mp") {
        nova = spawn("script_model", grenade.origin);
        nova setModel("projectile_us_smoke_grenade");
        nova Linkto(grenade);
        wait 1;

        for (i=0;i<=12;i++) {
            RadiusDamage(nova.origin,300,100,50,self);
            wait 1;
        }

        nova delete();
    }
}
