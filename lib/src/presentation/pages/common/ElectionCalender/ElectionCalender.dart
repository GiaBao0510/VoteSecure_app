import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';  // Sử dụng package này để hiển thị lịch
import 'package:votesecure/src/core/utils/WidgetLibrary.dart';
import 'package:votesecure/src/data/models/ElectionModel.dart';
import 'package:votesecure/src/domain/repositories/UserRepository.dart';
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
  Map<DateTime, List<ElectionModel>> _events = {};
  final UserRepository userRepository = UserRepository();

  @override
  void initState() {
    super.initState();
    _fetchAndSetEvents();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _fetchAndSetEvents() async {
    List<ElectionModel> elections = await userRepository.getListOfFuture_Elections(context);
    _addEvents(elections);
  }

  //Thêm sự kiện vào lịch
  void _addEvents(List<ElectionModel> elections){
    _events.clear();

    for(var election in elections){
      //Định dạng lại ngày tháng năm
      DateTime ngayBD = DateTime(election.ngayBD.year, election.ngayBD.month, election.ngayBD.day);
      DateTime ngayKT = DateTime(election.ngayKT.year, election.ngayKT.month, election.ngayKT.day);
      print("Parsed ngayBD: ${election.ngayBD}, ngayKT: ${election.ngayKT}");

      // Add ngayBD to the events map
      if (_events[ngayBD] == null) {
        _events[ngayBD] = [];
      }
      _events[ngayBD]!.add(election);

      // Add ngayKT to the events map if it's different from ngayBD
      if (!isSameDay(ngayBD, ngayKT)) {
        if (_events[ngayKT] == null) {
          _events[ngayKT] = [];
        }
        _events[ngayKT]!.add(election);
      }
      setState(() {});
    }
  }

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      _selectedDay = day;
    });

    //Lấy danh sách ngày được chọn
    List<ElectionModel>? events = _events[day];
    if (events != null && events.isNotEmpty) {
      _showBottomSheet(context, day, events);
    } else {
      _showBottomSheet(context, day, []);
    }
  }

  // Cập nhật ngày hiện tại dựa trên tháng được chọn
  void _onMonthSelected(int month) {
    setState(() {
      _selectedDay = DateTime(_selectedDay.year, month, _selectedDay.day);
    });
  }

  //Hiển thị thông tin cụ thể về ngày
  void _showBottomSheet(BuildContext context, DateTime day, List<ElectionModel> events) {
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
              ...events.map((election) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tên kỳ bầu cử: ${election.tenKyBauCu ?? 'null'}'),
                  Text('Mô tả: ${election.mota ?? 'null'}'),
                  SizedBox(height: 10),
                ],
              )),
            ],
          ),
        );
      },
      isScrollControlled: true,
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
  Widget _buildElectionCalendar(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.utc(1990, 1, 1),
      lastDay: DateTime.utc(2100, 12, 31),
      focusedDay: _selectedDay,
      calendarFormat: _calendarFormat,
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      eventLoader: (day) {
        return _events[day] ?? [];
      },
      onDaySelected: _onDaySelected,
      onFormatChanged: (format) {
        setState(() {
          _calendarFormat = format;
        });
      },
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, date, events) {
          // Check if the current date is ngayBD or ngayKT
          bool isNgayBD = _events[date]?.any((e) => isSameDay(date, e.ngayBD)) ?? false;
          bool isNgayKT = _events[date]?.any((e) => isSameDay(date, e.ngayKT)) ?? false;

          // Show markers based on the conditions
          if (isNgayBD && isNgayKT) {
            return Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.purple, // Use a combined color if both dates match
              ),
              width: 16,
              height: 16,
            );
          } else if (isNgayBD) {
            return Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue, // Blue for start date
              ),
              width: 16,
              height: 16,
            );
          } else if (isNgayKT) {
            return Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.yellow, // Yellow for end date
              ),
              width: 16,
              height: 16,
            );
          }
          return null; // No marker
        },
      ),
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
