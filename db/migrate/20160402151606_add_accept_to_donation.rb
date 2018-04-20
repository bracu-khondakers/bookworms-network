class AddAcceptToDonation < ActiveRecord::Migration
    def change
        add_column :donations, :accepted, :boolean
    end
end
