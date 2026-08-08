unless User.exists?(email: "admin@biblioteca.com")
  User.create!(
    nome: "Administrador",
    email: "admin@biblioteca.com",
    password: "admin123",
    password_confirmation: "admin123",
    role: :bibliotecario,
    first_login: true
  )
end

unless User.exists?(email: "cidadao@email.com")
  user = User.create!(
    nome: "Joao",
    email: "cidadao@email.com",
    password: "senha123",
    password_confirmation: "senha123",
    role: :cidadao,
    first_login: false
  )
  user.create_usuario_biblioteca!(
    nome_completo: "Joao da Silva",
    cpf: "123.456.789-00",
    telefone: "84999999999",
    senha_emprestimo: "abc123"
  )
end

["Ficcao", "Nao Ficcao", "Infantil", "Historia", "Ciencia", "Biografia"].each do |nome|
  Categoria.find_or_create_by!(nome: nome)
end

puts "Seeds carregados!"
