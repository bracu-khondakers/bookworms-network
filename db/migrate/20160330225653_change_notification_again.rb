class ChangeNotificationAgain < ActiveRecord::Migration
  def change
      remove_column :notifications, :message
      add_column :notifications, :deal_id, :integer
      add_foreign_key :notifications, :deals
  end
end
