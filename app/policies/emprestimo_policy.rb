class EmprestimoPolicy < ApplicationPolicy
  def index?
    funcionario?
  end

  def show?
    funcionario? || user&.usuario_biblioteca == record.usuario_biblioteca
  end

  def create?
    funcionario?
  end

  def devolver?
    funcionario?
  end

  def pagar_multa?
    funcionario?
  end

  def renovar?
    funcionario? || user&.usuario_biblioteca == record.usuario_biblioteca
  end

  def atrasados?
    funcionario?
  end

  def historico?
    funcionario?
  end

  class Scope < Scope
    def resolve
      if user.funcionario?
        scope.all
      else
        scope.where(usuario_biblioteca_id: user.usuario_biblioteca&.id)
      end
    end
  end
end