json.extract! course, :id, :name, :course_organization, :created_at, :updated_at
json.url course_url(course, format: :json)
