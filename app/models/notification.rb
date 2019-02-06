# == Schema Information
#
# Table name: notifications
#
#  id         :bigint(8)        not null, primary key
#  user_id    :bigint(8)
#  item_type  :string
#  item_id    :bigint(8)
#  viewed     :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :item, polymorphic: true
  after_commit { NotificationBroadcastJob.perform_later(self) }

  scope :unviewed, -> { where(viewed: false) }

  def self.for_user(user_id)
    Notification.where(user_id: user_id).unviewed.count
  end
end
