class AddPublisherIdToPublisher < ActiveRecord::Migration
  def change
      add_column :publishers, :publisher_id, :string
  end
end
