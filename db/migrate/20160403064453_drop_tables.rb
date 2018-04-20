class DropTables < ActiveRecord::Migration
  def change
      drop_table :active_admin_comments
      drop_table :admin_users
      drop_table :admins
      drop_table :responses
      drop_table :transactions
      drop_table :user_types
  end
end
