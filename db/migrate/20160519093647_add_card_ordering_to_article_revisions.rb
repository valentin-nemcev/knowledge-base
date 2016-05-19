class AddCardOrderingToArticleRevisions < ActiveRecord::Migration
  def change
    add_column :article_revisions, :card_ordering, :string
  end
end
