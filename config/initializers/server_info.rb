if defined?(Rails::Server)
  Rails.application.config.after_initialize do
    server_options = Rails::Server::Options.new.parse!(ARGV)
    port = server_options[:Port] || ENV.fetch("PORT", 3000)
    host = "http://localhost:#{port}"

    puts ""
    puts "=" * 60
    puts "  Biblioteca Municipal Ney Pontes - API"
    puts "=" * 60
    puts "  Swagger UI:  #{host}/api-docs"
    puts "  API Docs:    #{host}/api-docs/v1/swagger.yaml"
    puts "  Health:      #{host}/up"
    puts "  API Base:    #{host}/api/v1"
    puts "=" * 60
    puts ""
  end
end
