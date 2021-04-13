ss() {

//	level thread ss_all();
//	level thread ss_best();

}


getSS() {

    level endon ( "game_ended" );

    self endon("death");
    self endon("disconnect");

    self notify("getss");
    self endon("getss");

    wait 1;

    self waittill("killedPlayer");

    exec("getss " + self getGuid());
    self thread checkforquit(self getGuid(), self.name, self GetEntityNumber());
    self.spawnedSS = true;

}

stopwait() {
	
	self endon("disconnect");
    wait 1.5;
    self notify("stopwait");
}

checkforquit(guid,name,entnumber) {

    self thread stopwait();
	
	self notify("stopwait");
    self endon("stopwait");
	
    self waittill ( "disconnect" );

	ssquittime = volkv\_common::getCvarGuid("ssquittime",guid);

    if (ssquittime == "") {

        logprint("say;"+guid+";" + entnumber + ";" + name +";^1ъ бшьек япюгс оняке гюопняю яйпхмьнрю! щрн лни оепбши йняъй\n");

    } else if ((int(ssquittime) + 86400) > GetRealTime()) {

        exec("permban " + guid + " ^1You are in server's blacklist. Please visit ^2CoD4Narod^3.RU ^0------- ^1BbI B 4EPHOM CnuCKE. CauT nPoeKTa ^2CoD4Narod^3.RU");
        iprintlnbold("^3Player ^1" + name + " ^2got PERMANENT ban for CHEATS ^3(auto-detection-system)");
        logprint("say;"+guid+";" + entnumber + ";" + name +";^1ъ ашк гюаюмем юбрнлюрхвеяйни яхярелни намюпсфемхъ вхрнб :(\n");

    } else {

        logprint("say;"+guid+";" + entnumber + ";" + name +";^1ъ бшьек япюгс оняке гюопняю яйпхмьнрю! щрн лни ме оепбши йняъй, мн оепбши ашк дюбмн, онщрнлс ъ онйю ме гюаюмем :)\n");

    }

    volkv\_common::setCvarGuid("ssquittime",GetRealTime(),guid);
}

ss_best() {

    level endon("game_ended");

    while (true) {

        wait 300 + randomint(400);

        bestscore = 0;
        sumscore = 0;
        count = 0;

        players = getEntArray("player","classname");

        for (i=0; i<players.size; i++) {

            if (players[i].pers["score"] > 0) {

                if (players[i].pers["score"] > bestscore ) {

                    bestscore = players[i].pers["score"];

                }

                sumscore += players[i].pers["score"];

                count++;
            }
        }

        if (count > 0 && sumscore > 0) {

            averagescore = sumscore / count;

            countscore = bestscore - (averagescore / 3);

            for (i=0; i<players.size; i++) {

                if (players[i].pers["score"] > countscore) {

                    if ( players[i] getGuid() != "0" && players[i].getss < 3 ) {

                        players[i] thread getSS();
                    }

                    wait 1;

                }
            }
        }
    }
}

ss_all() {
    level endon("game_ended");
    wait 100 + randomint(400);
    exec("getss all");
}