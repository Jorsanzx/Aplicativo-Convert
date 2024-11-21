import 'package:flutterestudo/model/usuario_model_sqlite.dart';
import 'package:flutterestudo/repositories/sqlite/sqlitedatabase.dart';

class UsuarioRepositorySqlite {
  // Select usado para exibir os dados na página dados_cadastrais
  Future<List<UsuarioModelSqlite>> obterDados(int idUsuario) async {
    List<UsuarioModelSqlite> dados = [];
    //print(id);
    var db = await SqliteDatabase().obterDataBase();
    var result = await db.rawQuery(
        'SELECT id, nome, email, senha FROM usuarios WHERE id = ?',
        [idUsuario]);
    for (var element in result) {
      dados.add(UsuarioModelSqlite.fromMap(element));
    }

    print(result);
    return dados;
  }

  // Insert para cadastrar usuário, usado na página de cadastro sing_up_page
  Future<void> salvar(UsuarioModelSqlite usuarioModelSqlite) async {
    var db = await SqliteDatabase().obterDataBase();
    await db.rawInsert(
        'INSERT INTO usuarios (nome, email, senha) values (?,?,?)', [
      usuarioModelSqlite.nome,
      usuarioModelSqlite.email,
      usuarioModelSqlite.senha
    ]);
    print("salvo");
  }

  // Update dos dados do usário, usado na página de dados cadastrais
  Future<void> alterar(UsuarioModelSqlite usuarioModelSqlite) async {
    var db = await SqliteDatabase().obterDataBase();
    await db.rawInsert(
        'UPDATE usuarios SET nome = ?, email = ?, senha = ? WHERE id = ?', [
      usuarioModelSqlite.nome,
      usuarioModelSqlite.email,
      usuarioModelSqlite.senha,
      usuarioModelSqlite.id
    ]);
    print('Dados Aualizados');
  }

  // Delete para remover os dados da tabela, não é usado em nenhum lugar do programa,
  // só coloquei por que achei que ia precisar apagar os usuários
  Future<void> remover(UsuarioModelSqlite usuarioModelSqlite) async {
    var db = await SqliteDatabase().obterDataBase();
    await db
        .rawInsert('DELETE FROM tarefas WHERE id = ?', [usuarioModelSqlite.id]);
  }

  //Select usado na validação de dados no login, verifica se o email existe no banco
  // e se a senha digitada bate com o email informado
  Future<List?> selectsimples(String email, String senha) async {
    var db = await SqliteDatabase().obterDataBase();
    try {
      var result = await db.rawQuery(
          'SELECT id, nome, email, senha FROM usuarios WHERE email = ?',
          [email]);

      if (result[0]['senha'] == senha) {
        return ['Senha correta', result[0]['id']];
      } else {
        return ['Senha incorreta'];
      }
    } catch (e) {
      return ['Email inválido'];
    }
  }

  //Só verifica se o email existe, retorna uma lista [] com um Map {} dos dados do usuário
  //é usado na pagina password_recover_page, seria usado tambem para enviar a senha pro email.
  Future verificaEmail(String email) async {
    var db = await SqliteDatabase().obterDataBase();
    var consulta = await db.rawQuery(
        'SELECT id, nome, email, senha FROM usuarios WHERE email = ?', [email]);
    return consulta;
  }
}
