Meteor.methods
  openTag: (tid) ->
    if not Meteor.userId()
      throw new Meteor.Error 'error-invalid-user', 'Invalid user', { method: 'openTag' }

    CaoLiao.models.DebateSubscriptions.openByTagIdAndUserId tid, Meteor.userId()
