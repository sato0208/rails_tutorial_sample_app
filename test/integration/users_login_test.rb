require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  test "login with invalid information" do
    # ログイン用のパスを開く
    get login_path
    # しいセッションのフォームが正しく表示されたことを確認する
    assert_template 'sessions/new'
    post login_path, params: { session: { email: "", password: "" } }
    # 新しいセッションのフォームが再度表示され、フラッシュメッセージが追加されることを確認する
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    # 移動先のページでフラッシュメッセージが表示されていないことを確認
    assert flash.empty?
  end
end