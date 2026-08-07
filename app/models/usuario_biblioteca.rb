class UsuarioBiblioteca < ApplicationRecord
  belongs_to :user
  has_many :emprestimos, dependent: :restrict_with_error

  validates :nome_completo, presence: true
  validates :cpf, presence: true, uniqueness: { case_sensitive: false }
  validates :telefone, presence: true
  validates :senha_emprestimo, presence: true
end
