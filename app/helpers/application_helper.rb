module ApplicationHelper
  
  def title
    title = "Check-in System"
    if user_signed_in?
      title = current_user.user.name
      title += " Admin" if current_user.is_admin?
    end 
    title
  end
  
  def user_class(user)
    user.me?(current_user) ? 'current' : ''
  end
  
  def avatar(user)
    image_tag user.avatar_url(:thumb) if user.avatar?
    # if user.avatar?
    #   image_tag user.avatar_url(:thumb)
    # elsif user.gender == 'Mr'
    #   image_tag '/images/man_avatar.png'
    # else
    #   image_tag '/images/woman_avatar.png'
    # end
  end
  
  
end
