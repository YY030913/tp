# Config and Start SyncedCron
logger = new Logger 'SyncedCron'

SyncedCron.config
	logger: (opts) ->
		logger[opts.level].call(logger, opts.message)
	collectionName: 'caoliao_cron_history'

generateStatistics = ->
	statistics = CaoLiao.statistics.save()
	statistics.host = Meteor.absoluteUrl()
	if CaoLiao.settings.get 'Statistics_reporting'
		HTTP.post 'http://caoliao.net.cn/stats',#'https://caoliao/stats',
			data: statistics
	return

Meteor.startup ->
	Meteor.defer ->
		###
		generateStatistics()

		# Generate and save statistics every hour
		SyncedCron.add
			name: 'Generate and save statistics',
			schedule: (parser) -># parser is a later.parse object
				return parser.text 'every 1 hour'
			job: generateStatistics

		SyncedCron.start()
		###
