<?php
global $parsedline;
global $datetime;

$stats_db = new PDO('mysql:host=localhost;dbname=cod4stats', 'login', 'password');

list($vv1, $iddeath, $guidcc, $byweapon, $modkll, $kill_streak, $death_streak, $played_time,$self_played_time,$skillbonus) = explode(';', $parsedline);

if (!isset($skillbonus))
	$skillbonus = 0;


echo "\n[KILL] : [", $datetime, "] : [" . $guidcc . " -> " . $iddeath . "] [" . $modkll ."]";

if ($guidcc) {

	$addkill = "";

	if ((strpos($byweapon, 'grenade_') !== false) && ($iddeath != $guidcc))
		$addkill = "s_grenade = s_grenade +1,";
	else if ((strpos($modkll, 'MOD_MELEE') !== false) && ($iddeath != $guidcc))
		$addkill = "s_melle = s_melle + 1,";
	else if ((strpos($modkll, 'MOD_HEAD_SHOT') !== false) && ($iddeath != $guidcc))
		$addkill = "s_heads = s_heads + 1,";


	if (($modkll != 'MOD_SUICIDE') && ($iddeath != $guidcc)
		|| (($modkll == 'MOD_SUICIDE') && ($iddeath != $guidcc) && ($byweapon != 'none')))
		$stats_db->exec("UPDATE stats SET $addkill s_kill_streak = (case when s_kill_streak < $kill_streak THEN '$kill_streak' ELSE s_kill_streak END), s_kills=s_kills +1,s_skill = s_skill + '$skillbonus', s_playedkills = s_playedkills + 1, s_playedtime = s_playedtime + '$played_time' WHERE s_guid='$guidcc' and s_server = '$mysql_server'");

		}
		
	if ($iddeath) {

		$addkill = "";

		if ((($modkll == 'MOD_SUICIDE') && ($iddeath == $guidcc) && ($byweapon != 'none'))
			|| (($modkll != 'MOD_SUICIDE') && ($iddeath == $guidcc) && ($byweapon != 'none'))
			|| (($modkll == 'MOD_EXPLOSIVE') && ($iddeath == $guidcc) && ($byweapon == 'none'))
			|| (($modkll == 'MOD_TRIGGER_HURT') && ($byweapon == 'none'))
			|| (($modkll == 'MOD_FALLING') && ($byweapon == 'none'))) {
			$addkill = "s_suicids = s_suicids + 1,";
			echo '[SUICIDE]';
			}


		if ((($iddeath != $guidcc) && ($byweapon != 'none'))
			|| (($iddeath == $guidcc) && ($byweapon != 'none'))
			|| (($modkll == 'MOD_TRIGGER_HURT') && ($byweapon == 'none'))
			|| (($modkll == 'MOD_EXPLOSIVE') && ($byweapon == 'none'))
			|| (($modkll == 'MOD_FALLING') && ($byweapon == 'none')))
			$stats_db->exec("UPDATE stats SET $addkill s_death_streak = (case when s_death_streak < $death_streak THEN '$death_streak' ELSE s_death_streak END), s_playeddeaths = s_playeddeaths + 1, s_skill = s_skill - '$skillbonus', s_deaths=s_deaths +1, s_playedtime = s_playedtime + '$self_played_time' WHERE s_guid='$iddeath' and s_server = '$mysql_server'");
	}

