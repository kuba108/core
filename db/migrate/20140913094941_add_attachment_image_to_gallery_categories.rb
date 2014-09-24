class AddAttachmentImageToGalleryCategories < ActiveRecord::Migration
  def self.up
    change_table :shoppe_gallery_categories do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :shoppe_gallery_categories, :image
  end
end
