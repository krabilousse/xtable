class AddUserRoleInRole < ActiveRecord::Migration
  def change
    add_reference :roles, :user_role
  end
end
