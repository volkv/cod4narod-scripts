<?php
// *************************************************************************
//  This file is part of SourceBans++.
//
//  Copyright (C) 2014-2016 Sarabveer Singh <me@sarabveer.me>
//
//  SourceBans++ is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, per version 3 of the License.
//
//  SourceBans++ is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with SourceBans++. If not, see <http://www.gnu.org/licenses/>.
//
//  This file is based off work covered by the following copyright(s):  
//
//   SourceBans 1.4.11
//   Copyright (C) 2007-2015 SourceBans Team - Part of GameConnect
//   Licensed under GNU GPL version 3, or later.
//   Page: <http://www.sourcebans.net/> - <https://github.com/GameConnect/sourcebansv1>
//
// *************************************************************************




// ---------------------------------------------------
// Functions included and modified from other files. Required to use with the http interface of cod4x18server
// ---------------------------------------------------

//ini_set("log_errors", "1");
//ini_set("error_log", "error.log");
error_reporting(E_ALL & ~E_NOTICE & ~E_STRICT & ~E_DEPRECATED);

//Entry point is here

    $values = array();
    $rawdata = file_get_contents('php://input');
	//var_dump($rawdata);
    mb_parse_str($rawdata, $values);

    if(!isset($values["identkey"])){
        $response = array('status' => 'invalid_inputparamters');
        echo http_build_query($response);
        return;
    }

    define('IN_SBSVEXEC', 1);
    include 'serverexec_conf.php';

    if($values["identkey"] !== $identkey){
        $response = array('status' => 'invalid_identkey');
        echo http_build_query($response);
        return;
    }


    if($identkey == "ChangeMe")
    {
        $response = array('status' => 'change_default_identkey');
        echo http_build_query($response);
        return;
    }

        $response = array(
            'status' => 'permission',
            'message' => 'You have no permissions');


//    file_put_contents("input.txt", var_export($values, true));

    /* Source Bans */
    global $userbank;

    /* Trick to use server permissions */
    define('ADMIN_ADD_BAN', "dz");
    define('ADMIN_OWNER', "");

    require_once('init.php');
    unset($_COOKIE['password']);

    require_once(INCLUDES_PATH.'/sb-callback.php');

    $serverexec = new serverexec();

    $response = array();
    $authid = "";

    if(!isset($values["command"]))
    {
        $response = array('status' => 'invalid_inputparamters');
    }else{
        if(!isset($values['adminsteamid'])){
            $response = array(
            'status' => 'permission',
            'message' => 'You have no permissions');
            $authid = -1;

        }else if($values['adminsteamid'] == 0){
        /* Patch to act from console */
            class CUserManagerPatch extends CUserManager {
                function HasAccess($flags, $aid=-2)
                {
                    return TRUE;
                }
            }
            $userbank = new CUserManagerPatch(0, 0);
            $userbank->aid = 0;

        }else{
            /* Regular admin */
            $steam32id = $values['adminsteamid'];
            if((!is_numeric($steam32id) && !validateconvert_steam($steam32id)) || (is_numeric($steam32id) && (strlen($steam32id) < 15
            || !validate_steam($steam32id = FriendIDToSteamID($steam32id)))))
            {
                $steam32id = 0;
                $values['adminsteamid'] = 0;
            }

            $admins = $userbank->GetAllAdmins();

            foreach($admins as $admin)
            {
                if($admin['authid'] == $values['adminsteamid'] || $admin['authid'] == $steam32id)
                {
                    $userbank->aid = $admin['aid'];
                    $authid = $admin['authid'];
                    break;
                }
            }
            if($userbank->aid <= 0)
            {
                $response = array(
                'status' => 'permission',
                'message' => 'You have no permissions');
                $authid = -1;
            }

        }

        if(!empty($response))
        {
//            file_put_contents("output.txt", var_export($response, true));
            echo http_build_query($response);
            return;
        }

        if($values["command"] == "HELO")
        {
            if(empty($values['gamename']) || empty($values['gamedir']))
            {
                $response = array(
                'status' => "Error: Empty gamename or gamedir value");
            }else if(empty($_SERVER['REMOTE_ADDR']) || empty($values['serverport'])){
                $response = array(
                'status' => "Error: Empty serverip or serverport value");

            }else if(empty($values['rcon'])){
                $response = array(
                'status' => "Error: Empty rcon value");
            }else{

                $ret = $serverexec->AddMod($GLOBALS['db'], $userbank, $values['gamename'], $values['gamedir'], $values['gamedir'].".png", 0, true, $modinfo);

                if($ret !== "success" && $ret !== "Already present")
                {
                    $response = array(
                    'status' => $ret);
                }else{

                    if(empty($modinfo['mid']) || (int)($modinfo['mid']) < 1)
                    {
                        $response = array(
                        'status' => "Couldn't add mod to database");
                    }else{
                        $serverexec->AddServer($GLOBALS['db'], $userbank, $_SERVER['REMOTE_ADDR'], $values['serverport'], $values['rcon'], $modinfo['mid'], true);
                        if($ret !== "success" && $ret !== "Already present")
                        {
                            $response = array(
                            'status' => $ret);
                        }else{
                            $proto = empty($_SERVER['HTTPS']) ? "http://" : "https://";
                            $port = $_SERVER['SERVER_PORT'] != 80 && $_SERVER['SERVER_PORT'] != 443 ? ":".$_SERVER['SERVER_PORT'] : "";
                            $sourcebansurl = dirname($proto.$_SERVER['HTTP_HOST'].$port.$_SERVER['REQUEST_URI'])."/";
                            $response = array(
                            'status' => 'okay',
                            'showbanlistmessage' => 'Please visit '.$sourcebansurl.' to view the banlist');
                        }
                    }
                }
            }
        }else if($values["command"] == "queryplayer"){
            $playerid = "";
            $ip = "";
            if(isset($values['playerid']))
            {
              $playerid = $values['playerid'];
            }
            if(isset($values['address']))
            {
              $ip = $values['address'];
            }
            $status = $serverexec->QueryPlayer($GLOBALS['db'], $userbank, $playerid, $ip, $result);
            if($status !== "success")
            {
              $response = array('status' => $status, 'playerid' => $playerid);
            }else{
              if((int)$result['length'] === 0)
              {
                $expire = -1;
              }else{
                $expire = $result['ends'];
              }
              $response = array(
              'status' => 'active',
              'playerid' => $result['authid'],
              'message' => $result['reason'],
              'expire' => $expire,
              'created' => $result['created'],
              'length' => $result['length'],
              'steamid' => '');
            }
        }else if($values["command"] == "modifyban"){
            if(!isset($values["adminsteamid"])){
                $response = array(
                'status' => 'permission',
                'message' => 'You have no permission to modify ban records');
            }else if(!isset($values["timeleft"])){
                $response = array(
                'status' => 'error',
                'message' => 'timeleft undefined');
            }else{
              $playername = "";
              $ip = "";
              $banreason = "";
              $playerid = "";
              $steamid = "";

              if(isset($values['playername']))
              {
                $playername = $values['playername'];
              }
              if(isset($values['address']))
              {
                $ip = $values['address'];
              }
              if(isset($values['reason']))
              {
                $banreason = $values['reason'];
              }
              if(isset($values['playerid']))
              {
                $playerid = $values['playerid'];
              }
              if(isset($values['steamid']))
              {
                $steamid = $values['steamid'];
              }

              $bantime = (int)$values['timeleft'];

              if($bantime === -1 || $bantime > 0)
              {
                if($bantime === -1)
                {
                  //This is a permanent ban
                  $bantime = 0;
                }
                $status = $serverexec->AddBan($GLOBALS['db'], $userbank, $playerid, $ip, $bantime, $banreason, $playername);
                if($status === "Already Banned")
                {
                    $status = $serverexec->EditBan($GLOBALS['db'], $userbank, $playerid, $bantime, "");
                }
                if($status === "success")
                {
                  $status = "success_ban";
                }
              }else if($bantime === 0){
                //This is an unban
                $status = $serverexec->RemoveBan($GLOBALS['db'], $userbank, $playerid, "Unban from game/console");
                if($status === "success")
                {
                  $status = "success_unban";
                }
              }

              $response = array(
              'status' => $status,
              'steamid' => $steamid,
              'nick' => '$playername',
              'playerid' => $playerid);
            }

        }else if($values["command"] == "querypermissions"){
            if(!isset($values["adminsteamid"])){
              $response = array(
              'status' => 'notfound',
              'steamid' => '',
              'cmdlist' => '',
              'message' => '');
            }

            $cmdlist = "cmdlist;ministatus;rules";

            if($userbank->HasAccess(SM_ROOT . SM_RCON . SM_FULL . SM_GENERIC))
            {
                $cmdlist .= ";getss;record;warn;undercover;stoprecord;changepassword;status;sm_chat;smc";
                $cmdlist .= $additionalGenericAdminCommands;
            }else{
                if($userbank->HasAccess(SM_CHAT))
                {
                    $cmdlist .= ";sm_chat;smc";
                }
            }

            if($userbank->HasAccess(SM_ROOT . SM_RCON . SM_FULL))
            {
                $cmdlist .= ";kick;tempban;permban;unban;map;map_rotate;map_restart;say;screensay;tell;screentell";
                $cmdlist .= $additionalFullAdminCommands;
            }else{
                if($userbank->HasAccess(SM_KICK))
                {
                    $cmdlist .= ";kick";
                }
                if($userbank->HasAccess(SM_BAN))
                {
                    $cmdlist .= ";tempban;permban";
                }
                if($userbank->HasAccess(SM_UNBAN))
                {
                    $cmdlist .= ";unban";
                }
                if($userbank->HasAccess(SM_MAP))
                {
                    $cmdlist .= ";map;map_rotate;map_restart";
                }

            }

            if($userbank->HasAccess(SM_ROOT . SM_RCON))
            {
                $cmdlist .= ";set;exec;adminchangepassword;adminlistadmins;adminaddadmin;adminremoveadmin;adminlistcommands";
                $cmdlist .= $additionalRootAdminCommands;
            }else{
                if($userbank->HasAccess(SM_CVAR))
                {
                    $cmdlist .= ";set";
                }
                if($userbank->HasAccess(SM_CONFIG))
                {
                    $cmdlist .= ";exec";
                }
            }

            $response = array(
            'status' => 'success',
            'steamid' => $values["adminsteamid"],
            'cmdlist' => $cmdlist,
            'message' => '');

        }else{

            $response = array('status' => 'invalid_command');
        }

    }

if ($response['status'] != 'Ban Not Found')
	file_put_contents("output.txt", var_export($response, true), FILE_APPEND);

    echo http_build_query($response);





class serverexec
{
    public function CheckForBlocks($db, $userbank, $steam, &$output)
    {
        // If they didn't type a steamid
        if(empty($steam))
        {
            return "No Steam ID or IP set";
        }
    	else if((!is_numeric($steam) && !validateconvert_steam($steam)) || (is_numeric($steam) && (strlen($steam) < 15
    	|| !validate_steam($steam = FriendIDToSteamID($steam)))))
    	{
    		return "Bad Steam ID";
        }
        $bid = $db->GetRow("SELECT bid FROM ".DB_PREFIX."_comms WHERE authid = ? AND type = 2 AND (length = 0 OR ends > UNIX_TIMESTAMP()) AND RemovedBy IS NULL", array($steam));

        if($bid['bid'] != NULL)
        {
            return "chat";
        }

        $bid = $db->GetRow("SELECT bid FROM ".DB_PREFIX."_comms WHERE authid = ? AND type = 1 AND (length = 0 OR ends > UNIX_TIMESTAMP()) AND RemovedBy IS NULL", array($steam));

        if($bid['bid'] != NULL)
        {
            return "mute";
        }
        return "Ban Not Found";

    }

    public function QueryPlayer($db, $userbank, $steam, $ip, &$output)
    {
        // If they didn't type a steamid
        if(empty($steam))
        {
            if(empty($ip))
            {
                return "No Steam ID or IP set";
            }
        }
    	else if((!is_numeric($steam) && !validateconvert_steam($steam)) || (is_numeric($steam) && (strlen($steam) < 15
    	|| !validate_steam($steam = FriendIDToSteamID($steam)))))
    	{
    		return "Bad Steam ID";
    	}
   	$ip = RemoveCode($ip);

        if(!empty($steam))
        {

            $id = $db->GetRow("SELECT bid FROM ".DB_PREFIX."_bans WHERE authid = ? AND (length = 0 OR ends > UNIX_TIMESTAMP()) AND RemovedBy IS NULL", array($steam));
        }else{
            $id = $db->GetRow("SELECT bid FROM ".DB_PREFIX."_bans WHERE ip = ? AND (length = 0 OR ends > UNIX_TIMESTAMP()) AND RemovedBy IS NULL", array($ip));
        }

        if($id['bid'] == NULL)
        {
            return $this->CheckForBlocks($db, $userbank, $steam, $output);
        }
	$id = $id['bid'];
	$res = $db->GetRow("
					SELECT ba.ip, ba.authid, ba.name, created, ends, length, reason, ba.aid, ad.user
        				FROM ".DB_PREFIX."_bans AS ba
        				LEFT JOIN ".DB_PREFIX."_admins AS ad ON ba.aid = ad.aid
        				LEFT JOIN ".DB_PREFIX."_servers AS se ON se.sid = ba.sid
        				LEFT JOIN ".DB_PREFIX."_mods AS mo ON mo.mid = se.modid
        				WHERE bid = {$id}");

        if(!isset($res['authid']) && !isset($res['ip']))
        {
            return "Database entry error";
        }
        $output = $res;
        $output['authid'] = SteamIDToFriendID($output['authid']);
        return "success";
    }
    /* Susposed to change ban time */
    public function EditBan($db, $userbank, $steam, $banlength, $txtReason)
    {
      // If they didn't type a steamid
    	if(empty($steam))
    	{
    		return "No Steam ID set";
    	}
    	else if((!is_numeric($steam) && !validateconvert_steam($steam))
    	|| (is_numeric($steam)
    	&& (strlen($steam) < 15
    	|| !validate_steam($steam = FriendIDToSteamID($steam)))))
    	{
    		return "Bad Steam ID";
    	}

      $id = $db->GetRow("SELECT bid FROM ".DB_PREFIX."_bans WHERE authid = ? AND (length = 0 OR ends > UNIX_TIMESTAMP()) AND RemovedBy IS NULL AND type = '0'", array($steam));

      if($id['bid'] == NULL)
      {
        return "Ban Not Found";
      }
      $id = $id['bid'];
    	$res = $db->GetRow("
        				SELECT bid, ba.ip, ba.type, ba.authid, ba.name, created, ends, length, reason, ba.aid, ba.sid, ad.user, ad.gid, CONCAT(se.ip,':',se.port), se.sid, mo.icon, (SELECT origname FROM ".DB_PREFIX."_demos WHERE demtype = 'b' AND demid = {$id})
        				FROM ".DB_PREFIX."_bans AS ba
        				LEFT JOIN ".DB_PREFIX."_admins AS ad ON ba.aid = ad.aid
        				LEFT JOIN ".DB_PREFIX."_servers AS se ON se.sid = ba.sid
        				LEFT JOIN ".DB_PREFIX."_mods AS mo ON mo.mid = se.modid
        				WHERE bid = {$id}");
    	if (!$userbank->HasAccess(SM_ROOT)&&!$userbank->HasAccess(ADMIN_OWNER|ADMIN_EDIT_ALL_BANS)&&(!$userbank->HasAccess(ADMIN_EDIT_OWN_BANS) && $res[8]!=$userbank->GetAid())&&(!$userbank->HasAccess(ADMIN_EDIT_GROUP_BANS) && $res->fields['gid']!=$userbank->GetProperty('gid')))
    	{
    		return "Insufficient Permissions";
    	}

    	$steam = trim($steam);

    	// prune any old bans
    	PruneBans();

    	// Check if the new steamid is already banned
    	$chk = $db->GetRow("SELECT count(bid) AS count FROM ".DB_PREFIX."_bans WHERE authid = ? AND (length = 0 OR ends > UNIX_TIMESTAMP()) AND RemovedBy IS NULL AND type = '0' AND bid != ?", array($steam, (int)$id));

    	if((int)$chk[0] > 0)
    	{
    		return "Already Banned";
    	}
    	else
    	{
    	// Check if player is immune
    		$admchk = $userbank->GetAllAdmins();
    		foreach($admchk as $admin)
    		{
    			if($admin['authid'] == $steam && $userbank->GetProperty('srv_immunity') < $admin['srv_immunity'])
    			{
    				return "Player is immune";
    			}
    		}
    	}
    	$reason = RemoveCode(trim($txtReason));

    	if(!$banlength)
    		$banlength = 0;
    	else
    		$banlength = (int)$banlength*60;

    	// Only process if there are still no errors
    	$lengthrev = $db->Execute("SELECT length, authid, reason FROM ".DB_PREFIX."_bans WHERE bid = '".(int)$id."'");

    	// Didn't type a custom reason
    	if(empty($reason))
    	{
    		$reason = $lengthrev['reason'];
    	}

    	$edit = $db->Execute("UPDATE ".DB_PREFIX."_bans SET
    									`authid` = ?,
    									`reason` = ?,
    									`length` = ?,
    									`country` = '',
    									`ends` = `created` + ?
    									WHERE bid = ?", array($steam, $reason, $banlength, $banlength, (int)$id));

    	// Set all submissions to archived for that steamid
    	$db->Execute("UPDATE `".DB_PREFIX."_submissions` SET archiv = '3', archivedby = '".$userbank->GetAid()."' WHERE SteamId = ?;", array($steam));


    	if($banlength != $lengthrev->fields['length'])
    		$log = new CSystemLog("m", "Ban length edited", "Ban length for (" . $lengthrev->fields['authid'] . ") has been updated, before: ".$lengthrev->fields['length'].", now: ".$banlength);
    	return "success";
    }

    public function AddBan($db, $userbank, $steam, $ip, $length, $reason, $nickname)
    {
		
			if ($reason == "Violating internal system rules (Antihack)") {
			return;
		}
		
    	global $username;
    	if(!$userbank->HasAccess(SM_ROOT.SM_BAN))
    	{
    		$log = new CSystemLog("w", "Hacking Attempt", $username . " tried to add a ban, but doesnt have access.");
    		return "Insufficient Permissions";
    	}

    	$steam = trim($steam);
    	// If they didnt type a steamid
    	if(empty($steam))
    	{
          return "No Steam ID set";
    	}
    	else if((!is_numeric($steam)
    	&& !validateconvert_steam($steam))
    	|| (is_numeric($steam)
    	&& (strlen($steam) < 15
    	|| !validate_steam($steam = FriendIDToSteamID($steam)))))
    	{
          return "Bad Steam ID";
    	}

    	$nickname = RemoveCode($nickname);
    	$reason = RemoveCode($reason);
    	if(!$length)
    		$len = 0;
    	else
    		$len = (int)$length*60;

      // prune any old bans
	    PruneBans();
		  // Check if the new steamid is already banned
		  $chk = $db->GetRow("SELECT count(bid) AS count FROM ".DB_PREFIX."_bans WHERE authid = ? AND (length = 0 OR ends > UNIX_TIMESTAMP()) AND RemovedBy IS NULL AND type = '0'", array($steam));

		  if(intval($chk[0]) > 0)
	    {
			    return "Already Banned";
		  }

      // Check if player is immune
      $admchk = $userbank->GetAllAdmins();
      foreach($admchk as $admin)
          if($admin['authid'] == $steam && $userbank->GetProperty('srv_immunity') < $admin['srv_immunity'])
          {
              return "Player is immune";
          }

    	$pre = $db->Prepare("INSERT INTO ".DB_PREFIX."_bans(created,type,ip,authid,name,ends,length,reason,aid,adminIp ) VALUES
    									(UNIX_TIMESTAMP(),0,?,?,?,(UNIX_TIMESTAMP() + ?),?,?,?,?)");
    	$db->Execute($pre,array($ip,
    									   $steam,
    									   $nickname,
    									   $len,
    									   $len,
    									   $reason,
    									   $userbank->GetAid(),
    									   "0.0.0.0"));
    	$subid = $db->Insert_ID();

    	$db->Execute("UPDATE `".DB_PREFIX."_submissions` SET archiv = '3', archivedby = '".$userbank->GetAid()."' WHERE SteamId = ?;", array($steam));

    	$log = new CSystemLog("m", "Ban Added", "Ban against (" . $steam . ") has been added, reason: $reason, length: $length", true, false);
    	return "success";
    }

    /* Susposed to change ban time */
    public function RemoveBan($db, $userbank, $steam, $txtReason)
    {

      // If they didn't type a steamid
    	if(empty($steam))
    	{
    		return "No Steam ID set";
    	}
    	else if((!is_numeric($steam) && !validateconvert_steam($steam))
    	|| (is_numeric($steam)
    	&& (strlen($steam) < 15
    	|| !validate_steam($steam = FriendIDToSteamID($steam)))))
    	{
    		return "Bad Steam ID";
    	}

      $id = $db->GetRow("SELECT bid FROM ".DB_PREFIX."_bans WHERE authid = ? AND (length = 0 OR ends > UNIX_TIMESTAMP()) AND RemovedBy IS NULL AND type = '0'", array($steam));

      if($id['bid'] == NULL)
      {
        return "Ban Not Found";
      }
      $id = $id['bid'];
    	$res = $db->GetRow("
        				SELECT bid, ba.ip, ba.type, ba.authid, ba.name, created, ends, length, reason, ba.aid, ba.sid, ad.user, ad.gid, CONCAT(se.ip,':',se.port), se.sid, mo.icon, (SELECT origname FROM ".DB_PREFIX."_demos WHERE demtype = 'b' AND demid = {$id})
        				FROM ".DB_PREFIX."_bans AS ba
        				LEFT JOIN ".DB_PREFIX."_admins AS ad ON ba.aid = ad.aid
        				LEFT JOIN ".DB_PREFIX."_servers AS se ON se.sid = ba.sid
        				LEFT JOIN ".DB_PREFIX."_mods AS mo ON mo.mid = se.modid
        				WHERE bid = {$id}");
    	if (!$userbank->HasAccess(SM_ROOT) && !$userbank->HasAccess(SM_UNBAN) && !$userbank->HasAccess(ADMIN_OWNER|ADMIN_UNBAN)&&(!$userbank->HasAccess(ADMIN_UNBAN_OWN_BANS) && $res[8]!=$userbank->GetAid())&&(!$userbank->HasAccess(ADMIN_UNBAN_GROUP_BANS) && $res->fields['gid']!=$userbank->GetProperty('gid')))
    	{
    		return "Insufficient Permissions";
    	}

    	$steam = trim($steam);

    	// prune any old bans
    	PruneBans();

    	// Check if the new steamid is already banned
    	$chk = $db->GetRow("SELECT count(bid) AS count FROM ".DB_PREFIX."_bans WHERE authid = ? AND (length = 0 OR ends > UNIX_TIMESTAMP()) AND RemovedBy IS NULL AND type = '0' AND bid != ?", array($steam, (int)$id));
    	if((int)$chk[0] > 0)
    	{
    		return "Already Banned";
    	}
    	$reason = RemoveCode(trim($txtReason));

    	// Didn't type a custom reason
    	if(empty($reason))
    	{
    		return "No Unban Reason";
    	}

    	$edit = $db->Execute("UPDATE ".DB_PREFIX."_bans SET
    									`RemovedBy` = ?,
    									`RemoveType` = 'U',
    									`RemovedOn` = UNIX_TIMESTAMP(),
    									`ureason` = ?
    									WHERE bid = ?", array($userbank->GetAid(), $reason, (int)$id));

    	// Set all submissions to archived for that steamid
    	$db->Execute("UPDATE `".DB_PREFIX."_submissions` SET archiv = '3', archivedby = '".$userbank->GetAid()."' WHERE SteamId = ?;", array($steam));


	$log = new CSystemLog("m", "Ban removed", "Unbanned with reason".$reason);
    	return "success";
    }

    public function AddMod($db, $userbank, $name, $folder, $icon, $steam_universe, $enabled, &$output)
    {
	global $username;
	if(!$userbank->HasAccess(ADMIN_OWNER|ADMIN_ADD_MODS))
	{
		return "Insufficient Permissions";
	}
	$name = RemoveCode($name);//don't want to addslashes because execute will automatically do it
	$icon = RemoveCode($icon);
	$folder = RemoveCode($folder);
	$steam_universe = (int)$steam_universe;
	$enabled = (int)$enabled;
	
	// Already there?
	$modinfo = $db->GetRow("SELECT * FROM `" . DB_PREFIX . "_mods` WHERE modfolder = ? OR name = ?;", array($folder, $name));
	if(!empty($modinfo))
	{
		$output = $modinfo;
		return "Already present";
	}

	$pre = $db->Prepare("INSERT INTO ".DB_PREFIX."_mods(name,icon,modfolder,steam_universe,enabled) VALUES (?,?,?,?,?)");
	$db->Execute($pre,array($name, $icon, $folder, $steam_universe, $enabled));

	$modinfo = $db->GetRow("SELECT * FROM `" . DB_PREFIX . "_mods` WHERE modfolder = ? OR name = ?;", array($folder, $name));

	$log = new CSystemLog("m", "Mod Added", "Mod ($name) has been added");

	$output = $modinfo;
	return "success";
    }



    public function AddServer($db, $userbank, $ip, $port, $rcon, $mod, $enabled)
    {
	global $username;
	if(!$userbank->HasAccess(ADMIN_OWNER|ADMIN_ADD_SERVER))
	{
		return "Insufficient Permissions";
	}
	$ip = RemoveCode($ip);

	$error = 0;
	// ip
	if((empty($ip)))
	{
		return "No IP set";
	}
	else
	{
		if(!validate_ip($ip) && !is_string($ip))
		{
			return "Not a valid IP";
		}
	}
	// Port
	if((empty($port)))
	{
		return "No port set";
	}
	else
	{
		if(!is_numeric($port))
		{
			return "Not a valid port";
		}
	}
	// rcon
	if(empty($rcon))
	{
		return "No rcon password set";
	}
	$rcon = RemoveCode($rcon);
	// Please Select
	if($mod < 1)
	{
		return "No mod set";
	}
	
	// Check for dublicates afterwards
	$chk = $db->GetRow('SELECT sid FROM `'.DB_PREFIX.'_servers` WHERE ip = ? AND port = ?;', array($ip, (int)$port));
	if($chk)
	{
		// Update all details about this server
		$db->Execute("UPDATE `".DB_PREFIX."_servers` SET rcon = '".$rcon."', modid = '".$mod."' WHERE ip = ? AND port = ?;", array($ip, (int)$port));
		return "Already present";
	}

	// ##############################################################
	// ##                     Start adding to DB                   ##
	// ##############################################################
	$sid = NextSid();
	
	$enable = ($enabled=="true"?1:0);

	// Add the server
	$addserver = $GLOBALS['db']->Prepare("INSERT INTO ".DB_PREFIX."_servers (`sid`, `ip`, `port`, `rcon`, `modid`, `enabled`)
										  VALUES (?,?,?,?,?,?)");
	$db->Execute($addserver,array($sid, $ip, (int)$port, $rcon, $mod, $enable));

        $log = new CSystemLog("m", "Server Added", "Server (" . $ip . ":" . $port . ") has been added");
	return "success";
    }

}


