# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'API V1 Cidadaos', type: :request do
  include AuthHelpers

  path '/api/v1/cidadaos' do
    get 'Listar cidadaos' do
      tags 'Cidadaos'
      produces 'application/json'
      security [{ bearerAuth: [] }]

      response 200, 'Lista de cidadaos' do
        schema type: :array,
          items: {
            type: :object,
            properties: {
              id: { type: :integer },
              nome_completo: { type: :string },
              cpf: { type: :string },
              telefone: { type: :string },
              email: { type: :string },
              senha_emprestimo: { type: :string },
              created_at: { type: :string, format: 'date-time' }
            }
          }

        let!(:user) { create_bibliotecario }
        let!(:cidadao) { create_cidadao }
        let(:Authorization) { auth_headers(user)["Authorization"] }

        run_test!
      end

      response 403, 'Acesso negado (cidadao)' do
        let!(:cidadao) { create_cidadao }
        let(:Authorization) { auth_headers(cidadao)["Authorization"] }

        run_test!
      end
    end

    post 'Cadastrar cidadao (admin)' do
      tags 'Cidadaos'
      consumes 'application/json'
      produces 'application/json'
      security [{ bearerAuth: [] }]

      parameter name: :payload, in: :body, schema: {
        type: :object,
        properties: {
          nome_completo: { type: :string, example: 'Joao Silva' },
          email: { type: :string, example: 'joao@email.com' },
          cpf: { type: :string, example: '111.222.333-44' },
          telefone: { type: :string, example: '84988888888' },
          senha_emprestimo: { type: :string, example: 'abc123' }
        },
        required: %w[nome_completo email cpf telefone senha_emprestimo]
      }

      response 201, 'Cidadao cadastrado' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            nome_completo: { type: :string },
            cpf: { type: :string },
            telefone: { type: :string },
            email: { type: :string },
            senha_emprestimo: { type: :string },
            created_at: { type: :string, format: 'date-time' }
          }

        let!(:user) { create_bibliotecario }
        let(:Authorization) { auth_headers(user)["Authorization"] }
        let(:payload) { { nome_completo: 'Joao', email: 'joao@email.com', cpf: '111.222.333-44', telefone: '84988888888', senha_emprestimo: 'abc123' } }

        run_test!
      end
    end
  end

  path '/api/v1/cidadaos/{id}' do
    parameter name: :id, in: :path, type: :integer

    get 'Detalhes do cidadao' do
      tags 'Cidadaos'
      produces 'application/json'
      security [{ bearerAuth: [] }]

      response 200, 'Cidadao encontrado (bibliotecario)' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            nome_completo: { type: :string },
            cpf: { type: :string },
            telefone: { type: :string },
            email: { type: :string },
            senha_emprestimo: { type: :string },
            created_at: { type: :string, format: 'date-time' }
          }

        let!(:user) { create_bibliotecario }
        let!(:cidadao) { create_cidadao }
        let(:Authorization) { auth_headers(user)["Authorization"] }
        let(:id) { cidadao.usuario_biblioteca.id }

        run_test!
      end

      response 200, 'Cidadao ve o proprio perfil' do
        let!(:cidadao) { create_cidadao }
        let(:Authorization) { auth_headers(cidadao)["Authorization"] }
        let(:id) { cidadao.usuario_biblioteca.id }

        run_test!
      end
    end

    put 'Atualizar cidadao' do
      tags 'Cidadaos'
      consumes 'application/json'
      produces 'application/json'
      security [{ bearerAuth: [] }]

      parameter name: :payload, in: :body, schema: {
        type: :object,
        properties: {
          nome_completo: { type: :string },
          telefone: { type: :string },
          senha_emprestimo: { type: :string }
        }
      }

      response 200, 'Cidadao atualizado' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            nome_completo: { type: :string },
            cpf: { type: :string },
            telefone: { type: :string },
            email: { type: :string },
            senha_emprestimo: { type: :string },
            created_at: { type: :string, format: 'date-time' }
          }

        let!(:user) { create_bibliotecario }
        let!(:cidadao) { create_cidadao }
        let(:Authorization) { auth_headers(user)["Authorization"] }
        let(:id) { cidadao.usuario_biblioteca.id }
        let(:payload) { { nome_completo: 'Atualizado' } }

        run_test!
      end
    end

    delete 'Remover cidadao' do
      tags 'Cidadaos'
      produces 'application/json'
      security [{ bearerAuth: [] }]

      response 204, 'Cidadao removido' do
        let!(:user) { create_bibliotecario }
        let!(:cidadao) { create_cidadao }
        let(:Authorization) { auth_headers(user)["Authorization"] }
        let(:id) { cidadao.usuario_biblioteca.id }

        run_test!
      end
    end
  end

  path '/api/v1/registro' do
    post 'Cadastro publico de cidadao' do
      tags 'Registro'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :payload, in: :body, schema: {
        type: :object,
        properties: {
          nome: { type: :string, example: 'Joao' },
          email: { type: :string, example: 'joao@email.com' },
          password: { type: :string, example: 'senha123' },
          password_confirmation: { type: :string, example: 'senha123' },
          nome_completo: { type: :string, example: 'Joao da Silva' },
          cpf: { type: :string, example: '111.222.333-44' },
          telefone: { type: :string, example: '84988888888' },
          senha_emprestimo: { type: :string, example: 'abc123' }
        },
        required: %w[nome email password password_confirmation nome_completo cpf telefone senha_emprestimo]
      }

      response 201, 'Cadastro realizado' do
        schema type: :object,
          properties: {
            message: { type: :string },
            user: {
              type: :object,
              properties: {
                id: { type: :integer },
                nome: { type: :string },
                email: { type: :string },
                role: { type: :string }
              }
            },
            usuario_biblioteca: {
              type: :object,
              properties: {
                id: { type: :integer },
                nome_completo: { type: :string },
                cpf: { type: :string },
                telefone: { type: :string },
                senha_emprestimo: { type: :string }
              }
            },
            token: { type: :string }
          }

        let(:payload) do
          {
            nome: "Joao",
            email: "joao#{SecureRandom.hex(2)}@email.com",
            password: "senha123",
            password_confirmation: "senha123",
            nome_completo: "Joao da Silva",
            cpf: "999.888.777-66",
            telefone: "84999999999",
            senha_emprestimo: "abc123"
          }
        end

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

        let(:payload) { { nome: "", email: "", password: "", nome_completo: "", cpf: "", telefone: "", senha_emprestimo: "" } }

        run_test!
      end
    end
  end

  path '/api/v1/perfil' do
    get 'Ver perfil do cidadao logado' do
      tags 'Perfil'
      produces 'application/json'
      security [{ bearerAuth: [] }]

      response 200, 'Perfil encontrado' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            nome_completo: { type: :string },
            cpf: { type: :string },
            telefone: { type: :string },
            email: { type: :string },
            senha_emprestimo: { type: :string },
            created_at: { type: :string, format: 'date-time' }
          }

        let!(:cidadao) { create_cidadao }
        let(:Authorization) { auth_headers(cidadao)["Authorization"] }

        run_test!
      end

      response 404, 'Bibliotecario nao tem perfil' do
        let!(:user) { create_bibliotecario }
        let(:Authorization) { auth_headers(user)["Authorization"] }

        run_test!
      end
    end

    put 'Atualizar perfil do cidadao logado' do
      tags 'Perfil'
      consumes 'application/json'
      produces 'application/json'
      security [{ bearerAuth: [] }]

      parameter name: :payload, in: :body, schema: {
        type: :object,
        properties: {
          nome_completo: { type: :string },
          telefone: { type: :string },
          senha_emprestimo: { type: :string }
        }
      }

      response 200, 'Perfil atualizado' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            nome_completo: { type: :string },
            cpf: { type: :string },
            telefone: { type: :string },
            email: { type: :string },
            senha_emprestimo: { type: :string },
            created_at: { type: :string, format: 'date-time' }
          }

        let!(:cidadao) { create_cidadao }
        let(:Authorization) { auth_headers(cidadao)["Authorization"] }
        let(:payload) { { nome_completo: 'Perfil Atualizado' } }

        run_test!
      end
    end
  end
end
