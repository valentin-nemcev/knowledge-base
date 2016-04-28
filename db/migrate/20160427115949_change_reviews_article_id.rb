class ChangeReviewsArticleId < ActiveRecord::Migration
  def up
    Review.delete_all

    change_table :reviews do |t|
      t.remove :article_id
      t.references :card, index: true, foreign_key: true, null: false
    end
  end
end
