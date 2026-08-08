class CreateEnderecos < ActiveRecord::Migration[8.1]
  def change
    create_table :enderecos do |t|
      t.references :usuario_biblioteca, null: false, foreign_key: true
      t.string :cep
      t.string :logradouro
      t.string :bairro
      t.string :cidade
      t.string :uf
      t.string :numero
      t.string :complemento

      t.timestamps
    end
  end
end
