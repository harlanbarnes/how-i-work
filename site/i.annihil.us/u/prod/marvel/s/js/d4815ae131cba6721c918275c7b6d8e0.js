var JM01=function(d){var e,a;function c(){var f=d.parents(".pwrSldr_container").first();if($(window).innerWidth()<1105){a="auto"}else{a="none"}if(Juggernaut.client.isAndroidPre42&&Juggernaut.client.hasTouch&&$(window).innerWidth()<1105){f.css("width",Juggernaut.utilities.getWidthOfSliderForScroll(f)+"px");f.parents(".module").first().addClass("pwrSldr-overflow-visible");a="scroll"}e=d.pwrSldr({pagination:a});RowItemTruncator.truncate(f);$("._nxt").click(function(g){g.preventDefault();e.next(2,null,true)});$(window).on("resize",b)}function b(){setTimeout(function(){if($(window).innerWidth()<1105&&a!=="auto"){a="auto";e.changeOpts({pagination:a});RowItemTruncator.truncate(d.parents(".pwrSldr_container").first())}else{if($(window).innerWidth()>=1105&&a!=="none"){a="none";e.changeOpts({pagination:a});RowItemTruncator.truncate(d.parents(".pwrSldr_container").first())}}},50)}return{el:d,ps:e,i:c,u:b}};