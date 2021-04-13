<?php

global $datetime;
global $parsedline;

list($sayyy, $guidn, $idnum, $nickr, $msgr) = explode(';', $parsedline);

$msgr = str_replace(array(""), '', $msgr);
$msgr = mb_convert_encoding($msgr, "utf-8", "windows-1251");
$nickr = mb_convert_encoding($nickr, "utf-8", "windows-1251");

echo "\n[SAY][", $datetime, "] " . $nickr . " : " . $msgr;

$stats_db = new PDO('mysql:host=localhost;dbname=cod4stats', 'login', 'password');

$statement = $stats_db->prepare("INSERT INTO chat (date, guid, player, message, server) VALUES ('$datetime','$guidn',:user,:message,'$mysql_server')");
$statement->execute(array(
	"user" => $nickr,
	"message" => $msgr
));