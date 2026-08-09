class UserMailerPreview < ActionMailer::Preview
  def senha_emprestimo
    usuario = UsuarioBiblioteca.first || UsuarioBiblioteca.new(
      nome_completo: "Joao da Silva",
      cpf: "123.456.789-00",
      telefone: "84999999999",
      senha_emprestimo: "abc123",
      numero_carteirinha: "BNP-2026-A1B2C3D4",
      status_carteirinha: :ativa
    )
    UserMailer.senha_emprestimo(usuario)
  end
end
