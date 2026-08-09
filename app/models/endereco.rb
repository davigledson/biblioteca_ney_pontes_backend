class Endereco < ApplicationRecord
  belongs_to :usuario_biblioteca

  validates :cep, presence: true
  validates :logradouro, presence: true
  validates :cidade, presence: true
  validates :uf, presence: true
end