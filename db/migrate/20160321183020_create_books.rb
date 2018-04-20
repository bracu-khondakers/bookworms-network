class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.references :user, index: true, foreign_key: true
      t.string :isbn
      t.string :title
      t.string :genre
      t.string :availability
      t.string :condition
      t.float :market_price
      t.references :publisher, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
