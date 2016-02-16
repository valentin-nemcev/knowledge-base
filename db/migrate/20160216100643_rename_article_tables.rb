class RenameArticleTables < ActiveRecord::Migration
  def change
    rename_table :article_reviews, :reviews
    rename_table :article_revisions, :revisions
  end
end
