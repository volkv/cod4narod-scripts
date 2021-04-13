<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);
require_once BASEDIR . 'geoip/autoload.php';

use MaxMind\Db\Reader;

function BanPlayer($name, $guid, $ip, $path, $mysql_server, $type) {

    echo file_get_contents("https://cod4narod.ru/sourcebans/sb2342.php?name={$name}&guid={$guid}&ip={$ip}&path={$path}&mysql_server={$mysql_server}&type={$type}");
}

function checkSS($name, $guid, $ip, $path, $mysql_server, $url) {

    $response = file_get_contents("http://recod.ru/_Axon/json_index.php?key=de452d7955a370a2ea3d1ccc314dff0e&screensh=" . $url);

    if ($response) {
        $response = json_decode($response, true);

        if ($response["sign"] == "black_screen" && $response["signature"] == "detected") {
            BanPlayer($name, $guid, $ip, $path, $mysql_server, 1);
            if ($response["percentage"] != "100") {
                return "NOT 100";
            }

            return "BANNED BS";

        } else if ($response["signature"] == "detected") {
         
            if ($response["percentage"] > 99) {
          
			
			 //  BanPlayer($name, $guid, $ip, $path, $mysql_server, 0);

            return "BANNED PERM";
			  }
        }

        return "CLEAR";
    }

    return "NO RESPONSE";
}

function getGeo($ip) {

    $databaseFile = BASEDIR . 'geoip/DB/GeoIP2-City.mmdb';
    $databaseFile2 = BASEDIR . 'geoip/DB/GeoLite2-City.mmdb';

    $reader = new Reader($databaseFile);

    if (!is_null($reader))
        $geoarray = $reader->get($ip);
    else
        $geoarray = [];

    if (is_null($geoarray))
        $geoarray = [];

    $geocity = "";
    $geocountry = "";

    if (array_key_exists("country", $geoarray)) {
        $geocountry = $geoarray["country"]["names"]["en"];
    }
    if (array_key_exists("city", $geoarray)) {
        $geocity = $geoarray["city"]["names"]["en"];
    } else if (array_key_exists("subdivisions", $geoarray)) {
        $geocity = $geoarray["subdivisions"][0]["names"]["en"];
    }

    if (!is_null($reader))
        $reader->close();

    if ($geocity == "") {

        $reader = new Reader($databaseFile2);

        if (!is_null($reader))
            $geoarray = $reader->get($ip);
        else
            $geoarray = [];

        if (is_null($geoarray))
            $geoarray = [];

        $geocity = "";
        $geocountry = "";

        if (array_key_exists("country", $geoarray)) {
            $geocountry = $geoarray["country"]["names"]["en"];
        }
        if (array_key_exists("city", $geoarray)) {
            $geocity = $geoarray["city"]["names"]["en"];
        } else if (array_key_exists("subdivisions", $geoarray)) {
            $geocity = $geoarray["subdivisions"][0]["names"]["en"];
        }

        if (!is_null($reader))
            $reader->close();
    }

    return $geocountry . ";" . $geocity;

}

function readlogline() {

    clearstatcache();

    $output = "";

    $parser_pos = file_get_contents(SERVERDIR . 'C4N_PARSER/cache/parser_pos');

    if (filesize(SERVERDIR . 'main/games_mp.log') == $parser_pos) {

        return $output;

    }

    if (filesize(SERVERDIR . 'main/games_mp.log') < $parser_pos) {

        file_put_contents($SERVERDIR . 'C4N_PARSER/cache/parser_pos', 0);

        $parser_pos = 0;
    }

    $newPos = $parser_pos;

    $fp = fopen(SERVERDIR . 'main/games_mp.log', "r");

    fseek($fp, $parser_pos, SEEK_SET);

    $get = fgets($fp);

    if ($get === false) {
        return $output;
    }

    $newPos += strlen($get);

    file_put_contents(SERVERDIR . 'C4N_PARSER/cache/parser_pos', $newPos);

    $output = $get;

    fclose($fp);

    $output = str_replace("'", "''", $output);

    return trim($output);
}

function clearIP($ip) {

    $parts = explode(":", $ip);

    if (sizeof($parts) < 3)
        return explode(":", $ip)[0];
    else
        return str_replace("[", "", explode("]:", $ip)[0]);

}

function AddToLogGUID($s) {

    $fp = fopen(SERVERDIR . 'C4N_PARSER/logs/enter.log', 'a');
    fwrite($fp, $s . "\n");
    fclose($fp);
}

function rcon($sz, $zreplace = '') {

    global $server_rconpass, $server_port, $server_ip;

    $server_addr = "udp://" . $server_ip;
    @$connect = fsockopen($server_addr, $server_port, $re, $errstr, 30);
    if (!$connect) {
        die('Can\'t connect to COD gameserver.');
    }

    if ((strpos($sz, 'tell') !== false) || (strpos($sz, 'say') !== false))
        fwrite($connect, "\xff\xff\xff\xff" . 'rcon "' . $server_rconpass . '" ' . strtr($sz, array('%s' => $zreplace)));

    return fread($connect, 1);
}