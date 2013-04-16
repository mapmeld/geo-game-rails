class Microbe < ActiveRecord::Base
  has_many :instagram_photos

  attr_accessible :name, :tag
end
