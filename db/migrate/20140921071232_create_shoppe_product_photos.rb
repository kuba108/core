class CreateShoppeProductPhotos < ActiveRecord::Migration
  def change
    create_table :shoppe_product_photos do |t|
      t.references :product, null: false
      t.string :name, null: true
      t.string :title, null: true
      t.boolean :default, null: false, default: false
      t.timestamps
    end
  end
end
