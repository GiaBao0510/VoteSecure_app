import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:table_calendar/table_calendar.dart';  // Sử dụng package này để hiển thị lịch
import 'package:google_fonts/google_fonts.dart';
import 'package:votesecure/src/core/utils/WidgetLibrary.dart';
import 'package:votesecure/src/presentation/pages/common/ElectionCalender/ElectionCalender.dart';
import 'package:votesecure/src/presentation/widgets/TitleAppBar.dart';

class ElectioncalenderScreen extends StatefulWidget {
  static const routeName = 'election-calender';
  const ElectioncalenderScreen({super.key});

  @override
  State<ElectioncalenderScreen> createState() => _ElectioncalenderScreenState();
}

class _ElectioncalenderScreenState extends State<ElectioncalenderScreen> {
  DateTime _selectedDay = DateTime.now(); // Ngày hiện tại
  CalendarFormat _calendarFormat = CalendarFormat.month; // Định dạng lịch
  WidgetlibraryState widgetLibraryState = WidgetlibraryState();

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      _selectedDay = day;
    });
    _showBottomSheet(context, day);
  }

  // Cập nhật ngày hiện tại dựa trên tháng được chọn
  void _onMonthSelected(int month) {
    setState(() {
      _selectedDay = DateTime(_selectedDay.year, month, _selectedDay.day);
    });
  }

  //Hiển thị thông tin cụ thể về ngày
  void _showBottomSheet(BuildContext context, DateTime day) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 250,
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Details for ${day.day}/${day.month}/${day.year}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text('Class: Math'),
              Text('Time: 8:00 AM - 10:00 AM'),
              Text('Room: 302'),
              // Bạn có thể tùy chỉnh thêm thông tin chi tiết tại đây
            ],
          ),
        );
      },
      isScrollControlled: true, // Cho phép kéo bảng lên cao hơn
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTitle(textTitle: 'Lịch bầu cử'),
      body: Stack(
        children: [
          widgetLibraryState.buildPageBackgroundGradient2Color(context, '0xffece9e6', '0xffffffff'),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _BuildTitleDisplayDateTime(context),
                  SizedBox(height: 20),
                  _buildElectionCalendar(context),
                  SizedBox(height: 30,),
                  _buildMonthSelector(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Xay dựng phần Bố Trí tiêu đè
  Widget _BuildTitleDisplayDateTime(BuildContext context){
    return Text(
      '${_selectedDay.day}/${_selectedDay.month}/${_selectedDay.year}.',
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w800,
        color: Colors.blue,
      ),
    );
  }

  //Xây dựng phần hiển thị lịch
  Widget _buildElectionCalendar(BuildContext context){
    return TableCalendar(
      firstDay: DateTime.utc(1990, 1, 1),
      lastDay: DateTime.utc(2100, 12, 31),
      focusedDay: _selectedDay,
      calendarFormat: _calendarFormat,
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: _onDaySelected,
      onFormatChanged: (format) {
        setState(() {
          _calendarFormat = format;
        });
      },
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
    );
  }

  // Tạo danh sách các tháng (1-12) để hiển thị
  Widget _buildMonthSelector(BuildContext context) {
    return Container(
      height: 60, // Chiều cao của thanh chọn tháng
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // Cuộn ngang
        itemCount: 12, // Có 12 tháng trong năm
        itemBuilder: (context, index) {
          int month = index + 1;
          return GestureDetector(
            onTap: () {
              _onMonthSelected(month); // Cập nhật tháng khi người dùng chọn
            },
            child: Container(
              width: 50,
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                color: _selectedDay.month == month ? Colors.blue : Colors.grey[300], // Đổi màu khi tháng được chọn
                borderRadius: BorderRadius.circular(80),
              ),
              child: Text(
                '$month',
                style: TextStyle(
                  color: _selectedDay.month == month ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
