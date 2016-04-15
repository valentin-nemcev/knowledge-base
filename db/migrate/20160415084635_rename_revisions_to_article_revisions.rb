class RenameRevisionsToArticleRevisions < ActiveRecord::Migration
  def change
    rename_table :revisions, :article_revisions
  end
end
