module PermissionsHelper
  def can_edit?(resource, requester = current_user)
    case resource
    when Brand
      true
    when User
      true
    when Comment
      resource.try(:author) && resource.try(:author) == requester
    else
      true
    end
  end
end