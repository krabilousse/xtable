class Group < ActiveRecord::Base
  has_many :events
  has_and_belongs_to_many :tags
  has_many :user_roles
  has_many :users, :through => :user_roles
  
  self.per_page=2
end
