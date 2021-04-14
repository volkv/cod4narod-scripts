<?php 

$stats_db_weekly = new PDO('mysql:host=localhost;dbname=cod4stats', 'login', 'password');

$avg_count_query = $stats_db_weekly->query("SELECT value FROM `metrics` WHERE metric = 'avg_players' limit 1");

$avg_count = $avg_count_query->fetchColumn();

?>

<script>

    function createCookie(name, value, days) {
        var expires = "";
        if (days) {
            var date = new Date();
            date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
            expires = "; expires=" + date.toUTCString();
        }
        document.cookie = name + "=" + value + expires + "; path=/";
    }


    function HideBlockWeekly() {

        $('#block_weekly').toggle();


        if ($("#hide_block_weekly_btn").hasClass('open')) {
            createCookie('hide_block_weekly', 1, 1);

        } else {
            createCookie('hide_block_weekly', "", -1);
        }

        $("#hide_block_weekly_btn").toggleClass('open');

        return 0;

    }

</script>
<h2 class="ipsType_sectionTitle ipsType_reset">

    <span><i style="margin-right: 8px;" class="fa fa-calendar" aria-hidden="true"></i>Лидеры Недели<span
                style=" font-size: 14px;   color: #4e4e4e;   margin-left: 10px; ">(статистика сбрасывается каждое воскресенье в 23:59:59) <?=number_format($avg_count, 0, ',', ' ') ."+ убийств"?></span>

        <a href="#" id="hide_block_weekly_btn" <?php if (!isset($_COOKIE['hide_block_weekly'])) {
	        echo 'class="open"';
        } ?> onclick="event.preventDefault();HideBlockWeekly();"></a>

    </span>
</h2>

<?php

error_reporting(E_ALL);
ini_set('display_errors', 1);

function getNameForMetric($metric) {

	switch ($metric) {
		case 'kills':
			return "Убийства";
			break;
		case 'playedkills':
			return "Уб в Мин";
			break;
		case 'kd':
			return "Уб/См";
			break;
		case 'heads':
			return "В голову";
			break;
		case 'knives':
			return "Ножом";
			break;
		case 'skill':
			return "Навык";
			break;
		case 'suicids':
			return "Суицид";
			break;
		default:
			return "???";
	}

}

function sort_by_kills ($a, $b)
{
	return $b['kills'] > $a['kills'] ? 1 : -1;
}

function sort_by_playedkills($a, $b)
{
	return $b['playedkills'] > $a['playedkills'] ? 1 : -1;
}

function sort_by_knives ($a, $b)
{
	return $b['knives'] > $a['knives'] ? 1 : -1;
}

function sort_by_heads ($a, $b)
{
	return $b['heads'] > $a['heads'] ? 1 : -1;
}

function sort_by_kd ($a, $b)
{
	return $b['kd'] > $a['kd'] ? 1 : -1;
}

function sort_by_suicids ($a, $b)
{
	return $b['suicids'] > $a['suicids'] ? 1 : -1;
}

function sort_by_skill ($a, $b)
{
	return $b['skill'] > $a['skill'] ? 1 : -1;
}




if (isset($_COOKIE['hide_block_weekly'])) {

	echo '<div id="block_weekly" class="top_group" style="display: none;">';

} else {

	echo '<div id="block_weekly" class="top_group">';

}


$weekly_query = $stats_db_weekly->query("SELECT s_guid guid, Coalesce(v.days, 0) days,Coalesce(v.admin, 0) admin, max(s_player) player,sum(s_kills - s_kills_w) kills, 60 / (sum(s_playedtime - s_playedtime_w) / sum(s_playedkills - s_playedkills_w)) playedkills, sum(s_kills - s_kills_w) / sum(s_deaths - s_deaths_w) kd, sum(s_heads - s_heads_w) heads, sum(s_melle - s_melle_w) knives, max(s_skill) skill  FROM `stats` left join vip v on v.guid = s_guid where (s_kills - s_kills_w) > (SELECT value FROM `metrics` WHERE metric = 'avg_players') GROUP by s_guid");

$weekly_players = $weekly_query->fetchAll();

getWeekly('skill', $weekly_players);
getWeekly('kd', $weekly_players);
getWeekly('playedkills', $weekly_players);
getWeekly('heads', $weekly_players);
getWeekly('knives', $weekly_players);
getWeekly('kills', $weekly_players);


function getWeekly($metric,$weekly_players ) {

	usort($weekly_players, 'sort_by_' . $metric);

	if ($metric == 'kills')
		echo '<div class="table_wrapper"><table class="top_table" align="center"><thead><thead><tr><th>Игрок</th><th style="color:#fda100">Убийства</th><th>Уб/См</th></tr></thead>';
	else if ($metric == 'skill')
		echo '<div class="table_wrapper"><table class="top_table" align="center"><thead><thead><tr><th>Игрок</th><th style="color:#fda100">' . getNameForMetric($metric) . '</th><th>Уб/См</th></tr></thead>';
			else
		echo '<div class="table_wrapper"><table class="top_table" align="center"><thead><thead><tr><th>Игрок</th><th style="color:#fda100">' . getNameForMetric($metric) . '</th><th>Убийства</th></tr></thead>';

	for ($i = 0; $i < 6; $i++) {

		if (!array_key_exists($i, $weekly_players))
			continue; 

		echo '<tr><td><a href="/stats/index.php?search=' . $weekly_players[$i]['guid'] . '" target="_blank" rel="nofollow">' . $weekly_players[$i]['player'] . '</a>';
		if ($weekly_players[$i]['days'] > 0)
		    echo '<a href="/donate/?guid=' . $weekly_players[$i]['guid'] . '" target="_blank" rel="nofollow"><img title="VIP игрок ['.$weekly_players[$i]['days'] .']" style="width: 12px; vertical-align: sub; margin-left: 3px;" src="/stats/img/vip.png"></a>';
		if ($weekly_players[$i]['admin'] > 0)	 
			 echo '<a href="/staff/" target="_blank"><img title="Администратор Серверов" style="width: 12px; vertical-align: sub; margin-left: 3px;" src="/stats/img/admin.png"></a>';
        echo '</td>'; 

		if ($metric == 'kills') {
			echo '<td>' . number_format($weekly_players[$i]['kills'], 0, ',', ' ') . '</td>';
		} else {
			if ($metric == 'kd' || $metric == 'playedkills')
				echo '<td>' . number_format($weekly_players[$i][$metric], 2) . '</td>';
			else
				echo '<td>' . number_format($weekly_players[$i][$metric], 0, ',', ' ') . '</td>';
		}
		if ($metric == 'kills' || $metric == 'skill' )
			echo '<td>' . number_format($weekly_players[$i]['kd'], 2) . '</td></tr>';
		else
			echo '<td>' . number_format($weekly_players[$i]['kills'], 0, ',', ' ') . '</td></tr>';
	}
	echo '</thead></table></div>';
}?>