module Shoppe
  class GalleryPhotosController < Shoppe::ApplicationController

    before_filter { @active_nav = :gallery_photos }
    before_filter { params[:id] && @gallery_photo = Shoppe::GalleryPhoto.find(params[:id]) }
  
    def index
      @gallery_photos = GalleryPhoto.all
    end
  
    def new
      @gallery_photo = GalleryPhoto.new
    end

    def create
      @gallery_photo = Shoppe::GalleryPhoto.new(safe_params)
      if @gallery_photo.save
        redirect_to :gallery_photos, :flash => {:notice => "Photo has been created successfully"}
      else
        render :action => "new"
      end
    end

    def edit
    end

    def update
      if @gallery_photo.update(safe_params)
        redirect_to [:edit, @gallery_photo], :flash => {:notice => "Photo has been updated successfully"}
      else
        render :action => "edit"
      end
    end

    def destroy
      @gallery_category.destroy
      redirect_to :gallery_photos, :flash => {:notice => "Photo has been removed successfully"}
    end

    private

    def safe_params
      params[:gallery_photo].permit(:gallery_category_id, :name, :title, :display, :main, :image)
    end
  
  end
end
