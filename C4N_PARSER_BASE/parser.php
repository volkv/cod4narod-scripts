#!/bin/php
<?php

date_default_timezone_set('Europe/Moscow');

header('Content-Type: text/html; charset=UTF-8');

mb_internal_encoding('UTF-8');
mb_http_output('UTF-8');
mb_http_input('UTF-8');
mb_regex_encoding('UTF-8');

require_once 'config.php';

ini_set("log_errors", "1");
ini_set("error_log", SERVERDIR . "C4N_PARSER/logs/error.log");

require_once BASEDIR . "functions.php";

// Clean games_mp

	file_put_contents(SERVERDIR .'main/games_mp.log', "");

// Reset parser position

file_put_contents(SERVERDIR . 'C4N_PARSER/cache/parser_pos', 0);

echo "\nCoD4Narod.RU Admin Tool is ready to work\n";

// Get players count from xml (for parsing speed optimization)

$pl_cnt = (int)simplexml_load_file('../serverstatus.xml')->Clients[0]['Total'][0];
$check_pl_cnt = 0;

while (true) {

	if ($pl_cnt < 4)
		$sleep = 1000000; // 1 second delay if less than 4 players online
	else
		$sleep = (int)(1000000 / ($pl_cnt / 3)); // Progressive delay based on players count

	// Check players count every 30 seconds

	if ($check_pl_cnt > 30000000) {
		$pl_cnt = (int)simplexml_load_file('../serverstatus.xml')->Clients[0]['Total'][0];

		$check_pl_cnt = 0;
	}

	usleep($sleep);

	$check_pl_cnt += $sleep;

	$parsedline = readlogline();
	
	if ($parsedline == "")
	continue;

	$datetime = date('Y-m-d H:i:s');

	if (((strpos($parsedline, ' say;2310') !== false) || (strpos($parsedline, ' sayteam;2310') !== false)) && (strpos($parsedline, 'QUICKMESSAGE') == false)) {

		require BASEDIR . 'parser/parser_chat.php'; // Chat

	} else if (strpos($parsedline, ' J;2310') !== false) {

		require BASEDIR . 'parser/parser_join.php'; // Join/Geo Welcome

	} else if (strpos($parsedline, ' K;2310') !== false) {

		require BASEDIR . 'parser/parser_stats.php'; // Stats

	} else if (strpos($parsedline, ' SS;2310') !== false) {

		require BASEDIR . 'parser/parser_ss.php'; // Screenshots
		
	} else if (strpos($parsedline, ' STAT;2310') !== false) {

		require BASEDIR . 'parser/parser_statistics.php'; // Statistics
	}
	
	$stats_db = NULL;
}