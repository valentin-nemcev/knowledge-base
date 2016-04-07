class AddBodyHtmlToRevisions < ActiveRecord::Migration
  def change
    add_column :revisions, :body_html, :string, null: false
  end
end
