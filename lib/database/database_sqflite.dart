import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseSqflite {
  Future<Database> openConnection() async {
    //getDatabasesPath -> é a pasta aonde ele guarda tudo que tem gravado dentro do sqflite
    final databasePath = await getDatabasesPath();

    //!Repare nessa / não sabesmo se o android e ios aceita, com isso utilizamos o package PATH
    // databasePath += '/SQL_EXAMPLE';

    //!Repare agora nós utilizando o package PATH
    final databasefinalPath = join(databasePath, 'SQLITE_EXAMPLE');

    return await openDatabase(
      databasefinalPath,
      //sempre começa no 1, só alteramos a versão quando alteramos algo na database
      //!Repare que o version sempre acompanha o onUpgrade porém uma versão a mais
      //! quando eu insiro um elemento no onUpgrade aqui fica 2, quando eu insiro 2 elementos no onUpgrade aqui fica 3
      version: 2,
      //onConfigure -> é executado toda vez que o banco é aberto
      onConfigure: (db) async {
        print('onConfigure sendo chamado');
        //!bastante utilizado para que digamos para o banco trabalhar com as FOREING KEYS
        await db.execute('PRAGMA foreing_keys = ON');
      },
      //onCreate -> quando o banco de dados não existe o onCreate é chamado para criar (primeira vez que carrega o app)
      onCreate: (Database db, int version) {
        print('onCreated chamado');
        final batch = db.batch();
        batch.execute('''
          create table teste(
            id Integer primary key autoincrement,
            nome varchar(200)
          )
      ''');

        //!Precisamos copiar todas tabelas do onUpdate e jogar aqui no onCreated tambem
        //!se não quem baixar pela primeira vez nao tem acesso as tabelas do onUpgrade
        //   batch.execute('''
        //     create table produto(
        //       id Integer primary key autoincrement,
        //       nome varchar(200)
        //     )
        // ''');
        batch.commit();
      },
      //onUpgrade -> aqui que atualizamos alguma coisa dentro do database para podermos troca o 'Version'
      onUpgrade: (Database db, int oldVersion, int version) {
        print('onUpgrade chamado');

        //!Vamos atualizar a 'version', imagina que precisamos incluir a tabela 'produto'
        //!nós criamos ela aqui no onUpgrade
        //!não esqueça de alterar a 'version'
        final batch = db.batch();

        //se o oldVersion for igual a version 1 eu executo esse script
        if (oldVersion == 1) {
          batch.execute('''
          create table produto(
            id Integer primary key autoincrement,
            nome varchar(200)
          )
      ''');

          //!Precisamos por todos os scripts do onUpgrade independente da version aqui no 'oldVersion ==1'
          //!Porque ? o usuario pode pular atualizações e assim não tera os script de um version == 2 por exemplo
          //     batch.execute('''
          //     create table loja(
          //       id Integer primary key autoincrement,
          //       nome varchar(200)
          //     )
          // ''');
        }
        //   if (oldVersion == 2) {
        //     batch.execute('''
        //     create table loja(
        //       id Integer primary key autoincrement,
        //       nome varchar(200)
        //     )
        // ''');
        //   }
      },
      //onDowngrade -> sera chamado sempre que ouver uma alteração no version para menos (2 -> 1)
      onDowngrade: (Database db, int oldVersion, int version) {
        print('onDowngrade chamado');
        final batch = db.batch();

        //!na version 3 tem a tabela 'loja', então fazendo isso
        //!eu posso ir e apagar ou comentar todo lugar que tive a table loja
        //!dentro desse arquivo
        if (oldVersion == 3) {
          batch.execute('''
          drop table loja
          )
      ''');
        }
      },
    );

    // print(databasePath);
    //output: /data/user/0/br.com.vituflutter.flutter_sqlite_example/databases

    // print(databasefinalPath);
    //!repare que o 'path' colocoua barra '/'
    //output: /data/user/0/br.com.vituflutter.flutter_sqlite_example/databases/SQLITE_EXAMPLE
  }
}
