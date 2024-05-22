import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:tasks_app/shared/cubit/cubit.dart';

Widget defaultformfield({
  required TextEditingController controller,
  required String? Function(String?) validatee,
  required TextInputType type,
  Function(String)? onSubmit,
  Function(String)? onchange,
  required String label,
  required IconData prefix,
  VoidCallback? ontap,
  bool isclick = true,
}) =>
    TextFormField(
      enabled: isclick,
      validator: validatee,
      onTap: ontap,
      controller: controller,
      keyboardType: type,
      onFieldSubmitted: onSubmit,
      onChanged: onchange,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefix),
        border: OutlineInputBorder(),
      ),
    );

Widget buildtaskitem(Map model, context) => Dismissible(
      key: Key(model['id'].toString()),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Colors.blueAccent, Colors.yellowAccent])),
              child: CircleAvatar(
                backgroundColor: Colors.blueAccent,
                radius: 40,
                child: Text(
                  '${model['time']}',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${model['title']}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${model['date']}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color.fromARGB(255, 128, 128, 122),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              width: 20,
            ),
            IconButton(
                onPressed: () {
                  appcubit
                      .get(context)
                      .update_db(status: 'done', id: model['id']);
                },
                icon: Icon(
                  Icons.check_circle_outline_outlined,
                  color: const Color.fromARGB(255, 168, 168, 7),
                )),
            IconButton(
                onPressed: () {
                  appcubit
                      .get(context)
                      .update_db(status: 'archive', id: model['id']);
                },
                icon: Icon(
                  Icons.archive,
                  color: Colors.blueAccent,
                ))
          ],
        ),
      ),
      onDismissed: (direction) {
        appcubit.get(context).deleteData(id: model['id']);
      },
    );

Widget taskbuilderscreen({required List<Map> tasks, required String label}) =>
    ConditionalBuilder(
      condition: tasks.length > 0,
      builder: (context) {
        return ListView.separated(
          itemBuilder: (context, index) => buildtaskitem(tasks[index], context),
          separatorBuilder: (context, index) =>
              Container(color: Colors.grey, width: double.infinity, height: 1),
          itemCount: tasks.length,
        );
      },
      fallback: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.hourglass_empty_outlined,
              size: 50,
              color: Color.fromARGB(255, 148, 184, 52),
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              '$label',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 148, 184, 52),
              ),
            )
          ],
        ),
      ),
    );
