class AddRefsToMovie < ActiveRecord::Migration
  def change
    add_reference :movies, :category, null: false, index: true
    add_reference :movies, :user, null: false, index: true
  end
end
