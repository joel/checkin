module ApplicationHelper

  def title
    title = "Check-in System"
    if user_signed_in?
      title = current_user.name
      title += " Admin" if current_user.is_admin?
    end
    title
  end

  def user_class(user)
    user.me?(current_user) ? 'current' : ''
  end

  def avatar(user)
    # image_tag user.avatar_url(:thumb) if user.avatar?
    if user.avatar?
      image_tag user.avatar_url(:thumb)
    elsif user.gender == 'Mr'
      image_tag 'man_avatar.jpeg'
    else
      image_tag 'woman_avatar.jpeg'
    end
  end

  # def content(name)
  #  content_for name do
  #    capture_haml do
  #      haml_tag "div", { :id => name.to_s } do
  #        haml_tag "div", { :id => "#{name.to_s}_group" } do
  #          yield
  #        end
  #      end
  #    end
  #  end
  # end

  def tb_check_box
    haml_tag :div, :class => "input" do
      haml_tag :ul, :class => "inputs-list" do
        haml_tag :li do
          yield
        end
      end
    end
  end

end
