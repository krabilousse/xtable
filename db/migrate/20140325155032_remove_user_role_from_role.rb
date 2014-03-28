class RemoveUserRoleFromRole < ActiveRecord::Migration
  def change
    remove_reference :roles, :user_role
  end
end
