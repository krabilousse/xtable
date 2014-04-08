class GroupInvitation < ActiveRecord::Base
  belongs_to :group
  belongs_to :user
  validates_uniqueness_of :user, :scope => :group
  
  def is_owner(user)
    self.user == user
  end
end
