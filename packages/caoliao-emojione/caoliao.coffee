# CaoLiao.emoji should be set to an object representing the emoji package used
CaoLiao.emoji = emojione

CaoLiao.emoji.imageType = 'png';
CaoLiao.emoji.sprites = true;

# CaoLiao.emoji.list is the collection of emojis
CaoLiao.emoji.list = emojione.emojioneList

# CaoLiao.emoji.class is the name of the registered class for emojis
CaoLiao.emoji.class = 'Emojione'

# Additional settings -- ascii emojis
Meteor.startup ->
	Tracker.autorun ->
		emojione?.ascii = if Meteor.user()?.settings?.preferences?.convertAsciiEmoji? then Meteor.user().settings.preferences.convertAsciiEmoji else true
