class AddCurrentRevisionToArticles < ActiveRecord::Migration
  class Article < ActiveRecord::Base
    has_many :article_revisions
    belongs_to :current_revision, class_name: 'ArticleRevision'
  end

  class ArticleRevision < ActiveRecord::Base
    belongs_to :article
  end

  def change
    add_reference :articles, :current_revision, index: true
    add_foreign_key :articles, :article_revisions, column: :current_revision_id

    reversible do |dir|
      dir.up do
        Article.find_each do |article|
          article.current_revision = article.article_revisions.first
          article.save!
        end
      end
    end
  end
end
