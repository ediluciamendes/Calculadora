# Calculadora: Comparação de Rendimentos

Aplicativo Flutter que compara **dois investimentos** com juros compostos, mostrando o montante final, o rendimento total e a evolução mês a mês, lado a lado.

# Funcionalidades

### Tela inicial (entrada de dados)
- Período em meses, **compartilhado** entre os dois investimentos.
- Para **cada** investimento:
  - Capital inicial (R$)
  - Aplicação mensal (R$)
  - Taxa de juros mensal (% a.m.)
- Validação dos campos (vazio, texto inválido, valores negativos, período entre 1 e 600 meses).
- Aceita vírgula ou ponto como separador decimal (`1,5` ou `1.5`).
- Botão **Limpar** para zerar o formulário.

### Tela de resultados (comparação)
- Dois cartões lado a lado com **montante final**, **rendimento total** e **total investido**.
- Destaque (troféu e borda) para o investimento com maior montante, e uma frase com a diferença entre eles.
- Lista comparativa **mês a mês** dos dois investimentos (o maior valor de cada mês aparece em negrito).
- Filtro de visualização **Todos / 3 em 3 / 6 em 6 / 12 em 12**, atualizado na hora com `setState`.
- Botão **Nova simulação** para voltar à tela de entrada.

## Como o cálculo funciona

A cada mês:

```
saldo = saldo × (1 + taxa / 100) + aplicação_mensal
```

- Os juros incidem sobre o saldo do mês anterior; o aporte entra no **final** do mês.
- **Montante final** = saldo do último mês.
- **Total investido** = capital inicial + aplicação mensal × meses.
- **Rendimento total** = montante final − total investido.

**Exemplo:** capital R$ 1.000, sem aporte, 10% a.m.

| Mês | Saldo |
|----:|------:|
| 1 | R$ 1.100,00 |
| 2 | R$ 1.210,00 |

##  Estrutura do projeto

```
lib/
├── main.dart                          # MaterialApp e tema
├── models/
│   └── investimento.dart              # modelos + função simular() (juros compostos)
├── utils/
│   └── formatacao.dart                # formatarReais() e lerNumero()
├── screens/
│   ├── input_page.dart                # Tela 1: formulário
│   └── result_page.dart               # Tela 2: comparação e lista mensal
└── widgets/
    ├── investimento_form_card.dart    # campos de um investimento (usado 2x)
    └── resumo_card.dart               # cartão-resumo de resultado
test/
└── calculo_test.dart                  # testes dos cálculos e da formatação
```
