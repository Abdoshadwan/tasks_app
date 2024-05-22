import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tasks_app/shared/components/conponents.dart';
import 'package:tasks_app/shared/cubit/cubit.dart';
import 'package:tasks_app/shared/cubit/states.dart';

// ignore: must_be_immutable
class home extends StatelessWidget {
  var titlecontroler = TextEditingController();
  var timecontroler = TextEditingController();
  var datecontroler = TextEditingController();

  appbarcustom(appcubit cubit) {
    return PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: Container(
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Colors.blueAccent, Colors.yellowAccent])),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              cubit.titles[cubit.currentindex],
              style: TextStyle(fontSize: 20),
            ),
          ),
        ));
  }

  var scaffoldkey = GlobalKey<ScaffoldState>();
  var _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => appcubit()..create_dbase(),
      child: BlocConsumer<appcubit, appstates>(
        listener: (BuildContext context, appstates state) {
          if (state is appinsertdatabase) Navigator.pop(context);
        },
        builder: (BuildContext context, state) {
          appcubit cubit = appcubit.get(context);
          return Scaffold(
            key: scaffoldkey,
            appBar: appbarcustom(cubit),
            body: ConditionalBuilder(
              condition: state is! appgetdatabaseload,
              builder: (context) =>
                  appcubit.get(context).screens[cubit.currentindex],
              fallback: (context) => Center(
                child: CircularProgressIndicator(),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.blueAccent,
              onPressed: () {
                if (cubit.issheet) {
                  if (_formkey.currentState!.validate()) {
                    cubit.insert_into_db(
                        title: titlecontroler.text,
                        time: timecontroler.text,
                        date: datecontroler.text);
                  }
                  titlecontroler.clear();
                  timecontroler.clear();
                  datecontroler.clear();
                } else {
                  scaffoldkey.currentState
                      ?.showBottomSheet(
                        elevation: 20,
                        (context) => Container(
                          padding: EdgeInsets.all(20),
                          color: Color.fromARGB(255, 194, 194, 189),
                          child: Form(
                            key: _formkey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                defaultformfield(
                                    controller: titlecontroler,
                                    validatee: (value) {
                                      if (value!.isEmpty) {
                                        return 'title must be not null';
                                      }
                                      return null;
                                    },
                                    type: TextInputType.text,
                                    label: 'Task Title',
                                    prefix: Icons.title),
                                SizedBox(
                                  height: 15,
                                ),
                                defaultformfield(
                                    controller: timecontroler,
                                    ontap: () {
                                      showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now())
                                          .then((value) {
                                        timecontroler.text =
                                            value!.format(context);
                                      });
                                    },
                                    validatee: (value) {
                                      if (value!.isEmpty) {
                                        return 'time must be not null';
                                      }
                                      return null;
                                    },
                                    type: TextInputType.datetime,
                                    label: 'Task Time',
                                    prefix: Icons.watch_later),
                                SizedBox(
                                  height: 15,
                                ),
                                defaultformfield(
                                    controller: datecontroler,
                                    ontap: () {
                                      showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime.now(),
                                              lastDate:
                                                  DateTime.parse("2024-02-27"))
                                          .then((value) {
                                        datecontroler.text =
                                            DateFormat.yMMMd().format(value!);
                                      });
                                    },
                                    validatee: (value) {
                                      if (value!.isEmpty) {
                                        return 'Date must be not null';
                                      }
                                      return null;
                                    },
                                    type: TextInputType.datetime,
                                    label: 'Task Date',
                                    prefix: Icons.calendar_month)
                              ],
                            ),
                          ),
                        ),
                      )
                      .closed
                      .then((value) {
                    cubit.changebottomsheet(isshow: false, icon: Icons.edit);
                  });
                  cubit.changebottomsheet(isshow: true, icon: Icons.add);
                }
              },
              child: Icon(cubit.iconsheet),
            ),
            bottomNavigationBar: BottomNavigationBar(
                showUnselectedLabels: false,
                selectedFontSize: 17,
                selectedItemColor: Colors.blueAccent,
                currentIndex: cubit.currentindex,
                onTap: (index) {
                  cubit.changeindex(index);
                },
                type: BottomNavigationBarType.fixed,
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.task), label: 'Tasks'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.check), label: 'Done'),
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.archive,
                      ),
                      label: 'archive'),
                ]),
          );
        },
      ),
    );
  }
}
