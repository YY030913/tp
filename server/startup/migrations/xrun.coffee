if CaoLiao.Migrations.getVersion() isnt 0
	CaoLiao.Migrations.migrateTo 'latest'
else
	control = CaoLiao.Migrations._getControl()
	control.version = _.last(CaoLiao.Migrations._list).version
	CaoLiao.Migrations._setControl control
