class Employee {
  final String employeeId;
  final String fullName;
  final String phoneNumber;
  final String companyEmail;

  final double salary;
  final double bonus;

  /// NEW FIELDS
  final String? shiftStart; // Example: "09:30"
  final String? shiftEnd; // Example: "18:00"

  Employee({
    required this.employeeId,
    required this.fullName,
    required this.phoneNumber,
    required this.companyEmail,
    required this.salary,
    required this.bonus,
    this.shiftStart,
    this.shiftEnd,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      employeeId: json['employeeId'] ?? "",
      fullName: json['fullName'] ?? "",
      phoneNumber: json['phoneNumber'] ?? "",
      companyEmail: json['companyEmail'] ?? "",
      salary: json['salary'] != null
          ? double.tryParse(json['salary'].toString()) ?? 0
          : 0,
      bonus: json['bonus'] != null
          ? double.tryParse(json['bonus'].toString()) ?? 0
          : 0,

      /// shift mapping
      shiftStart: json['shiftStart'],
      shiftEnd: json['shiftEnd'],
    );
  }

  /// OPTIONAL — if you want to send back JSON
  Map<String, dynamic> toJson() {
    return {
      "employeeId": employeeId,
      "fullName": fullName,
      "phoneNumber": phoneNumber,
      "companyEmail": companyEmail,
      "salary": salary,
      "bonus": bonus,
      "shiftStart": shiftStart,
      "shiftEnd": shiftEnd,
    };
  }
}
