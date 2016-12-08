CaoLiao.tagTypes.add null, 0,
	template: 'starredTags'
	icon: 'icon-star'

CaoLiao.tagTypes.add 'o', 10,
	template: 'debateTag'
	icon: 'icon-hash'
	route:
		name: 'openTag'
		path: '/openTag/debates/:name'
		action: (params, queryParams) ->
			openTag 'o', params.name
			CaoLiao.TabBar.showGroup 'debatetag'
		link: (sub) ->
			return { name: sub.name }
	findTag: (identifier) ->
		query =
			t: 'o'
			name: identifier
		return Tag.findOne(query)
	tagName: (tagData) ->
		return tagData.name
	condition: ->
		return CaoLiao.authz.hasAtLeastOnePermission ['view-o-tag', 'view-joined-tag']

CaoLiao.tagTypes.add 'u', 20,
	template: 'debateTag'
	icon: 'icon-hash'
	route:
		name: 'userTag'
		path: '/userTag/debates/:name'
		action: (params, queryParams) ->
			openTag 'u', params.name
			CaoLiao.TabBar.showGroup 'debatetag'
		link: (sub) ->
			return { name: sub.name }
	findTag: (identifier) ->
		query =
			t: 'u'
			name: identifier
		return Tag.findOne(query)
	tagName: (tagData) ->
		return tagData.name
	condition: ->
		return CaoLiao.authz.hasAllPermission 'view-u-tag'

CaoLiao.tagTypes.add 'h', 30,
	template: 'debateTag'
	icon: 'icon-lock'
	route:
		name: 'group'
		path: '/group/:name'
		action: (params, queryParams) ->
			openTag 'h', params.name
			CaoLiao.TabBar.showGroup 'privategroup'
		link: (sub) ->
			return { name: sub.name }
	findTag: (identifier) ->
		query =
			t: 'h'
			name: identifier
		return Tag.findOne(query)
	tagName: (tagData) ->
		return tagData.name
	condition: ->
		return CaoLiao.authz.hasAllPermission 'view-h-tag'
