module Shoppe
  class ProductCategory < ActiveRecord::Base
  
    self.table_name = 'shoppe_product_categories'

    has_attached_file :image, :styles => { :medium => "500x673#", :thumb => "253x340#" },
                      :default_url => "/assets/photos/default/:style/product-category-default.jpg",
                      :url => "/assets/photos/product_categories/:id/:style/:basename.:extension",
                      :path => ":rails_root/public/assets/photos/product_categories/:id/:style/:basename.:extension"

    validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
  
    # All products within this category
    has_many :products, :dependent => :restrict_with_exception, :class_name => 'Shoppe::Product'
    
    # Validations
    validates :name, :presence => true
    validates :permalink, :presence => true, :uniqueness => true

    # All categories ordered by their name ascending
    scope :ordered, -> { order(:name) }
    
    # Set the permalink on callback
    before_validation { self.permalink = self.name.parameterize if self.permalink.blank? && self.name.is_a?(String) }
  
  end
end
