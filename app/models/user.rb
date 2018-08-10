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

  def self.from_omniauth(auth)
    where(provider: auth['provider'], uid: auth['uid']).first_or_create do |user|
      user.email = auth['info']['email']
      user.name = auth['info']['name']
      user.password = Devise.friendly_token[0, 20]
    end
  end

  private

  def username_regex
    unless username =~ /\A[a-zA-Z]*[a-zA-Z][a-zA-Z0-9_]*\z/
      errors.add(:username, 'el nombre de usuario debe iniciar con una letra,
                             puede contener a demas números y guión bajo')
    end
  end
end
