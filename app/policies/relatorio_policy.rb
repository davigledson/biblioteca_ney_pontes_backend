class RelatorioPolicy < ApplicationPolicy
  def emprestimos?
    funcionario?
  end

  def multas?
    funcionario?
  end
end