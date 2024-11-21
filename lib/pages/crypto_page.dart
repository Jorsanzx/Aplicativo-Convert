import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'main_page.dart';

class CryptoPage extends StatefulWidget {
  const CryptoPage({Key? key}) : super(key: key);

  @override
  State<CryptoPage> createState() => _CryptoPageState();
}

class _CryptoPageState extends State<CryptoPage> {
  int _selectedIndex = 1;
  bool _isLoading = true;
  String? _errorMessage;
  Map<String, double>? _cryptoPrices;

  @override
  void initState() {
    super.initState();
    _fetchCryptoPrices();
  }

  Future<void> _fetchCryptoPrices() async {
    final String url =
        'https://api.coingecko.com/api/v3/simple/price?ids=bitcoin,ethereum,tether,binancecoin,solana,usd-coin,ripple,dogecoin,toncoin,cardano&vs_currencies=brl';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final Map<String, double> prices = {};

        // Mapeando os preços para exibição
        data.forEach((key, value) {
          if (value['brl'] != null) {
            // Convertendo para double de forma segura
            prices[key] = (value['brl'] is int)
                ? (value['brl'] as int).toDouble()
                : value['brl'] as double;
          }
        });

        setState(() {
          _cryptoPrices = prices;
          _isLoading = false;
        });
      } else {
        throw Exception(
            'Erro ao buscar dados da API. Código: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
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
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "CryptoPage",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text('Erro: $_errorMessage'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Cotação dos principais cryptos",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Table(
                        border: TableBorder.all(),
                        columnWidths: const {
                          0: FlexColumnWidth(2),
                          1: FlexColumnWidth(3),
                        },
                        children: [
                          const TableRow(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Criptomoeda',
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
                          ..._cryptoPrices!.entries.map((entry) {
                            return TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(entry.key.toUpperCase()),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
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
        unselectedItemColor: Colors.white,
        backgroundColor: Colors.black,
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
    );
  }
}
