class InstagramPhoto < ActiveRecord::Base
  belongs_to :instagram_user
  belongs_to :microbe

  attr_accessible :instagram_photo_id, :latitude, :longitude, :image_url, :caption, :instagram_user_id, :created_time, :microbe_id
end
