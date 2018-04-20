class CreateReviewerships < ActiveRecord::Migration
  def change
    create_table :reviewerships do |t|
      t.integer :user_id
      t.integer :reviewer_id
      t.string :rating
      t.string :review

      t.timestamps null: false
    end
  end
end
