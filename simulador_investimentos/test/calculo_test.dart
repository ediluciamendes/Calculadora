import 'package:flutter_test/flutter_test.dart';
import 'package:simulador_investimentos/models/investimento.dart';
import 'package:simulador_investimentos/utils/formatacao.dart';

void main() {
  test('juros compostos sem aporte (exemplo do enunciado)', () {
    const inv = Investimento(
        nome: 'A', capitalInicial: 1000, aporteMensal: 0, taxaMensal: 10);
    final r = simular(inv, 2);
    expect(r.evolucao[0], closeTo(1100, 1e-9));
    expect(r.evolucao[1], closeTo(1210, 1e-9));
    expect(r.rendimentoTotal, closeTo(210, 1e-9));
  });

  test('com aporte mensal', () {
    const inv = Investimento(
        nome: 'B', capitalInicial: 1000, aporteMensal: 100, taxaMensal: 1);
    final r = simular(inv, 2);
    expect(r.evolucao[0], closeTo(1110, 1e-9)); // 1000*1.01 + 100
    expect(r.evolucao[1], closeTo(1221.1, 1e-9)); // 1110*1.01 + 100
    expect(r.totalInvestido, 1200);
  });

  test('formatação', () {
    expect(formatarReais(1234.5), 'R\$ 1.234,50');
    expect(lerNumero('1.500,50'), 1500.5);
    expect(lerNumero('2,5'), 2.5);
    expect(lerNumero('abc'), isNull);
  });
}
