class InstagramUserController < ApplicationController

  def index # also leaderboard
    @users = InstagramUser.order("score DESC").all
  end

  def show
    @user = InstagramUser.where( "username = ?", params[:username] ).first
    @mapped_photos = InstagramPhoto.where( :instagram_user_id => @user.id )
    @recent_photos = @mapped_photos.order("created_time DESC").all
    @mapped_photos = ActiveSupport::JSON.encode(@mapped_photos.all)
  end

end
