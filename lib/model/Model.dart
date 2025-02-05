

// Employee Model
class Employee {
  final int? id;
  final String name;
  final String role;
  final String startDate;
  final String endDate;

  Employee({this.id, required this.name, required this.role, required this.startDate, required this.endDate});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'role': role, 'startDate': startDate, 'endDate': endDate};
  }
}