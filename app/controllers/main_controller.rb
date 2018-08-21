# frozen-string-literal: true

class MainController < ApplicationController
  def home
    @post = Post.new
    @posts = Post.order('created_at DESC')
  end

  def unregistered
  end

  # protected

  # def set_layout
  #   return 'landing' if action_name == 'unregistered'
  #   super
  # end
end
