class HomeController < ApplicationController
  include ApplicationHelper
  caches_action :index

  def index

    # just in case our scheduled pingdom request failed
    # if ApplicationHelper.next_load_instagram < Time.now
    #   refresh_photos
    # end

    @microbes = ApplicationHelper.microbes
    @mapped_photos = ActiveSupport::JSON.encode(InstagramPhoto.all)
  end

  def refresh_photos
    ApplicationHelper.fetch_all_photos
    redirect_to '/'
  end

end