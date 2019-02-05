# frozen-string-literal: true

class Post < ApplicationRecord
  belongs_to :user

  validates :body, presence: true, length: { in: 30..600 }

  scope :newest, -> { order('created_at DESC') }

  def self.all_for_user(user)
    Post.where(user_id: user.id)
        .or(Post.where(user_id: user.friend_ids))
        .or(Post.where(user_id: user.user_ids))
  end

  private

  def send_to_action_cable
    data = { message: to_html, action: 'new_post' }

    self.user.user_ids.each do |friend_id|
      ActionCable.server.broadcast "posts_#{friend_id}", data
    end

    self.user.user_ids.each do |user_id|
      ActionCable.server.broadcast "posts_#{user_id}", data
    end
  end

  def to_html
    AplicationController.renderer.render(partial: 'posts/post', locals: { post: self })
  end
end
