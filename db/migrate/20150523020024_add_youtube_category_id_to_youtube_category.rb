class AddYoutubeCategoryIdToYoutubeCategory < ActiveRecord::Migration
  def change
    add_column :youtube_categories, :youtube_category_id, :integer
  end
end
