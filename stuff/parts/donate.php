<?php
header('Content-Type: text/html; charset=utf-8');
$servername = "localhost";
$username = "login";
$password = "password";
$dbname = "cod4stats";

$conn = new mysqli($servername, $username, $password, $dbname);
$conn->set_charset("utf8");
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
} 


$resultSum = $conn->query("SELECT sum(amount) DIV 1 as sum FROM donations where datetime > '2019-01-01'");

if ($resultSum->num_rows > 0) {
	$row = $resultSum->fetch_assoc();
	$summ = $row["sum"];
}

$date1 = '2019-01-01';
$date2 = date("Y-m-d");

$ts1 = strtotime($date1);
$ts2 = strtotime($date2);

$year1 = date('Y', $ts1);
$year2 = date('Y', $ts2);

$month1 = date('m', $ts1);
$month2 = date('m', $ts2);

$months = (($year2 - $year1) * 12) + ($month2 - $month1) + 1;
$sumspent = $months*2000;
if ($sumspent == 0)
$percen = 100;
else
$percen = intval(($summ / $sumspent)*100);

if ($percen >= 100){
	$percen = 100;
$color = '18520a';	
} else {
	$color = 'b12121';	
}


$summ = number_format($summ, 0, ',', ' ' );
$sumspent = number_format($sumspent, 0, ',', ' ' );

function getdays($amount) {
		
		  $days = 0;

    if ($amount < 10)
        $days = round($amount / 20);

    else if ($amount < 20)
        $days = round($amount / 15);

    else if ($amount < 40)
        $days = round($amount / 10);

    else if ($amount < 50)
        $days = round($amount / 8);

    else if ($amount < 100)
        $days = round($amount / 5);

    else if ($amount < 300)
        $days = round($amount / 4.5);

    else if ($amount < 500)
        $days = round($amount / 4.3);

    else if ($amount < 1000)
        $days = round($amount / 4.0);

    else if ($amount < 2000)
        $days = round($amount / 3.5);

    else
        $days = round($amount / 3);

	if ($days != 0)
			$days++;
		
		$form = "";
		
	 $count = abs($days) % 100;
    $lcount = $count % 10;

    if ($count >= 11 && $count <= 19) 		$form ="дней";
    else if ($lcount >= 2 && $lcount <= 4) $form ="дня";
    else if ($lcount == 1) $form = "день";
    else  $form ="дней";
		
		return ' [<span style="color:#1ab814;">+'.$days . ' VIP ' . $form . '</span>]';
	}
	


?>

<div class="ipsWidget_inner ipsPad ipsType_richText">
<p style="text-align: center;">
	<span style="font-size:22px;">Оплата Хостинга</span><span style="font-size:14px;"> (собрано / потрачено)</span>
</p>

<div class="wa-progress" style="width: 100%;margin: 0 auto;margin-top: 5px;height: 30px;">
	<div aria-valuemax="100" aria-valuemin="0" aria-valuenow="45" class="wa-progress-bar wa-progress-bar-striped" role="progressbar" style="width: <?php echo $percen;?>%;background-color:#57a443;">
		 
	</div>

	<div style="position: absolute; width: 100%; color: #<?php echo $color ;?>;">
		<strong style="font-size: 18px;"><?php echo $summ . " / " .$sumspent ;?> ₽ <small>(<?php echo $percen;?>%)</small></strong>
	</div>
</div>

<p style="text-align: center;">
	<span style="font-size:22px;">Нас поддержали <small>(последние 25 переводов):</small></span>
</p>
		
		
<?php		
	
$result = $conn->query("SELECT * FROM (SELECT * from donations where datetime > '2018-01-01' ORDER BY datetime desc limit 25) sub ORDER BY datetime");

if ($result->num_rows > 0) {
	
	   while($row = $result->fetch_assoc()) {

if ($row["notification_type"] == 'p2p-incoming') {
	$oplata = 'ПЕРЕВОД ЯНДЕКС ДЕНЕГ';
} else if ( $row["notification_type"] == 'card-incoming') {
	$oplata = 'ПЕРЕВОД С КАРТЫ';
} else {
$oplata = $row["notification_type"];

	}

if ($row["user"] != 'неизвестный') {
	$user = '<span style="color:#d35400;"><strong>' . $row["user"] . '</strong></span>';
} else {
	$user = 'неизвестный';
}

echo '<p style="margin: 0;"><span style="font-size:11px;"><strong>'.date("d.m H:i", strtotime($row["datetime"])).'</strong> + <span style="color:#1ab814;"><strong>'. $row["withdraw_amount"].' ₽ </strong></span><span style="color:#27ae60;"><strong></span>('.$user.' - '.$oplata.')'. getdays((int)$row["withdraw_amount"]).'</span></p>';


    }
} else {
    echo "0 results";
}
?>


<p style="text-align: center;font-style: italic;">
	<span style="font-size:12px;">таблица генерируется в автоматическом режиме на основании информации, полученной от сервиса Яндекс.Деньги</small></span>
</p>



<blockquote class="ipsQuote" data-ipsquote="">
	<div class="ipsQuote_citation ipsQuote_closed">
		Все переводы
	</div>

	<div animating="true" class="ipsQuote_contents ipsClearfix ipsAnim ipsAnim_fade ipsAnim_in" style="display: none;">


<?php		
	
	
$result = $conn->query("SELECT * FROM (SELECT * from donations where datetime < '2018-01-01' ORDER BY datetime desc) sub ORDER BY datetime");

if ($result->num_rows > 0) {
	
	   while($row = $result->fetch_assoc()) {

if ($row["notification_type"] == 'p2p-incoming') {
	$oplata = 'ПЕРЕВОД ЯНДЕКС ДЕНЕГ';
} else if ( $row["notification_type"] == 'card-incoming') {
	$oplata = 'ПЕРЕВОД С КАРТЫ';
} else {
$oplata = $row["notification_type"];

	}

if ($row["user"] != 'неизвестный') {
	$user = '<span style="color:#d35400;"><strong>' . $row["user"] . '</strong></span>';
} else {
	$user = 'неизвестный';
}


echo '<p style="margin: 0;"><span style="font-size:11px;"><strong>'.date("d.m H:i", strtotime($row["datetime"])).'</strong> + <span style="color:#1ab814;"><strong>'. $row["withdraw_amount"].' ₽ </strong></span><span style="color:#27ae60;"><strong></span>('.$user.' - '.$oplata.')</span></p>';


    }
} else {
    echo "0 results";
}
	$conn->close();	
?>

	</div>
</blockquote>