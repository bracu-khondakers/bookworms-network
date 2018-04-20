class CreateDonations < ActiveRecord::Migration
  def change
    create_table :donations do |t|
      t.references :user, index: true, foreign_key: true
      t.references :book, index: true, foreign_key: true
      t.string :keeper_id

      t.timestamps null: false
    end
  end
end
