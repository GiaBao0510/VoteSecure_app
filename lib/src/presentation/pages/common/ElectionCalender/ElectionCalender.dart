import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
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
  // Khai báo biến với giá trị mặc định thay vì dùng late
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  final WidgetlibraryState widgetLibraryState = WidgetlibraryState();
  final List<ElectionModel> _danhSachCacCuocBauCuTuongLaiList = [];
  late Future<List<ElectionModel>> _danhSachCacCuocBauCuTuongLaiFuture;
  final Map<DateTime, List<ElectionModel>> _events = {};
  final UserRepository userRepository = UserRepository();

  @override
  void initState() {
    super.initState();
    _fetchAndSetEvents();
  }

  // Sửa lại hàm _getEventsForDay để xử lý chính xác các sự kiện cùng ngày
  List<ElectionModel> _getEventsForDay(DateTime day) {
    // Chuẩn hóa ngày bằng cách loại bỏ thông tin về giờ, phút, giây
    final normalizedDay = DateTime(day.year, day.month, day.day);

    // Tìm tất cả các sự kiện trong ngày này
    List<ElectionModel> dayEvents = [];
    _events.forEach((key, events) {
      // Chuẩn hóa key date để so sánh
      final keyDate = DateTime(key.year, key.month, key.day);
      if (keyDate.isAtSameMomentAs(normalizedDay)) {
        dayEvents.addAll(events);
      }
    });

    // Sắp xếp các sự kiện theo thời gian
    dayEvents.sort((a, b) => a.ngayBD.compareTo(b.ngayBD));
    return dayEvents;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _fetchAndSetEvents() async {
    try {
      final controller = Provider.of<UserRepository>(context, listen: false);
      _danhSachCacCuocBauCuTuongLaiFuture = controller.getListOfFuture_Elections(context);

      final kybaucu = await _danhSachCacCuocBauCuTuongLaiFuture;

      if (mounted) {
        setState(() {
          _danhSachCacCuocBauCuTuongLaiList.clear();
          _danhSachCacCuocBauCuTuongLaiList.addAll(kybaucu);

          // Cập nhật events
          for (var election in _danhSachCacCuocBauCuTuongLaiList) {
            final startDate = DateTime(
              election.ngayBD.year,
              election.ngayBD.month,
              election.ngayBD.day,
              election.ngayBD.hour,
              election.ngayBD.minute,
              election.ngayBD.second,
            );
            print(startDate);

            _events[startDate] = [...(_events[startDate] ?? []), election];

            // Sắp xếp các sự kiện trong cùng một ngày
            _events[startDate]!.sort((a, b) => a.ngayBD.compareTo(b.ngayBD));
          }
        });
      }
    } catch (e) {
      print('Lỗi khi tải dữ liệu: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTitle(textTitle: 'Lịch bầu cử'),
      body: Stack(
        children: [
          widgetLibraryState.buildPageBackgroundGradient2Color(
              context,
              '0xffece9e6',
              '0xffffffff'
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
            child: Column(
              children: [
                _buildingA_ScheduleFrame(context),
                Expanded(
                    child: _InformationAboutTheDayEvents(context)
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildingA_ScheduleFrame(BuildContext context) {
    return TableCalendar<ElectionModel>(
      firstDay: DateTime.utc(2000, 1, 1),
      lastDay: DateTime.utc(2040, 12, 31),
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      calendarFormat: _calendarFormat,
      eventLoader: _getEventsForDay,
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      onFormatChanged: (format) {
        setState(() {
          _calendarFormat = format;
        });
      },
      calendarStyle: CalendarStyle(
        markersMaxCount: 5,
        markerDecoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
        ),
        tableBorder: TableBorder.all(
            color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(5)
        ),
        
      ),
      headerStyle: HeaderStyle(
        titleCentered: true,
        formatButtonDecoration:  BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22.0),
        ),
        formatButtonTextStyle: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold),
        formatButtonShowsNext: false,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff0052d4), Color(0xff4364f7), Color(0xff6fb1fc)],
            stops: [0, 0.5, 1],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
            borderRadius: BorderRadius.circular(5),
        ),
        titleTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),

      ),
      // Thêm những thuộc tính này để hiển thị marker tốt hơn
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, date, events) {
          if (events.isEmpty) return null;
          return Positioned(
            bottom: 1,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              width: 6.0,
              height: 6.0,
              child: Center(
                child: Text(
                  '${events.length}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 4.0,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _InformationAboutTheDayEvents(BuildContext context) {
    final events = _getEventsForDay(_selectedDay);

    if (events.isEmpty) {
      return SingleChildScrollView(
        child: Column(
          children: [
            FractionallySizedBox(
              child: Lottie.asset(
                  'assets/animations/NoEvent.json',
                  repeat: true,
                  fit: BoxFit.contain,
                  height: 200,
                  width: double.infinity
              ),
            ),
            SizedBox(height: 10,),
            const Center(
              child: Text('Không có sự kiện nào trong ngày này'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 4.0,
          ),
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: ListTile(
            title: Text(event.tenKyBauCu ?? 'Chưa có tên'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bắt đầu: ${DateFormat('HH:mm').format(event.ngayBD)}',
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  'Kết thúc: ${DateFormat('dd/MM/yyyy').format(event.ngayKT)}',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}