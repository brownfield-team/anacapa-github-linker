module CoursesHelper
  def get_courses_for(user) 
    if user.has_role? :user 
      return user.courses
    else 
      return user.courses + Course.order("name").select{ |course| user.ability.can? :manage, course }
    end
  end
end
