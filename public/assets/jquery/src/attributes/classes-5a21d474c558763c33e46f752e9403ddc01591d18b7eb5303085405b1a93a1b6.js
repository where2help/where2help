define(["../core","../var/rnotwhite","../var/strundefined","../data/var/data_priv","../core/init"],function(e,t,n,r){var i=/[\t\r\n\f]/g;e.fn.extend({addClass:function(n){var r,a,o,s,u,l,c="string"==typeof n&&n,d=0,f=this.length;if(e.isFunction(n))return this.each(function(t){e(this).addClass(n.call(this,t,this.className))});if(c)for(r=(n||"").match(t)||[];f>d;d++)if(a=this[d],o=1===a.nodeType&&(a.className?(" "+a.className+" ").replace(i," "):" ")){for(u=0;s=r[u++];)o.indexOf(" "+s+" ")<0&&(o+=s+" ");l=e.trim(o),a.className!==l&&(a.className=l)}return this},removeClass:function(n){var r,a,o,s,u,l,c=0===arguments.length||"string"==typeof n&&n,d=0,f=this.length;if(e.isFunction(n))return this.each(function(t){e(this).removeClass(n.call(this,t,this.className))});if(c)for(r=(n||"").match(t)||[];f>d;d++)if(a=this[d],o=1===a.nodeType&&(a.className?(" "+a.className+" ").replace(i," "):"")){for(u=0;s=r[u++];)for(;o.indexOf(" "+s+" ")>=0;)o=o.replace(" "+s+" "," ");l=n?e.trim(o):"",a.className!==l&&(a.className=l)}return this},toggleClass:function(i,a){var o=typeof i;return"boolean"==typeof a&&"string"===o?a?this.addClass(i):this.removeClass(i):e.isFunction(i)?this.each(function(t){e(this).toggleClass(i.call(this,t,this.className,a),a)}):this.each(function(){if("string"===o)for(var a,s=0,u=e(this),l=i.match(t)||[];a=l[s++];)u.hasClass(a)?u.removeClass(a):u.addClass(a);else(o===n||"boolean"===o)&&(this.className&&r.set(this,"__className__",this.className),this.className=this.className||i===!1?"":r.get(this,"__className__")||"")})},hasClass:function(e){for(var t=" "+e+" ",n=0,r=this.length;r>n;n++)if(1===this[n].nodeType&&(" "+this[n].className+" ").replace(i," ").indexOf(t)>=0)return!0;return!1}})});