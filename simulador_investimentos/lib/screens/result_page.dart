import 'package:flutter/material.dart';

import '../models/investimento.dart';
import '../utils/formatacao.dart';
import '../widgets/resumo_card.dart';
import 'input_page.dart' show corInvestimento1, corInvestimento2;

/// Tela 2: comparação lado a lado + evolução mês a mês.
class ResultPage extends StatefulWidget {
  final ResultadoSimulacao resultado1;
  final ResultadoSimulacao resultado2;
  final int meses;

  const ResultPage({
    super.key,
    required this.resultado1,
    required this.resultado2,
    required this.meses,
  });

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  // Estado: de quantos em quantos meses a lista é exibida (1 = todos).
  // Ao mudar via setState, a lista é reconstruída na hora.
  int _passo = 1;

  /// Meses a exibir conforme o filtro escolhido (sempre inclui o último mês).
  List<int> get _mesesVisiveis {
    final lista = <int>[];
    for (int m = 1; m <= widget.meses; m++) {
      if (m % _passo == 0 || m == widget.meses) lista.add(m);
    }
    return lista;
  }

  @override
  Widget build(BuildContext context) {
    final r1 = widget.resultado1;
    final r2 = widget.resultado2;
    final dif = (r1.montanteFinal - r2.montanteFinal).abs();
    final empate = dif < 0.005;
    final vence1 = r1.montanteFinal > r2.montanteFinal;

    return Scaffold(
      appBar: AppBar(title: const Text('Comparação de Rendimentos')),
      body: SafeArea(
        child: Column(
          children: [
            // ---- Resumo lado a lado ----
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: ResumoCard(
                          resultado: r1,
                          cor: corInvestimento1,
                          vencedor: !empate && vence1)),
                  const SizedBox(width: 8),
                  Expanded(
                      child: ResumoCard(
                          resultado: r2,
                          cor: corInvestimento2,
                          vencedor: !empate && !vence1)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Text(
                empate
                    ? 'Os dois investimentos terminam com o mesmo montante.'
                    : '${vence1 ? r1.investimento.nome : r2.investimento.nome} '
                        'rende ${formatarReais(dif)} a mais em ${widget.meses} meses.',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),

            // ---- Filtro da lista (usa setState) ----
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SegmentedButton<int>(
                segments: const [
                  ButtonSegment(value: 1, label: Text('Todos')),
                  ButtonSegment(value: 3, label: Text('3 em 3')),
                  ButtonSegment(value: 6, label: Text('6 em 6')),
                  ButtonSegment(value: 12, label: Text('12 em 12')),
                ],
                selected: {_passo},
                onSelectionChanged: (s) => setState(() => _passo = s.first),
              ),
            ),
            const SizedBox(height: 8),

            // ---- Cabeçalho da tabela ----
            Container(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: const Row(
                children: [
                  SizedBox(
                      width: 40,
                      child: Text('Mês',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(
                      child: Text('Invest. 1 (R\$)',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: corInvestimento1))),
                  Expanded(
                      child: Text('Invest. 2 (R\$)',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: corInvestimento2))),
                ],
              ),
            ),

            // ---- Lista com a evolução mensal ----
            Expanded(
              child: ListView.separated(
                itemCount: _mesesVisiveis.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, i) {
                  final mes = _mesesVisiveis[i];
                  // evolucao[0] é o mês 1, por isso mes - 1.
                  final v1 = r1.evolucao[mes - 1];
                  final v2 = r2.evolucao[mes - 1];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    child: Row(
                      children: [
                        SizedBox(width: 40, child: Text('$mes')),
                        Expanded(
                          child: Text(formatarReais(v1),
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontWeight: v1 > v2
                                      ? FontWeight.bold
                                      : FontWeight.normal)),
                        ),
                        Expanded(
                          child: Text(formatarReais(v2),
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontWeight: v2 > v1
                                      ? FontWeight.bold
                                      : FontWeight.normal)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: OutlinedButton.icon(
          onPressed: () => Navigator.pop(context), // volta para a entrada
          icon: const Icon(Icons.arrow_back),
          label: const Text('Nova simulação'),
        ),
      ),
    );
  }
}
