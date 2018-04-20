class CreateUserTypes < ActiveRecord::Migration
  def change
    create_table :user_types do |t|
      t.references :user, index: true, foreign_key: true
      t.string :role

      t.timestamps null: false
    end
  end
end
