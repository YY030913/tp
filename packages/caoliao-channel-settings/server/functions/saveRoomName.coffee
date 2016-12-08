CaoLiao.saveRoomName = (rid, name) ->
	if not Meteor.userId()
		throw new Meteor.Error('error-invalid-user', "Invalid user", { function: 'CaoLiao.saveRoomName' })

	room = CaoLiao.models.Rooms.findOneById rid

	if room.t not in ['c', 'p']
		throw new Meteor.Error 'error-not-allowed', 'Not allowed', { function: 'CaoLiao.saveRoomName' }

	unless CaoLiao.authz.hasPermission(Meteor.userId(), 'edit-room', rid)
		throw new Meteor.Error 'error-not-allowed', 'Not allowed', { function: 'CaoLiao.saveRoomName' }

	###
	try
		nameValidation = new RegExp '^' + CaoLiao.settings.get('UTF8_Names_Validation') + '$'
	catch
		nameValidation = new RegExp '^[0-9a-zA-Z-_.]+$'

	if not nameValidation.test name
		throw new Meteor.Error 'error-invalid-room-name', name + ' is not a valid room name. Use only letters, numbers, hyphens and underscores', { function: 'CaoLiao.saveRoomName', room_name: name }

	###

	if name.length > CaoLiao.settings.get('UTF8_Names_MaxLength') || name.length < CaoLiao.settings.get('UTF8_Names_MinLength')
		throw new Meteor.Error 'error-invalid-room-name-length', "#{name} is not a valid length must longer then #{CaoLiao.settings.get('UTF8_Names_MinLength')} and litter then #{CaoLiao.settings.get('UTF8_Names_MaxLength')}"


	# name = _.slugify name

	if name is room.name
		return

	# avoid duplicate names
	if CaoLiao.models.Rooms.findOneByName name
		throw new Meteor.Error 'error-duplicate-channel-name', 'A channel with name \'' + name + '\' exists', { function: 'CaoLiao.saveRoomName', channel_name: name }

	CaoLiao.models.Rooms.setNameById rid, name
	CaoLiao.models.Subscriptions.updateNameAndAlertByRoomId rid, name

	return name
