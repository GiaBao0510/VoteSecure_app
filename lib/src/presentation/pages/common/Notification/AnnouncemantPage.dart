import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:votesecure/src/core/utils/WidgetLibrary.dart';
import 'package:votesecure/src/data/models/DetailNoticeModel.dart';
import 'package:votesecure/src/domain/repositories/DetailNoticeRepository.dart';
import 'package:votesecure/src/presentation/pages/shared/LoadingPage.dart';
import 'package:votesecure/src/presentation/pages/shared/login.dart';
import 'package:votesecure/src/presentation/widgets/TitleAppBar.dart';

class AnnouncementScreen extends StatefulWidget {
  static const routeName = 'announcement-page';
  final String ID_object;
  const AnnouncementScreen({super.key, required this.ID_object});

  @override
  State<AnnouncementScreen> createState() => _AnnouncementScreenState(ID_object: ID_object);
}

class _AnnouncementScreenState extends State<AnnouncementScreen> {
  final String ID_object;
  final DetailNoticeRepository detailNoticeRepository = DetailNoticeRepository();
  WidgetlibraryState widgetLibraryState = WidgetlibraryState();

  late Future<List<DetailNoticeModel>> _LisOFutureObjects = Future.value([]);
  List<DetailNoticeModel> _ListOfObject = [];

  _AnnouncementScreenState({required this.ID_object});

  //Khởi tạo
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  //Hủy
  @override
  void dispose() {
    super.dispose();
  }

  //Hàm lấy dữ liệu
  Future<void> _loadData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String Role = pref.getString('UserRole') ?? 'null';

    setState(() {
      switch (Role) {
        case "2": //ứng cử viên
          _LisOFutureObjects = detailNoticeRepository.GetCandidateNotificationList(context, ID_object);
          break;
        case "5": //Cử tri
          _LisOFutureObjects = detailNoticeRepository.GetVoterNotificationList(context, ID_object);
          break;
        case "8": //Cán bộ
          _LisOFutureObjects = detailNoticeRepository.GetCadreNotificationList(context, ID_object);
          break;
        default:
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const loginPages()));
          break;
      }
    });

    _LisOFutureObjects.then((thongbao) {
      if (mounted) {
        setState(() {
          _ListOfObject = thongbao;
        });
      }
    });
  }

  //Hiển thị
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Stack(children: [
            widgetLibraryState.buildPageBackgroundGradient2Color(context, '0xffd7d5d5','0xffe1e2df'),
            _buildBodyAnnouncements(context)
          ],),
        )
    );
  }

  //Hiển thị danh sách các thông báo
  Widget _buildBodyAnnouncements(BuildContext context){
    return Padding(
      padding: EdgeInsets.fromLTRB(12, 15, 12, 20),
      child: Column(children: [
        const SizedBox(height: 12,),
        Expanded(
            child: ShowList()
        ),
      ],),
    );
  }

  // Show danh sách
  FutureBuilder<List<DetailNoticeModel>> ShowList() {
    return FutureBuilder<List<DetailNoticeModel>>(
      future: _LisOFutureObjects,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingPage();
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return ListView.builder(
            itemCount: _ListOfObject.length,
            physics: AlwaysScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.bell_circle_fill,
                        size: 40,
                        color: Color(0xff2f80ed),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Thời điểm: ${widgetLibraryState.DateTimeFormat(_ListOfObject[index].thoiDiem ?? '')}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Nội dung: ${_ListOfObject[index].noiDungThongBao}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
