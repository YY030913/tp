CaoLiao.Migrations.add
	version: 14
	up: ->
		# Remove unused settings
		CaoLiao.models.Settings.remove { _id: "API_Piwik_URL" }
		CaoLiao.models.Settings.remove { _id: "API_Piwik_ID" }

		CaoLiao.models.Settings.remove { _id: "Message_Edit" }
		CaoLiao.models.Settings.remove { _id: "Message_Delete" }
		CaoLiao.models.Settings.remove { _id: "Message_KeepStatusHistory" }

		CaoLiao.models.Settings.update { _id: "Message_ShowEditedStatus" }, { $set: { type: "boolean", value: true } }
		CaoLiao.models.Settings.update { _id: "Message_ShowDeletedStatus" }, { $set: { type: "boolean", value: false } }

		metaKeys = [
			'old': 'Meta:language'
			'new': 'Meta_language'
		,
			'old': 'Meta:fb:app_id'
			'new': 'Meta_fb_app_id'
		,
			'old': 'Meta:robots'
			'new': 'Meta_robots'
		,
			'old': 'Meta:google-site-verification'
			'new': 'Meta_google-site-verification'
		,
			'old': 'Meta:msvalidate.01'
			'new': 'Meta_msvalidate01'
		]

		for oldAndNew in metaKeys
			oldValue = CaoLiao.models.Settings.findOne({_id: oldAndNew.old})?.value
			newValue = CaoLiao.models.Settings.findOne({_id: oldAndNew.new})?.value
			if oldValue? and not newValue?
				CaoLiao.models.Settings.update { _id: oldAndNew.new }, { $set: { value: newValue } }

			CaoLiao.models.Settings.remove { _id: oldAndNew.old }


		CaoLiao.models.Settings.remove { _id: "SMTP_Security" }
