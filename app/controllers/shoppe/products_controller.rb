module Shoppe
  class ProductsController < Shoppe::ApplicationController
  
    before_filter { @active_nav = :products }
    before_filter { params[:id] && @product = Shoppe::Product.root.find(params[:id]) }
    before_filter { @product_photos = @product.product_photos if @product }
  
    def index
      @products = Shoppe::Product.root.includes(:stock_level_adjustments, :product_category, :variants).order(:name).group_by(&:product_category).sort_by { |cat,pro| cat.name }
    end
  
    def new
      @product = Shoppe::Product.new
    end
  
    def create
      @product = Shoppe::Product.new(safe_params)
      if @product.save
        save_photo
        redirect_to :products, :flash => {:notice => "Product has been created successfully"}
      else
        render :action => "new"
      end
    end
  
    def edit
    end
  
    def update
      save_photo
      if @product.update(safe_params)
        redirect_to [:edit, @product], :flash => {:notice => "Product has been updated successfully"}
      else
        render :action => "edit"
      end
    end
  
    def destroy
      @product.destroy
      redirect_to :products, :flash => {:notice => "Product has been removed successfully"}
    end

    def delete_photo
      begin
        photo = ProductPhoto.find(params[:photo_id])
        if photo.destroy!
          flash[:notice] = I18n.t :photo_was_deleted, scope: [:shoppe, :products]
        end
      rescue
        flash[:error] = I18n.t :photo_not_found, scope: [:shoppe, :products]
      end

      redirect_to [:edit, @product]
    end
    
    private
  
    def safe_params
      params[:product].permit(:product_category_id, :name, :sku, :permalink, :description, :short_description, :weight, :price, :cost_price, :tax_rate_id, :stock_control, :image, :data_sheet_file, :active, :featured, :in_the_box, :product_attributes_array => [:key, :value, :searchable, :public])
    end

    def save_photo
      prms = params[:product][:product_photo]
      if prms && !prms.blank? && !prms[:name].blank? && !prms[:title].blank? && !prms[:image].blank?
        prms[:product_id] = @product.id
        photo = Shoppe::ProductPhoto.new(prms.permit(:product_id, :name, :title, :image))
        if photo.save

        end
      end
    end
  
  end
end
