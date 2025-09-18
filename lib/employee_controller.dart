import 'package:get/get.dart';

class EmployeeController extends GetxController {
  var empId = "".obs;

  void setEmpId(String id) {
    empId.value = id;
  }
}
