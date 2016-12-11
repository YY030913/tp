! function(a) {
	"use strict";

	function b(a) {
		return null !== a && a === a.window
	}

	function c(a) {
		return b(a) ? a : 9 === a.nodeType && a.defaultView
	}

	function d(a) {
		var b, d, e = {
				top: 0,
				left: 0
			},
			f = a && a.ownerDocument;
		return b = f.documentElement, "undefined" != typeof a.getBoundingClientRect && (e = a.getBoundingClientRect()), d = c(f), {
			top: e.top + d.pageYOffset - b.clientTop,
			left: e.left + d.pageXOffset - b.clientLeft
		}
	}

	function e(a) {
		var b = "";
		for (var c in a) a.hasOwnProperty(c) && (b += c + ":" + a[c] + ";");
		return b
	}

	function f(a) {
		if (k.allowEvent(a) === !1) return null;
		for (var b = null, c = a.target || a.srcElement; null !== c.parentElement;) {
			if (!(c instanceof SVGElement || -1 === c.className.indexOf("waves-effect"))) {
				b = c;
				break
			}
			if (c.classList.contains("waves-effect")) {
				b = c;
				break
			}
			c = c.parentElement
		}
		return b
	}

	function g(b) {
		var c = f(b);
		null !== c && (j.show(b, c), "ontouchstart" in a && (c.addEventListener("touchend", j.hide, !1), c.addEventListener("touchcancel", j.hide, !1)), c.addEventListener("mouseup", j.hide, !1), c.addEventListener("mouseleave", j.hide, !1))
	}
	var h = h || {},
		i = document.querySelectorAll.bind(document),
		j = {
			duration: 750,
			show: function(a, b) {
				if (2 === a.button) return !1;
				var c = b || this,
					f = document.createElement("div");
				f.className = "waves-ripple", c.appendChild(f);
				var g = d(c),
					h = a.pageY - g.top,
					i = a.pageX - g.left,
					k = "scale(" + c.clientWidth / 100 * 10 + ")";
				"touches" in a && (h = a.touches[0].pageY - g.top, i = a.touches[0].pageX - g.left), f.setAttribute("data-hold", Date.now()), f.setAttribute("data-scale", k), f.setAttribute("data-x", i), f.setAttribute("data-y", h);
				var l = {
					top: h + "px",
					left: i + "px"
				};
				f.className = f.className + " waves-notransition", f.setAttribute("style", e(l)), f.className = f.className.replace("waves-notransition", ""), l["-webkit-transform"] = k, l["-moz-transform"] = k, l["-ms-transform"] = k, l["-o-transform"] = k, l.transform = k, l.opacity = "1", l["-webkit-transition-duration"] = j.duration + "ms", l["-moz-transition-duration"] = j.duration + "ms", l["-o-transition-duration"] = j.duration + "ms", l["transition-duration"] = j.duration + "ms", l["-webkit-transition-timing-function"] = "cubic-bezier(0.250, 0.460, 0.450, 0.940)", l["-moz-transition-timing-function"] = "cubic-bezier(0.250, 0.460, 0.450, 0.940)", l["-o-transition-timing-function"] = "cubic-bezier(0.250, 0.460, 0.450, 0.940)", l["transition-timing-function"] = "cubic-bezier(0.250, 0.460, 0.450, 0.940)", f.setAttribute("style", e(l))
			},
			hide: function(a) {
				k.touchup(a);
				var b = this,
					c = (1.4 * b.clientWidth, null),
					d = b.getElementsByClassName("waves-ripple");
				if (!(d.length > 0)) return !1;
				c = d[d.length - 1];
				var f = c.getAttribute("data-x"),
					g = c.getAttribute("data-y"),
					h = c.getAttribute("data-scale"),
					i = Date.now() - Number(c.getAttribute("data-hold")),
					l = 350 - i;
				0 > l && (l = 0), setTimeout(function() {
					var a = {
						top: g + "px",
						left: f + "px",
						opacity: "0",
						"-webkit-transition-duration": j.duration + "ms",
						"-moz-transition-duration": j.duration + "ms",
						"-o-transition-duration": j.duration + "ms",
						"transition-duration": j.duration + "ms",
						"-webkit-transform": h,
						"-moz-transform": h,
						"-ms-transform": h,
						"-o-transform": h,
						transform: h
					};
					c.setAttribute("style", e(a)), setTimeout(function() {
						try {
							b.removeChild(c)
						} catch (a) {
							return !1
						}
					}, j.duration)
				}, l)
			},
			wrapInput: function(a) {
				for (var b = 0; b < a.length; b++) {
					var c = a[b];
					if ("input" === c.tagName.toLowerCase()) {
						var d = c.parentNode;
						if ("i" === d.tagName.toLowerCase() && -1 !== d.className.indexOf("waves-effect")) continue;
						var e = document.createElement("i");
						e.className = c.className + " waves-input-wrapper";
						var f = c.getAttribute("style");
						f || (f = ""), e.setAttribute("style", f), c.className = "waves-button-input", c.removeAttribute("style"), d.replaceChild(e, c), e.appendChild(c)
					}
				}
			}
		},
		k = {
			touches: 0,
			allowEvent: function(a) {
				var b = !0;
				return "touchstart" === a.type ? k.touches += 1 : "touchend" === a.type || "touchcancel" === a.type ? setTimeout(function() {
					k.touches > 0 && (k.touches -= 1)
				}, 500) : "mousedown" === a.type && k.touches > 0 && (b = !1), b
			},
			touchup: function(a) {
				k.allowEvent(a)
			}
		};
	h.displayEffect = function(b) {
		b = b || {}, "duration" in b && (j.duration = b.duration), j.wrapInput(i(".waves-effect")), "ontouchstart" in a && document.body.addEventListener("touchstart", g, !1), document.body.addEventListener("mousedown", g, !1)
	}, h.attach = function(b) {
		"input" === b.tagName.toLowerCase() && (j.wrapInput([b]), b = b.parentElement), "ontouchstart" in a && b.addEventListener("touchstart", g, !1), b.addEventListener("mousedown", g, !1)
	}, 
	a.Waves = h, document.addEventListener("DOMContentLoaded", function() {
		h.displayEffect()
	}, !1)
}(window);

Meteor.startup(function() {
	window.Waves.displayEffect();
});