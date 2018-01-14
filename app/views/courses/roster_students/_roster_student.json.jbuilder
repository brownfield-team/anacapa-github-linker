json.extract! roster_student, :id, :perm, :first_name, :last_name, :email, :created_at, :updated_at
json.url roster_student_url(roster_student, format: :json)
