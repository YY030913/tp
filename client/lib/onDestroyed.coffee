
Template.onDestroyed ->
	# console.log "Template.onDestroyed"
	# $("body").removeClass("loaded")


Template.onRendered ->
	instance = this
	Blaze._allowJavascriptUrls()