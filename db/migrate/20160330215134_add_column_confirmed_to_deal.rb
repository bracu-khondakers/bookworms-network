class AddColumnConfirmedToDeal < ActiveRecord::Migration
    def change
        add_column :deals, :confirmed, :boolean
    end
end