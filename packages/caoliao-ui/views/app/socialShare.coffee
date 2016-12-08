
Template.socialShare.onRendered ->

Template.socialShare.events
	'click .share-wechat': (event, instance)->
		if Meteor.isCordova
			Wechat.isInstalled( (installed) ->
				if installed
					scope = "snsapi_userinfo";
					state = "_" + (+new Date());
					Wechat.auth(scope, state, (response) ->
						Wechat.share(
							message: {
								title: "Hi, there",
								description: "This is description.",
								thumb: "www/img/thumbnail.png",
								mediaTagName: "TEST-TAG-001",
								messageExt: "这是第三方带的测试字段",
								messageAction: "<action>dotalist</action>",
								media: "YOUR_MEDIA_OBJECT_HERE"
							},
							scene: Wechat.Scene.TIMELINE
						,  () ->
							alert("Success");
						, (reason) ->
							alert("Failed: " + reason);
						);
						
					, (reason) ->
						alert("Failed: " + reason);
					);
			, (reason) ->
				alert("Failed: " + reason);
			);
		else
			$("#shareModal").openModal()
			
	'click .close': (event, instance)->
		$(".social-share-wrap").removeClass("active")