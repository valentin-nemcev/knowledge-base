class AddDestroyedAtToCards < ActiveRecord::Migration
  def change
    add_column :cards, :destroyed_at, :datetime
    add_index :cards, :destroyed_at
  end
end
