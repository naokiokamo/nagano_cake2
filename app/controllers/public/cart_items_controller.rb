class Public::CartItemsController < ApplicationController
  before_action :authenticate_customer!

  def with_tax_price
    (price * 1.1).floor
  end

  def index
    @cart_items = current_customer.cart_items
  end



  def create
    unless params.dig(:cart_item, :amount).present?
      redirect_back(fallback_location: root_path)
      return
    end
    
    cart_item = CartItem.new(cart_item_params)
    if CartItem.find_by(item_id: params.dig(:cart_item, :item_id))
      count = params.dig(:cart_item, :amount).to_i
      item = CartItem.find_by(item_id: params.dig(:cart_item, :item_id))
      item.increment(:amount, count)
      item.save
    else
      cart_item.save
    end
    redirect_to cart_items_path
  end

  def update
    cart_item = CartItem.find(params[:id])
    if cart_item.update(cart_item_params)
      redirect_to cart_items_path
    else
      render :index
    end
  end

  def destroy
    cart_item = CartItem.find(params[:id])
    cart_item.destroy
    redirect_to cart_items_path
  end

  def destroy_all
    current_customer.cart_items.destroy_all
    redirect_to cart_items_path
  end

  private
  def cart_item_params
    params.require(:cart_item).permit(:amount, :item_id, :customer_id)
  end
end
