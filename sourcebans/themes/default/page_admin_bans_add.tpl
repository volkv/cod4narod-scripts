{if NOT $permission_addban}
  Access Denied!
{else}

  <div id="msg-green" style="display:none;">
    <i><img src="./images/yay.png" alt="Success" /></i>
    <b>Ban Added</b><br />
    The new ban has been added to the system.<br /><br />
    <i>Redirecting back to bans page</i>
  </div>
  

  <div id="add-group1">
    <h3>Добавить бан</h3>
   Наведите на значок вопроса для дополнительной информации<br /><br />
    <table width="90%" style="border-collapse:collapse;" id="group.details" cellpadding="3">
    <tr>
        <td valign="top" width="35%">
          <div class="rowdesc">
            {help_icon title="Ник" message="Введите Никнейм игрока."}Ник 
          </div>
        </td>
        <td>
          <div align="left">
            <input type="hidden" id="fromsub" value="" />
              <input type="text" TABINDEX=1 class="textbox" id="nickname" name="nickname" style="width: 169px" value="{$plname}" />
          </div>
          <div id="nick.msg" class="badentry"></div>
        </td>
      </tr>
      <tr>
        <td valign="top" width="35%">
          <div class="rowdesc">
            {help_icon title="Тип Бана" message="COD4 GUID или IP "}Тип Бана
          </div>
        </td>
        <td>
          <div align="left">
            <select id="type" name="type" TABINDEX=2 class="select" style="width: 196px">
              <option value="0">COD4 GUID</option>
              <option value="1">IP Address</option>
            </select>
          </div>
        </td>
      </tr>
      <tr>
        <td valign="top">
          <div class="rowdesc">
            {help_icon title="COD4 GUID" message="Введите GUID игрока (начинается на 2310)"}COD4 GUID
          </div>
        </td>
        <td>
          <div align="left">
            <input type="text" TABINDEX=3 class="textbox" id="steam" name="steam" style="width: 169px" value="{$plguid}" />
          </div>
          <div id="steam.msg" class="badentry"></div>
        </td>
      </tr>
      <tr>
        <td valign="top" width="35%">
          <div class="rowdesc">
            {help_icon title="IP адрес" message="Введите IP грока."}IP адрес
          </div>
        </td>
        <td>
          <div align="left">
            <input type="text" TABINDEX=3 class="textbox" id="ip" name="ip" style="width: 169px" value="{$plip}"/>
          </div>
          <div id="ip.msg" class="badentry"></div>
        </td>
      </tr>
      <tr>
        <td valign="top" width="35%">
          <div class="rowdesc">
            {help_icon title="Причина бана" message="Введите причину бана (выберите единственную доступную)"}Причина бана
          </div>
        </td>
        <td>
          <div align="left">
            <select id="listReason" name="listReason" TABINDEX=4 class="select" onChange="changeReason(this[this.selectedIndex].value);">
           
     			<optgroup label="Читы">
					    	<option value="^1You are in server's blacklist. Please visit ^2CoD4Narod^3.RU ^0------- ^1BbI B 4EPHOM CnuCKE. CauT nPoeKTa ^2CoD4Narod^3.RU" selected>Бан за читы</option>
								</optgroup>
				<optgroup label="Другое">
					    	<option value="^1You are temp banned for black screenshots - ^2CoD4Narod^3.RU ^0------- ^1BbI BPEMEHHO 3A6AHEHbI 3A 4EPHbIE CKPUHbI  ^2CoD4Narod^3.RU">Черныe cкриншоты</option>
							<option value="^1You are temp banned for ^3r_fullbright 1 -  ^2CoD4Narod^3.RU ^0------- ^1BbI BPEMEHHO 3A6AHEHbI 3A ^3r_fullbright 1  ^2CoD4Narod^3.RU">r_fullbright</option>
								</optgroup>
			
          {if $customreason}
          <optgroup label="Custom">
          {foreach from="$customreason" item="creason"}
            <option value="{$creason}">{$creason}</option>
          {/foreach}
          </optgroup>
          {/if}
   <option value="other">Other Reason</option>
        </select>
        <div id="dreason" style="display:none;">
              <textarea class="textbox" TABINDEX=4 cols="30" rows="5" id="txtReason" name="txtReason"></textarea>
            </div>
          </div>
          <div id="reason.msg" class="badentry"></div>
        </td>
      </tr>
      <tr>
        <td valign="top" width="35%">
          <div class="rowdesc">
            {help_icon title="Срока бана" message="На сколько баним"}Срок бана
          </div>
        </td>
        <td>
          <div align="left">
              <select id="banlength" TABINDEX=5 class="select" style="width: 196px">
            <option value="0">Вечный</option>
            <optgroup label="minutes">
              <option value="1">1 минута</option>
              <option value="5">5 минут</option>
              <option value="10">10 минут</option>
              <option value="15">15 минут</option>
              <option value="30">30 минут</option>
              <option value="45">45 минут</option>
            </optgroup>
            <optgroup label="hours">
              <option value="60">1 час</option>
              <option value="120">2 часа</option>
              <option value="180">3 часа</option>
              <option value="240">4 часа</option>
              <option value="480">8 часов</option>
              <option value="720">12 часов</option>
            </optgroup>
            <optgroup label="days">
              <option value="1440">1 день</option>
              <option value="2880">2 дня</option>
              <option value="4320">3 дня</option>
              <option value="5760">4 дня</option>
              <option value="7200">5 дней</option>
              <option value="8640">6 дней</option>
            </optgroup>
            <optgroup label="weeks">
              <option value="10080">1 неделя</option>
              <option value="20160">2 недели</option>
              <option value="30240">3 недели</option>
            </optgroup>
            <optgroup label="months">
              <option value="43200">1 месяц</option>
              <option value="86400">2 месяца</option>
              <option value="129600">3 месяца</option>
              <option value="259200">6 месяцев</option>
              <option value="518400">12 месяцев</option>
            </optgroup>
          </select>
          </div>
          <div id="length.msg" ></div>
        </td>
      </tr>
      
      
      <tr>
        <td valign="top" width="35%">
          <div class="rowdesc">
            {help_icon title="Доказательства" message="Обязательно загрузите доказателства (скрин, демка)"}Доказательства
          </div>
        </td>
        <td>
          <div align="left">
            {sb_button text="Загрузить доказательство" onclick="childWindow=open('pages/admin.uploaddemo.php','upload','resizable=no,width=300,height=130');" class="save" id="udemo" submit=false}
          </div>
          <div id="demo.msg" style="color:#CC0000;"></div>
        </td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td>
            {sb_button text="Добавить бан" onclick="ProcessBan();" class="ok" id="aban" submit=false}
              &nbsp;
        {sb_button text="Назад" onclick="history.go(-1)" class="cancel" id="aback"}
          </td>
      </tr>
  </table>
</div>
{$message}
{/if}
