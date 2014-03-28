class RemoveGroupReferenceFromTag < ActiveRecord::Migration
  def change
    remove_reference :tags, :group
  end
end
