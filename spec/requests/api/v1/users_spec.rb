# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'API V1 Users', type: :request do
  include AuthHelpers

  path '/api/v1/login' do
    post 'Autenticar bibliotecário' do
      tags 'Autenticação'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :credentials, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string, example: 'admin@biblioteca.com' },
          password: { type: :string, example: 'senha123' }
        },
        required: %w[email password]
      }

      response 200, 'Login realizado com sucesso' do
        schema type: :object,
          properties: {
            message: { type: :string },
            user: {
              type: :object,
              properties: {
                id: { type: :integer },
                nome: { type: :string },
                email: { type: :string },
                first_login: { type: :boolean }
              }
            },
            token: { type: :string }
          }

        let!(:user) { create_bibliotecario }
        let(:credentials) { { email: user.email, password: 'senha123' } }

        run_test!
      end

      response 401, 'Credenciais inválidas' do
        schema type: :object,
          properties: {
            error: { type: :string }
          }

        let(:credentials) { { email: 'invalido@teste.com', password: 'errada' } }

        run_test!
      end
    end
  end

  path '/api/v1/logout' do
    delete 'Encerrar sessão' do
      tags 'Autenticação'
      produces 'application/json'
      security [{ bearerAuth: [] }]

      response 200, 'Logout realizado com sucesso' do
        schema type: :object,
          properties: {
            message: { type: :string }
          }

        let!(:user) { create_bibliotecario }
        let(:Authorization) { auth_headers(user)["Authorization"] }

        run_test!
      end
    end
  end

  path '/api/v1/users/password' do
    post 'Solicitar recuperação de senha' do
      tags 'Autenticação'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :payload, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string }
        },
        required: %w[email]
      }

      response 200, 'Instruções enviadas' do
        schema type: :object,
          properties: {
            message: { type: :string }
          }

        let!(:user) { create_bibliotecario }
        let(:payload) { { email: user.email } }

        run_test!
      end

      response 422, 'E-mail não encontrado' do
        schema type: :object,
          properties: {
            error: { type: :string }
          }

        let(:payload) { { email: 'naoexiste@teste.com' } }

        run_test!
      end
    end
  end

  path '/api/v1/users' do
    get 'Listar bibliotecários' do
      tags 'Bibliotecários'
      produces 'application/json'
      security [{ bearerAuth: [] }]

      response 200, 'Lista de bibliotecários' do
        schema type: :array,
          items: {
            type: :object,
            properties: {
              id: { type: :integer },
              nome: { type: :string },
              email: { type: :string },
              first_login: { type: :boolean },
              created_at: { type: :string, format: 'date-time' }
            }
          }

        let!(:user) { create_bibliotecario }
        let(:Authorization) { auth_headers(user)["Authorization"] }

        run_test!
      end

      response 401, 'Não autorizado' do
        schema type: :object,
          properties: {
            error: { type: :string }
          }

        let(:Authorization) { 'Bearer invalid_token' }

        run_test!
      end
    end

    post 'Cadastrar bibliotecário' do
      tags 'Bibliotecários'
      consumes 'application/json'
      produces 'application/json'
      security [{ bearerAuth: [] }]

      parameter name: :payload, in: :body, schema: {
        type: :object,
        properties: {
          nome: { type: :string, example: 'Novo Bibliotecário' },
          email: { type: :string, example: 'novo@biblioteca.com' }
        },
        required: %w[nome email]
      }

      response 201, 'Bibliotecário cadastrado' do
        schema type: :object,
          properties: {
            message: { type: :string },
            user: {
              type: :object,
              properties: {
                id: { type: :integer },
                nome: { type: :string },
                email: { type: :string },
                first_login: { type: :boolean }
              }
            },
            temporary_password: { type: :string }
          }

        let!(:user) { create_bibliotecario }
        let(:Authorization) { auth_headers(user)["Authorization"] }
        let(:payload) { { nome: 'Novo Biblio', email: 'novo@biblioteca.com' } }

        run_test!
      end

      response 422, 'Dados inválidos' do
        schema type: :object,
          properties: {
            errors: {
              type: :array,
              items: { type: :string }
            }
          }

        let!(:user) { create_bibliotecario }
        let(:Authorization) { auth_headers(user)["Authorization"] }
        let(:payload) { { nome: '', email: '' } }

        run_test!
      end
    end
  end

  path '/api/v1/users/{id}' do
    parameter name: :id, in: :path, type: :integer

    get 'Detalhes do bibliotecário' do
      tags 'Bibliotecários'
      produces 'application/json'
      security [{ bearerAuth: [] }]

      response 200, 'Detalhes encontrados' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            nome: { type: :string },
            email: { type: :string },
            first_login: { type: :boolean },
            created_at: { type: :string, format: 'date-time' }
          }

        let!(:admin) { create_bibliotecario }
        let(:Authorization) { auth_headers(admin)["Authorization"] }
        let(:id) { admin.id }

        run_test!
      end

      response 404, 'Não encontrado' do
        schema type: :object,
          properties: {
            error: { type: :string }
          }

        let!(:admin) { create_bibliotecario }
        let(:Authorization) { auth_headers(admin)["Authorization"] }
        let(:id) { 9999 }

        run_test!
      end
    end

    put 'Atualizar bibliotecário' do
      tags 'Bibliotecários'
      consumes 'application/json'
      produces 'application/json'
      security [{ bearerAuth: [] }]

      parameter name: :payload, in: :body, schema: {
        type: :object,
        properties: {
          nome: { type: :string },
          email: { type: :string }
        }
      }

      response 200, 'Bibliotecário atualizado' do
        schema type: :object,
          properties: {
            message: { type: :string },
            user: {
              type: :object,
              properties: {
                id: { type: :integer },
                nome: { type: :string },
                email: { type: :string },
                first_login: { type: :boolean }
              }
            }
          }

        let!(:admin) { create_bibliotecario }
        let(:Authorization) { auth_headers(admin)["Authorization"] }
        let(:id) { admin.id }
        let(:payload) { { nome: 'Nome Atualizado' } }

        run_test!
      end
    end

    delete 'Remover bibliotecário' do
      tags 'Bibliotecários'
      produces 'application/json'
      security [{ bearerAuth: [] }]

      response 200, 'Bibliotecário removido' do
        schema type: :object,
          properties: {
            message: { type: :string }
          }

        let!(:admin) { create_bibliotecario }
        let(:target) { User.create!(nome: 'Remover', email: 'remover@teste.com', password: '123456', password_confirmation: '123456', role: :bibliotecario) }
        let(:Authorization) { auth_headers(admin)["Authorization"] }
        let(:id) { target.id }

        run_test!
      end
    end
  end

  path '/api/v1/users/{id}/change_password' do
    put 'Alterar senha' do
      tags 'Bibliotecários'
      consumes 'application/json'
      produces 'application/json'
      security [{ bearerAuth: [] }]

      parameter name: :id, in: :path, type: :integer
      parameter name: :payload, in: :body, schema: {
        type: :object,
        properties: {
          password: { type: :string, example: 'nova_senha_segura' },
          password_confirmation: { type: :string, example: 'nova_senha_segura' }
        },
        required: %w[password password_confirmation]
      }

      response 200, 'Senha alterada com sucesso' do
        schema type: :object,
          properties: {
            message: { type: :string }
          }

        let!(:admin) { create_bibliotecario }
        let(:Authorization) { auth_headers(admin)["Authorization"] }
        let(:id) { admin.id }
        let(:payload) { { password: 'nova_senha', password_confirmation: 'nova_senha' } }

        run_test!
      end
    end
  end
end
