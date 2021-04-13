#include volkv\_common;

init()
{

//	addConnectThread(::IntroduceThisServer,"once");

    addSpawnThread(::SpawnProtection);


}

IntroduceThisServer() {
    if (self getStat(752) != 7) { // ** Display this intro at the 2nd connect so that they wont get raged
        self setStat(752,7);

        self endon("disconnect");
        for (k=0;k<3;k++) {
            self closeMenu();
            self closeInGameMenu();
            wait .05;
        }
        shader = [];
        for (i=0;i<5;i++) {
            shader[i] = createHud( self, 0, 0, .6, "center", "middle", "center",1.6, 9999 + i );
            shader[i].vertAlign = "middle";
            shader[i] thread FadeIn1(.5);
        }
        shader[0] SetShader("white",502,352);
        shader[1] SetShader("black",500,350);
        shader[2].alpha = 1;
        shader[2].y = -150;
        shader[2].alignX = "left";
        shader[2].x = -200;
        shader[2] setText(self getLangString("HELP_1"));
        shader[3].alpha = 1;
        shader[3].y = -4;
        shader[3].alignX = "left";
        shader[3].x = -200;
        shader[3] setText(self getLangString("HELP_2"));
        shader[4].x = 200;
        shader[4].y = 150;
        shader[4].label = self getLangString("HELP_TIME_LEFT");
        shader[4] SetTenthsTimer(15);
        shader[4].alignX = "right";
        wait 15;
        shader[4].label = &"&&1";
        shader[4] setText(self getLangString("HELP_CLOSE"));
        while (!self MeleeButtonPressed()) wait .05;
        for (i=0;i<5;i++)
            shader[i] thread FadeOut1(1,true,"left");
    }
}



FadeOut1(time,slide,dir) {
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
FadeIn1(time,slide,dir) {
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
createHud( who, x, y, alpha, alignX, alignY, vert, fontScale, sort ) {
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
    return hud;
}

SpawnProtection() {

    time = 2;
    self endon("disconnect");
    self setHealth(200);

    for (i=0;i<time*20 && !self AttackButtonPressed() && self.sessionstate == "playing";i++) wait .05;


    if ((isDefined(self.inPredator) && !self.inPredator) || !isDefined(self.inPredator)) {

        self maps\mp\gametypes\_globallogic::defaultHealth();
    }
}

schnitzel( align, fade_in_time, x_off, y_off ) {
    hud = newClientHudElem(self);
    hud.foreground = true;
    hud.x = x_off;
    hud.y = y_off;
    hud.alignX = align;
    hud.alignY = "middle";
    hud.horzAlign = align;
    hud.vertAlign = "middle";
    hud.fontScale = 2;
    hud.color = (1, 1, 1);
    hud.font = "objective";
    hud.glowColor = ( 0.043, 0.203, 1 );
    hud.glowAlpha = 1;
    hud.alpha = 1;
    hud fadeovertime( fade_in_time );
    hud.alpha = 1;
    hud.hidewheninmenu = true;
    hud.sort = 10;
    return hud;
}

animate_circle_number(degree, time) {
    w = 1 / getDvarInt("sv_fps");
    degree_step = (self.degree - degree) * (w/time) *-1;
    if ( degree > self.degree )
        degree_step = (degree-self.degree) * (w/time);
    for (i=self.degree;isDefined(self);i+=degree_step) {
        if (i < 15 && i > -15)
            self.color = (0.172, 0.781, 1);
        else
            self.color = (1,1,1);
        self MoveOverTime(w);
        self.x = sin(i)*85;
        self.y = cos(i)*85;
        wait w;
    }
}

SpawnAnimation() {
    self endon("disconnect");
    pos[0]["origin"] = self.origin + maps\mp\_utility::vector_scale(anglestoforward(self getPlayerAngles()+(80,0,0)), -1000 );
    pos[0]["angles"] = self getPlayerAngles()+(80,0,0);
    pos[1]["origin"] = self.origin + maps\mp\_utility::vector_scale(anglestoforward(self getPlayerAngles()+(45,0,0)), -100 );
    pos[1]["angles"] = self getPlayerAngles()+(45,0,0);
    pos[2]["origin"] = self.origin;
    pos[2]["angles"] = self getPlayerAngles();
    if (!game["roundsplayed"] || !isDefined(level.instrattime) || !level.instrattime) return;
    self thread BeginFlight(pos,30);
    self setClientDvar("cg_drawGun",0);
    self disableWeapons();
    self hide();
    wait 2;
    self setClientDvar("cg_drawGun",1);
    self waittill("flight_done");
    self show();
    wait 1;
    self enableWeapons();
}

