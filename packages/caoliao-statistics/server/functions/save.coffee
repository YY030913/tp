CaoLiao.statistics.save = ->
	statistics = CaoLiao.statistics.get()
	statistics.createdAt = new Date
	CaoLiao.models.Statistics.insert statistics
	return statistics

