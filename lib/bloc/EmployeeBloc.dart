import 'package:employee_app/db/DataBaseHelper.dart';
import 'package:employee_app/model/Model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Employee Bloc
abstract class EmployeeEvent {}
class LoadEmployees extends EmployeeEvent {}
class AddEmployee extends EmployeeEvent {
  final Employee employee;
  AddEmployee(this.employee);
}

class DeleteEmployee extends EmployeeEvent {
  final int id;
  DeleteEmployee(this.id);
}

class UpdateEmployee extends EmployeeEvent {
  final Employee employee;
  UpdateEmployee(this.employee);
}

class EmployeeState {
  final List<Employee> employees;
  EmployeeState(this.employees);
}

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  EmployeeBloc() : super(EmployeeState([])) {
    on<LoadEmployees>((event, emit) async {
      final employees = await DatabaseHelper.instance.getEmployees();
      emit(EmployeeState(employees));
    });
    on<AddEmployee>((event, emit) async {
      await DatabaseHelper.instance.insertEmployee(event.employee);
      final employees = await DatabaseHelper.instance.getEmployees();
      emit(EmployeeState(employees));
    });
    on<DeleteEmployee>((event, emit) {
      final updatedEmployees = state.employees.where((e) => e.id != event.id).toList();
      emit(EmployeeState(updatedEmployees));
    });

    // Update Employee
    on<UpdateEmployee>((event, emit) async {
      // Update employee in the database
      await DatabaseHelper.instance.updateEmployee(event.employee);

      // Fetch updated list of employees
      final employees = await DatabaseHelper.instance.getEmployees();
      emit(EmployeeState(employees));
    });

  }
}