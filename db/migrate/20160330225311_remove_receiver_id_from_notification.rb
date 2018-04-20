class RemoveReceiverIdFromNotification < ActiveRecord::Migration
  def change
      remove_column :notifications, :receiver_id
  end
end
