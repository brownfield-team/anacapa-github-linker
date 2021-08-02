class JobResult
    
    def initialize(total=0,created=0,updated=0,excluded=0)
        @total = total
        @created = created
        @updated = updated
        @excluded = excluded
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

    def excluded
        @excluded
    end

    def add(total, created, updated, excluded)
        @total += total
        @created += created
        @updated += updated
        @excluded += excluded
        self
    end

    def all_good?
        @total == @created + @updated  + @excluded
    end

    def report
        job_outcome = all_good? ? "Successfully" : "with errors; CHECK LOG; note that total items retrieved does NOT MATCH number created + updated + excluded"
        "Job Completed #{job_outcome}.<br />        Retrieved #{@total} items. Created #{@created}, Updated #{@updated}, Excluded #{@excluded} in database"
    end

    def +(obj) 
        result = JobResult.new
        result.add(
            self.total + obj.total,
            self.created + obj.created,
            self.updated + obj.updated,
            self.excluded + obj.excluded
        )
        result
    end

    def to_s
        "total: #{@total} created: #{@created} updated: #{@updated}"    
    end

end
    