class Admin::OrderDetailsController < ApplicationController
  before_action :authenticate_admin!

  #製作ステータスの更新
  def update
    @order_detail = OrderDetail.find(params[:id])
    @order = @order_detail.order
    if @order_detail.update(order_detail_params)
      if @order_detail.making_status == "making"
        @order.update(status: "production")
      end
      #注文詳細に注文されてるものの詳細を定義する
      order_detail_all = @order.order_details
      #complete_countに初期値を0に設定
      complete_count = 0
      #注文詳細のそれぞれの処理
      order_detail_all.each do |order_detail|
        #もし注文詳細(xつ目)の製作ステータスが「製作完了」であれば、、
        if order_detail.making_status == "complete_manufactured"
          #complete_count＋1=complete_countになる
          complete_count += 1
        end
      end
      #complete_countの数値=注文されてるものの詳細の総数だったら、、、
      if complete_count == order_detail_all.count
        @order.update(status: "preparing_ship")
      end
      redirect_to admin_order_path(@order)
    else
      render :show
    end
  end


  private
  def order_detail_params
    params.require(:order_detail).permit(:order_id, :item_id, :price, :amount, :making_status)
  end
end