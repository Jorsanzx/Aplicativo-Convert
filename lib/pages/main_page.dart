import 'package:flutter/material.dart';
import 'package:flutterestudo/pages/sobre_page.dart';
import 'package:flutterestudo/pages/termos_de_uso_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutterestudo/pages/dados_cadastrais.dart';
import 'crypto_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final String _apiKey = 'a2042de51d24aec0adaebee2';
  final String _baseUrl = 'https://v6.exchangerate-api.com/v6';

  final List<String> _moedas = [
    'USD',
    'EUR',
    'ARS',
    'VES',
    'GBP',
    'JPY',
    'CNY',
    'CFH',
    'CAD',
    'ZAR',
    'AUD'
  ];

  Map<String, double>? _cotacoes;
  bool _isLoading = true;
  String? _errorMessage;

  int _selectedIndex = 0; // Indica qual aba está selecionada

  @override
  void initState() {
    super.initState();
    _fetchCotacoes();
  }

  Future<void> _fetchCotacoes() async {
    try {
      final response =
          await http.get(Uri.parse('$_baseUrl/$_apiKey/latest/BRL'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data != null && data['conversion_rates'] is Map<String, dynamic>) {
          final rates = data['conversion_rates'] as Map<String, dynamic>;

          final Map<String, double> cotacoes = {};
          for (String moeda in _moedas) {
            if (rates.containsKey(moeda)) {
              // Calcula quantos reais equivalem a 1 unidade da moeda
              cotacoes[moeda] = 1 / rates[moeda].toDouble();
            }
          }

          setState(() {
            _cotacoes = cotacoes;
            _isLoading = false; // Atualize o estado corretamente
          });
        } else {
          throw Exception('Dados inválidos recebidos da API.');
        }
      } else {
        throw Exception(
            'Erro ao buscar dados da API. Código: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false; // Garanta que o estado será atualizado
      });
    }
  }

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      // Pegando o `idUsuario` atual da rota
      final int? idUsuario = ModalRoute.of(context)?.settings.arguments as int?;
      if (idUsuario != null) {
        // Navegando para a página correta e passando o `idUsuario`
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => index == 0 ? MainPage() : CryptoPage(),
            settings: RouteSettings(arguments: idUsuario),
          ),
        );
      } else {
        print('Erro: idUsuario não encontrado');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final int? idUsuario = ModalRoute.of(context)?.settings.arguments as int?;
    return SafeArea(
        child: Scaffold(
      drawer: Drawer(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    width: double.infinity,
                    child: Text("Dados cadastrais")),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DadosCadastroPage(),
                          settings: RouteSettings(arguments: idUsuario)));
                },
              ),
              Divider(),
              InkWell(
                child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    width: double.infinity,
                    child: Text("Configurações")),
                onTap: () {},
              ),
              Divider(),
              InkWell(
                child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    width: double.infinity,
                    child: Text("Termos de uso e privacidade")),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TermosDeUsoPage()),
                  );
                },
              ),
              Divider(),
              InkWell(
                child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    width: double.infinity,
                    child: Text("Sobre")),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const sobrePage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: Text(
          "PAGINA PRINCIPAL",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text('Erro: $_errorMessage'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Cotação das principais moedas",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16),
                      Table(
                        border: TableBorder.all(),
                        columnWidths: const {
                          0: FlexColumnWidth(2),
                          1: FlexColumnWidth(3),
                        },
                        children: [
                          TableRow(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Moeda',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Valor (R\$)',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          ..._cotacoes!.entries.map((entry) {
                            return TableRow(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(entry.key),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(entry.value.toStringAsFixed(2)),
                                ),
                              ],
                            );
                          }).toList(),
                        ],
                      ),
                    ],
                  ),
                ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        unselectedItemColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.money),
            label: 'Moeda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.currency_bitcoin),
            label: 'Crypto',
          ),
        ],
      ),
    ));
  }
}
