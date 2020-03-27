require 'Octokit_Wrapper'
class Course < ApplicationRecord
  # validates :name,  presence: true,
  #                   length: { minimum: 3 }
  validates :name, presence: true, length: {minimum: 3}, uniqueness: true
  validates :course_organization, presence: true, length: {minimum: 3}, uniqueness: true
  validate :check_course_org_exists
  has_many :roster_students, dependent: :destroy
  has_many :completed_jobs, dependent: :destroy
  has_many :github_repos, dependent: :destroy
  has_many :org_teams, dependent: :destroy
  belongs_to :slack_workspace, dependent: :destroy

  resourcify

  def org
    return @org if @org or @no_org
    begin
      @org = Octokit_Wrapper::Octokit_Wrapper.machine_user.organization(course_organization)
    rescue Octokit::NotFound
      @no_org = true
      @org = nil
    end
  end

  def accept_invite_to_course_org
    Octokit_Wrapper::Octokit_Wrapper.machine_user.update_organization_membership(course_organization, {state: "active"})
  end

  def invite_user_to_course_org(user)
    unless Octokit_Wrapper::Octokit_Wrapper.machine_user.organization_member?(course_organization, user.username)
      Octokit_Wrapper::Octokit_Wrapper.machine_user.update_organization_membership(course_organization, {user: "#{user.username}", role: "member"})
    end
  end

  def check_course_org_exists
    # NOTE: this is run as a validation step on creation and update for the organization
    if org
      begin
        membership = Octokit_Wrapper::Octokit_Wrapper.machine_user.organization_membership(course_organization)
        unless membership.role == "admin"
          errors.add(:base, "You must add #{ENV['MACHINE_USER_NAME']} to your organization before you can proceed.")
        end
      rescue Octokit::NotFound
        errors.add(:base, "You must add #{ENV['MACHINE_USER_NAME']} to your organization before you can proceed.")
      end
    else
      errors.add(:base, "You must create a github organization with the name of your class and add #{ENV['MACHINE_USER_NAME']} as an owner of that organization.")
    end
  end

  def users
    return (self.roster_students.map {|student| student.user }).compact
  end

  # import roster students from a roster file provided by gradescope
  def import_students(file, header_map, header_row_exists)
    ext = File.extname(file.original_filename)
    spreadsheet = Roo::Spreadsheet.open(file, extension: ext)

    # get index for each param
    id_index = header_map.index("perm")
    email_index = header_map.index("email")
    first_name_index = header_map.index("first_name")
    last_name_index = header_map.index("last_name")
    full_name_index = header_map.index("full_name")

    unenroll_all_students

    # start at row 1 if header row exists (via checkbox)
    ((header_row_exists ? 2 : 1 )..spreadsheet.last_row).each do |i|

      spreadsheet_row = spreadsheet.row(i)

      row = {} # build dynaimically based on choices

      row["perm"] = spreadsheet_row[id_index]
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
      student = roster_students.find_by(perm: row["perm"]) ||
      roster_students.new

      student.enrolled = true
      student.perm = row["perm"]
      student.first_name = row["first_name"]
      student.last_name = row["last_name"]
      student.email = row["email"]
      student.save
    end
  end

  # export roster students to a CSV file
  def export_students_to_csv
    CSV.generate(headers: true) do |csv|
      csv << %w[studentId email first_name last_name github_username enrolled]

      roster_students.each do |user|
        csv << [
          user.perm,
          user.email,
          user.first_name,
          user.last_name,
          user.username,
          user.enrolled
        ]
      end
    end
  end

  def unenroll_all_students
    self.roster_students.each do |student|
      student.enrolled = false
      student.save
    end
  end

  
end
