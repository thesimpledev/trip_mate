class Api::SessionsController < ApplicationController
  def create
    @user = User.find_by_credentials(email, password)
    if @user
      login!(@user)
      render "api/users/show"
    else
      render json: ["Failed to login"], status: 422
    end
  end

  def destroy
    logout!
    render json: { message: "Successfully logged out" }
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end

  def email
    user_params[:email]
  end

  def password
    user_params[:password]
  end
end
