module Shoppe

  class GalleryCategory < ActiveRecord::Base

    self.table_name = 'shoppe_gallery_categories'

    has_attached_file :image, :styles => { :medium => "500x673#", :thumb => "253x340#" },
                      :default_url => "/assets/photos/default/:style/gallery-default.jpg",
                      :url => "/assets/photos/galleries/:id/:style/:basename.:extension",
                      :path => ":rails_root/public/assets/photos/galleries/:id/:style/:basename.:extension"

    validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

    has_many :photos, :dependent => :restrict_with_exception, :class_name => 'Shoppe::GalleryPhoto'

    # All categories ordered by their name ascending
    scope :ordered, -> { order(:name) }

    # Set the permalink on callback
    before_validation { self.permalink = self.name.parameterize if self.permalink.blank? && self.name.is_a?(String) }

  end
end