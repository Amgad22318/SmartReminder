import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../business_logic/cubit/cubit.dart';
import '../../../../business_logic/cubit/states.dart';
import '../../views/task_builder.dart';

class UncompletedTasksScreen extends StatelessWidget {
  const UncompletedTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToDoAppCubit, ToDoAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = ToDoAppCubit.get(context).uncompletedTasks;
        return TaskLayoutBuilder(
            tasks: tasks,
            noTasksMsg: 'Add Uncompleted Tasks Now',
            taskType: 'uncompleted');
      },
    );
  }
}
