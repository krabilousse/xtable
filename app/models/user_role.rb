class UserRole < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  belongs_to :role
  validates_uniqueness_of :user, :scope => :group
end
