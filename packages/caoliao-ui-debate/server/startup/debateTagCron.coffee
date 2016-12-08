# Config and Start SyncedCron
logger = new Logger 'SyncedCron'

SyncedCron.config
	logger: (opts) ->
		logger[opts.level].call(logger, opts.message)
	collectionName: 'caoliao_Debate_Tag_Cron_history'

updateDebateTag = ->

	now = new Date
	hourago = new Date(now - 3600000)
	userCount = CaoLiao.models.Users.find().count()
	debates = CaoLiao.models.Debates.findList({
		save: true
	}, {field: {_id: 1, ts: 1, "read.ts": 1, "share.ts":1, "favorite.favoriteAt":1, "favorite.enable": 1}}).fetch()
	for debate in debates
		updateTags = []
		pullTags = []

		newstag = CaoLiao.models.Tags.findOneByNameAndType "News", "o", {fields: { _id: 1 ,name: 1}}

		CaoLiao.models.Debates.pullTag debate._id, {_id: newstag._id, name: newstag.name}
		if (now.getDate() - (new Date(debate.ts)).getDate() < 7)
			CaoLiao.models.Debates.pushTag debate._id, {_id: newstag._id, name: newstag.name}

		readlen = debate.read.length
		readcount = 0
		while readlen > 0
			if debate.read[readlen-1].ts > hourago 
				readcount++
				readlen--
			else
				readlen = 0

		favoritelen = debate.favorite.length
		favoritecount = 0
		while favoritelen > 0 
			if debate.favorite[readlen-1].favoriteAt > hourago and favoriteitem.enable
				favoritecount++
				favoritelen--
			else
				favoritelen = 0

		sharelen = debate.share.length
		sharecount = 0
		while sharelen > 0 
			if debate.share[readlen-1].ts > hourago 
				sharecount++
				sharelen--
			else
				sharelen = 0


		hottag = CaoLiao.models.Tags.findOneByNameAndType "Hot", "o"
		CaoLiao.models.Debates.pullTag debate._id, {_id: hottag._id, name: hottag.name}
		if (readcount / userCount) * CaoLiao.Debate.readWeight + (sharecount / userCount) * CaoLiao.Debate.shareWeight + (favoritecount / userCount) * CaoLiao.Debate.favoriteWeight > 0.5
			CaoLiao.models.Debates.pushTag debate._id,  {_id: hottag._id, name: hottag.name}

	true


Meteor.startup ->
	Meteor.defer ->
		updateDebateTag()

		# Generate and save statistics every hour
		SyncedCron.add
			name: 'update Debate Tag Cron',
			schedule: (parser) -># parser is a later.parse object
				return parser.text 'every 1 hour'
			job: updateDebateTag

		SyncedCron.start()