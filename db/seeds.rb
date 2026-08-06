unless User.exists?(email: "admin@biblioteca.com")
  User.create!(
    nome: "Administrador",
    email: "admin@biblioteca.com",
    password: "admin123",
    password_confirmation: "admin123",
    first_login: true
  )
end

["Ficcao", "Nao Ficcao", "Infantil", "Historia", "Ciencia", "Biografia"].each do |nome|
  Categoria.find_or_create_by!(nome: nome)
end

puts "Seeds carregados!"
