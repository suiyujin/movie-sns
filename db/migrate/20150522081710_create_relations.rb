class CreateRelations < ActiveRecord::Migration
  def change
    create_table :relations do |t|
      t.integer :good_count, null: false, default: 0
      t.integer :bad_count, null: false, default: 0
      t.float :similarity, null: false, default: 0.0
      t.references :movie1, null: false, index: true
      t.references :movie2, null: false, index: true
      t.references :user, null: false, index: true

      t.timestamps
    end
  end
end
