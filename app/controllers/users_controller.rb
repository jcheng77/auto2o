class UsersController < ApplicationController


  before_action :authenticate_user!, except: [:new, :register]

  def new
    @user = User.new
  end

  def register
    # only:  c d e f h k p x y
    generated_password = SecureRandom.urlsafe_base64(18).downcase.tr!("-_a0ob6gq9i1jlrmnt7uvwz25348", "").first(4)
    Rails.logger.info("PASSWORD:::::::::::#{generated_password}") if Rails.env.development?
    @user = User.new(user_params.merge(password: generated_password, email: "fake_mail@#{user_params["phone"]}.com"))
    respond_to do |format|
      if @user.save
        format.html { redirect_to user_session_path, notice: "密码已发给手机号#{user_params['phone']}，请用收到的密码登录。" }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:phone)
  end

end
