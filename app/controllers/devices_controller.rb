class DevicesController < InheritedResources::Base

  before_action :authenticate_user!

  P_2_C = {
    'ios' => IosDevice,
    'android' => AndroidDevice,
    'windows_phone' => WindowsPhone
  }

  def create
    return(head(:bad_request)) unless P_2_C.keys.include? params[:type]
    @device = P_2_C[params[:type]].new(device_params)
    @device.user = current_user
    respond_to do |format|
      if @device.save
        format.html { redirect_to @device, notice: 'Device was successfully created.' }
        format.json { render :show, status: :created, location: @device }
      else
        format.html { render :new }
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_device
    @device = Device.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def device_params
    params.require(:device).permit(:push_id)
  end


end
