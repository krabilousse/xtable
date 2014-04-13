class Group < ActiveRecord::Base
  has_many :events
  has_and_belongs_to_many :tags
  has_many :user_roles
  has_many :users, :through => :user_roles
  
  validates :name, presence: true
  
  self.per_page=2
  
  def is_admin?(user)
    admin_role = Role.where(name: "Admin").first
    ur = user_roles.where(user: user, role: admin_role)
    
    ur.size > 0
  end
  
  def users_not_following(user)
    User.all - self.users - [user]
  end
  
  def add_follower(user)    
    begin
      self.add_user(user, "Follower")
      true           
    rescue
      false
    end    
  end
  
  def add_admin(user)
    begin
      self.add_user(user, "Admin")
      true      
    rescue
      false
    end
  end    
  
  def add_user(user, role_name)    
    role = Role.where(name: role_name).first    
    ur = UserRole.create(user: user, role: role, group: self)   
  end
  
  def get_admin
    adminRole = Role.where(name: 'Admin').first
    ur = UserRole.where(role: adminRole, group: self).first
    ur.user    
  end
    
end
