module AuthHelpers
  def auth_headers(user)
    token = Warden::JWTAuth::UserEncoder.new.call(user, :api_v1_user, nil).first
    { "Authorization" => "Bearer #{token}", "Content-Type" => "application/json" }
  end

  def create_user
    User.create!(
      nome: "Admin Teste",
      email: "admin@teste.com",
      password: "senha123",
      password_confirmation: "senha123",
      first_login: false
    )
  end
end
