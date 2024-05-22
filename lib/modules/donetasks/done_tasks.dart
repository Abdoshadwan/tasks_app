
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks_app/shared/components/conponents.dart';
import 'package:tasks_app/shared/cubit/cubit.dart';
import 'package:tasks_app/shared/cubit/states.dart';

class done_tasks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<appcubit, appstates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = appcubit.get(context).donetasks;
        return taskbuilderscreen(tasks: tasks,label: 'NO DONE TASKS');
      },
    );
  }
}
