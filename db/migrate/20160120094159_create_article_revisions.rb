class CreateArticleRevisions < ActiveRecord::Migration
  class Article < ActiveRecord::Base
    has_many :article_revisions
  end

  class ArticleRevision < ActiveRecord::Base
    belongs_to :article
  end

  def up
    create_table :article_revisions do |t|
      t.references :article, index: true, foreign_key: true
      t.string :title, null: false
      t.text :body, null: false

      t.timestamps null: false
    end

    Article.find_each do |article|
      article.article_revisions
        .create!(title: article.title, body: article.body)
    end

    remove_column :articles, :title
    remove_column :articles, :body
  end
end
