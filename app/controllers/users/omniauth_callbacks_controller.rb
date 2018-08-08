# frozen-string-literal: true

class Users::OmniauthCallbacksController < ApplicationController
  def facebook
    @user = User.from_omniauth(request.env['omniauth.auth'])
    if @user.persisted?
      @user.remember_me = true
      sign_in_and_redirect @user, event: :authentication
      return
    end
    session['devise.facebook_data'] = request.env['omniauth.auth']
    render :edit
  end

  # este metodo se llama desde el form edit
  def custom_sign_up
    @user = User.from_omniauth(session['devise.facebook_data'])
    if @user.update(user_params)
      sign_in_and_redirect @user, event: :authentication
    else
      render :edit
    end
  end

  def failure
    redirect_to new_user_session_path, notice: 'Hubo un problema con tu
                                               autenticación, por favor
                                               intentelo mas tarde'
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :username)
  end
end
