class RenameUserIdToSenderIdInNotification < ActiveRecord::Migration
  def change
      rename_column :notifications, :user_id, :sender_id
  end
end
