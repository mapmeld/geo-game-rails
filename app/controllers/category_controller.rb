class CategoryController < ApplicationController

  def show
    @category = Category.where( "tag = ?", params[ :tag ] ).first

    @category_photos = InstagramPhoto.select("instagram_photos.*, instagram_users.username, categories.tag")
                               .joins("JOIN instagram_users on instagram_users.id = instagram_photos.instagram_user_id")
                               .joins("JOIN categories on categories.id = instagram_photos.category_id")
                               .where( :category_id => @category.id )
    @mapped_photos = ActiveSupport::JSON.encode( @category_photos )
  end

end
