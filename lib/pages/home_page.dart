import 'package:flutter/material.dart';
import 'package:flutter_sqlite_example/database/database_sqflite.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    _database();
    super.initState();
  }

  void _database() async {
    final database = await DatabaseSqflite().openConnection();

    //fazendo insert
    // database.insert('teste', {'nome': 'Vitor1'});
    // database.insert('teste', {'nome': 'Vitor2'});
    // database.insert('teste', {'nome': 'Vitor3'});

    //deletando
    // database.delete('teste', where: 'nome = ?', whereArgs: ['Vitor']);

    //dando um update
    // database.update('teste', {'nome': 'Academia do flutter'},
    //     where: 'nome = ?', whereArgs: ['Vitor2']);

    //Para ver o banco de dados
    // var result = await database.query('teste');
    // print(result);

    // database.rawInsert('insert into teste values(null, ?)', ['Vitor7']);
    // database
    //     .rawInsert('update teste set nome = ? where id = ?', ['seninha', 5]);
    // database.rawDelete('delete from teste where id = ?', [5]);
    var result3 = await database.rawQuery('select * from teste');
    print(result3);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Container(),
    );
  }
}
