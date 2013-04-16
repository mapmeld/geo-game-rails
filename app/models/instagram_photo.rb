class InstagramPhoto < ActiveRecord::Base
  belongs_to :instagram_user

  attr_accessible :instagram_id, :latitude, :longitude
end
