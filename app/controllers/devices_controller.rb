class DevicesController < InheritedResources::Base

  before_action :authenticate_user!, only: [:create], unless: :is_dealer?
  before_action :authenticate_dealer!, only: [:create], unless: :is_user?

  P_2_C = {
    'ios' => IosDevice,
    'android' => AndroidDevice,
    'windows_phone' => WindowsPhone,
    'baidu_push' => BaiduDevice
  }

  def create
    return(head(:bad_request)) unless P_2_C.keys.include? params[:type]
    if params[:type] == 'baidu_push'
      @device = BaiduDevice.find_or_create_by(baidu_user_id: params[:baidu_user_id], baidu_channel_id: params[:baidu_channel_id])
    else
      @device = P_2_C[params[:type]].new(device_params)
    end
    @device.user = current_user if current_user
    @device.dealer = current_dealer if current_dealer
    @device.state = "active"
    respond_to do |format|
      if @device.save
        format.html { redirect_to @device, notice: 'Device was successfully created.' }
        format.json { render :show, status: :created }
      else
        format.html { render :new }
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def is_dealer?
    current_dealer && !current_user
  end

  def is_user?
    !current_dealer && current_user
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_device
    @device = Device.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  # baidu's user_id, channel_id http://developer.baidu.com/wiki/index.php?title=docs/cplat/push/scene
  def device_params
    params.require(:type)
    params.require(:device).permit(:push_id, :baidu_user_id, :baidu_channel_id)
  end


end
