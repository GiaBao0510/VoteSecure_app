import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:votesecure/src/core/utils/WidgetLibrary.dart';
import 'package:votesecure/src/data/models/CandidateListBasedOnElctionDateModel.dart';
import 'package:votesecure/src/domain/repositories/CandidateRepository.dart';
import 'package:votesecure/src/presentation/pages/shared/LoadingPage.dart';
import 'package:votesecure/src/presentation/widgets/TitleAppBar.dart';
import 'package:votesecure/src/presentation/widgets/searchBar.dart';
import 'package:votesecure/src/presentation/pages/common/Introduction/CandidateIntroductionPage.dart';

class ListOfCandidatesBasedOnElectionDateScreen extends StatefulWidget {
  static const routeName = 'list-of-candidate-based-on-election';
  final String ngayBD;
  const ListOfCandidatesBasedOnElectionDateScreen({
    super.key,
    required this.ngayBD
  });

  @override
  State<ListOfCandidatesBasedOnElectionDateScreen> createState() => _ListOfCandidatesBasedOnElectionDateScreenState(ngayBD: ngayBD);
}

class _ListOfCandidatesBasedOnElectionDateScreenState extends State<ListOfCandidatesBasedOnElectionDateScreen> {
  final CandidateRepository candidateRepository = CandidateRepository();
  final TextEditingController _searchController = TextEditingController();
  late Future<List<CandidateListBasedonElEctionDateModel>> _danhsachungcuvienFuture;
  WidgetlibraryState widgetLibraryState = WidgetlibraryState();
  List<CandidateListBasedonElEctionDateModel> _fillDanhSachUngCuVienList = [];
  List<CandidateListBasedonElEctionDateModel> _danhSachUngCuVienList = [];
  final String ngayBD;

  _ListOfCandidatesBasedOnElectionDateScreenState({
    required this.ngayBD
  });

  //hàm khởi tạo
  @override
  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(_fillterElections);
  }

  //hàm hủy
  @override
  void dispose() {
    super.dispose();
  }

  //Load danh sách bầu củ
  Future<void> _loadData() async{
    final controller = Provider.of<CandidateRepository>(context, listen: false);
    _danhsachungcuvienFuture = controller.GetCandidateListBasedOnElectionDate(context,ngayBD);
    _danhsachungcuvienFuture.then((ungcuviens) {
      setState(() {
        _danhSachUngCuVienList = ungcuviens;
        _fillDanhSachUngCuVienList = ungcuviens;
      });
    });
  }

  // Bộ lọc tìm kiếm
  void _fillterElections(){
    final query = _searchController.text.toLowerCase();
    setState(() {
      _fillDanhSachUngCuVienList = _danhSachUngCuVienList.where((ungcuvien){
        return ungcuvien.HoTen!.toLowerCase().contains(query);
      }).toList();
    });
  }

  //Hàm hiển thi chính
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppTitle(textTitle: 'Danh sách các ứng cử viên tại kỳ này'),
          body: Stack(
            children: [
              widgetLibraryState.buildPageBackgroundGradient2Color(context, '0xffd7d5d5','0xffe1e2df'),
              _buildCandidateListBasedOnElectionDay(context),
            ],
          )
      ),
    );
  }

  Widget _buildCandidateListBasedOnElectionDay(BuildContext context){
    return Padding(
      padding: EdgeInsets.fromLTRB(5, 15, 5, 20),
      child: Column(children: [
        Search_Bar(searchController: _searchController),
        const SizedBox(height: 12,),
        Expanded(
            child: ShowList()
        ),
      ],),
    );
  }

  FutureBuilder<List<CandidateListBasedonElEctionDateModel>> ShowList(){
    return FutureBuilder(
        future: _danhsachungcuvienFuture,
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return LoadingPage();
          }else if(snapshot.hasError){
            return Center(child: Text('Error: ${snapshot.error}'));
          }else{
            return ListView.builder(
              itemCount: _fillDanhSachUngCuVienList.length,
              physics: AlwaysScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index){
                return Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: const LinearGradient(
                          colors: [Color(0xff1e3c72), Color(0xff2a5298)],
                          stops: [0, 1],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 5,
                            offset: Offset(4, 8), // Shadow position
                          ),
                        ],
                      ),
                      margin: EdgeInsets.fromLTRB(8, 15, 8, 0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: EdgeInsets.zero, // Để nút không có thêm khoảng cách
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CandidateInfoPage(candidateInfo:_fillDanhSachUngCuVienList[index] ,)),
                          );
                        },
                        child: ListTile(
                          subtitle: Row(
                            children: [
                              Flexible(
                                child: Column(
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        style: TextStyle(color: Colors.white),
                                        children: [
                                          TextSpan(
                                              text: 'Họ Tên ',
                                              style: TextStyle(
                                                  fontSize: 13, fontWeight: FontWeight.bold)),
                                          TextSpan(
                                              text:
                                              '${_fillDanhSachUngCuVienList[index].HoTen}',
                                              style: TextStyle(
                                                fontSize: 11,
                                              )),
                                        ],
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        style: TextStyle(color: Colors.white),
                                        children: [
                                          TextSpan(
                                              text: 'Giới tính: ',
                                              style: TextStyle(
                                                  fontSize: 13, fontWeight: FontWeight.bold)),
                                          TextSpan(
                                              text:
                                              '${_fillDanhSachUngCuVienList[index].GioiTinh == '1' ? 'Nam' : 'Nữ'}',
                                              style: TextStyle(
                                                fontSize: 11,
                                              )),
                                        ],
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        style: TextStyle(color: Colors.white),
                                        children: [
                                          TextSpan(
                                              text: 'Trình độ: ',
                                              style: TextStyle(
                                                  fontSize: 13, fontWeight: FontWeight.bold)),
                                          TextSpan(
                                              text:
                                              '${_fillDanhSachUngCuVienList[index].tenTrinhDoHocVan}',
                                              style: TextStyle(
                                                fontSize: 11,
                                              )),
                                        ],
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        style: TextStyle(color: Colors.white),
                                        children: [
                                          TextSpan(
                                              text: 'Số lượt bình chọn: ',
                                              style: TextStyle(
                                                  fontSize: 13, fontWeight: FontWeight.bold)),
                                          TextSpan(
                                              text:
                                              '${_fillDanhSachUngCuVienList[index].soLuotBinhChon}',
                                              style: TextStyle(
                                                fontSize: 11,
                                              )),
                                        ],
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        style: TextStyle(color: Colors.white),
                                        children: [
                                          TextSpan(
                                              text: 'Tỷ lệ bình chọn: ',
                                              style: TextStyle(
                                                  fontSize: 13, fontWeight: FontWeight.bold)),
                                          TextSpan(
                                              text:
                                              '${_fillDanhSachUngCuVienList[index].tyLeBinhChon}',
                                              style: TextStyle(
                                                fontSize: 11,
                                              )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Flexible(
                                child: Container(
                                  width: 210,
                                  height: 210,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2.0,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: CircleAvatar(
                                      radius: 100,
                                      backgroundImage: NetworkImage(
                                        '${_fillDanhSachUngCuVienList[index].HinhAnh}',
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    _BuildSerialNumbering(context, index),
                    _BuildDetailedIconSection(context),
                  ],
                );
              },
            );
          }
        }
    );
  }

  //Phần đánh số thứ tự ứng cử viên
  Widget _BuildSerialNumbering(BuildContext cotext, int index){
    return Positioned(
      top: 8, // Khoảng cách từ trên cùng của Container đến số index
      left: 8, // Khoảng cách từ trái của Container đến số index
      child: Container(
        padding: EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8), // Màu nền của số index
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Text(
          '${index }', // Hiển thị số index, thêm 1 để bắt đầu từ 1 thay vì 0
          style: TextStyle(
            color: Colors.black, // Màu chữ của số index
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  //Phần icon
  Widget _BuildDetailedIconSection(BuildContext context){
    return Positioned(
      bottom: 8, // Khoảng cách từ trên cùng của Container đến số index
      right: 8, // Khoảng cách từ trái của Container đến số index
      child: Container(
          padding: EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.0), // Màu nền của số index
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Icon(
            Icons.info_outline,
            color: Colors.white,
          )
      ),
    );
  }
}