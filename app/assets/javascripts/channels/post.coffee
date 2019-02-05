App.post = App.cable.subscriptions.create "PostChannel",
  connected: ->
  # Called when the subscription is ready for use on the server

  disconnected: ->
  # Called when the subscription has been terminated by the server

  received: (data) ->
    if data.action == 'new_post'
      console.log(data)
      $('#posts .data').prepend(data.message)
    # Called when there's incoming data on the websocket for this channel
