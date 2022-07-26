import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../styles/colors.dart';
import '../widgets/default_text.dart';
import 'completed_task_item.dart';
import 'favorite_task_item.dart';
import 'uncompleted_task_item.dart';
import 'all_task_item.dart';

class TaskLayoutBuilder extends StatelessWidget {
  TaskLayoutBuilder(
      {Key? key,
      required this.taskType,
      required this.noTasksMsg,
      required this.tasks})
      : super(key: key);

  List<Map> tasks;
  String noTasksMsg;
  String taskType;

  @override
  Widget build(BuildContext context) {
    return ConditionalBuilder(
      condition: tasks.isNotEmpty,
      builder: (context) => ListView.separated(
        itemBuilder: (context, index) {
          if (taskType == 'uncompleted') {
            return DoneTaskItem(
              model: tasks[index],
            );
          } else if (taskType == 'completed') {
            return CompletedTaskItem(
              model: tasks[index],
            );
          } else if (taskType == 'favourite') {
            return FavoriteTaskItem(
              model: tasks[index],
            );
          } else {
            return AllTaskItem(model: tasks[index]);
          }
        },
        separatorBuilder: (context, index) => Row(
          children: [
            Expanded(child: Divider(height: 1.h, color: Colors.black54)),
          ],
        ),
        itemCount: tasks.length,
      ),
      fallback: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.clear_all,
              size: 75.0,
              color: defaultAppColor,
            ),
            Flexible(
              child: DefaultText(
                text: noTasksMsg,
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
                color: defaultAppColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
