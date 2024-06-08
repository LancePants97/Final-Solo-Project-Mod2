class MerchantBulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discounts = @merchant.bulk_discounts
  end

  def show

  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    discount = BulkDiscount.create!(percentage_discount: params[:percentage_discount],
                quantity_threshold: params[:quantity_threshold],
                merchant: @merchant)
  if discount.save
    redirect_to "/merchants/#{@merchant.id}/bulk_discounts"
    flash[:notice] = "Bulk Discount Successfully Created"
  else
    redirect_to "/merchant/#{@merchant.id}/bulk_discounts/new"
    flash[:alert] = "Error"
    end
  end
end