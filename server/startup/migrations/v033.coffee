CaoLiao.Migrations.add
	version: 33
	up: ->
		scriptAlert = "/**\n * This scrit is out-of-date, convert to the new format\n * (https://github.com/CaoLiao/CaoLiao/wiki/WebHook-Scripting)\n**/\n\n"

		integrations = CaoLiao.models.Integrations.find({
			$or: [
				{script: {$exists: false}, processIncomingRequestScript: {$exists: true}}
				{script: {$exists: false}, prepareOutgoingRequestScript: {$exists: true}}
				{script: {$exists: false}, processOutgoingResponseScript: {$exists: true}}
			]
		}).fetch()


		integrations.forEach (integration) ->
			script = ''
			if integration.processIncomingRequestScript
				script += integration.processIncomingRequestScript + '\n\n'

			if integration.prepareOutgoingRequestScript
				script += integration.prepareOutgoingRequestScript + '\n\n'

			if integration.processOutgoingResponseScript
				script += integration.processOutgoingResponseScript + '\n\n'

			CaoLiao.models.Integrations.update integration._id,
				$set:
					script: scriptAlert + script.replace(/^/gm, '// ')


		update =
			$unset:
				processIncomingRequestScript: 1
				prepareOutgoingRequestScript: 1
				processOutgoingResponseScript: 1

		CaoLiao.models.Integrations.update {}, update, {multi: true}

		update =
			$set:
				enabled: true

		CaoLiao.models.Integrations.update {enabled: {$exists: false}}, update, {multi: true}
