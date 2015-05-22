class RemoveColumnsFromRelation < ActiveRecord::Migration
  def change
    remove_column :relations, :good_count, :integer
    remove_column :relations, :bad_count, :integer
  end
end
