class MicrobeController < ApplicationController

  def show
    @microbe = Microbe.find( params[ :id ] )
    @mapped_photos = InstagramPhoto.where( :microbe_id => params[ :id ] )
    @mapped_photos = ActiveSupport::JSON.encode( @mapped_photos )
  end

end
