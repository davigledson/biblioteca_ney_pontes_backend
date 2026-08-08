class UserMailer < ApplicationMailer
  default from: "biblioteca@mossoro.rn.gov.br"

  def senha_emprestimo(usuario_biblioteca)
    @usuario = usuario_biblioteca
    @user = usuario_biblioteca.user
    mail(
      to: @user.email,
      subject: "Biblioteca Ney Pontes - Sua senha de emprestimo"
    )
  end
end
