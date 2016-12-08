@visitorId = new ReactiveVar null

Meteor.startup ->
	if not localStorage.getItem('caoliaoLivechat')?
		localStorage.setItem('caoliaoLivechat', Random.id())

	visitorId.set localStorage.getItem('caoliaoLivechat')
