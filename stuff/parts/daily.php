<?php
$cache_file = "/var/www/html/parts/daily.html";

$timedif = (time() - filemtime($cache_file)); // how old is the file?
if ($timedif > 60) {


    ob_start();
    $sourcebans_db = new PDO('mysql:host=localhost;dbname=sourcebans', 'login', 'password');

    $perm_bans_query = $sourcebans_db->query("SELECT count(*) FROM `sb_bans` where aid = 0 and length = 0 and date(from_unixtime(created)) = CURDATE()");
    $perm_bans_count = $perm_bans_query->fetchColumn();

    $all_bans_query = $sourcebans_db->query("SELECT count(*) FROM `sb_bans` where length <> 240 and date(from_unixtime(created)) = CURDATE()");
    $all_bans_count = $all_bans_query->fetchColumn();

    $sourcebans_db = null;

    $stats_db = new PDO('mysql:host=localhost;dbname=cod4stats', 'login', 'password');

    $new_players_query = $stats_db->query("SELECT count(DISTINCT(s_guid)) FROM `stats` WHERE DATE(s_time) = CURDATE()");
    $new_players_count = $new_players_query->fetchColumn();

    $post_players_query = $stats_db->query("SELECT players FROM `statistics_players` WHERE server = 99 and date = DATE_SUB(curdate(), INTERVAL 1 day)");
    $post_players_count = $post_players_query->fetchColumn();

    $post_1_players_query = $stats_db->query("SELECT players FROM `statistics_players` WHERE server = 99 and date = DATE_SUB(curdate(), INTERVAL 2 day)");
    $post_players_diff = $post_players_count - $post_1_players_query->fetchColumn();

    $players_query = $stats_db->query("SELECT count(DISTINCT(s_guid)) FROM `stats` WHERE DATE(s_lasttime) = CURDATE()");
    $players_count = $players_query->fetchColumn();

    $c4n_players_query = $stats_db->query("SELECT count(*) FROM `stats` WHERE BINARY s_player = 'CoD4Narod.RU' and date(s_time) = curdate() ORDER BY `s_skill`  DESC");
    $c4n_nplayers_count = $c4n_players_query->fetchColumn();

    $screenshots_query = $stats_db->query("SELECT count(*) FROM `ss` WHERE DATE(date) = CURDATE()");
    $screenshots_count = $screenshots_query->fetchColumn();

    $messages_query = $stats_db->query("SELECT count(*) FROM `chat` WHERE DATE(date) = CURDATE()");
    $messages_count = $messages_query->fetchColumn();

    $kills_query = $stats_db->query("SELECT sum(s_kills) - sum(s_kills_d) FROM `stats`");
    $kills_count = $kills_query->fetchColumn();

    $vip_query = $stats_db->query("SELECT count(DISTINCT(name)), sum(days) FROM `vip` WHERE days > 0");
    $vip = $vip_query->fetchAll();
	
			$axon_query = $stats_db->query("SELECT COUNT(*) FROM ss where axon = 1 and banned = 0 and date > DATE_SUB(DATE(NOW()), INTERVAL 1 DAY) LIMIT 200");
		$axon_count = $axon_query->fetchColumn();

    $vip_count = $vip[0][0];
    $vip_days = $vip[0][1];

    $admin_query = $stats_db->query("SELECT count(DISTINCT(name)) FROM `vip` WHERE admin > 0");
    $admin_count = $admin_query->fetchColumn();

    $donations_query = $stats_db->query("SELECT GROUP_CONCAT(user SEPARATOR ', '), count(*) FROM `donations` WHERE date(datetime) = CURDATE()");
    $donations = $donations_query->fetchAll();
    $donations_names = $donations[0][0];
    $donations_count = $donations[0][1];
    $donations_names = ($donations_names) ? ' (<span style="color:#f39c12;">' . $donations_names . '</span>)' : '';

    function colorRAM($load) {

        if ($load < 80) {
            return "<span style='font-weight:bold;color: #00a81f'>{$load}%</span>";
        }
        if ($load < 90) {
            return "<span style='font-weight:bold;color: #f39c12'>{$load}%</span>";
        }

        return "<span style='font-weight:bold;color: #b12121'>{$load}%</span>";
    }

    function colorCPU($load) {
        if ($load < 3.5) {
            return "<span style='font-weight:bold;color: #00a81f'>{$load}</span>";
        }
        if ($load < 5.5) {
            return "<span style='font-weight:bold;color: #f39c12'>{$load}</span>";
        }

        return "<span style='font-weight:bold;color: #b12121'>{$load}</span>";

    }

    $loads = sys_getloadavg();

    $free = shell_exec('free');
    $free = (string)trim($free);
    $free_arr = explode("\n", $free);
    $mem = explode(" ", $free_arr[1]);
    $mem = array_filter($mem);
    $mem = array_merge($mem);
    $memory_usage = $mem[2] / $mem[1] * 100;

    $memory_usage = "RAM: " . colorRAM(round($memory_usage));
    $cpu_usage = "CPU: ";

    foreach ($loads as $key => $load) {
        if ($key == 2) {
            $cpu_usage .= colorCPU($load);
        } else {
            $cpu_usage .= colorCPU($load) . " / ";
        }

    }
    function getPings() {
        $output = "";
        $color = "#00a81f";
        $pings = json_decode(file_get_contents("/var/www/html/parts/ping"), true);
        foreach ($pings as $ping) {

            if (($ping["ping"] - $ping["norm"]) > 20) {
                $color = "#b12121";
            } else if (($ping["ping"] - $ping["norm"]) > 10) {
                $color = "#f39c12";
            }

            $output .= "<li>" . $ping["name"] . ': <span style="font-weight:bold;color:' . $color . ';">' . $ping["ping"] . " мс</span></li>";
        }

        return $output;
    }

    ?>
    <style>
        .today_stat {
            margin: 2px auto;
            font-weight: bold;
        }

        .today_green {
            color: #00a81f;
        }

        .today_ping {
            width: 16px;
            height: 16px;
            cursor: pointer;
            margin-left: 3px;
        }

        #today_pings {
            display: none;
            list-style: none;
            margin: 12px 0;
        }

        .today_title {
            font-weight: bold;
        }

        #today_pings.show {
            display: block;
        }
    </style>
    <div class="ipsType_richText" style="text-align: center;">

        <span style="font-size:22px;">Сегодня</span>
        <p class="today_stat">Игроков: <span style="color:#00a81f;"><?= $players_count ?></span> (<span class="today_green" title="Всего"><?= $new_players_count . '</span>/<span class="today_green" title="CoD4Narod.RU">' . $c4n_nplayers_count ?></span> новых)</p>
        <p class="today_stat">Полегло бойцов: <span class="today_green"><?= $kills_count ?></span></p>
        <p class="today_stat">Выписано банов: <span class="today_green"><?= $all_bans_count ?></span> (<span class="today_green"><?= $perm_bans_count ?></span> авто)</p>
        <p class="today_stat">Скриншотов снято: <span class="today_green"><?= $screenshots_count ?></span> (<a href="https://cod4narod.ru/screenshots/index.php?axon" target="_blank" title="Подозрительных" style="color:#00a81f;"><?= $axon_count ?></a>)</p>
        <p class="today_stat">Приятных сообщений в чате: <span class="today_green"><?= $messages_count ?></span></p>
        <p class="today_stat">Постоянных игроков: <span class="today_green"><?= $post_players_count ?> (<?= ($post_players_diff >= 0) ? "+" . $post_players_diff : $post_players_diff ?>)</span></p>
        <p class="today_stat">VIP игроков: <span class="today_green" title="Дней: <?= $vip_days ?>"><?= $vip_count ?></span> Админов: <span class="today_green"><?= $admin_count ?></span></p>
        <div class="today_stat"><?= $memory_usage . " " . $cpu_usage ?> <img title="Пинги" class="today_ping" onclick="show_pings()" src="/img/ping.png">
        <ul id="today_pings">
            <li class="today_title">Пинги до регионов</li>
            <?= getPings() ?>
        </ul>
        </div>

        <p style="margin: 2px auto;font-weight: bold;">Поддержали: <span style="color:#00a81f;"><?= $donations_count ?></span><?= ($donations_names) ?></p>

    </div>

    <script>
        function show_pings() {
            document.getElementById("today_pings").classList.toggle("show");
        }
    </script>

    <?php

    $content = ob_get_contents();
    ob_end_clean();
    $f = fopen($cache_file, "w");
    fwrite($f, $content);
    fclose($f);
}

echo file_get_contents($cache_file);