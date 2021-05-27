require 'test_helper'

class JobResultTest < ActiveSupport::TestCase

    setup do
        @sampleResult = JobResult.new
        @a = JobResult.new(3,2,1)
        @b = JobResult.new(12,5,6)
    end

    test "constructor initializes counts to zero" do
        assert @sampleResult.total == 0
        assert @sampleResult.created == 0
        assert @sampleResult.updated == 0
    end

    test "all_good? works on initial object" do
        assert @sampleResult.all_good?
    end

    test "add method works" do
        jr = JobResult.new
        jr.add(3,2,1)
        assert jr.total == 3
        assert jr.created == 2
        assert jr.updated == 1
        jr.add(5,1,1)
        assert jr.total == 8
        assert jr.created == 3
        assert jr.updated == 2
    end

    test "+ method works" do
        c = @a + @b
        assert c.total == 15
        assert c.created == 7
        assert c.updated == 7
    end

    test "all_good? works when true" do
        assert @a.all_good?
    end

    test "all_good? works when false" do
        assert !@b.all_good?
    end

    test "report a" do
        assert_equal @a.report, "Job Completed Successfully.<br />        Retrieved 3 items. Created 2, Updated 1 in database"
    end

    test "report b" do
        assert_equal @b.report, "Job Completed with errors; CHECK LOG; note that total items retrieved does NOT MATCH number created + updated.<br />        Retrieved 12 items. Created 5, Updated 6 in database"        
    end

end
  