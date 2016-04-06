class AddFormatToArticles < ActiveRecord::Migration
  class Article < ActiveRecord::Base
  end

  def up
    add_column :articles, :format, :string

    Article.find_each do |article|
      article.update_attributes(format: 'kramdown')
    end
  end

  def down
    remove_column :articles, :format
  end
end
