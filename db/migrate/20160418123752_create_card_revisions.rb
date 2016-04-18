class CreateCardRevisions < ActiveRecord::Migration
  def change
    create_table :card_revisions do |t|
      t.timestamps null: false
      t.references :card, index: true, foreign_key: true, null: false
      t.references :article_revision, index: true, foreign_key: true, null: false
      t.boolean :autosave, default: false, null: false
      t.text :body_html, null: false
    end

    add_reference :cards, :current_revision, index: true
    add_foreign_key :cards, :card_revisions, column: :current_revision_id
    remove_column :cards, :body_html, :text
  end
end
