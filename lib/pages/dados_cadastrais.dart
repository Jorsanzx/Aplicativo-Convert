import 'package:flutter/material.dart';
import 'package:flutterestudo/model/usuario_model_sqlite.dart';
import 'package:flutterestudo/repositories/sqlite/usuario_repository_sqlite.dart';

class DadosCadastroPage extends StatefulWidget {
  const DadosCadastroPage({super.key});

  @override
  State<DadosCadastroPage> createState() => _DadosCadastroPageState();
}

class _DadosCadastroPageState extends State<DadosCadastroPage> {
  UsuarioRepositorySqlite usuarioRepository = UsuarioRepositorySqlite();
  var textFieldSomenteLeitura = true;
  bool isObscureTextSenha = true;
  var _dados = const <UsuarioModelSqlite>[];
  var nomeController = TextEditingController(text: "");
  var emailController = TextEditingController(text: "");
  var senhaController = TextEditingController(text: "");

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final int? idUsuario = ModalRoute.of(context)?.settings.arguments as int?;
      if (idUsuario != null) {
        obterDados(idUsuario);
      } else {
        // Trate o caso em que `idUsuario` não foi passado
        print('ID do usuário não encontrado');
      }
    });
  }

  void obterDados(int idUsuario) async {
    _dados = await usuarioRepository.obterDados(idUsuario);
    if (_dados.isNotEmpty) {
      nomeController.text = _dados[0].nome;
      emailController.text = _dados[0].email;
      senhaController.text = _dados[0].senha;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Dados Cadastrais",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Nome de usuário",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            TextField(
              controller: nomeController,
              readOnly: textFieldSomenteLeitura,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Email",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            TextField(
              controller: emailController,
              readOnly: textFieldSomenteLeitura,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Senha",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            TextField(
              controller: senhaController,
              readOnly: textFieldSomenteLeitura,
              obscureText: isObscureTextSenha,
            ),
            Row(
              children: [
                TextButton(
                    onPressed: () {
                      textFieldSomenteLeitura = !textFieldSomenteLeitura;
                      isObscureTextSenha = !isObscureTextSenha;
                      setState(() {});
                    },
                    child: Text("Editar")),
                TextButton(
                  onPressed: () async {
                    if (nomeController.text.trim().length < 3) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.red,
                        content: Text('Nome muito pequeno!'),
                      ));
                      return;
                    }
                    if (('@'.allMatches(emailController.text.trim()).length ==
                            0) &&
                        emailController.text.trim().length < 3) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.red,
                        content: Text('Email inválido!'),
                      ));
                      return;
                    }

                    // Capturar o `idUsuario` dos argumentos da rota
                    final int? idUsuario =
                        ModalRoute.of(context)?.settings.arguments as int?;
                    if (idUsuario == null) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.red,
                        content: Text('Erro: ID do usuário não encontrado!'),
                      ));
                      return;
                    }

                    // Criar um objeto do modelo com os dados atualizados
                    UsuarioModelSqlite usuarioAtualizado = UsuarioModelSqlite(
                      nomeController.text.trim(),
                      emailController.text.trim(),
                      senhaController.text.trim(),
                      id: idUsuario, // Passa o ID do usuário
                    );

                    // Atualizar os dados no banco de dados
                    try {
                      await usuarioRepository.alterar(usuarioAtualizado);

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.green,
                        content: Text('Dados atualizados com sucesso!'),
                      ));

                      // Desabilitar edição após salvar
                      setState(() {
                        textFieldSomenteLeitura = true;
                        isObscureTextSenha = true;
                      });
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.red,
                        content: Text('Usuário ou email já existem!'),
                      ));
                    }
                  },
                  child: Text("Salvar"),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
