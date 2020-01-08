class UsersController < ApplicationController

  load_and_authorize_resource
  def index
    # @users = User.all
    unless params[:type].nil?
      # This very... different implementation of displaying the users when a filter parameter is added is due to the
      # way Rails converts a set of records to a traditional Ruby array when using the select method. Kaminari
      # requires this syntax when paginating a normal array.
      filtered_users = User.select{ |user| user.has_role? params[:type]}.sort_by(&:name)
      @users = Kaminari.paginate_array(filtered_users).page params[:page]
    else
      @users = User.order(:name).page params[:page]
    end
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
