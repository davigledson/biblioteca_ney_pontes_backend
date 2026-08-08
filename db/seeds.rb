require "securerandom"

# ======== Usuarios base (autenticacao) ========

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

# ======= Bibliotecarios (10 no total) =======

bibliotecarios = [
  { nome: "Maria Oliveira", email: "maria.bibliotecaria@biblioteca.com", primeiro_acesso: true },
  { nome: "Carlos Pereira", email: "carlos.bibliotecario@biblioteca.com", primeiro_acesso: true },
  { nome: "Joao Pedro Costa", email: "joaopedro.bibliotecario@biblioteca.com", primeiro_acesso: false },
  { nome: "Paulo Henrique Santos", email: "paulo.bibliotecario@biblioteca.com", primeiro_acesso: false },
  { nome: "Fernanda Lima", email: "fernanda.bibliotecaria@biblioteca.com", primeiro_acesso: false },
  { nome: "Jose Alves", email: "jose.bibliotecario@biblioteca.com", primeiro_acesso: false },
  { nome: "Juliana Castro", email: "juliana.bibliotecaria@biblioteca.com", primeiro_acesso: false },
  { nome: "Marcelo Nunes", email: "marcelo.bibliotecario@biblioteca.com", primeiro_acesso: false },
  { nome: "Camila Rocha", email: "camila.bibliotecaria@biblioteca.com", primeiro_acesso: false }
]

bibliotecarios.each do |b|
  next if User.exists?(email: b[:email])

  User.create!(
    nome: b[:nome],
    email: b[:email],
    password: "senha123",
    password_confirmation: "senha123",
    role: :bibliotecario,
    first_login: b[:primeiro_acesso]
  )
end

# ======= Categorias (10) =======

["Ficcao", "Nao Ficcao", "Infantil", "Historia", "Ciencia", "Biografia", "Poesia", "Romance", "Tecnologia", "Filosofia"].each do |nome|
  Categoria.find_or_create_by!(nome: nome)
end

ficcao = Categoria.find_by(nome: "Ficcao")
nao_ficcao = Categoria.find_by(nome: "Nao Ficcao")
infantil = Categoria.find_by(nome: "Infantil")
historia = Categoria.find_by(nome: "Historia")
ciencia = Categoria.find_by(nome: "Ciencia")
biografia = Categoria.find_by(nome: "Biografia")
poesia = Categoria.find_by(nome: "Poesia")
romance = Categoria.find_by(nome: "Romance")
tecnologia = Categoria.find_by(nome: "Tecnologia")
filosofia = Categoria.find_by(nome: "Filosofia")

# ======= Livros (20) =======

livros = [
  { titulo: "Dom Casmurro", autor: "Machado de Assis", categoria: ficcao },
  { titulo: "Grande Sertao: Veredas", autor: "Guimaraes Rosa", categoria: ficcao },
  { titulo: "Vidas Secas", autor: "Graciliano Ramos", categoria: ficcao },
  { titulo: "O Cortico", autor: "Aluisio Azevedo", categoria: ficcao },
  { titulo: "1984", autor: "George Orwell", categoria: ficcao },
  { titulo: "O Povo Brasileiro", autor: "Darcy Ribeiro", categoria: nao_ficcao },
  { titulo: "O Genocidio do Negro Brasileiro", autor: "Abdias Nascimento", categoria: nao_ficcao },
  { titulo: "O Menino Maluquinho", autor: "Ziraldo", categoria: infantil },
  { titulo: "Reinacoes de Narizinho", autor: "Monteiro Lobato", categoria: infantil },
  { titulo: "Casa-Grande & Senzala", autor: "Gilberto Freyre", categoria: historia },
  { titulo: "Mossoro: Cidade e Regiao", autor: "Raimundo Soares de Brito", categoria: historia },
  { titulo: "Uma Breve Historia do Tempo", autor: "Stephen Hawking", categoria: ciencia },
  { titulo: "O Diario de Anne Frank", autor: "Anne Frank", categoria: biografia },
  { titulo: "Quarto de Despejo", autor: "Carolina Maria de Jesus", categoria: biografia },
  { titulo: "O Alquimista", autor: "Paulo Coelho", categoria: romance },
  { titulo: "Cem Anos de Solidao", autor: "Gabriel Garcia Marquez", categoria: romance },
  { titulo: "Antologia Poetica", autor: "Manuel Bandeira", categoria: poesia },
  { titulo: "Codigo Limpo", autor: "Robert C. Martin", categoria: tecnologia },
  { titulo: "O Mundo de Sofia", autor: "Jostein Gaarder", categoria: filosofia },
  { titulo: "A Maquina do Tempo", autor: "H. G. Wells", categoria: romance }
]

livros.each do |attrs|
  Livro.find_or_create_by!(titulo: attrs[:titulo], autor: attrs[:autor]) do |l|
    l.categoria = attrs[:categoria]
    l.status = :disponivel
  end
end

# ======= Cidadaos (10 no total, cada um com endereco) =======

bairros_mossoro = [
  "Alto de Sao Manoel", "Aeroporto", "Centro", "Abolicao", "Barra",
  "Santa Fe", "Bom Jardim", "Dourado", "Guava", "Nova Betania"
]

cidadaos = [
  { nome: "Maria", nome_completo: "Maria da Conceicao Oliveira", email: "maria.cidadao@email.com", cpf: "234.567.890-01", telefone: "84988887777" },
  { nome: "Jose", nome_completo: "Jose Ricardo Alves", email: "jose.cidadao@email.com", cpf: "345.678.901-02", telefone: "84977776666" },
  { nome: "Ana", nome_completo: "Ana Paula Martins", email: "ana.cidadao@email.com", cpf: "456.789.012-03", telefone: "84966665555" },
  { nome: "Pedro", nome_completo: "Pedro Henrique Souza", email: "pedro.cidadao@email.com", cpf: "567.890.123-04", telefone: "84955554444" },
  { nome: "Luiza", nome_completo: "Luiza Camargo", email: "luiza.cidadao@email.com", cpf: "678.901.234-05", telefone: "84944443333" },
  { nome: "Rafael", nome_completo: "Rafael Dias", email: "rafael.cidadao@email.com", cpf: "789.012.345-06", telefone: "84933332222" },
  { nome: "Beatriz", nome_completo: "Beatriz Almeida", email: "beatriz.cidadao@email.com", cpf: "890.123.456-07", telefone: "84922221111" },
  { nome: "Gustavo", nome_completo: "Gustavo Lima", email: "gustavo.cidadao@email.com", cpf: "901.234.567-08", telefone: "84911110000" },
  { nome: "Marina", nome_completo: "Marina Gomes", email: "marina.cidadao@email.com", cpf: "012.345.678-09", telefone: "84900009999" }
]

cidadaos.each_with_index do |c, i|
  next if User.exists?(email: c[:email])

  user = User.create!(
    nome: c[:nome],
    email: c[:email],
    password: "senha123",
    password_confirmation: "senha123",
    role: :cidadao,
    first_login: false
  )
  user.create_usuario_biblioteca!(
    nome_completo: c[:nome_completo],
    cpf: c[:cpf],
    telefone: c[:telefone],
    senha_emprestimo: SecureRandom.hex(3),
    endereco_attributes: {
      cep: "59600-000",
      logradouro: "Rua das Flores",
      bairro: bairros_mossoro[i % bairros_mossoro.size],
      cidade: "Mossoró",
      uf: "RN",
      numero: "12",
      complemento: ""
    }
  )
end

# ======= Emprestimos (21, inclui 10 devolucoes com multa) =======

if Emprestimo.none?
  cidadaos_livros = UsuarioBiblioteca.includes(:user).order(:id).to_a

  def gerar_emprestimo(livro_titulo, usuario, data_emprestimo, prevista, devolvido_em: nil, pago: false, renovacoes: 0)
    livro = Livro.find_by!(titulo: livro_titulo)
    emprestimo = Emprestimo.create!(
      livro: livro,
      usuario_biblioteca: usuario,
      data_emprestimo: data_emprestimo,
      data_devolucao_prevista: prevista,
      renovacoes: renovacoes,
      status: :ativo
    )

    if devolvido_em
      em_dia = devolvido_em <= prevista
      emprestimo.update!(
        data_devolucao_real: devolvido_em,
        status: em_dia ? :devolvido : :atrasado
      )
      livro.update!(status: :disponivel)
      unless em_dia
        emprestimo.create_multa!(valor: 2.0)
        emprestimo.multa.update!(pago: pago)
      end
    else
      livro.update!(status: :emprestado)
    end

    emprestimo
  end

  # Ativos em dia (5)
  gerar_emprestimo("Dom Casmurro", cidadaos_livros[0], Time.current - 2.days, (Time.current - 2.days).to_date + 12)
  gerar_emprestimo("Vidas Secas", cidadaos_livros[1], Time.current - 5.days, (Time.current - 5.days).to_date + 15)
  gerar_emprestimo("1984", cidadaos_livros[2], Time.current - 8.days, (Time.current - 8.days).to_date + 10)
  gerar_emprestimo("O Alquimista", cidadaos_livros[3], Time.current - 12.days, (Time.current - 12.days).to_date + 15, renovacoes: 1)
  gerar_emprestimo("Codigo Limpo", cidadaos_livros[4], Time.current - 3.days, (Time.current - 3.days).to_date + 15)

  # Ativos vencidos (3) - aparecem no relatorio de atrasados
  gerar_emprestimo("O Cortico", cidadaos_livros[0], Time.current - 40.days, (Time.current - 40.days).to_date + 15)
  gerar_emprestimo("Uma Breve Historia do Tempo", cidadaos_livros[5], Time.current - 55.days, (Time.current - 55.days).to_date + 15)
  gerar_emprestimo("O Mundo de Sofia", cidadaos_livros[6], Time.current - 25.days, (Time.current - 25.days).to_date + 15)

  # Devolvidos no prazo (3)
  gerar_emprestimo("O Menino Maluquinho", cidadaos_livros[7], Time.current - 60.days, (Time.current - 60.days).to_date + 15, devolvido_em: (Time.current - 45.days).to_date)
  gerar_emprestimo("Reinacoes de Narizinho", cidadaos_livros[8], Time.current - 30.days, (Time.current - 30.days).to_date + 15, devolvido_em: (Time.current - 22.days).to_date)
  gerar_emprestimo("Mossoro: Cidade e Regiao", cidadaos_livros[0], Time.current - 75.days, (Time.current - 75.days).to_date + 15, devolvido_em: (Time.current - 65.days).to_date)

  # Devolvidos com atraso e multa (10)
  devolucoes_atrasadas = [
    ["Grande Sertao: Veredas", 1, 60, 30, false],
    ["O Povo Brasileiro", 2, 55, 25, false],
    ["O Genocidio do Negro Brasileiro", 3, 50, 20, false],
    ["Casa-Grande & Senzala", 4, 45, 22, false],
    ["O Diario de Anne Frank", 5, 40, 18, false],
    ["Quarto de Despejo", 0, 35, 16, false],
    ["Cem Anos de Solidao", 6, 30, 20, false],
    ["O Menino Maluquinho", 7, 25, 16, false],
    ["A Maquina do Tempo", 8, 20, 17, true],
    ["Mossoro: Cidade e Regiao", 1, 18, 16, true]
  ]

  devolucoes_atrasadas.each do |titulo, idx, dias_emprestimo, dias_ate_devolucao, pago|
    usuario = cidadaos_livros[idx % cidadaos_livros.size]
    data_emp = Time.current - dias_emprestimo.days
    prevista = data_emp.to_date + 15
    devolvido_em = data_emp.to_date + dias_ate_devolucao
    gerar_emprestimo(titulo, usuario, data_emp, prevista, devolvido_em: devolvido_em, pago: pago, renovacoes: 1)
  end
end

puts "Seeds carregados!"
puts "  Bibliotecarios: #{User.bibliotecario.count}"
puts "  Cidadaos: #{UsuarioBiblioteca.count}"
puts "  Categorias: #{Categoria.count}"
puts "  Livros: #{Livro.count}"
puts "  Emprestimos: #{Emprestimo.count}"
puts "  Multas: #{Multa.count}"