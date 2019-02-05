class PostChannel < ApplicationCable::Channel
  def subscribed
    stream_from "posts"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def echo(data)
    ActionCable.server.broadcast "posts", data
  end
end
