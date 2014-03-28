class CreateGroupsTagsJoinTable < ActiveRecord::Migration
  def change
    create_table :groups_tags, id: false do |t|
      t.integer :group_id
      t.integer :tag_id
    end
  end
end
