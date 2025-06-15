class UsersController < ApplicationController
  allow_unauthenticated_access only: %i[new create]

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(params.require(:user).permit(:email_address, :password).merge(account_attributes: { openrouter_key: nil }))
    if @user.save
      redirect_to new_session_url
    else
      render :new, status: :unprocessable_entity
    end
  end
end
