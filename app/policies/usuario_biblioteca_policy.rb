class UsuarioBibliotecaPolicy < ApplicationPolicy
  def index?
    bibliotecario?
  end

  def show?
    bibliotecario? || user&.usuario_biblioteca == record
  end

  def carteirinha?
    show?
  end

  def create?
    bibliotecario?
  end

  def update?
    bibliotecario? || user&.usuario_biblioteca == record
  end

  def destroy?
    bibliotecario?
  end

  class Scope < Scope
    def resolve
      if user.bibliotecario?
        scope.all
      else
        scope.where(id: user.usuario_biblioteca&.id)
      end
    end
  end
end
