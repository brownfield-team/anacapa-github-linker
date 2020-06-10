class GithubWebhooksController
  class OrganizationHook
    def self.process_hook(course, payload)
      case payload[:action]
      when "member_invited"
        student = course.student_for_uid(payload[:invitation][:id])
        return if student.nil?
        student.org_membership_type = "Invited"
        student.save
      when "member_added"
        student = course.student_for_uid(payload[:membership][:user][:id])
        return if student.nil?
        student.is_org_member = true
        student.org_membership_type = payload[:membership][:role].capitalize
        student.save
      when "member_removed"
        student = course.student_for_uid(payload[:membership][:user][:id])
        return if student.nil?
        student.is_org_member = false
        student.org_membership_type = nil
        student.save
      when "renamed"
        course.course_organization = payload[:organization][:login]
        course.save
      else
        return
      end
    end
  end
end