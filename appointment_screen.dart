import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class AppointmentScreen extends StatefulWidget {
  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  int _currentStage = 0;
  final List<String> _stages = ['Hospital Selection', 'Doctor & Date', 'Time Slot'];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _selectedState;
  String? _selectedDistrict;
  String? _selectedHospital;
  String? _selectedDepartment;
  String? _selectedDoctor;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: _currentStage > 0
            ? IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _currentStage--;
                  });
                },
              )
            : null,
        title: Text('Appointment'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildStageIndicator(),
            Expanded(
              child: _buildCurrentStage(),
            ),
            _buildNextButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildStageIndicator() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          _stages.length,
          (index) => _buildStageItem(index),
        ),
      ),
    );
  }

  Widget _buildStageItem(int index) {
    bool isActive = index <= _currentStage;
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive ? Colors.purple : Colors.grey[300],
              ),
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: 20,
              ),
            ),
            if (index < _stages.length - 1)
              Positioned(
                right: -35,
                child: Container(
                  width: 70,
                  height: 2,
                  color: isActive ? Colors.purple : Colors.grey[300],
                ),
              ),
          ],
        ),
        SizedBox(height: 4),
        Text(
          _stages[index],
          style: TextStyle(
            color: isActive ? Colors.purple : Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentStage() {
    switch (_currentStage) {
      case 0:
        return _buildHospitalSelection();
      case 1:
        return _buildDoctorAndDateSelection();
      case 2:
        return _buildTimeSlotSelection();
      default:
        return Container();
    }
  }

  Widget _buildHospitalSelection() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDropdownField(
            label: 'Select State',
            value: _selectedState,
            items: ['Tamil Nadu', 'Kerala', 'Karnataka'],
            onChanged: (value) {
              setState(() {
                _selectedState = value;
              });
            },
          ),
          SizedBox(height: 20),
          _buildDropdownField(
            label: 'Select District',
            value: _selectedDistrict,
            items: ['Chennai', 'Coimbatore', 'Madurai'],
            onChanged: (value) {
              setState(() {
                _selectedDistrict = value;
              });
            },
          ),
          SizedBox(height: 20),
          _buildDropdownField(
            label: 'Select Hospital',
            value: _selectedHospital,
            items: ['Apollo Hospital', 'Fortis Hospital', 'Max Hospital'],
            onChanged: (value) {
              setState(() {
                _selectedHospital = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorAndDateSelection() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDropdownField(
            label: 'Select Department',
            value: _selectedDepartment,
            items: ['Cardiology', 'Neurology', 'Orthopedics'],
            onChanged: (value) {
              setState(() {
                _selectedDepartment = value;
              });
            },
          ),
          SizedBox(height: 20),
          _buildDropdownField(
            label: 'Select Doctor',
            value: _selectedDoctor,
            items: ['Dr. Smith', 'Dr. Johnson', 'Dr. Williams'],
            onChanged: (value) {
              setState(() {
                _selectedDoctor = value;
              });
            },
          ),
          SizedBox(height: 20),
          _buildDatePicker(
            label: 'Select Date',
            selectedDate: _selectedDate,
            onDateSelected: (date) {
              setState(() {
                _selectedDate = date;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSlotSelection() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTimePicker(
            label: 'Select Time Slot',
            selectedTime: _selectedTime,
            onTimeSelected: (time) {
              setState(() {
                _selectedTime = time;
              });
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            child: Text('Book Appointment'),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Handle booking logic
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextButton() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: ElevatedButton(
        child: Text('Next'),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            if (_currentStage < _stages.length - 1) {
              setState(() {
                _currentStage++;
              });
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.purple,
          minimumSize: Size(double.infinity, 50),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.grey[100],
          ),
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: onChanged,
          validator: (value) => value == null ? 'Please select $label' : null,
        ),
      ],
    );
  }

  Widget _buildDatePicker({
    required String label,
    DateTime? selectedDate,
    required ValueChanged<DateTime> onDateSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        InkWell(
          onTap: () {
            DatePicker.showDatePicker(
              context,
              showTitleActions: true,
              minTime: DateTime.now(),
              maxTime: DateTime(2025, 12, 31),
              onConfirm: onDateSelected,
              currentTime: selectedDate ?? DateTime.now(),
              locale: LocaleType.en,
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
              color: Colors.grey[100],
            ),
            child: Text(
              selectedDate == null
                  ? 'Choose Date'
                  : DateFormat.yMMMMd().format(selectedDate),
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimePicker({
    required String label,
    TimeOfDay? selectedTime,
    required ValueChanged<TimeOfDay> onTimeSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        InkWell(
          onTap: () async {
            TimeOfDay? time = await showTimePicker(
              context: context,
              initialTime: selectedTime ?? TimeOfDay.now(),
            );
            if (time != null) {
              onTimeSelected(time);
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
              color: Colors.grey[100],
            ),
            child: Text(
              selectedTime == null
                  ? 'Choose Time Slot'
                  : selectedTime.format(context),
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ),
        ),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AppointmentScreen(),
  ));
}
