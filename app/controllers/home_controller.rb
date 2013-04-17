class HomeController < ApplicationController
  include ApplicationHelper

  def index
    #@microbes = Rails.cache.read("AllMicrobes")
    #if @microbes.nil?
    #  @microbes = Microbe.all
    #  Rails.cache.write("AllMicrobes", @microbes)
    #end
    @microbes = Microbe.all

    @mapped_photos = InstagramPhoto.all
    @mapped_photos = ActiveSupport::JSON.encode(@mapped_photos)
  end

  def fetch_from_instagram
    #@instagram_tags = [ "mbgeo", "mbrhizo", "mbbacs", "mbmyco", "mbshewa" ]

    @microbes = Microbe.all

    #@mapped_photos = [ ]

    @microbes.each do |microbe|
      photos = nil # Rails.cache.read(microbe.tag)
      if photos.nil?
        photos = Instagram.tag_recent_media(microbe.tag)
        #Rails.cache.write(microbe.tag, photos, :timeToLive => 300.seconds)

        # store photos until you reach an already-known photo
        photos.each do |photo|
          break if store_instagram_photo(photo, microbe)
        end
      end
      #@mapped_photos.concat( photos )
    end

    #@mapped_photos = ActiveSupport::JSON.encode(@mapped_photos)
  end

  def store_instagram_photo(photo, microbe)
    unless photo.location.nil?
      known_photo = InstagramPhoto.where(:instagram_photo_id => photo.id).first
      if known_photo.nil?
        # photo is new
        known_user = InstagramUser.where(:instagram_id => photo.user.id).first
        if known_user.nil?
          # user is new
          known_user = InstagramUser.new(
            :instagram_id => photo.user.id,
            :username => photo.user.username,
            :profile_picture => photo.user.profile_picture,
            :full_name => photo.user.full_name,
            :score => 1
          )
          known_user.save!
          #puts known_user
        else
          #increment user score
          known_user.score = known_user.score + 1
          known_user.save!
        end
        # now that user exists in DB, create the photo
        gen_photo = InstagramPhoto.new(
          :instagram_photo_id => photo.id,
          :created_time => photo.created_time,
          :latitude => photo.location.latitude,
          :longitude => photo.location.longitude,
          :image_url => photo.images.low_resolution.url,
          :caption => photo.caption.text,
          :instagram_user_id => known_user.id,
          :microbe_id => microbe.id
        )
        gen_photo.save!
        #puts gen_photo
        false
      else
        # photo has been added before
        true
      end
    else
      # this photo did not have location, so keep looking for photos to store
      false
    end
  end
end
