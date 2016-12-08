Meteor.methods
	loadNextTypeDebates: (slug, end, limit=20, ls=null) ->

		if ls?
			unless Meteor.userId()
				return this.ready()

		fromId = Meteor.userId()


		options =
			sort:
				ts: -1
			limit: limit

		tags = []
		if Meteor.userId()
			temps = CaoLiao.models.DebateSubscriptions.findByTypeAndUserId(slug, Meteor.userId(), fields: {
					tid :1
			}).fetch()

			_.each(temps, (element, index, list) -> 
				tags.push element.tid
			)
		else
			newsTag = CaoLiao.models.Tags.findOneByNameAndType('News', 'o', fields: {
				_id :1
			})
			tags.push newsTag._id

		if end?
			records = CaoLiao.models.Debates.findVisibleInTagsBeforeTimestamp(tags, end, options).fetch()
		else
			records = CaoLiao.models.Debates.findVisibleInTags(tags, options).fetch()


		
		debates = _.map records, (debate) ->
			debate.starred = _.findWhere debate.starred, { _id: fromId }
			return debate

		return {
			debates: debates
		}