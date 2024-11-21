import 'package:flutter/material.dart';
import 'package:flutterestudo/pages/coins_page.dart';
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

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  List<Widget> pages = [CoinsPage(), CryptoPage()];

  int selectedIndex = 0;
  late TabController tabController;
  final List<IconData> icons = [
    Icons.attach_money_sharp,
    Icons.currency_bitcoin,
  ];
  Widget biuldIcon(IconData icon, bool isSelct) {
    return Icon(
      icon,
      size: 30,
      color: isSelct ? Colors.amber : Colors.black,
    );
  }

  List<NavigationDestination> pagesMenu() {
    return List.generate(
      pages.length,
      (index) => NavigationDestination(
          icon: biuldIcon(icons[index], selectedIndex == index),
          label: selectedIndex == 0 ? 'Coins' : 'Crypto'),
    );
  }

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: pages.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffffffff),
        body: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: tabController,
            children: pages),
        bottomNavigationBar: NavigationBar(
            onDestinationSelected: (value) {
              setState(() {
                selectedIndex = value;
                tabController.index = value;
              });
            },
            selectedIndex: selectedIndex,
            height: 65,
            indicatorColor: const Color(0xffffffff),
            backgroundColor: const Color(0xffffffff),
            destinations: pagesMenu()));
  }
}
