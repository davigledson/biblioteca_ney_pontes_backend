class User < ApplicationRecord
  devise :database_authenticatable, :recoverable,
         :validatable, :jwt_authenticatable,
         jwt_revocation_strategy: self

  enum :role, { bibliotecario: 0, cidadao: 1, admin: 2 }

  def funcionario?
    bibliotecario? || admin?
  end

  validates :nome, presence: true

  before_validation :set_jti, on: :create

  has_one :usuario_biblioteca, dependent: :destroy

  def self.jwt_revoked?(payload, user)
    user.jti != payload["jti"]
  end

  def self.revoke_jwt(payload, user)
    user.update!(jti: SecureRandom.uuid)
  end

  def jwt_payload
    { "jti" => jti, "nome" => nome, "email" => email, "role" => role, "first_login" => first_login }
  end

  private

  def set_jti
    self.jti ||= SecureRandom.uuid
  end
end
