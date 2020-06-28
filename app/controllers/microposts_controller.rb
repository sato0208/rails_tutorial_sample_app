class MicropostsController < ApplicationController
    # 直前にlogged_in_userメソッド（ApplicationController）を実行 :create, :destroyアクションにのみ適用
    before_action :logged_in_user, only: [:create, :destroy]

    def create
      @micropost = current_user.microposts.build(micropost_params)
      if @micropost.save
        flash[:success] = "Micropost created!"
        redirect_to root_url
      else
        @feed_items = []
        render 'static_pages/home'
      end
    end

    def destroy
    end

    private

      def micropost_params
        params.require(:micropost).permit(:content)
      end
  end