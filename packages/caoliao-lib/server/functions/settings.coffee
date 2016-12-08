blockedSettings = {}
process.env.SETTINGS_BLOCKED?.split(',').forEach (settingId) ->
	blockedSettings[settingId] = 1

hiddenSettings = {}
process.env.SETTINGS_HIDDEN?.split(',').forEach (settingId) ->
	hiddenSettings[settingId] = 1

CaoLiao.settings._sorter = 0

###
# Add a setting
# @param {String} _id
# @param {Mixed} value
# @param {Object} setting
###
CaoLiao.settings.add = (_id, value, options = {}) ->
	# console.log '[functions] CaoLiao.settings.add -> '.green, 'arguments:', arguments

	if not _id or not value?
		return false

	options.packageValue = value
	options.valueSource = 'packageValue'
	options.ts = new Date
	options.hidden = false
	options.blocked = options.blocked || false
	options.sorter ?= CaoLiao.settings._sorter++

	if options.enableQuery?
		options.enableQuery = JSON.stringify options.enableQuery

	if options.i18nDefaultQuery?
		options.i18nDefaultQuery = JSON.stringify options.i18nDefaultQuery

	if process?.env?[_id]?
		value = process.env[_id]
		if value.toLowerCase() is "true"
			value = true
		else if value.toLowerCase() is "false"
			value = false
		options.processEnvValue = value
		options.valueSource = 'processEnvValue'

	else if Meteor.settings?[_id]?
		value = Meteor.settings[_id]
		options.meteorSettingsValue = value
		options.valueSource = 'meteorSettingsValue'

	if not options.i18nLabel?
		options.i18nLabel = _id

	# Default description i18n key will be the setting name + "_Description" (eg: LDAP_Enable -> LDAP_Enable_Description)
	if not options.i18nDescription?
		options.i18nDescription = "#{_id}_Description"

	if blockedSettings[_id]?
		options.blocked = true

	if hiddenSettings[_id]?
		options.hidden = true

	if process?.env?['OVERWRITE_SETTING_' + _id]?
		value = process.env['OVERWRITE_SETTING_' + _id]
		if value.toLowerCase() is "true"
			value = true
		else if value.toLowerCase() is "false"
			value = false
		options.value = value
		options.processEnvValue = value
		options.valueSource = 'processEnvValue'

	updateOperations =
		$set: options
		$setOnInsert:
			createdAt: new Date

	if not options.value?
		if options.force is true
			updateOperations.$set.value = options.packageValue
		else
			updateOperations.$setOnInsert.value = value

	if not options.section?
		updateOperations.$unset = { section: 1 }

	return CaoLiao.models.Settings.upsert { _id: _id }, updateOperations



###
# Add a setting group
# @param {String} _id
###
CaoLiao.settings.addGroup = (_id, options = {}, cb) ->
	# console.log '[functions] CaoLiao.settings.addGroup -> '.green, 'arguments:', arguments

	if not _id
		return false

	if _.isFunction(options)
		cb = options
		options = {}

	if not options.i18nLabel?
		options.i18nLabel = _id

	if not options.i18nDescription?
		options.i18nDescription = "#{_id}_Description"

	options.ts = new Date
	options.blocked = false
	options.hidden = false

	if blockedSettings[_id]?
		options.blocked = true

	if hiddenSettings[_id]?
		options.hidden = true

	CaoLiao.models.Settings.upsert { _id: _id },
		$set: options
		$setOnInsert:
			type: 'group'
			createdAt: new Date

	if cb?
		cb.call
			add: (id, value, options = {}) ->
				options.group = _id
				CaoLiao.settings.add id, value, options

			section: (section, cb) ->
				cb.call
					add: (id, value, options = {}) ->
						options.group = _id
						options.section = section
						CaoLiao.settings.add id, value, options

	return


###
# Remove a setting by id
# @param {String} _id
###
CaoLiao.settings.removeById = (_id) ->
	# console.log '[functions] CaoLiao.settings.add -> '.green, 'arguments:', arguments

	if not _id
		return false

	return CaoLiao.models.Settings.removeById _id


###
# Update a setting by id
# @param {String} _id
###
CaoLiao.settings.updateById = (_id, value) ->
	# console.log '[functions] CaoLiao.settings.updateById -> '.green, 'arguments:', arguments

	if not _id or not value?
		return false

	value._updatedAt = new Date

	return CaoLiao.models.Settings.updateValueById _id, value


###
# Update options of a setting by id
# @param {String} _id
###
CaoLiao.settings.updateOptionsById = (_id, options) ->
	# console.log '[functions] CaoLiao.settings.updateOptionsById -> '.green, 'arguments:', arguments

	if not _id or not options?
		return false

	return CaoLiao.models.Settings.updateOptionsById _id, options


###
# Update a setting by id
# @param {String} _id
###
CaoLiao.settings.clearById = (_id) ->
	# console.log '[functions] CaoLiao.settings.clearById -> '.green, 'arguments:', arguments

	if not _id?
		return false

	return CaoLiao.models.Settings.updateValueById _id, undefined


###
# Update a setting by id
###
CaoLiao.settings.init = ->
	initialLoad = true
	CaoLiao.models.Settings.find().observe
		added: (record) ->
			Meteor.settings[record._id] = record.value
			if record.env is true
				process.env[record._id] = record.value
			CaoLiao.settings.load record._id, record.value, initialLoad
		changed: (record) ->
			Meteor.settings[record._id] = record.value
			if record.env is true
				process.env[record._id] = record.value
			CaoLiao.settings.load record._id, record.value, initialLoad
		removed: (record) ->
			delete Meteor.settings[record._id]
			if record.env is true
				delete process.env[record._id]
			CaoLiao.settings.load record._id, undefined, initialLoad
	initialLoad = false
