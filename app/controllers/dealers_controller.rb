class DealersController < ApplicationController


  before_action :authenticate_user!, except: [:new, :register, :reset_pwd]
  skip_before_action :authenticate_user!, if: :dealer_login

  before_action :authenticate_dealer!, except: [:new, :register, :reset_pwd]
  skip_before_action :authenticate_dealer!, if: :user_login

  def index
    @dealers = Dealer.all
    @dealers = current_dealer.shop.dealers if current_dealer
  end

  def show
    @dealer = Dealer.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: @dealer }
    end
  end

  def new
    @dealer = Dealer.new
  end

  def register
    generated_password = Cipher.gen
    @dealer = Dealer.new(dealer_params.merge(password: generated_password, email: "fake_mail@#{dealer_params["phone"]}.com"))
    respond_to do |format|
      if @dealer.save
        Sms.password(dealer_params['phone'], generated_password)
        format.html { redirect_to dealer_session_path, notice: "密码已发给手机号#{dealer_params['phone']}，请用收到的密码登录。" }
        format.json { render :show, status: :created, location: @dealer }
      else
        format.html { render :new }
        format.json { render json: @dealer.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def reset_pwd
    return(head(:bad_request)) unless params[:dealer][:phone]
    return(head(:not_found))   unless (@dealer = Dealer.where(phone: params[:dealer][:phone]).first)
    generated_password = Cipher.gen
    @dealer.password = generated_password
    respond_to do |format|
      if @dealer.save
        Sms.password(params[:phone], generated_password)
        format.html { redirect_to dealer_session_path, notice: "密码已发给手机号#{params[:dealer][:phone]}，请用收到的密码登录。" }
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
