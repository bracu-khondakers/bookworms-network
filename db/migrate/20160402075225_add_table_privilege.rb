class AddTablePrivilege < ActiveRecord::Migration
    def change
        create_table :privileges do |t|
            t.references :user, index: true, foreign_key: true
            t.boolean :admin

            t.timestamps null: false
        end
    end
end
