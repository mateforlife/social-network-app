class Post < ApplicationRecord
  belongs_to :user

  validates :body, presence: true, length: { in: 30..600 }
end
