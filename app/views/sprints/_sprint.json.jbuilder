json.extract! sprint, :id, :name, :start_date, :end_date, :course_id, :created_at, :updated_at
json.url course_sprint_url(course, sprint, format: :json)
