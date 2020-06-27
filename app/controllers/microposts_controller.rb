class MicropostsController < ApplicationController
    # 直前にlogged_in_userメソッド（ApplicationController）を実行　:create, :destroyアクションにのみ適用
    before_action :logged_in_user, only: [:create, :destroy]
  
    def create
    end
   
    def destroy
    end
end