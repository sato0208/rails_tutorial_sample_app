require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name:  "",
                                              email: "foo@invalid",
                                              password:              "foo",
                                              password_confirmation: "bar" } }

                                              assert_template 'users/edit'
                                              assert_select "div.alert", "The form contains 4 errors."
  end

  test "successful edit with friendly forwarding" do
    # edit_user_path(@user)にgetのリクエスト
    get edit_user_path(@user)
    # session[:forwarding_url]とedit_user_url(@user)が等しい時にtrue
    assert_equal session[:forwarding_url], edit_user_url(@user)
    # @userとしてログイン
    log_in_as(@user)
    # edit用のテンプレートはリダイレクトで描画されるので下記一文は削除
    # assert_template 'users/edit'
    # session[:forwarding_url]がnilの時true
    assert_nil session[:forwarding_url]
    # @userのユーザー編集ページにリダイレクトされる
    assert_redirected_to edit_user_url(@user)
    # nameに"Foo Bar"を代入
    name  = "Foo Bar"
    # emailに"foo@bar.com"を代入
    email = "foo@bar.com"
    # 有効なparams:を持ったuser_path(@user)でpatch（更新）のリクエスト
    patch user_path(@user), params: { user: { name:  name,
                                              email: email,
                                              password:              "",
                                              password_confirmation: "" } }
・