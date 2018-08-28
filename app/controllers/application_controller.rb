# frozen-string-literal: true

class ApplicationController < ActionController::Base
  before_action :devise_additional_params, if: :devise_controller?

  layout :set_layout

  protected

  def devise_additional_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end

  def set_layout
    if devise_controller?
      'landing'
    else
      'application'
    end
  end
end
