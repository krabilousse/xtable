class GroupInvitationStatus < ActiveRecord::Base
  has_many :group_invitations
  
  def self.pending
    self.where(name: "Pending").first     
  end
  
  def self.accepted
    self.where(name: "Accepted").first    
  end
  
  def self.refused
    self.where(name: "Refused").first    
  end
end
