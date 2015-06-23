class SkusController < ApplicationController
  before_action :set_sku, only: [:show, :edit, :update, :destroy]

  # GET /skus
  # GET /skus.json
  def index
    @skus = Sku.all
    @userskus = []
    if current_user
      @userskus = current_user.skus
    end
  end

  # GET /skus/1
  # GET /skus/1.json
  def show
  end

  # GET /skus/new
  def new
    @sku = Sku.new
  end

  # GET /skus/1/edit
  def edit
  end

  # POST /skus
  # POST /skus.json
  def create
    ap @sku = Sku.fetch(sku_id_param)

    respond_to do |format|
      unless @sku.nil?
        puts "hello".green
        format.html { redirect_to @sku, notice: 'Sku was successfully created.' }
        format.json { render action: 'show', status: :created, location: @sku }
      else
        format.html { redirect_to '/skus/new', notice: 'Sku was not created maybe Skroutz credentials have expired or you entered a wrong id' }
        format.json { render json: @sku.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /skus/1
  # PATCH/PUT /skus/1.json
  def update
    respond_to do |format|
      if @sku.update(sku_params)
        format.html { redirect_to @sku, notice: 'Sku was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @sku.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /skus/1
  # DELETE /skus/1.json
  def destroy
    @sku.destroy
    respond_to do |format|
      format.html { redirect_to skus_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sku
      @sku = Sku.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sku_params
      params.require(:sku).permit(:name, :price_max, :price_min, :image)
    end
    
    def sku_id_param
      params.require(:sku_id)
    end
end
