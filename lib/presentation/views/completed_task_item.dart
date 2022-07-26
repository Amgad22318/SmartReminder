import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../business_logic/cubit/cubit.dart';
import '../styles/colors.dart';
import '../widgets/default_text.dart';
import 'edit_task_title_dialog.dart';

class CompletedTaskItem extends StatelessWidget {
  CompletedTaskItem({Key? key, required this.model}) : super(key: key);

  Map model;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(model['id'].toString()),
      child: InkWell(
        splashColor: defaultAppColor,
        highlightColor: defaultAppColor,
        onTap: () {
          Fluttertoast.showToast(
              msg: "Swipe to delete , Long touch to edit Title",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: defaultAppColor2,
              textColor: defaultAppWhiteColor,
              fontSize: 14.sp);
        },
        onLongPress: () {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return EditTaskTitleDialog(
                model: model,
              );
            },
          );
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 1.h),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.only(start: 3.w),
                      child: DefaultText(
                        text: '${model['title']}',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        maxLines: 3,
                        color: defaultAppColor2,
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Icon(
                            Icons.access_time,
                            color: defaultAppColor2,
                          ),
                          Flexible(
                            child: DefaultText(
                              maxLines: 3,
                              text: '${model['reminder']}',
                              fontSize: 10.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 8,
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 3.h, horizontal: 3.w),
                          decoration: BoxDecoration(
                            color: defaultAppColor,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(16.sp),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              DefaultText(
                                text: '${model['date']}',
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                                color: defaultAppWhiteColor,
                                maxLines: 2,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 2.5.h,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: DefaultText(
                                      text: '${model['startTime']}',
                                      fontSize: 12.sp,
                                      color: defaultAppWhiteColor,
                                      fontWeight: FontWeight.bold,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  DefaultText(
                                    text: ' | ',
                                    fontSize: 12.sp,
                                    color: defaultAppWhiteColor,
                                    fontWeight: FontWeight.bold,
                                    textAlign: TextAlign.center,
                                  ),
                                  Expanded(
                                    child: DefaultText(
                                      text: '${model['endTime']}',
                                      fontSize: 12.sp,
                                      color: defaultAppWhiteColor,
                                      fontWeight: FontWeight.bold,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            ToDoAppCubit.get(context).changeStatus(
                              status: 'uncompleted',
                              id: model['id'],
                            );
                          },
                          icon: const Icon(
                            Icons.close_outlined,
                            color: defaultAppColor2,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            ToDoAppCubit.get(context).changeStatus(
                              status: 'favorite',
                              id: model['id'],
                            );
                          },
                          icon: const Icon(
                            Icons.favorite,
                            color: defaultAppColor2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      onDismissed: (direction) {
        ToDoAppCubit.get(context).deleteData(
          id: model['id'],
        );
        Fluttertoast.showToast(
            msg: "Task Deleted Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: defaultAppColor2,
            textColor: defaultAppWhiteColor,
            fontSize: 14.sp);
      },
    );
  }
}
