module TestHooks
  class LoginController < ApplicationController
    skip_before_action :authenticate_user!

    def login_student
      user = User.find_by(username: 'student') || FactoryBot.create(:user, :student)
      sign_in user
      head :no_content
    end

    def login_admin
      user = User.find_by(username: 'admin') || FactoryBot.create(:user, :admin)
      sign_in user
      head :no_content
    end
  end
end