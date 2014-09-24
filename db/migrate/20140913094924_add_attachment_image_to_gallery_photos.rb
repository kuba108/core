class AddAttachmentImageToGalleryPhotos < ActiveRecord::Migration
  def self.up
    change_table :shoppe_gallery_photos do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :shoppe_gallery_photos, :image
  end
end
