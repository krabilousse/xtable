class AddIsPrivateToGroup < ActiveRecord::Migration
  def change
    add_column :groups, :isPrivate, :boolean
  end
end
