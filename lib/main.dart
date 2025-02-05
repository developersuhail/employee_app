import 'package:employee_app/bloc/EmployeeBloc.dart';
import 'package:employee_app/screen/EmployeeListScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


void main() {
  runApp(
    BlocProvider(
      create: (context) => EmployeeBloc(),
      child: MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pet Adoption App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: EmployeeListScreen(), // Initial page (e.g., the page with the list of pets)
    );
  }
}