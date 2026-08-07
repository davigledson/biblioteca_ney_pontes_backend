class Livro < ApplicationRecord
  belongs_to :categoria

  enum :status, { disponivel: 0, emprestado: 1 }

  validates :titulo, presence: true
  validates :autor, presence: true
  validates :categoria, presence: true
  validates :status, presence: true
end
