# https://github.com/TelescopeJS/Telescope/blob/master/packages/telescope-lib/lib/callbacks.js

###
# Callback hooks provide an easy way to add extra steps to common operations.
# @namespace CaoLiao.promises
###
CaoLiao.promises = {}

###
# Callback priorities
###
CaoLiao.promises.priority =
	HIGH: -1000
	MEDIUM: 0
	LOW: 1000

###
# Add a callback function to a hook
# @param {String} hook - The name of the hook
# @param {Function} callback - The callback function
###

CaoLiao.promises.add = (hook, callback, priority, id) ->
	# if callback array doesn't exist yet, initialize it
	priority ?= CaoLiao.promises.priority.MEDIUM
	unless _.isNumber priority
		priority = CaoLiao.promises.priority.MEDIUM
	callback.priority = priority
	callback.id = id or Random.id()
	CaoLiao.promises[hook] ?= []

	# Avoid adding the same callback twice
	for cb in CaoLiao.promises[hook]
		if cb.id is callback.id
			return

	CaoLiao.promises[hook].push callback
	return

###
# Remove a callback from a hook
# @param {string} hook - The name of the hook
# @param {string} id - The callback's id
###

CaoLiao.promises.remove = (hookName, id) ->
	CaoLiao.promises[hookName] = _.reject CaoLiao.promises[hookName], (callback) ->
		callback.id is id
	return

###
# Successively run all of a hook's callbacks on an item
# @param {String} hook - The name of the hook
# @param {Object} item - The post, comment, modifier, etc. on which to run the callbacks
# @param {Object} [constant] - An optional constant that will be passed along to each callback
# @returns {Object} Returns the item after it's been through all the callbacks for this hook
###

CaoLiao.promises.run = (hook, item, constant) ->
	callbacks = CaoLiao.promises[hook]
	if !!callbacks?.length
		# if the hook exists, and contains callbacks to run
		callbacks = _.sortBy(callbacks, (callback) -> return callback.priority or CaoLiao.promises.priority.MEDIUM)
		return callbacks.reduce (previousPromise, callback) ->
			return new Promise (resolve, reject) ->
				previousPromise.then (result) ->
					callback(result, constant).then(resolve, reject)
		, Promise.resolve(item)
	else
		# else, just return the item unchanged
		return Promise.resolve(item)

###
# Successively run all of a hook's callbacks on an item, in async mode (only works on server)
# @param {String} hook - The name of the hook
# @param {Object} item - The post, comment, modifier, etc. on which to run the callbacks
# @param {Object} [constant] - An optional constant that will be passed along to each callback
###

CaoLiao.promises.runAsync = (hook, item, constant) ->
	callbacks = CaoLiao.promises[hook]
	if Meteor.isServer and !!callbacks?.length
		# use defer to avoid holding up client
		Meteor.defer ->
			# run all post submit server callbacks on post object successively
			_.sortBy(callbacks, (callback) -> return callback.priority or CaoLiao.promises.priority.MEDIUM).forEach (callback) ->
				# console.log(callback.name);
				callback item, constant
				return
			return
	else
		return item
	return
