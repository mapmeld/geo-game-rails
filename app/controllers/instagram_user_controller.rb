class InstagramUserController < ApplicationController

  def index # also leaderboard
    @sorted_users = InstagramUser.order("score DESC").limit(5)
  end

  def show
    @user = InstagramUser.find( params[:id] )
    @mapped_photos = InstagramPhoto.where( :instagram_user_id => params[:id] ).all
    @mapped_photos = ActiveSupport::JSON.encode(@mapped_photos)
  end

end
