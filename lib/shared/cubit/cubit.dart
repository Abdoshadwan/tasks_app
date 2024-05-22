import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tasks_app/modules/archive/archive_tasks.dart';
import 'package:tasks_app/modules/donetasks/done_tasks.dart';
import 'package:tasks_app/modules/tasks/new_task_screen.dart';
import 'package:tasks_app/shared/cubit/states.dart';

class appcubit extends Cubit<appstates> {
  appcubit() : super(appinitialstate());

  static appcubit get(context) => BlocProvider.of<appcubit>(context);

  int currentindex = 0;

  List<Widget> screens = [task_screen(), done_tasks(), archive_tasks()];
  List<String> titles = ['Tasks_Screen', 'Done_Tasks', 'Archive_Tasks'];

  void changeindex(int index) {
    currentindex = index;
    emit(changebottomnavstate());
  }

  Database? database;
  List<Map> tasks = [];
  List<Map> donetasks = [];
  List<Map> archivetasks = [];

  void create_dbase() async {
    database = await openDatabase('mations.db', version: 1,
        onCreate: (database, version) {
      print('database created');
      database
          .execute(
              'CREATE TABLE task (id INTEGER PRIMARY KEY, title TEXT , date TEXT, time TEXT,status TEXT)')
          .then((value) {
        print('table created');
      }).catchError((error) {
        print('error when creating table ${error.toString()}');
      });
    }, onOpen: (database) {
      getdatabase(database);
      print('data base opened ');
    }).then((value) {
      database = value;
      emit(appcreatedatabase());
      return null;
    });
  }

  bool issheet = false;
  IconData iconsheet = Icons.edit;
  void changebottomsheet({required bool isshow, required IconData icon}) {
    issheet = isshow;
    iconsheet = icon;
    emit(floatbutomicon());
  }

  insert_into_db({
    required String title,
    required String time,
    required String date,
  }) async {
    database = await openDatabase(
      'mations.db',
      version: 1,
    );
    await database?.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO task (title, date, time, status) VALUES ("$title", "$date", "$time", "New")')
          .then((value) {
        print('$value inserted successfully');

        emit(appinsertdatabase());
        getdatabase(database);
      }).catchError((error) {
        print("error occur when inserting ${error.toString()}");
      });
      return null;
    });
  }

  update_db({required String status, required int id}) async {
    database = await openDatabase(
      'mations.db',
      version: 1,
    );
    database?.rawUpdate('UPDATE task SET status=? WHERE id=?',
        ['$status', '$id']).then((value) {
      getdatabase(database);
      emit(appupdatedatabase());
    });
  }

  void getdatabase(database) async {
    tasks = [];
    donetasks = [];
    archivetasks = [];
    emit(appgetdatabaseload());

    database.rawQuery('SELECT * FROM task').then((value) {
      value.forEach((element) {
        if (element['status'] == 'New') {
          tasks.add(element);
        } else if (element['status'] == 'done') {
          donetasks.add(element);
        } else {
          archivetasks.add(element);
        }
      });
      emit(appgetdatabase());
    });
  }

  void deleteData({required int id}) async {
    database = await openDatabase(
      'mations.db',
      version: 1,
    );
    database?.rawDelete('DELETE FROM task WHERE id=?', ['$id']).then((value) {
      getdatabase(database);
      emit(appdeletdatabase());
    });
  }
}
