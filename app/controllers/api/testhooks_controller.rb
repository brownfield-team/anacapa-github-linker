module Api
    class TesthooksController < ApplicationController
        respond_to :json
        before_action :require_test_mode
        skip_before_action :authenticate_user!

        def login_student
            begin
                user = User.where({username: "student"}).first
            rescue
                user = FactoryBot.create("user","student") 
            end 
            sign_in user
            response = {
                env: Rails.env,
                status: "signed in",
                user: user
            }
            logger.debug "response: #{response}"
            respond_with response
        end

        def login_admin
            begin
                admin = User.where({username: "admin"}).first
            rescue
                admin = FactoryBot.create("user","admin") 
            end 
            sign_in admin
            response = {
                env: Rails.env,
                status: "signed in",
                user: admin
            }
            logger.debug "response: #{response}"
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