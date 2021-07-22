json.extract! course, :id, :name, :course_organization, :created_at, :updated_at, :term, :school, :hidden
json.path course_path(course)
json.edit_path edit_course_path(course)
