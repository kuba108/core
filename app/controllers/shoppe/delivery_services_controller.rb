module Shoppe
  class DeliveryServicesController < Shoppe::ApplicationController
  
    before_filter { @active_nav = :delivery_services }
    before_filter { params[:id] && @delivery_service = Shoppe::DeliveryService.find(params[:id]) }
  
    def index
      @delivery_services = Shoppe::DeliveryService.all
    end
  
    def new
      @delivery_service = Shoppe::DeliveryService.new
    end
  
    def create
      @delivery_service = Shoppe::DeliveryService.new(safe_params)
      if @delivery_service.save
        redirect_to :delivery_services, :flash => {:notice => "Delivery Service has been created successfully"}
      else
        render :action => "new"
      end
    end
  
    def edit
    end
  
    def update
      if @delivery_service.update(safe_params)
        redirect_to [:edit, @delivery_service], :flash => {:notice => "Delivery Service has been updated successfully"}
      else
        render :action => "edit"
      end
    end
  
    def destroy
      @delivery_service.destroy
      redirect_to :delivery_services, :flash => {:notice => "Delivery Service has been removed successfully"}
    end
  
    private
  
    def safe_params
      params[:delivery_service].permit(:name, :code, :active, :default, :courier, :tracking_url)
    end
  
  end
end
