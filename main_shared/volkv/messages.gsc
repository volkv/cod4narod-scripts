tellmessage(mes) {

    players = getentarray("player", "classname");
    for (i = 0; i < players.size; i++)
    {
        if (!isDefined(players[i]))
            continue;

        maguid = players[i] getGuid();

        if (isDefined(maguid) && maguid != "0")
            exec("tell " + maguid + " " + players[i] volkv\_common::getLangString(mes));

        wait .05;

    }

}


messages()
{

    level endon("game_ended");

    while (1)

    {
		wait 60;

        tellmessage("MESSAGE10");
		
		wait 60;

        tellmessage("MESSAGE15");
		
        wait 60;
		
		tellmessage("MESSAGE7");

        wait 60;

        weeklyMessageKills(); //
		
		wait 60;

        tellmessage("MESSAGE1");

        wait 60;

        tellmessage("MESSAGE2");

        wait 60;

        tellmessage("MESSAGE3");

        wait 60;

        weeklyMessageKD(); //

        wait 60;

        tellmessage("MESSAGE14");

        wait 60;

        tellmessage("MESSAGE4");

		
		 wait 60;

        tellmessage("MESSAGE5");
		
	    wait 60;

        weeklyMessageKnives(); //


		wait 60;


        tellmessage("MESSAGE6");
		
        wait 60;
		
		tellmessage("MESSAGE12");
		
        wait 60;

		weeklyMessageSkill(); //
				
        wait 60;

        tellmessage("MESSAGE8");
		
        wait 60;
		
        tellmessage("MESSAGE9");
		
		wait 60;

		weeklyMessageKPM(); //

    }

}

weeklyMessageKD() {

    tellmessage("MESSAGE_LEADERS_KD");

    wait .1;
    for (i = 0; i<level.weeklytopKD["player"].size;i++) {

        if (isDefined(level.weeklytopKD["player"][i]) && isDefined(level.weeklytopKD["kd"][i]))
            exec("say ^1" + getSubStr(level.weeklytopKD["kd"][i], 0, 4) + " ^2 | ^3" + level.weeklytopKD["player"][i] + " ^2 [^6+" + (5 - 2*i) + " VIP days^2]");

        wait .2;

    }

}

weeklyMessageKPM() {

    tellmessage("MESSAGE_LEADERS_KPM");

    wait .1;
    for (i = 0; i<level.weeklytopKPM["player"].size;i++) {

        if (isDefined(level.weeklytopKPM["player"][i]) && isDefined(level.weeklytopKPM["kpm"][i]))
            exec("say ^1" + getSubStr(level.weeklytopKPM["kpm"][i], 0, 4) + " ^2 | ^3" + level.weeklytopKPM["player"][i]);

        wait .2;

    }

}

weeklyMessageKills() {

    tellmessage("MESSAGE_LEADERS_KILLS");
    wait .1;
    for (i = 0; i<level.weeklytopKills["player"].size;i++) {

        if (isDefined(level.weeklytopKills["player"][i]) && isDefined(level.weeklytopKills["kills"][i]))
            exec("say ^1" + level.weeklytopKills["kills"][i] + " ^2 | ^3" + level.weeklytopKills["player"][i] + " ^2 [^6+" + (5 - 2*i) + " VIP days^2]");
        wait .2;

    }


}

weeklyMessageKnives() {

    tellmessage("MESSAGE_LEADERS_KNIVES");
    wait .1;
    for (i = 0; i<level.weeklytopKnives["player"].size;i++) {

        if (isDefined(level.weeklytopKnives["player"][i]) && isDefined(level.weeklytopKnives["knives"][i]))
            exec("say ^1" + level.weeklytopKnives["knives"][i] + " ^2 | ^3" + level.weeklytopKnives["player"][i] + " ^2 [^6+" + (5 - 2*i) + " VIP days^2]");
        wait .2;

    }

}

weeklyMessageSkill() {

    tellmessage("MESSAGE_LEADERS_SKILL");
    wait .1;
    for (i = 0; i<level.topSkill["player"].size;i++) {

        if (isDefined(level.topSkill["player"][i]) && isDefined(level.topSkill["skill"][i]))
            exec("say ^1" + level.topSkill["skill"][i] + " ^2 | ^3" + level.topSkill["player"][i]);
        wait .2;

    }

}