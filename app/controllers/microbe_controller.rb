class MicrobeController < ApplicationController

  def show
    @microbe = Microbe.where( "tag = ?", params[ :tag ] ).first
    @mapped_photos = InstagramPhoto.where( :microbe_id => @microbe.id )
    @mapped_photos = ActiveSupport::JSON.encode( @mapped_photos )
  end

end
