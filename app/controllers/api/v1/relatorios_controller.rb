module Api
  module V1
    class RelatoriosController < BaseController
      LIMITE_LINHAS = 5000
      LIMITE_PREVIEW = 50

      def emprestimos
        authorize :relatorio, :emprestimos?
        return unless validar_periodo!

        relacionamento = Emprestimo
          .joins(:livro, :usuario_biblioteca)
          .includes(:usuario_biblioteca, :multa, livro: :categoria)
          .order(data_emprestimo: :desc)

        relacionamento = relacionamento.where(data_emprestimo: periodo) if periodo
        if params[:status].present? && Emprestimo.statuses.key?(params[:status])
          relacionamento = relacionamento.where(status: params[:status])
        end
        relacionamento = relacionamento.where(termo_emprestimos) if termo.present?

        linhas = linhas_emprestimos(relacionamento.limit(LIMITE_LINHAS))

        if params[:preview] == "1"
          render json: {
            linhas: linhas.first(LIMITE_PREVIEW),
            totais: totais_emprestimos(relacionamento)
          }
else
          render_xlsx("relatorio-emprestimos", linhas)
        end
      end

      def multas
        authorize :relatorio, :multas?
        return unless validar_periodo!

        relacionamento = Multa
          .joins(emprestimo: [:livro, :usuario_biblioteca])
          .order("emprestimos.data_devolucao_real DESC NULLS LAST")

        if periodo
          relacionamento = relacionamento.where("emprestimos.data_devolucao_real BETWEEN ? AND ?", periodo.first.beginning_of_day, periodo.last.end_of_day)
        end
        if params[:pago].present?
          relacionamento = relacionamento.where(pago: params[:pago] == "true")
        end
        relacionamento = relacionamento.where(termo_multas) if termo.present?

        linhas = linhas_multas(relacionamento.limit(400))

        if params[:preview] == "1"
          render json: {
            linhas: linhas.first(LIMITE_PREVIEW),
            totais: totais_multas(relacionamento)
          }
        else
          render_xlsx("relatorio-multas", linhas)
        end
      end

      private

      def render_xlsx(nome, linhas)
        pacote = Axlsx::Package.new
        pacote.workbook do |workbook|
          estilo_cabecalho = workbook.styles.add_style(b: true, bg_color: "DDEBF7")
          workbook.add_worksheet(name: nome.split("-").last.capitalize) do |planilha|
            cabecalho = linhas.empty? ? [] : linhas.first.keys
            planilha.add_row(cabecalho.map(&:to_s), style: estilo_cabecalho)
            linhas.each do |linha|
              planilha.add_row(linha.values.map { |v| celula_xlsx(v) })
            end
          end
        end

        send_data pacote.to_stream.read,
                  filename: "#{nome}-#{Date.current.strftime('%Y%m%d')}.xlsx",
                  type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
      end

      def celula_xlsx(valor)
        return valor unless valor.is_a?(String) && valor.match?(/\A\d{1,10},\d{2}\z/)

        valor.gsub(",", ".").to_f
      end

      def linhas_emprestimos(relacionamento)
        relacionamento.map do |e|
          {
            "ID" => e.id,
            "Livro" => e.livro.titulo,
            "Autor" => e.livro.autor,
            "Categoria" => e.livro.categoria.nome,
            "Cidadao" => e.usuario_biblioteca.nome_completo,
            "CPF" => e.usuario_biblioteca.cpf,
            "Status" => rotulo_status(e.status),
            "Data emprestimo" => formatar_data(e.data_emprestimo),
            "Devolucao prevista" => formatar_data(e.data_devolucao_prevista),
            "Devolucao real" => formatar_data(e.data_devolucao_real),
            "Dias de atraso" => e.dias_atraso,
            "Renovacoes" => e.renovacoes,
            "Multa (R$)" => formatar_moeda(e.multa&.valor),
            "Multa paga" => e.multa ? (e.multa.pago ? "Sim" : "Nao") : "-"
          }
        end
      end

      def linhas_multas(relacionamento)
        relacionamento.map do |m|
          {
            "ID" => m.id,
            "Valor (R$)" => formatar_moeda(m.valor),
            "Paga" => m.pago ? "Sim" : "Nao",
            "Data devolucao" => formatar_data(m.emprestimo.data_devolucao_real),
            "Cidadao" => m.emprestimo.usuario_biblioteca.nome_completo,
            "CPF" => m.emprestimo.usuario_biblioteca.cpf,
            "Livro" => m.emprestimo.livro.titulo,
            "Emprestimo ID" => m.emprestimo.id
          }
        end
      end

      def totais_emprestimos(relacionamento)
        base = relacionamento.unscope(:order)
        agrupado = base.group(:status).count
        {
          total: base.count,
          ativos: agrupado["ativo"].to_i,
          devolvidos: agrupado["devolvido"].to_i,
          atrasados: agrupado["atrasado"].to_i,
          multas_pendentes: base
            .joins(:multa)
            .where(multas: { pago: false })
            .count
        }
      end

      def totais_multas(relacionamento)
        {
          total: relacionamento.count,
          pendentes: relacionamento.where(pago: false).count,
          valor_total: relacionamento.sum(:valor).to_f,
          valor_pendente: relacionamento.where(pago: false).sum(:valor).to_f,
          valor_pago: relacionamento.where(pago: true).sum(:valor).to_f
        }
      end

      def termo
        return @termo if defined?(@termo)

        @termo = params[:q].present? ? "%#{params[:q].strip}%" : nil
      end

      def termo_emprestimos
        ["livros.titulo ILIKE :t OR livros.autor ILIKE :t OR usuario_bibliotecas.nome_completo ILIKE :t", { t: termo }]
      end

      def termo_multas
        ["livros.titulo ILIKE :t OR usuario_bibliotecas.nome_completo ILIKE :t", { t: termo }]
      end

      def periodo
        return @periodo if defined?(@periodo)

        if params[:data_inicio].blank? && params[:data_fim].blank?
          @periodo = nil
        else
          inicio = params[:data_inicio].present? ? Date.parse(params[:data_inicio]).beginning_of_day : Date.new(2000, 1, 1)
          fim = params[:data_fim].present? ? Date.parse(params[:data_fim]).end_of_day : Time.current
          @periodo = inicio..fim
        end
      end

      def validar_periodo!
        if params[:data_inicio].present? && params[:data_fim].present?
          return true if Date.parse(params[:data_inicio]) <= Date.parse(params[:data_fim])

          render json: { error: "Data inicial maior que data final" }, status: :unprocessable_entity
          return false
        end
        true
      rescue ArgumentError
        render json: { error: "Data(s) invalida(s). Use o formato YYYY-MM-DD" }, status: :unprocessable_entity
        false
      end

      def rotulo_status(status)
        { "ativo" => "Ativo", "devolvido" => "Devolvido", "atrasado" => "Atrasado" }[status] || status
      end

      def formatar_data(data)
        data&.strftime("%d/%m/%Y") || ""
      end

      def formatar_moeda(valor)
        return "" if valor.nil?

        format("%.2f", valor).gsub(".", ",")
      end
    end
  end
end