class UsuarioBibliotecaPolicy < ApplicationPolicy
  def index?
    funcionario?
  end

  def show?
    funcionario? || user&.usuario_biblioteca == record
  end

  def carteirinha?
    show?
  end

  def enviar_senha_emprestimo?
    funcionario?
  end

  def create?
    funcionario?
  end

  def update?
    funcionario? || user&.usuario_biblioteca == record
  end

  def destroy?
    funcionario?
  end

  class Scope < Scope
    def resolve
      if user.funcionario?
        scope.all
      else
        scope.where(id: user.usuario_biblioteca&.id)
      end
    end
  end
end