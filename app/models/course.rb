class Course < ApplicationRecord
  # validates :name,  presence: true,
  #                   length: { minimum: 3 }
  validates :name, presence: true, length: {minimum: 3}, uniqueness: true
  validates :course_organization, presence: true, length: {minimum: 3}, uniqueness: true
  has_and_belongs_to_many :users
  has_many :roster_students
  resourcify


  def import_students(file, header_map, header_row_exists)
    ext = File.extname(file.original_filename)
    spreadsheet = Roo::Spreadsheet.open(file, extension: ext)
    
    # get index for each param
    id_index = header_map.index("student_id")
    email_index = header_map.index("email")
    first_name_index = header_map.index("first_name")
    last_name_index = header_map.index("last_name")
    full_name_index = header_map.index("full_name")

    # start at row 1 if header row exists (via checkbox)
    ((header_row_exists ? 2 : 1 )..spreadsheet.last_row).each do |i|

      spreadsheet_row = spreadsheet.row(i)

      row = {} # build dynaimically based on choices

      row["student_id"] = spreadsheet_row[id_index]
      row["email"] = spreadsheet_row[email_index]

      if first_name_index
        row["first_name"] = spreadsheet_row[first_name_index]
        row["last_name"] = spreadsheet_row[last_name_index]
      else
        name_arr = spreadsheet_row[full_name_index].split(" ") # this seems prone to bugs because last names are weird
        row["first_name"] = name_arr[0]
        row["last_name"] = name_arr[1]
      end

      next if row.values.all?(&:nil?) # skip empty rows

      # check if there is an existing student in the course or create a new one
      student = roster_students.find_by(perm: row["student_id"]) || roster_students.new
      student.perm = row["student_id"]
      student.first_name = row["first_name"]
      student.last_name = row["last_name"]
      student.email = row["email"]
      student.save!
    end
  end

  def export_students_to_csv
    CSV.generate(headers: true) do |csv|
      csv << %w[perm email first_name last_name github_username]

      roster_students.each do |user|
        csv << [
          user.perm,
          user.email,
          user.first_name,
          user.last_name,
          user.username
        ]
      end
    end
  end
end
