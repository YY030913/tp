Meteor.methods
	deleteMessage: (message) ->
		if not Meteor.userId()
			throw new Meteor.Error 'error-invalid-user', 'Invalid user', { method: 'deleteMessage' }

		originalMessage = CaoLiao.models.Messages.findOneById message._id, {fields: {u: 1, rid: 1, file: 1}}
		if not originalMessage?
			throw new Meteor.Error 'error-action-not-allowed', 'Not allowed', { method: 'deleteMessage', action: 'Delete_message' }

		hasPermission = CaoLiao.authz.hasPermission(Meteor.userId(), 'delete-message', originalMessage.rid)
		deleteAllowed = CaoLiao.settings.get 'Message_AllowDeleting'

		deleteOwn = originalMessage?.u?._id is Meteor.userId()

		unless hasPermission or (deleteAllowed and deleteOwn)
			throw new Meteor.Error 'error-action-not-allowed', 'Not allowed', { method: 'deleteMessage', action: 'Delete_message' }

		blockDeleteInMinutes = CaoLiao.settings.get 'Message_AllowDeleting_BlockDeleteInMinutes'
		if blockDeleteInMinutes? and blockDeleteInMinutes isnt 0
			msgTs = moment(originalMessage.ts) if originalMessage.ts?
			currentTsDiff = moment().diff(msgTs, 'minutes') if msgTs?
			if currentTsDiff > blockDeleteInMinutes
				throw new Meteor.Error 'error-message-deleting-blocked', 'Message deleting is blocked', { method: 'deleteMessage' }


		keepHistory = CaoLiao.settings.get 'Message_KeepHistory'
		showDeletedStatus = CaoLiao.settings.get 'Message_ShowDeletedStatus'

		if keepHistory
			if showDeletedStatus
				CaoLiao.models.Messages.cloneAndSaveAsHistoryById originalMessage._id
			else
				CaoLiao.models.Messages.setHiddenById originalMessage._id, true

			if originalMessage.file?._id?
				CaoLiao.models.Uploads.update originalMessage.file._id, {$set: {_hidden: true}}

		else
			if not showDeletedStatus
				CaoLiao.models.Messages.removeById originalMessage._id

			if originalMessage.file?._id?
				FileUpload.delete(originalMessage.file._id)

		if showDeletedStatus
			CaoLiao.models.Messages.setAsDeletedById originalMessage._id
		else
			CaoLiao.Notifications.notifyRoom originalMessage.rid, 'deleteMessage', {_id: originalMessage._id}
