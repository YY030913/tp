/**
 * main.js
 * http://www.codrops.com
 *
 * Licensed under the MIT license.
 * http://www.opensource.org/licenses/mit-license.php
 * 
 * Copyright 2015, Codrops
 * http://www.codrops.com
 */
(function(factory) {
	factory(window.jQuery);
})(function($) {
	"use strict";

	// 定义构造函数
	(function(window, $) {
		if (window.Autocontent) {
			console.log("window.Autocontent");
			return;
		}
		var E = function(elem) {
			var support = {
					transitions: Modernizr.csstransitions
				};
				// transition end event name
			var transEndEventNames = {
					'WebkitTransition': 'webkitTransitionEnd',
					'MozTransition': 'transitionend',
					'OTransition': 'oTransitionEnd',
					'msTransition': 'MSTransitionEnd',
					'transition': 'transitionend'
				};
			var transEndEventName = transEndEventNames[Modernizr.prefixed('transition')];
			var gridEl = document.getElementById('theGrid');
			this.onEndTransition = function(el, callback) {
				var onEndCallbackFn = function(ev) {
					if (support.transitions) {
						if (ev.target != this) return;
						this.removeEventListener(transEndEventName, onEndCallbackFn);
					}
					if (callback && typeof callback === 'function') {
						callback.call(this);
					}
				};
				if (support.transitions) {
					el.addEventListener(transEndEventName, onEndCallbackFn);
				} else {
					onEndCallbackFn();
				}
			};

			this.sidebarEl = document.getElementById('theSidebar');
			this.gridItemsContainer = gridEl.querySelector('section.grid');
			this.contentItemsContainer = gridEl.querySelector('section.content');
			this.gridItems = this.gridItemsContainer.querySelectorAll('.grid__item');
			this.contentItems = this.contentItemsContainer.querySelectorAll('.content__item');
			this.closeCtrl = this.contentItemsContainer.querySelector('.close-button');
			this.current = -1;
			this.lockScroll = false,
				this.xscroll = 0;
			this.yscroll = 0;
			this.isAnimating = false;
			this.menuCtrl = document.getElementById('menu-toggle');
			this.menuCloseCtrl = this.sidebarEl.querySelector('.close-button');

			// ------------------初始化------------------
			this.init();
		};

		E.fn = E.prototype;
		/**
		 * gets the viewport width and height
		 * based on http://responsejs.com/labs/dimensions/
		 */
		E.fn.getViewport = function(axis) {
			var client, inner;
			if (axis === 'x') {
				client = window.document.documentElement['clientWidth'];
				inner = window['innerWidth'];
			} else if (axis === 'y') {
				client = window.document.documentElement['clientHeight'];
				inner = window['innerHeight'];
			}

			return client < inner ? inner : client;
		};
		E.fn.scrollX = function() {
			return window.pageXOffset || window.document.documentElement.scrollLeft;
		};
		E.fn.scrollY = function() {
			return window.pageYOffset || window.document.documentElement.scrollTop;
		};

		E.fn.init = function() {
			this.initEvents();
		};

		E.fn.initEvents = function() {
			[].slice.call(this.gridItems).forEach(function(item, pos) {
				// grid item click event
				item.addEventListener('click', function(ev) {
					ev.preventDefault();
					if (this.isAnimating || this.current === pos) {
						return false;
					}
					this.isAnimating = true;
					// index of this.current item
					this.current = pos;
					// simulate loading time..
					classie.add(item, 'grid__item--loading');
					setTimeout(function() {
						classie.add(item, 'grid__item--animate');
						// reveal/load content after the last element animates out (todo: wait for the last transition to finish)
						setTimeout(function() {
							this.loadContent(item);
						}, 500);
					}, 1000);
				});
			});

			this.closeCtrl.addEventListener('click', function() {
				// hide content
				this.hideContent();
			});

			// keyboard esc - hide content
			document.addEventListener('keydown', function(ev) {
				if (!this.isAnimating && this.current !== -1) {
					var keyCode = ev.keyCode || ev.which;
					if (keyCode === 27) {
						ev.preventDefault();
						if ("activeElement" in document)
							document.activeElement.blur();
						this.hideContent();
					}
				}
			});

			// hamburger menu button (mobile) and close cross
			this.menuCtrl.addEventListener('click', function() {
				if (!classie.has(this.sidebarEl, 'sidebar--open')) {
					classie.add(this.sidebarEl, 'sidebar--open');
				}
			});

			this.menuCloseCtrl.addEventListener('click', function() {
				if (classie.has(this.sidebarEl, 'sidebar--open')) {
					classie.remove(this.sidebarEl, 'sidebar--open');
				}
			});
		};

		E.fn.loadContent = function(item) {
			// add expanding element/placeholder 
			var dummy = document.createElement('div');
			dummy.className = 'placeholder';

			// set the width/heigth and position
			dummy.style.WebkitTransform = 'translate3d(' + (item.offsetLeft - 5) + 'px, ' + (item.offsetTop - 5) + 'px, 0px) scale3d(' + item.offsetWidth / this.gridItemsContainer.offsetWidth + ',' + item.offsetHeight / this.getViewport('y') + ',1)';
			dummy.style.transform = 'translate3d(' + (item.offsetLeft - 5) + 'px, ' + (item.offsetTop - 5) + 'px, 0px) scale3d(' + item.offsetWidth / this.gridItemsContainer.offsetWidth + ',' + item.offsetHeight / this.getViewport('y') + ',1)';

			// add transition class 
			classie.add(dummy, 'placeholder--trans-in');

			// insert it after all the grid items
			this.gridItemsContainer.appendChild(dummy);

			// body overlay
			classie.add(document.body, 'view-single');

			setTimeout(function() {
				// expands the placeholder
				dummy.style.WebkitTransform = 'translate3d(-5px, ' + (this.scrollY() - 5) + 'px, 0px)';
				dummy.style.transform = 'translate3d(-5px, ' + (this.scrollY() - 5) + 'px, 0px)';
				// disallow scroll
				window.addEventListener('scroll', this.noscroll);
			}, 25);

			this.onEndTransition(dummy, function() {
				// add transition class 
				classie.remove(dummy, 'placeholder--trans-in');
				classie.add(dummy, 'placeholder--trans-out');
				// position the content container
				this.contentItemsContainer.style.top = this.scrollY() + 'px';
				// show the main content container
				classie.add(this.contentItemsContainer, 'content--show');
				// show content item:
				classie.add(this.contentItems[this.current], 'content__item--show');
				// show close control
				classie.add(this.closeCtrl, 'close-button--show');
				// sets overflow hidden to the body and allows the switch to the content scroll
				classie.addClass(document.body, 'this.noscroll');

				this.isAnimating = false;
			});
		};

		E.fn.hideContent = function() {
			var gridItem = this.gridItems[this.current],
				contentItem = this.contentItems[this.current];

			classie.remove(contentItem, 'content__item--show');
			classie.remove(this.contentItemsContainer, 'content--show');
			classie.remove(this.closeCtrl, 'close-button--show');
			classie.remove(document.body, 'view-single');

			setTimeout(function() {
				var dummy = this.gridItemsContainer.querySelector('.placeholder');

				classie.removeClass(document.body, 'this.noscroll');

				dummy.style.WebkitTransform = 'translate3d(' + gridItem.offsetLeft + 'px, ' + gridItem.offsetTop + 'px, 0px) scale3d(' + gridItem.offsetWidth / this.gridItemsContainer.offsetWidth + ',' + gridItem.offsetHeight / this.getViewport('y') + ',1)';
				dummy.style.transform = 'translate3d(' + gridItem.offsetLeft + 'px, ' + gridItem.offsetTop + 'px, 0px) scale3d(' + gridItem.offsetWidth / this.gridItemsContainer.offsetWidth + ',' + gridItem.offsetHeight / this.getViewport('y') + ',1)';

				this.onEndTransition(dummy, function() {
					// reset content scroll..
					contentItem.parentNode.scrollTop = 0;
					this.gridItemsContainer.removeChild(dummy);
					classie.remove(gridItem, 'grid__item--loading');
					classie.remove(gridItem, 'grid__item--animate');
					this.lockScroll = false;
					window.removeEventListener('scroll', this.noscroll);
				});

				// reset this.current
				this.current = -1;
			}, 25);
		};

		E.fn.noscroll = function() {
			if (!this.lockScroll) {
				this.lockScroll = true;
				this.xscroll = this.scrollX();
				this.yscroll = this.scrollY();
			}
			window.scrollTo(this.xscroll, this.yscroll);
		};

		// 暴露给全局对象
		window.Autocontent = E;
	})(window, $);


	return window.Autocontent;
});