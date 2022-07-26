import 'package:algoriza_task_2_todo_app_75/business_logic/cubit/states.dart';
import 'package:algoriza_task_2_todo_app_75/constants/local_notifications.dart';
import 'package:algoriza_task_2_todo_app_75/presentation/screens/completed_tasks/completed_tasks_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

import '../../presentation/screens/all_tasks/all_tasks_screen.dart';
import '../../presentation/screens/favourite_tasks/favorite_tasks_screen.dart';
import '../../presentation/screens/uncompleted_tasks/uncompleted_tasks_screen.dart';

class ToDoAppCubit extends Cubit<ToDoAppStates> {
  ToDoAppCubit() : super(ToDoAppInitState());

  static ToDoAppCubit get(context) => BlocProvider.of<ToDoAppCubit>(context);

  int currentIndex = 0;

  List<Widget> screens = [
    const AllTasksScreen(),
    const UncompletedTasksScreen(),
    const CompletedTasksScreen(),
    const FavoriteTasksScreen(),
  ];

  List<String> titles = [
    'All Tasks',
    'Uncompleted Tasks',
    'Completed Tasks',
    'Favorite Tasks',
  ];

  void changeIndex(int index) {
    currentIndex = index;
    emit(ToDoAppChangeBNBState());
  }

  List<Map> allTasks = [];
  List<Map> uncompletedTasks = [];
  List<Map> completedTasks = [];
  List<Map> favoriteTasks = [];
  String dropDownValue = '10 Minutes Before';
  var dropDownListItems = [
    '10 Minutes Before',
    '30 Minutes Before',
    '1 Hour Before',
    '1 Day Before',
  ];
  late Database database;

  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        if (kDebugMode) {
          print('database created');
        }
        database
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, startTime TEXT, endTime TEXT, reminder TEXT, status TEXT)')
            .then((value) {
          if (kDebugMode) {
            print('table created');
          }
        }).catchError((error) {
          if (kDebugMode) {
            print('Error when creating table ${error.toString()}');
          }
        });
      },
      onOpen: (database) {
        getDataFromDatabase(database);
        if (kDebugMode) {
          print('database opened');
        }
      },
    ).then((value) {
      database = value;
      emit(ToDoAppCreateDBState());
    });
  }

  void getDataFromDatabase(database) {
    allTasks = [];
    uncompletedTasks = [];
    completedTasks = [];
    favoriteTasks = [];

    emit(ToDoAppGetDBLoadingState());
    database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        allTasks.add(element);

        if (element['status'] == 'uncompleted') {
          uncompletedTasks.add(element);
        } else if (element['status'] == 'completed') {
          completedTasks.add(element);
        } else if (element['status'] == 'favorite') {
          favoriteTasks.add(element);
        }
      });

      emit(ToDoAppGetDBState());
    });
  }

  insertToDatabase(
      {required String title,
      required String startTime,
      required String endTime,
      required String date,
      required String reminder}) async {
    if (endTime.isEmpty) {
      endTime = '∞';
    }
    await database.transaction((txn) {
      return txn
          .rawInsert(
              'INSERT INTO tasks(title, date, startTime, endTime, reminder, status) VALUES("$title", "$date", "$startTime", "$endTime", "$reminder", "uncompleted")')
          .then((value) {
        if (kDebugMode) {
          print('task $value successfully inserted!');
        }
        emit(ToDoAppInsertTaskState());

        getDataFromDatabase(database);
      }).catchError((error) {
        if (kDebugMode) {
          print('Error when inserting to database ${error.toString()}');
        }
      });
    });
  }

  void changeStatus({
    required String status,
    required int id,
  }) async {
    database.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ?',
      [status, id],
    ).then((value) {
      getDataFromDatabase(database);
      emit(ToDoAppChangeStatusState());
    });
  }

  void deleteData({
    required int id,
  }) async {
    database.rawDelete(
      'DELETE FROM tasks WHERE id = ?',
      [id],
    ).then((value) {
      getDataFromDatabase(database);
      emit(ToDoAppDeleteDBState());
    });
  }

  void changeDropDownListValue(String newValue) {
    dropDownValue = newValue;
    emit(ToDoAppChangeDDListValueState());
  }

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.note_add_outlined;

  void changeBSState({
    required bool isShow,
    required IconData icon,
  }) {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(ToDoAppChangeBSState());
  }

  void setReminder(String title, DateTime selectedDate,
      TimeOfDay selectedStartTime, String selectedReminder) {
    int day = selectedDate.day;
    int hour = selectedStartTime.hour;
    int minute = selectedStartTime.minute;

    if (selectedReminder == dropDownListItems.elementAt(0)) {
      minute = minute - 10;
    } else if (selectedReminder == dropDownListItems.elementAt(1)) {
      minute = minute - 30;
    } else if (selectedReminder == dropDownListItems.elementAt(2)) {
      hour = hour - 1;
    } else {
      day = day - 1;
    }

    DateTime joinDateWthTime(DateTime date, int day, int hour, int minute) {
      return DateTime(date.year, date.month, day, hour, minute);
    }

    int i = 0;
    NotificationService().scheduleNotifications(
        i++, title, joinDateWthTime(selectedDate, day, hour, minute));
  }

  void editTaskTitle({
    required String title,
    required int id,
  }) async {
    database.rawUpdate(
      'UPDATE tasks SET title = ? WHERE id = ?',
      [title, id],
    ).then((value) {
      getDataFromDatabase(database);
      emit(ToDoAppEditTitleState());
    });
  }
}
