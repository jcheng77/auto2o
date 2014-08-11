class DepositsController < InheritedResources::Base

  before_action :authenticate_user!

  before_action :set_deposit, only: [:show, :edit, :update, :destroy]

  def create
    @deposit = Deposit.new(deposit_params)
    @deposit.user = current_user
    @tender = Tender.find(deposit_params[:tender_id])
    @deposit.tender = @tender
    @tender.submit_margin

    respond_to do |format|
      if @deposit.save
        format.html { redirect_to @deposit.tender, notice: 'Tender was successfully created.' }
        format.json { render :show, status: :created, location: @deposit }
      else
        format.html { render :new }
        format.json { render json: @deposit.errors, status: :unprocessable_entity }
      end
    end
  end

  def deposit_params
    params.require(:deposit).permit(:sum, :tender_id)
  end

private

  # Use callbacks to share common setup or constraints between actions.
  def set_deposit
    @deposit = Deposit.find(params[:id])
  end

end
