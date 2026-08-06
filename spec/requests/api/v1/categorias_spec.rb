# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'API V1 Categorias', type: :request do
  include AuthHelpers

  path '/api/v1/categorias' do
    get 'Listar categorias' do
      tags 'Categorias'
      produces 'application/json'
      security [{ bearerAuth: [] }]

      response 200, 'Lista de categorias' do
        schema type: :array,
          items: {
            type: :object,
            properties: {
              id: { type: :integer },
              nome: { type: :string },
              created_at: { type: :string, format: 'date-time' }
            }
          }

        let!(:user) { create_user }
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

    post 'Cadastrar categoria' do
      tags 'Categorias'
      consumes 'application/json'
      produces 'application/json'
      security [{ bearerAuth: [] }]

      parameter name: :payload, in: :body, schema: {
        type: :object,
        properties: {
          nome: { type: :string, example: 'Ficção' }
        },
        required: %w[nome]
      }

      response 201, 'Categoria cadastrada' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            nome: { type: :string },
            created_at: { type: :string, format: 'date-time' }
          }

        let!(:user) { create_user }
        let(:Authorization) { auth_headers(user)["Authorization"] }
        let(:payload) { { nome: 'Ficção' } }

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

        let!(:user) { create_user }
        let(:Authorization) { auth_headers(user)["Authorization"] }
        let(:payload) { { nome: '' } }

        run_test!
      end
    end
  end

  path '/api/v1/categorias/{id}' do
    parameter name: :id, in: :path, type: :integer

    get 'Detalhes da categoria' do
      tags 'Categorias'
      produces 'application/json'
      security [{ bearerAuth: [] }]

      response 200, 'Categoria encontrada' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            nome: { type: :string },
            created_at: { type: :string, format: 'date-time' }
          }

        let!(:user) { create_user }
        let!(:categoria) { Categoria.create!(nome: 'Ficção') }
        let(:Authorization) { auth_headers(user)["Authorization"] }
        let(:id) { categoria.id }

        run_test!
      end

      response 404, 'Categoria não encontrada' do
        schema type: :object,
          properties: {
            error: { type: :string }
          }

        let!(:user) { create_user }
        let(:Authorization) { auth_headers(user)["Authorization"] }
        let(:id) { 9999 }

        run_test!
      end
    end

    put 'Atualizar categoria' do
      tags 'Categorias'
      consumes 'application/json'
      produces 'application/json'
      security [{ bearerAuth: [] }]

      parameter name: :payload, in: :body, schema: {
        type: :object,
        properties: {
          nome: { type: :string, example: 'Ficção Científica' }
        },
        required: %w[nome]
      }

      response 200, 'Categoria atualizada' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            nome: { type: :string },
            created_at: { type: :string, format: 'date-time' }
          }

        let!(:user) { create_user }
        let!(:categoria) { Categoria.create!(nome: 'Ficção') }
        let(:Authorization) { auth_headers(user)["Authorization"] }
        let(:id) { categoria.id }
        let(:payload) { { nome: 'Ficção Científica' } }

        run_test!
      end
    end

    delete 'Remover categoria' do
      tags 'Categorias'
      produces 'application/json'
      security [{ bearerAuth: [] }]

      response 204, 'Categoria removida' do
        let!(:user) { create_user }
        let!(:categoria) { Categoria.create!(nome: 'Remover') }
        let(:Authorization) { auth_headers(user)["Authorization"] }
        let(:id) { categoria.id }

        run_test!
      end
    end
  end
end
