require_relative '../test_helper'

class AdminLoginHelper
    include Devise::Test::IntegrationHelpers

    setup do
        @user = users(:wes)
    end

end