import 'package:flutter/material.dart';
import 'package:flutterestudo/pages/main_page.dart';
import 'package:flutterestudo/pages/sign_up_page.dart';
import 'package:flutterestudo/pages/password_recover_page.dart';
import 'package:flutterestudo/repositories/sqlite/usuario_repository_sqlite.dart';
import 'dart:async';

class LoginPAge extends StatefulWidget {
  const LoginPAge({super.key});

  @override
  State<LoginPAge> createState() => _LoginPAgeState();
}

class _LoginPAgeState extends State<LoginPAge> {
  UsuarioRepositorySqlite usuarioRepository = UsuarioRepositorySqlite();
  int idlogado = 0;
  var resultadoLogin;
  var emailController = TextEditingController(text: "");
  var senhaController = TextEditingController(text: "");

  String senha = "";
  bool isObscureText = true;

//Função que executa o select para verificar se os dados digitados para login estão no banco
  void select() async {
    var tentativaLogin = await usuarioRepository.selectsimples(
        emailController.text, senhaController.text);
    resultadoLogin = tentativaLogin;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints:
                BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Espaçamento de 50px
                SizedBox(
                  height: 50,
                ),
                Row(
                  children: [
                    // Imagem da tela de login
                    Expanded(child: Container()),
                    Expanded(
                      flex: 6,
                      child: Image.network(
                          "https://i.postimg.cc/brqSMD5s/Untitled-logo-1-free-file.jpg"),
                    ),
                    Expanded(child: Container()),
                  ],
                ),
                // Espaçamento de 20px
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Possui Cadastro?",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w700),
                ),
                Text("Faça seu Login.",
                    style: TextStyle(color: Colors.white, fontSize: 16)),
                SizedBox(
                  height: 40,
                ),
                // LOGIN EMAIL ###################################################
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  height: 30,
                  alignment: Alignment.center,
                  child: TextField(
                    controller: emailController,
                    onChanged: (value) {
                      emailController.text = value;
                    },
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        hintText: "Email",
                        hintStyle: TextStyle(color: Colors.white),
                        prefixIcon: Icon(
                          Icons.person,
                          color: Colors.blue,
                        )),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                // LOGIN SENHA ##################################################
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  height: 30,
                  alignment: Alignment.center,
                  child: TextField(
                    obscureText: isObscureText,
                    controller: senhaController,
                    onChanged: (value) {
                      senhaController.text = value;
                    },
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        hintText: "Senha",
                        hintStyle: TextStyle(color: Colors.white),
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Colors.blue,
                        ),
                        suffixIcon: InkWell(
                          onTap: () {
                            // SET STATE para alterar a imagem do icone de obscurecer a senha
                            setState(() {
                              isObscureText = !isObscureText;
                            });
                          },
                          child: Icon(
                            isObscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.white,
                          ),
                        )),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                // BOTÃO ########################################################
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: double.infinity,
                    child: TextButton(
                        onPressed: () {
                          select();
                          Timer(Duration(milliseconds: 500), () {
                            print(resultadoLogin);
                            if (resultadoLogin[0] == 'Senha correta') {
                              idlogado = resultadoLogin[1];
                              print(idlogado);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MainPage(),
                                      settings:
                                          RouteSettings(arguments: idlogado)));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(resultadoLogin[0])),
                              );
                            }
                          });
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(Colors.blue)),
                        child: Text(
                          "ENTRAR",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w500),
                        )),
                  ),
                ),
                Expanded(child: Container()),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  height: 30,
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PasswordRecoverPage()));
                    },
                    child: Text(
                      "Esqueci minha senha",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  height: 30,
                  alignment: Alignment.center,
                  child: Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpPage()));
                      },
                      child: Text(
                        "Criar Conta",
                        style: TextStyle(
                            color: Colors.green, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
