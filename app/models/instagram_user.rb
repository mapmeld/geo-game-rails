class InstagramUser < ActiveRecord::Base
  has_many :instagram_photos

  attr_accessible :instagram_id, :username, :profile_picture, :full_name, :score
end
