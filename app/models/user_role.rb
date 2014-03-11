class UserRole < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  has_one :role
end
