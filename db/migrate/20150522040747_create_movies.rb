class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string :movie_id
      t.string :title
      t.string :description
      t.string :url
      t.string :thumbnail_url
      t.string :thumbnail_path

      t.timestamps
    end
  end
end
