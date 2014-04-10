class GroupInvitationStatus < ActiveRecord::Base
  has_many :group_invitations
  
  def self.pending
    self.where(name: "pending").first     
  end
  
  def self.accepted
    self.where(name: "accepted").first    
  end
  
  def self.refused
    self.where(name: "refused").first    
  end
end
