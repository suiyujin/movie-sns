class CreateAjaxTests < ActiveRecord::Migration
  def change
    create_table :ajax_tests do |t|
      t.string :movie_id
      t.string :title
      t.string :description
      t.string :url
      t.string :thumbnail_url
      t.string :thumbnail_path
      t.references :user, index: true

      t.timestamps
    end
  end
end
