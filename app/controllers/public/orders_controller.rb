class Public::OrdersController < ApplicationController
  before_action :authenticate_customer!

  def new
    @order = Order.new
  end

  #注文確認画面
  def confirm
    @cart_items = current_customer.cart_items
    @order = Order.new
    @order.customer_id = current_customer.id
    @order.shipping_cost = 800
    if params[:order][:select_address] == "customer_address"
      @order.payment_method = order_params[:payment_method]
      @order.postal_code = current_customer.postal_code
      @order.address = current_customer.address
      @order.name = current_customer.last_name + current_customer.first_name
    elsif params[:order][:select_address] == "select_address" then
      @order.payment_method = order_params[:payment_method]
      @address = Address.find(params[:order][:address_id])
      @order.postal_code = @address.postal_code
      @order.address = @address.address
      @order.name = @address.name
    else
      @order.payment_method = order_params[:payment_method]
      @order.postal_code = order_params[:postal_code]
      @order.address = order_params[:address]
      @order.name = order_params[:name]
    end
  end
  #注文確定処理
  def create
    @cart_items = current_customer.cart_items
    @order = Order.new(order_params)
    if @order.save
      current_customer.cart_items.each do |cart_item|
        @order_detail = OrderDetail.new
        @order_detail.order_id =  @order.id
        @order_detail.item_id = cart_item.item.id
        @order_detail.price = cart_item.item.price * 1.1
        @order_detail.amount = cart_item.amount
        @order_detail.save
      end
      current_customer.cart_items.destroy_all
      redirect_to orders_thanks_path
    else
      render :confirm
    end
  end

  #ありがとう画面
  def thanks
  end



  #
  def index
    @orders = current_customer.orders
  end

  #
  def show
    @order = Order.find(params[:id])
    @order.shipping_cost = 800
  end

  private
  def order_params
    params.require(:order).permit(:payment_method, :postal_code, :address, :name, :address_id, :select_address, :status, :customer_id, :shipping_cost, :total_payment)
  end
end