# == Schema Information
#
# Table name: friendships
#
#  id         :bigint(8)        not null, primary key
#  user_id    :bigint(8)
#  friend_id  :bigint(8)
#  status     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# frozen-string-literal: true

class Friendship < ApplicationRecord
  include AASM
  include Notificable

  belongs_to :user
  belongs_to :friend, class_name: 'User'
  validates :user_id, uniqueness: { scope: :friend_id,
                                    message: 'Amistar duplicada' }

  def self.friends?(user, friend)
    return true if user == friend
    Friendship.where(user: user, friend: friend)
              .or(Friendship.where(user: friend, friend: user))
              .any?
  end

  def self.pending_for_user(user)
    Friendship.pending.where(friend: user)
  end

  def self.accepted_for_user(user)
    Friendship.active.where(friend: user)
  end

  def user_ids

  end
  
  aasm column: 'status' do
    state :pending, initial: true
    state :active
    state :denied

    event :accepted do
      transitions from: :pending, to: :active
    end

    event :rejected do
      transitions from: %i[pending active], to: :denied
    end
  end
end
