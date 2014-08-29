class DealersController < ApplicationController


  before_action :authenticate_user!, except: [:new, :register]

  def index
    @dealers = Dealer.all
  end

  def show
  end

  def new
    @dealer = Dealer.new
  end

  def register
    # only:  c d e f h k p x y
    generated_password = SecureRandom.urlsafe_base64(18).downcase.tr!("-_a0ob6gq9i1jlrmnt7uvwz25348", "").first(4)
    Rails.logger.info("PASSWORD:::::::::::#{generated_password}") if Rails.env.development?
    @dealer = Dealer.new(dealer_params.merge(password: generated_password, email: "fake_mail@#{dealer_params["phone"]}.com"))
    respond_to do |format|
      if @dealer.save
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

end
