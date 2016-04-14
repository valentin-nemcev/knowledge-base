class CreateCards < ActiveRecord::Migration
  def change
    create_table(:cards) do |t|
      # // TODO Use string primary key when this is landed in stable:
      # https://github.com/rails/rails/pull/18228
      # t.column :id, 'VARCHAR PRIMARY KEY NOT NULL'

      # t.string :id, null: false, index: {unique: true}
      t.string :path, null: false
      t.references :article, index: true, foreign_key: true, null: false
      t.text :body_html, null: false

      t.index [:path, :article_id], unique: true
    end
  end
end
