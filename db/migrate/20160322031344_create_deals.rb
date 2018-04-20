class CreateDeals < ActiveRecord::Migration
  def change
    create_table :deals do |t|
      t.integer :buyer_id
      t.integer :seller_id
      t.integer :book_id
      t.date :date_of_transaction

      t.timestamps null: false
    end
  end
end
