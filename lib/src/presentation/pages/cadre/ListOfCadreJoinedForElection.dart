import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:votesecure/src/core/utils/WidgetLibrary.dart';
import 'package:votesecure/src/data/models/CadreJoinedForElectionModel.dart';
import 'package:votesecure/src/data/models/ElectionsUsersHavePaticipated_Model.dart';
import 'package:votesecure/src/domain/repositories/CadreRepository.dart';
import 'package:votesecure/src/presentation/pages/cadre/DetailedListOfVotesBasedOnTheElection.dart';
import 'package:votesecure/src/presentation/pages/candidate/ListOfCandaitesBasedOnElecionDatePage.dart';
import 'package:votesecure/src/presentation/pages/shared/LoadingPage.dart';
import 'package:votesecure/src/presentation/widgets/TitleAppBar.dart';
import 'package:votesecure/src/presentation/widgets/searchBar.dart';

class ListOfCadreJoinedForElection extends StatefulWidget {
  static const routeName = 'List-Of-Cadre-Joined-For-Election';
  final String ID_CanBo;
  const ListOfCadreJoinedForElection({super.key, required this.ID_CanBo});

  @override
  State<ListOfCadreJoinedForElection> createState() => _ListOfCadreJoinedForElectionState(ID_CanBo: ID_CanBo);
}

class _ListOfCadreJoinedForElectionState extends State<ListOfCadreJoinedForElection> {
  final String ID_CanBo;
  final CadreRepository cadreRepository = CadreRepository();
  final TextEditingController _searchController = TextEditingController();
  late Future<List<CadreJoinedForElectionModel>> _danhsachbaucuFuture;
  List<CadreJoinedForElectionModel> _fillDanhSachBauCuList = [];
  List<CadreJoinedForElectionModel> _danhSachBauCuList = [];
  WidgetlibraryState widgetLibraryState = WidgetlibraryState();

  _ListOfCadreJoinedForElectionState({required this.ID_CanBo});

  @override
  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(_fillterElections);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  //Hàm lấy dữ liệu
  Future<void> _loadData() async{
    final controller = Provider.of<CadreRepository>(context, listen: false);
    _danhsachbaucuFuture = controller.GetListOfCadreJoinedForElection(context,ID_CanBo);
    _danhsachbaucuFuture.then((kybaucu) {
      setState(() {
        _danhSachBauCuList = kybaucu;
        _fillDanhSachBauCuList = kybaucu;
      });
    });
  }

  //Bộ lọc
  void _fillterElections(){
    final query = _searchController.text.toLowerCase();
    setState(() {
      _fillDanhSachBauCuList = _danhSachBauCuList.where((kybaucu){
        return kybaucu.tenCapUngCu!.toLowerCase().contains(query);
      }).toList();
    });
  }

  // Hàm lấy màu sắc dựa trên trạng thái công bố
  Map<String, dynamic> _getItemColors(String congBo) {
    if (congBo == "1") {
      return {
        'textColor': Colors.black87,
        'bgColor': Color(0xffe65c00),
        'gradientColors': [Color(0xffe65c00), Color(0xfff9d423)],
      };
    } else {
      return {
        'textColor': Colors.white,
        'bgColor': Colors.indigo,
        'gradientColors': [Color(0xff1e3c72), Color(0xff2a5298)],
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppTitle(textTitle: 'Danh sách kỳ bầu cử đang dự'),
          body: Stack(children: [
            widgetLibraryState.buildPageBackgroundGradient2Color(context, '0xffd7d5d5','0xffe1e2df'),
            _buildBodyListElections(context)
          ],),
        )
    );
  }

  //Hiển thị danh sách các kỳ bầu cử đã đăng ký tham dự
  Widget _buildBodyListElections(BuildContext context){
    return Padding(
      padding: EdgeInsets.fromLTRB(12, 15, 12, 20),
      child: Column(children: [
        Search_Bar(searchController: _searchController),
        const SizedBox(height: 12,),
        Expanded(
            child: ShowList()
        ),
      ],),
    );
  }

  //Show danh saách
  FutureBuilder<List<CadreJoinedForElectionModel>> ShowList(){
    return FutureBuilder<List<CadreJoinedForElectionModel>>
      (
        future: _danhsachbaucuFuture,
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return LoadingPage();
          }else if(snapshot.hasError){
            return Center(child: Text('Error: ${snapshot.error}'));
          }else{
            return ListView.builder(
                itemCount: _fillDanhSachBauCuList.length,
                physics: AlwaysScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index){

                  // Lấy màu sắc cho từng item riêng biệt
                  final itemColors = _getItemColors(_fillDanhSachBauCuList[index].CongBo ?? '0');
                  final textColor = itemColors['textColor'];
                  final bgColor = itemColors['bgColor'];
                  final gradientColors = itemColors['gradientColors'];

                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      gradient:LinearGradient(
                        colors: gradientColors,
                        stops: [0, 1],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.8), // Màu của bóng và độ trong suốt
                          spreadRadius: 5, // Bán kính mà bóng lan rộng
                          blurRadius: 7, // Độ mờ của bóng
                          offset: Offset(0, 3), // Độ dịch chuyển của bóng theo trục x và y
                        ),
                      ],
                    ),
                    child: ListTile(
                        title: Column(children: [
                          Row(
                            children: [
                              Flexible(
                                flex: 1,
                                child: Icon(
                                  Icons.people_alt_outlined,
                                  size: 55,
                                  color: textColor,  ),
                              ),
                              const SizedBox(width: 10,),
                              Flexible(
                                flex: 4,
                                child: Column(
                                  children: [
                                    FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: RichText(
                                        text: TextSpan(children: [
                                          const TextSpan(text: 'Tên kỳ bầu cử: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                                          TextSpan(text: '${_fillDanhSachBauCuList[index].tenKyBauCu}')
                                        ],
                                          style: TextStyle(color: textColor,),),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: RichText(
                                        text: TextSpan(children: [
                                          const TextSpan(text: 'Tên đơn vị: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                                          TextSpan(text: '${_fillDanhSachBauCuList[index].tenDonViBauCu}')
                                        ],
                                          style: TextStyle(color: textColor,),),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8,),
                          Row(children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  RichText(
                                      text: TextSpan(children: [
                                        const TextSpan(text: 'Tên cấp ứng củ: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                                        TextSpan(text: '${_fillDanhSachBauCuList[index].tenCapUngCu ?? 'null' }')
                                      ], style: TextStyle(color: textColor))
                                  ),
                                  RichText(
                                      text: TextSpan(children: [
                                        const TextSpan(text: 'Số lượng ứng cử viên: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                                        TextSpan(text: '${_fillDanhSachBauCuList[index].SoLuongToiDaUngCuVien}')
                                      ], style: TextStyle(color: textColor))
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10,),
                            Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  RichText(
                                      text: TextSpan(children: [
                                        const TextSpan(text: 'Ngày bắt đầu: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                                        TextSpan(text: '${widgetLibraryState.DateTimeFormat(_fillDanhSachBauCuList[index].ngayBD ?? 'null') }')
                                      ], style: TextStyle(color: textColor)),
                                    textAlign: TextAlign.left,
                                  ),
                                  RichText(
                                      text: TextSpan(children: [
                                        const TextSpan(text: 'Ngày kết thúc: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                                        TextSpan(text: '${widgetLibraryState.DateTimeFormat(_fillDanhSachBauCuList[index].ngayKT ?? 'null') }')
                                      ], style: TextStyle(color: textColor)),
                                    textAlign: TextAlign.left,
                                  ),
                                  RichText(
                                      text: TextSpan(children: [
                                        const TextSpan(text: 'Công bố kết quả: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                                        TextSpan(text: '${_fillDanhSachBauCuList[index].CongBo == "1"? 'Rồi':'Chưa ' }')
                                      ], style: TextStyle(color: textColor)),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                            ),
                          ],),

                            const SizedBox(height: 10,),
                          _buildNavigationButtonSection(context, index)

                        ],),
                      ),
                  );
                }
            );
          }
        }
    );
  }

  //Xây dựng phần nút chuyển trang
  Widget _buildNavigationButtonSection(BuildContext content, int index) {
    final itemColors = _getItemColors(_fillDanhSachBauCuList[index].CongBo ?? '0');
    final textColor = itemColors['textColor'];
    final bgColor = itemColors['bgColor'];
    final hasVoted = _fillDanhSachBauCuList[index].ghiNhan == "1";

    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(
                colors: hasVoted
                    ? [Colors.grey.shade400, Colors.grey.shade600]
                    : [Colors.green.shade400, Colors.green.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: hasVoted
                  ? () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Kỳ bầu cử này đã bỏ phiếu rồi',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: Colors.red.shade700,
                    duration: Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              }
                  : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListOfCandidatesBasedOnElectionDateScreen(
                      ngayBD: _fillDanhSachBauCuList[index].ngayBD ?? '',
                      ID_object: ID_CanBo,
                      electionDetails: ElectionUserHavePaticipanted_Model(
                        iD_DonViBauCu: _fillDanhSachBauCuList[index].iD_DonViBauCu,
                        iD_Cap: _fillDanhSachBauCuList[index].iD_Cap,
                        ngayBD: _fillDanhSachBauCuList[index].ngayBD,
                        tenDonViBauCu: _fillDanhSachBauCuList[index].tenDonViBauCu,
                        tenKyBauCu: _fillDanhSachBauCuList[index].tenKyBauCu,
                        soLuotBinhChonToiDa: _fillDanhSachBauCuList[index].SoLuotBinhChonToiDa,
                        soLuongToiDaUngCuVien: _fillDanhSachBauCuList[index].SoLuongToiDaUngCuVien,
                        soLuongToiDaCuTri: _fillDanhSachBauCuList[index].SoLuongToiDaCuTri,
                        ngayKT: _fillDanhSachBauCuList[index].ngayKT,
                        mota: 'null',
                        ghiNhan: 'null',
                      ),
                      CandidateVote: false,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: EdgeInsets.symmetric(horizontal: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      hasVoted ? Icons.check_circle : Icons.how_to_vote,
                      size: 18,
                      color: Colors.white,
                    ),
                    SizedBox(width: 4),
                    Text(
                      hasVoted ? 'Đã bỏ phiếu' : 'Bỏ phiếu',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          flex: 1,
          child: Container(
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(
                colors: [Colors.blue.shade400, Colors.blue.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailedListOfVotesBasedOnTheElection(
                      ngayBD: _fillDanhSachBauCuList[index].ngayBD ?? '',
                      ID_CanBo: ID_CanBo,
                      cadreJoinedForElectionModel: _fillDanhSachBauCuList[index],
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: EdgeInsets.symmetric(horizontal: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.list_alt,
                      size: 18,
                      color: Colors.white,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'DS phiếu',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

}