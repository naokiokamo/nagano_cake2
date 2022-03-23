class Public::CartItemsController < ApplicationController
  before_action :authenticate_customer!

  def index
    @cart_items = current_customer.cart_items
  end

  def create
    @cart_item = CartItem.new(cart_item_params)
    if params[:cart_item][:amount] == ""
      @genres = Genre.all
      @item = Item.find(params[:cart_item][:item_id])
      @customer = current_customer
      render "public/items/show"
    else
      if current_customer.cart_items.find_by(item_id: params[:cart_item][:item_id])
        count = params[:cart_item][:amount].to_i
        item = CartItem.find_by(item_id: params[:cart_item][:item_id])
        item.increment(:amount, count)
        item.save
        redirect_to cart_items_path
      else
         @cart_item.save
         flash[:notice] = ""
         redirect_to cart_items_path
      end
    end
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
