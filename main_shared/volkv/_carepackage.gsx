#include volkv\_common;
#include maps\mp\_helicopter;
#include maps\mp\gametypes\_hud_util;

main() {
	precacheModel( "com_plasticcase_beige_big" );
	PreCacheShader("hud_suitcase_bomb");
	level.fx[1]=loadfx("fire/tank_fire_engine");
	level.chopper_fx["explode"]["medium"] = loadfx("explosions/aerial_explosion");
}

canCallPackage() {
	if (isDefined(level.carpackageInUse)) {
		self iprintlnbold(self getLangString("PACKEGE_INUSE"));
		return false;
	}

	location = 2000;
	if (getDvar("mapname") == "mp_bloc") location = 2400;
	else if (getDvar("mapname") == "mp_crossfire") location = 2200;
	else if (getDvar("mapname") == "mp_citystreets") location = 2000;
	else if (getDvar("mapname") == "mp_creek") location = 2100;
	else if (getDvar("mapname") == "mp_bog") location = 2200;
	else if (getDvar("mapname") == "mp_overgrown") location = 2500;
	else if (getDvar("mapname") == "mp_nuketown") location = 1700;
	else if (getDvar("mapname") == "mp_strike") location = 2100;
	else if (getDvar("mapname") == "mp_crash") location = 2100;

	heliorigin = (self.origin[0],self.origin[1],location);
	playerorigin = self.origin;

	if (!BulletTracePassed(heliorigin,playerorigin,true,self)) {
		self iPrintBig("PACKAGE_POSITION");
		return false;
	}

	level.carpackageInUse = true;
	self thread CarePackage(heliorigin,playerorigin);
	return true;
}

CarePackage(heliorigin,playerorigin) {
	self endon("disconnect");
	vector = anglesToForward((0,randomint(360) ,0));
	start = heliorigin+(vector[0]*10600,vector[1]*10600,0);

	model = "vehicle_mi24p_hind_desert";
	sound = "mp_hind_helicopter";
	if ( self.pers["team"] == "allies" ) {
		model = "vehicle_cobra_helicopter_fly";
		sound = "mp_cobra_helicopter";
	}

	chopper = spawnHelicopter( self, start, (0,0,-10), "cobra_mp", model );
	chopper playLoopSound( sound );
	chopper.currentstate = "ok";
	chopper.laststate = "ok";
	chopper setdamagestage( 3 );
	chopper setspeed(3000, 100, 50);
	chopper setvehgoalpos( heliorigin, 1);

	box = spawn( "script_model", heliorigin );

	box setmodel("com_plasticcase_beige_big");
	box LinkTo( chopper, "tag_ground" , (0,0,-10) , (0,0,0) );
	while (distance(chopper.origin,heliorigin) >= 50) wait .05;
	box Unlink();
	box.angles = (0,box.angles[1],0);
	box MoveTo(playerorigin,distance(playerorigin,box.origin) / 1500);
	chopper setvehgoalpos( start, 1);
	chopper thread deleteChopper(start);
	box waittill ("movedone");


	players = getAllPlayers();

	for (i=0;i<players.size;i++) {
		if (isDefined(players[i]) && distance(players[i].origin,box.origin) < 65) {
			PlayRumbleOnPosition( "artillery_rumble", box.origin );
			volkv\_common::TriggerEarthquake( 0.7, 0.5, box.origin, 800 );
			radiusDamage( box.origin + (0,0,50), 512, 300, 100, self, "MOD_PROJECTILE_SPLASH", "artillery_mp" );
			break;
		}
	}




	solid = spawn("trigger_radius",box.origin,0,1,1);
	solid setContents(1);
	solid.targetname = "script_collision";
	level thread endOnDc(self,box,solid,chopper);
	box thread AddTriggerMsg(self);
	box thread AddTrigger(self);
	box thread delTimer();

	players = getAllPlayers();

	for (i=0;i<players.size;i++) {

		if (isDefined(box) && isDefined(players[i]) && players[i].team != self.team) {

			content = newClientHudElem(players[i]);
			content.x = box.origin[0];
			content.y = box.origin[1];
			content.z = box.origin[2]+30;
			content.alpha = .5;
			content.archived = true;
			content setShader("hint_usable", 48, 48);
			content setWaypoint(true, "hint_usable");
			content.color = (1,0,0);

			players[i] thread delcontent(content, box);
		}

		else if (isDefined(box) && isDefined(players[i]) && players[i] == self) {

			content = newClientHudElem(players[i]);
			content.x = box.origin[0];
			content.y = box.origin[1];
			content.z = box.origin[2]+30;
			content.alpha = .5;
			content.archived = true;
			content setShader("hint_usable", 48, 48);
			content setWaypoint(true, "hint_usable");
			content.color = (0,1,0);

			players[i] thread delcontent(content, box);

		}
		wait .02;
	}

	box waittill("death");

	solid notify("deleted");
	solid delete();


}

delTimer() {
	self endon("death");
	wait 120;
	self delete();
}

delcontent(content, box) {

	self endon("disconnect");
	box waittill("death");
	content destroy();

}


endOnDc(player,box,solid,chopper) {
	solid endon("deleted");
	player waittill("disconnect");
	if (isDefined(box))
		box delete();
	if (isDefined(solid))
		solid delete();
	if (isDefined(chopper))
		chopper delete();
	level.carpackageInUse = undefined;
}

deleteChopper(start) {
	self endon("death");
	while (distance(self.origin,start) >= 1000) wait .05;
	level.carpackageInUse = undefined;
	self delete();
}

AddTrigger(owner) {

	self endon("death");
	owner endon("disconnect");
	num = level.carepackage.size;
	triggerrange = 80;
	while (isDefined(self)) {
		wait .05;
		players = getAllPlayers();
		for (i=0;i<players.size;i++) {
			player = players[i];
			if (isDefined(player.origin) && isDefined(self.origin)) {
				if ((player.team != owner.team || player == owner ) && player isRealyAlive() && (distance(player.origin,self.origin) < triggerrange) ) {
					if (player UseButtonPressed()) {
						level.carepackage[num] = true;

						if (player != owner)
							timer = 5;
						else
							timer = 1;

						player DisableWeapons();
						player freezeControls( true );
						player.entschaerfen = player maps\mp\gametypes\_hud_util::createBar((1,1,1), 128, 8);
						player.entschaerfen maps\mp\gametypes\_hud_util::setPoint("CENTER", 0, 0, 0);
						player.entschaerfen maps\mp\gametypes\_hud_util::updateBar(0, 1/timer );
						for (i=0;i<(timer*20+1);i++) {
							if (!isDefined(player)) {
								level.carepackage[num] = false;
								i = 999999;
							}
							if (!player UseButtonPressed() || !isDefined(self) || !player isRealyAlive() || distance(player.origin,self.origin) > (triggerrange + 10)) {
								if (isDefined(player.entschaerfen))
									player.entschaerfen maps\mp\gametypes\_hud_util::destroyElem();
								player EnableWeapons();
								player freezeControls( false );
								level.carepackage[num] = false;
								i = 999999;
							}
							wait .05;
							if (i == (timer*20)) {
								if (isDefined(player.entschaerfen))
									player.entschaerfen maps\mp\gametypes\_hud_util::destroyElem();
								player EnableWeapons();
								player freezeControls( false );
								if (player.pers["team"] != owner.pers["team"] && randomint(5) == 0) {

									PlayRumbleOnPosition( "artillery_rumble", self.origin );
									volkv\_common::TriggerEarthquake( 0.7, 0.5, self.origin, 800 );
									radiusDamage( self.origin + (0,0,50), 512, 300, 100, owner, "MOD_PROJECTILE_SPLASH", "artillery_mp" );

									owner thread volkv\_languages::iPrintBigTeams("PACKAGE_EXPLODE", "PLAYER", player.name, "OWNER", owner.name);

								}
								else
									player thread Rewards(owner);
								self delete();
								return;
							}
						}
					}
				}
			}
		}
	}
}

AddTriggerMsg(owner) {

	self endon("death");

	if (!isDefined(level.carepackage)) {
		level.carepackage = [];
	}
	num = level.carepackage.size;
	wait .05;
	level.carepackage[num] = false;

	triggerrange = 80;
	while (isDefined(self)) {
		players = getAllPlayers();
		for (i=0;i<players.size;i++) {
			player = players[i];
			if (player isRealyAlive() && distance(player.origin,self.origin) < triggerrange && !level.carepackage[num]) {
				player.carepackagemsg = true;
				if (player == owner) {
					player maps\mp\_utility::setLowerMessage(player getLangString("PICKUP"));
				} else if (player.team != owner.team) {
					player maps\mp\_utility::setLowerMessage(player getLangString("ENEMY_PICKUP"));
				}
			}
			else if (isDefined(player.carepackagemsg) && player.carepackagemsg && (level.carepackage[num] || distance(player.origin,self.origin) > triggerrange)) {
				player.carepackagemsg = false;
				player maps\mp\_utility::clearLowerMessage( .3 );
			}
		}
		wait .05;
	}
	players = getAllPlayers();
	for (i=0;i<players.size;i++)
		if (isDefined(players[i].carepackagemsg) && players[i].carepackagemsg)
			players[i] maps\mp\_utility::clearLowerMessage( .3 );
}

NukeBullets() {
	self endon("death");
	self endon("disconnect");
	self endon("spawned");
	for (i=0;i<20;i++) {
		self waittill ( "weapon_fired" );
		self playsound("rocket_explode_default");
		vec = anglestoforward(self getPlayerAngles());
		end = (vec[0] * 200000, vec[1] * 200000, vec[2] * 200000);
		SPLOSIONlocation = BulletTrace( self gettagorigin("tag_eye"), self gettagorigin("tag_eye")+end, 0, self)[ "position" ];
		playfx(level.chopper_fx["explode"]["medium"], SPLOSIONlocation);
		RadiusDamage( SPLOSIONlocation, 200, 500, 60, self );
		volkv\_common::TriggerEarthquake(0.3, 1, SPLOSIONlocation, 400);
		wait 1;
	}
}

Rewards(owner) {
	self endon("disconnect");

	random = randomint(115);
	players = GetEntArray("player","classname");

	if (random >= 0 && random < 5 ) {

		self maps\mp\gametypes\_hardpoints::giveHardpointItem( "strafe_mp" );
		self maps\mp\gametypes\_hud_message::oldNotifyMessage_lite(self getLangString("strafe_mp"));

		if (self != owner) {

			for (i=0;i<players.size;i++)
				players[i] iPrintln(players[i] getLangString("STOLE_PACKAGE","PLAYER",self.name,"OWNER",owner.name,"REWARD", players[i] getLangString("STRAFE_INCOMING")));

		} else {

			for (i=0;i<players.size;i++)
				players[i] iPrintln(players[i] getLangString("FOUND_PACKAGE","PLAYER",self.name,"REWARD", players[i] getLangString("STRAFE_INCOMING")));
		}

	}	else if (random >= 5 && random < 10 ) {

		self maps\mp\gametypes\_hardpoints::giveHardpointItem( "helicopter_mp" );
		self maps\mp\gametypes\_hud_message::oldNotifyMessage_lite(level.hardpointHints["helicopter_mp"]);

		if (self != owner) {
			for (i=0;i<players.size;i++)
				players[i] iPrintln(players[i] getLangString("STOLE_PACKAGE","PLAYER",self.name,"OWNER",owner.name,"REWARD", players[i] getLangString("HELICOPTER_MP")));

		} else {
			for (i=0;i<players.size;i++)
				players[i] iPrintln(players[i] getLangString("FOUND_PACKAGE","PLAYER",self.name,"REWARD", players[i] getLangString("HELICOPTER_MP")));

		}


	} else if (random >= 10 && random < 20 ) {

		self maps\mp\gametypes\_hardpoints::giveHardpointItem( "airstrike_mp" );
		self maps\mp\gametypes\_hud_message::oldNotifyMessage_lite(level.hardpointHints["airstrike_mp"]);

		if (self != owner) {
			for (i=0;i<players.size;i++)
				players[i] iPrintln(players[i] getLangString("STOLE_PACKAGE","PLAYER",self.name,"OWNER",owner.name,"REWARD", players[i] getLangString("AIRST_MP")));

		} else {
			for (i=0;i<players.size;i++)
				players[i] iPrintln(players[i] getLangString("FOUND_PACKAGE","PLAYER",self.name,"REWARD", players[i] getLangString("AIRST_MP")));

		}


	} else if (random >= 20 && random < 25 ) {

		self maps\mp\gametypes\_hardpoints::giveHardpointItem( "predator_mp" );
		self maps\mp\gametypes\_hud_message::oldNotifyMessage_lite(getLangString("predator_mp"));

		if (self != owner) {
			for (i=0;i<players.size;i++)
				players[i] iPrintln(players[i] getLangString("STOLE_PACKAGE","PLAYER",self.name,"OWNER",owner.name,"REWARD", players[i] getLangString("PREDATOR_CAPTION")));

		} else {
			for (i=0;i<players.size;i++)
				players[i] iPrintln(players[i] getLangString("FOUND_PACKAGE","PLAYER",self.name,"REWARD", players[i] getLangString("PREDATOR_CAPTION")));
		}


	} else if (random >= 25 && random < 35 ) {

		self maps\mp\gametypes\_hardpoints::giveHardpointItem( "radar_mp" );
		self maps\mp\gametypes\_hud_message::oldNotifyMessage_lite(level.hardpointHints["radar_mp"]);

		if (self != owner) {

			for (i=0;i<players.size;i++)
				players[i] iPrintln(players[i] getLangString("STOLE_PACKAGE","PLAYER",self.name,"OWNER",owner.name,"REWARD", players[i] getLangString("RAD_MP")));

		} else {

			for (i=0;i<players.size;i++)
				players[i] iPrintln(players[i] getLangString("FOUND_PACKAGE","PLAYER",self.name,"REWARD", players[i] getLangString("RAD_MP")));
		}


	} else if (random >= 35 && random < 40 ) {

		self maps\mp\gametypes\_hardpoints::giveHardpointItem( "artillery_mp" );
		self maps\mp\gametypes\_hud_message::oldNotifyMessage_lite(getLangString("artillery_mp"));

		if (self != owner) {
			for (i=0;i<players.size;i++)
				players[i] iPrintln(players[i] getLangString("STOLE_PACKAGE","PLAYER",self.name,"OWNER",owner.name,"REWARD", players[i] getLangString("ARTILLERY_INCOMING")));

		} else {
			for (i=0;i<players.size;i++)
				players[i] iPrintln(players[i] getLangString("FOUND_PACKAGE","PLAYER",self.name,"REWARD", players[i] getLangString("ARTILLERY_INCOMING")));
		}


	} else if (random >= 40 && random < 50 ) {

		self giveWeapon("rpg_mp");
		self giveMaxAmmo( "rpg_mp" );
		self SetActionSlot( 1, "weapon","rpg_mp");

		self setperk( "specialty_explosivedamage" );
		self showPerk(0,"specialty_explosivedamage", 60);
		self showPerk(1, "specialty_extraammo", 60 );
		self thread maps\mp\gametypes\_globallogic::hidePerksAfterTime( 1.0 );
		self thread maps\mp\gametypes\_globallogic::hidePerksOnDeath();
		self maps\mp\gametypes\_hud_message::oldNotifyMessage_lite("^23 RPG !");

		if (self != owner) {
			for (i=0;i<players.size;i++)
				players[i] iPrintln(players[i] getLangString("STOLE_PACKAGE","PLAYER",self.name,"OWNER",owner.name,"REWARD", "3 RPG !"));
		} else {
			for (i=0;i<players.size;i++)
				players[i] iPrintln(players[i] getLangString("FOUND_PACKAGE","PLAYER",self.name,"REWARD", "3 RPG !"));
		}


	} else if (random >= 50 && random < 60 ) {
		self setperk( "specialty_pistoldeath" );
		self showPerk(0,"specialty_pistoldeath",80);
		self thread maps\mp\gametypes\_globallogic::hidePerksAfterTime( 1.0 );
		self thread maps\mp\gametypes\_globallogic::hidePerksOnDeath();
		self maps\mp\gametypes\_hud_message::oldNotifyMessage_lite("^2Last Stand !");

		if (self != owner) {
			for (i=0;i<players.size;i++)
				players[i] iPrintln(players[i] getLangString("STOLE_PACKAGE","PLAYER",self.name,"OWNER",owner.name,"REWARD", "Last Stand !"));

		} else {
			for (i=0;i<players.size;i++)
				players[i] iPrintln(players[i] getLangString("FOUND_PACKAGE","PLAYER",self.name,"REWARD", "Last Stand !"));
		}


	} else if (random >= 60 && random < 70 ) {
		self setperk( "specialty_armorvest" );
		self showPerk(0,"specialty_armorvest",80);
		self thread maps\mp\gametypes\_globallogic::hidePerksAfterTime( 1.0 );
		self thread maps\mp\gametypes\_globallogic::hidePerksOnDeath();
		self maps\mp\gametypes\_hud_message::oldNotifyMessage_lite("^2Juggernaut !");

		if (self != owner) {
			for (i=0;i<players.size;i++)
				players[i] iPrintln(players[i] getLangString("STOLE_PACKAGE","PLAYER",self.name,"OWNER",owner.name,"REWARD", "Juggernaut !"));

		} else {
			for (i=0;i<players.size;i++)
				players[i] iPrintln(players[i] getLangString("FOUND_PACKAGE","PLAYER",self.name,"REWARD", "Juggernaut !"));
		}



	} else if (random >= 70 && random < 80 ) {

		self giveWeapon("frag_grenade_mp");
		self SetWeaponAmmoClip( "frag_grenade_mp", 4 );
		self maps\mp\gametypes\_hud_message::oldNotifyMessage_lite("^24 Grenades !");

		if (self != owner) {
			for (i=0;i<players.size;i++)
				players[i] iPrintln(players[i] getLangString("STOLE_PACKAGE","PLAYER",self.name,"OWNER",owner.name,"REWARD", "4 Grenades !"));

		} else {
			for (i=0;i<players.size;i++)
				players[i] iPrintln(players[i] getLangString("FOUND_PACKAGE","PLAYER",self.name,"REWARD", "4 Grenades !"));
		}
	} else if (random >= 80 && random < 82 ) {

		self maps\mp\gametypes\_hardpoints::giveHardpointItem( "nuke_mp" );
		self maps\mp\gametypes\_hud_message::oldNotifyMessage_lite(getLangString("nuke_mp"));

		if (self != owner) {
			for (i=0;i<players.size;i++)
				players[i] maps\mp\gametypes\_hud_message::oldNotifyMessage_lite(players[i] getLangString("STOLE_PACKAGE","PLAYER",self.name,"OWNER",owner.name,"REWARD", players[i] getLangString("nuke_mp_single")));

		} else {
			for (i=0;i<players.size;i++)
				players[i] iPrintln(players[i] getLangString("FOUND_PACKAGE","PLAYER",self.name,"REWARD", players[i] getLangString("nuke_mp_single")));
		}
	}

	else if (random >= 82 && random < 85 ) {

		self maps\mp\gametypes\_hardpoints::giveHardpointItem( "ac180_mp" );
		self maps\mp\gametypes\_hud_message::oldNotifyMessage_lite(getLangString("AC180_MP"));

		if (self != owner) {
			for (i=0;i<players.size;i++)
				players[i] maps\mp\gametypes\_hud_message::oldNotifyMessage_lite(players[i] getLangString("STOLE_PACKAGE","PLAYER",self.name,"OWNER",owner.name,"REWARD", players[i] getLangString("AC180_MP_CAPTION")));

		} else {
			for (i=0;i<players.size;i++)
				players[i] iPrintln(players[i] getLangString("FOUND_PACKAGE","PLAYER",self.name,"REWARD", players[i] getLangString("AC180_MP_CAPTION")));
		}
	} 	else if (random >= 85 && random < 95 ) {

		self maps\mp\gametypes\_hardpoints::giveHardpointItem( "orbital_mp" );
		self maps\mp\gametypes\_hud_message::oldNotifyMessage_lite(getLangString("orbital_mp"));

		if (self != owner) {
			for (i=0;i<players.size;i++)
				players[i] iPrintln(players[i] getLangString("STOLE_PACKAGE","PLAYER",self.name,"OWNER",owner.name,"REWARD", players[i] getLangString("orbital_mp_single")));

		} else {
			for (i=0;i<players.size;i++)
				players[i] iPrintln(players[i] getLangString("FOUND_PACKAGE","PLAYER",self.name,"REWARD", players[i] getLangString("orbital_mp_single")));
		}
	} else if (random >= 95 && random < 100 ) {

		self maps\mp\gametypes\_hardpoints::giveHardpointItem( "heli_mp" );
		self maps\mp\gametypes\_hud_message::oldNotifyMessage_lite(getLangString("HELI_MP"));

		if (self != owner) {
			for (i=0;i<players.size;i++)
				players[i] iPrintln(players[i] getLangString("STOLE_PACKAGE","PLAYER",self.name,"OWNER",owner.name,"REWARD", players[i] getLangString("HELI_MP_CAPTION")));

		} else {
			for (i=0;i<players.size;i++)
				players[i] iPrintln(players[i] getLangString("FOUND_PACKAGE","PLAYER",self.name,"REWARD", players[i] getLangString("HELI_MP_CAPTION")));
		}
	} else if (random >= 100 && random < 110 ) {
		self setperk( "specialty_rof" );
		self showPerk(0,"specialty_rof",80);
		self thread maps\mp\gametypes\_globallogic::hidePerksAfterTime( 1.0 );
		self thread maps\mp\gametypes\_globallogic::hidePerksOnDeath();
		self maps\mp\gametypes\_hud_message::oldNotifyMessage_lite("^2Double Fire Rate !");

		if (self != owner) {
			for (i=0;i<players.size;i++)
				players[i] iPrintln(players[i] getLangString("STOLE_PACKAGE","PLAYER",self.name,"OWNER",owner.name,"REWARD", "Double Fire Rate !"));

		} else {
			for (i=0;i<players.size;i++)
				players[i] iPrintln(players[i] getLangString("FOUND_PACKAGE","PLAYER",self.name,"REWARD", "Double Fire Rate !"));
		}

	}

	else {

		self maps\mp\gametypes\_hud_message::oldNotifyMessage_lite(getLangString("NOTHING"));

		if (self != owner) {
			for (i=0;i<players.size;i++)
				players[i] iPrintln(players[i] getLangString("STOLE_PACKAGE","PLAYER",self.name,"OWNER",owner.name,"REWARD", players[i] getLangString("NOTHING")));

		} else {
			for (i=0;i<players.size;i++)
				players[i] iPrintln(players[i] getLangString("FOUND_PACKAGE","PLAYER",self.name,"REWARD", players[i] getLangString("NOTHING")));
		}
	}
}

NotifyMsg(text) {
	notifyData = spawnStruct();
	notifyData.notifyText = text;
	self maps\mp\gametypes\_hud_message::notifyMessage( notifyData );

}