module PermissionsHelper
  def can_edit?(resource, requester = current_user)
    case resource
    when Brand
      true
    when User
      true
    else
      true
    end
  end
  
  
end