import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseSqflite {
  Future<void> openConnection() async {
    //getDatabasesPath -> é a pasta aonde ele guarda tudo que tem gravado dentro do sqflite
    final databasePath = await getDatabasesPath();

    //!Repare nessa / não sabesmo se o android e ios aceita, com isso utilizamos o package PATH
    // databasePath += '/SQL_EXAMPLE';

    //!Repare agora nós utilizando o package PATH
    final databasefinalPath = join(databasePath, 'SQLITE_EXAMPLE');

    await openDatabase(
      databasefinalPath,
      //sempre começa no 1, só alteramos a versão quando alteramos algo na database
      version: 1,
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
        batch.commit();
      },
      //onUpgrade -> aqui que atualizamos alguma coisa dentro do database para podermos troca o 'Version'
      onUpgrade: (Database db, int oldVersion, int version) {
        print('onUpgrade chamado');
      },
      //onDowngrade -> sera chamado sempre que ouver uma alteração no version para menos (2 -> 1)
      onDowngrade: (Database db, int oldVersion, int version) {
        print('onDowngrade chamado');
      },
    );

    // print(databasePath);
    //output: /data/user/0/br.com.vituflutter.flutter_sqlite_example/databases

    // print(databasefinalPath);
    //!repare que o 'path' colocoua barra '/'
    //output: /data/user/0/br.com.vituflutter.flutter_sqlite_example/databases/SQLITE_EXAMPLE
  }
}
