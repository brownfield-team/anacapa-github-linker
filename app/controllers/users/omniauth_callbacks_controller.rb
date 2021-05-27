class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # should have a method for each provider
  def github
    @user = User.from_omniauth(request.env["omniauth.auth"])
    create_session_octokit(request.env["omniauth.auth"])
    sign_in @user
    redirect_to "/"
  end

  private

    def create_session_octokit(auth)
      token = auth.credentials.token
      session[:token] = token
      client = Octokit::Client.new :access_token => token
      session[:user_emails] = client.emails
    end

  # def failure
  #   redirect_to root_path
  # end

end