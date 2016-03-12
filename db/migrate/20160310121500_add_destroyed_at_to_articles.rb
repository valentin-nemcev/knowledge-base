class AddDestroyedAtToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :destroyed_at, :datetime
    add_index :articles, :destroyed_at
  end
end
