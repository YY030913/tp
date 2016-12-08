/* globals openRoom */

CaoLiao.roomTypes.add('l', 5, {
	template: 'livechat',
	icon: 'icon-chat-empty',
	route: {
		name: 'live',
		path: '/live/:code(\\d+)',
		action(params/*, queryParams*/) {
			openRoom('l', params.code);
			CaoLiao.TabBar.showGroup('livechat', 'search');
		},
		link(sub) {
			return {
				code: sub.code
			};
		}
	},

	findRoom(identifier) {
		return ChatRoom.findOne({ code: parseInt(identifier) });
	},

	roomName(roomData) {
		if (!roomData.name) {
			return roomData.label;
		} else {
			return roomData.name;
		}
	},

	condition: () => {
		return CaoLiao.settings.get('Livechat_enabled') && CaoLiao.authz.hasAllPermission('view-l-room');
	}
});

AccountBox.addItem({
	name: 'Livechat',
	icon: 'icon-chat-empty',
	href: 'livechat-current-chats',
	sideNav: 'livechatFlex',
	condition: () => {
		return CaoLiao.settings.get('Livechat_enabled') && CaoLiao.authz.hasAllPermission('view-livechat-manager');
	}
});

CaoLiao.TabBar.addButton({
	groups: ['livechat'],
	id: 'visitor-info',
	i18nTitle: 'Visitor_Info',
	icon: 'icon-info-circled',
	template: 'visitorInfo',
	order: 0
});

// CaoLiao.TabBar.addButton({
// 	groups: ['livechat'],
// 	id: 'visitor-navigation',
// 	i18nTitle: 'Visitor_Navigation',
// 	icon: 'icon-history',
// 	template: 'visitorNavigation',
// 	order: 10
// });

CaoLiao.TabBar.addButton({
	groups: ['livechat'],
	id: 'visitor-history',
	i18nTitle: 'Past_Chats',
	icon: 'icon-chat',
	template: 'visitorHistory',
	order: 11
});

CaoLiao.TabBar.addGroup('message-search', ['livechat']);
CaoLiao.TabBar.addGroup('starred-messages', ['livechat']);
CaoLiao.TabBar.addGroup('uploaded-files-list', ['livechat']);
CaoLiao.TabBar.addGroup('push-notifications', ['livechat']);

CaoLiao.TabBar.addButton({
	groups: ['livechat'],
	id: 'external-search',
	i18nTitle: 'Knowledge_Base',
	icon: 'icon-lightbulb',
	template: 'externalSearch',
	order: 10
});

CaoLiao.MessageTypes.registerType({
	id: 'livechat-close',
	system: true,
	message: 'Conversation_closed',
	data(message) {
		return {
			comment: message.msg
		};
	}
});
