import 'package:get/get.dart';

class EmployeeController extends GetxController {
  var empId = "".obs;
  var isFin = false.obs;
  var adminId = "".obs;

  // 🔹 Store employee/admin details as a map
  var details = <String, dynamic>{}.obs;

  void setEmpId(String id) => empId.value = id;
  void setIsFin(bool fin) => isFin.value = fin;
  void setAdminId(String id) => adminId.value = id;

  /// 🔹 Save backend response (employee or admin details)
  void setDetails(Map<String, dynamic> data) {
    details.assignAll(data);
  }

  /// 🔹 Clear everything when user logs out
  void clear() {
    empId.value = "";
    isFin.value = false;
    adminId.value = "";
    details.clear();
  }
}
