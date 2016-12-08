CaoLiao.Debate = {};

CaoLiao.Debate.readWeight = 0.1
CaoLiao.Debate.shareWeight = 0.5
CaoLiao.Debate.favoriteWeight = 0.2
CaoLiao.Debate.commentWeight = 0.2


CaoLiao.Debate.utils = {};

###
icon
operator
title
content
###

CaoLiao.Debate.utils.addDebate = (debate, icon, operator) ->
  "icon": icon
  "operator": operator
  "title": debate.name
  "content": debate.abstractHtml
