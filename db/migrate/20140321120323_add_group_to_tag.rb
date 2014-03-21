class AddGroupToTag < ActiveRecord::Migration
  def change
    add_reference :tags, :group, index: true
  end
end
