!function(e){"function"==typeof define&&define.amd?define(["jquery","moment"],e):e(jQuery,moment)}(function(e,t){function n(e){return e>1&&5>e}function r(e,t,r,i){var o=e+" ";switch(r){case"s":return t||i?"p\xe1r sek\xfand":"p\xe1r sekundami";case"m":return t?"min\xfata":i?"min\xfatu":"min\xfatou";case"mm":return t||i?o+(n(e)?"min\xfaty":"min\xfat"):o+"min\xfatami";case"h":return t?"hodina":i?"hodinu":"hodinou";case"hh":return t||i?o+(n(e)?"hodiny":"hod\xedn"):o+"hodinami";case"d":return t||i?"de\u0148":"d\u0148om";case"dd":return t||i?o+(n(e)?"dni":"dn\xed"):o+"d\u0148ami";case"M":return t||i?"mesiac":"mesiacom";case"MM":return t||i?o+(n(e)?"mesiace":"mesiacov"):o+"mesiacmi";case"y":return t||i?"rok":"rokom";case"yy":return t||i?o+(n(e)?"roky":"rokov"):o+"rokmi"}}var i="janu\xe1r_febru\xe1r_marec_apr\xedl_m\xe1j_j\xfan_j\xfal_august_september_okt\xf3ber_november_december".split("_"),o="jan_feb_mar_apr_m\xe1j_j\xfan_j\xfal_aug_sep_okt_nov_dec".split("_");(t.defineLocale||t.lang).call(t,"sk",{months:i,monthsShort:o,monthsParse:function(e,t){var n,r=[];for(n=0;12>n;n++)r[n]=new RegExp("^"+e[n]+"$|^"+t[n]+"$","i");return r}(i,o),weekdays:"nede\u013ea_pondelok_utorok_streda_\u0161tvrtok_piatok_sobota".split("_"),weekdaysShort:"ne_po_ut_st_\u0161t_pi_so".split("_"),weekdaysMin:"ne_po_ut_st_\u0161t_pi_so".split("_"),longDateFormat:{LT:"H:mm",LTS:"LT:ss",L:"DD.MM.YYYY",LL:"D. MMMM YYYY",LLL:"D. MMMM YYYY LT",LLLL:"dddd D. MMMM YYYY LT"},calendar:{sameDay:"[dnes o] LT",nextDay:"[zajtra o] LT",nextWeek:function(){switch(this.day()){case 0:return"[v nede\u013eu o] LT";case 1:case 2:return"[v] dddd [o] LT";case 3:return"[v stredu o] LT";case 4:return"[vo \u0161tvrtok o] LT";case 5:return"[v piatok o] LT";case 6:return"[v sobotu o] LT"}},lastDay:"[v\u010dera o] LT",lastWeek:function(){switch(this.day()){case 0:return"[minul\xfa nede\u013eu o] LT";case 1:case 2:return"[minul\xfd] dddd [o] LT";case 3:return"[minul\xfa stredu o] LT";case 4:case 5:return"[minul\xfd] dddd [o] LT";case 6:return"[minul\xfa sobotu o] LT"}},sameElse:"L"},relativeTime:{future:"za %s",past:"pred %s",s:r,m:r,mm:r,h:r,hh:r,d:r,dd:r,M:r,MM:r,y:r,yy:r},ordinalParse:/\d{1,2}\./,ordinal:"%d.",week:{dow:1,doy:4}}),e.fullCalendar.datepickerLang("sk","sk",{closeText:"Zavrie\u0165",prevText:"&#x3C;Predch\xe1dzaj\xfaci",nextText:"Nasleduj\xfaci&#x3E;",currentText:"Dnes",monthNames:["janu\xe1r","febru\xe1r","marec","apr\xedl","m\xe1j","j\xfan","j\xfal","august","september","okt\xf3ber","november","december"],monthNamesShort:["Jan","Feb","Mar","Apr","M\xe1j","J\xfan","J\xfal","Aug","Sep","Okt","Nov","Dec"],dayNames:["nede\u013ea","pondelok","utorok","streda","\u0161tvrtok","piatok","sobota"],dayNamesShort:["Ned","Pon","Uto","Str","\u0160tv","Pia","Sob"],dayNamesMin:["Ne","Po","Ut","St","\u0160t","Pia","So"],weekHeader:"Ty",dateFormat:"dd.mm.yy",firstDay:1,isRTL:!1,showMonthAfterYear:!1,yearSuffix:""}),e.fullCalendar.lang("sk",{buttonText:{month:"Mesiac",week:"T\xfd\u017ede\u0148",day:"De\u0148",list:"Rozvrh"},allDayText:"Cel\xfd de\u0148",eventLimitText:function(e){return"+\u010fal\u0161ie: "+e}})});