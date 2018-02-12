class UsersController < ApplicationController
  load_and_authorize_resource
  def index
    @users = User.all
  end

  def update
    @user = User.find(params[:id])
    @user.reassign_role(params[:user][:roles])
    redirect_to users_path
  end

    # private
    #     def user_params
    #         params.require(:user).permit(:roles)
    #     end
end
