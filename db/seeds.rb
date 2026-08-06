# Admin padrão do sistema
admin = User.find_or_initialize_by(email: "admin@biblioteca.com")
admin.assign_attributes(
  nome: "Administrador",
  password: "admin123",
  password_confirmation: "admin123",
  first_login: true
)
admin.save!

puts "Usuário admin criado: admin@biblioteca.com / admin123"
