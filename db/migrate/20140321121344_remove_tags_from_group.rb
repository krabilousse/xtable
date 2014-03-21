class RemoveTagsFromGroup < ActiveRecord::Migration
  def change
    remove_reference :groups, :tags
  end
end
