import 'package:flutter/material.dart';
import 'package:flutterestudo/model/usuario_model_sqlite.dart';
import 'package:flutterestudo/repositories/sqlite/usuario_repository_sqlite.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  UsuarioRepositorySqlite usuarioRepository = UsuarioRepositorySqlite();
  var emailController = TextEditingController(text: "");
  var senhaController = TextEditingController(text: "");
  var nomeController = TextEditingController(text: "");
  var cadastroConfirmSenha = TextEditingController(text: "");
  bool isObscureTextSenha = true;
  bool isObscureTextSenhaConfirm = true;
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
                  height: 50,
                ),
                Text(
                  "Cadastre-se",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 70,
                ),
                // CADASTRO USUARIO ###################################################
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  height: 30,
                  alignment: Alignment.center,
                  child: TextField(
                    controller: nomeController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        hintText: "Nome de Usuário",
                        hintStyle: TextStyle(color: Colors.white),
                        prefixIcon: Icon(
                          Icons.person,
                          color: Colors.blue,
                        )),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                // CADASTRO EMAIL #############################################
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  height: 30,
                  alignment: Alignment.center,
                  child: TextField(
                    controller: emailController,
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
                  height: 30,
                ),
                // CADASTRO SENHA ##################################################
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  height: 30,
                  alignment: Alignment.center,
                  child: TextField(
                    obscureText: isObscureTextSenha,
                    controller: senhaController,
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
                            setState(() {
                              isObscureTextSenha = !isObscureTextSenha;
                            });
                          },
                          child: Icon(
                            isObscureTextSenha
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.white,
                          ),
                        )),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                // CADASTRO CONFIRMA SENHA ####################################
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  height: 30,
                  alignment: Alignment.center,
                  child: TextField(
                    controller: cadastroConfirmSenha,
                    obscureText: isObscureTextSenhaConfirm,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        hintText: "Confirmação de senha",
                        hintStyle: TextStyle(color: Colors.white),
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Colors.blue,
                        ),
                        suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              isObscureTextSenhaConfirm =
                                  !isObscureTextSenhaConfirm;
                            });
                          },
                          child: Icon(
                            isObscureTextSenhaConfirm
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.white,
                          ),
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
                          if (nomeController.text.trim().length < 3) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.red,
                              content: Text('Nome muito pequeno!'),
                            ));
                            return;
                          }
                          if (('@'
                                      .allMatches(emailController.text.trim())
                                      .length ==
                                  0) &&
                              emailController.text.trim().length < 3) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.red,
                              content: Text('Email inválido!'),
                            ));
                            return;
                          }
                          if (senhaController.text.trim().length < 8) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(
                                  'Senha deve ter entre 8 e 16 caracteres!'),
                            ));
                            return;
                          }
                          if (senhaController.text.trim() !=
                              cadastroConfirmSenha.text.trim()) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.red,
                              content: Text('As senhas estão divergentes!'),
                            ));
                            return;
                          }
                          print('paasou');
                          try {
                            await usuarioRepository.salvar(UsuarioModelSqlite(
                                nomeController.text,
                                emailController.text,
                                senhaController.text));
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.green,
                              content: Text('Cadastro realizado'),
                            ));
                          } catch (e) {
                            print(e);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(
                                  'Usuário ou Email já foram cadastrados!'),
                            ));
                          }
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(Colors.blue)),
                        child: Text(
                          "CADASTRAR",
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
