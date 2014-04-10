class GroupInvitation < ActiveRecord::Base
  belongs_to :group
  belongs_to :user
  belongs_to :group_invitation_status
  
  validates :group_invitation_status, presence: true
  
  validates_uniqueness_of :user, scope: :group, conditions: -> {where(group_invitation_status: GroupInvitationStatus.pending)}
  
  def is_owner?(user)
    self.user == user
  end
end
