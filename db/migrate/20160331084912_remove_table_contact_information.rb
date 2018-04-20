class RemoveTableContactInformation < ActiveRecord::Migration
  def change
      drop_table :contact_informations
  end
end
