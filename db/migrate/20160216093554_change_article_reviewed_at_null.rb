class ChangeArticleReviewedAtNull < ActiveRecord::Migration
  def change
    reversible do |dir|
        dir.up do
          execute 'DELETE FROM article_reviews WHERE reviewed_at IS NULL'
        end
    end
    change_column_null :article_reviews, :reviewed_at, false
  end
end
