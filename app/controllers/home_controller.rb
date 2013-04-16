class HomeController < ApplicationController
  include ApplicationHelper

  def index
    @instagram_tags = [ "mbgeo", "mbrhizo", "mbbacs", "mbmyco", "mbshewa" ]

    @mapped_photos = [ ]

    @instagram_tags.each do |tag|
      photos = nil # Rails.cache.read(tag)
      if photos == nil
        photos = Instagram.tag_recent_media(tag)
        #Rails.cache.write(tag, photos, :timeToLive => 300.seconds)

        # store photos until you reach an already-known photo
        photos.each do |photo|
          break if store_instagram_photo(photo)
        end
      end
      @mapped_photos.concat( photos )
    end

    @mapped_photos = ActiveSupport::JSON.encode(@mapped_photos)
  end

  def store_instagram_photo(photo)
    known_photo = InstagramPhoto.where(:instagram_photo_id => photo.id).first
    if known_photo == nil
      # photo is new
      known_user = InstagramUser.where(:instagram_user_id => photo.user.id).first
      if known_user == nil
        # user is new
        known_user = InstagramUser.create([
          { instagram_user_id: photo.user.id, username: photo.user.username, profile_picture: photo.user.profile_picture, full_name: photo.user.full_name, score: 1 }
        ])
        puts known_user
      end
      # now that user exists in DB, create the photo
      gen_photo = InstagramPhoto.create([
        { instagram_photo_id: photo.id, created_time: photo.created_time, latitude: photo.location.latitude, longitude: photo.location.longitude, image_url: photo.images.low_resolution.url, caption: photo.caption.text }
      ])
      puts gen_photo
      false
    else
      # photo has been added before
      true
    end
  end
end