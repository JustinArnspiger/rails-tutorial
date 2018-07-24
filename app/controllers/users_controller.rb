class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :index, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: [:destroy]

  def create
    @user = User.new(user_params)
    if @user.save
      # Saved successfully
      log_in @user
      flash[:success] = "You have signed up successfully!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def destroy
    user_to_destroy = User.find(params[:id])
    name = user_to_destroy.name
    user_to_destroy.destroy
    flash[:success] = "#{name} deleted"
    redirect_to users_url
  end

  def edit
    @user = User.find(params[:id])
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      # Successful update!
      flash[:success] = "Your profile has been updated!"
      redirect_to @user
    else
      # Unsuccessful update!
      render 'edit'
    end
  end

  private

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless @user == current_user
    end

    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in!"
        redirect_to login_url
      end
    end

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

end
