class AddCapaBlobIdToLivros < ActiveRecord::Migration[8.1]
  def change
    add_column :livros, :capa_blob_id, :bigint
    add_index :livros, :capa_blob_id
  end
end