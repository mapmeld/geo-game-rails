class HomeController < ApplicationController
  include ApplicationHelper

  def trigger_instagram( microbes=nil )
    if microbes.nil?
      microbes = Microbe.all
    end

    microbes.each do |microbe|
      fetch_from_instagram(microbe)
    end
    ApplicationHelper.finished_instagram_load
  end

  def index
    #@microbes = Rails.cache.read("AllMicrobes")
    #if @microbes.nil?
    #  @microbes = Microbe.all
    #  Rails.cache.write("AllMicrobes", @microbes)
    #end

    @microbes = Microbe.all

    if ApplicationHelper.next_load_instagram < Time.now
      trigger_instagram(@microbes)
    end


    @mapped_photos = InstagramPhoto.all
    @mapped_photos = ActiveSupport::JSON.encode(@mapped_photos)

  end

  def score_of( latlng, microbe_type )
    closest = InstagramPhoto.where( :microbe_id => microbe_type ).find_closest( :origin => latlng )
    if closest.nil?
      # first bacteria of this type: 10 points
      10
    else
      neardist = closest.distance_to( latlng )
      # nearest_photos = InstagramPhoto.where( :microbe_id => microbe_type ).find_within(2, :origin => latlng)
      if neardist < 0.007
        # too close - zero points
        0
      elsif neardist > 100
        # too far - one point
        1
      else
        # function
        10 / ( 3 * neardist + 0.333 )
      end
    end
  end

  def fetch_from_instagram( microbe, earliest_tag_id=nil, page=0 )

    earliest_tag_id = nil

    if page.nil?
      photos = Instagram.tag_recent_media(microbe.tag)
    else
      photos = Instagram.tag_recent_media(microbe.tag, { :max_tag_id => page })
    end

    # store photos until you reach an already-known photo
    finished = false
    photos.each do |photo|
      finished = store_instagram_photo(photo, microbe)
      break if finished

      if earliest_tag_id.nil?
        earliest_tag_id = photo.id
      else
        earliest_tag_id = [ earliest_tag_id, photo.id ].min
      end
    end

    # if these 20 images did not match any in the DB, go to the next page
    # unless we are on the tenth page; that's time to stop

    if finished == false and page < 10 and photos.length >= 15
      fetch_from_instagram( microbe, earliest_tag_id, page + 1 )
    end
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
            :score => [ 10, score_of( [ photo.location.latitude, photo.location.longitude ], microbe.id ) ].max
          )
          known_user.save!
          #puts known_user
        else
          #increment user score
          near = score_of( [ photo.location.latitude, photo.location.longitude ], microbe.id )
          puts near
          known_user.score = known_user.score + near.ceil
          known_user.save!
        end
        # now that user exists in DB, create the photo
        photo.caption = photo.caption or { :text => "" }
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
