module Api
    class TesthooksController < ApplicationController
        respond_to :json
        #load_and_authorize_resource
    
        def reset
          response = {
              rails_env: Rails.env
          }
          if Rails.env=='test'
            response['status'] = 'not implemented yet';
          else
            response['status'] = 'only valid in test mode';
          end
          respond_with response
        end
    end
end