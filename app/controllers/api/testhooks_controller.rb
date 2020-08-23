module Api
    class TesthooksController < ApplicationController
        respond_to :json
        before_action :require_test_mode
        skip_before_action :authenticate_user!

        def login_student
            user = FactoryBot.create("user","student")  
            sign_in user
            response = {
                env: Rails.env,
                status: "signed in",
                user: user
            }
            respond_with response
        end

        def login_admin
            admin = FactoryBot.create("user","admin")  
            sign_in admin
            response = {
                env: Rails.env,
                status: "signed in",
                user: admin
            }
            respond_with response
        end
        private
 
        def require_test_mode
            unless Rails.env=="test"
                response = {
                    env: Rails.env,
                    status: "invalid request"
                }
                respond_with response
            end
        end
    end
end