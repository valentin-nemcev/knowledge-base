class AddColumnsToReviews < ActiveRecord::Migration
  def change
    change_table :reviews do |t|
      t.float :e_factor
      t.datetime :next_review_at
    end
  end
end
