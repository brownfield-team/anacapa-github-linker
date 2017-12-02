class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # should have a method for each provider
  def github
    @user = User.from_omniauth(request.env["omniauth.auth"])
    sign_in @user
    redirect_to "/courses"
  end

  # def failure
  #   redirect_to root_path
  # end

end