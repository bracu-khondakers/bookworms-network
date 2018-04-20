class CreateResponses < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.references :deal, index: true, foreign_key: true
      t.string :buyer_review
      t.string :buyer_rating
      t.string :seller_review
      t.string :seller_rating
      t.boolean :buyer_review_flag
      t.boolean :seller_review_flag

      t.timestamps null: false
    end
  end
end
