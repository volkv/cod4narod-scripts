<?php

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

function sort_by_kills($a, $b) {
    return $b['kills'] > $a['kills'] ? 1 : -1;
}

function sort_by_playedkills($a, $b) {
    return $b['playedkills'] > $a['playedkills'] ? 1 : -1;
}

function sort_by_knives($a, $b) {
    return $b['knives'] > $a['knives'] ? 1 : -1;
}

function sort_by_heads($a, $b) {
    return $b['heads'] > $a['heads'] ? 1 : -1;
}

function sort_by_kd($a, $b) {
    return $b['kd'] > $a['kd'] ? 1 : -1;
}

function sort_by_suicids($a, $b) {
    return $b['suicids'] > $a['suicids'] ? 1 : -1;
}

function sort_by_skill($a, $b) {
    return $b['skill'] > $a['skill'] ? 1 : -1;
}

function seconds_to_time($seconds) {
    $days = floor($seconds / (3600 * 24));
    $hours = floor(($seconds / 3600) % 24);
    $minutes = floor(($seconds / 60) % 60);

    if ($days > 0)
        return $days . ' д ' . $hours . ' ч';
    else if ($hours > 0)
        return $hours . ' ч ' . $minutes . ' м';
    else
        return $minutes . ' м';
}

function format_by_count($count) {
    return format_by_form($count, ' дней ', ' дня ', ' день ');
}

function format_by_form($count, $f1, $f2, $f3) {
    $count = abs($count) % 100;
    $lcount = $count % 10;

    if ($count >= 11 && $count <= 19) return ($f1);
    if ($lcount >= 2 && $lcount <= 4) return ($f2);
    if ($lcount == 1) return ($f3);

    return $f1;
}

function diff_text($sinceThen) {
    $days = $sinceThen->d;
    $months = $sinceThen->m;
    $years = $sinceThen->y;

    if ($years == 0 && $months == 0 && $days == 0) {
        $yearmonthsdays = "Сегодня";
    } else if ($years >= 0 && $months == 0 && $days == 0) {
        $yearmonthsdays = $years . " лет";
    } else if ($years == 0 && $months >= 0 && $days == 0) {
        $yearmonthsdays = $months . " мес";
    } else if ($years == 0 && $months == 0 && $days >= 0) {
        $yearmonthsdays = $days . format_by_count($days);
    } else if ($years >= 0 && $months == 0 && $days >= 0) {
        $yearmonthsdays = $years . " лет  " . $days . " д";
    } else if ($years == 0 && $months >= 0 && $days >= 0) {
        $yearmonthsdays = $months . " мес  " . $days . " д";
    } else if ($years >= 0 && $months >= 0 && $days >= 0) {
        $yearmonthsdays = $years . " лет " . $months . " мес " . $days . " д";
    } else {
        $yearmonthsdays = " ";
    }

    $total = $years * 365.25 + $months * 30 + $days;

    if ($total > 15) $total = 15;

    $total = 120 - ($total * 8);

    $hsl = $total . ',100%,50%';

    return '<span style= "color:hsl(' . $hsl . ') ">' . $yearmonthsdays . '</span>';
}

function get_prestige_icon($kills) {
    if ($kills < 270)
        return "1-3";
    else if ($kills < 1080)
        return "4-6";
    else if ($kills < 2430)
        return "7-9";
    else if ($kills < 4380)
        return "10-12";
    else if ($kills < 7050)
        return "13-15";
    else if ($kills < 10440)
        return "16-18";
    else if ($kills < 14550)
        return "19-21";
    else if ($kills < 19380)
        return "22-24";
    else if ($kills < 24930)
        return "25-27";
    else if ($kills < 31240)
        return "28-30";
    else if ($kills < 38590)
        return "31-33";
    else if ($kills < 47020)
        return "34-36";
    else if ($kills < 56530)
        return "37-39";
    else if ($kills < 67120)
        return "40-42";
    else if ($kills < 78790)
        return "43-45";
    else if ($kills < 91540)
        return "46-48";
    else if ($kills < 105370)
        return "49-51";
    else if ($kills < 120280)
        return "52-54";
    else
        return "55";
}

function get_rank_text($kills) {
    $i = 0;
    if (++$i && $kills < 30) return $i . ";Private First Class";
    if ($i++ && $kills < 120) return $i . ";Private First Class I";
    if ($i++ && $kills < 270) return $i . ";Private First Class II";
    if ($i++ && $kills < 480) return $i . ";Lance Corporal";
    if ($i++ && $kills < 750) return $i . ";Lance Corporal I";
    if ($i++ && $kills < 1080) return $i . ";Lance Corporal II";
    if ($i++ && $kills < 1470) return $i . ";Corporal";
    if ($i++ && $kills < 1920) return $i . ";Corporal I";
    if ($i++ && $kills < 2430) return $i . ";Corporal II";
    if ($i++ && $kills < 3000) return $i . ";Sergeant";
    if ($i++ && $kills < 3650) return $i . ";Sergeant I";
    if ($i++ && $kills < 4380) return $i . ";Sergeant II";
    if ($i++ && $kills < 5190) return $i . ";Staff Sergeant";
    if ($i++ && $kills < 6080) return $i . ";Staff Sergeant I";
    if ($i++ && $kills < 7050) return $i . ";Staff Sergeant II";
    if ($i++ && $kills < 8100) return $i . ";Gunnery Sergeant";
    if ($i++ && $kills < 9230) return $i . ";Gunnery Sergeant I";
    if ($i++ && $kills < 10440) return $i . ";Gunnery Sergeant II";
    if ($i++ && $kills < 11730) return $i . ";Master Sergeant";
    if ($i++ && $kills < 13100) return $i . ";Master Sergeant I";
    if ($i++ && $kills < 14550) return $i . ";Master Sergeant II";
    if ($i++ && $kills < 16080) return $i . ";Master Gunnery Sergeant";
    if ($i++ && $kills < 17690) return $i . ";Master Gunnery Sergeant I";
    if ($i++ && $kills < 19380) return $i . ";Master Gunnery Sergeant II";
    if ($i++ && $kills < 21150) return $i . ";Second Lieutenant";
    if ($i++ && $kills < 23000) return $i . ";Second Lieutenant I";
    if ($i++ && $kills < 24930) return $i . ";Second Lieutenant II";
    if ($i++ && $kills < 26940) return $i . ";First Lieutenant";
    if ($i++ && $kills < 29030) return $i . ";First Lieutenant I";
    if ($i++ && $kills < 31240) return $i . ";First Lieutenant II";
    if ($i++ && $kills < 33570) return $i . ";Captain";
    if ($i++ && $kills < 36020) return $i . ";Captain I";
    if ($i++ && $kills < 38590) return $i . ";Captain II";
    if ($i++ && $kills < 41280) return $i . ";Major";
    if ($i++ && $kills < 44090) return $i . ";Major I";
    if ($i++ && $kills < 47020) return $i . ";Major II";
    if ($i++ && $kills < 50070) return $i . ";Lieutenant Colonel";
    if ($i++ && $kills < 53240) return $i . ";Lieutenant Colonel I";
    if ($i++ && $kills < 56530) return $i . ";Lieutenant Colonel II";
    if ($i++ && $kills < 59940) return $i . ";Colonel";
    if ($i++ && $kills < 63470) return $i . ";Colonel I";
    if ($i++ && $kills < 67120) return $i . ";Colonel II";
    if ($i++ && $kills < 70890) return $i . ";Brigadier General";
    if ($i++ && $kills < 74780) return $i . ";Brigadier General I";
    if ($i++ && $kills < 78790) return $i . ";Brigadier General II";
    if ($i++ && $kills < 82920) return $i . ";Major General";
    if ($i++ && $kills < 87170) return $i . ";Major General I";
    if ($i++ && $kills < 91540) return $i . ";Major General II";
    if ($i++ && $kills < 96030) return $i . ";Lieutenant General";
    if ($i++ && $kills < 100640) return $i . ";Lieutenant General I";
    if ($i++ && $kills < 105370) return $i . ";Lieutenant General II";
    if ($i++ && $kills < 110220) return $i . ";General";
    if ($i++ && $kills < 115190) return $i . ";General I";
    if ($i++ && $kills < 120280) return $i . ";General II";
    if ($i++ && $kills < 125490) return $i . ";Commander";
    if ($i++ && $kills < 130820) return $i . ";Commander I";
    if ($i++ && $kills < 136270) return $i . ";Commander II";
    if ($i++ && $kills < 141840) return $i . ";Commander II";
    if ($i++ && $kills < 147530) return $i . ";Commander III";
    if ($i++ && $kills < 153340) return $i . ";Commander IIII";
    if ($i++ && $kills < 159270) return $i . ";Commander V";
    if ($i++ && $kills < 165320) return $i . ";Commander VI";
    if ($i++ && $kills < 171490) return $i . ";Commander VII";
    if ($i++ && $kills < 177780) return $i . ";Commander VIII";
    if ($i++ && $kills < 184190) return $i . ";Commander VIIII";
    if ($i++ && $kills < 190720) return $i . ";Commander X";
    if ($i++ && $kills < 197370) return $i . ";Commander XI";
    if ($i++ && $kills < 204140) return $i . ";Commander XII";
    if ($i++ && $kills < 211030) return $i . ";Commander XIII";
    if ($i++ && $kills < 218040) return $i . ";Commander XIIII";
    if ($i++ && $kills < 225170) return $i . ";Commander XV";
    if ($i++ && $kills < 232420) return $i . ";Commander XVI";
    if ($i++ && $kills < 239790) return $i . ";Commander XVII";
    if ($i++ && $kills < 247280) return $i . ";Commander XVIII";
    if ($i++ && $kills < 254890) return $i . ";Commander XVIIII";
    if ($i++ && $kills < 262620) return $i . ";Commander XX";
    if ($i++ && $kills < 270470) return $i . ";Commander XXI";
    if ($i++ && $kills < 278440) return $i . ";Commander XXII";
    if ($i++ && $kills < 286530) return $i . ";Commander XXIII";
    if ($i++ && $kills < 294740) return $i . ";Commander XXIIII";
    if ($i++ && $kills < 303070) return $i . ";Supreme Commander I";
    if ($i++ && $kills < 311520) return $i . ";Supreme Commander II";
    if ($i++ && $kills < 320090) return $i . ";Supreme Commander III";
    if ($i++ && $kills < 328780) return $i . ";Supreme Commander IIII";
    if ($i++ && $kills < 337590) return $i . ";Supreme Commander V";
    if ($i++ && $kills < 346520) return $i . ";Supreme Commander VI";
    if ($i++ && $kills < 355570) return $i . ";Supreme Commander VII";
    if ($i++ && $kills < 364740) return $i . ";Supreme Commander VIII";
    if ($i++ && $kills < 374030) return $i . ";Supreme Commander VIIII";
    if ($i++ && $kills < 383440) return $i . ";Supreme Commander XI";
    if ($i++ && $kills < 392970) return $i . ";Supreme Commander XII";
    if ($i++ && $kills < 402620) return $i . ";Supreme Commander XIII";
    if ($i++ && $kills < 412390) return $i . ";Supreme Commander XIIII";
    if ($i++ && $kills < 422280) return $i . ";Supreme Commander XX";
    if ($i++ && $kills < 432290) return $i . ";Supreme Commander XXI";
    if ($i++ && $kills < 442420) return $i . ";Supreme Commander XXII";
    if ($i++ && $kills < 452670) return $i . ";Supreme Commander XXIII";
    if ($i++ && $kills < 463040) return $i . ";Supreme Commander XXIIII";
    if ($i++ && $kills < 473530) return $i . ";Supreme Commander XXX";
    if ($i++ && $kills < 484140) return $i . ";Supreme Commander XXXI";
    if ($i++ && $kills < 494870) return $i . ";Supreme Commander XXXII";
    if ($i++ && $kills < 505720) return $i . ";Supreme Commander XXXIII";
	

    else {
        $i++;

        return $i . ";Commander";
    }
}

function h($s) {
    return htmlspecialchars($s, ENT_QUOTES, 'utf-8');
}

function get_prestige($kd) {
    if ($kd < .5) {
        return "Бронзовый Герб;Rank_Prestige_1_CoD4";
    } else if ($kd < .8) {
        return "Серебряный Герб;Rank_Prestige_6_CoD4";
    } else if ($kd < 1.2) {
        return "Золотая Эмблема;Rank_Prestige_2_CoD4";
    } else if ($kd < 1.6) {
        return "Черный Жемчуг;Rank_Prestige_4_CoD4";
    } else if ($kd < 2) {
        return "Кровавый Рубин;Rank_Prestige_8_CoD4";
    } else if ($kd < 2.6) {
        return "Ядерный Гранат;Rank_Prestige_9_CoD4";
    } else {
        return "Челленджер;Rank_Prestige_10_CoD4";
    }
}

function uncolorize($string) {
    $string = str_replace('^1', '', $string);
    $string = str_replace('^2', '', $string);
    $string = str_replace('^3', '', $string);
    $string = str_replace('^4', '', $string);
    $string = str_replace('^5', '', $string);
    $string = str_replace('^6', '', $string);
    $string = str_replace('^7', '', $string);
    $string = str_replace('^8', '', $string);
    $string = str_replace('^9', '', $string);
    $string = str_replace('^0', '', $string);

    return $string;
}

function colorize($string) {
    $string .= "^";

    $find = array(
        '/\^0(.*?)\^/is',
        '/\^1(.*?)\^/is',
        '/\^2(.*?)\^/is',
        '/\^3(.*?)\^/is',
        '/\^4(.*?)\^/is',
        '/\^5(.*?)\^/is',
        '/\^6(.*?)\^/is',
        '/\^7(.*?)\^/is',
        '/\^8(.*?)\^/is',
        '/\^9(.*?)\^/is',
    );

    $replace = array(
        '<span style="color:#777777;">$1</span>^',
        '<span style="color:#F65A5A;">$1</span>^',
        '<span style="color:#00F100;">$1</span>^',
        '<span style="color:#EFEE04;">$1</span>^',
        '<span style="color:#0F04E8;">$1</span>^',
        '<span style="color:#04E8E7;">$1</span>^',
        '<span style="color:#F75AF6;">$1</span>^',
        '<span style="color:#FFFFFF;">$1</span>^',
        '<span style="color:#7E7E7E;">$1</span>^',
        '<span style="color:#6E3C3C;">$1</span>^',
    );

    $string = preg_replace($find, $replace, $string);

    return substr($string, 0, strlen($string) - 1);
}

function format_color($number, $fix = 1, $reverse = false, $percent = true) {
    if (!is_numeric($number))
        return "";

    $total = $number * $fix;

    if ($total > 120) $total = 120;

    if ($reverse) $total = 120 - $total;
    $hsl = $total . ',100%,50%';
    if ($percent)
        return '<span style= "color:hsl(' . $hsl . ')">' . number_format($number, 3) * 100 . '%</span>';
    else
        return '<span style= "color:hsl(' . $hsl . ')">' . $number . '</span>';
}