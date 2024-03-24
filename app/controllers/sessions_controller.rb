class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_to root_url
    else
      flash[:danger] = create_error_message(user, params[:session])
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def create_error_message(user, session)
    if params[:session][:email].blank? || params[:session][:password].blank?
        'ユーザーID,もしくはパスワードが未入力です'
      else
        'ユーザーIDとパスワードが一致するユーザーが存在しない' 
    end
  end
end
