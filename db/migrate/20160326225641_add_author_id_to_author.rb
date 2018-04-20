class AddAuthorIdToAuthor < ActiveRecord::Migration
  def change
      add_column :authors, :author_id, :string
  end
end
