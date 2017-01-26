class CreateShipments < ActiveRecord::Migration
  def change
    create_table :shipments do |t|
      t.float :weight
      t.float :height
      t.float :width
      t.float :depth

      t.timestamps null: false
    end
  end
end
