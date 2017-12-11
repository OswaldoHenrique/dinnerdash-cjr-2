class CreateMeals < ActiveRecord::Migration[5.0]
  def change
    create_table :meals do |t|
      t.string :name
      t.text :description
      t.float :price
      t.binary :image
      t.boolean :available
      t.references :meal_category, foreign_key: true

      t.timestamps
    end
  end
end
