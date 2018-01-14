module ApplicationHelper
  def github_profile_img_for(user, height=20, width=20)
    image_tag(
      "https://avatars2.githubusercontent.com/u/#{user.uid}?v=3&amp;s=40",
      height: "#{height}",
      width: "#{width}",
      alt: "@#{user.username}",
      class: 'avatar'
    )
  end

  def rolename
    if current_user.has_role? :admin
      "admin"
    elsif current_user.has_role? :instructor
      "instructor"
    elsif current_user.has_role? :user 
      "user"
    else 
      "unidentified role"
    end
  end
end
