import 'package:flutter/material.dart';

import '../models/investimento.dart';
import '../utils/formatacao.dart';
import '../widgets/investimento_form_card.dart';
import 'result_page.dart';

/// Tela 1: formulário com os dados dos dois investimentos.
class InputPage extends StatefulWidget {
  const InputPage({super.key});

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  // Chave que identifica o Form e permite chamar validate().
  final _formKey = GlobalKey<FormState>();

  // Um controller para cada campo, para podermos ler (e limpar) o texto.
  final _capital1 = TextEditingController();
  final _aporte1 = TextEditingController();
  final _taxa1 = TextEditingController();
  final _capital2 = TextEditingController();
  final _aporte2 = TextEditingController();
  final _taxa2 = TextEditingController();
  final _meses = TextEditingController();

  // Estado da tela: mensagem de erro geral (atualizada via setState).
  String? _erro;

  @override
  void dispose() {
    for (final c in [
      _capital1, _aporte1, _taxa1, _capital2, _aporte2, _taxa2, _meses
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  /// Valida o formulário, monta os dois investimentos e abre a tela de resultados.
  void _comparar() {
    if (!_formKey.currentState!.validate()) {
      setState(() => _erro = 'Corrija os campos destacados.');
      return;
    }
    setState(() => _erro = null);

    final meses = int.parse(_meses.text.trim());

    final inv1 = Investimento(
      nome: 'Investimento 1',
      capitalInicial: lerNumero(_capital1.text)!,
      aporteMensal: lerNumero(_aporte1.text)!,
      taxaMensal: lerNumero(_taxa1.text)!,
    );
    final inv2 = Investimento(
      nome: 'Investimento 2',
      capitalInicial: lerNumero(_capital2.text)!,
      aporteMensal: lerNumero(_aporte2.text)!,
      taxaMensal: lerNumero(_taxa2.text)!,
    );

    // Navegação: empilha a tela de resultados enviando os dados por construtor.
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultPage(
          resultado1: simular(inv1, meses),
          resultado2: simular(inv2, meses),
          meses: meses,
        ),
      ),
    );
  }

  /// Limpa todos os campos.
  void _limpar() {
    _formKey.currentState!.reset();
    for (final c in [
      _capital1, _aporte1, _taxa1, _capital2, _aporte2, _taxa2, _meses
    ]) {
      c.clear();
    }
    setState(() => _erro = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Simulador de Investimentos')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Período compartilhado entre os dois investimentos.
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextFormField(
                      controller: _meses,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Período (compartilhado)',
                        suffixText: 'meses',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) {
                        final n = int.tryParse((v ?? '').trim());
                        if (n == null) return 'Informe um número inteiro';
                        if (n < 1 || n > 600) return 'Use entre 1 e 600 meses';
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                InvestimentoFormCard(
                  titulo: 'Investimento 1',
                  cor: corInvestimento1,
                  capitalCtrl: _capital1,
                  aporteCtrl: _aporte1,
                  taxaCtrl: _taxa1,
                ),
                const SizedBox(height: 8),
                InvestimentoFormCard(
                  titulo: 'Investimento 2',
                  cor: corInvestimento2,
                  capitalCtrl: _capital2,
                  aporteCtrl: _aporte2,
                  taxaCtrl: _taxa2,
                ),
                if (_erro != null) ...[
                  const SizedBox(height: 12),
                  Text(_erro!,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.error)),
                ],
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: _comparar,
                  icon: const Icon(Icons.compare_arrows),
                  label: const Text('Comparar investimentos'),
                ),
                TextButton(onPressed: _limpar, child: const Text('Limpar')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Cores fixas para identificar cada investimento em todas as telas.
const corInvestimento1 = Color(0xFF00796B); // verde-azulado
const corInvestimento2 = Color(0xFFE65100); // laranja
