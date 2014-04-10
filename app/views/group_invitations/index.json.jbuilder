json.array!(@group_invitations) do |group_invitation|
  json.extract! group_invitation, :id, :group_id, :user_id
  json.url group_invitation_url(group_invitation, format: :json)
end
