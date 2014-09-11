class DealersController < ApplicationController


  before_action :authenticate_user!, except: [:new, :register]
  skip_before_action :authenticate_user!, if: :dealer_login

  before_action :authenticate_dealer!, except: [:new, :register]
  skip_before_action :authenticate_dealer!, if: :user_login

  def index
    @dealers = Dealer.all
    @dealers = current_dealer.shop.dealers if current_dealer
  end

  def show
  end

  def new
    @dealer = Dealer.new
  end

  def register
    # only:  c d e f h k p x y
    generated_password = SecureRandom.urlsafe_base64(18).downcase.tr!("-_a0ob6gq9i1jlrmnt7uvwz25s348", "").first(4)
    Rails.logger.info("PASSWORD:::::::::::#{generated_password}") if Rails.env.development?
    @dealer = Dealer.new(dealer_params.merge(password: generated_password, email: "fake_mail@#{dealer_params["phone"]}.com"))
    respond_to do |format|
      if @dealer.save
        company = "紫薯"
        template_value = URI.encode "#code#=#{generated_password}&#company#=#{company}"
        url = "http://v.juhe.cn"                                                                  <<
              "/sms/send?"                                                                        <<
              "mobile=#{dealer_params["phone"]}"                                                  <<
              "&tpl_id=1"                                                                         <<
              "&tpl_value=#{template_value}"                                                      <<
              "&key=b837cf1fbc2809288678f954c679495b"
        Typhoeus.post(url, body: {})
        format.html { redirect_to dealer_session_path, notice: "密码已发给手机号#{dealer_params['phone']}，请用收到的密码登录。" }
        format.json { render :show, status: :created, location: @dealer }
      else
        format.html { render :new }
        format.json { render json: @dealer.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def dealer_params
    params.require(:dealer).permit(:phone)
  end

  def dealer_login
    current_dealer.present?
  end

  def user_login
    current_user.present?
  end

end
