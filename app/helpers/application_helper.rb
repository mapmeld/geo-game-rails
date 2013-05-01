module ApplicationHelper

  # on setup, load instagram photos
  @@next_load_instagram = Time.new(0)

  def self.next_load_instagram
    @@next_load_instagram
  end

  def self.finished_instagram_load
    @@next_load_instagram = Time.now + 10.minutes
  end

  def self.microbes
    @@microbes = Microbe.all
  end

  def self.fetch_all_photos
    microbes = ApplicationHelper.microbes

    microbes.each do |microbe|
      fetch_from_instagram(microbe)
    end

    recalculate_scores
    finished_instagram_load
  end

  def self.recalculate_scores
    photos = InstagramPhoto.order("created_time ASC").all
    known_users = { }
    photos.each do |photo|
      score = score_of( [ photo.latitude, photo.longitude ], photo.microbe_id, photo.id )
      unless photo.likes.nil?
        puts "adding likes: " + photo.likes.to_s
        score = score + photo.likes
      end
      unless known_users.has_key?(photo.instagram_user_id)
        score = [10, score].max
        # puts "first photo for user!"
        known_users[photo.instagram_user_id] = score
      else
        known_users[photo.instagram_user_id] += score
        # puts score
      end
      photo.score = score
      puts photo.id.to_s + " = " + score.to_s
      photo.save!
    end
    puts "users"
    known_users.each do | user_id, score |
      user = InstagramUser.find(user_id)
      user.score = score
      user.save!
      puts user_id.to_s + " = " + score.to_s
    end
  end

  def self.score_of( latlng, microbe_type, own_id=nil )
    closest = InstagramPhoto.where( :microbe_id => microbe_type)
    unless own_id.nil?
      closest = closest.where([ 'instagram_photos.id <> ?', own_id ])
    end
    closest = closest.find_closest( :origin => latlng )
    if closest.nil?
      # first bacteria of this type: 10 points
      #puts "first bacteria of this type!"
      10
    else
      neardist = closest.distance_to( latlng )
      # nearest_photos = InstagramPhoto.where( :microbe_id => microbe_type ).find_within(2, :origin => latlng)
      if neardist < 0.007
        # too close - zero points
        #puts "too close!"
        1
      elsif neardist > 100
        # too far - one point
        #puts "too far!"
        1
      else
        # function
        (10 / ( 3 * neardist + 0.333 )).ceil
      end
    end
  end

  def self.fetch_from_instagram( microbe, earliest_tag_id=nil, page=0 )
    earliest_tag_id = nil

    if page.nil?
      photos = Instagram.tag_recent_media(microbe.tag)
    else
      photos = Instagram.tag_recent_media(microbe.tag, { :max_tag_id => page })
    end

    # store photos until you reach an already-known photo
    photos.each do |photo|
      store_instagram_photo(photo, microbe)

      if earliest_tag_id.nil?
        earliest_tag_id = photo.id
      else
        earliest_tag_id = [ earliest_tag_id, photo.id ].min
      end
    end

    # if these 20 images did not match any in the DB, go to the next page
    # unless we are on the tenth page; that's time to stop

    if page < 10 and photos.length >= 15
      fetch_from_instagram( microbe, earliest_tag_id, page + 1 )
    end
  end

  def self.store_instagram_photo(photo, microbe)
    unless photo.location.nil?
      linkable_id = photo.link.split("/")[4]
      # puts linkable_id
      known_photo = InstagramPhoto.where(:instagram_photo_id => linkable_id).first
      if known_photo.nil?
        # photo is new
        known_user = InstagramUser.where(:instagram_id => photo.user.id).first
        if known_user.nil?
          # user is new
          known_user = InstagramUser.new(
            :instagram_id => photo.user.id,
            :username => photo.user.username,
            :profile_picture => photo.user.profile_picture,
            :full_name => photo.user.full_name
          )
          known_user.save!
          #puts known_user
        end
        # now that user exists in DB, create the photo
        photo.caption = photo.caption or { :text => "" }
        gen_photo = InstagramPhoto.new(
          :instagram_photo_id => linkable_id,
          :created_time => photo.created_time,
          :latitude => photo.location.latitude,
          :longitude => photo.location.longitude,
          :image_url => photo.images.low_resolution.url,
          :caption => photo.caption.text,
          :instagram_user_id => known_user.id,
          :microbe_id => microbe.id,
          :likes => photo.likes[ :count ]
        )
        gen_photo.save!
        #puts gen_photo
        false
      else
        # photo has been added before - check for new likes
        if known_photo.likes != photo.likes[ :count ]
          known_photo.likes = photo.likes[ :count ]
          puts "adjusted to " + photo.likes[ :count ].to_s
          known_photo.save!
        end
        true
      end
    else
      # this photo did not have location, so keep looking for photos to store
      false
    end
  end

end
