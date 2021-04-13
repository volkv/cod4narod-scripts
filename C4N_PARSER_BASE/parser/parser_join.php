<?php

date_default_timezone_set('Europe/Moscow');

global $parsedline;

if (substr_count($parsedline, ';') == 5) {
	list($noon, $s_guid, $s_player, $ip, $s_fps, $s_ping) = explode(';', $parsedline);

	$ip = clearIP($ip);
	$s_player_utf = $s_player;
	$s_player = mb_convert_encoding($s_player, "utf-8", "windows-1251");

	//AddToLogGUID("[" . $datetime . "]" . $s_player . ";" . $s_guid . ";" . $ip . ";" . $geo_full);

	$geo_full = "Earth";

	$stats_db = new PDO('mysql:host=localhost;dbname=cod4stats', 'login', 'password');

	$row = $stats_db->query("select * FROM stats where s_guid = '$s_guid' and s_server = '$mysql_server' limit 1")->fetch();

	if ($row) {
		if (abs(strtotime($datetime) - strtotime($row['s_lasttime'])) > (3000 + mt_rand(0, 300))) {
			$geo = getGeo($ip);
			list($geocountry, $geocity) = explode(';', $geo);

			$geocity = str_replace("'", '', $geocity);

			if ($geocity == "")
				$geo_full = $geocountry;
			else
				$geo_full = $geocountry . ", " . $geocity;

			if ($geocity == "")
				$stats_db->exec("update stats set s_ip = '$ip', s_fps = (case when s_fps = 0 or s_fps = 999 THEN '$s_fps' ELSE (s_fps + $s_fps) / 2 END),s_ping = (case when s_ping = 0 or s_ping = 999 THEN '$s_ping' ELSE (s_ping + $s_ping) / 2 END) ,s_lasttime='$datetime', s_geo='$geocountry',s_player='$s_player' where s_guid ='$s_guid' and s_server = '$mysql_server'");
			else
				$stats_db->exec("update stats set s_ip = '$ip', s_fps = (case when s_fps = 0 or s_fps = 999 THEN '$s_fps' ELSE (s_fps + $s_fps) / 2 END),s_ping = (case when s_ping = 0 or s_ping = 999 THEN '$s_ping' ELSE (s_ping + $s_ping) / 2 END) ,s_lasttime='$datetime', s_city='$geocity', s_geo='$geocountry',s_player='$s_player' where s_guid ='$s_guid' and s_server = '$mysql_server'");

			rcon('consay ^3Welcome Back ^1' . $s_player . ' ^3from^2 ' . $geo_full, '');
		} else {
			$stats_db->exec("update stats set s_fps = (case when s_fps = 0 or s_fps = 999 THEN '$s_fps' ELSE (s_fps + $s_fps) / 2 END),s_ping = (case when s_ping = 0 or s_ping = 999 THEN '$s_ping' ELSE (s_ping + $s_ping) / 2 END) ,s_lasttime='$datetime', s_player='$s_player' where s_guid ='$s_guid' and s_server = '$mysql_server'");
		}
	} else {
		$geo = getGeo($ip);
		list($geocountry, $geocity) = explode(';', $geo);

		$geocity = str_replace("'", '', $geocity);

		if ($geocity == "")
			$geo_full = $geocountry;
		else
			$geo_full = $geocountry . ", " . $geocity;

		$stats_db->exec("INSERT INTO stats(s_player,s_kills,s_deaths,s_grenade,s_heads,s_time,s_lasttime,s_city,s_guid,s_geo, s_suicids,s_melle,s_ping,s_ip,s_fps,s_server)
								  VALUES ('$s_player','0','0','0','0','$datetime','$datetime','$geocity','$s_guid','$geocountry','0','0','$s_ping','$ip','$s_fps','$mysql_server')");


		rcon('say ^3Welcome ^1' . $s_player_utf . ' ^3from^2 ' . $geo_full, '');
	}
	echo "\n[JOIN]" . $s_player . ":" . $s_guid . ":" . $geo_full;
}