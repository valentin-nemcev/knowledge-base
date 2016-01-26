class AddAutosaveToArticleRevision < ActiveRecord::Migration
  def change
    add_column :article_revisions, :autosave,
      :boolean, null: false, default: false
  end
end
