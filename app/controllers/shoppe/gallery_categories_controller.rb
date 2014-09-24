module Shoppe
  class GalleryCategoriesController < Shoppe::ApplicationController

    before_filter { @active_nav = :gallery_categories }
    before_filter { params[:id] && @gallery_category = Shoppe::GalleryCategory.find(params[:id]) }
  
    def index
      @gallery_categories = GalleryCategory.all
    end
  
    def new
      @gallery_category = GalleryCategory.new
    end

    def create
      @gallery_category = Shoppe::GalleryCategory.new(safe_params)
      if @gallery_category.save
        redirect_to :gallery_categories, :flash => {:notice => "Category has been created successfully"}
      else
        render :action => "new"
      end
    end

    def edit
    end

    def update
      if @gallery_category.update(safe_params)
        redirect_to [:edit, @gallery_category], :flash => {:notice => "Category has been updated successfully"}
      else
        render :action => "edit"
      end
    end

    def destroy
      @gallery_category.destroy
      redirect_to :gallery_categories, :flash => {:notice => "Category has been removed successfully"}
    end

    private

    def safe_params
      params[:gallery_category].permit(:name, :title, :description, :image)
    end
  
  end
end
