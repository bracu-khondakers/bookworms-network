class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :password
      t.string :name
      t.date :birth_date
      t.text :about_me

      t.timestamps null: false
    end
  end
end
