class CreateGroupInvitationStatuses < ActiveRecord::Migration
  def change
    create_table :group_invitation_statuses do |t|
      t.string :name

      t.timestamps
    end
  end
end
