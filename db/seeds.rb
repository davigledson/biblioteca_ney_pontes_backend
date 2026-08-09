require "securerandom"

# ======== Usuarios base (autenticacao) ========

unless User.exists?(email: "admin@biblioteca.com")
  User.create!(
    nome: "Administrador",
    email: "admin@biblioteca.com",
    password: "admin123",
    password_confirmation: "admin123",
    role: :admin,
    first_login: true
  )
else
  User.find_by(email: "admin@biblioteca.com").update_column(:role, 2)
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

# ======= Emprestimos (demo variado e reexecutavel: ~29 + multas) =======

cidadaos_demo = UsuarioBiblioteca.includes(:user).order(:id).to_a

if cidadaos_demo.empty?
  puts "  Aviso: nenhum cidadao cadastrado, pulei o seed de emprestimos."
else
  demo_antes = Emprestimo.count

  def garantir_livro_demo(titulo, autor = "Autor Demo")
    Livro.find_or_create_by!(titulo: titulo) do |l|
      l.autor = autor
      l.categoria = Categoria.first || Categoria.find_or_create_by!(nome: "Ficcao")
      l.status = :disponivel
    end
  end

  def gerar_emprestimo_demo(titulo, usuario, data_emprestimo, prevista, devolvido_em: nil, pago: false, renovacoes: 0)
    livro = garantir_livro_demo(titulo)
    return if Emprestimo
      .where(livro: livro, usuario_biblioteca: usuario)
      .where("data_emprestimo::date = ?", data_emprestimo.to_date)
      .exists?
    return unless livro.disponivel? # livro ocupado por emprestimo real: nao mexo

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
  gerar_emprestimo_demo("Dom Casmurro", cidadaos_demo[0], Time.current - 2.days, (Time.current - 2.days).to_date + 12)
  gerar_emprestimo_demo("Vidas Secas", cidadaos_demo[1], Time.current - 5.days, (Time.current - 5.days).to_date + 15)
  gerar_emprestimo_demo("1984", cidadaos_demo[2], Time.current - 8.days, (Time.current - 8.days).to_date + 10)
  gerar_emprestimo_demo("O Alquimista", cidadaos_demo[3], Time.current - 12.days, (Time.current - 12.days).to_date + 15, renovacoes: 1)
  gerar_emprestimo_demo("Codigo Limpo", cidadaos_demo[4], Time.current - 3.days, (Time.current - 3.days).to_date + 15)

  # Ativos vencidos (3) - aparecem no relatorio de atrasados
  gerar_emprestimo_demo("O Cortico", cidadaos_demo[0], Time.current - 40.days, (Time.current - 40.days).to_date + 15)
  gerar_emprestimo_demo("Uma Breve Historia do Tempo", cidadaos_demo[5], Time.current - 55.days, (Time.current - 55.days).to_date + 15)
  gerar_emprestimo_demo("O Mundo de Sofia", cidadaos_demo[6], Time.current - 25.days, (Time.current - 25.days).to_date + 15)

  # Devolvidos no prazo (3)
  gerar_emprestimo_demo("O Menino Maluquinho", cidadaos_demo[7], Time.current - 60.days, (Time.current - 60.days).to_date + 15, devolvido_em: (Time.current - 45.days).to_date)
  gerar_emprestimo_demo("Reinacoes de Narizinho", cidadaos_demo[8], Time.current - 30.days, (Time.current - 30.days).to_date + 15, devolvido_em: (Time.current - 22.days).to_date)
  gerar_emprestimo_demo("Mossoro: Cidade e Regiao", cidadaos_demo[0], Time.current - 75.days, (Time.current - 75.days).to_date + 15, devolvido_em: (Time.current - 65.days).to_date)

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
    usuario = cidadaos_demo[idx % cidadaos_demo.size]
    data_emp = Time.current - dias_emprestimo.days
    prevista = data_emp.to_date + 15
    devolvido_em = data_emp.to_date + dias_ate_devolucao
    gerar_emprestimo_demo(titulo, usuario, data_emp, prevista, devolvido_em: devolvido_em, pago: pago, renovacoes: 1)
  end

  # Reforco no historico do primeiro cidadao (mais de 10 registros para testar paginacao)
  u0 = cidadaos_demo[0]

  gerar_emprestimo_demo("O Vendedor de Sonhos", u0, Time.current - 90.days, (Time.current - 90.days).to_date + 15, devolvido_em: (Time.current - 82.days).to_date)
  gerar_emprestimo_demo("O Poder do Habito", u0, Time.current - 70.days, (Time.current - 70.days).to_date + 15, devolvido_em: (Time.current - 63.days).to_date)
  gerar_emprestimo_demo("A Arte da Guerra", u0, Time.current - 52.days, (Time.current - 52.days).to_date + 15, devolvido_em: (Time.current - 44.days).to_date)
  gerar_emprestimo_demo("Mindset", u0, Time.current - 36.days, (Time.current - 36.days).to_date + 15, devolvido_em: (Time.current - 26.days).to_date)
  gerar_emprestimo_demo("O Homem Mais Rico da Babilonia", u0, Time.current - 21.days, (Time.current - 21.days).to_date + 15, devolvido_em: (Time.current - 14.days).to_date)
  gerar_emprestimo_demo("Essencialismo", u0, Time.current - 15.days, (Time.current - 15.days).to_date + 15, devolvido_em: (Time.current - 8.days).to_date, pago: true)
  gerar_emprestimo_demo("A Sutil Arte de Ligar o Foda-se", u0, Time.current - 9.days, (Time.current - 9.days).to_date + 15, devolvido_em: (Time.current - 4.days).to_date, pago: false)
  gerar_emprestimo_demo("Comece pelo Porque", u0, Time.current - 7.days, (Time.current - 7.days).to_date + 15, devolvido_em: (Time.current - 1.days).to_date)
  gerar_emprestimo_demo("O Poder do Agora", u0, Time.current - 4.days, (Time.current - 4.days).to_date + 15, renovacoes: 2)

  puts "  Emprestimos demo criados: #{Emprestimo.count - demo_antes}"
end

puts "Seeds carregados!"
puts "  Bibliotecarios: #{User.bibliotecario.count}"
puts "  Cidadaos: #{UsuarioBiblioteca.count}"
puts "  Categorias: #{Categoria.count}"
puts "  Livros: #{Livro.count}"
puts "  Emprestimos: #{Emprestimo.count}"
puts "  Multas: #{Multa.count}"