// CaoLiao.OptionTabBar.addButton({
// 	groups: ['directmessage'],
// 	id: 'user-info',
// 	i18nTitle: 'User_Info',
// 	icon: 'icon-user',
// 	template: 'membersList',
// 	route: {
// 		name: 'membersList',
// 		path: '/membersList/:rid',
// 		action(params/*, queryParams*/) {
// 			BlazeLayout.render('main', {
// 			  	center: 'membersList'
// 			});
// 		},
// 		link(sub) {
// 			return {
// 				rid: sub.rid
// 			};
// 		}
// 	},
// 	order: 2
// });

CaoLiao.OptionTabBar.addButton({
	groups: ['channel', 'privategroup'],
	id: 'members-list',
	i18nTitle: 'Members_List',
	icon: 'icon-users',
	template: 'membersList',
	route: {
		name: 'membersList',
		path: '/membersList/:rid',
		action(params/*, queryParams*/) {
			BlazeLayout.render('main', {
			  	center: 'membersList'
			});
		},
		link(sub) {
			return {
				rid: sub.rid
			};
		}
	},
	order: 2
});

// CaoLiao.OptionTabBar.addButton({
// 	groups: ['channel', 'privategroup', 'directmessage'],
// 	id: 'uploaded-files-list',
// 	i18nTitle: 'Room_uploaded_file_list',
// 	icon: 'icon-attach',
// 	template: 'uploadedFilesList',
// 	route: {
// 		name: 'uploadedFilesList',
// 		path: '/uploadedFilesList/:rid',
// 		action(params/*, queryParams*/) {	
// 			BlazeLayout.render('main', {
// 			  	center: 'uploadedFilesList'
// 			});
// 		},
// 		link(sub) {
// 			return {
// 				rid: sub.rid
// 			};
// 		}
// 	},
// 	order: 3
// });
