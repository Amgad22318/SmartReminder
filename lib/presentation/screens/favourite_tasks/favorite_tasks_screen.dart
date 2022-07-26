import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../business_logic/cubit/cubit.dart';
import '../../../../business_logic/cubit/states.dart';
import '../../views/task_builder.dart';

class FavoriteTasksScreen extends StatelessWidget {
  const FavoriteTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToDoAppCubit, ToDoAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = ToDoAppCubit.get(context).favoriteTasks;

        return TaskLayoutBuilder(
            tasks: tasks,
            noTasksMsg: 'Add Your Favorite Tasks Now',
            taskType: 'favorite');
      },
    );
  }
}
