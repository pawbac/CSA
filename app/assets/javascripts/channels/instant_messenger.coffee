App.feeds = App.cable.subscriptions.create "InstantMessengerChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    $('#instant_messages_table').prepend(data.created_at + " " +data.firstname + ":<br>" + data.content + "<br>")
    $('#instant_messages_table').scrollTop() # or some other notification of new message?