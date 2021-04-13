ShowKDRatio()
{
    self notify( "new_KDRRatio" );
    self endon( "new_KDRRatio" );
    self endon( "disconnect" );
    wait 1;
    if ( isDefined( self.mc_kdratio ) )	self.mc_kdratio Destroy();
    if ( isDefined( self.mc_skill ) )	self.mc_skill Destroy();

    self.mc_skill = NewClientHudElem(self);
    self.mc_skill.x = 110;
    self.mc_skill.y = -465;
    self.mc_skill.horzAlign = "left";
    self.mc_skill.vertAlign = "bottom";
    self.mc_skill.alignX = "left";
    self.mc_skill.alignY = "middle";
    self.mc_skill.alpha = 0;
    self.mc_skill.fontScale = 1.4;
    self.mc_skill.hidewheninmenu = true;
    self.mc_skill.label = self volkv\_common::getLangString("MC_SKILL");
    self.mc_skill FadeOverTime(.5);
    self.mc_skill.alpha = .6;
    self.mc_skill.glowcolor = (0.3, 0.3, 0.3);
    self.mc_skill.glowalpha = .6;

    self.mc_kdratio = NewClientHudElem(self);
    self.mc_kdratio.x = 110;
    self.mc_kdratio.y = -452;
    self.mc_kdratio.horzAlign = "left";
    self.mc_kdratio.vertAlign = "bottom";
    self.mc_kdratio.alignX = "left";
    self.mc_kdratio.alignY = "middle";
    self.mc_kdratio.alpha = 0;
    self.mc_kdratio.fontScale = 1.4;
    self.mc_kdratio.hidewheninmenu = true;
    self.mc_kdratio.label = self volkv\_common::getLangString("MC_KD");
    self.mc_kdratio FadeOverTime(.5);
    self.mc_kdratio.alpha = .6;
    self.mc_kdratio.glowcolor = (0.3, 0.3, 0.3);
    self.mc_kdratio.glowalpha = .6;

    first = true;

    for (;;) {

        if (first)
            first = 0;
        else
            wait .2;

        if (!isDefined(self) || !isDefined(self.pers) || !isDefined(self.pers[ "kills" ]) || !isDefined(self.pers[ "deaths" ]) || !isDefined(self.mc_kdratio) || !isDefined(self.pers["skill"]))
            return;

        if ( isDefined( self.pers[ "kills" ] ) && IsDefined( self.pers[ "deaths" ] ) ) {
            if ( self.pers[ "deaths" ] < 1 ) ratio = self.pers[ "kills" ];
            else ratio = int( self.pers[ "kills" ] / self.pers[ "deaths" ] * 100 ) / 100;

            if (ratio == 0)

                color = (1,.5,0);
            else if (ratio > self.pers["KDz"]) {

                if (ratio - self.pers["KDz"] > .3 )
                    color = (0,1,0);
                else
                    color = (.5,1,0);

            } else  {
                if (self.pers["KDz"] - ratio < .3 )
                    color = (1,.5,0);
                else color = (1,0,0);
            }

            self.mc_kdratio.color = color;
            self.mc_kdratio setValue(ratio);
        }

        if (self.pers["skill"] < self.pers["skill_init"])
            color2 = (1,0,0);
        else if (self.pers["skill"] > self.pers["skill_init"])
            color2 = (0,1,0);
        else
            color2 = (1,.5,0);

        self.mc_skill.color = color2;
        self.mc_skill SetValue( self.pers["skill"] );

        self common_scripts\utility::waittill_any("killed_player","player_killed");
    }

}