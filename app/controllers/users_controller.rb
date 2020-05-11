class UsersController < ApplicationController

  load_and_authorize_resource

  def index
    respond_to do |format|
      format.html {}
      format.json do
        @users = User.all
        search_query = params[:search]
        type_query = params[:type]
        unless search_query.nil? || search_query.empty?
          @users = @users.search(search_query)
        end
        unless type_query.nil? || type_query.empty?
          @users = User.users_with_role(@users, type_query)
        end
        paginate json: @users
      end
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
