class NotificationsController < ApplicationController
  def index
    @notifications = Notification.where(user: current_user).unviewed
    respond_to do |format|
      format.html
      format.js
    end
  end
end
