import 'package:flutter/material.dart';
import 'package:flutterestudo/pages/dados_cadastrais.dart';
import 'package:flutter/material.dart';
import 'package:flutterestudo/pages/sobre_page.dart';
import 'package:flutterestudo/pages/termos_de_uso_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutterestudo/pages/dados_cadastrais.dart';
import 'crypto_page.dart';


class CoinsPage extends StatefulWidget {
  const CoinsPage({super.key});

  @override
  State<CoinsPage> createState() => _CoinsPageState();
}

class _CoinsPageState extends State<CoinsPage> {
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
  List<String> priceList = [];
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
            _isLoading = false;
            priceList = _cotacoes!.entries.map((ett) {
              return ett.value.toStringAsFixed(2);
            }).toList();

            // Atualize o estado corretamente
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
  @override
  Widget build(BuildContext context) {
   final int? idUsuario = ModalRoute.of(context)?.settings.arguments as int?;
    return SafeArea(
        child: Scaffold(
            backgroundColor: Color(0xffffffff),
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
                          MaterialPageRoute(
                              builder: (context) => const sobrePage()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.black87),
              backgroundColor: Colors.white,
              surfaceTintColor: Color(0xffffffff),
              title: Text(
                "PAGINA PRINCIPAL",
                style: TextStyle(fontFamily: "Poppins", color: Colors.amber),
              ),
            ),
            body: _isLoading
                ? Center(child: CircularProgressIndicator(color: Colors.amber,))
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
                                  fontSize: 22, fontFamily: "Poppins"),
                            ),
                            SizedBox(height: 16),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 2.3, color: Colors.amber.shade400),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Moeda',
                                            style: TextStyle(
                                              fontFamily: "Poppins",
                                            )),
                                        Text(
                                          'Valor (\$)',
                                          style: TextStyle(
                                            fontFamily: "Poppins",
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    color: Colors.amber.shade400,
                                    thickness: 2.3,
                                  ),
                                  SizedBox(
                                    height: 300,
                                    child: SingleChildScrollView(
                                      physics: BouncingScrollPhysics(),
                                      child: Column(
                                        children: List.generate(
                                            priceList.length, (index) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0, horizontal: 14),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  _moedas[index],
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Text(
                                                  priceList[index],
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
          
            ));
  }
}