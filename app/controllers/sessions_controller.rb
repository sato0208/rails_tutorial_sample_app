class SessionsController < ApplicationController

  def new
  end

  def create
      # 送信されたメールアドレスを使って、データベースからユーザーを取り出す
    user = User.find_by(email: params[:session][:email].downcase)
      # ユーザーがデータベースにあり、かつ、認証に成功した場合にのみ
    if user && user.authenticate(params[:session][:password])
      # ユーザーログイン後にユーザー情報のページにリダイレクトする
      log_in user
      remember user
      redirect_to user
    else
      # エラーメッセージを作成する
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end