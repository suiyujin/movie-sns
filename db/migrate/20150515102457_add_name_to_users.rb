class AddNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string, null: false, default: '名称未設定'
  end
end
