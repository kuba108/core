module Shoppe

  class GalleryPhoto < ActiveRecord::Base

    self.table_name = 'shoppe_gallery_photos'

    has_attached_file :image, :styles => { :medium => "500x673#", :thumb => "253x340#", :original => "892x1200#" },
                      :default_url => "/assets/photos/default/:style/gallery-photo-default.jpg",
                      :url => "/assets/photos/gallery_photos/:id/:style/:basename.:extension",
                      :path => ":rails_root/public/assets/photos/gallery_photos/:id/:style/:basename.:extension"
    validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

    belongs_to :shoppe_gallery_category, :class_name => 'Shoppe::GalleryCategory'

  end
end
