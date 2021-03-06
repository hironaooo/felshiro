class UsersController < ApplicationController
  before_action :require_login, except: [:new, :create]
  before_action :correct_user,   only: [:edit, :update]
  
  def index
    @users = User.paginate(page: params[:page], per_page: 12)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Successfully create a account."
      redirect_to root_url
    else
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Successfully updated profile."
      redirect_to @user 
    else
      render 'edit'
    end
  end

  private
  def user_params
    params.require(:user).permit(:name,:email,:password,:password_confirmation,:picture)
  end

  def require_login
    unless logged_in?
      flash[:info] = "Please login to gain access."
      redirect_to login_url
    end
  end

  def correct_user
    @user = User.find(params[:id])
    unless current_user?(@user)
      flash[:danger] = "You don't have authority to edit other users."
      redirect_to(root_url) 
    end
  end

end

