class JobResult
    
    def initialize(total=0,created=0,updated=0)
        @total = total
        @created = created
        @updated = updated
    end

    def total
        @total
    end

    def created
        @created
    end

    def updated
        @updated
    end

    def add(total, created, updated)
        @total += total
        @created += created
        @updated += updated
        self
    end

    def all_good?
        @total == @created + @updated
    end

    def report
        job_outcome = all_good? ? "Successfully" : "with errors; CHECK LOG; note that total items retrieved does NOT MATCH number created + updated"
        "Job Completed #{job_outcome}.<br />        Retrieved #{@total} items. Created #{@created}, Updated #{@updated} in database"
    end

    def +(obj) 
        result = JobResult.new
        result.add(
            self.total + obj.total,
            self.created + obj.created,
            self.updated + obj.updated
        )
        result
    end

    def to_s
        "total: #{@total} created: #{@created} updated: #{@updated}"    
    end

end
    