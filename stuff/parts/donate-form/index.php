<?php
$guid = "";
$name = "Без VIP (выберите игрока через Статистику)";
if (!empty($_GET["guid"])) {
    $guid = (int) $_GET["guid"];

    if (strlen($guid) == 19) {

        $stats_db = new PDO('mysql:host=localhost;dbname=cod4stats', 'login', 'password');

        $name_query = $stats_db->query("SELECT s_player FROM stats WHERE s_guid = '".$guid."' ORDER by s_lasttime desc limit 1");
        $name2 = $name_query->fetchColumn();

        if (!empty($name2)) {
            $name = mb_convert_encoding($name2, 'UTF-8', 'UTF-8');
        } else {
            $guid = "";
        }

    } else {

        $guid = "";
    }
}

?>
<div style="text-align: center;">
    <p style="text-align: center;">
        <font color="#27ae60"><span style="font-size: 26px;"><b>Карта, Я.Деньги, с мобильного</b></span></font>
    </p>


    <link rel="stylesheet" href="/parts/donate-form/_money.css">
    <script type="text/javascript" charset="utf-8" src="/parts/donate-form/jquery.min.js"></script>
    <script type="text/javascript" charset="utf-8" src="/parts/donate-form/_money.js"></script>
    <script charset="utf-8" src="/parts/donate-form/lodash.min.js"></script>

    <script charset="utf-8" src="/parts/donate-form/_old-site.ru.js"></script>

    <link rel="Stylesheet" href="/parts/donate-form/b-widget-donate.css">

    <div class="i-ua_js_yes i-ua_css_standart utilityfocus i-ua_svg_yes i-ua_inlinesvg_yes i-ua_placeholder_yes b-widget-donate"
         data-content-block="this">
        <div class="b-widget-donate__target">
            GUID и Имя Игрока для установки <span class="form_link">VIP статуса </span>(<span class="vipdays">+22 дня</span> VIP)
        </div>

        <form method="POST" target="_blank" class="b-widget-donate__form"
              action="https://money.yandex.ru/quickpay/confirm.xml">
            <input name="label" type="hidden" value="<?= $guid ?>">
            <input name="receiver" type="hidden" value="41001485874410">
            <input name="quickpay-form" type="hidden" value="donate">
            <input name="referer" type="hidden" value="https://cod4narod.ru/donate">
            <input name="targets" type="hidden" value="Поддержка CoD4Narod.RU (<?= ($guid) ? "VIP для ".$name : 'Без VIP' ?>)">
            <input name="successURL" type="hidden" value="https://cod4narod.ru/thanks">
            <div class="b-widget-donate__comment">
                <label class="b-widget-donate__label"></label>
                <div class="b-textarea b-textarea__textarea-compact">
                    <textarea readonly class="b-textarea__textarea" name="vip" maxlength="60"><?= ($guid) ? $guid." (".$name.")" : $name ?></textarea>

                </div>

                <div class="b-form__field-hint">Для выбора GUID найдите себя в <a class="form_link" target="_blank"
                                                                                  href="https://cod4narod.ru/stats/">Статистике</a>, наведите на ник и
                    нажмите на VIP иконку
                </div>

                <div class="b-widget-donate__target">
                    <p>Ваш комментарий</a></p>
                </div>


                <div class="b-textarea b-textarea__textarea-compact">

                    <textarea class="b-textarea__textarea" style="height:60px !important" name="comment" maxlength="60"></textarea>
                </div>


            </div>
            <div class="b-input-text b-input-text_1 b-input-text_inline">
                <input class="b-input-text__input" name="sum" style="text-align: right;box-sizing: inherit;" type="text"
                       maxlength="10" value="100"><span class="b-widget-donate__currency">руб.</span></div>

            <script>

                function format_by_count(count) {
                    return format_by_form(count, ' дней ', ' дня ', ' день ');
                }

                function format_by_form(count, f1, f2, f3) {
                    count = Math.abs(count) % 100;
                    lcount = count % 10;

                    if (count >= 11 && count <= 19) return (f1);
                    if (lcount >= 2 && lcount <= 4) return (f2);
                    if (lcount == 1) return (f3);

                    return f1;
                }

                $(document).ready(function () {


                    $('input.b-input-text__input').on('keyup change', function () {

                        var amount = $(this).val();
                        var days = 0;


                        if (amount < 10)
                            days = Math.round(amount / 20);

                        else if (amount < 20)
                            days = Math.round(amount / 15);

                        else if (amount < 40)
                            days = Math.round(amount / 10);

                        else if (amount < 50)
                            days = Math.round(amount / 8);

                        else if ($(this).val() < 100)
                            days = Math.round(amount / 5);

                        else if ($(this).val() < 300)
                            days = Math.round(amount / 4.5);

                        else if ($(this).val() < 500)
                            days = Math.round(amount / 4.3);

                        else if ($(this).val() < 1000)
                            days = Math.round(amount / 4.0);

                        else if ($(this).val() < 2000)
                            days = Math.round(amount / 3.5);

                        else
                            days = Math.round(amount / 3);


                        $('.vipdays').text("+" + days + format_by_count(days));


                    });
                });
            </script>
            <span class="b-form-radio b-form-radio_size_xl b-form-radio_theme_grey i-bem b-form-radio_js_inited"
                  onclick="return {&#39;b-form-radio&#39;:{name:&#39;b-form-radio&#39;,id:&#39;id1166036927751&#39;}}">

            <label class="b-form-radio__button b-form-radio__button_id_ b-form-radio__button_disabled_no b-form-radio__button_focused_yes b-form-radio__button_checked_yes b-form-radio__button_side_left"
                   for="id1166036927758" title="платеж с карты VISA или MasterCard">

                <span class="b-form-radio__inner">
                    <span class="b-form-radio__content">
                        <input type="radio" name="paymentType" checked="checked" class="b-form-radio__radio"
                               id="id1166036927758" value="AC">
                        <span class="b-form-radio__text"><img class="b-icon b-form-radio__ico"
                                                              src="/parts/donate-form/quickpay-widget__any-card.png" alt=""
                                                              title=""></span><i class="b-form-radio__click"></i></span>
        </span>
        </label>
        <label class="b-form-radio__button b-form-radio__button_id_ b-form-radio__button_disabled_no b-form-radio__button_next-for-checked_yes"
               for="id1166036927781" title="платеж с баланса сотового"><span class="b-form-radio__inner">
                    <span class="b-form-radio__content"><input type="radio" name="paymentType"
                                                               class="b-form-radio__radio" id="id1166036927781"
                                                               value="MC">
                        <span class="b-form-radio__text"><img class="b-icon b-form-radio__ico"
                                                              src="/parts/donate-form/quickpay-widget__mobile.png" alt=""
                                                              title=""></span><i class="b-form-radio__click"></i></span>
			</span>
		</label>

        <label class="b-form-radio__button b-form-radio__button_id_ b-form-radio__button_disabled_no b-form-radio__button_next-for-checked_yes b-form-radio__button_side_right"
               for="id1166036927798" title="платеж из кошелька в Яндекс.Деньгах"><span class="b-form-radio__inner"><span
                        class="b-form-radio__content"><input type="radio" name="paymentType"
                                                             class="b-form-radio__radio" id="id1166036927798"
                                                             value="PC"><span class="b-form-radio__text"><img
                                class="b-icon b-form-radio__ico" src="/parts/donate-form/quickpay-widget__yamoney.png" alt=""
                                title=""></span><i class="b-form-radio__click"></i></span>
			</span>
		</label>

        </span><span class="b-button b-button_1 b-button_orange" data-block="b-button"><span class="b-button__inner">Поддержать</span>
        <input type="submit" value="Поддержать" class="b-button__input" name="submit-button">
        </span>

        </form>
    </div>


    <p style="text-align: center;">
        <span style="font-size:26px;"><span style="color:#27ae60;"><strong>WebMoney, Bitcoin, QIWI&nbsp;и др.</strong></span></span>
    </p>

    <p style="text-align: center;">
        <iframe height="150" scrolling="no"
                src="https://funding.webmoney.ru/widgets/horizontal/33984670-2e50-41f2-977b-7cba95e2a9ce?bt=0&amp;hs=1&amp;sum=100&amp;hcc=1&amp;hym=1&amp;hmc=1"
                style="border:none;" width="468"></iframe>
    </p>
    <!--
    <p style="text-align: center;">
        <font color="#27ae60"><span style="font-size: 26px;"><b>Оплата Хостинга (QIWI)</b></span></font>
    </p>

    <p style="text-align: center;">
        Так же, Вы можете помочь самым естественным способом -
    </p>

    <p style="text-align: center;">
        закинуть денег напрямую&nbsp;на <span style="color:#27ae60;"><strong>наш хостинг</strong></span>.
    </p>

    <p style="text-align: center;">
        Для этого пройдите по ссылке:
    </p>

    <p style="text-align: center;">
        &nbsp;<span style="font-size:18px;"><strong><a class="form_link" href="https://qiwi.com/payment/form.action?provider=1712" ipsnoembed="true" rel="external nofollow"><span style="color:#27ae60;">https://qiwi.com/payment/form.action?provider=1712</span></a></strong>&nbsp;</span><span style="font-size:14px;">(ЗАО Первый)</span>
    </p>

    <p style="text-align: center;">
        <span style="font-size:16px;">и введите номер нашего ЛС:&nbsp;<strong><span style="color:#27ae60;">639002</span></strong><span style="color:#27ae60;"> </span></span>
    </p>

    <p style="text-align: center;">
        <span style="font-size:14px;">(оплата любым способом,<span style="color:#27ae60;"> без комиссии</span>)</span>
    </p> -->

    <p style="text-align: center;margin: 0;">
        <span style="font-size:26px;"><strong><span style="color:#27ae60;">Перевод PayPal -</span>&nbsp;</strong></span><u><span
                    style="font-size:24px;"><strong><a class="form_link" href="https://www.paypal.me/volkv" rel="external nofollow"><span
                                style="color:#d35400;">PayPal.me/</span><span style="color:#27ae60;">volkv</span></a></strong></span></u>
    </p>

    <p style="margin: 0;text-align: center;">
        <span style="font-size:12px;">(please include your ingame nickname in the payment note)</span>
    </p>

    <p style="text-align: center;">
        <input name="cmd" type="hidden" value="_s-xclick"><input name="encrypted" type="hidden" value="-----BEGIN PKCS7-----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-----END PKCS7-----
">
    </p>

</div>
