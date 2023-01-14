import 'package:flutter/material.dart';

// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

void main() {
  return runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  String _selectedDate = '';
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        _range = '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} -'
            // ignore: lines_longer_than_80_chars
            ' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
      } else if (args.value is DateTime) {
        _selectedDate = args.value.toString();
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
        _selectedDate= "";
        for (var i = 0; i < args.value.length; i++) {
          _selectedDate = "$_selectedDate${DateFormat('yyyy-MM-dd').format(args.value[i])}, ";
        }
        _selectedDate = _selectedDate.substring(0, _selectedDate.lastIndexOf(", "));
      } else {
        _rangeCount = args.value.length.toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('DatePicker demo'),
        ),
        body: Stack(
          children: <Widget>[
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              height: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Selected date: $_selectedDate'),
                  Text('Selected date count: $_dateCount'),
                  Text('Selected range: $_range'),
                  Text('Selected ranges count: $_rangeCount'),
                ],
              ),
            ),
            DatePicker(onSelectionChanged: _onSelectionChanged, disabledDate: const ["2023-01-26", "2023-01-27"]),
          ],
        ),
      ),
    );
  }
}

class DatePicker extends StatelessWidget {
  void Function(DateRangePickerSelectionChangedArgs args) onSelectionChanged;
  List<String> disabledDate;

  DatePicker({
    Key? key,
    required this.onSelectionChanged,
    required this.disabledDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      top: 80,
      right: 0,
      bottom: 0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.05),
          borderRadius: const BorderRadius.all(
            Radius.circular(40.0),
          ),
        ),
        margin: const EdgeInsets.all(16),
        child: SfDateRangePicker(
          toggleDaySelection: true,
          enableMultiView: true,
          navigationDirection: DateRangePickerNavigationDirection.vertical,
          viewSpacing: 20,
          headerStyle: const DateRangePickerHeaderStyle(
            backgroundColor: Colors.blue,
            textAlign: TextAlign.center,
            textStyle: TextStyle(
              color: Colors.white,
            ),
          ),
          view: DateRangePickerView.month,
          monthViewSettings: DateRangePickerMonthViewSettings(
            weekendDays: [7, 6],
            specialDates: [
              DateTime(2023, 01, 14),
            ],
            showTrailingAndLeadingDates: true,
          ),
          monthCellStyle: DateRangePickerMonthCellStyle(
            specialDatesDecoration: BoxDecoration(
              // color: Colors.blue,
              border: Border.all(color: Colors.blue, width: 1),
              shape: BoxShape.circle,
            ),
            weekendDatesDecoration: BoxDecoration(
              color: Colors.red.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            todayCellDecoration: BoxDecoration(
              color: Colors.red.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            specialDatesTextStyle: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
          enablePastDates: false,
          onSelectionChanged: onSelectionChanged,
          selectionMode: DateRangePickerSelectionMode.multiple,
          selectableDayPredicate: (DateTime date) {
            // return DateFormat('hh:mm:ss').format(dateTime);
            if (disabledDate.contains(DateFormat('yyyy-MM-dd').format(date))) {
              return false;
            }
            if (date.weekday == DateTime.saturday || date.weekday == DateTime.sunday) {
              return false;
            }
            return true;
          },
        ),
      ),
    );
  }
}
