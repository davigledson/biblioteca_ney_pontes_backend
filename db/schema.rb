# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_08_08_220900) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "categorias", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "nome", null: false
    t.datetime "updated_at", null: false
    t.index ["nome"], name: "index_categorias_on_nome", unique: true
  end

  create_table "emprestimos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "data_devolucao_prevista", null: false
    t.date "data_devolucao_real"
    t.datetime "data_emprestimo", null: false
    t.bigint "livro_id", null: false
    t.integer "renovacoes", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.bigint "usuario_biblioteca_id", null: false
    t.index ["livro_id"], name: "index_emprestimos_on_livro_id"
    t.index ["usuario_biblioteca_id"], name: "index_emprestimos_on_usuario_biblioteca_id"
  end

  create_table "enderecos", force: :cascade do |t|
    t.string "bairro"
    t.string "cep"
    t.string "cidade"
    t.string "complemento"
    t.datetime "created_at", null: false
    t.string "logradouro"
    t.string "numero"
    t.string "uf"
    t.datetime "updated_at", null: false
    t.bigint "usuario_biblioteca_id", null: false
    t.index ["usuario_biblioteca_id"], name: "index_enderecos_on_usuario_biblioteca_id"
  end

  create_table "livros", force: :cascade do |t|
    t.string "autor", null: false
    t.bigint "capa_blob_id"
    t.bigint "categoria_id", null: false
    t.datetime "created_at", null: false
    t.text "observacoes"
    t.integer "status", default: 0, null: false
    t.string "titulo", null: false
    t.datetime "updated_at", null: false
    t.index ["capa_blob_id"], name: "index_livros_on_capa_blob_id"
    t.index ["categoria_id"], name: "index_livros_on_categoria_id"
  end

  create_table "multas", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "emprestimo_id", null: false
    t.boolean "pago", default: false, null: false
    t.datetime "updated_at", null: false
    t.decimal "valor", precision: 8, scale: 2, null: false
    t.index ["emprestimo_id"], name: "index_multas_on_emprestimo_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.boolean "first_login", default: true
    t.string "jti", null: false
    t.string "nome", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "role", default: 1, null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "usuario_bibliotecas", force: :cascade do |t|
    t.string "cpf", null: false
    t.datetime "created_at", null: false
    t.string "nome_completo", null: false
    t.string "numero_carteirinha", default: "", null: false
    t.string "senha_emprestimo", null: false
    t.integer "status_carteirinha", default: 0, null: false
    t.string "telefone", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["cpf"], name: "index_usuario_bibliotecas_on_cpf", unique: true
    t.index ["numero_carteirinha"], name: "index_usuario_bibliotecas_on_numero_carteirinha", unique: true
    t.index ["user_id"], name: "index_usuario_bibliotecas_on_user_id", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "emprestimos", "livros"
  add_foreign_key "emprestimos", "usuario_bibliotecas"
  add_foreign_key "enderecos", "usuario_bibliotecas"
  add_foreign_key "livros", "categorias"
  add_foreign_key "multas", "emprestimos"
  add_foreign_key "usuario_bibliotecas", "users"
end
