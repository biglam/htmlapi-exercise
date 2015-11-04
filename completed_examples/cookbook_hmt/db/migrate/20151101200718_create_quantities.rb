class CreateQuantities < ActiveRecord::Migration
  def change
    create_table :quantities do |t|
      t.integer :ingredient_id
      t.integer :recipe_id
      t.string :quantity

      t.timestamps null: false
    end
  end
end
