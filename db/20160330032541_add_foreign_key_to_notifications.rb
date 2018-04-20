class AddForeignKeyToNotifications < ActiveRecord::Migration
  def change
      add_foreign_key :notifications, column: :receiver_id
  end
end
