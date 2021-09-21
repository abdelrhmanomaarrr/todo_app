import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todolist/cubit/states.dart';
import '../ArchiveTasks.dart';
import '../DoneTasks.dart';
import '../NewTasks.dart';

class AppCubit extends Cubit<AppStates>
{
  AppCubit():super(AppInitialState());
  static AppCubit get(context)=> BlocProvider.of(context);
  int currentIndex = 0;

  List<Widget> Screens = [
    NewTasks(),
    DoneTasks(),
    ArchiveTasks(),
  ];
  List<String>titles=
  [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];
  void ChangeIndex (int index)
  {
    currentIndex=index;
    emit(AppChangeBottomNavBarState());
  }
  Database database;
  List<Map>newtasks = [] ;
  List<Map>donetasks = [] ;
  List<Map>archivetasks = [] ;
  void createDatabase()
  {
     openDatabase(
        'todo.db',
        version: 1,
        onCreate:(database,version)
        {
          print('Create DataBase');
          database.execute('CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT ,date TEXT, time TEXT, status   )')
              .then((value)
          {
            print('Create Table');
          }).catchError((error)
          {
            print('Error when Creating Table${error.toString()}');
          });
        },
        onOpen: (database)
        {
           getDataFromDatabase(database)  ;
          print('DataBase Opened');
        }
        ).then((value)
     {
       database=value;
       emit(AppCreateDataBaseState());
     });
  }

   insertTODatabase
      ({
    @required String title,
    @required String time,
    @required String date,
  })async
  {
    await  database.transaction((txn)
    {
      txn.rawInsert('INSERT INTO Tasks ( title, date, time, status) VALUES("$title ","$date","$time","new") '
      ).then((value) {
        print('$value inserted sucsefluy');
        emit(AppInsertDataBaseState());

        getDataFromDatabase(database);
      }).catchError((error){
        print('Error ${error.toString()}');
      });
      return null;
    });

  }
  void getDataFromDatabase(database)
  {
    newtasks=[];
    donetasks=[];
    archivetasks=[];

    emit(AppGetDataBaseLoadingState());
     database.rawQuery('SELECT * FROM tasks').then((value) {

       value.forEach((element)
       {
         if(element['status']=='new')
         newtasks.add(element);
         else if(element['status']=='done')
           donetasks.add(element);
         else
           archivetasks.add(element);
       });
       emit(AppGetDataBaseState());
     });
  }
  void updateData(
  {
    @required String status,
    @required int id,
  })async
  {
    database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        ['$status',id],
    ).then((value)
    {
      getDataFromDatabase(database);
      emit(AppGetUpdateBaseState());
    });
  }
  void deleteData(
      {
        @required int id,
      })async
  {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id])
        .then((value)
    {
      getDataFromDatabase(database);
      emit(AppGetDelteBaseState());
    });
  }

  bool isBottomSheetShown=false;
  IconData fabIcon=Icons.edit;
  void ChangeBottomSheetState(
  {
   @required bool ishow,
   @required IconData icon,
  })
  {    isBottomSheetShown =ishow;
    fabIcon = icon ;
    emit(AppChangeBottomSheetState());
  }
}