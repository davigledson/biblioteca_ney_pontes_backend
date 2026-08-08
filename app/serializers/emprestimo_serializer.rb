class EmprestimoSerializer
  def self.call(emprestimo)
    {
      id: emprestimo.id,
      status: emprestimo.status,
      data_emprestimo: emprestimo.data_emprestimo,
      data_devolucao_prevista: emprestimo.data_devolucao_prevista,
      data_devolucao_real: emprestimo.data_devolucao_real,
      renovacoes: emprestimo.renovacoes,
      dias_atraso: emprestimo.dias_atraso,
      livro: {
        id: emprestimo.livro.id,
        titulo: emprestimo.livro.titulo,
        autor: emprestimo.livro.autor
      },
      usuario_biblioteca: {
        id: emprestimo.usuario_biblioteca.id,
        nome_completo: emprestimo.usuario_biblioteca.nome_completo,
        cpf: emprestimo.usuario_biblioteca.cpf
      },
      multa: emprestimo.multa ? { id: emprestimo.multa.id, valor: emprestimo.multa.valor.to_f, pago: emprestimo.multa.pago } : nil,
      created_at: emprestimo.created_at
    }
  end
end