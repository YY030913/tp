CaoLiao.Migrations.add({
	version: 39,
	up: function() {
		if (CaoLiao && CaoLiao.models && CaoLiao.models.Settings) {
			var footer = CaoLiao.models.Settings.findOne({ _id: 'Layout_Sidenav_Footer' });

			// Replace footer octicons with icons
			if (footer && footer.value !== '') {
				var footerValue = footer.value.replace('octicon octicon-pencil', 'icon-pencil');
				footerValue = footerValue.replace('octicon octicon-heart', 'icon-heart');
				footerValue = footerValue.replace('octicon octicon-mark-github', 'icon-github-circled');
				CaoLiao.models.Settings.update({ _id: 'Layout_Sidenav_Footer' }, { $set: { value: footerValue, packageValue: footerValue } });
			}
		}
	}
});
