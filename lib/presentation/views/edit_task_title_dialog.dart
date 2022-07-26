import 'package:algoriza_task_2_todo_app_75/presentation/widgets/default_text.dart';
import 'package:algoriza_task_2_todo_app_75/presentation/widgets/default_text_button.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../business_logic/cubit/cubit.dart';
import '../styles/colors.dart';
import '../widgets/default_form_field.dart';

class EditTaskTitleDialog extends StatelessWidget {
  EditTaskTitleDialog({Key? key, required this.model}) : super(key: key);

  Map model;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    titleController = TextEditingController(text: '${model['title']}');

    return Dialog(
      backgroundColor: defaultAppColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
      child: Container(
        decoration: BoxDecoration(
          color: defaultAppColor,
          borderRadius: BorderRadius.circular(20.0),
        ),
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DefaultFormField(
                controller: titleController,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Title must not be empty';
                  }
                  return null;
                },
                labelText: 'Task Title',
                textColor: defaultAppWhiteColor,
                prefixIcon: const Icon(
                  Icons.edit,
                  color: defaultAppWhiteColor,
                ),
              ),
              SizedBox(
                height: 3.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: DefaultTextButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          ToDoAppCubit.get(context).editTaskTitle(
                              title: titleController.text, id: model['id']);
                          Fluttertoast.showToast(
                              msg: "Title edited successfully",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: defaultAppColor2,
                              textColor: defaultAppWhiteColor,
                              fontSize: 14.sp);
                          Navigator.of(context).pop();
                        }
                      },
                      child: const DefaultText(
                        text: 'Save',
                        color: defaultAppWhiteColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: DefaultTextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const DefaultText(
                        text: 'Cancel',
                        color: defaultAppWhiteColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
