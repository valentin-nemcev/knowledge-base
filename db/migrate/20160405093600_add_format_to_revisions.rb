class AddFormatToRevisions < ActiveRecord::Migration
  class Revision < ActiveRecord::Base
  end

  def up
    add_column :revisions, :markup_language, :string

    Revision.update_all(markup_language: 'kramdown')

    change_column :revisions, :markup_language, :string, null: false
  end

  def down
    remove_column :revisions, :markup_language
  end
end
