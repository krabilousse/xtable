class UserRole < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  belongs_to :role
end
