class CreateGroupInvitations < ActiveRecord::Migration
  def change
    create_table :group_invitations do |t|
      t.references :group, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
