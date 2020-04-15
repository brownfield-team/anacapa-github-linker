class UsersController < ApplicationController

  load_and_authorize_resource
  def index
    users = User.all
    unless params[:search].nil?
      users = users.where("name ~* ?", params[:search]).sort_by(&:name)
    end
    unless params[:type].nil?
      users = users.select { |u| u.has_role? params[:type] }
    end
    @users = Kaminari.paginate_array(users).page params[:page]
  end

  def update
    # TODO: Rewrite this update method. It is poorly designed and possible vulnerable to attack.
    @user = User.find(params[:id])
    if params[:commit].include? "Admin"
      @user.change_admin_status
    end
    if params[:commit].include? "Instructor"
      @user.change_instructor_status
    end
    redirect_to users_path
  end


    # private
    #     def user_params
    #         params.require(:user).permit(:roles)
    #     end
end
