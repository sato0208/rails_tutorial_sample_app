class SessionsController < ApplicationController

  def new
  end

  def create
      # 送信されたメールアドレスを使って、データベースからユーザーを取り出す
    user = User.find_by(email: params[:session][:email].downcase)
      # ユーザーがデータベースにあり、かつ、認証に成功した場合にのみ
    if user && user.authenticate(params[:session][:password])
      # ユーザーログイン後にユーザー情報のページにリダイレクトする
    else
      # エラーメッセージを作成する
      render 'new'
    end
  end


  def destroy
  end
end