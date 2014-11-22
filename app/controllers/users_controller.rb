class UsersController < ApplicationController


  before_action :authenticate_user!, except: [:new, :register, :reset_pwd]
  before_action :find_user, only: [:show]

  def new
    @user = User.new
  end

  def register
    generated_password = Cipher.gen
    @user = User.new(user_params.merge(password: generated_password, email: "fake_mail@#{user_params["phone"]}.com"))
    respond_to do |format|
      if @user.save
        Sms.password(user_params['phone'], generated_password)
        format.html { redirect_to user_session_path, notice: "密码已发给手机号#{user_params['phone']}，请用收到的密码登录。" }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def reset_pwd
    return :bad_request unless params[:user][:phone]
    return :not_found unless (@user = User.where(phone: params[:user][:phone]).first)
    generated_password = Cipher.gen
    @user.password = generated_password
    respond_to do |format|
      if @user.save
        Sms.password(params[:phone], generated_password)
        format.html { redirect_to user_session_path, notice: "密码已发给手机号#{params[:user][:phone]}，请用收到的密码登录。" }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end


  def show
    respond_to do |format|
      format.html
      format.json { render json: @user }
    end
  end

  private

  def user_params
    params.require(:user).permit(:phone)
  end

  def find_user
    @user = User.find(params[:id])
  end

end
