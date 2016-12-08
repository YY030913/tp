###
# CaoLiao.settings holds all packages settings
# @namespace CaoLiao.settings
###
CaoLiao.settings =
	callbacks: {}
	ts: new Date

	get: (_id) ->
		return Meteor.settings?[_id]

	get: (_id, callback) ->
		if callback?
			CaoLiao.settings.onload _id, callback
			if Meteor.settings?[_id]?
				callback _id, Meteor.settings?[_id]
		else
			return Meteor.settings?[_id]

	set: (_id, value, callback) ->
		Meteor.call 'saveSetting', _id, value, callback

	batchSet: (settings, callback) ->

		# async -> sync
		# http://daemon.co.za/2012/04/simple-async-with-only-underscore/

		save = (setting) ->
			return (callback) ->
				Meteor.call 'saveSetting', setting._id, setting.value, callback

		actions = _.map settings, (setting) -> save(setting)
		_(actions).reduceRight(_.wrap, (err, success) -> return callback err, success)()

	load: (key, value, initialLoad) ->
		if CaoLiao.settings.callbacks[key]?
			for callback in CaoLiao.settings.callbacks[key]
				callback key, value, initialLoad

		if CaoLiao.settings.callbacks['*']?
			for callback in CaoLiao.settings.callbacks['*']
				callback key, value, initialLoad


	onload: (key, callback) ->
		# if key is '*'
		# 	for key, value in Meteor.settings
		# 		callback key, value, false
		# else if Meteor.settings?[_id]?
		# 	callback key, Meteor.settings[_id], false

		keys = [].concat key

		for k in keys
			CaoLiao.settings.callbacks[k] ?= []
			CaoLiao.settings.callbacks[k].push callback
