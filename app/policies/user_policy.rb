class UserPolicy < ApplicationPolicy
  def index?
    bibliotecario?
  end

  def show?
    bibliotecario?
  end

  def create?
    bibliotecario?
  end

  def update?
    bibliotecario?
  end

  def destroy?
    bibliotecario?
  end

  def change_password?
    bibliotecario? || user == record
  end
end
