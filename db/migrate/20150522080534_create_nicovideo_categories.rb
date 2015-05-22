class CreateNicovideoCategories < ActiveRecord::Migration
  def change
    create_table :nicovideo_categories do |t|
      t.string :name
      t.references :category, index: true
    end
  end
end
