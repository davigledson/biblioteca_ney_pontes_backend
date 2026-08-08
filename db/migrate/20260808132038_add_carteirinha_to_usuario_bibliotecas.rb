class AddCarteirinhaToUsuarioBibliotecas < ActiveRecord::Migration[8.1]
  def change
    add_column :usuario_bibliotecas, :numero_carteirinha, :string, null: false, default: ""
    add_column :usuario_bibliotecas, :status_carteirinha, :integer, null: false, default: 0
    add_index :usuario_bibliotecas, :numero_carteirinha, unique: true
  end
end
