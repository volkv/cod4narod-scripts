<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ru" lang="ru">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
	<meta name="description" content="Скриншоты игроков серверов CoD4Narod.RU"/>

	<link rel="stylesheet" href="http://brutaldesign.github.io/swipebox/src/css/swipebox.min.css">
	<link rel="stylesheet" href="css/style.css">

	<?php

	header("Cache-Control: no-store, no-cache, must-revalidate, max-age=0");
	header("Cache-Control: post-check=0, pre-check=0", false);
	header("Pragma: no-cache");
	error_reporting(E_ALL);
	ini_set('display_errors', 1);

	include('config.php');

	$messages_per_page = 200;
	$search = null;
	$all = false;
	$server_id = -1;
	$black = false;
	$shame = false;
	$axon = false;

	if (isset($_GET['black'])) {
		$black = true;
	}

	if (isset($_GET['shame'])) {
		$shame = true;
	}
	if (isset($_GET['axon'])) {
		$axon = true;
	}

	if (!empty($_GET['search'])) {
		$server_name = "ПОИСК";
		$search = $_GET['search'];
	}
	else if (!isset($_GET['server'])) {
		$all = true;
		$server_name = "ВСЕ";
	}
	else {
		$server_id = (int)$_GET['server'];

		if (!array_key_exists($server_id, $serverDB)) die("no");

		$server_mysql = $serverDB[$server_id]['mysql'];
		$server_name = $serverDB[$server_id]['name'];
	}

	if (empty($_GET['page']) || (int)$_GET['page'] == 0) $cur_page = 1;
	else $cur_page = (int)$_GET['page'];

	?>

	<title><?php echo $server_name; ?> - скриншоты</title>

</head>
<body>

<div class="head-logo">
	<div class="pagination">
		<?php

		if (is_null($search)) {
			for ($p = 1; $p < 6; $p++) {
				$active = ($cur_page == $p) ? ' class="active" ' : ' ';

				if ($all) echo '<a' . $active . 'href="?page=' . $p . '" rel="nofollow">' . $p . '</a>';
				else
					echo '<a' . $active . 'href="?server=' . $server_id . '&page=' . $p . '" rel="nofollow">' . $p . '</a>';
			}
		}

		$db = new PDO('mysql:host=localhost;dbname=cod4stats', 'login', 'password');

		$axon_query = $db->query("SELECT COUNT(*) FROM ss where axon = 1 and banned = 0 and date > DATE_SUB(DATE(NOW()), INTERVAL 1 DAY) LIMIT 200");
		$axon_count = $axon_query->fetchColumn();

		if ($axon) {
			$screens_count = $axon_count;
		}
		else if ($shame) {
			$count_query = $db->query("SELECT COUNT(*) FROM ss where banned = 1 LIMIT 200");
			$screens_count = $count_query->fetchColumn();
		}
		else if ($search) {
			$count_query = $db->prepare("SELECT COUNT(*) FROM ss WHERE name LIKE :search OR guid = :searchguid");
			$count_query->execute(array('search' => "%$search%", 'searchguid' => $search));
			$screens_count = $count_query->fetchColumn();
		}
		else if ($all) {
			$count_query = $db->query("SELECT COUNT(*) FROM ss LIMIT 200");
			$screens_count = $count_query->fetchColumn();
		}
		else {
			$count_query = $db->query("SELECT COUNT(*) FROM ss where server = $server_id");
			$screens_count = $count_query->fetchColumn();
		}

		if (empty($screens_count)) $screens_count = 0;

		$nb_pages = ceil($screens_count / $messages_per_page);

		$firstIdPerPage = ($cur_page - 1) * $messages_per_page;

		?>
	</div>

	<a href="/">
		<img src="/logo@2x.png" border="0" alt="CoD4Narod.RU"/>
	</a>
	<div class="ss-count">
		<a href="index.php?shame" class="shame">
			Стена позора
		</a>
		<a href="index.php?axon" class="shame">
			Подозрительные (<?= $axon_count ?>)
		</a>
		Скриншотов:
		<b><?php echo $screens_count . " (" . $firstIdPerPage . "-" . ($firstIdPerPage + $messages_per_page) . ")" ?></b>
	</div>
</div>
<div class="top">

	<?php if ($all || $search || $shame || $axon)

		echo '<a class="button active" href="index.php">ВСЕ</a>';
	else
		echo '<a class="button" href="index.php">ВСЕ</a>';

	foreach ($serverDB as $key => $value) {
		$active = ($key == $server_id) ? 'active' : '';
		echo '<a class="button ' . $active . '" href="index.php?server=' . $key . '">' . $serverDB[$key]['name'] . '</a>';
	} ?>

	<form class="searchform" action="index.php" method="GET">
		<input name="search" type="text" id="search" placeholder="Поиск по имени или GUID..."
		       title="Введите имя игрока или его GUID (2310...)">

	</form>
	<a class="button" href="/sourcebans/">БАНЛИСТ</a>
	<a class="button" href="/stats/index.php">СТАТИСТИКА</a>
	<a class="button" href="/stats/chat.php">ЧАТ</a>

</div>

<div class="image-grid">

	<?php
	if ($axon) {
		$data_query = $db->query("SELECT s.guid, s.name, s.ip, s.path, s.date,s.server, s.banned, Coalesce(v.cheated, 0) cheated, Coalesce(v.days, 0) days, Coalesce(v.admin, 0) admin FROM ss s left join vip v on v.guid=s.guid where s.axon = 1 and s.banned = 0 and s.date > DATE_SUB(DATE(NOW()), INTERVAL 1 DAY) ORDER BY s.date DESC LIMIT  $firstIdPerPage, $messages_per_page");
	}
	else if ($shame) {
		$data_query = $db->query("SELECT s.guid, s.name, s.ip, s.path, s.date,s.server, s.banned, Coalesce(v.cheated, 0) cheated, Coalesce(v.days, 0) days, Coalesce(v.admin, 0) admin FROM ss s left join vip v on v.guid=s.guid where s.banned = 1 ORDER BY s.date DESC LIMIT  $firstIdPerPage, $messages_per_page");
	}
	else if ($search) {
		$data_query = $db->prepare("SELECT s.guid, s.name, s.ip, s.path, s.date,s.server, s.banned, Coalesce(v.cheated, 0) cheated, Coalesce(v.days, 0) days, Coalesce(v.admin, 0) admin FROM ss s left join vip v on v.guid=s.guid WHERE s.name LIKE :search OR s.guid = :searchguid ORDER BY s.date DESC LIMIT 200");
		$data_query->execute(array('search' => "%$search%", 'searchguid' => $search));
	}
	else if ($all) {
		$data_query = $db->query("SELECT s.guid, s.name, s.ip, s.path, s.date,s.server, s.banned, Coalesce(v.cheated, 0) cheated, Coalesce(v.days, 0) days, Coalesce(v.admin, 0) admin FROM ss s left join vip v on v.guid=s.guid ORDER BY s.date DESC LIMIT  $firstIdPerPage, $messages_per_page");
	}
	else {
		$data_query = $db->query("SELECT s.guid, s.name, s.ip, s.path, s.date,s.server, s.banned, Coalesce(v.cheated, 0) cheated, Coalesce(v.days, 0) days, Coalesce(v.admin, 0) admin FROM ss s left join vip v on v.guid=s.guid where server = $server_id ORDER BY s.date DESC LIMIT  $firstIdPerPage, $messages_per_page");
	}
if ($data_query)
	while ($row = $data_query->fetch()) {
	$server_id = $row['server'];
	$undate = date("d.m.y H:i", strtotime($row['date']));
	$unname = $row['name'];
	$cheated = $row['cheated'];
	$days = $row['days'];
	$admin = $row['admin'];
	$ip = $row['ip'];
	$banned = $row['banned'];
	$unguid = $row['guid'];
	$unscreen = $serverDB[$server_id]['screenshots'] . urlencode($row['path']);
	$undemo = str_replace("/screenshots/files/", "", $unscreen);

	if ($black && filesize($_SERVER['DOCUMENT_ROOT'] . $serverDB[$server_id]['screenshots'] . $row['path']) > 7000) continue;

	if ($banned && !$shame) echo '<div class="gallery-item banned" title="ЗАБАНЕН">';
	else
		echo '<div class="gallery-item">';
	?>

	<a href="<?php echo $unscreen; ?>" class="swipebox" title="<?php echo $unname; ?>">

                <span class="gallery-icon lazy" data-src="<?php echo $unscreen; ?>">
				<?php if ($banned && !$shame) echo '<span class="banned-overlay"></span>' ?>
				</span>
	</a>

	<div class="caption" id="gallery-1-481">

		<?php

		echo '<a href="/sourcebans/index.php?p=admin&c=bans&plname=' . urlencode($unname) . '&plguid=' . $unguid . '&plip=' . $ip . '&pldemo=' . $undemo . '" target="_blank" title="Забанить игрока (нужны права Администратора Серверов)" rel="nofollow">';
		echo '<img src="/screenshots/img/ban.png" class="action-icon ban"></a>';

		echo '<a href="/screenshots/index.php?search=' . $unguid . '" target="_blank" title="Поиск скриншотов игрока по всем серверам" rel="nofollow">';
		echo '<img src="/screenshots/img/search.png" class="action-icon search"></a>';

		echo '<span class="name">' . $unname . '<span class="date"> | ' . $undate . '</span>';
		echo ($cheated > 0) ? '<span style="color:red"> [БЫВШИЙ ЗЭК]</span>' : '';

		echo '</span><p class="guid">' . $unguid . '</p></a>';

		?>

	</div>

</div>

<?php }

echo '</div>'; ?>

<script type="text/javascript" src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
<script type="text/javascript" src="http://brutaldesign.github.io/swipebox/src/js/jquery.swipebox.min.js"></script>
<script type="text/javascript" src="http://jquery.eisbehr.de/lazy/js/jquery.lazy.min.js?token=357a0587fbb914483d6e2832ae5e8e0b5f4e1d9f2dfa31e60f20b982c1f6fc52"></script>
<script type="text/javascript">

	$(function () {
		$('.swipebox').swipebox();
	});

	$(function () {
		$('.lazy').lazy();
	});

</script>

</body>
</html>