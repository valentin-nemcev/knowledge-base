class ChangeArticleRevisionBodyHtml < ActiveRecord::Migration
  def up
    change_column :article_revisions, :body_html, :text, null: false
  end
end
