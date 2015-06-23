class ListController < ApplicationController
  before_action :set_user
  def show
  end

  def add
    print "add sku to list ".red; puts sku_params
    @user.skus.push Sku.find(sku_params)
    redirect_to "/skus"
  end

  def remove
    #`sleep 2`
    print "remove sku to list ".red; puts sku_params
    @user.skus.delete Sku.find(sku_params)
    redirect_to "/skus"
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      authorize
      @user = current_user
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sku_params
      params.require(:id)
    end
end
