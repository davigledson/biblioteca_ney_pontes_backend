class Emprestimo < ApplicationRecord
  belongs_to :livro
  belongs_to :usuario_biblioteca
  has_one :multa, dependent: :destroy

  enum :status, { ativo: 0, devolvido: 1, atrasado: 2 }

  validates :data_emprestimo, presence: true
  validates :data_devolucao_prevista, presence: true
  validate :livro_disponivel, on: :create

  before_validation :calcular_devolucao_prevista, on: :create

  scope :ativos, -> { where(status: :ativo) }
  scope :atrasados, -> do
    where(status: :atrasado)
      .or(where(status: :ativo).where("data_devolucao_prevista < ?", Date.current))
  end

  def em_atraso?
    return false if devolvido?

    atrasado? || Date.current > data_devolucao_prevista
  end

  def dias_atraso
    return nil if devolvido?
    return 0 unless atrasado? || Date.current > data_devolucao_prevista

    referencia = data_devolucao_real || Date.current
    (referencia - data_devolucao_prevista).to_i
  end

  def devolver!(data_devolucao = Date.current)
    transaction do
      update!(data_devolucao_real: data_devolucao, status: status_devolucao(data_devolucao))
      livro.update!(status: :disponivel)
    end
  end

  def renovar!
    transaction do
      increment!(:renovacoes)
      nova_data = 15.business_days.from_now.to_date
      update!(data_devolucao_prevista: nova_data, status: :ativo)
    end
  end

  private

  def livro_disponivel
    return unless livro
    errors.add(:livro, "nao esta disponivel para emprestimo") unless livro.disponivel?
  end

  def calcular_devolucao_prevista
    self.data_emprestimo ||= Time.current
    self.data_devolucao_prevista ||= 15.business_days.from_now.to_date
  end

  def status_devolucao(data_devolucao)
    data_devolucao > data_devolucao_prevista ? :atrasado : :devolvido
  end
end
