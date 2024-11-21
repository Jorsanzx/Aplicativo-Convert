import 'package:flutter/material.dart';
import 'package:flutterestudo/repositories/sqlite/usuario_repository_sqlite.dart';

class PasswordRecoverPage extends StatefulWidget {
  const PasswordRecoverPage({super.key});

  @override
  State<PasswordRecoverPage> createState() => _PasswordRecoverPageState();
}

class _PasswordRecoverPageState extends State<PasswordRecoverPage> {
  UsuarioRepositorySqlite usuarioRepository = UsuarioRepositorySqlite();
  var recuperaemaillController = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints:
                BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 130,
                ),
                Text(
                  "Recuperar senha",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Informe o email cadastrado",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 70,
                ),
                // RECUPERACAO EMAIL ##################################################
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  height: 30,
                  alignment: Alignment.center,
                  child: TextField(
                    controller: recuperaemaillController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        hintText: "Email",
                        hintStyle: TextStyle(color: Colors.white),
                        prefixIcon: Icon(
                          Icons.mail,
                          color: Colors.blue,
                        )),
                  ),
                ),
                SizedBox(
                  height: 100,
                ),
                // BOTÃO ########################################################
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: double.infinity,
                    child: TextButton(
                        onPressed: () async {
                          var resultado = await usuarioRepository.verificaEmail(
                              recuperaemaillController.text.trim());
                          try {
                            print(resultado[0]['email'] +
                                ' ' +
                                resultado[0]['senha']);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.green,
                              content: Text('Email de recuperação enviado'),
                            ));
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.red,
                              content: Text('Email não cadastrado!'),
                            ));
                          }
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(Colors.blue)),
                        child: Text(
                          "RECUPERAR",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w500),
                        )),
                  ),
                ),
                Expanded(child: Container()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
