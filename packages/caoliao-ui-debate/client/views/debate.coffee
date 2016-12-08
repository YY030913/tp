isSubscribed =  ->
	return FlowRouter.subsReady('debate')

Template.debate.helpers
	currentUser: ->
		return Meteor.userId()
	validEdit: ->
		return Meteor.userId() == CaoLiao.models.Debate.findOne(FlowRouter.current().params.slug).u._id
	slug: ->
		return FlowRouter.current().params.slug
	userid: ->
		return CaoLiao.models.Debate.findOne(FlowRouter.current().params.slug).u._id
	pagetitle: ->
		return CaoLiao.models.Debate.findOne(FlowRouter.current().params.slug).name
	username: ->
		return CaoLiao.models.Debate.findOne(FlowRouter.current().params.slug).u.username
	t: ->
		return CaoLiao.models.Debate.findOne(FlowRouter.current().params.slug).ts
	isLiving: ->
		return CaoLiao.models.Debate.findOne(FlowRouter.current().params.slug).webrtcJoined?.length > 0
	htmlBody: ->
		return CaoLiao.models.Debate.findOne(FlowRouter.current().params.slug).htmlBody
	createTime: ->
		# moment(this.ts).format('LLL')
		# moment(this.ts).locale(TAPi18n.getLanguage()).format('L LT')
		# moment(this.ts).format('LT') 1:03 PM
		# moment(this.ts).format('LL')August 15, 2016
		# console.log moment(CaoLiao.models.Debate.findOne(FlowRouter.current().params.slug).ts).locale(TAPi18n.getLanguage()).format('YYYY-MM-DD')
		if moment().diff(moment(CaoLiao.models.Debate.findOne(FlowRouter.current().params.slug).ts), 'days') >= 1
			return moment(CaoLiao.models.Debate.findOne(FlowRouter.current().params.slug).ts).locale(TAPi18n.getLanguage()).format('YYYY-MM-DD')
		else
			return moment(CaoLiao.models.Debate.findOne(FlowRouter.current().params.slug).ts).locale(TAPi18n.getLanguage()).fromNow();

	isSub: ->
		return isSubscribed();
	isEmpty: ->
		return CaoLiao.models.Debate.find(FlowRouter.current().params.slug).count() == 0;

	debatetags: ->
		return CaoLiao.models.Debate.findOne(FlowRouter.current().params.slug).tags

	started: ->
		return false;

	imageMogr: (html)->
		width = $(window).width()
		return CaoLiao.utils.extendImgSrcs(html, "?imageMogr2/thumbnail/#{width}/quality/100")

Template.debate.onCreated ->
	# console.log "debate.onCreated"
	# @debate = new ReactiveVar Object

Template.debate.onRendered ->
	self = this

	Meteor.call("updateDebateRead", FlowRouter.current().params.slug)
	
	Refresh = ->															
		window.open("http://www.baidu.com");


	###
	autocontentterval = Meteor.setInterval ->
		if $("#theGrid").length == 1
			Meteor.clearInterval autocontentterval
			window.Autocontent()
	,100

	
	refreshinterval = Meteor.setInterval ->
		if document.getElementById("debateContainer").querySelector(".container")?
			# console.log document.getElementById("debateContainer").querySelector(".container")
			refresher.init
				id:"debateContainer",
				insertBeforeElem: ".container",
				pullDownAction:Refresh,
				pullDownLable: "pullDownLable",
				pullingDownLable: "pullingDownLable",
				pullUpLable: "pullUpLable",
				pullingUpLable: "pullingUpLable",
				loadingLable: "loadingLable..."
			Meteor.clearInterval(refreshinterval)
	, 100
	###

	###
	Template.instance().debate.set({result: true});
	Meteor.call("getDebate", FlowRouter.current().params.slug, (error, result)->
		if error?
			toastr.error t(error.message)
		else 
			CaoLiao.models.Debate.upsert {_id: FlowRouter.current().params.slug}, result
			self.debate.set(result);
	);
	###
Template.debate.onDestroyed ->

Template.debate.events
	###
	'keydown .edit-label': (event, instance)->
		tag = {
			_id: $(event.target).data("id"),
			name: $(event.target).text()
		}
		Meteor.call("updateDebateTag", FlowRouter.current().params.slug, tag, (error, result)->
			if error?
				toastr.error t(error.message)
		);
	###
	'keyup .edit-label': (event, instance)->
		event.preventDefault()
		event.stopPropagation()
		if event.which is 13
			if _.trim($(event.target).text()) isnt ''
				tag = {
					_id: $(event.target).data("id"),
					name: _.trim($(event.target).text())
				}
				$(event.target).text('')
				event.preventDefault()
				event.stopPropagation()
				Meteor.call("updateDebateTag", FlowRouter.current().params.slug, tag, (error, result)->
					if error?
						toastr.error t(error.message)
				);
	'click .add-label': (event, instance)->
		$("#debate-tag-input").toggle();
	'click .icon-star-empty': (event, instance)->
		Meteor.call("startDebate", FlowRouter.current().params.slug, (error, result)->
			if error?
				toastr.error t(error.message)
		);
	'click .icon-star': (event, instance)->
		Meteor.call("unstartDebate", FlowRouter.current().params.slug, (error, result)->
			if error?
				toastr.error t(error.message)
		);

	'click .icon-share': (event, instance)->
		event.preventDefault()

		if !Meteor.isCordova
			$("#qrcode").empty();
			$("#qrcode").qrcode( 

				render: "table",

				width: 200,

				height:200,

				text: "http://caoliao.net.cn/"
			)
		$(".social-share-wrap").addClass("active")
		###
		
		
		Meteor.call("sharetDebate", FlowRouter.current().params.slug, (error, result)->
			if error?
				toastr.error t(error.message)
		);
		###

	'click .icon-comment-a': (event, instance)->
		
		if !ChatSubscription.findOne({rid: CaoLiao.models.Debate.findOne(FlowRouter.current().params.slug).rid})?
			Meteor.call("joinRoom", CaoLiao.models.Debate.findOne(FlowRouter.current().params.slug).rid, (error, result)->
				if error?
					toastr.error t(error.message)
					return
				else
					FlowRouter.goToRoomById CaoLiao.models.Debate.findOne(FlowRouter.current().params.slug).rid
			);
		else
			FlowRouter.goToRoomById CaoLiao.models.Debate.findOne(FlowRouter.current().params.slug).rid