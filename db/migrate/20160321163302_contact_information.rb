class ContactInformation < ActiveRecord::Migration
    def change
        create_table :contact_informations, :force => true do |t|
            t.string :contactable_type #user/publisher
            t.integer :contactable_id #user_id/publisher_id
            t.string :type #email, phone_number, address
            t.string :label #personal, home, work
            t.string :info #the actual content
            
            t.timestamps null: false #default timestamp
        end
    end
end