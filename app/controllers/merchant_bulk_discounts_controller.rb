class MerchantBulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discounts = @merchant.bulk_discounts
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @discount = @merchant.bulk_discounts.find(params[:id])
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

  def edit
    @merchant = Merchant.find(params[:merchant_id])
    @discount = @merchant.bulk_discounts.find(params[:id])
  end

  def update
    @merchant = Merchant.find(params[:merchant_id])
    @discount = @merchant.bulk_discounts.find(params[:id])
    if @discount.update(percentage_discount: params[:percentage_discount],
      quantity_threshold: params[:quantity_threshold],
      merchant: @merchant)
      redirect_to "/merchants/#{@merchant.id}/bulk_discounts/#{@discount.id}"
      flash[:notice] = "Bulk Discount Successfully Updated"
    else
      redirect_to "/merchants/#{@merchant.id}/bulk_discounts/#{@discount.id}/edit"
      flash[:alert] = "Error: Please Fill in All Fields"
    end
  end

  def destroy
    @merchant = Merchant.find(params[:merchant_id])
    @merchant.bulk_discounts.find(params[:id]).destroy
    redirect_to "/merchants/#{@merchant.id}/bulk_discounts"
  end
end