class AccountsController < ApplicationController
  before_action :set_account, only: %i[edit update destroy]

  def edit
    redirect_to root_path if @account.user != Current.user
  end

  def update
    @account.update(account_params)
  end

  def destroy
    @account.user.destroy
    redirect_to root_url
  end

  private

  def account_params
    params.require(:account).permit(:openrouter_key, :nickname).to_h
  end

  def set_account
    @account = Current.user.account
  end
end
