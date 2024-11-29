import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:math' as math;
import 'package:provider/provider.dart';
import 'package:votesecure/src/core/utils/WidgetLibrary.dart';
import 'package:votesecure/src/data/models/CandidateListBasedOnElctionDateModel.dart';
import 'package:votesecure/src/data/models/ElectionsUsersHavePaticipated_Model.dart';
import 'package:votesecure/src/domain/repositories/CandidateRepository.dart';
import 'package:votesecure/src/domain/repositories/VoterRepository.dart';
import 'package:votesecure/src/presentation/pages/shared/LoadingPage.dart';
import 'package:votesecure/src/presentation/widgets/TitleAppBar.dart';
import 'package:votesecure/src/presentation/widgets/searchBar.dart';
import 'package:votesecure/src/presentation/pages/common/Introduction/CandidateIntroductionPage.dart';

class BallotForm extends StatefulWidget {
  static const routeName = 'ballot-form';
  final String ngayBD;
  final String ID_object;
  final ElectionUserHavePaticipanted_Model electionDetails;

  const BallotForm({
    super.key,
    required this.ngayBD,
    required this.electionDetails,
    required this.ID_object
  });

  @override
  _BallotFormState createState() => _BallotFormState(ngayBD: ngayBD,electionDetails: electionDetails,ID_object: ID_object);
}

class _BallotFormState extends State<BallotForm> {
  //Thuộc tính
  final String ngayBD;
  final String ID_object;
  final ElectionUserHavePaticipanted_Model electionDetails;
  WidgetlibraryState widgetLibraryState = WidgetlibraryState();
  final CandidateRepository  candidateRepository = CandidateRepository();
  final VoterRepository  voterRepository = VoterRepository();
  final TextEditingController _searchController = TextEditingController();
  late Future<List<CandidateListBasedonElEctionDateModel>> _danhsachungcuvienFuture;
  List<CandidateListBasedonElEctionDateModel> _fillDanhSachUngCuVienList = [];
  List<CandidateListBasedonElEctionDateModel> _danhSachUngCuVienList = [];
  int DemSoLuotBinhChon = 0;
  late List<int> ThongTinPhieuBau;
  _BallotFormState({
    required this.ngayBD,
    required this.electionDetails,
    required this.ID_object
  });

  //Khởi tạo
  @override
  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(_fillterElections);
  }

  //Hủy
  @override
  void dispose() {
    _searchController.dispose();
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
        ThongTinPhieuBau = List.generate(_fillDanhSachUngCuVienList.length, (_) => 0);
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppTitle(textTitle: 'Phiếu bầu'),
        body: Stack(
          children: [
            widgetLibraryState.buildPageBackgroundGradient2Color(context, '0xffd7d5d5','0xffe1e2df'),
            _buildBodyBallotForm(context),
          ],
        )
      ),
    );
  }

  Widget _buildBodyBallotForm(BuildContext context){
    return Padding(
      padding: EdgeInsets.fromLTRB(5, 15, 5, 20),
      child: Column(children: [
        Search_Bar(searchController: _searchController),
        const SizedBox(height: 12,),
        Expanded(
            child: ShowList()
        ),
        _buildVoteSubmitButton(context),
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
                          leading: Checkbox(
                            value: _fillDanhSachUngCuVienList[index].IsSelected,
                            onChanged: (bool? value) {
                              //Nếu người dùng bỏ chọn ô đã chọn trước đó
                              if (value == false) {
                                setState(() {
                                  _fillDanhSachUngCuVienList[index].IsSelected = value!;
                                  DemSoLuotBinhChon--;
                                  ThongTinPhieuBau[index] = 0;
                                });
                              } else {
                                //Kiểm tra điều kiện khi người dùng chọn thêm
                                if (DemSoLuotBinhChon < electionDetails.soLuotBinhChonToiDa) {
                                  setState(() {
                                    _fillDanhSachUngCuVienList[index].IsSelected = value!;
                                    DemSoLuotBinhChon++;
                                    ThongTinPhieuBau[index] = 1;
                                  });
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Chỉ có thể chọn tối đa ${electionDetails.soLuotBinhChonToiDa} lần.'),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      behavior: SnackBarBehavior.floating,
                                      margin: const EdgeInsets.only(
                                          bottom: 60.0, left: 16.0, right: 16.0),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0,
                                        vertical: 12.0,
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                            activeColor: Colors.white,
                            checkColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2.0),
                            ),
                            side: MaterialStateBorderSide.resolveWith(
                                  (states) => BorderSide(width: 2.0, color: Colors.white),
                            ),
                          ),
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

  //Nút gửi
  Widget _buildVoteSubmitButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: _BuildRegulatoryInformation(context),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.blueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () async {
                  // Kiểm tra xem có ít nhất một ứng cử viên được chọn không
                  if (!_fillDanhSachUngCuVienList.any((task) => task.IsSelected)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Vui lòng chọn ít nhất một ứng cử viên.'),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        behavior: SnackBarBehavior.floating,
                        margin: const EdgeInsets.only(bottom: 60.0, left: 16.0, right: 16.0),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 12.0,
                        ),
                      ),
                    );
                    return;
                  }

                  // Hiển thị dialog xác nhận
                  bool? confirmResult = await showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Xác nhận gửi phiếu bầu'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Bạn có chắc chắn muốn gửi phiếu bầu với:'),
                            SizedBox(height: 8),
                            Text('- ${DemSoLuotBinhChon} lượt bình chọn',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('- ${_fillDanhSachUngCuVienList.where((task) => task.IsSelected).length} ứng cử viên được chọn',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 8),
                            Text('Lưu ý: Hành động này không thể hoàn tác sau khi xác nhận.',
                                style: TextStyle(color: Colors.red, fontSize: 12)),
                          ],
                        ),
                        actions: [
                          TextButton(
                            child: Text('Chỉnh sửa'),
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                          ),
                          ElevatedButton(
                            child: Text('Xác nhận'),
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      );
                    },
                  );

                  // Nếu người dùng xác nhận, tiến hành gửi phiếu bầu
                  if (confirmResult == true) {
                    //Hiển thị thông tin trước khi tính giá trị phiếu bầu
                    print('--------- Thông tin trước khi tính giá trị phiếu bầu --------');
                    print('Số lượt bình chọn tối đa (S): ${electionDetails.soLuotBinhChonToiDa}');
                    print('Số lượng cử tri (N): ${electionDetails.soLuongToiDaCuTri}');
                    print('Số lượng ứng viên (K): ${electionDetails.soLuongToiDaUngCuVien}');
                    print('Số lượng bình chọn hiện tại đã chọn: ${DemSoLuotBinhChon}');
                    print('Thông tin phiếu bầu: ${ThongTinPhieuBau}');

                    int b = electionDetails.soLuongToiDaCuTri + 1; //Cơ số b-phân
                    print('Cơ số b phân: ${b}');
                    BigInt GiaTriPhieu = BigInt.zero;
                    for (int i = 0; i < ThongTinPhieuBau.length; i++) {
                      GiaTriPhieu += BigInt.from(ThongTinPhieuBau[i]) * BigInt.from(math.pow(b, i));
                    }
                    // print('Giá trị phiếu: ${GiaTriPhieu}');
                    // print('ID_cutri: ${ID_object}');
                    // print('iD_cap: ${electionDetails.iD_Cap}');
                    // print('iD_DonViBauCu: ${electionDetails.iD_Cap}');
                    // print('ngayBD: ${electionDetails.ngayBD}');
                    print('-----------------------------------------');

                    try {
                      bool guiPhieu = await voterRepository.VoterVote(context, electionDetails, ID_object, GiaTriPhieu);
                      if(guiPhieu){
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Gửi phiếu bầu thành công!'),
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            behavior: SnackBarBehavior.floating,
                            margin: const EdgeInsets.only(bottom: 60.0, left: 16.0, right: 16.0),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 12.0,
                            ),
                          ),
                        );
                      }else{
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Có lỗi xảy ra khi gửi phiếu bầu. Vui lòng thử lại.'),
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            behavior: SnackBarBehavior.floating,
                            margin: const EdgeInsets.only(bottom: 60.0, left: 16.0, right: 16.0),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 12.0,
                            ),
                          ),
                        );
                      }

                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Có lỗi xảy ra khi gửi phiếu bầu. Vui lòng thử lại.'),
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          behavior: SnackBarBehavior.floating,
                          margin: const EdgeInsets.only(bottom: 60.0, left: 16.0, right: 16.0),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 12.0,
                          ),
                        ),
                      );
                    }
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Gửi',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.send, color: Colors.white),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //Thông tin quy định
  Widget _BuildRegulatoryInformation(BuildContext cotext){
    return Column(children: [
      RichText(
        text: TextSpan(
          style: TextStyle(color: Colors.black),
          children: [
            TextSpan(
                text: 'Số lượt bình chọn tối đa: ',
                style: TextStyle(
                    fontSize: 12, fontWeight: FontWeight.bold)),
            TextSpan(
                text: '${electionDetails.soLuotBinhChonToiDa}',
                style: TextStyle(
                  fontSize: 12,
                )),
          ],
        ),
      ),
      RichText(
        text: TextSpan(
          style: TextStyle(color: Colors.black),
          children: [
            TextSpan(
                text: 'Số lượng ứng viên: ',
                style: TextStyle(
                    fontSize: 12, fontWeight: FontWeight.bold)),
            TextSpan(
                text: '${electionDetails.soLuongToiDaUngCuVien}',
                style: TextStyle(
                  fontSize: 12,
                )),
          ],
        ),
      ),
    ],);
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
