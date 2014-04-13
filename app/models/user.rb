class User < ActiveRecord::Base

  has_many :user_roles, dependent: :destroy
  has_and_belongs_to_many :events, -> { uniq }
  
  has_many :groups, :through => :user_roles
  has_many :roles, :through => :user_roles
  has_many :events, :through => :groups, dependent: :destroy  
  
  has_many :group_invitations, dependent: :destroy
  

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook, :github, :google_oauth2]
 

  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_create do |user|
        user.provider = auth.provider
        user.uid = auth.uid
        user.email = auth.info.email
        user.password = Devise.friendly_token[0,20]
        user.name = auth.info.name   # assuming the user model has a name
        user.image = auth.info.image # assuming the user model has an image
    end
  end  
    
  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.user_attributes"] && session["devise.user_attributes"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end    
  end
  
  def pending_group_invitations
    group_invitations.where(group_invitation_status: GroupInvitationStatus.pending)
  end
  
  def accepted_group_invitations
    group_invitations.where(group_invitation_status: GroupInvitationStatus.accepted)
  end
  
  def refused_group_invitations
    group_invitations.where(group_invitation_status: GroupInvitationStatus.refused)
  end
  
  def is_in_group?(group)
    groups.include?(group)
  end
  
  def private_group
    groups.first
  end
  
  def create_user_bound_group
    g = Group.new
    g.name = self.name + " _private"
    ur = UserRole.new
    ur.user = self
    ur.group = g
    ur.role = Role.where(name: 'Admin').first
    ur.save
    g.save
  end  
  
  after_create :create_user_bound_group
end
