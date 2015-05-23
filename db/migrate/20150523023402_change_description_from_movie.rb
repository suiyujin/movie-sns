class ChangeDescriptionFromMovie < ActiveRecord::Migration
  def change
    change_column :movies, :description, :text
  end
end
