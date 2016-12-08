@parentCall = (method, args = []) ->
	data =
		src: 'caoliao'
		fn: method
		args: args

	window.parent.postMessage data, '*'
