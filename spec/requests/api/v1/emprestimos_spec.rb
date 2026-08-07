# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'API V1 Emprestimos', type: :request do
  include AuthHelpers

  let(:categoria) { Categoria.create!(nome: 'Ficcao') }
  let(:livro) { Livro.create!(titulo: 'Livro Teste', autor: 'Autor', categoria: categoria, status: :disponivel) }

  path '/api/v1/emprestimos' do
    get 'Listar emprestimos' do
      tags 'Emprestimos'
      produces 'application/json'
      security [{ bearerAuth: [] }]

      response 200, 'Lista de emprestimos (bibliotecario)' do
        schema type: :array,
          items: {
            type: :object,
            properties: {
              id: { type: :integer },
              status: { type: :string },
              data_emprestimo: { type: :string, format: 'date-time' },
              data_devolucao_prevista: { type: :string, format: 'date' },
              data_devolucao_real: { type: :string, format: 'date', nullable: true },
              renovacoes: { type: :integer },
              livro: {
                type: :object,
                properties: {
                  id: { type: :integer },
                  titulo: { type: :string },
                  autor: { type: :string }
                }
              },
              usuario_biblioteca: {
                type: :object,
                properties: {
                  id: { type: :integer },
                  nome_completo: { type: :string },
                  cpf: { type: :string }
                }
              },
              multa: { type: :object, nullable: true },
              created_at: { type: :string, format: 'date-time' }
            }
          }

        let!(:user) { create_bibliotecario }
        let(:Authorization) { auth_headers(user)["Authorization"] }

        run_test!
      end
    end

    post 'Realizar emprestimo' do
      tags 'Emprestimos'
      consumes 'application/json'
      produces 'application/json'
      security [{ bearerAuth: [] }]

      parameter name: :payload, in: :body, schema: {
        type: :object,
        properties: {
          livro_id: { type: :integer, example: 1 },
          usuario_biblioteca_id: { type: :integer, example: 1 },
          senha_emprestimo: { type: :string, example: 'abc123' }
        },
        required: %w[livro_id usuario_biblioteca_id senha_emprestimo]
      }

      response 201, 'Emprestimo realizado' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            status: { type: :string },
            data_emprestimo: { type: :string, format: 'date-time' },
            data_devolucao_prevista: { type: :string, format: 'date' },
            data_devolucao_real: { type: :string, format: 'date', nullable: true },
            renovacoes: { type: :integer },
            livro: {
              type: :object,
              properties: { id: { type: :integer }, titulo: { type: :string }, autor: { type: :string } }
            },
            usuario_biblioteca: {
              type: :object,
              properties: { id: { type: :integer }, nome_completo: { type: :string }, cpf: { type: :string } }
            },
            multa: { type: :object, nullable: true },
            created_at: { type: :string, format: 'date-time' }
          }

        let!(:user) { create_bibliotecario }
        let!(:cidadao) { create_cidadao }
        let(:Authorization) { auth_headers(user)["Authorization"] }
        let(:payload) { { livro_id: livro.id, usuario_biblioteca_id: cidadao.usuario_biblioteca.id, senha_emprestimo: 'abc123' } }

        run_test!
      end

      response 401, 'Senha invalida' do
        schema type: :object, properties: { error: { type: :string } }

        let!(:user) { create_bibliotecario }
        let!(:cidadao) { create_cidadao }
        let(:Authorization) { auth_headers(user)["Authorization"] }
        let(:payload) { { livro_id: livro.id, usuario_biblioteca_id: cidadao.usuario_biblioteca.id, senha_emprestimo: 'errada' } }

        run_test!
      end
    end
  end

  path '/api/v1/emprestimos/{id}' do
    parameter name: :id, in: :path, type: :integer

    get 'Detalhes do emprestimo' do
      tags 'Emprestimos'
      produces 'application/json'
      security [{ bearerAuth: [] }]

      response 200, 'Emprestimo encontrado' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            status: { type: :string },
            data_emprestimo: { type: :string, format: 'date-time' },
            data_devolucao_prevista: { type: :string, format: 'date' },
            data_devolucao_real: { type: :string, format: 'date', nullable: true },
            renovacoes: { type: :integer },
            livro: {
              type: :object,
              properties: { id: { type: :integer }, titulo: { type: :string }, autor: { type: :string } }
            },
            usuario_biblioteca: {
              type: :object,
              properties: { id: { type: :integer }, nome_completo: { type: :string }, cpf: { type: :string } }
            },
            multa: { type: :object, nullable: true },
            created_at: { type: :string, format: 'date-time' }
          }

        let!(:user) { create_bibliotecario }
        let!(:cidadao) { create_cidadao }
        let!(:emprestimo) { Emprestimo.create!(livro: livro, usuario_biblioteca: cidadao.usuario_biblioteca, data_emprestimo: Time.current) }
        let(:Authorization) { auth_headers(user)["Authorization"] }
        let(:id) { emprestimo.id }

        run_test!
      end
    end
  end

  path '/api/v1/emprestimos/{id}/devolver' do
    put 'Registrar devolucao' do
      tags 'Emprestimos'
      produces 'application/json'
      security [{ bearerAuth: [] }]
      parameter name: :id, in: :path, type: :integer

      response 200, 'Devolucao registrada' do
        let!(:user) { create_bibliotecario }
        let!(:cidadao) { create_cidadao }
        let!(:emprestimo) { Emprestimo.create!(livro: livro, usuario_biblioteca: cidadao.usuario_biblioteca, data_emprestimo: Time.current) }
        let(:Authorization) { auth_headers(user)["Authorization"] }
        let(:id) { emprestimo.id }

        run_test!
      end
    end
  end

  path '/api/v1/emprestimos/{id}/renovar' do
    put 'Renovar emprestimo' do
      tags 'Emprestimos'
      produces 'application/json'
      security [{ bearerAuth: [] }]
      parameter name: :id, in: :path, type: :integer

      response 200, 'Emprestimo renovado' do
        let!(:cidadao) { create_cidadao }
        let!(:emprestimo) { Emprestimo.create!(livro: livro, usuario_biblioteca: cidadao.usuario_biblioteca, data_emprestimo: Time.current) }
        let(:Authorization) { auth_headers(cidadao)["Authorization"] }
        let(:id) { emprestimo.id }

        run_test!
      end
    end
  end

  path '/api/v1/emprestimos/atrasados' do
    get 'Relatorio de livros em atraso' do
      tags 'Emprestimos'
      produces 'application/json'
      security [{ bearerAuth: [] }]

      response 200, 'Lista de atrasados' do
        let!(:user) { create_bibliotecario }
        let(:Authorization) { auth_headers(user)["Authorization"] }

        run_test!
      end
    end
  end

  path '/api/v1/emprestimos/historico' do
    get 'Historico de emprestimos por usuario' do
      tags 'Emprestimos'
      produces 'application/json'
      security [{ bearerAuth: [] }]
      parameter name: :usuario_biblioteca_id, in: :query, type: :integer, required: true

      response 200, 'Historico encontrado' do
        let!(:user) { create_bibliotecario }
        let!(:cidadao) { create_cidadao }
        let(:Authorization) { auth_headers(user)["Authorization"] }
        let(:usuario_biblioteca_id) { cidadao.usuario_biblioteca.id }

        run_test!
      end
    end
  end
end
