module Shoppe
  class ProductPhoto < ActiveRecord::Base

    has_attached_file :image, :styles => { :medium => "500x673#", :thumb => "253x340#", :small_thumb => "121x163#", :original => "892x1200#"},
                      :default_url => "/photos/default/:style/product-photo-default.jpg",
                      :url => "/photos/product_photos/:id/:style/:basename.:extension",
                      :path => ":rails_root/public/photos/product_photos/:id/:style/:basename.:extension"

    validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

    belongs_to :shoppe_product, :class_name => 'Shoppe::Product'

    # Other photos than default
    scope :other_photos, -> { where(:default => 0) }

    # select and return default image or first image or just empty PhotoProduct with default image
    def self.default
      image = self.where(:default => 1).first
      if image.blank?
        image = self.first

        if image.blank?
          image = ProductPhoto.new
        end
      end

      image
    end

  end
end