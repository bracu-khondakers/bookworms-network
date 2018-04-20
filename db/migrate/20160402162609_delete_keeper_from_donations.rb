class DeleteKeeperFromDonations < ActiveRecord::Migration
    def change
        remove_column :donations, :keeper_id
    end
end
