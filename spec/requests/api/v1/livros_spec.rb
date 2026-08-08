# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'API V1 Livros', type: :request do
  include AuthHelpers

  path '/api/v1/livros' do
    get 'Listar livros' do
      tags 'Livros'
      produces 'application/json'
      security [{ bearerAuth: [] }]
      parameter name: :page, in: :query, type: :integer, required: false
      parameter name: :per_page, in: :query, type: :integer, required: false

      response 200, 'Lista de livros' do
        header 'X-Page', type: :integer, description: 'Pagina atual'
        header 'X-Per-Page', type: :integer, description: 'Itens por pagina'
        header 'X-Total', type: :integer, description: 'Total de registros'
        header 'X-Total-Pages', type: :integer, description: 'Total de paginas'

        schema type: :array,
          items: {
            type: :object,
            properties: {
              id: { type: :integer },
              titulo: { type: :string },
              autor: { type: :string },
              status: { type: :string },
              observacoes: { type: :string, nullable: true },
              categoria: {
                type: :object,
                properties: {
                  id: { type: :integer },
                  nome: { type: :string }
                }
              },
              created_at: { type: :string, format: 'date-time' },
              updated_at: { type: :string, format: 'date-time' }
            }
          }

        let!(:user) { create_bibliotecario }
        let!(:categoria) { Categoria.create!(nome: 'Ficcao') }
        let!(:livro) { Livro.create!(titulo: 'Teste', autor: 'Autor', categoria: categoria) }
        let(:Authorization) { auth_headers(user)["Authorization"] }

        run_test!
      end
    end

    post 'Cadastrar livro' do
      tags 'Livros'
      consumes 'application/json'
      produces 'application/json'
      security [{ bearerAuth: [] }]

      parameter name: :payload, in: :body, schema: {
        type: :object,
        properties: {
          titulo: { type: :string, example: 'Dom Casmurro' },
          autor: { type: :string, example: 'Machado de Assis' },
          categoria_id: { type: :integer, example: 1 },
          status: { type: :integer, example: 0 },
          observacoes: { type: :string, example: 'Edicao especial' }
        },
        required: %w[titulo autor categoria_id]
      }

      response 201, 'Livro cadastrado' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            titulo: { type: :string },
            autor: { type: :string },
            status: { type: :string },
            observacoes: { type: :string, nullable: true },
            categoria: {
              type: :object,
              properties: {
                id: { type: :integer },
                nome: { type: :string }
              }
            },
            created_at: { type: :string, format: 'date-time' },
            updated_at: { type: :string, format: 'date-time' }
          }

        let!(:user) { create_bibliotecario }
        let!(:categoria) { Categoria.create!(nome: 'Ficcao') }
        let(:Authorization) { auth_headers(user)["Authorization"] }
        let(:payload) { { titulo: 'Dom Casmurro', autor: 'Machado de Assis', categoria_id: categoria.id } }

        run_test!
      end

      response 422, 'Dados invalidos' do
        schema type: :object,
          properties: {
            errors: {
              type: :array,
              items: { type: :string }
            }
          }

        let!(:user) { create_bibliotecario }
        let(:Authorization) { auth_headers(user)["Authorization"] }
        let(:payload) { { titulo: '', autor: '', categoria_id: nil } }

        run_test!
      end
    end
  end

  path '/api/v1/livros/{id}' do
    parameter name: :id, in: :path, type: :integer

    get 'Detalhes do livro' do
      tags 'Livros'
      produces 'application/json'
      security [{ bearerAuth: [] }]

      response 200, 'Livro encontrado' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            titulo: { type: :string },
            autor: { type: :string },
            status: { type: :string },
            observacoes: { type: :string, nullable: true },
            categoria: {
              type: :object,
              properties: {
                id: { type: :integer },
                nome: { type: :string }
              }
            },
            created_at: { type: :string, format: 'date-time' },
            updated_at: { type: :string, format: 'date-time' }
          }

        let!(:user) { create_bibliotecario }
        let!(:categoria) { Categoria.create!(nome: 'Ficcao') }
        let!(:livro) { Livro.create!(titulo: 'Teste', autor: 'Autor', categoria: categoria) }
        let(:Authorization) { auth_headers(user)["Authorization"] }
        let(:id) { livro.id }

        run_test!
      end

      response 404, 'Livro nao encontrado' do
        schema type: :object,
          properties: {
            error: { type: :string }
          }

        let!(:user) { create_bibliotecario }
        let(:Authorization) { auth_headers(user)["Authorization"] }
        let(:id) { 9999 }

        run_test!
      end
    end

    put 'Atualizar livro' do
      tags 'Livros'
      consumes 'application/json'
      produces 'application/json'
      security [{ bearerAuth: [] }]

      parameter name: :payload, in: :body, schema: {
        type: :object,
        properties: {
          titulo: { type: :string },
          autor: { type: :string },
          categoria_id: { type: :integer },
          status: { type: :integer },
          observacoes: { type: :string }
        }
      }

      response 200, 'Livro atualizado' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            titulo: { type: :string },
            autor: { type: :string },
            status: { type: :string },
            observacoes: { type: :string, nullable: true },
            categoria: {
              type: :object,
              properties: {
                id: { type: :integer },
                nome: { type: :string }
              }
            },
            created_at: { type: :string, format: 'date-time' },
            updated_at: { type: :string, format: 'date-time' }
          }

        let!(:user) { create_bibliotecario }
        let!(:categoria) { Categoria.create!(nome: 'Ficcao') }
        let!(:livro) { Livro.create!(titulo: 'Antigo', autor: 'Autor', categoria: categoria) }
        let(:Authorization) { auth_headers(user)["Authorization"] }
        let(:id) { livro.id }
        let(:payload) { { titulo: 'Atualizado' } }

        run_test!
      end
    end

    delete 'Remover livro' do
      tags 'Livros'
      produces 'application/json'
      security [{ bearerAuth: [] }]

      response 204, 'Livro removido' do
        let!(:user) { create_bibliotecario }
        let!(:categoria) { Categoria.create!(nome: 'Remover') }
        let!(:livro) { Livro.create!(titulo: 'Remover', autor: 'Autor', categoria: categoria) }
        let(:Authorization) { auth_headers(user)["Authorization"] }
        let(:id) { livro.id }

        run_test!
      end
    end
  end
end
