class RenameReviewsResponseQualityToGrade < ActiveRecord::Migration
  def change
    change_table :reviews do |t|
      t.remove :response_quality
      t.string :grade, null: false
    end
  end
end
