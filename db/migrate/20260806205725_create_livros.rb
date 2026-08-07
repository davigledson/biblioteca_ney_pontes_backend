class CreateLivros < ActiveRecord::Migration[8.1]
  def change
    create_table :livros do |t|
      t.string :titulo, null: false
      t.string :autor, null: false
      t.integer :status, null: false, default: 0
      t.text :observacoes
      t.references :categoria, null: false, foreign_key: true

      t.timestamps
    end
  end
end
