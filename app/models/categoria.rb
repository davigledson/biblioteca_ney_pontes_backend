class Categoria < ApplicationRecord
  validates :nome, presence: true

  has_many :livros, dependent: :restrict_with_error
end
