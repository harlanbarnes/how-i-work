var janrain=(function(b){var g={message:"Enter Marvel.com, the best place to connect with other fans and get news about comics & greatest super-heroes: Iron Man, Thor, Captain America, the X-Men, and more.",title:"Marve.com",description:"Enter Marvel.com, the best place to connect with other fans and get news about comics & greatest super-heroes: Iron Man, Thor, Captain America, the X-Men, and more."};function e(){c();f();d()}function c(){b.settings=b.settings||{};b.settings.share=b.settings.share||{};b.settings.packages=b.settings.packages||[];b.settings.packages.push("share");b.settings.share.message=g.message;b.settings.share.title=g.title;b.settings.share.url="http://marvel.com/";b.settings.share.description=g.description}function d(){var j=document.createElement("script");j.type="text/javascript";j.id="janrainWidgets";if(document.location.protocol==="https:"){j.src=URLs.rpxWidgetUrlSecure}else{j.src=URLs.rpxWidgetUrl}var h=document.getElementsByTagName("script")[0];h.parentNode.insertBefore(j,h)}function f(){a().setReadyBinds();a().setClickBinds()}function a(){return{setReadyBinds:function(){function h(){janrain.ready=true}if(document.addEventListener){document.addEventListener("DOMContentLoaded",h,false)}else{window.attachEvent("onload",h)}},setClickBinds:function(){function h(){var j=this.getAttribute("data-janrain-sharebtn");var l=this.getAttribute("data-janrain-forcemeta");if(typeof l==="string"&&l.length>0){try{l=JSON.parse(this.getAttribute("data-janrain-forcemeta"))}catch(k){throw"invalid JSON passed"}}else{l={}}janrain.engage.share.reset();setMetaContent(l);janrain.engage.share.showProvider(j);janrain.engage.share.show()}$(document).on("click","*[data-janrain-sharebtn]",function(j){j.preventDefault();h.call(this)})}}}e();return b})(janrain||{});function janrainShareOnload(){if(typeof gallery!=="undefined"||typeof Juggernaut.overRideJanrain!=="undefined"){return false}janrain.events.onModalOpen.addHandler(function(a){setMetaContent()})}function setMetaContent(b){b=b||{};var a={message:getMetaContent(""),title:getMetaContent("og:title"),image:getMetaContent("og:image"),desc:getMetaContent("og:description"),url:getMetaContent("og:url")};b=$.extend({},a,b);janrain.engage.share.setMessage(b.message);janrain.engage.share.setTitle(b.title);janrain.engage.share.setImage(b.image);janrain.engage.share.setDescription(b.desc);janrain.engage.share.setUrl(b.url)}function getMetaContent(a){var b=document.getElementsByTagName("meta");for(i=0;i<b.length;i++){if(b[i].getAttribute("name")==a||b[i].getAttribute("property")==a){return b[i].getAttribute("content").trim()}}return""}$(document).on("focus blur",".findashop input[type=text]",function(b){var a=b.type;if(a==="focusin"&&this.value===this.defaultValue){this.value=""}else{if(a==="focusout"&&this.value===""){this.value=this.defaultValue}}});$(document).on("click","a[data-collapse-trigger]",function(b){b.preventDefault();var a=this.getAttribute("data-collapse-trigger");$("[data-collapse-item="+a+"]").slideToggle();if(this.innerHTML.toUpperCase()==="HIDE"){this.innerHTML="Show More"}else{if(this.innerHTML.toUpperCase()==="SHOW MORE"){this.innerHTML="Hide"}}});$(document).on("click","span[data-squeezed-toggler], a[data-squeezed-toggler]",function(a){a.preventDefault();var b=this.getAttribute("data-squeezed-toggler");$("*[data-squeezed-wrap="+b+"]").fadeToggle()});$(document).on("click","a[data-blurb-trigger]",function(d){d.preventDefault();var b=this.getAttribute("data-blurb-trigger"),c=$(this),a=$("*[data-blurb-trigger="+b+"]");if(c.html().toUpperCase().search("LESS")>=0){a.html(" more")}else{a.html(" less")}$("*[data-blurb="+b+"]").toggle(0)});$(document).on("click","*[data-dialoghelp]",function(c){var b=$(this).data("dialoghelp"),a=$("#"+b);a.show();$("#"+b).find(".close").click(function(){a.hide()})});$(document).on("click.enlargeImage","a[data-dpop-image-detail]",function(b){b.preventDefault();var a=this.getAttribute("data-dpop-image-detail");a='<img src="'+a+'" alt="printSizeImage" />';dPop.create(a,{css:"imageDetail",hasMask:true,XButton:true,fixPosition:false})});$(document).on("click.enlargeImageWJCGallery","[data-dpop-image-jcgallery]",function(h){h.preventDefault();if(JCGallery){var d=Juggernaut.mustache,f=tplToJs.mustache,c=$.parseJSON(this.getAttribute("data-dpop-image-jcgallery"));if(!d.hasTpl("structure")){Mustache.compilePartial("JCGallery/partials/topcontrols",f.topcontrols);Mustache.compilePartial("JCGallery/partials/slider",f.slider)}var k=Juggernaut.mustache.load("structure");var a="dPop_image-detail-gallery",j=document.getElementById("dPop_image-detail-gallery");if(!j){j=document.createElement("div");j.id=a;document.body.appendChild(j)}var g="JCGallery-DetailJS";j.innerHTML=k({UI:{JCGallery:{id:g}}});console.log(c);var b={count:1,index:0,slides:[{abstractMetaData:[],connected:null,connectedMeta:[],description:c.description,gallery_title:c.gallery_title,img:c.img,id:c.id,index:0,preloaded_slide:false,showLinkText:true,thumb:c.img,title:c.title,toggleLinkText:"More"}]};var l={isMobile:Juggernaut.client.hasTouch,title:c.gallery_title,interstitial_interval:0,count:b.count,lastSlideIndex:b.slides[b.slides.length-1].index,googleAnalytics:{contentId:c.contentId,galleryType:c.galleryType},contentID:c.contentId,galleryType:c.galleryType};var m=$("#"+g);JCGalleryDetailInt=new JCGallery();JCGalleryDetailInt.init(m,b,l);console.log("gallery data : ",b,"Instance data : ",l);m.find(".pwrSldr").one("pwrSldr_draw",function(){setTimeout(JCGalleryDetailInt.toggleFullscreen,350)});$("a.fullscreen-toggle").one("click",function(){setTimeout(function(){delete JCGalleryDetailInt;j.innerHTML=""},1200)})}else{$(document).off("click.enlargeImageWJCGallery")}});function smoothScroll(f,c){var b=window.pageYOffset;var a=$(f);c=c||{};var k=c.limitDirection||null,e=c.offsetY||0,d=typeof c.duration==="number"?c.duration:500,j=c.callback||function(){},g=c.easing||"swing";var h;if(typeof f==="number"){h=f}else{if(a.offset()){h=a.offset().top+e}else{return true}}h=a.offset().top+e;if(b<h&&k==="top"||b>h&&k==="bottom"){return true}$("html, body").stop().animate({scrollTop:h},d,g,j)}$(document).on("jtap","*[data-scrollto]",function(c){var a=this.getAttribute("data-scrollto"),b={};try{b=JSON.parse(a);a=b.selector;if(Juggernaut.client.hasTouch&&!b.duration){b.duration=0}}catch(c){console.warn(c)}smoothScroll(a,b)});$("div[data-sld]").each(function(){$this=$(this);if(!$this.data("pwrSldr")){$this.addClass("pwrSldr");PwrSldrInstantiator.run()}});Juggernaut.UI.JCAccordion=(function(k){var b=$([]),c=[300,800,2100,5500],g=["_sSize","_mSize","_lSize","_xlSize"];function h(n){for(var m=0;m<c.length;m++){if(n<c[m]){var l=g[m];break}}return l||""}function f(){b=$("[data-jcaccordion]");b.children("dd._expanded").each(function(){var l=$(this).prev("dt");l.addClass("_expanded")});a();j()}function e(l){var n=$(this),q=n.next("dd"),m=h(q[0].scrollHeight);function p(){q.addClass(m);setTimeout(function(){q.addClass("_animable");setTimeout(function(){q.removeClass(g.join(" ")+" _expanded");n.removeClass("_expanded")},50)},50)}function o(){q.one(k,function(){console.log("done");q.removeClass("_animable");q.removeClass(m);q.off(k)});q.addClass("_animable");q.addClass("_expanded "+m);n.addClass("_expanded")}if(q.hasClass("_expanded")||l==="collapse"){p()}else{if(l==="expand"){o()}else{o()}}}function d(){var l;if(!this.nodeName){l=$(document)}else{if(this.nodeName==="dl"){l=$(this)}else{l=$(this).closest("dl")}}$("dd, dt",l).removeClass("_animable _expanded")}function a(){b.children("dt").off("click.jcAccordion")}function j(){b.children("dt").on("click.jcAccordion",function(){e.call(this)})}f();return{_reinit:f,expandCollapse:e,collapseAll:d}})(Juggernaut.evCheck.transitionEnd);Juggernaut.stickyFooter=function(c,h){var a=h.body,e=h.documentElement;var g=function(){return Math.max(a.scrollHeight,a.offsetHeight,e.clientHeight,e.scrollHeight,e.offsetHeight)};var j=function(){return c.innerHeight};var f=function(d){$(d).removeClass("stickyFooter")};var b=function(d){var k=h.getElementById("marvel_bottomnav_ad").parentNode;if(!!d){f(k)}if(g()<=j()){k.className+=" stickyFooter";return true}else{return false}};return{getHeight:g,stickIt:b}}(window,document);Juggernaut.stickyFooter.stickIt();$(window).resize(Juggernaut.utilities.debounce(function(){Juggernaut.stickyFooter.stickIt(true)},500,false));$(document).on("Juggernaut.filter.updatedlist",Juggernaut.utilities.debounce(function(){Juggernaut.stickyFooter.stickIt(true)},300,false));var scrollbind=(function(f){var c={};var b={};var e={inboundsCB:function(){},outboundsCB:function(){},compareBoundsCB:function(){},withinBoundsOf:null};function j(){h()}function a(l,n,m){f(l).each(function(p){var s=f(this),r=s.offset().top-(n.offset||0),q=r>0?r:0;if(n.withinBoundsOf){n.compareObjectHeight=n.withinBoundsOf.outerHeight()||null;n.compareObjectOffsetTop=n.withinBoundsOf.offset().top||null;n.selectorHeight=l.height()||null}var o=f.extend({},e,n);o.elem=s;c[q]=o})}function k(l){var n;for(var m in c){if(c[m].elem.is(l)){n=f.extend({},c[m]);delete c[m]}}delete n.elem;return n}function g(l){var m=k(l);a(l,m)}function h(){d().setScrollBinds()}function d(){return{setScrollBinds:function(){function l(){var m=window,n=m.document;if(m.pageYOffset!=null){return m.pageYOffset}if(document.compatMode=="CSS1Compat"){return n.documentElement.scrollTop}return n.body.scrollTop}f(window).on("scroll.scrollbind",function(){var o=l();for(var m in c){var n=c[m].elem;if(o>parseInt(m)){c[m].inboundsCB(n)}else{if(o<=parseInt(m)){c[m].outboundsCB(n)}}if(o>(c[m].compareObjectOffsetTop+c[m].compareObjectHeight)-c[m].selectorHeight){c[m].compareBoundsCB(n)}}})}}}j();return{bindOffsets:a,deleteOffsets:k,recalculateOffsets:g,_offsets:c}})(jQuery);scrollbind.bindOffsets("*[data-sticky-register]",{inboundsCB:function(a){a.addClass("sticky")},outboundsCB:function(a){a.removeClass("sticky")}});(function(){if(document.getElementById("nav1_0Detect")){return}if(typeof window.janrain!=="object"){window.janrain={}}if(typeof window.janrain.settings!=="object"){window.janrain.settings={}}janrain.settings.tokenUrl=window.marvelJanrainTokenUrl;janrain.settings.type="embed";janrain.settings.appId=window.marvelJanrainAppId;janrain.settings.appUrl=window.marvelJanrainAppUrl;janrain.settings.providers=["facebook","googleplus","twitter","yahoo"];janrain.settings.providersPerPage="6";janrain.settings.format="one row";janrain.settings.actionText="Sign in";janrain.settings.showAttribution=false;janrain.settings.fontColor="#0d0d0d";janrain.settings.fontFamily="TradeGothic,Arial,Helvetica,Lucida Grande,Verdana,sans-serif";janrain.settings.backgroundColor="transparent";janrain.settings.width="236";janrain.settings.borderRadius="0";janrain.settings.borderColor="transparent";janrain.settings.buttonBorderColor="transparent";janrain.settings.buttonBorderRadius="0";janrain.settings.buttonBackgroundStyle="white";janrain.settings.language="en";janrain.settings.linkClass="janrainEngage";function b(){janrain.ready=true}if(document.addEventListener){document.addEventListener("DOMContentLoaded",b,false)}else{window.attachEvent("onload",b)}janrain.ready=true;var c=document.createElement("script");c.type="text/javascript";c.id="janrainAuthWidget";if(document.location.protocol==="https:"){c.src=URLs.rpxWidgetUrlSecure||"https://rpxnow.com/js/lib/marvel-eval/engage.js"}else{c.src=URLs.rpxWidgetUrl||"http://widget-cdn.rpxnow.com/js/lib/marvel-eval/engage.js"}var a=document.getElementsByTagName("script")[0];a.parentNode.insertBefore(c,a)})();(function(q,A){var f=q.navigator.msPointerEnabled,j=(f)?"MSPointerDown":"ontouchstart" in q?"touchstart":"mousedown",s=(f)?"MSPointerMove":"ontouchstart" in q?"touchmove":"mousemove",o=(f)?"MSPointerUp":"ontouchstart" in q?"touchend":"mouseup";(function(H,w){H[w]||(H[w]=function(d){return this.querySelectorAll("."+d)},Element.prototype[w]=H[w])})(document,"getElementsByClassName");!window.addEventListener&&function(J,w,L,I,d,H,K){J[I]=w[I]=L[I]=function(N,M){var O=this;K.unshift([O,N,M,function(P){P.currentTarget=O;P.preventDefault=function(){P.returnValue=false};P.stopPropagation=function(){P.cancelBubble=true};P.target=P.srcElement||O;M.call(O,P)}]);this.attachEvent("on"+N,K[0][3])};J[d]=w[d]=L[d]=function(O,M){for(var P=0,N;N=K[P];++P){if(N[0]==this&&N[1]==O&&N[2]==M){return this.detachEvent("on"+O,K.splice(P,1)[0][3])}}};J[H]=w[H]=L[H]=function(M){return this.fireEvent("on"+M.type,M)}}(Window.prototype,HTMLDocument.prototype,Element.prototype,"addEventListener","removeEventListener","dispatchEvent",[]);if(typeof document!=="undefined"&&!("classList" in document.createElement("a"))){(function(K){var T="classList",O="prototype",H=(K.HTMLElement||K.Element)[O],S=Object,J=String[O].trim||function(){return this.replace(/^\s+|\s+$/g,"")},R=Array[O].indexOf||function(d){var U=0,V=this.length;for(;U<V;U++){if(U in this&&this[U]===d){return U}}return -1},w=function(U,d){this.name=U;this.code=DOMException[U];this.message=d},N=function(d,U){if(U===""){throw new w("SYNTAX_ERR","An invalid or illegal string was specified")}if(/\s/.test(U)){throw new w("INVALID_CHARACTER_ERR","String contains an invalid character")}return R.call(d,U)},Q=function(d){var U=J.call(d.className),V=U?U.split(/\s+/):[],W=0,X=V.length;for(;W<X;W++){this.push(V[W])}this._updateClassName=function(){d.className=this.toString()}},P=Q[O]=[],L=function(){return new Q(this)};w[O]=Error[O];P.item=function(d){return this[d]||null};P.contains=function(d){d+="";return N(this,d)!==-1};P.add=function(d){d+="";if(N(this,d)===-1){this.push(d);this._updateClassName()}};P.remove=function(d){d+="";var U=N(this,d);if(U!==-1){this.splice(U,1);this._updateClassName()}};P.toggle=function(d){d+="";if(N(this,d)===-1){this.add(d)}else{this.remove(d)}};P.toString=function(){return this.join(" ")};if(S.defineProperty){var I={get:L,enumerable:true,configurable:true};try{S.defineProperty(H,T,I)}catch(M){if(M.number===-2146823252){I.enumerable=false;S.defineProperty(H,T,I)}}}else{if(S[O].__defineGetter__){H.__defineGetter__(T,L)}}}(self))}function x(){return z&&E&&b}function D(){return c}var g=A.getElementById("icon-menu"),z=A.getElementById("icon-search"),c=A.querySelectorAll(".icon-account")[0],E=A.getElementById("txtSearch"),G=A.getElementById("marvel_topnav_ul_wrapper"),b=A.getElementById("marvel_topnav_search"),r=A.getElementById("marvel_topnav_ul"),C=A.getElementById("marvel_subnav"),n=A.getElementById("marvel_subnav_li"),m=A.getElementById("marvel_subnav_ul"),v=A.getElementById("marvel_subnav_div"),a=function(){return q.innerHeight+44+"px"},l=false,e;function F(){k();t();y()}function t(){setTimeout(function(){var H=document.querySelectorAll(".marvelWidget_Container"),d=j!="mousedown"?"device_HASTOUCH":"device_NOT_HASTOUCH";for(var w=0;w<H.length;w++){H[w].classList.add(d)}},1000)}function k(){if(A.addEventListener){h().touchBinds()}h().initBinds()}function h(){return{touchBinds:function(){if(g){function w(N){N.preventDefault();N.stopPropagation();g.classList.toggle("active");if(n!==null){n.classList.remove("active");v.classList.remove("active");r.style.display="block"}if(x()){z.classList.remove("active");b.classList.remove("active")}if(G.className=="active"){G.className="";setTimeout(function(){e.destroy();e=undefined;B()},250)}else{G.style.height=a();G.className="active";if(typeof e==="undefined"){setTimeout(function(){e=new iScroll(G);e.on("scrollEndTap",function(){var O=e.e;if(O.target.offsetParent.className.indexOf("dropdown-container")===-1){if(e.e.target.href!==undefined){window.location.href=e.e.target.href;return}if(e.e.target.parentElement.href!==undefined){window.location.href=e.e.target.parentElement.href}}else{O.target.offsetParent.classList.toggle("active");e.refresh()}})},500)}if(x()){z.classList.remove("active");b.classList.remove("active")}if(n){m.classList.remove("active");n.classList.remove("active")}}}g.removeEventListener(j,w,false);g.addEventListener(j,w,false)}if(c&&(j!=="mousedown")){function L(N){N.preventDefault();N.stopPropagation();c.parentNode.parentNode.classList.toggle("active");r.querySelector(".dropdown-container").classList.remove("active")}c.removeEventListener(j,L,false);c.addEventListener(j,L,false)}if(x()){function I(N){N.preventDefault();N.stopPropagation();z.classList.toggle("active");b.classList.toggle("active");if(z.classList.contains("active")){E.focus()}else{E.blur();q.scrollTo(0,1)}g.classList.remove("active");G.classList.remove("active");if(n!==null){n.classList.remove("active");v.classList.remove("active")}if(!l){A.getElementById("marvel_topnav_search").addEventListener(j,function(P){var O=A.createEvent("UIEvent");O.initUIEvent("touchstart",true,true);if(P.target.nodeName==="DIV"){P.preventDefault();P.stopPropagation();z.dispatchEvent(O)}});l=true}}z.removeEventListener(j,I,false);z.addEventListener(j,I,false)}if(C){var M={};function d(O){var N=O.touches?O.touches[0]:O;M={moved:false,startY:N.pageY,dist:0,uloffsetHeight:m.offsetHeight,ulscrollerHeight:m.scrollerHeight,getComputedPosition:H()};O.preventDefault();O.stopPropagation()}function K(P){var N=P.touches?P.touches[0]:P,Q=H(),O;M.dist=N.pageY-M.startY;if(Math.abs(M.dist)>10){M.moved=true}if(Q.height+88<window.innerHeight){return}if(M.dist<0&&Q.height+Q.y<210){return}if(Q.y>9){m.style.top="0px";return}if(M.moved){O=M.getComputedPosition.y+M.dist;if(O>0){return}m.style.top=O+"px"}P.preventDefault();P.stopPropagation()}function J(N){if(M.moved){return false}if(!M.move&&N.target.href!==undefined&&N.target.href.length>0){window.location.href=N.target.href;return}if(!M.move&&N.target.href===""&&N.target.offsetParent.classList.contains("dropdown-container")){N.target.offsetParent.classList.toggle("active");return}n.classList.toggle("active");v.classList.toggle("active");z.classList.remove("active");b.classList.remove("active");g.classList.remove("active");G.classList.remove("active");N.preventDefault();N.stopPropagation()}function H(){var O=window.getComputedStyle(m,null),N,P;P=+O.top.replace(/[^-\d]/g,"");height=parseInt(O.height,10);return{y:P,height:height}}C.addEventListener(j,d,false);C.addEventListener(s,K,false);C.addEventListener(o,J,false)}},initBinds:function(){var d;q.addEventListener("resize",function(){clearTimeout(d);d=setTimeout(function(){if(G){G.style.height=g.className.search("active")>=0?a():0}},500);B()});function w(H){A.getElementById("marvel_topnav_search").classList.toggle("open");A.getElementById("marvel_topnav_search_button").classList.toggle("active");setTimeout(function(){A.getElementById("txtSearch").focus()},500);H.preventDefault();H.stopPropagation();return}if(A.getElementById("marvel_topnav_search_button")){A.getElementById("marvel_topnav_search_button").addEventListener(j,w)}if(A.getElementById("marvel_topnav_search_close")){A.getElementById("marvel_topnav_search_close").addEventListener(j,w)}}}}var u=A.getElementById("janrainListener");if(u){var p=function p(d){d=d||window.event;var H=d.target||d.srcElement;if(H.className.match(/icon-/gi)||H.className.match(/fabebook/gi)||H.innerHTML.match(/facebook/gi)){var J=new Date(),I="",w=1;J.setDate(J.getDate()+w);I=escape(q.location.href)+((w==null)?"":"; expires="+J.toUTCString());A.cookie="socialRefererUrl="+I+";domain=marvel.com;path=/";janrain.engage.signin.triggerFlow.call(this,(H.className.replace("icon-","")||"facebook"));d.preventDefault();d.stopPropagation()}};(j==="touchstart"||j==="MSPointerDown")?u.addEventListener(j,p):u.onclick=p}function B(){if(r){r.parentNode.setAttribute("style","")}}function y(I){var H,d;function w(J){if(window.innerWidth>900&&(j==="touchstart"||j==="MSPointerDown")){if(D()){c.parentNode.parentNode.classList.remove("active")}if(J.target.nodeName.toLowerCase()==="span"&&J.target.offsetParent.classList.contains("btn")){window.location.href=J.target.offsetParent.href;J.preventDefault();J.stopPropagation();return}H=J.target.offsetParent;if(d&&d!==H){d.classList.remove("active")}if(H.className.indexOf("dropdown-container")===-1){if(J.target.href!==undefined){window.location.href=J.target.href;J.preventDefault();J.stopPropagation();return}if(J.target.parentElement.className.indexOf("icon-user")){H.classList.toggle("active");d=H;J.preventDefault();J.stopPropagation();return}}else{H.classList.toggle("active");d=H;J.preventDefault();B()}}}if(G){G.addEventListener(j,w,false)}}F()})(window,document);var _ga=_ga||{};_ga.getSocialActionTrackers_=function(d,a,b,c){return ga("send",{hitType:"social",socialAction:a,socialTarget:b,page:c})};_ga.trackFacebook=function(a){try{if(FB&&FB.Event&&FB.Event.subscribe){FB.Event.subscribe("edge.create",function(c){_ga.getSocialActionTrackers_("facebook","like",c,a)});FB.Event.subscribe("edge.remove",function(c){_ga.getSocialActionTrackers_("facebook","unlike",c,a)});FB.Event.subscribe("message.send",function(c){_ga.getSocialActionTrackers_("facebook","send",c,a)})}}catch(b){}};_ga.trackTwitterHandler_=function(a,d){var c;if(a&&a.type=="tweet"||a.type=="click"){if(a.target.nodeName=="IFRAME"){c=_ga.extractParamFromUri_(a.target.src,"url")}var b=a.type+((a.type=="click")?"-"+a.region:"");ga(_ga.getSocialActionTrackers_("twitter",b,c,d))}};_ga.trackTwitter=function(a){intent_handler=function(b){_ga.trackTwitterHandler_(b,a)};twttr.events.bind("click",intent_handler);twttr.events.bind("tweet",intent_handler)};_ga.extractParamFromUri_=function(b,c){if(!b){return}var a=new RegExp("[\\?&#]"+c+"=([^&#]*)");var d=a.exec(b);if(d!=null){return unescape(d[1])}return};(function(){var a=["iamgroot"];var j="http://i.annihil.us/u/prod/marvel/i/am/groot/";var f=[];var k="71,82,79,79,84";var g=this.document;function l(){e();h()}function e(){var o=g.createElement("div");var m=g.body;var d=!!g.createElement("audio").canPlayType("audio/ogg");var n=d?".ogg":"mp3";var r;o.id="jukebox";for(var p=a.length-1;p>=0;p--){var q=j+a[p]+n;r=g.createElement("audio");r.src=q;r.id="jukebox-"+a[p];r.preload="auto";o.appendChild(r)}m.appendChild(o)}function h(){$(window).on("keydown",b)}function c(m){console.log("I am Groot");var d=g.getElementById("jukebox-"+m)||g.getElementById("jukebox-havenofear");d.load();d.play()}function b(d){f.push(d.keyCode);var m=f.toString();if(m.indexOf(k)>=0){f=[];c(a[Math.floor(Math.random()*a.length)])}else{if(k.indexOf(m)!==0){f=[]}}}l()})();