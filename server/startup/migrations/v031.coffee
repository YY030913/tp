CaoLiao.Migrations.add
	version: 31
	up: ->
		changes =
			API_Analytics: 'GoogleTagManager_id'

		for from, to of changes
			record = CaoLiao.models.Settings.findOne _id: from
			if record?
				delete record._id
				CaoLiao.models.Settings.upsert {_id: to}, record
			CaoLiao.models.Settings.remove _id: from
