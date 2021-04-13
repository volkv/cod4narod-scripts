<?php
date_default_timezone_set('Europe/Moscow');
error_reporting(E_ALL);
ini_set('display_errors', 1);
global $parsedline;
global $datetime;

$stats_db = new PDO('mysql:host=localhost;dbname=cod4stats', 'login', 'password');

list($vv1, $guid, $name, $ip, $path) = explode(';', $parsedline);

$path = str_replace("./screenshots/", '', $path);
$name = mb_convert_encoding($name, "utf-8", "windows-1251");

$ip = clearIP($ip);

$banned = 0;
$axon = 0;
//$ss_status = checkSS(urlencode($name), $guid, $ip, $path, $mysql_server, "https://cod4narod.ru/screenshots/files/" . $mysql_server . "_server/" . urlencode($path));

$ss_status = "";
if ($ss_status == "BANNED PERM") {
    $axon = 1;
} else if ($ss_status == "BANNED BS") {
    $banned = 1;
}
echo "\n[SS] : [", $datetime, "] : [" . $name . " -> " . $path . "] " . $ss_status;

$stats_db->exec("INSERT INTO ss (guid, name, ip, path, date, server, banned, axon) VALUES ('$guid','$name','$ip','$path','$datetime','$mysql_server', $banned, $axon)");
