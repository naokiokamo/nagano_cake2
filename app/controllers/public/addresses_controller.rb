class Public::AddressesController < ApplicationController
  before_action :authenticate_customer!

  def index
    @new_address = Address.new
    @addresses = current_customer.addresses
    @customer = current_customer
  end

  def create
    @customer = current_customer
    @address = Address.new(address_params)
    @address.save
    redirect_to addresses_path
  end

  def edit
    @customer = current_customer
    @edit_address = Address.find(params[:id])
  end

  def update
    @customer = current_customer
    address = Address.find(params[:id])
    address.update(address_params)
    redirect_to addresses_path
  end

  def destroy
    @customer = current_customer
    address = Address.find(params[:id])
    address.destroy
    redirect_to addresses_path
  end

  private
  def address_params
    params.require(:address).permit(:customer_id, :postal_code, :address, :name)
  end
end
