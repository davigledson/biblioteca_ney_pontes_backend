class CreateMultas < ActiveRecord::Migration[8.1]
  def change
    create_table :multas do |t|
      t.references :emprestimo, null: false, foreign_key: true
      t.decimal :valor, null: false, precision: 8, scale: 2
      t.boolean :pago, null: false, default: false

      t.timestamps
    end
  end
end
