class AddAttachmentImageToShoppeProductPhotos < ActiveRecord::Migration
  def self.up
    change_table :shoppe_product_photos do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :shoppe_product_photos, :image
  end
end
