class InstagramUserController < ApplicationController

  def index # also leaderboard
    @sorted_users = InstagramUser.order("score DESC").limit(5)
  end

  def show
    @user = InstagramUser.find( params[:id] )
    @mapped_photos = InstagramPhoto.where( :instagram_user_id => params[:id] )
    @recent_photos = @mapped_photos.order("created_time DESC").limit(6)
    @mapped_photos = ActiveSupport::JSON.encode(@mapped_photos.all)
  end

end
