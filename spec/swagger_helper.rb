# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  config.openapi_root = Rails.root.join('swagger').to_s

  config.openapi_specs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'Biblioteca Municipal Ney Pontes - API',
        version: 'v1',
        description: 'API para o sistema da Biblioteca Municipal Ney Pontes'
      },
      components: {
        securitySchemes: {
          bearerAuth: {
            type: :http,
            scheme: :bearer,
            bearerFormat: 'JWT'
          }
        }
      },
      paths: {},
      servers: [
        {
          url: 'http://localhost:3001',
          description: 'Servidor de desenvolvimento'
        }
      ]
    }
  }

  config.openapi_format = :yaml
end
