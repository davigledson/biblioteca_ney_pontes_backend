class Livro < ApplicationRecord
  belongs_to :categoria
  has_many :emprestimos, dependent: :restrict_with_error
  has_one_attached :capa

  enum :status, { disponivel: 0, emprestado: 1 }

  validates :titulo, presence: true
  validates :autor, presence: true
  validates :categoria, presence: true
  validates :status, presence: true
  validate :validar_capa

  def sincronizar_capa_blob_id!
    update_columns(capa_blob_id: capa.attachment&.blob_id)
  end

  def remover_capa!
    capa.purge
    update_columns(capa_blob_id: nil)
  end

  private

  def validar_capa
    return unless capa.attached?

    unless capa.content_type.in?(%w[image/jpeg image/png image/webp])
      errors.add(:capa, "deve ser JPG, PNG ou WebP")
      capa.purge
    end

    if capa.attached? && capa.blob.byte_size > 5.megabytes
      errors.add(:capa, "deve ter no maximo 5 MB")
      capa.purge
    end
  end
end
