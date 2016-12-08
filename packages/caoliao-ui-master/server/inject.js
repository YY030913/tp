/* globals Inject */

// Inject.rawBody('page-loading', `
// 	<div id="initial-page-loading" class="page-loading">
// 		<div class="spinner">
// 			<div class="rect1"></div>
// 			<div class="rect2"></div>
// 			<div class="rect3"></div>
// 			<div class="rect4"></div>
// 			<div class="rect5"></div>
// 		</div>
// 	</div>`
// );
// Inject.rawModHtml('moveScriptsToBottom', function(html) {
// 	console.log("moveScriptsToBottom callled");
//     // get all scripts
//     var scripts = html.match(/<script type="text\/javascript" src.*"><\/script>\n/g);
//     // remove all scripts
//     html = html.replace(/<script type="text\/javascript" src.*"><\/script>\n/g, '');
//     // add scripts to the bottom
//     return html.replace(/<\/body>/, scripts.join('') + '\n</body>');
// });

CaoLiao.settings.get('Site_Url', function() {
	Meteor.defer(function() {
		let baseUrl;
		if (__meteor_runtime_config__.ROOT_URL_PATH_PREFIX && __meteor_runtime_config__.ROOT_URL_PATH_PREFIX.trim() !== '') {
			baseUrl = __meteor_runtime_config__.ROOT_URL_PATH_PREFIX;
		} else {
			baseUrl = '/';
		}
		if (/\/$/.test(baseUrl) === false) {
			baseUrl += '/';
		}
		Inject.rawHead('base', `<base href="${baseUrl}">`);
	});
});

CaoLiao.settings.get('GoogleSiteVerification_id', function(key, value) {
	if (value) {
		Inject.rawHead('google-site-verification', `<meta name="google-site-verification" content="${value}" />`);
	} else {
		Inject.rawHead('google-site-verification', '');
	}
});
