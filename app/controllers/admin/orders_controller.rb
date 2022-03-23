class Admin::OrdersController < ApplicationController
  before_action :authenticate_admin!

  def index
    @customer = Customer.find(params[:customer_id]).page(params[:page]).per(10)
    @orders = @customer.orders
  end

  def show
    @order = Order.find(params[:id])
    @order.shipping_cost = 800
  end

  #注文ステータス・着手状況の更新
  def update
    @order = Order.find(params[:id])
    if @order.update(order_params)
      if @order.status == "deposited"
        @order.order_details.update_all(making_status: "waiting_manufactured")
      end
      redirect_to admin_order_path(@order)
    else
      render :show
    end
  end


  private
  def order_params
    params.require(:order).permit(:customer_id, :postal_code, :address, :name, :shipping_cost, :total_payment, :payment_method, :status)
  end
end