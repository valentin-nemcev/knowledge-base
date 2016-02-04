class AddResponseQualityToArticleReview < ActiveRecord::Migration
  def change
    add_column :article_reviews, :response_quality, :integer
  end
end
