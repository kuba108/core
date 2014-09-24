module Shoppe

  class GalleryCategory < ActiveRecord::Base

    self.table_name = 'shoppe_gallery_categories'

    has_attached_file :image, :styles => { :medium => "500x673#", :thumb => "253x340#" },
                      :default_url => "/assets/default/:style/gallery-default.jpg",
                      :url => "/assets/gallery_categories/:id/:style/:basename.:extension"
    validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

    has_many :photos, :dependent => :restrict_with_exception, :class_name => 'Shoppe::GalleryPhoto'

    # All categories ordered by their name ascending
    scope :ordered, -> { order(:name) }

  end
end