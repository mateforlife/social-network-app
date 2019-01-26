# frozen-string-literal: true

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

  #has_one_attached :avatar
  #has_one_attached :cover

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
