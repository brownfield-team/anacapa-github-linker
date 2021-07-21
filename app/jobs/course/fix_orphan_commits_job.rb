require 'json'
class FixOrphanCommitsJob < CourseJob
    @job_name = "Fix Orphan Commits"
    @job_short_name = "fix_orphan_commits"
    @job_description = "Try to match commits with a roster student"

    def attempt_job(options)
      @orphans = @course.orphans
      orphans_count_before = @orphans.count

      process_orphan_commits

      result_hash = {
        orphans_count_before: orphans_count_before,
        orphans_count_after: @course.orphans.count
      }
      "Done.  Results:<pre>#{JSON.pretty_generate(result_hash)}</pre>"
    end

    def process_orphan_commits
      @orphans.each do |orphan|
        process_orphan(orphan)
      end
    end

    def process_orphan(orphan)
        roster_student = @course.student_for_orphan_name(orphan.author_name)
        if roster_student.nil?
          roster_student = @course.student_for_orphan_email(orphan.author_email)
        end
        orphan.roster_student = roster_student
        orphan.save!
    end
end