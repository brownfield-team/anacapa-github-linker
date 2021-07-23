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
        orphan.fix_orphan_commit(@course)
      end
    end

   
end