class CreateUsuarioBibliotecas < ActiveRecord::Migration[8.1]
  def change
    create_table :usuario_bibliotecas do |t|
      t.references :user, null: false, foreign_key: true, index: { unique: true }
      t.string :nome_completo, null: false
      t.string :cpf, null: false
      t.string :telefone, null: false
      t.string :senha_emprestimo, null: false

      t.timestamps
    end

    add_index :usuario_bibliotecas, :cpf, unique: true
  end
end
