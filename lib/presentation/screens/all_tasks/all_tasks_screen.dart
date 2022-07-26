import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../business_logic/cubit/cubit.dart';
import '../../../../business_logic/cubit/states.dart';
import '../../views/task_builder.dart';

class AllTasksScreen extends StatelessWidget {
  const AllTasksScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToDoAppCubit, ToDoAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = ToDoAppCubit.get(context).allTasks;

        return TaskLayoutBuilder(
            tasks: tasks, noTasksMsg: 'Add Tasks Now', taskType: 'all');
      },
    );
  }
}
