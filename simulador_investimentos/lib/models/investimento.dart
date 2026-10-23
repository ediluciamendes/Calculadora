/// Dados de entrada de UM investimento.
class Investimento {
  final String nome;
  final double capitalInicial; // R$ investido no mês 0
  final double aporteMensal; // R$ depositado ao final de cada mês
  final double taxaMensal; // taxa em % ao mês (ex.: 1.5 = 1,5% a.m.)

  const Investimento({
    required this.nome,
    required this.capitalInicial,
    required this.aporteMensal,
    required this.taxaMensal,
  });
}

/// Resultado da simulação de um investimento.
class ResultadoSimulacao {
  final Investimento investimento;

  /// Saldo ao final de cada mês. Índice 0 = mês 1, índice 1 = mês 2, ...
  final List<double> evolucao;

  /// Total efetivamente colocado do bolso (capital + aportes).
  final double totalInvestido;

  const ResultadoSimulacao({
    required this.investimento,
    required this.evolucao,
    required this.totalInvestido,
  });

  /// Montante final = saldo do último mês.
  double get montanteFinal => evolucao.last;

  /// Rendimento (juros) acumulado = montante - o que foi investido.
  double get rendimentoTotal => montanteFinal - totalInvestido;
}

/// Calcula juros compostos mês a mês.
///
/// Regra usada em cada mês:  saldo = saldo * (1 + taxa/100) + aporteMensal
/// (os juros incidem sobre o saldo do mês anterior e o aporte entra ao
/// final do mês, sem render naquele mês).
ResultadoSimulacao simular(Investimento inv, int meses) {
  final evolucao = <double>[];
  double saldo = inv.capitalInicial;

  for (int mes = 1; mes <= meses; mes++) {
    saldo = saldo * (1 + inv.taxaMensal / 100) + inv.aporteMensal;
    evolucao.add(saldo);
  }

  return ResultadoSimulacao(
    investimento: inv,
    evolucao: evolucao,
    totalInvestido: inv.capitalInicial + inv.aporteMensal * meses,
  );
}
