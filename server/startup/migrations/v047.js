CaoLiao.Migrations.add({
	version: 47,
	up: function() {
		if (CaoLiao && CaoLiao.models && CaoLiao.models.Settings) {
			var autolinkerUrls = CaoLiao.models.Settings.findOne({ _id: 'AutoLinker_Urls' });
			if (autolinkerUrls) {
				CaoLiao.models.Settings.remove({ _id: 'AutoLinker_Urls' });
				CaoLiao.models.Settings.upsert({ _id: 'AutoLinker_Urls_Scheme' }, {
					$set: {
						value: autolinkerUrls.value ? true : false,
						i18nLabel: 'AutoLinker_Urls_Scheme'
					}
				});
				CaoLiao.models.Settings.upsert({ _id: 'AutoLinker_Urls_www' }, {
					$set: {
						value: autolinkerUrls.value ? true : false,
						i18nLabel: 'AutoLinker_Urls_www'
					}
				});
				CaoLiao.models.Settings.upsert({ _id: 'AutoLinker_Urls_TLD' }, {
					$set: {
						value: autolinkerUrls.value ? true : false,
						i18nLabel: 'AutoLinker_Urls_TLD'
					}
				});
			}
		}
	}
});
