<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ru" lang="ru">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
	<meta name="description" content="Статистика игроков серверов CoD4Narod.RU"/>

	<link rel="stylesheet" href="css/style.css?19">
	<link rel="stylesheet" type="text/css" href="http://calebjacob.github.io/tooltipster/dist/css/tooltipster.bundle.min.css"/>

	<script type="text/javascript" src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
	<script type="text/javascript" src="http://calebjacob.github.io/tooltipster/dist/js/tooltipster.bundle.min.js"></script>

	<?php

	header("Cache-Control: no-store, no-cache, must-revalidate, max-age=0");
	header("Cache-Control: post-check=0, pre-check=0", false);
	header("Pragma: no-cache");

	include('functions.php');

	include('config.php');

	$search = null;
	$all = false;
	$server_id = -1;
	$server_name_color = "";
	$server_mysql = -1;

	if (!empty($_GET['search'])) {
		$server_name = "ПОИСК";
		$search = $_GET['search'];
	} else if (!isset($_GET['server'])) {
		$all = true;
		$server_name = "ВСЕ";
	} else {
		$server_id = (int)$_GET['server'];

		if (!array_key_exists($server_id, $serverDB))
			die("no");

		$server_mysql = $serverDB[$server_id]['mysql'];
		$server_name = $serverDB[$server_id]['name'];
		$server_name_color = $serverDB[$server_id]['name_color'];
	}

	if (empty($_GET['page']) || (int)$_GET['page'] == 0) $page = 1;
	else $page = (int)$_GET['page'];

	if (!isset($_GET['sort'])) $sortby = 's_kills';
	else if ($_GET['sort'] == 'deaths') $sortby = 's_deaths';
	else if ($_GET['sort'] == 'kd') $sortby = 'kd';
	else if ($_GET['sort'] == 'skill') $sortby = 's_skill';
	else if ($_GET['sort'] == 'knives') $sortby = 'knives';
	else if ($_GET['sort'] == 'heads') $sortby = 'heads';
	else if ($_GET['sort'] == 'grenades') $sortby = 'grenades';
	else $sortby = 's_kills';

	$players_per_page = 50;

	if ($search)
		echo '<title>Поиск - ' . h($search) . '</title>';
	else if ($all)
		echo '<title>Все сервера - статистика</title>';
	else
		echo '<title>' . $server_name . '  - статистика игроков</title>';
	?>
</head>

<body>
<?php

$stats_db = new PDO('mysql:host=localhost;dbname=cod4stats', 'login', 'password');

if ($search) {
	$count_query = $stats_db->prepare("SELECT COUNT(*) FROM stats where s_player like :search OR s_guid = :searchguid OR s_ip like :searchguid");
	$count_query->execute(array('search' => "%$search%", 'searchguid' => "$search%"));
	$players_count = $count_query->fetchColumn();
} else if ($all) {
	$count_query = $stats_db->query("select count(*) from (SELECT 1 FROM `stats` where s_lasttime > (curdate() - interval 1 month) group by s_guid having sum(s_kills) > 500) a");
	$players_count = $count_query->fetchColumn();
} else {
	$count_query = $stats_db->query("SELECT COUNT(*) FROM stats  WHERE s_server = $server_mysql and s_kills >= 500 and s_lasttime >  (curdate() - interval 1 month)");
	$players_count = $count_query->fetchColumn();
}

if (empty($players_count)) $players_count = 0;

?>
<div class="head-logo">
	<a href="/">
		<img src="/logo@2x.png" border="0" alt="CoD4Narod.RU"/>
	</a>
</div>

<div class="top">

	<?php if ($all || $search)
		echo '<a class="button active" href="index.php">ВСЕ</a>';
	else
		echo '<a class="button" href="index.php">ВСЕ</a>';

	foreach ($serverDB as $key => $value) {
		if ( !isset($serverDB[$key]['off'])) {
		$active = ($key == $server_id) ? 'active' : '';
		echo '<a class="button ' . $active . '" href="index.php?server=' . $key . '">' . $serverDB[$key]['name'] . '</a>';
		}
	} ?>

	<form class="searchform" action="index.php" method="GET">
		<input name="search" type="text" id="search" placeholder="Поиск по имени или GUID..."
		       title="Введите имя игрока или его GUID (2310...)">
	</form>

	<a class="button" href="chat.php">ЧАТ</a>
	<a class="button" href="/screenshots/index.php">СКРИНШОТЫ</a>
	<a class="button" href="/sourcebans/">БАНЛИСТ</a>
</div>

<?php

if ($all) {
	$avg_count_query = $stats_db->query("SELECT value FROM `metrics` WHERE metric = 'avg_players' limit 1");
	$avg_count = $avg_count_query->fetchColumn();
	echo '<div class="caption">Лидеры Недели <span style="color:lime">Всех Серверов</span><span class="kills"> (' . number_format($avg_count, 0, ',', ' ') . '+ убийств)</span></div><div class="top_group">';
} else if (is_null($search)) {
	$avg_count_query = $stats_db->query("SELECT value FROM `metrics` WHERE metric = $server_mysql limit 1");
	$avg_count = $avg_count_query->fetchColumn();
	echo '<div class="caption">Лидеры Недели Сервера ' . $server_name_color . '<span class="kills"> (' . number_format($avg_count, 0, ',', ' ') . '+ убийств)</span></div><div class="top_group">';
}

function getWeekly($metric) {
	global $weekly_players;
	usort($weekly_players, 'sort_by_' . $metric);

	if ($metric == 'kills')
		echo '<div class="table_wrapper"><table class="c4n_table weekly"><thead><thead><tr><th>Игрок</th><th style="color:#fda100">Убийства</th><th>Уб/См</th></tr></thead>';
	else if ($metric == 'skill')
		echo '<div class="table_wrapper"><table class="c4n_table weekly"><thead><thead><tr><th>Игрок</th><th style="color:#fda100">' . getNameForMetric($metric) . '</th><th>Уб/См</th></tr></thead>';
	else
		echo '<div class="table_wrapper"><table class="c4n_table weekly"><thead><thead><tr><th>Игрок</th><th style="color:#fda100">' . getNameForMetric($metric) . '</th><th>Убийства</th></tr></thead>';

	for ($i = 0; $i < 6; $i++) {
		if (!array_key_exists($i, $weekly_players))
			continue;

		echo '<tr><td><a href="/stats/index.php?search=' . $weekly_players[$i]['guid'] . '" rel="nofollow">' . $weekly_players[$i]['player'] . '</a>';
        if ($weekly_players[$i]['days'] > 0)
            echo '<a href="/donate/?guid=' . $weekly_players[$i]['guid'] . '" target="_blank" rel="nofollow"><img title="VIP игрок ['.$weekly_players[$i]['days'] .']" class="vip_small" src="img/vip.png"></a>';
        if ($weekly_players[$i]['admin'] > 0)
            echo '<a href="/staff/" target="_blank"><img title="Администратор Серверов" class="vip_small" src="img/admin.png"></a>';
         echo '</td>';



		if ($metric == 'kills') {
			echo '<td>' . number_format($weekly_players[$i]['kills'], 0, ',', ' ') . '</td>';
		} else {
			if ($metric == 'kd' || $metric == 'playedkills')
				echo '<td>' . number_format($weekly_players[$i][$metric], 2) . '</td>';
			else
				echo '<td>' . number_format($weekly_players[$i][$metric], 0, ',', ' ') . '</td>';
		}
		if ($metric == 'kills' || $metric == 'skill')
			echo '<td>' . number_format($weekly_players[$i]['kd'], 2) . '</td></tr>';
		else
			echo '<td>' . number_format($weekly_players[$i]['kills'], 0, ',', ' ') . '</td></tr>';
	}






	echo '</thead></table></div>';
}

if (is_null($search)) {
	if ($all)
		$weekly_query = $stats_db->query("SELECT s_guid guid,Coalesce(v.days, 0) days,Coalesce(v.admin, 0) admin, max(s_player) player,sum(s_kills - s_kills_w) kills, 60 / (sum(s_playedtime - s_playedtime_w) / sum(s_playedkills - s_playedkills_w)) playedkills, sum(s_kills - s_kills_w) / sum(s_deaths - s_deaths_w) kd, sum(s_heads - s_heads_w) heads, max(s_skill) skill, sum(s_melle - s_melle_w) knives, sum(s_grenade - s_grenade_w) grenades  FROM `stats` left join vip v on v.guid = s_guid where (s_kills - s_kills_w) > (SELECT value FROM `metrics` WHERE metric = 'avg_players') GROUP by s_guid");
	else
		$weekly_query = $stats_db->query("SELECT s_player player,Coalesce(v.days, 0) days, Coalesce(v.admin, 0) admin, s_guid guid, (s_kills - s_kills_w) kills, 60 / ((s_playedtime - s_playedtime_w) / (s_playedkills - s_playedkills_w)) playedkills,(s_kills - s_kills_w) / (s_deaths - s_deaths_w) kd, (s_deaths - s_deaths_w) deaths, (s_heads - s_heads_w) heads, s_skill skill, (s_melle - s_melle_w) knives, (s_grenade - s_grenade_w) grenades, s_server 'server' FROM `stats` left join vip v on v.guid = s_guid where s_server = $server_mysql AND ((s_kills - s_kills_w) > (SELECT value FROM `metrics` WHERE metric = '$server_mysql'))");

	$weekly_players = $weekly_query->fetchAll();

	getWeekly('skill');
	getWeekly('kd');
	getWeekly('playedkills');
	getWeekly('heads');
	getWeekly('knives');
	getWeekly('kills');
}
?>

</div>
<table class="c4n_table">
	<?php

	if ($search)
		echo '<caption>Поиск - ' . h($search) . '</caption>';
	else if ($all)
		echo '<caption>Общая Статистика по <span style="color:lime">Всем Серверам</span></caption>';
	else
		echo '<caption>Статистика Игроков Сервера ' . $server_name_color . '</caption>';
	?>
	<thead>
	<tr>
		<th>#</th>
		<th>Игрок</th>
		<?php
		$server_ad = (!$search && !$all) ? "&server=" . $server_id : "";
		if ($search)
			echo '<th>Сервер</th><th>IP</th>';
		?>

		<th class="tt info" title="Средний пинг игрока">Пинг</th>
		<th class="tt info" title="Среднее кол-во кадров в секунду игрока">FPS</th>

		<th class="sortable<?= ($sortby == "s_kills") ? ' sort' : '' ?>">
			<a href="?sort=kills<?= $server_ad ?>" rel="nofollow">Убийства</a>
		</th>
		<th class="sortable<?= ($sortby == "s_deaths") ? ' sort' : '' ?>">
			<a href="?sort=deaths<?= $server_ad ?>" rel="nofollow">Смерти</a>
		</th>
		<th class="sortable<?= ($sortby == "kd") ? ' sort' : '' ?>"><a href="?sort=kd<?= $server_ad ?>" rel="nofollow">Уб/См</a>
		</th>
		<th class="tt info sortable<?= ($sortby == "s_skill") ? ' sort' : '' ?>" title="Показатель Навыка рассчитывается умным алгоритмом">
			<a href="?sort=skill<?= $server_ad ?>" rel="nofollow">Навык</a></th>
		<th class="sortable<?= ($sortby == "heads") ? ' sort' : '' ?>">
			<a href="?sort=heads<?= $server_ad ?>" rel="nofollow">В голову</a>
		</th>
		<th class="tt info sortable<?= ($sortby == "grenades") ? ' sort' : '' ?>" title="Процент Смертей/Убийств Гранатой (примерный показатель меткости)">
			<a href="?sort=grenades<?= $server_ad ?>" rel="nofollow">Гранатой</a></th>
		<th class="sortable<?= ($sortby == "knives") ? ' sort' : '' ?>">
			<a href="?sort=knives<?= $server_ad ?>" rel="nofollow">Ножом</a>
		</th>

		<th>Суицид</th>
		<th>Город</th>
		<th>В игре</th>

	</tr>
	</thead>

	<?php

	$nb_pages = ceil($players_count / $players_per_page);

	$firstIdPerPage = ($page - 1) * $players_per_page;

	if ($search) {
		$queryZ = $stats_db->prepare("SELECT *, Coalesce(v.days, 0) days,Coalesce(v.admin, 0) admin FROM stats left join vip v on v.guid = s_guid WHERE s_player like :search OR s_guid = :searchguid OR s_ip like :searchguid ORDER BY s_lasttime DESC LIMIT $firstIdPerPage, $players_per_page");
		$queryZ->execute(array('search' => "%$search%", 'searchguid' => "$search%"));
	} else if ($all) {
		$queryZ = $stats_db->query("SELECT max(s_player) s_player,Coalesce(v.days, 0) days, Coalesce(v.admin, 0) admin, sum(s_kills) s_kills, sum(s_grenade) s_grenade, (sum(s_melle) / sum(s_kills) ) knives,(sum(s_grenade) / sum(s_deaths) ) grenades,(sum(s_heads) / sum(s_kills) ) heads, (sum(s_kills) / sum(s_deaths)) kd, max(s_skill) s_skill, sum(s_playedkills) s_playedkills,sum(s_playeddeaths) s_playeddeaths,sum(s_playedtime) s_playedtime, sum(s_deaths)s_deaths,sum(s_heads)s_heads,ROUND(AVG(s_kill_streak),0) s_kill_streak,ROUND(AVG(s_death_streak),0) s_death_streak,ROUND(AVG(s_guid),0) s_guid,SUM(s_suicids)s_suicids,sum(s_melle) s_melle,ROUND(avg(s_ping),0) s_ping,ROUND(avg(s_fps),0) s_fps,max(s_lasttime) s_lasttime,min(s_time) s_time, max(s_geo) s_geo,max(s_city)s_city, max(s_ip)s_ip,max(s_server)s_server FROM `stats` left join vip v on v.guid = s_guid where s_lasttime >  (curdate() - interval 1 week) or s_server in (0,2)  GROUP by s_guid having sum(s_kills) > 500 order by $sortby desc LIMIT  $firstIdPerPage, $players_per_page");
	} else {
		$queryZ = $stats_db->query("SELECT *, Coalesce(v.days, 0) days,Coalesce(v.admin, 0) admin, (s_kills / s_deaths) kd, (s_grenade / s_deaths ) grenades , (s_heads / s_kills ) heads, (s_melle / s_kills ) knives FROM stats left join vip v on v.guid = s_guid WHERE s_server = $server_mysql and s_kills>=500 AND s_lasttime >  (curdate() - interval 1 month) ORDER BY $sortby DESC LIMIT  $firstIdPerPage, $players_per_page");
	}

	$i = $firstIdPerPage;

	$guids = [];

	while ($row = $queryZ->fetch()) {
		$i++;
		$s_server = $row['s_server'];
		$s_ip = $row['s_ip'];
		$s_days = $row['days'];
		$s_admin = $row['admin'];
		$s_player = $row['s_player'];
		$s_ping = ($row['s_ping'] == 0) ? '' : $row['s_ping'];
		$s_fps = ($row['s_fps'] == 0) ? '' : $row['s_fps'];
		$s_kills = $row['s_kills'];
		$s_kill_streak = $row['s_kill_streak'];
		$s_deaths = $row['s_deaths'];
		$s_death_streak = $row['s_death_streak'];
		$s_heads = $row['s_heads'];
		$s_grenade = $row['s_grenade'];
		$s_suicids = $row['s_suicids'];
		$s_melle = $row['s_melle'];
		$s_skill = $row['s_skill'];
		$s_lasttime = $row['s_lasttime'];
		$s_city = $row['s_city'];
		$s_geo = $row['s_geo'];
		$s_geo = ($s_geo == '' ? 'Unknown' : $s_geo);
		$s_guid = $row['s_guid'];
		$s_playedkills = (int)$row['s_playedkills'];
		$s_playeddeaths = (int)$row['s_playeddeaths'];
		$s_playedtime = (int)$row['s_playedtime'];

		$kd = ($s_deaths > 0) ? ($s_kills / $s_deaths) : 0;
		$head_kd = ($s_kills > 0) ? ($s_heads / $s_kills) : 0;
		$grenade_kd = ($s_deaths > 0) ? ($s_grenade / $s_deaths) : 0;
		$melle_kd = ($s_kills > 0) ? ($s_melle / $s_kills) : 0;
		$suicids_kd = ($s_kills > 0) ? ($s_suicids / $s_kills) : 0;

		$rank_text = get_rank_text($s_kills);
		$prestige_text = get_prestige($kd);

		echo '<tbody><tr><td rowspan="2">' . $i . '</td>';
		echo '<td rowspan="2" class="player"><img class="tt flag" title="' . $s_geo . '" src="flags/' . $s_geo . '.png"><span class="tt rank-wrapper" title="' . explode(";", $rank_text)[1] . '"><img class="rank" src="ranks/' . get_prestige_icon($s_kills) . '.png"><sub class="rank_number">' . explode(";", $rank_text)[0] . '</sub></span><a class="tt" data-tooltip-content="#tooltip_' . $s_guid . '" href="index.php?search=' . $s_guid . '" rel="nofollow">' . $s_player . '</a>';
		if ($s_days > 0)
		    echo '<a href="/donate/?guid=' . $s_guid . '" target="_blank" rel="nofollow"><img title="VIP игрок ['.$s_days .']"' .'class="vip" src="img/vip.png">';
        if ($s_admin > 0)
            echo '<a href="/staff/" target="_blank"><img title="Администратор Серверов" class="vip" src="img/admin.png">';

        echo '</a></span></td>';


		if (!array_key_exists($s_guid,$guids))
		echo '<div class="th"><span id="tooltip_' . $s_guid . '">GUID: ' . $s_guid . '<a title="Поддержать Проект и получить VIP статус для игрока" href=https://cod4narod.ru/donate/?guid=' . $s_guid . ' target="_blank" rel="nofollow"><img class="vip" src=img/vip.png></a></span></div>';

        $guids[$s_guid] = true;

        if ($search) {
			echo '<td rowspan="2">' . $serverDB[$s_server]['name'] . '</td>';
			echo '<td rowspan="2" class="tt" title="Поиск по IP"><a href="index.php?search=' . $s_ip . '" rel="nofollow">' . $s_ip . '</a></td></td>';
		}

		echo '<td rowspan="2">' . format_color($s_ping, 1, true, false) . '</td>';
		echo '<td rowspan="2">' . format_color($s_fps, 1, false, false) . '</td>';
		echo '<td>' . number_format($s_kills, 0, ',', ' ');
		echo '<td>' . number_format($s_deaths, 0, ',', ' ') . '</td>';
		echo '<td rowspan="2" class="kd"><img class="tt prestige" title="' . explode(";", $prestige_text)[0] . '" src="prestiges/' . explode(";", $prestige_text)[1] . '.png">' . format_color(number_format($kd, 2), 40, false, false) . '</td>';
		echo '<td rowspan="2">' . format_color(round($s_skill, 0), .05, false, false) . '</td>';
		echo '<td rowspan="2" class="tt" title="' . $s_heads . '">' . format_color($head_kd, 400) . '</td>';
		echo '<td rowspan="2" class="tt" title="' . $s_grenade . '">' . format_color($grenade_kd, 700) . '</td>';
		echo '<td rowspan="2" class="tt" title="' . $s_melle . '">' . format_color($melle_kd, 900) . '</td>';
		echo '<td rowspan="2" class="tt" title="' . $s_suicids . '">' . format_color($suicids_kd, 8000, true) . '</td>';

		echo '<td rowspan="2">' . $s_city . '</td>';

		$datetime1 = date_create($s_lasttime);
		if ($datetime1) {
			$datetime2 = date_create();
			$sinceThen = date_diff($datetime1, $datetime2);

			echo '<td class="tt" title="Последний онлайн: ' . date("d.m.y H:i", strtotime($s_lasttime)) . '">' . diff_text($sinceThen) . '</td></tr>';
		}

		echo '<tr><td class="kd"><span class="tt" title="Убийств подряд">' . format_color($s_kill_streak, 4, false, false) . '</span>';
		echo ($s_playedtime != 0 && $s_playedkills != 0) ? ' / <span class="tt" title="Убийств в минуту">' . format_color(round(60 / ($s_playedtime / $s_playedkills)), 10, false, false) . '</span></td>' : '</td>';
		echo '<td class="kd"><span class="tt" title="Смертей подряд">' . format_color($s_death_streak, 8, true, false) . '</span>';
		echo ($s_playedtime != 0 && $s_playeddeaths != 0) ? ' / <span class="tt" title="Смертей в минуту">' . format_color(round(60 / ($s_playedtime / $s_playeddeaths)), 12, true, false) . '</span></td>' : '</td>';
		echo '<td class="tt" title="Общее время в игре">' . seconds_to_time($s_playedtime) . '</td></tr></tbody>';
	}
	?>

</table>

<script>
	$(document).ready(function () {
		$('.tt').tooltipster({
			theme: 'tooltipster-cod4narod',
            contentCloning: true,
			interactive: true
		});
	});
</script>

<div class="footer">
	<div class="pagination">
		<?php

		if (empty($_GET['search'])) {
			$sort = "";
			if (isset($_GET['sort'])) {
				$sort = "&sort=" . $_GET['sort']; 
			}
			for ($p = 1;
			     $p < ceil($players_count / $players_per_page);
			     $p++) {
				$active = ($page == $p) ? ' class="active" ' : ' ';

				if ($search || $all)
					echo '<a' . $active . 'href="?page=' . $p .$sort . '" rel="nofollow">' . $p . '</a>';
				else
					echo '<a' . $active . 'href="?server=' . $server_id . '&page=' . $p . $sort.'" rel="nofollow">' . $p . '</a>';
			}
		}

		$stats_db = null;

		echo '</div>';

		if ($all)
            echo '<div class="total-count">Игроков: <b>' . $players_count . '</b> (500+ убийств, активность в последнюю неделю)</div>';
		else if (empty($_GET['search']))
			echo '<div class="total-count">Игроков: <b>' . $players_count . '</b> (500+ убийств, активность в последний месяц)</div>';
		else
			echo '<div class="total-count">Найдено игроков: <b>' . $players_count . '</b></div>';

		?>
	</div>

</body>
</html>