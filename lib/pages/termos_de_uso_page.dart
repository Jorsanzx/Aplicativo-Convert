import 'package:flutter/material.dart';

class TermosDeUsoPage extends StatelessWidget {
  const TermosDeUsoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          "Termos de Uso e Privacidade",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Termos de Uso",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "1. Uso do aplicativo: Você deve usar o aplicativo de forma responsável, respeitando todas as leis aplicáveis.",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 4),
              Text(
                "2. Garantias e Limitações: Apesar de nossos esforços para manter o aplicativo atualizado e funcional, não garantimos a precisão ou disponibilidade contínua das informações.",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 4),
              Text(
                "3. Propriedade intelectual: Todos os conteúdos do aplicativo são de propriedade exclusiva do \$ Convert, exceto onde indicado de outra forma.",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                "Política de Privacidade",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "1. Coleta de informações: O \$ Convert pode coletar informações limitadas, como dados de uso do aplicativo, para melhorar sua experiência.",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 4),
              Text(
                "2. Uso de informações: Seus dados não serão vendidos ou compartilhados com terceiros sem o seu consentimento explícito.",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 4),
              Text(
                "3. Segurança dos dados: Empregamos medidas de segurança para proteger suas informações, mas não garantimos proteção absoluta contra violações.",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 4),
              Text(
                "4. Contato: Para dúvidas, entre em contato conosco pelo e-mail suporte@convertapp.com.",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
