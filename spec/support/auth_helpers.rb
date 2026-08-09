module AuthHelpers
  def auth_headers(user)
    token = Warden::JWTAuth::UserEncoder.new.call(user, :api_v1_user, nil).first
    { "Authorization" => "Bearer #{token}", "Content-Type" => "application/json" }
  end

  def create_bibliotecario
    User.create!(
      nome: "Admin Teste",
      email: "admin@teste.com",
      password: "senha123",
      password_confirmation: "senha123",
      role: :bibliotecario,
      first_login: false
    )
  end

  def create_cidadao
    user = User.create!(
      nome: "Cidadao Teste",
      email: "cidadao@teste.com",
      password: "senha123",
      password_confirmation: "senha123",
      role: :cidadao,
      first_login: false
    )
    user.create_usuario_biblioteca!(
      nome_completo: "Cidadao da Silva",
      cpf: "123.456.789-00",
      telefone: "84999999999",
      senha_emprestimo: "abc123"
    )
    user
  end
end
