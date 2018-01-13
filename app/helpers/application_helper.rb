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
end
