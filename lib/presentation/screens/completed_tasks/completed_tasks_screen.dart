import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../business_logic/cubit/cubit.dart';
import '../../../../business_logic/cubit/states.dart';
import '../../views/task_builder.dart';

class CompletedTasksScreen extends StatelessWidget {
  const CompletedTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToDoAppCubit, ToDoAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = ToDoAppCubit.get(context).completedTasks;

        return TaskLayoutBuilder(
            tasks: tasks,
            noTasksMsg: 'Add Completed Tasks Now',
            taskType: 'completed');
      },
    );
  }
}
