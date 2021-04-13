<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ru" lang="ru">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
	<meta name="description" content="Лог чата серверов CoD4Narod.RU"/>

	<link rel="stylesheet" href="css/style.css?17">
	<link rel="stylesheet" type="text/css" href="http://calebjacob.github.io/tooltipster/dist/css/tooltipster.bundle.min.css"/>

	<script type="text/javascript" src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
	<script type="text/javascript" src="http://calebjacob.github.io/tooltipster/dist/js/tooltipster.bundle.min.js"></script>

	<?php

	header("Cache-Control: no-store, no-cache, must-revalidate, max-age=0");
	header("Cache-Control: post-check=0, pre-check=0", false);
	header("Pragma: no-cache");

	error_reporting(E_ALL);
	ini_set('display_errors', 1);

	include('functions.php');

	include('config.php');

	$messages_per_page = 200;
	$search = null;
	$all = false;
	$server_id = -1;
	$server_name_color = "";

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

		$server_name = $serverDB[$server_id]['name'];
		$server_name_color = $serverDB[$server_id]['name_color'];
	}

	if (empty($_GET['page']) || (int)$_GET['page'] == 0) $page = 1;
	else $page = (int)$_GET['page'];

	$table = 'chat';

	if ($search)
		echo '<title>Поиск - ' . h($search) . '</title>';
	else if ($all)
		echo '<title>Чат всех серверов</title>';

	else
		echo '<title>' . $server_name . ' - Чат</title>';
	?>
</head>

<body>

<table class="c4n_table chat">
	<?php

	if ($search)
		echo '<caption>Поиск - ' . h($search) . '</caption>';
	else if ($all)
		echo '<caption>Чат всех серверов</caption>';
	else
		echo '<caption>Чат сервера ' . $server_name_color . '</caption>';
	?>
	<thead>
	<tr>

		<?php if ($search || $all) {
			echo '<th>Сервер</th>';
		} ?>
		<th>Время</th>
		<th>Игрок</th>
		<th>Сообщение</th>
	</tr>
	</thead>
	<?php

	$db = new PDO('mysql:host=localhost;dbname=cod4stats', 'login', 'password');

	if ($search) {
		$count = $db->prepare("SELECT COUNT(*) FROM chat WHERE player like :search OR guid = :searchguid");
		$count->execute(array('search' => "%$search%", 'searchguid' => $search));
		$messages_count = $count->fetchColumn();
	} else if ($all) {
		$count = $db->query("SELECT COUNT(*) FROM chat");
		$messages_count = $count->fetchColumn();
	} else {
		$count = $db->query("SELECT COUNT(*) FROM chat where server = $server_id ORDER BY date DESC");
		$messages_count = $count->fetchColumn();
	}
	if (empty($messages_count)) $messages_count = 0;

	?>
	<div class="head-logo">
		<a href="/">
			<img src="/logo@2x.png" border="0" alt="CoD4Narod.RU"/>
		</a>
	</div>

	<div class="top">

		<?php if ($all || $search)
			echo '<a class="button active" href="chat.php">ВСЕ</a>';
		else
			echo '<a class="button" href="chat.php">ВСЕ</a>';

		foreach ($serverDB as $key => $value) {
				if ( !isset($serverDB[$key]['off'])) {
			$active = ($key == $server_id) ? 'active' : '';
			echo '<a class="button ' . $active . '" href="chat.php?server=' . $key . '">' . $serverDB[$key]['name'] . '</a>';
				}
		} ?>

		<form class="searchform" action="chat.php" method="GET">
			<input name="search" type="text" id="search" placeholder="Поиск по имени или GUID..."

			       title="Введите имя игрока или его GUID (2310...)">
			<input type="hidden" name="server" value="<?php echo $server_id ?>"/>
		</form>

		<a class="button" href="index.php">СТАТИСТИКА</a>
		<a class="button" href="/screenshots/index.php">СКРИНШОТЫ</a>
		<a class="button" href="/sourcebans/">БАНЛИСТ</a>
	</div>
	<?php

	$nb_pages = ceil($messages_count / $messages_per_page);

	$firstIdPerPage = ($page - 1) * $messages_per_page;

	if ($search) {
		$queryZ = $db->prepare("SELECT c.date,server,guid,player,message,Coalesce(v.days, 0) days, Coalesce(v.admin, 0) admin FROM chat c left join vip v using(guid)WHERE player like :search OR guid = :searchguid ORDER BY date DESC");
		$queryZ->execute(array('search' => "%$search%", 'searchguid' => $search));
	} else if ($all) {
		$queryZ = $db->query("SELECT c.date,server,guid,player,message,Coalesce(v.days, 0) days, Coalesce(v.admin, 0) admin FROM chat c left join vip v using(guid) ORDER BY date DESC LIMIT  $firstIdPerPage, $messages_per_page");
	} else {
		$queryZ = $db->query("SELECT c.date,server,guid,player,message,Coalesce(v.days, 0) days, Coalesce(v.admin, 0) admin FROM chat c left join vip v using(guid) where server = $server_id ORDER BY date DESC LIMIT  $firstIdPerPage, $messages_per_page");
	}

	while ($row = $queryZ->fetch()) {
		$server_id = $row['server'];
		$date = date("d.m.y H:i", strtotime($row['date']));
		$player = $row['player'];
        $days = $row['days'];
        $admin = $row['admin'];
		$guid = $row['guid'];
		$message = $row['message'];

		echo '<tr class="chat">';

		if ($search || $all) {
			echo '<td><a href="?server='.$server_id.'">' . $serverDB[$server_id]['name'] . '</a></td>';
		}

		echo '<td>' . $date . '</td>';
		echo '<td><a href="chat.php?search=' . $guid . '" rel="nofollow"><span class="tt player" title="GUID: ' . $guid . '">' . $player . '</span></a>';

		if ($days > 0)
            echo '<a href="/donate/?guid=' . $guid . '" target="_blank" rel="nofollow"><img title="VIP игрок ['.$days .']" class="vip_small" src="img/vip.png">';
        if ($admin > 0)
            echo '<a href="/staff/" target="_blank"><img title="Администратор Серверов" class="vip_small" src="img/admin.png">';
        echo '</td>';

		echo '<td class="message">' . uncolorize(colorize($message)) . '</td></tr>';
	}

	?>

	</tbody></table>

<script>
	$(document).ready(function () {
		$('.tt').tooltipster({
			theme: 'tooltipster-cod4narod',
			interactive: true
		});
	});
</script>

<div class="footer">
	<div class="pagination">
		<?php
		if (empty($_GET['search'])) {
			for ($p = 1; $p < ceil($messages_count / $messages_per_page); $p++) {
				$active = ($page == $p) ? ' class="active" ' : ' ';

				if ($search || $all)
					echo '<a' . $active . 'href="?page=' . $p . '">' . $p . '</a>';
				else
					echo '<a' . $active . 'href="?server=' . $server_id . '&page=' . $p . '">' . $p . '</a>';
			}
		}

		$stats_db = null;
		?>
	</div>

	<?php
	if (empty($_GET['search']))
		echo '<div class="total-count">Сообщений: <b>' . $messages_count . '</b></div>';
	else
		echo '<div class="total-count">Найдено сообщений: <b>' . $messages_count . '</b></div>';
	?>
</div>

</body>
</html>