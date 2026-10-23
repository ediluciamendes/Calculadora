import 'package:flutter/material.dart';

import '../utils/formatacao.dart';

/// Cartão reutilizável com os campos de UM investimento.
/// É usado duas vezes na tela de entrada (Investimento 1 e 2).
class InvestimentoFormCard extends StatelessWidget {
  final String titulo;
  final Color cor;
  final TextEditingController capitalCtrl;
  final TextEditingController aporteCtrl;
  final TextEditingController taxaCtrl;

  const InvestimentoFormCard({
    super.key,
    required this.titulo,
    required this.cor,
    required this.capitalCtrl,
    required this.aporteCtrl,
    required this.taxaCtrl,
  });

  /// Validador para valores em R$ (não pode ser negativo).
  String? _validarValor(String? v) {
    final n = lerNumero(v);
    if (n == null) return 'Informe um número';
    if (n < 0) return 'Não pode ser negativo';
    return null;
  }

  /// Validador da taxa (precisa ser maior ou igual a zero).
  String? _validarTaxa(String? v) {
    final n = lerNumero(v);
    if (n == null) return 'Informe um número';
    if (n < 0) return 'Não pode ser negativa';
    return null;
  }

  InputDecoration _decoracao(String rotulo, String? prefixo, String? sufixo) =>
      InputDecoration(
        labelText: rotulo,
        prefixText: prefixo,
        suffixText: sufixo,
        border: const OutlineInputBorder(),
      );

  @override
  Widget build(BuildContext context) {
    const teclado = TextInputType.numberWithOptions(decimal: true);
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              CircleAvatar(radius: 6, backgroundColor: cor),
              const SizedBox(width: 8),
              Text(titulo,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
            ]),
            const SizedBox(height: 16),
            TextFormField(
              controller: capitalCtrl,
              keyboardType: teclado,
              decoration: _decoracao('Capital inicial', 'R\$ ', null),
              validator: _validarValor,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: aporteCtrl,
              keyboardType: teclado,
              decoration: _decoracao('Aplicação mensal', 'R\$ ', null),
              validator: _validarValor,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: taxaCtrl,
              keyboardType: teclado,
              decoration: _decoracao('Taxa de juros mensal', null, '% a.m.'),
              validator: _validarTaxa,
            ),
          ],
        ),
      ),
    );
  }
}
