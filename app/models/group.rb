class Group < ActiveRecord::Base
  belongs_to :events
  belongs_to :tags
  has_many :user_roles
  has_many :users, :through => :user_roles
  
  self.per_page=2
end
