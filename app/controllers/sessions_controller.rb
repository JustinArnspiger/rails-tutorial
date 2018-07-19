class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # Successful login.
      log_in user
      redirect_to user
    else
      # Unsuccessful login.
      flash.now[:danger] = 'Invalid email/password combination!'
      render 'new'
    end
  end

  def destroy
    log_out
    flash.now[:success] = 'You have successfully logged out.'
    redirect_to root_url
  end

  private

    #def session_params
    #  params.require(:session).permit(:email, :password)
    #end
end
