<?php
date_default_timezone_set('Europe/Moscow');
	error_reporting(E_ALL);
	ini_set('display_errors', 1);
$amount = (int)$_GET["amount"];
$guid = (int)$_GET["label"];

$datetime = date("Y-m-d H:i:s");

$stats_db = new PDO('mysql:host=localhost;dbname=cod4stats', 'login', 'password');

if (strlen($guid) == 19) {

    $stats_db->exec("INSERT INTO vip(guid, name) VALUES ('" . $guid . "', (SELECT s_player FROM stats WHERE s_guid = '" . $guid . "' ORDER by s_lasttime desc limit 1))");

    $stats_db->exec("INSERT INTO donations (notification_type, operation_id, amount, withdraw_amount, datetime, sender, label, user) VALUES ('p2p-incoming','','" . $amount . "','" . $amount . "','" . $datetime . "','','',(SELECT s_player FROM stats WHERE s_guid = '" . $guid . "' ORDER by s_lasttime desc limit 1))");

    $days = 0;

    if ($amount < 10)
        $days = round($amount / 20);

    else if ($amount < 20)
        $days = round($amount / 15);

    else if ($amount < 40)
        $days = round($amount / 10);

    else if ($amount < 50)
        $days = round($amount / 8);

    else if ($amount < 100)
        $days = round($amount / 5);

    else if ($amount < 300)
        $days = round($amount / 4.5);

    else if ($amount < 500)
        $days = round($amount / 4.3);

    else if ($amount < 1000)
        $days = round($amount / 4.0);

    else if ($amount < 2000)
        $days = round($amount / 3.5);

    else
        $days = round($amount / 3);

	if ($days != 0)
			$days++;
		
    $stats_db->exec("UPDATE vip set days=days+" . $days . " where guid = '" . $guid . "'");

    echo "OK " . $guid . " __ " . $days;

}

$stats_db = null;