class Multa < ApplicationRecord
  belongs_to :emprestimo

  validates :valor, presence: true, numericality: { greater_than: 0 }
end
