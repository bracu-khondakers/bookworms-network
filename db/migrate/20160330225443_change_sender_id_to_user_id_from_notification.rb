class ChangeSenderIdToUserIdFromNotification < ActiveRecord::Migration
  def change
      rename_column :notifications, :sender_id, :user_id
  end
end
