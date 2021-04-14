<?php


include_once("includes/adodb/adodb.inc.php");
include_once("includes/adodb/adodb-errorhandler.inc.php");


define('DB_HOST', 'localhost');   					// The host/ip to your SQL server
define('DB_USER', 'login');						// The username to connect with
define('DB_PASS', 'password');						// The password
define('DB_NAME', 'sourcebans');  						// Database name	
define('DB_PREFIX', 'sb');					// The table prefix for SourceBans
define('DB_PORT','3306');							// The SQL port (Default: 3306)
define('STEAMAPIKEY','');				// Steam API Key for Shizz
define('SB_WP_URL','http://cod4narod.ru/sourcebans/');       				//URL of SourceBans Site
define('SB_EMAIL','pvolkv@gmail.com');  



$GLOBALS['db'] = ADONewConnection("mysqli://".DB_USER.':'.DB_PASS.'@'.DB_HOST.':'.DB_PORT.'/'.DB_NAME);

if (isset($_GET['SteamtoGUID']) && !empty($_GET['SteamtoGUID']))
{
 echo SteamtoGUID($_GET['SteamtoGUID']);
}

if (isset($_GET['GUIDToSteam']) && !empty($_GET['GUIDToSteam']) )
{
		echo GUIDToSteam($_GET['GUIDToSteam']);
}

function SteamtoGUID($authid)
{
	$parts = array("0", "0", "0");

	if(strpos($authid, "STEAM_") === 0)
	{
		$parts = explode(":", substr($authid, 6));
	}

	$friendid = $GLOBALS['db']->GetRow("SELECT (((CAST('".$parts[0]."' AS UNSIGNED) + CAST('1' AS UNSIGNED)) << CAST('56' AS UNSIGNED)) | CAST('1' AS UNSIGNED) << CAST('52' AS UNSIGNED) | CAST('1' AS UNSIGNED) << CAST('32' AS UNSIGNED) | CAST('".$parts[1]."' AS UNSIGNED) & CAST('1' AS UNSIGNED) | CAST('".$parts[2]."' AS UNSIGNED) << CAST('1' AS UNSIGNED)) AS friend_id");
	return $friendid["friend_id"];
}


function GUIDToSteam($friendid)
{
	$steamid = $GLOBALS['db']->GetRow("SELECT CONCAT(\"STEAM_\", ((CAST('".$friendid."' AS UNSIGNED) >> CAST('56' AS UNSIGNED)) - CAST('1' AS UNSIGNED)),	\":\", (CAST('".$friendid."' AS UNSIGNED) &	CAST('1' AS UNSIGNED)), \":\", (CAST('".$friendid."' AS UNSIGNED) &	CAST('4294967295' AS UNSIGNED)) >> CAST('1' AS UNSIGNED)) AS steam_id;");
	return $steamid['steam_id'];
}




	