module UsersHelper
  def self.instructor_or_admin?(user)
    user.has_role?(:admin) || has_role_in_any_context?(user, "instructor")
  end

  # The Rolify has_role? method requires the course/course id to be provided to tell whether a user is an instructor.
  # This method is intended to bypass that limitation by checking if a user has a given role for any course/context.
  def self.has_role_in_any_context?(user, role_name)
    user.roles.each { |role| return true if role.name == role_name }
    false
  end
end
