CaoLiao.Score = {};
CaoLiao.Score.utils = {};


CaoLiao.Score.utils.minScore = -100;
CaoLiao.Score.utils.registerScore = 100;
CaoLiao.Score.utils.debateCreateScore = 10;
CaoLiao.Score.utils.loginScore = 1;
CaoLiao.Score.utils.addFollow = 0;
CaoLiao.Score.utils.sendMessage = 0;


CaoLiao.Score.utils.MaxCount = 102400;

###
icon
operator
title
content
###

CaoLiao.Score.utils.add = (href, icon, operator) ->
	"icon": icon
	"operator": operator
	"href": href


CaoLiao.Score.utils.canCreateDebateCount = (score) ->
	if score <= 10000
		return 1
	else if score <= 50000 && score > 10000
		return 5
	else if score <= 100000 && score > 50000
		return 20
	else 
		return CaoLiao.Score.utils.MaxCount

CaoLiao.Score.utils.canOptionMsgCount = (score) ->
	if score <= 1000
		return 50
	else if score <= 5000 && score > 1000
		return 500
	else if score <= 100000 && score > 5000
		return 5000
	else 
		return CaoLiao.Score.utils.MaxCount

CaoLiao.Score.utils.canTipoffCount = (score) ->
	if score <= 1000
		return 3
	else if score <= 5000 && score > 1000
		return 30
	else if score <= 100000 && score > 5000
		return 300
	else 
		return CaoLiao.Score.utils.MaxCount