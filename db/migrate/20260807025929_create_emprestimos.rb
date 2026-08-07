class CreateEmprestimos < ActiveRecord::Migration[8.1]
  def change
    create_table :emprestimos do |t|
      t.references :livro, null: false, foreign_key: true
      t.references :usuario_biblioteca, null: false, foreign_key: true
      t.datetime :data_emprestimo, null: false
      t.date :data_devolucao_prevista, null: false
      t.date :data_devolucao_real
      t.integer :status, null: false, default: 0
      t.integer :renovacoes, null: false, default: 0

      t.timestamps
    end
  end
end
