CaoLiao.checkIntroductionAvailability = function(introduction) {
	return introduction.length < CaoLiao.settings.get('UTF8_Long_Names_And_Introduction_MaxLength') && introduction.length > CaoLiao.settings.get('UTF8_Long_Names_And_Introduction_MinLength')

};
