class ApplicationController < ActionController::Base

  layout :set_layout

  protected

  def set_layout
    if devise_controller?
      'landing'
    else
      'application'
    end
  end
end
