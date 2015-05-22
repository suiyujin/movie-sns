class CreateYoutubeCategories < ActiveRecord::Migration
  def change
    create_table :youtube_categories do |t|
      t.string :name
      t.references :category, index: true
    end
  end
end
