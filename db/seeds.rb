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

ficcao = Categoria.find_by(nome: "Ficcao")
nao_ficcao = Categoria.find_by(nome: "Nao Ficcao")
infantil = Categoria.find_by(nome: "Infantil")
historia = Categoria.find_by(nome: "Historia")
ciencia = Categoria.find_by(nome: "Ciencia")
biografia = Categoria.find_by(nome: "Biografia")

livros = [
  { titulo: "Dom Casmurro", autor: "Machado de Assis", categoria: ficcao },
  { titulo: "Grande Sertao: Veredas", autor: "Guimaraes Rosa", categoria: ficcao },
  { titulo: "Vidas Secas", autor: "Graciliano Ramos", categoria: ficcao },
  { titulo: "O Cortico", autor: "Aluisio Azevedo", categoria: ficcao },
  { titulo: "1984", autor: "George Orwell", categoria: ficcao },
  { titulo: "O Povo Brasileiro", autor: "Darcy Ribeiro", categoria: nao_ficcao },
  { titulo: "O Genocidio do Negro Brasileiro", autor: "Abdias Nascimento", categoria: nao_ficcao },
  { titulo: "O Menino Maluquinho", autor: "Ziraldo", categoria: infantil },
  { titulo: "Reinaçoes de Narizinho", autor: "Monteiro Lobato", categoria: infantil },
  { titulo: "Casa-Grande & Senzala", autor: "Gilberto Freyre", categoria: historia },
  { titulo: "Mossoro: Cidade e Regiao", autor: "Raimundo Soares de Brito", categoria: historia },
  { titulo: "Uma Breve Historia do Tempo", autor: "Stephen Hawking", categoria: ciencia },
  { titulo: "O Diario de Anne Frank", autor: "Anne Frank", categoria: biografia },
  { titulo: "Quarto de Despejo", autor: "Carolina Maria de Jesus", categoria: biografia },
]

livros.each do |attrs|
  Livro.find_or_create_by!(titulo: attrs[:titulo], autor: attrs[:autor]) do |l|
    l.categoria = attrs[:categoria]
    l.status = :disponivel
  end
end

puts "Seeds carregados!"
