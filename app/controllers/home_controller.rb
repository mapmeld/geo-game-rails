class HomeController < ApplicationController
  include ApplicationHelper
  caches_action :index

  def index

    # just in case our scheduled pingdom request failed
    # if ApplicationHelper.next_load_instagram < Time.now
    #   refresh_photos
    # end

    @microbes = ApplicationHelper.microbes
    @users = InstagramUser.order("score DESC")[0..2]
    all_photos = InstagramPhoto.select("instagram_photos.*, instagram_users.username, microbes.tag")
                               .joins("JOIN instagram_users on instagram_users.id = instagram_photos.instagram_user_id")
                               .joins("JOIN microbes on microbes.id = instagram_photos.microbe_id")
    @mapped_photos = ActiveSupport::JSON.encode(all_photos)

  end

  def refresh_photos
    ApplicationHelper.fetch_all_photos
    redirect_to '/'
  end

end