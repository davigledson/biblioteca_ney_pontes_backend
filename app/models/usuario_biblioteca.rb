class UsuarioBiblioteca < ApplicationRecord
  belongs_to :user
  has_many :emprestimos, dependent: :restrict_with_error

  enum :status_carteirinha, { ativa: 0, inativa: 1 }

  validates :nome_completo, presence: true
  validates :cpf, presence: true, uniqueness: { case_sensitive: false }
  validates :telefone, presence: true
  validates :senha_emprestimo, presence: true
  validates :numero_carteirinha, presence: true, uniqueness: true

  before_validation :gerar_numero_carteirinha, on: :create

  private

  def gerar_numero_carteirinha
    self.numero_carteirinha = "BNP-#{Date.current.year}-#{SecureRandom.hex(4).upcase}" if numero_carteirinha.blank?
  end
end
