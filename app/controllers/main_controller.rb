# frozen-string-literal: true

class MainController < ApplicationController
  def home
    @post = Post.new
    @posts = Post.all_for_user(current_user).newest
  end

  def unregistered
  end

  # protected

  # def set_layout
  #   return 'landing' if action_name == 'unregistered'
  #   super
  # end
end
