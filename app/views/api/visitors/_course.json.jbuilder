json.extract! course, :id, :name, :course_organization
json.user_enrolled RosterStudent.where(course: course, user: current_user, enrolled: true).count > 0
json.can_read can? :read, course
json.can_manage can? :manage, course
json.path course_path(course)
json.join_path course_join_path(course)