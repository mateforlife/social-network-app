# frozen-string-literal: true

class AccountsController < ApplicationController
  before_action :set_user
  before_action :authenticate_user!, only: :update
  before_action :authenticate_owner!, only: :update

  def show
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'Perfil actualizado!' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { redirect_to @user, notice: @user.errors.full_messages }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def authenticate_owner!
    if current_user != @user
      redirect_to root_path, notice: 'no tiene permisos necesarios', status: :unauthorized
    end
  end

  def user_params
    params.require(:user).permit(:name, :username, :about, :avatar, :cover)
  end
end
