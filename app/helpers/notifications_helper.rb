# frozen_string_literal: true

module NotificationsHelper
  def render_notifications(notifications)
    notifications.map do |n|
      render partial: "notifications/#{n.item_type.downcase}", locals: { notification: n }
    end.join(' | ').html_safe
  end
end
