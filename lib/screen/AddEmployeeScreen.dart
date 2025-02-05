import 'package:employee_app/bloc/EmployeeBloc.dart';
import 'package:employee_app/model/Model.dart';  // Make sure you have the Employee model
import 'package:employee_app/utils/CalenderScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddEmployeeScreen extends StatefulWidget {
  final Employee? employee;

  AddEmployeeScreen({this.employee}); // Constructor to pass employee data

  @override
  _AddEmployeeScreenState createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final _nameController = TextEditingController();
  String _selectedRole = 'Product Designer';
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();

    // If employee data is passed, pre-fill the fields
    if (widget.employee != null) {
      _nameController.text = widget.employee!.name;
      _selectedRole = widget.employee!.role;
      _startDate = DateTime.parse(widget.employee!.startDate);  // Assuming startDate is stored as ISO string
      _endDate = DateTime.parse(widget.employee!.endDate);      // Assuming endDate is stored as ISO string
    }
  }

  void _showRoleSelectionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bottomSheetContext) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: ['Product Designer', 'Flutter Developer', 'QA Tester', 'Product Owner']
                .map((role) => ListTile(
              title: Text(role),
              onTap: () {
                setState(() => _selectedRole = role);
                Navigator.pop(bottomSheetContext);
              },
            ))
                .toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.employee == null ? 'Add Employee Details' : 'Edit Employee Details',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false, // Hides default back button
        leading: GestureDetector(
          onTap: () => Navigator.pop(context), // Custom back action
          child: Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Employee Name',
                labelStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person_2_outlined, color: Colors.blue),
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                _showRoleSelectionSheet(context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.work_outline, color: Colors.blue),
                    SizedBox(width: 10),
                    Text(_selectedRole, style: TextStyle(fontSize: 16)),
                    Spacer(),
                    Icon(Icons.arrow_drop_down, color: Colors.blue),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _startDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      setState(() => _startDate = pickedDate);
                    },
                    icon: Icon(Icons.calendar_month_sharp, color: Colors.blue),
                    label: Text(
                      _startDate == null
                          ? 'Today'
                          : _startDate!.toLocal().toString().split(' ')[0],
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Icon(Icons.arrow_forward_outlined, color: Colors.blue),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _endDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      setState(() => _endDate = pickedDate);
                    },
                    icon: Icon(Icons.calendar_month_sharp, color: Colors.blue),
                    label: Text(
                      _endDate == null
                          ? 'No date'
                          : _endDate!.toLocal().toString().split(' ')[0],
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel', style: TextStyle(color: Colors.blue)),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(100, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    if (_nameController.text.isNotEmpty &&
                        _startDate != null &&
                        _endDate != null) {
                      final employee = Employee(
                        id: widget.employee?.id ?? DateTime.now().millisecondsSinceEpoch, // Generate ID if new
                        name: _nameController.text,
                        role: _selectedRole,
                        startDate: _startDate!.toIso8601String(),
                        endDate: _endDate!.toIso8601String(),
                      );
                      if (widget.employee == null) {
                        BlocProvider.of<EmployeeBloc>(context).add(AddEmployee(employee));
                      } else {
                        BlocProvider.of<EmployeeBloc>(context).add(UpdateEmployee(employee));
                      }
                      Navigator.pop(context);
                    }
                  },
                  child: Text(widget.employee == null ? 'Save' : 'Update',
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: Size(100, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
