App.feeds = App.cable.subscriptions.create "InstantMessengerChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    $('#instant_messages_table').append(data.firstname.class + ": " + data.content + "<br>")
    # data.created_at + " " + 