Meteor.publish 'tag', (tagName) ->
	unless this.userId
		return this.ready()
	
	if tagName?
		if typeof tagName isnt 'string'
			return this.ready()

		type = tagName.substr(0, 1)
		name = tagName.substr(1)
		record = CaoLiao.tagTypes.runPublish.call(this, type, name)
		return record
	else 
		return CaoLiao.models.Tags.find()