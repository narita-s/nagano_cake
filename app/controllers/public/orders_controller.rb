class Public::OrdersController < ApplicationController

  before_action :authenticate_customer!

  def new
    @order = Order.new
    @addresses = current_customer.addresses.all
  end

  def confirm
    @order = Order.new(order_params)
    @order.payment_method = params[:order][:payment_method]
    @order.shipping_cost = 800
    @cart_items = current_customer.cart_items
    @price = @cart_items.inject(0) { |sum, item| sum + item.subtotal }
    @total_price = @price + @order.shipping_cost

    if params[:order][:address_select] == "0"
      @order.postal_code = current_customer.postal_code
      @order.address = current_customer.address
      @order.name = current_customer.full_name
    elsif params[:order][:address_select] == "1"
      @order.postal_code =  Address.find(params[:order][:address_id]).postal_code
      @order.address = Address.find(params[:order][:address_id]).address
      @order.name = Address.find(params[:order][:address_id]).name
    elsif params[:order][:address_select] = "2"
      @order.postal_code = params[:order][:postal_code]
      @order.address = params[:order][:address]
      @order.name = params[:order][:name]
    else
      render 'new'
    end

  end

  def create
    @order = Order.new(order_params)
    @order.customer_id = current_customer.id
    @order.save

    current_customer.cart_items.each do |cart_item|
      @order_detail = OrderDetail.new
      @order_detail.item_id = cart_item.item_id
      @order_detail.amount = cart_item.amount
      @order_detail.order_id =  @order.id
      @order_detail.price = cart_item.item.price * 1.1
      @order_detail.save
    end
    current_customer.cart_items.destroy_all
    redirect_to thanks_orders_path
  end


  def thanks
  end

  def index
    @orders = current_customer.orders.all

  end

  def show
    @order = current_customer.orders.find(params[:id])
    @order_details = @order.order_details
  end

  private

    def order_params
        params.require(:order).permit(:postal_code, :address, :name, :total_price, :shipping_cost, :payment_method, :status)
    end

end
