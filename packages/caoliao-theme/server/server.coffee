less = Npm.require('less')
autoprefixer = Npm.require('less-plugin-autoprefix')
crypto = Npm.require('crypto')

logger = new Logger 'caoliao:theme',
	methods:
		stop_rendering:
			type: 'info'


calculateClientHash = WebAppHashing.calculateClientHash
WebAppHashing.calculateClientHash = (manifest, includeFilter, runtimeConfigOverride) ->
	css = CaoLiao.theme.getCss()

	WebAppInternals.staticFiles['/__cordova/theme.css'] = WebAppInternals.staticFiles['/theme.css'] =
		cacheable: true
		sourceMapUrl: undefined
		type: 'css'
		content: css

	hash = crypto.createHash('sha1').update(css).digest('hex')

	themeManifestItem = _.find manifest, (item) -> return item.path is 'app/theme.css'
	if not themeManifestItem?
		themeManifestItem = {}
		manifest.push themeManifestItem

	themeManifestItem.path = 'app/theme.css'
	themeManifestItem.type = 'css'
	themeManifestItem.cacheable = true
	themeManifestItem.where = 'client'
	themeManifestItem.url = "/theme.css?#{hash}"
	themeManifestItem.size = css.length
	themeManifestItem.hash = hash

	calculateClientHash.call this, manifest, includeFilter, runtimeConfigOverride


CaoLiao.theme = new class
	variables: {}
	packageCallbacks: []
	files: [
		'assets/stylesheets/global/_variables.less'
		'assets/stylesheets/utils/_keyframes.import.less'
		'assets/stylesheets/utils/_lesshat.import.less'
		'assets/stylesheets/utils/_preloader.import.less'
		'assets/stylesheets/utils/_reset.import.less'
		'assets/stylesheets/utils/_chatops.less'
		'assets/stylesheets/base.less'
		'assets/stylesheets/rtl.less'
		'assets/stylesheets/utils/_colors.import.less'
	]

	constructor: ->
		@customCSS = ''

		CaoLiao.settings.add 'css', ''
		CaoLiao.settings.addGroup 'Layout'

		@compileDelayed = _.debounce Meteor.bindEnvironment(@compile.bind(@)), 300

		CaoLiao.settings.onload '*', Meteor.bindEnvironment (key, value, initialLoad) =>
			if key is 'theme-custom-css'
				if value?.trim() isnt ''
					@customCSS = value
			else if /^theme-.+/.test(key) is true
				name = key.replace /^theme-[a-z]+-/, ''
				if @variables[name]?
					@variables[name].value = value
			else
				return

			@compileDelayed()

	compile: ->
		content = [
			@getVariablesAsLess()
		]

		content.push Assets.getText file for file in @files

		for packageCallback in @packageCallbacks
			result = packageCallback()
			if _.isString result
				content.push result

		content.push @customCSS

		content = content.join '\n'

		options =
			compress: true
			plugins: [
				new autoprefixer()
			]

		start = Date.now()
		less.render content, options, (err, data) ->
			logger.stop_rendering Date.now() - start
			if err?
				return console.log err

			CaoLiao.settings.updateById 'css', data.css

			process.emit('message', {refresh: 'client'})

	addVariable: (type, name, value, persist=true) ->
		@variables[name] =
			type: type
			value: value

		if persist is true
			config =
				group: 'Layout'
				type: type
				section: 'Colors'
				public: false

			CaoLiao.settings.add "theme-#{type}-#{name}", value, config

	addPublicColor: (name, value) ->
		@addVariable 'color', name, value, true

	getVariablesAsObject: ->
		obj = {}
		for name, variable of @variables
			obj[name] = variable.value

		return obj

	getVariablesAsLess: ->
		items = []
		for name, variable of @variables
			items.push "@#{name}: #{variable.value};"

		return items.join '\n'

	addPackageAsset: (cb) ->
		@packageCallbacks.push cb
		@compileDelayed()

	getCss: ->
		return CaoLiao.settings.get 'css'
