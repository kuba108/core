class AddAttachmentImageToShoppeProductCategories < ActiveRecord::Migration
  def self.up
    change_table :shoppe_product_categories do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :shoppe_product_categories, :image
  end
end
