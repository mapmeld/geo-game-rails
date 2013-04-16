class InstagramUser < ActiveRecord::Base
  has_many :instagram_photos

  attr_accessible :instagram_id, :name, :score
end
