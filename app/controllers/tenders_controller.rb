class TendersController < InheritedResources::Base

  before_action :set_tender, only: [:show, :edit, :update, :destroy, :bid, :bids_list, :submit, :bargain, :submit_bargain, :show_bargain]

  # GET /tenders
  # GET /tenders.json
  def index
    @tenders = Tender.all
  end

  # GET /tenders/1
  # GET /tenders/1.json
  def show
  end

  # GET /tenders/new
  def new
    @tender = Tender.new
  end

  # GET /tenders/1/edit
  def edit
  end

  # POST /tenders
  # POST /tenders.json
  def create
    @tender = Tender.new(tender_params)

    respond_to do |format|
      if @tender.save
        format.html { redirect_to @tender, notice: 'Tender was successfully created.' }
        format.json { render :show, status: :created, location: @tender }
      else
        format.html { render :new }
        format.json { render json: @tender.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tenders/1
  # PATCH/PUT /tenders/1.json
  def update
    respond_to do |format|
      if @tender.update(tender_params)
        format.html { redirect_to @tender, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @tender }
      else
        format.html { render :edit }
        format.json { render json: @tender.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tenders/1
  # DELETE /tenders/1.json
  def destroy
    @tender.destroy
    respond_to do |format|
      format.html { redirect_to tenders_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /tender/1/bid
  # GET /tender/1/bid.json
  def bid
    @bid = @tender.bids.new
  end

  # GET /tender/1/bid_list
  # GET /tender/1/bid_list.json
  def bids_list  
    @bids = @tender.bids
  end

  # POST /tender/1/submit
  # POST /tender/1/submit.json
  def submit
    @bid = Bid.new(bid_params)
    @bid.tender = @tender       
    respond_to do |format|
      if @bid.save
        format.html { redirect_to @bid, notice: 'Tender was successfully created.' }
        format.json { render :show, status: :created, location: @bid }
      else
        format.html { render :new }
        format.json { render json: @bid.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # GET /tender/1/bargain
  # GET /tender/1/bargain.json  
  def bargain
    @bargain = @tender.build_bargain 
  end

  # GET /tender/1/show_bargain
  # GET /tender/1/show_bargain.json
  def show_bargain
    @bargain = @tender.bargain
  end

  # POST /tender/1/submit_bargain
  # POST /tender/1/submit_bargain.json
  def submit_bargain
    @bargain = @tender.build_bargain(bargain_params)
       
    respond_to do |format|
      if @bargain.save
        format.html { redirect_to @bargain, notice: 'Tender was successfully created.' }
        format.json { render :show, status: :created, location: @bargain }
      else
        format.html { render :new }
        format.json { render json: @bargain.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_tender
    @tender = Tender.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def tender_params
    params.require(:tender).permit(:model, :price, :description)
  end

  def bid_params
    params.require(:bid).permit(:price, :description)
  end
  
  def bargain_params
    params.require(:bargain).permit(:price, :postscript)
  end

end
