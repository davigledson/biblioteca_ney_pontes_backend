class EmprestimoPolicy < ApplicationPolicy
  def index?
    bibliotecario?
  end

  def show?
    bibliotecario? || user&.usuario_biblioteca == record.usuario_biblioteca
  end

  def create?
    bibliotecario?
  end

  def devolver?
    bibliotecario?
  end

  def renovar?
    user&.usuario_biblioteca == record.usuario_biblioteca
  end

  def atrasados?
    bibliotecario?
  end

  def historico?
    bibliotecario?
  end

  class Scope < Scope
    def resolve
      if user.bibliotecario?
        scope.all
      else
        scope.where(usuario_biblioteca_id: user.usuario_biblioteca&.id)
      end
    end
  end
end
