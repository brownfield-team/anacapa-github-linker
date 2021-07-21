class RepoCommitEvent < HookEventRecord
  belongs_to :roster_student,  optional: true

  def event_type
    'Commit'
  end

  def roster_student_for_commit(course)
    rs = course.student_for_github_username(self.author_login)
    rs = course.student_for_orphan_name(self.author_name) if rs.nil?  
    rs = course.student_for_orphan_email(CGI.unescape(self.author_email)) if rs.nil?
    rs
  end

  def fix_orphan_commit(course)
    self.roster_student = roster_student_for_commit(course)
    self.save!
  end

end