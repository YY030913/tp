/*!
 * clipboard.js v1.5.9
 * https://zenorocha.github.io/clipboard.js
 *
 * Licensed MIT © Zeno Rocha
 */
! function(t) {
	if ("object" == typeof exports && "undefined" != typeof module) module.exports = t();
	else if ("function" == typeof define && define.amd) define([], t);
	else {
		var e;
		e = "undefined" != typeof window ? window : "undefined" != typeof global ? global : "undefined" != typeof self ? self : this, e.Clipboard = t()
	}
}(function() {
	var t, e, n;
	return function t(e, n, o) {
		function r(c, s) {
			if (!n[c]) {
				if (!e[c]) {
					var a = "function" == typeof require && require;
					if (!s && a) return a(c, !0);
					if (i) return i(c, !0);
					var l = new Error("Cannot find module '" + c + "'");
					throw l.code = "MODULE_NOT_FOUND", l
				}
				var u = n[c] = {
					exports: {}
				};
				e[c][0].call(u.exports, function(t) {
					var n = e[c][1][t];
					return r(n ? n : t)
				}, u, u.exports, t, e, n, o)
			}
			return n[c].exports
		}
		for (var i = "function" == typeof require && require, c = 0; c < o.length; c++) r(o[c]);
		return r
	}({
		1: [function(t, e, n) {
			var o = t("matches-selector");
			e.exports = function(t, e, n) {
				for (var r = n ? t : t.parentNode; r && r !== document;) {
					if (o(r, e)) return r;
					r = r.parentNode
				}
			}
		}, {
			"matches-selector": 5
		}],
		2: [function(t, e, n) {
			function o(t, e, n, o, i) {
				var c = r.apply(this, arguments);
				return t.addEventListener(n, c, i), {
					destroy: function() {
						t.removeEventListener(n, c, i)
					}
				}
			}

			function r(t, e, n, o) {
				return function(n) {
					n.delegateTarget = i(n.target, e, !0), n.delegateTarget && o.call(t, n)
				}
			}
			var i = t("closest");
			e.exports = o
		}, {
			closest: 1
		}],
		3: [function(t, e, n) {
			n.node = function(t) {
				return void 0 !== t && t instanceof HTMLElement && 1 === t.nodeType
			}, n.nodeList = function(t) {
				var e = Object.prototype.toString.call(t);
				return void 0 !== t && ("[object NodeList]" === e || "[object HTMLCollection]" === e) && "length" in t && (0 === t.length || n.node(t[0]))
			}, n.string = function(t) {
				return "string" == typeof t || t instanceof String
			}, n.fn = function(t) {
				var e = Object.prototype.toString.call(t);
				return "[object Function]" === e
			}
		}, {}],
		4: [function(t, e, n) {
			function o(t, e, n) {
				if (!t && !e && !n) throw new Error("Missing required arguments");
				if (!s.string(e)) throw new TypeError("Second argument must be a String");
				if (!s.fn(n)) throw new TypeError("Third argument must be a Function");
				if (s.node(t)) return r(t, e, n);
				if (s.nodeList(t)) return i(t, e, n);
				if (s.string(t)) return c(t, e, n);
				throw new TypeError("First argument must be a String, HTMLElement, HTMLCollection, or NodeList")
			}

			function r(t, e, n) {
				return t.addEventListener(e, n), {
					destroy: function() {
						t.removeEventListener(e, n)
					}
				}
			}

			function i(t, e, n) {
				return Array.prototype.forEach.call(t, function(t) {
					t.addEventListener(e, n)
				}), {
					destroy: function() {
						Array.prototype.forEach.call(t, function(t) {
							t.removeEventListener(e, n)
						})
					}
				}
			}

			function c(t, e, n) {
				return a(document.body, t, e, n)
			}
			var s = t("./is"),
				a = t("delegate");
			e.exports = o
		}, {
			"./is": 3,
			delegate: 2
		}],
		5: [function(t, e, n) {
			function o(t, e) {
				if (i) return i.call(t, e);
				for (var n = t.parentNode.querySelectorAll(e), o = 0; o < n.length; ++o)
					if (n[o] == t) return !0;
				return !1
			}
			var r = Element.prototype,
				i = r.matchesSelector || r.webkitMatchesSelector || r.mozMatchesSelector || r.msMatchesSelector || r.oMatchesSelector;
			e.exports = o
		}, {}],
		6: [function(t, e, n) {
			function o(t) {
				var e;
				if ("INPUT" === t.nodeName || "TEXTAREA" === t.nodeName) t.focus(), t.setSelectionRange(0, t.value.length), e = t.value;
				else {
					t.hasAttribute("contenteditable") && t.focus();
					var n = window.getSelection(),
						o = document.createRange();
					o.selectNodeContents(t), n.removeAllRanges(), n.addRange(o), e = n.toString()
				}
				return e
			}
			e.exports = o
		}, {}],
		7: [function(t, e, n) {
			function o() {}
			o.prototype = {
				on: function(t, e, n) {
					var o = this.e || (this.e = {});
					return (o[t] || (o[t] = [])).push({
						fn: e,
						ctx: n
					}), this
				},
				once: function(t, e, n) {
					function o() {
						r.off(t, o), e.apply(n, arguments)
					}
					var r = this;
					return o._ = e, this.on(t, o, n)
				},
				emit: function(t) {
					var e = [].slice.call(arguments, 1),
						n = ((this.e || (this.e = {}))[t] || []).slice(),
						o = 0,
						r = n.length;
					for (o; r > o; o++) n[o].fn.apply(n[o].ctx, e);
					return this
				},
				off: function(t, e) {
					var n = this.e || (this.e = {}),
						o = n[t],
						r = [];
					if (o && e)
						for (var i = 0, c = o.length; c > i; i++) o[i].fn !== e && o[i].fn._ !== e && r.push(o[i]);
					return r.length ? n[t] = r : delete n[t], this
				}
			}, e.exports = o
		}, {}],
		8: [function(e, n, o) {
			! function(r, i) {
				if ("function" == typeof t && t.amd) t(["module", "select"], i);
				else if ("undefined" != typeof o) i(n, e("select"));
				else {
					var c = {
						exports: {}
					};
					i(c, r.select), r.clipboardAction = c.exports
				}
			}(this, function(t, e) {
				"use strict";

				function n(t) {
					return t && t.__esModule ? t : {
						"default": t
					}
				}

				function o(t, e) {
					if (!(t instanceof e)) throw new TypeError("Cannot call a class as a function")
				}
				var r = n(e),
					i = "function" == typeof Symbol && "symbol" == typeof Symbol.iterator ? function(t) {
						return typeof t
					} : function(t) {
						return t && "function" == typeof Symbol && t.constructor === Symbol ? "symbol" : typeof t
					},
					c = function() {
						function t(t, e) {
							for (var n = 0; n < e.length; n++) {
								var o = e[n];
								o.enumerable = o.enumerable || !1, o.configurable = !0, "value" in o && (o.writable = !0), Object.defineProperty(t, o.key, o)
							}
						}
						return function(e, n, o) {
							return n && t(e.prototype, n), o && t(e, o), e
						}
					}(),
					s = function() {
						function t(e) {
							o(this, t), this.resolveOptions(e), this.initSelection()
						}
						return t.prototype.resolveOptions = function t() {
							var e = arguments.length <= 0 || void 0 === arguments[0] ? {} : arguments[0];
							this.action = e.action, this.emitter = e.emitter, this.target = e.target, this.text = e.text, this.trigger = e.trigger, this.selectedText = ""
						}, t.prototype.initSelection = function t() {
							if (this.text && this.target) throw new Error('Multiple attributes declared, use either "target" or "text"');
							if (this.text) this.selectFake();
							else {
								if (!this.target) throw new Error('Missing required attributes, use either "target" or "text"');
								this.selectTarget()
							}
						}, t.prototype.selectFake = function t() {
							var e = this,
								n = "rtl" == document.documentElement.getAttribute("dir");
							this.removeFake(), this.fakeHandler = document.body.addEventListener("click", function() {
								return e.removeFake()
							}), this.fakeElem = document.createElement("textarea"), this.fakeElem.style.fontSize = "12pt", this.fakeElem.style.border = "0", this.fakeElem.style.padding = "0", this.fakeElem.style.margin = "0", this.fakeElem.style.position = "fixed", this.fakeElem.style[n ? "right" : "left"] = "-9999px", this.fakeElem.style.top = (window.pageYOffset || document.documentElement.scrollTop) + "px", this.fakeElem.setAttribute("readonly", ""), this.fakeElem.value = this.text, document.body.appendChild(this.fakeElem), this.selectedText = (0, r.default)(this.fakeElem), this.copyText()
						}, t.prototype.removeFake = function t() {
							this.fakeHandler && (document.body.removeEventListener("click"), this.fakeHandler = null), this.fakeElem && (document.body.removeChild(this.fakeElem), this.fakeElem = null)
						}, t.prototype.selectTarget = function t() {
							this.selectedText = (0, r.default)(this.target), this.copyText()
						}, t.prototype.copyText = function t() {
							var e = void 0;
							try {
								e = document.execCommand(this.action)
							} catch (n) {
								e = !1
							}
							this.handleResult(e)
						}, t.prototype.handleResult = function t(e) {
							e ? this.emitter.emit("success", {
								action: this.action,
								text: this.selectedText,
								trigger: this.trigger,
								clearSelection: this.clearSelection.bind(this)
							}) : this.emitter.emit("error", {
								action: this.action,
								trigger: this.trigger,
								clearSelection: this.clearSelection.bind(this)
							})
						}, t.prototype.clearSelection = function t() {
							this.target && this.target.blur(), window.getSelection().removeAllRanges()
						}, t.prototype.destroy = function t() {
							this.removeFake()
						}, c(t, [{
							key: "action",
							set: function t() {
								var e = arguments.length <= 0 || void 0 === arguments[0] ? "copy" : arguments[0];
								if (this._action = e, "copy" !== this._action && "cut" !== this._action) throw new Error('Invalid "action" value, use either "copy" or "cut"')
							},
							get: function t() {
								return this._action
							}
						}, {
							key: "target",
							set: function t(e) {
								if (void 0 !== e) {
									if (!e || "object" !== ("undefined" == typeof e ? "undefined" : i(e)) || 1 !== e.nodeType) throw new Error('Invalid "target" value, use a valid Element');
									this._target = e
								}
							},
							get: function t() {
								return this._target
							}
						}]), t
					}();
				t.exports = s
			})
		}, {
			select: 6
		}],
		9: [function(e, n, o) {
			! function(r, i) {
				if ("function" == typeof t && t.amd) t(["module", "./clipboard-action", "tiny-emitter", "good-listener"], i);
				else if ("undefined" != typeof o) i(n, e("./clipboard-action"), e("tiny-emitter"), e("good-listener"));
				else {
					var c = {
						exports: {}
					};
					i(c, r.clipboardAction, r.tinyEmitter, r.goodListener), r.clipboard = c.exports
				}
			}(this, function(t, e, n, o) {
				"use strict";

				function r(t) {
					return t && t.__esModule ? t : {
						"default": t
					}
				}

				function i(t, e) {
					if (!(t instanceof e)) throw new TypeError("Cannot call a class as a function")
				}

				function c(t, e) {
					if (!t) throw new ReferenceError("this hasn't been initialised - super() hasn't been called");
					return !e || "object" != typeof e && "function" != typeof e ? t : e
				}

				function s(t, e) {
					if ("function" != typeof e && null !== e) throw new TypeError("Super expression must either be null or a function, not " + typeof e);
					t.prototype = Object.create(e && e.prototype, {
						constructor: {
							value: t,
							enumerable: !1,
							writable: !0,
							configurable: !0
						}
					}), e && (Object.setPrototypeOf ? Object.setPrototypeOf(t, e) : t.__proto__ = e)
				}

				function a(t, e) {
					var n = "data-clipboard-" + t;
					if (e.hasAttribute(n)) return e.getAttribute(n)
				}
				var l = r(e),
					u = r(n),
					f = r(o),
					d = function(t) {
						function e(n, o) {
							i(this, e);
							var r = c(this, t.call(this));
							return r.resolveOptions(o), r.listenClick(n), r
						}
						return s(e, t), e.prototype.resolveOptions = function t() {
							var e = arguments.length <= 0 || void 0 === arguments[0] ? {} : arguments[0];
							this.action = "function" == typeof e.action ? e.action : this.defaultAction, this.target = "function" == typeof e.target ? e.target : this.defaultTarget, this.text = "function" == typeof e.text ? e.text : this.defaultText
						}, e.prototype.listenClick = function t(e) {
							var n = this;
							this.listener = (0, f.default)(e, "click", function(t) {
								return n.onClick(t)
							})
						}, e.prototype.onClick = function t(e) {
							var n = e.delegateTarget || e.currentTarget;
							this.clipboardAction && (this.clipboardAction = null), this.clipboardAction = new l.default({
								action: this.action(n),
								target: this.target(n),
								text: this.text(n),
								trigger: n,
								emitter: this
							})
						}, e.prototype.defaultAction = function t(e) {
							return a("action", e)
						}, e.prototype.defaultTarget = function t(e) {
							var n = a("target", e);
							return n ? document.querySelector(n) : void 0
						}, e.prototype.defaultText = function t(e) {
							return a("text", e)
						}, e.prototype.destroy = function t() {
							this.listener.destroy(), this.clipboardAction && (this.clipboardAction.destroy(), this.clipboardAction = null)
						}, e
					}(u.default);
				t.exports = d
			})
		}, {
			"./clipboard-action": 8,
			"good-listener": 4,
			"tiny-emitter": 7
		}]
	}, {}, [9])(9)
});