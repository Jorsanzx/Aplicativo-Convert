class UsuarioModelSqlite {
  int? _id; // Torna o ID opcional para novos registros
  String _nome;
  String _email;
  String _senha;

  // Construtor atualizado com ID opcional
  UsuarioModelSqlite(this._nome, this._email, this._senha, {int? id})
      : _id = id;

  // Getters
  int? get id => _id;
  String get nome => _nome;
  String get email => _email;
  String get senha => _senha;

  // Setters
  set id(int? id) {
    _id = id;
  }

  set nome(String nome) {
    _nome = nome;
  }

  set senha(String senha) {
    _senha = senha;
  }

  set email(String email) {
    _email = email;
  }

  // Método para converter um objeto em Map (útil para operações no banco)
  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'nome': _nome,
      'email': _email,
      'senha': _senha,
    };
  }

  // Construtor para criar o modelo a partir de um Map (resultado do banco de dados)
  UsuarioModelSqlite.fromMap(Map<String, dynamic> map)
      : _id = map['id'] as int?,
        _nome = map['nome'] as String,
        _email = map['email'] as String,
        _senha = map['senha'] as String;
}
