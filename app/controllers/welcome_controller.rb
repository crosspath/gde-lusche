class WelcomeController < ApplicationController
  def index
  end
  
  def search_address
    @addresses = Address.fts(params[:term])
    respond_to do |format|
      format.js { render json: @addresses.map { |x| {value: x[0], label: x[1]} } }
    end
  end
  
  def search_house
    term = params[:term] || ''
    @addresses = House.where('name like ?', term+'%').where(address_id: params[:address])
    respond_to do |format|
      format.js { render json: @addresses.map { |x| {value: x.id, label: x.name} } }
    end
  end
  
  def view_address
    @house = House.find(params[:house_id])
  end
end
