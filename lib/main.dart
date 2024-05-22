import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart'; 
import 'package:tasks_app/shared/bloc_observe.dart';
import 'layout/home.dart';

void main() {

   Bloc.observer = MyBlocObserver();

  runApp(MaterialApp(
    home:  home(),
  ));
}
