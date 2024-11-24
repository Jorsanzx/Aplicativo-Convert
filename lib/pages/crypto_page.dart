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
  List<String> priceList = [];
  List<String> cryptoList = [];

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
          priceList = _cryptoPrices!.entries.map((ett) {
            return ett.value.toStringAsFixed(2);
          }).toList();
          cryptoList = _cryptoPrices!.entries.map((ett) {
            return ett.key.toUpperCase();
          }).toList();
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black87),
        backgroundColor: Colors.white,
        surfaceTintColor: Color(0xffffffff),
        title: Text(
          "CryptoPage",
          style: TextStyle(fontFamily: "Poppins", color: Colors.amber),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: Colors.amber,
            ))
          : _errorMessage != null
              ? Center(child: Text('Erro: $_errorMessage'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Cotação dos principais cryptos",
                        style: TextStyle(fontSize: 22, fontFamily: "Poppins"),
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
                                  Text('Criptomoeda',
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
                                  children:
                                      List.generate(priceList.length, (index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 14),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            cryptoList[index],
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Text(
                                            priceList[index],
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500),
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
    );
  }
}
