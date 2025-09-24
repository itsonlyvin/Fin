class Employee {
  final String employeeId;
  final String fullName;
  final String phoneNumber;
  final String companyEmail;
  final double salary;
  final double bonus;

  Employee({
    required this.employeeId,
    required this.fullName,
    required this.phoneNumber,
    required this.companyEmail,
    required this.salary,
    required this.bonus,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      employeeId: json['employeeId'] ?? "",
      fullName: json['fullName'] ?? "",
      phoneNumber: json['phoneNumber'] ?? "",
      companyEmail: json['companyEmail'] ?? "",
      salary: (json['salary'] != null)
          ? double.tryParse(json['salary'].toString()) ?? 0
          : 0,
      bonus: (json['bonus'] != null)
          ? double.tryParse(json['bonus'].toString()) ?? 0
          : 0,
    );
  }
}
