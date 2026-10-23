/// Formata um valor como moeda brasileira, ex.: 1234.5 -> "R$ 1.234,50".
/// (Implementado à mão para não precisar de pacotes externos.)
String formatarReais(double valor) {
  final negativo = valor < 0;
  final partes = valor.abs().toStringAsFixed(2).split('.');
  final inteiro = partes[0].replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => '.',
  );
  return '${negativo ? '-' : ''}R\$ $inteiro,${partes[1]}';
}

/// Converte texto digitado ("1.500,50" ou "1500.50") em número.
/// Retorna null se não for um número válido.
double? lerNumero(String? texto) {
  if (texto == null) return null;
  var t = texto.trim().replaceAll(' ', '');
  if (t.isEmpty) return null;
  // Se tem vírgula, o ponto é separador de milhar: "1.500,50" -> "1500.50"
  if (t.contains(',')) t = t.replaceAll('.', '').replaceAll(',', '.');
  return double.tryParse(t);
}
