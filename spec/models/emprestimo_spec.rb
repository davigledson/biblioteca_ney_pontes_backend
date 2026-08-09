require 'rails_helper'

RSpec.describe Emprestimo, type: :model do
  include AuthHelpers

  let(:categoria) { Categoria.create!(nome: "Ficcao") }
  let(:usuario_biblioteca) { create_cidadao.usuario_biblioteca }

  def criar_livro(titulo = "Livro Teste")
    Livro.create!(titulo: titulo, autor: "Autor Teste", categoria: categoria)
  end

  def criar_emprestimo(livro, data_prevista: nil)
    Emprestimo.create!(
      livro: livro,
      usuario_biblioteca: usuario_biblioteca,
      data_devolucao_prevista: data_prevista
    )
  end

  describe "criacao" do
    it "define prazo de devolucao de 15 dias uteis" do
      emprestimo = criar_emprestimo(criar_livro)

      expect(emprestimo.status).to eq("ativo")
      expect(emprestimo.data_emprestimo).not_to be_nil
      expect(emprestimo.data_devolucao_prevista).not_to be_nil
      expect(emprestimo.dias_atraso).to be_nil
      expect(emprestimo.em_atraso?).to be false
    end
  end

  describe ".atrasados" do
    it "inclui emprestimos devolvidos com atraso" do
      emprestimo = criar_emprestimo(criar_livro)
      emprestimo.devolver!(emprestimo.data_devolucao_prevista + 5)

      expect(emprestimo.status).to eq("atrasado")
      expect(Emprestimo.atrasados).to include(emprestimo)
    end

    it "inclui emprestimos ativos com previsao vencida" do
      vencido = criar_emprestimo(criar_livro, data_prevista: 5.days.ago.to_date)

      expect(vencido.status).to eq("ativo")
      expect(Emprestimo.atrasados).to include(vencido)
    end

    it "exclui emprestimos ativos em dia e devolvidos no prazo" do
      em_dia = criar_emprestimo(criar_livro)
      devolvido = criar_emprestimo(criar_livro("Outro Livro"))
      devolvido.devolver!(devolvido.data_devolucao_prevista)

      expect(Emprestimo.atrasados).not_to include(em_dia, devolvido)
    end
  end

  describe "#dias_atraso" do
    it "retorna a quantidade de dias de atraso de emprestimo ativo vencido" do
      vencido = criar_emprestimo(criar_livro, data_prevista: 5.days.ago.to_date)

      expect(vencido.em_atraso?).to be true
      expect(vencido.dias_atraso).to eq(5)
    end

    it "retorna nil para emprestimo ativo em dia" do
      em_dia = criar_emprestimo(criar_livro)

      expect(em_dia.dias_atraso).to be_nil
    end
  end
end