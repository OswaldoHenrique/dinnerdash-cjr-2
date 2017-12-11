class CreateOrderHasMeals < ActiveRecord::Migration[5.0]
  def change
    create_table :order_has_meals do |t|
      t.integer :quantity
      t.float :price
      t.references :order, foreign_key: true
      t.references :meal, foreign_key: true

      t.timestamps
    end
  end
end
