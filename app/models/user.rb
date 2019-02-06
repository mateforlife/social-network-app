# frozen-string-literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint(8)        not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  username               :string
#  name                   :string
#  uid                    :string
#  provider               :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  about                  :text
#  avatar_file_name       :string
#  avatar_content_type    :string
#  avatar_file_size       :bigint(8)
#  avatar_updated_at      :datetime
#  cover_file_name        :string
#  cover_content_type     :string
#  cover_file_size        :bigint(8)
#  cover_updated_at       :datetime
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable,
         omniauth_providers: [:facebook]

  validates :username, presence: true, length: { in: 3..20 }
  validates_uniqueness_of :username
  validate :username_regex

  has_many :posts
  has_many :friendships
  has_many :followers, class_name: 'Friendship', foreign_key: 'friend_id'
  has_many :friends_added, through: :friendships, source: :friend
  has_many :friends_who_added, through: :friendships, source: :user

  has_attached_file :avatar, styles: { thumb: '100x100', medium: '300x300' },
                             default_url: '/images/:style/missing.png'
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  has_attached_file :cover, styles: { thumb: '400x300', medium: '800x600' },
                            default_url: '/images/:style/missing_cover.png'
  validates_attachment_content_type :cover, content_type: /\Aimage\/.*\Z/

  def self.from_omniauth(auth)
    where(provider: auth['provider'], uid: auth['uid']).first_or_create do |user|
      user.email = auth['info']['email']
      user.name = auth['info']['name']
      user.password = Devise.friendly_token[0, 20]
    end
  end

  def unviewed_notifications_count
    Notification.for_user(self.id)
  end

  def my_friend?(friend)
    Friendship.friends?(self, friend)
  end

  def friend_ids
    Friendship.active.where(user: self).pluck(:friend_id)
  end

  def user_ids
    Friendship.active.where(friend: self).pluck(:user_id)
  end

  private

  def username_regex
    unless username =~ /\A[a-zA-Z]*[a-zA-Z][a-zA-Z0-9_]*\z/
      errors.add(:username, 'el nombre de usuario debe iniciar con una letra,
                             puede contener a demas números y guión bajo')
    end
  end
end
