Meteor.startup ->
	if Meteor.isCordova
		window.weibo.init "1500447187", "https://caoliao.net.cn/_oauth/weibo", -> console.log "success init weibo", -> console.log "fail init weibo"