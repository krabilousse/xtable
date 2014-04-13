class AddIsPersonalToGroup < ActiveRecord::Migration
  def change
    add_column :groups, :is_personal, :boolean, default: false
  end
end
