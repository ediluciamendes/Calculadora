import 'package:flutter/material.dart';

import '../models/investimento.dart';
import '../utils/formatacao.dart';

/// Cartão-resumo de um investimento (montante final e rendimento total).
class ResumoCard extends StatelessWidget {
  final ResultadoSimulacao resultado;
  final Color cor;
  final bool vencedor; // true => mostra selo "Melhor"

  const ResumoCard({
    super.key,
    required this.resultado,
    required this.cor,
    required this.vencedor,
  });

  @override
  Widget build(BuildContext context) {
    final texto = Theme.of(context).textTheme;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: cor, width: vencedor ? 2.5 : 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(resultado.investimento.nome,
                      style: texto.titleSmall?.copyWith(
                          color: cor, fontWeight: FontWeight.bold)),
                ),
                if (vencedor) Icon(Icons.emoji_events, size: 18, color: cor),
              ],
            ),
            const SizedBox(height: 8),
            Text('Montante final', style: texto.labelSmall),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(formatarReais(resultado.montanteFinal),
                  style: texto.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 8),
            Text('Rendimento total', style: texto.labelSmall),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(formatarReais(resultado.rendimentoTotal),
                  style: texto.titleSmall),
            ),
            const SizedBox(height: 8),
            Text('Total investido', style: texto.labelSmall),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(formatarReais(resultado.totalInvestido),
                  style: texto.bodyMedium),
            ),
          ],
        ),
      ),
    );
  }
}
