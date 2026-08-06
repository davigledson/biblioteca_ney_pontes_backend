class User < ApplicationRecord
  devise :database_authenticatable, :recoverable,
         :validatable, :jwt_authenticatable,
         jwt_revocation_strategy: self

  validates :nome, presence: true

  before_validation :set_jti, on: :create

  def regenerate_jti
    update(jti: SecureRandom.uuid)
  end

  def jwt_payload
    { "jti" => jti, "nome" => nome }
  end

  private

  def set_jti
    self.jti ||= SecureRandom.uuid
  end
end
