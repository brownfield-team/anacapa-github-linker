class ApplicationController < ActionController::Base
  include Rails::Pagination

  protect_from_forgery with: :exception
  before_action :authenticate_user!

  # handle unauthorized access messages
  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden, content_type: 'text/html' }
      format.html { redirect_to main_app.root_url, alert: exception.message }
      format.js   { head :forbidden, content_type: 'text/html' }
    end
  end

  def github_machine_user
    Octokit_Wrapper::Octokit_Wrapper.machine_user
  end
end
