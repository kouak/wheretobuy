# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def show_horizontal_ad?
    false
  end
  
  def delete_button(path, *args)
    opts = {
      :method => :delete,
      :class => "delete",
      :confirm => "Are you sure?"
    }
    button_to('X', path, opts)
  end
end
