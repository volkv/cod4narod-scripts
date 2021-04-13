#include maps\mp\_utility;
#include common_scripts\utility;
#include volkv\_common;

init() {
	addSpawnThread(::Monitors);
	level.chopper_fx["explode"]["medium"] = loadfx("explosions/aerial_explosion");
	precacheShader("hint_mantle");
}

Monitors() {
	self.reflect_damage = false;

	if (getdvarint( "sniper" ) != 1) {
		if (!isDefined(self.pers["status"]) || (self.pers["status"] != "vip" && self.pers["status"] != "vipadmin")) {

			self thread AntiCamp();
		}
	}
	if (self.pers["status"] != "boss")
	self thread AFKMonitor();
}

AFKMonitor() {
	self endon("disconnect");
	self endon("death");
	self endon("joined_spectators");
	self endon( "spawned_player" );
	level endon("game_ended");
	level endon("mapvote");
	i = 0;
	if (self getGuid() != "0") {
		while (isAlive(self)) {
			ori = self.origin;
			angles = self.angles;
			wait 1;

			if (isAlive(self) && self.sessionteam != "spectator") {
				if (self.origin == ori && angles == self.angles)
					i++;
				else
					i = 0;
				if (i == 45)
					self iPrintBig("APPEAR_AFK");
				if (i >= 55) {
					self setClientDvar("r_blur", 0);
					self.sessionteam = "spectator";
					self.sessionstate = "spectator";
					self.pers["team"] = "spectator";
					self [[level.spawnSpectator]]();
					self notify("sdfsdfdsf");
					level iPrintSmall("IS_AFK","NAME",self.name);
					return;
				}
			} else
				i = 0;
		}
	}
}

AntiCamp() {
	self notify("sdfsdfdsf");
	self endon("disconnect");
	self endon("sdfsdfdsf");
	self endon( "spawned_player" );
	self endon("joined_spectators");
	self endon("death");

	level endon("game_ended");
	level endon("mapvote");
	self.camping = 0;
	self.notified = 0;


	if (!isDefined(self.hud_anticamp_info)) {
		self.hud_anticamp_info = newClientHudElem(self);
		self.hud_anticamp_info.horzAlign = "right";
		self.hud_anticamp_info.vertAlign = "bottom";
		self.hud_anticamp_info.alignX = "right";
		self.hud_anticamp_info.alignY = "bottom";
		self.hud_anticamp_info.x = -24;
		self.hud_anticamp_info.y = -45;
		self.hud_anticamp_info.color = (1,0,0);
		self.hud_anticamp_info.archived = true;
		self.hud_anticamp_info setShader("hint_mantle", 48, 48);

	}

	self.hud_anticamp_info.alpha = 0;


	self.blended = 0;


//   if(!isDefined(self.camp)) {
//      self.camp = createBar((0, 0, 0), 64, 8, 5, -48, "left", "bottom");
//		self.camp.bar.color = (0, 1, 0);
// 	self.camp.bar.alpha = .3;
//		self.camp.bar.hidewheninmenu = true;
//		self.camp.hidewheninmenu = true;
//		self.camp updateBar(0);
//   }

	wait 1;
	angles = self.angles;
	while (angles == self.angles)
		wait .5;
	while (isAlive(self)) {
		oldorg = self.origin;
		wait .3;
		if (distance(oldorg, self.origin) < 30 && self.health <= 130 && level.weak[self.pers["team"]] == false ) {
			if (isSubStr(self GetCurrentWeapon(), "remington700_mp") || isSubStr(self GetCurrentWeapon(), "m21_mp") || isSubStr(self GetCurrentWeapon(), "aw50_mp") || isSubStr(self GetCurrentWeapon(), "barrett_mp") || isSubStr(self GetCurrentWeapon(), "dragunov_mp") || isSubStr(self GetCurrentWeapon(), "m40a3_mp") )
				self.camping += 0.005;
			else
				self.camping += 0.02;
		}

		else
			self.camping -= distance(oldorg, self.origin) * 0.001;

		if (self.camping > 1)
			self.camping = 1;
		else if (self.camping < 0)
			self.camping = 0;

//		self.camp.bar FadeOverTime(.1);
//		self.camp.bar.color = (self.camping, 1 - self.camping, 0);
//		self.camp.bar.alpha = .3 + (self.camping / 2);

//		if(self.camping != 0 )
//			self.camp updateBar(self.camping,.1);
//		else
//			self.camp updateBar(0);



		if (self.camping == 1) {
			//self iprintlnbold("^5Move or you will be killed!");

			self thread Blur2();

			oldorg = self.origin;
			wait 1;
			while (distance(oldorg, self.origin) < 300) {

				wait .1;
			}

			self thread UnBlur2();
		}
	}

//	if(isdefined(self.camp)) {
//		if(isDefined(self.camp.bar))
//			self.camp.bar Destroy();
//			self.camp Destroy();
//	}

}

createBar( color, width, height, x, y, ax, ay ) {
	barElem = newClientHudElem(	self );
	barElem.x = x + 1;
	barElem.y = y;
	barElem.color = color;
	barElem.sort = -2;
	barElem.alignX = "left";
	barElem.alignY = "middle";
	barElem.horzAlign = ax;
	barElem.vertAlign = ay;


	barElem.shader = "white";
	barElem setShader( barElem.shader, width , height  );

	barElemBG = newClientHudElem( self );
	barElemBG.x = x;
	barElemBG.y = y;
	barElemBG.color = (0,0,0);
	barElemBG.sort = -3;
	barElemBG.alignX = "left";
	barElemBG.alignY = "middle";
	barElemBG.horzAlign = ax;
	barElemBG.vertAlign = ay;

	barElemBG.bar = barElem;
	barElemBG.width = width-1;
	barElemBG.height = height;
	barElemBG.alpha = 0.5;
	barElemBG setShader( "white", width + 2, height + 2 );

	return barElemBG;
}

updateBar(barFrac,rateOfChange) {
	barWidth = int(self.width * barFrac + 0.5); // (+ 0.5 rounds)

	if ( !barWidth )
		barWidth = 1;

	self.bar setShader( self.bar.shader, barWidth, self.height );

	//if barWidth is bigger than self.width then we are drawing more than 100%
	if ( isDefined( rateOfChange ) && barWidth < self.width ) {
		if ( rateOfChange > 0 ) {
			self.bar scaleOverTime( (1 - barFrac) / rateOfChange, self.width, self.height );
		} else if ( rateOfChange < 0 ) {
			self.bar scaleOverTime( barFrac / (-1 * rateOfChange), 1, self.height );
		}
	}
}

Blur() {
	self endon("disconnect");
	for (i=0;i<14;i++) {
		self setClientDvar("r_blur", i / 2);
		wait .1;
	}

}

Blur2() {
	self endon("disconnect");

	if (self.notified == 0) { // ** Display this intro at the 2nd connect so that they wont get raged
		self.notified = 1;

		self iPrintBig("CAMP_BLUR");

	}

	self.multipl_anticamp = .2;
	self.hud_anticamp_info fadeOverTime(.5);
	self.hud_anticamp_info.alpha = .6;



}

UnBlur() {
	self endon("disconnect");
	for (i=14;i>=0;i--) {
		self setClientDvar("r_blur", i / 2);
		wait .1;
	}

}

UnBlur2() {
	self endon("disconnect");
	self.multipl_anticamp = 1;

	self.hud_anticamp_info fadeOverTime(.5);
	self.hud_anticamp_info.alpha = 0;
}

Blend() {
	self endon("disconnect");
	if (isdefined(self.blended) && self.blended == 1)
		return;
	self.blended = 1;
	self ShellShock( "frag_grenade_mp", .4 );
	wait 6;
	self.blended = 0;
}