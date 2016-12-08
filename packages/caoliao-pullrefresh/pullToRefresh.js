window.refresher = {};
refresher.info = {
	"pullDownLable": "下拉刷新",
	"pullingDownLable": "释放立即刷新",
	"pullUpLable": "上拉加载更多",
	"pullingUpLable": "释放加载更多",
	"loadingLable": "加载中..."
};
refresher.init = function(parameter) {
	if (parameter.pullDownLable) {
		this.info.pullDownLable = parameter.pullDownLable
	}
	if (parameter.pullingDownLable) {
		this.info.pullingDownLable = parameter.pullingDownLable
	}
	if (parameter.pullUpLable) {
		this.info.pullUpLable = parameter.pullUpLable
	}
	if (parameter.pullingUpLable) {
		this.info.pullingUpLable = parameter.pullingUpLable
	}
	if (parameter.loadingLable) {
		this.info.loadingLable = parameter.loadingLable
	}
	
	var wrapper = document.getElementById(parameter.id);
	var div = document.createElement("div");
	div.className = "scroller";
	wrapper.appendChild(div);
	var scroller = wrapper.querySelector(".scroller");
	console.log("#" + parameter.id + " " + parameter.insertBeforeElem);
	
	var list = wrapper.querySelector("#" + parameter.id + " " + parameter.insertBeforeElem);
	scroller.insertBefore(list, scroller.childNodes[0]);
	var pullDown = document.createElement("div");
	pullDown.className = "pullDown";
	var loader = document.createElement("div");
	loader.className = "pullDownIcon";
	pullDown.appendChild(loader);
	var pullDownLabel = document.createElement("div");
	pullDownLabel.className = "pullDownLabel";
	pullDown.appendChild(pullDownLabel);
	scroller.insertBefore(pullDown, scroller.childNodes[0]);
	var pullUp = document.createElement("div");
	pullUp.className = "pullUp";
	var loader = document.createElement("div");
	loader.className = "pullUpIcon";
	pullUp.appendChild(loader);
	var pullUpLabel = document.createElement("div");
	pullUpLabel.className = "pullUpLabel";
	var content = document.createTextNode(refresher.info.pullUpLable);
	pullUpLabel.appendChild(content);
	pullUp.appendChild(pullUpLabel);
	scroller.appendChild(pullUp);
	var pullDownEle = wrapper.querySelector(".pullDown");
	var pullDownOffset = pullDownEle.offsetHeight;
	var pullUpEle = wrapper.querySelector(".pullUp");
	var pullUpOffset = pullUpEle.offsetHeight;
	
	this.scrollIt(parameter, pullDownEle, pullDownOffset, pullUpEle, pullUpOffset);
};
refresher.scrollIt = function(parameter, pullDownEle, pullDownOffset, pullUpEle, pullUpOffset) {
	eval(
	parameter.id + "= new iScroll(\
								parameter.id,\
								 {\
									 useTransition: true,\
									 vScrollbar: false,\
									 topOffset: pullDownOffset,\
									 onRefresh: function () {\
													  refresher.onRelease(pullDownEle,pullUpEle);\
																	 },\
									onScrollMove: function () {\
													     refresher.onScrolling(this,pullDownEle,pullUpEle,pullUpOffset);\
																	},\
									onScrollEnd: function () {\
												       refresher.onScrollEnd(pullDownEle,parameter.pullDownAction,pullUpEle,parameter.pullUpAction);\
																	}\
									})"
				);
};
refresher.onScrolling = function(e, pullDownEle, pullUpEle, pullUpOffset) {
	if (e.y > -(pullUpOffset)&&!pullDownEle.className.match('loading')) {
		pullDownEle.classList.remove("flip");
		pullDownEle.querySelector('.pullDownLabel').innerHTML = refresher.info.pullDownLable;
		pullDownEle.querySelector('.pullDownIcon').style.display = "block";
		e.minScrollY = -pullUpOffset;
	}
	if (e.scrollerH < e.wrapperH &&e.y>e.maxScrollY-pullUpOffset&&pullUpEle.className.match("flip") || e.scrollerH > e.wrapperH &&e.y>e.maxScrollY-pullUpOffset&&pullUpEle.className.match("flip") ) {
		pullUpEle.classList.remove("flip");
		pullUpEle.querySelector('.pullUpLabel').innerHTML = refresher.info.pullUpLable;
	}		
	if (e.y > 0&&!pullUpEle.className.match('loading')&&!pullDownEle.className.match('loading')) {
		pullDownEle.classList.add("flip");
		pullDownEle.querySelector('.pullDownLabel').innerHTML = refresher.info.pullingDownLable;
		e.minScrollY = 0;
	}
	if (e.scrollerH < e.wrapperH && e.y < (e.minScrollY - pullUpOffset) &&!pullDownEle.className.match('loading')&&!pullUpEle.className.match('loading')|| e.scrollerH > e.wrapperH && e.y < (e.maxScrollY - pullUpOffset)&&!pullDownEle.className.match('loading')&&!pullUpEle.className.match('loading')) {
		pullUpEle.classList.add("flip");
		pullUpEle.querySelector('.pullUpLabel').innerHTML = refresher.info.pullingUpLable;
	}

};
refresher.onRelease = function(pullDownEle, pullUpEle) {
	if (pullDownEle.className.match('loading')) {
		pullDownEle.classList.toggle("loading");
		pullDownEle.querySelector('.pullDownLabel').innerHTML = refresher.info.pullDownLable;
	}
	if (pullUpEle.className.match('loading')) {
		pullUpEle.classList.toggle("loading");
		pullUpEle.querySelector('.pullUpLabel').innerHTML = refresher.info.pullUpLable;
	}
};
refresher.onScrollEnd = function(pullDownEle, pullDownAction, pullUpEle, pullUpAction) {
	if (pullDownEle.className.match('flip')&&!pullDownEle.className.match('loading')) {
		pullDownEle.classList.add("loading");
		pullDownEle.classList.remove("flip");
		pullDownEle.querySelector('.pullDownLabel').innerHTML = refresher.info.loadingLable;
		if (pullDownAction) pullDownAction();	
	}
	if (pullUpEle.className.match('flip')&&!pullUpEle.className.match('loading')) {
		pullUpEle.classList.add("loading");
		pullUpEle.classList.remove("flip");
		pullUpEle.querySelector('.pullUpLabel').innerHTML = refresher.info.loadingLable;
		if (pullUpAction) pullUpAction();
	}
};