<?php

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
?>


<div class="ipsType_richText">
<p style="text-align: center;margin-bottom: 5px;">
	<span style="font-size:22px;">Оплата Хостинга</span></p>

<div class="wa-progress" style="width: 100%;margin: 0 auto;margin-top: 5px;height: 25px;">
	<div aria-valuemax="100" aria-valuemin="0" aria-valuenow="45" class="wa-progress-bar wa-progress-bar-striped" role="progressbar" style="width: <?php echo $percen;?>%;background-color:#57a443;max-width:100%;">
		 
	</div>

	<div style="position: absolute; width: 100%; color: #<?php echo $color ;?>;">
		<strong style="font-size: 15px;"><?php echo $summ . " / " .$sumspent ;?> ₽ <small>(<?php echo $percen;?>%)</small></strong>
	</div>
</div>

<p style="text-align: center;margin: 0;">
	<span style="font-size:12px;">(собрано / потрачено)</span>
</p>

<p style="text-align: center;margin: 0;">
	<a href="http://cod4narod.ru/donate/" rel=""><span style="font-size:18px;"><strong><span style="color:#27ae60;">Поддержать проект</span></strong></span> </a>
</p>

<p style="text-align: center;margin: 0;">
	<a href="http://cod4narod.ru/donate/" rel="">(и получить <strong><span style="color:#f39c12;">VIP статус</span></strong>)</a>
</p>

<script>

    function createCookie2(name, value, days) {
        var expires = "";
        if (days) {
            var date = new Date();
            date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
            expires = "; expires=" + date.toUTCString();
        }
        document.cookie = name + "=" + value + expires + "; path=/";
    }

window.pushed = false;
    function HideBlockNy() {

		
        if ($("#hide_block_ny_btn").hasClass('open')) {
            createCookie2('hide_block_ny', 1, .25);
			 $('#block_ny').toggle();

        } else {
            createCookie2('hide_block_ny', "", -1);
			if (!pushed) {
				window.pushed = true;
			(adsbygoogle = window.adsbygoogle || []).push({});
			
			}
        }

        $("#hide_block_ny_btn").toggleClass('open');

		
       
		
        return 0;

    }

</script>
<!-- <h2 class="ipsType_sectionTitle ipsType_reset" style="padding: 3px 15px;">

    <span><span  style=" font-size: 14px;   color: #4e4e4e;   margin-left: 10px; ">Реклама (cпасибo! ;)</span>

        <a href="#" id="hide_block_ny_btn" <?php if (!isset($_COOKIE['hide_block_ny'])) {
	        echo 'class="open"';
        } ?> onclick="event.preventDefault();HideBlockNy();"></a>

    </span>
</h2>

<ins id="block_ny" class="adsbygoogle"
     style="display:block"
     data-ad-client="ca-pub-7957101469761625"
     data-ad-slot="6284037056"
     data-ad-format="auto"></ins> -->
	 
<?php 
//if (!isset($_COOKIE['hide_block_ny']))  {

//echo '<script>(adsbygoogle = window.adsbygoogle || []).push({});</script>';} ?>