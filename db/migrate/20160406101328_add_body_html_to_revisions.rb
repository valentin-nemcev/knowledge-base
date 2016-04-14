class AddBodyHtmlToRevisions < ActiveRecord::Migration
  def up
    add_column :revisions, :body_html, :string
    Revision.reset_column_information
    Revision.find_each(&:update_body_html)
    change_column :revisions, :body_html, :string, null: false
  end
end
