class InstagramPhoto < ActiveRecord::Base
  belongs_to :instagram_user
  belongs_to :category

  attr_accessible :instagram_photo_id, :latitude, :longitude, :image_url, :caption, :instagram_user_id, :created_time, :category_id, :score, :likes

  acts_as_mappable :lat_column_name => :latitude, :lng_column_name => :longitude
end
