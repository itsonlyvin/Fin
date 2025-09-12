import 'package:flutter/material.dart';

enum AttendanceStatus { absent, present, halfDay }

class AttendanceRadio extends StatefulWidget {
  const AttendanceRadio({super.key});

  @override
  State<AttendanceRadio> createState() => _AttendanceRadioState();
}

class _AttendanceRadioState extends State<AttendanceRadio> {
  AttendanceStatus _status = AttendanceStatus.absent;

  void _toggleStatus() {
    setState(() {
      if (_status == AttendanceStatus.absent) {
        _status = AttendanceStatus.present;
      } else if (_status == AttendanceStatus.present) {
        _status = AttendanceStatus.halfDay;
      } else {
        _status = AttendanceStatus.absent;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (_status) {
      case AttendanceStatus.absent:
        color = Colors.red;
        break;
      case AttendanceStatus.present:
        color = Colors.green;
        break;
      case AttendanceStatus.halfDay:
        color = Colors.blue;
        break;
    }
    String text;
    switch (_status) {
      case AttendanceStatus.absent:
        text = "A";

        break;
      case AttendanceStatus.present:
        text = "P";
        break;
      case AttendanceStatus.halfDay:
        text = "H";
        break;
    }

    return GestureDetector(
      onTap: _toggleStatus,
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black54),
          color: color,
        ),
        child: Center(
            child: Text(
          text,
          style: Theme.of(context).textTheme.bodySmall,
        )),
      ),
    );
  }
}
