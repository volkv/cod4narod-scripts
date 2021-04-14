<?php

error_reporting(E_ALL);
ini_set('display_errors', 1);

if ($_SERVER['REMOTE_ADDR'] != $_SERVER['SERVER_ADDR']) {
    die("NO");
}

    $name = $_GET["name"];
    $guid = $_GET["guid"];
    $ip = $_GET["ip"];
    $path = $_GET["path"];
    $mysql_server = $_GET["mysql_server"];
    $type = $_GET["type"];

    include_once 'init.php';
    include_once(INCLUDES_PATH . "/user-functions.php");
    include_once(INCLUDES_PATH . "/system-functions.php");
    include_once(INCLUDES_PATH . "/sb-callback.php");

    global $userbank;

    class CUserManagerPatch2 extends CUserManager {

        function HasAccess($flags, $aid = -2) {
            return TRUE;
        }
    }

    $userbank = new CUserManagerPatch2(0, 0);
    $userbank->aid = 0;

    $filename = md5(time() . rand(0, 1000));

    file_put_contents(SB_DEMOS . "/" . $filename, file_get_contents("/var/www/html/screenshots/files/" . $mysql_server . "_server/" . $path));
    if ($type == 0) {

        AddBan($name, 0, $guid, $ip, 0, $filename, $path, "^1You are in server's blacklist. Please visit ^2CoD4Narod^3.RU ^0------- ^1BbI B 4EPHOM CnuCKE. CauT nPoeKTa ^2CoD4Narod^3.RU", $name);
    } elseif ($type == 1) {
        AddBan($name, 0, $guid, $ip, 120, $filename, $path, "	^1You are temp banned for black screenshots - ^2CoD4Narod^3.RU ^0------- ^1BbI BPEMEHHO 3A6AHEHbI 3A 4EPHbIE CKPUHbI ^2CoD4Narod^3.RU", $name);
        echo "BS";
    }


