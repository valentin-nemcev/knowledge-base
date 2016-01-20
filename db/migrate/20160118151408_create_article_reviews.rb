class CreateArticleReviews < ActiveRecord::Migration
  def change
    create_table :article_reviews do |t|
      t.datetime :reviewed_at
      t.references :article, index: true, foreign_key: true
    end
  end
end
