class AddGroupInvitationStatusToGroupInvitation < ActiveRecord::Migration
  def change
    add_reference :group_invitations, :group_invitation_status, index: true
  end
end
