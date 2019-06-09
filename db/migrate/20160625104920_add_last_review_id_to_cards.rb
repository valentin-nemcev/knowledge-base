class AddLastReviewIdToCards < ActiveRecord::Migration
  def change
    add_reference :cards, :latest_review, index: true
    add_foreign_key :cards, :reviews, column: :latest_review_id
  end
end
