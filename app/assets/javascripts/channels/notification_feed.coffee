App.feeds = App.cable.subscriptions.create "NotificationFeedChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    $('#notification_feed_table').prepend(data.created_at + " " +data.firstname + ":<br>" + data.content + "<br>")
    $('#notification_feed_table').scrollTop() # TODO or some other notification of new message?