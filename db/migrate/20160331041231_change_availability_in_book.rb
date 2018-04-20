class ChangeAvailabilityInBook < ActiveRecord::Migration
  def change
      change_column :books, :availability, :boolean
  end
end
