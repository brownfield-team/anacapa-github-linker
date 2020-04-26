class UsersController < ApplicationController

  load_and_authorize_resource
  def index
    respond_to do |format|
      format.html { }
      format.json {
        @users = User.all
        unless params[:search].nil?
          @users = @users.where("users.name ~* ?", params[:search]).or(User.where("users.username ~* ?", params[:search]))
        end
        unless params[:type].nil?
          @users = User.users_with_role(@users, params[:type])
        end
        paginate json: @users.distinct
      }
    end
  end

  def update
    @user = User.find(params[:id])
    @user.change_role(params[:role]) if params[:role].present?
    respond_to do |format|
      format.html {
        redirect_to users_path
      }
      format.json {
        head :no_content
      }
    end

  end

    # private
    #     def user_params
    #         params.require(:user).permit(:roles)
    #     end
end
