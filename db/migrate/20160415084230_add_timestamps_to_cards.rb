class AddTimestampsToCards < ActiveRecord::Migration
  def change
    change_table :cards do |t|
      t.timestamps null: false
    end
  end
end
