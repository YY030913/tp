CaoLiao.models.Medals = new class extends CaoLiao.models._Base
	constructor: ->
		@_initModel 'medals'
		@tryEnsureIndex { 'name': 1 }

	findUsersInRole: (name, options) ->
		medal = @findOne name
		CaoLiao.models['Users']?.findUsersInMedals?(name, options)

	isUserInMedals: (userId, medals) ->
		medals = [].concat medals
		_.some medals, (medalName) =>
			medal = @findOne medalName
			return CaoLiao.models['Users']?.isUserInRole?(userId, medalName)

	createOrUpdate: (name, description, protectedRole) ->
		updateData = {}
		updateData.name = name
		if description?
			updateData.description = description
		if protectedRole?
			updateData.protected = protectedRole

		@upsert { _id: name }, { $set: updateData }

	addUserMedals: (userId, medals) ->
		medals = [].concat medals
		console.log medals
		for medalName in medals
			medal = @findOne medalName
			CaoLiao.models['Users']?.addMedalsByUserId?(userId, medalName)

	removeUserMedals: (userId, medals) ->
		medals = [].concat medals
		for medalName in medals
			medal = @findOne medalName
			CaoLiao.models['Users']?.removeMedalsByUserId?(userId, medalName)
