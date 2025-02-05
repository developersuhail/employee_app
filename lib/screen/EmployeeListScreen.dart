import 'package:employee_app/bloc/EmployeeBloc.dart';
import 'package:employee_app/screen/AddEmployeeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeListScreen extends StatefulWidget {
  @override
  _EmployeeListScreenState createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  @override
  void initState() {
    super.initState();
    // Trigger the event to load employees from the database
    BlocProvider.of<EmployeeBloc>(context).add(LoadEmployees());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Employee List',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white), // Ensure back icon is white
      ),
      body: BlocBuilder<EmployeeBloc, EmployeeState>(
        builder: (context, state) {
          if (state.employees.isEmpty) {
            return Center(child: Text('No employees found. Add some!'));
          }

          // Sort employees by their start date
          state.employees.sort((a, b) => DateTime.parse(a.startDate).compareTo(DateTime.parse(b.startDate)));

          // Separate the employees into previous and current ones
          final previousEmployees = state.employees.where((e) => DateTime.parse(e.endDate).isBefore(DateTime.now())).toList();
          final currentEmployees = state.employees.where((e) => DateTime.parse(e.endDate).isAfter(DateTime.now()) || e.endDate == null).toList();

          return ListView(
            children: [
              // Show the list of current employees
              Container(
                width: double.infinity, // Makes it take the full width
                color: Colors.black12, // Background color
                padding: const EdgeInsets.only(left: 8.0, top: 10.0, bottom: 10.0,), // Adds padding
                child: Text(
                  'Current Employees',
                  textAlign: TextAlign.start, // Centers the text
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              ...currentEmployees.map((employee) {
                return Dismissible(
                  key: Key(employee.id.toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    BlocProvider.of<EmployeeBloc>(context).add(DeleteEmployee(employee.id!));
                  },
                  child: ListTile(
                    title: Text(employee.name),
                    subtitle: Text(employee.role),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddEmployeeScreen(employee: employee),
                        ),
                      );
                    },
                  ),
                );
              }).toList(),

              // Divider between current and previous employees
              // if (previousEmployees.isNotEmpty)
              //   Padding(
              //       padding: const EdgeInsets.symmetric(horizontal: 8.0),
              //       child:
              //   Divider(
              //     height: 20,
              //     thickness: 1,
              //     color: Colors.grey[400],
              //   ),),

              // Show the "Previous Employee" label only if there are previous employees
              if (previousEmployees.isNotEmpty)
                Container(
                  width: double.infinity, // Makes it take the full width
                  color: Colors.black12, // Background color
                  padding: const EdgeInsets.only(left: 8.0, top: 10.0, bottom: 10.0,), // Adds padding
                  child: Text(
                    'Previous Employees',
                    textAlign: TextAlign.start, // Centers the text
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),

              // Show the list of previous employees
              ...previousEmployees.map((employee) {
                return Dismissible(
                  key: Key(employee.id.toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    BlocProvider.of<EmployeeBloc>(context).add(DeleteEmployee(employee.id!));
                  },
                  child: ListTile(
                    title: Text(employee.name),
                    subtitle: Text(employee.role),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddEmployeeScreen(employee: employee),
                        ),
                      );
                    },
                  ),
                );
              }).toList(),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddEmployeeScreen()),
        ),
        child: Icon(Icons.add),
      ),
    );
  }
}
