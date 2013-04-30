class MicrobeController < ApplicationController

  def show
    @microbe = Microbe.where( "tag = ?", params[ :tag ] ).first

    @microbe_photos = InstagramPhoto.select("instagram_photos.*, instagram_users.username, microbes.tag")
                               .joins("JOIN instagram_users on instagram_users.id = instagram_photos.instagram_user_id")
                               .joins("JOIN microbes on microbes.id = instagram_photos.microbe_id")
                               .where( :microbe_id => @microbe.id )
    @mapped_photos = ActiveSupport::JSON.encode( @microbe_photos )
  end

end
