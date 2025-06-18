class AccountsController < ApplicationController
  before_action :set_account, only: %i[edit update destroy]

  def edit
    redirect_to root_path if @account.user != Current.user
  end

  def update
    if @account.update(account_params)
      flash[:notice] = "Account updated successfully."
      redirect_to edit_account_path(@account)
    else
      flash.now[:alert] = "There was a problem updating your account."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @account.user.destroy
    redirect_to root_url
  end

  private

  def account_params
    params.require(:account).permit(:openrouter_key, :openai_key, :nickname).to_h
  end

  def set_account
    @account = Current.user.account
  end
end
