class UsersController < ApplicationController


  before_action :authenticate_user!, except: [:new, :register]

  def new
    @user = User.new
  end

  def register
    # only:  c d e f h k p x y
    generated_password = SecureRandom.urlsafe_base64(18).downcase.tr!("-_a0ob6gq9i1jlrmnt7uvwz25s348", "").first(4)
    Rails.logger.info("PASSWORD:::::::::::#{generated_password}") if Rails.env.development?
    @user = User.new(user_params.merge(password: generated_password, email: "fake_mail@#{user_params["phone"]}.com"))
    respond_to do |format|
      if @user.save
        company = "紫薯"
        template_value = CGI::escape "#code#=#{generated_password}&#company#=#{company}"
        url = "http://v.juhe.cn"                                                                  <<
              "/sms/send?"                                                                        <<
              "mobile=#{user_params["phone"]}"                                                    <<
              "&tpl_id=513"                                                                       <<
              "&tpl_value=#{template_value}"                                                      <<
              "&key=b837cf1fbc2809288678f954c679495b"
        Typhoeus.post(url, body: {})
        format.html { redirect_to user_session_path, notice: "密码已发给手机号#{user_params['phone']}，请用收到的密码登录。" }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @user = User.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: @user }
    end
  end

  private

  def user_params
    params.require(:user).permit(:phone)
  end

end
