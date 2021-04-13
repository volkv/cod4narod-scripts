<?php
date_default_timezone_set('Europe/Moscow');

global $parsedline;

$stats_db = new PDO('mysql:host=localhost;dbname=cod4stats', 'login', 'password');

list($vv1,$vv2,$time,$server,$map,$players) = explode(';', $parsedline);

$date = gmdate("Y-m-d\TH:i:s\Z", $time);
$date = date_create($date);
date_add($date, date_interval_create_from_date_string('42 years 3 hours'));

$datetime = date_format($date, 'Y-m-d H:i:s');

echo "\n[STAT] : [", $datetime, "] : [" . $map . " -> " . $players . "]";

$stats_db->exec("INSERT INTO statistics (time, server, map, players) VALUES('$datetime', '$server', (select id FROM maps_ctl WHERE map = '$map'), '$players')");