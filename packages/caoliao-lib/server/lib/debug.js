CaoLiao.debugLevel = 'debug';

Meteor.startup(function() {
	CaoLiao.settings.onload('Debug_Level', function(key, value/*, initialLoad*/) {
		if (value) {
			CaoLiao.debugLevel = value;
		}
	});

	var value = CaoLiao.settings.get('Debug_Level');
	if (value) {
		CaoLiao.debugLevel = value;
	}
});

var wrapMethods = function(name, originalHandler, methodsMap) {
	methodsMap[name] = function() {
		if (CaoLiao.debugLevel === 'debug') {
			var args = name === 'ufsWrite' ? Array.prototype.slice.call(arguments, 1) : arguments;
			console.log('[methods]'.green, name, '-> userId:', Meteor.userId(), ', arguments: ', args);
		}

		return originalHandler.apply(this, arguments);
	};
};

var originalMeteorMethods = Meteor.methods;

Meteor.methods = function(methodMap) {
	_.each(methodMap, function(handler, name) {
		wrapMethods(name, handler, methodMap);
	});
	originalMeteorMethods(methodMap);
};

var originalMeteorPublish = Meteor.publish;

Meteor.publish = function(name, func) {
	return originalMeteorPublish(name, function() {
		if (CaoLiao.debugLevel === 'debug') {
			console.log('[publish]'.green, name, '-> userId:', this.userId, ', arguments: ', arguments);
		}

		return func.apply(this, arguments);
	});
};
