CaoLiao._setUsername = (userId, username) ->
	username = s.trim username
	if not userId or not username
		return false

	###
	try
		nameValidation = new RegExp '^' + CaoLiao.settings.get('UTF8_Names_Validation') + '$'
	catch
		nameValidation = new RegExp '^[0-9a-zA-Z-_.]+$'

	if not nameValidation.test username
		return false
		
	###

	if username.length > CaoLiao.settings.get('UTF8_Names_MaxLength') || username.length < CaoLiao.settings.get('UTF8_Names_MinLength')
		return false

	user = CaoLiao.models.Users.findOneById userId

	# User already has desired username, return
	if user.username is username
		return user

	previousUsername = user.username

	# Check username availability or if the user already owns a different casing of the name
	if ( !previousUsername or !(username.toLowerCase() == previousUsername.toLowerCase()))
		unless CaoLiao.checkUsernameAvailability username
			return false

	# If first time setting username, send Enrollment Email
	if not previousUsername and user.emails?.length > 0 and CaoLiao.settings.get 'Accounts_Enrollment_Email'
		Accounts.sendEnrollmentEmail(userId)

	# Username is available; if coming from old username, update all references
	if previousUsername
		CaoLiao.models.Messages.updateAllUsernamesByUserId userId, username
		CaoLiao.models.Messages.updateUsernameOfEditByUserId userId, username

		CaoLiao.models.Messages.findByMention(previousUsername).forEach (msg) ->
			updatedMsg = msg.msg.replace(new RegExp("@#{previousUsername}", "ig"), "@#{username}")
			CaoLiao.models.Messages.updateUsernameAndMessageOfMentionByIdAndOldUsername msg._id, previousUsername, username, updatedMsg

		CaoLiao.models.Rooms.replaceUsername previousUsername, username
		CaoLiao.models.Rooms.replaceMutedUsername previousUsername, username
		CaoLiao.models.Rooms.replaceUsernameOfUserByUserId userId, username

		CaoLiao.models.Subscriptions.setUserUsernameByUserId userId, username
		CaoLiao.models.Subscriptions.setNameForDirectRoomsWithOldName previousUsername, username


		CaoLiao.models.Debates.updateAllUsernamesByUserId userId, username
		CaoLiao.models.Debates.replaceUsername previousUsername, username

		CaoLiao.models.DebateSubscriptions.updateAllUsernamesByUserId userId, username

		CaoLiao.models.DebateHistories.updateAllUsernamesByUserId userId, username
		
		rs = CaoLiaoFileAvatarInstance.getFileWithReadStream(encodeURIComponent("#{previousUsername}.jpg"))
		if rs?
			CaoLiaoFileAvatarInstance.deleteFile encodeURIComponent("#{username}.jpg")
			ws = CaoLiaoFileAvatarInstance.createWriteStream encodeURIComponent("#{username}.jpg"), rs.contentType
			ws.on 'end', Meteor.bindEnvironment ->
				CaoLiaoFileAvatarInstance.deleteFile encodeURIComponent("#{previousUsername}.jpg")
			rs.readStream.pipe(ws)

	# Set new username
	pinyin = Npm.require('pinyin');
	CaoLiao.models.Users.setUsername userId, username
	username_pinyin_array = pinyin(username, {heteronym: true, segment: true })
	username_pinyin_str = ""
	for item in username_pinyin_array
		username_pinyin_str = username_pinyin_str + item[0].split(",")[0] + " "
	CaoLiao.models.Users.setPinyin userId, username_pinyin_str

	if _.indexOf(user.medals, 'Medal_Start')<0
		CaoLiao.models.Users.addMedalsByUserId userId, "Medal_Start"
		
	user.username = username
	user.pinyin = pinyin(username, {heteronym: true, segment: true })
	return user

CaoLiao.setUsername = CaoLiao.RateLimiter.limitFunction CaoLiao._setUsername, 1, 60000,
	0: () -> return not Meteor.userId() or not CaoLiao.authz.hasPermission(Meteor.userId(), 'edit-other-user-info') # Administrators have permission to change others usernames, so don't limit those
