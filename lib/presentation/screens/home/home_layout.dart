import 'package:algoriza_task_2_todo_app_75/business_logic/cubit/states.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:algoriza_task_2_todo_app_75/presentation/widgets/default_text.dart';
import '../../../business_logic/cubit/cubit.dart';
import '../../styles/colors.dart';
import '../../widgets/default_form_field.dart';

class HomeLayout extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  TimeOfDay initialStartTime = TimeOfDay.now();
  TimeOfDay initialEndTime =
      TimeOfDay.fromDateTime(DateTime.now().add(const Duration(minutes: 1)));
  TimeOfDay? selectedStartTime;
  TimeOfDay? selectedEndTime;
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToDoAppCubit, ToDoAppStates>(
      listener: (BuildContext context, ToDoAppStates state) {
        if (state is ToDoAppInsertTaskState) {
          Navigator.pop(context);
        }
      },
      builder: (BuildContext context, ToDoAppStates state) {
        ToDoAppCubit cubit = ToDoAppCubit.get(context);

        return Scaffold(
          backgroundColor: defaultAppWhiteColor,
          key: scaffoldKey,
          appBar: AppBar(
              automaticallyImplyLeading: false,
              toolbarHeight: 70,
              backgroundColor: defaultAppColor,
              title: Center(
                child: DefaultText(
                  text: cubit.titles[cubit.currentIndex],
                  color: defaultAppWhiteColor,
                  fontWeight: FontWeight.bold,
                ),
              )),
          body: ConditionalBuilder(
            condition: state is! ToDoAppGetDBLoadingState,
            builder: (BuildContext context) =>
                cubit.screens[cubit.currentIndex],
            fallback: (context) =>
                const Center(child: CircularProgressIndicator()),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: defaultAppColor2,
            onPressed: () {
              if (cubit.isBottomSheetShown) {
                if (formKey.currentState!.validate()) {
                  cubit.insertToDatabase(
                    title: titleController.text,
                    startTime: startTimeController.text,
                    endTime: endTimeController.text,
                    date: dateController.text,
                    reminder: cubit.dropDownValue,
                  );
                  cubit.setReminder(titleController.text, selectedDate!,
                      selectedStartTime!, cubit.dropDownValue);
                }
              } else {
                scaffoldKey.currentState!
                    .showBottomSheet(
                      (context) => Wrap(
                        children: [
                          Container(
                            color: defaultAppColor,
                            padding: EdgeInsets.symmetric(
                                vertical: 2.h, horizontal: 3.w),
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
                                      Icons.title_outlined,
                                      color: defaultAppWhiteColor,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 2.h),
                                    child: DefaultFormField(
                                      controller: dateController,
                                      keyboardType: TextInputType.datetime,
                                      onTap: () {
                                        showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate:
                                              DateTime.parse('2030-02-06'),
                                        ).then((value) {
                                          selectedDate = value;
                                          dateController.text =
                                              DateFormat.yMMMd()
                                                  .format(value!)
                                                  .toString();
                                        });
                                      },
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Date must not be empty';
                                        }
                                        return null;
                                      },
                                      labelText: 'Task Date',
                                      textColor: defaultAppWhiteColor,
                                      prefixIcon: const Icon(
                                        Icons.date_range_outlined,
                                        color: defaultAppWhiteColor,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsetsDirectional.only(
                                              end: 2.w),
                                          child: DefaultFormField(
                                            controller: startTimeController,
                                            onTap: () {
                                              showTimePicker(
                                                context: context,
                                                initialTime: initialStartTime,
                                              ).then((value) {
                                                selectedStartTime = value;
                                                startTimeController.text =
                                                    selectedStartTime!
                                                        .format(context)
                                                        .toString();
                                              });
                                            },
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Start Time must not be empty';
                                              }
                                              return null;
                                            },
                                            labelText: 'Start Time',
                                            textColor: defaultAppWhiteColor,
                                            prefixIcon: const Icon(
                                              Icons.timer,
                                              color: defaultAppWhiteColor,
                                            ),
                                            keyboardType:
                                                TextInputType.datetime,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: DefaultFormField(
                                          controller: endTimeController,
                                          onTap: () {
                                            showTimePicker(
                                              context: context,
                                              initialTime: initialEndTime,
                                            ).then((value) {
                                              if (value!.hour.toDouble() >
                                                  selectedStartTime!.hour
                                                      .toDouble()) {
                                                selectedEndTime = value;
                                                endTimeController.text =
                                                    selectedEndTime!
                                                        .format(context)
                                                        .toString();
                                              } else if (value.hour
                                                          .toDouble() ==
                                                      selectedStartTime!.hour
                                                          .toDouble() &&
                                                  value.minute.toDouble() >=
                                                      selectedStartTime!.minute
                                                          .toDouble()) {
                                                selectedEndTime = value;
                                                endTimeController.text =
                                                    selectedEndTime!
                                                        .format(context)
                                                        .toString();
                                              } else {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "End Time can't be before Start Time",
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    gravity:
                                                        ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor:
                                                        defaultAppColor2,
                                                    textColor:
                                                        defaultAppWhiteColor,
                                                    fontSize: 16.0);
                                              }
                                            });
                                          },
                                          labelText: 'End Time',
                                          textColor: defaultAppWhiteColor,
                                          prefixIcon: const Icon(
                                            Icons.timer_off_outlined,
                                            color: defaultAppWhiteColor,
                                          ),
                                          keyboardType: TextInputType.datetime,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 2.h),
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: defaultAppColor,
                                        border: Border.all(
                                            color: defaultBlack, width: 0.3),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: BlocBuilder<ToDoAppCubit,
                                          ToDoAppStates>(
                                        builder: (BuildContext context, state) {
                                          return DropdownButton(
                                              isExpanded: true,
                                              dropdownColor: defaultAppColor2,
                                              icon: Padding(
                                                padding:
                                                    EdgeInsetsDirectional.only(
                                                        end: 3.w),
                                                child: const Icon(
                                                  Icons.keyboard_arrow_down,
                                                  color: defaultAppWhiteColor,
                                                ),
                                              ),
                                              value: cubit.dropDownValue,
                                              items: cubit.dropDownListItems
                                                  .map((String items) {
                                                return DropdownMenuItem(
                                                    value: items,
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .only(start: 3.w),
                                                      child: DefaultText(
                                                        text: items,
                                                        color:
                                                            defaultAppWhiteColor,
                                                      ),
                                                    ));
                                              }).toList(),
                                              onChanged: (String? newValue) {
                                                cubit.changeDropDownListValue(
                                                    newValue!);
                                              });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      elevation: 20.0,
                    )
                    .closed
                    .then((value) {
                  cubit.changeBSState(
                    isShow: false,
                    icon: Icons.note_add_outlined,
                  );
                });
                cubit.changeBSState(
                  isShow: true,
                  icon: Icons.add,
                );
              }
            },
            child: Icon(
              cubit.fabIcon,
              color: defaultAppWhiteColor,
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            onTap: (index) {
              cubit.changeIndex(index);
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: defaultAppColor,
            selectedItemColor: defaultAppColor2,
            unselectedItemColor: defaultAppWhiteColor,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.menu,
                ),
                label: 'All',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.close_outlined,
                ),
                label: 'Uncompleted',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.check_circle_outline,
                ),
                label: 'Completed',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.favorite,
                ),
                label: 'Favourite',
              ),
            ],
          ),
        );
      },
    );
  }
}
