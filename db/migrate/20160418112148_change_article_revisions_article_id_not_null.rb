class ChangeArticleRevisionsArticleIdNotNull < ActiveRecord::Migration
  def change
    change_column_null :article_revisions, :article_id, false
  end
end
