class AddColumnHomepageToGalleryCategory < ActiveRecord::Migration
  def change
    add_column :shoppe_gallery_categories, :homepage, :boolean, null: false, default: false, index: true
  end
end
