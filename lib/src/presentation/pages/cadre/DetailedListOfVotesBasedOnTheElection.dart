import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:votesecure/src/core/utils/WidgetLibrary.dart';
import 'package:votesecure/src/data/models/BallotDetailModel.dart';
import 'package:votesecure/src/data/models/CadreJoinedForElectionModel.dart';
import 'package:votesecure/src/domain/repositories/CadreRepository.dart';
import 'package:votesecure/src/presentation/pages/shared/LoadingPage.dart';
import 'package:votesecure/src/presentation/widgets/TitleAppBar.dart';
import 'package:votesecure/src/presentation/widgets/searchBar.dart';

class DetailedListOfVotesBasedOnTheElection extends StatefulWidget {
  static const routeName = 'detailed-list-of-votes-based-on-the-election';
  final String ngayBD;
  final String ID_CanBo;
  final CadreJoinedForElectionModel cadreJoinedForElectionModel;
  const DetailedListOfVotesBasedOnTheElection({
    super.key, 
    required this.ngayBD,
    required this.ID_CanBo,
    required this.cadreJoinedForElectionModel
  });

  @override
  State<DetailedListOfVotesBasedOnTheElection> createState() => _DetailedListOfVotesBasedOnTheElectionState(ngayBD: ngayBD, ID_CanBo: ID_CanBo,cadreJoinedForElectionModel: cadreJoinedForElectionModel);
}

// Thêm enum để quản lý trạng thái hiển thị
enum VoteDisplayMode {
  encoded,
  decoded
}

class _DetailedListOfVotesBasedOnTheElectionState extends State<DetailedListOfVotesBasedOnTheElection> {
  final String ngayBD, ID_CanBo;
  final CadreJoinedForElectionModel cadreJoinedForElectionModel;
  final CadreRepository cadreRepository = CadreRepository();
  final TextEditingController _searchController = TextEditingController();
  // Khởi tạo Future ngay khi khai báo
  late Future<List<BallotDetailModel>> _danhsachbaucuFuture;
  List<BallotDetailModel> _fillDanhSachBauCuList = [];
  List<BallotDetailModel> _danhSachBauCuList = [];
  WidgetlibraryState widgetLibraryState = WidgetlibraryState();
  Color TextColorInItem = Colors.white;
  Color BgColorInItem = Colors.indigo;
  List<Color> BackGroundColorInItem = [Color(0xff1e3c72), Color(0xff2a5298)];
  final DraggableScrollableController _dragController = DraggableScrollableController();
  VoteDisplayMode _displayMode = VoteDisplayMode.encoded;
  //CupertinoIcons IconValueVote = CupertinoIcons.p;

  _DetailedListOfVotesBasedOnTheElectionState({
    required this.ngayBD,
    required this.ID_CanBo,
    required this.cadreJoinedForElectionModel
  });

  @override
  void initState() {
    super.initState();
    // Khởi tạo Future trong initState
    _danhsachbaucuFuture = _loadInitialData();
    _loadData();
    _searchController.addListener(_fillterElections);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Thêm phương thức mới để load dữ liệu ban đầu
  Future<List<BallotDetailModel>> _loadInitialData() async {
    final controller = Provider.of<CadreRepository>(context, listen: false);
    return _displayMode == VoteDisplayMode.decoded
        ? controller.GetListOfDecodedVotesBasedOnElectionDate(context, ngayBD)
        : controller.GetDetailsAboutVotesBasedOnElectionDate(context, ngayBD);
  }

  //Hàm lấy dữ liệu
  Future<void> _loadData() async {
    try {
      setState(() {
        _danhsachbaucuFuture = _loadInitialData();
      });

      final ballots = await _danhsachbaucuFuture;

      setState(() {
        _danhSachBauCuList = ballots;
        _fillDanhSachBauCuList = ballots;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Có lỗi xảy ra khi tải dữ liệu: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  //Bộ lọc
  void _fillterElections(){
    final query = _searchController.text.toLowerCase();
    setState(() {
      _fillDanhSachBauCuList = _danhSachBauCuList.where((kybaucu){
        return kybaucu.iD_Phieu!.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppTitle(textTitle: 'Danh sách các phiếu bầu'),
          body: Stack(children: [
            widgetLibraryState.buildPageBackgroundGradient2Color(context, '0xffd7d5d5','0xffe1e2df'),
            _buildBodyListVotes(context),
            _buildDraggableSheet(),
            _buildFloatingButton(),
          ],),
        )
    );
  }

  //Hiển thị danh sách các kỳ bầu cử đã đăng ký tham dự
  Widget _buildBodyListVotes(BuildContext context){
    return Padding(
      padding: EdgeInsets.fromLTRB(12, 15, 12, 20),
      child: Column(children: [
        Search_Bar(searchController: _searchController),
        const SizedBox(height: 12,),
        Expanded(
            child: ShowList()
        ),
        const SizedBox(height: 35,),
      ],),
    );
  }

  //Show danh sách
  FutureBuilder<List<BallotDetailModel>> ShowList(){
    return FutureBuilder<List<BallotDetailModel>>
      (
        future: _danhsachbaucuFuture,
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return LoadingPage();
          }else if(snapshot.hasError){
            return Center(child: Text('Error: ${snapshot.error}'));
          }else if (!snapshot.hasData) {
            return Center(child: Text('Không có dữ liệu'));
          } else{
            return ListView.builder(
                itemCount: _fillDanhSachBauCuList.length,
                physics: AlwaysScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index){

                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      gradient:LinearGradient(
                        colors: BackGroundColorInItem,
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
                                CupertinoIcons.ticket_fill,
                                size: 55,
                                color: TextColorInItem,  ),
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
                                        const TextSpan(text: 'Mã phiếu: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                                        TextSpan(text: '${_fillDanhSachBauCuList[index].iD_Phieu}')
                                      ],
                                        style: TextStyle(color: TextColorInItem,),),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  const SizedBox(height: 10,),
                                  FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Container(
                                      child: RichText(
                                        text: TextSpan(children: [
                                          const WidgetSpan(child: Icon(CupertinoIcons.info_circle, color: Colors.white,)),
                                          const TextSpan(text: ' Mã cử tri: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                                          TextSpan(text: '${_fillDanhSachBauCuList[index].iD_user}')
                                        ],
                                          style: TextStyle(color: TextColorInItem,),),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8,),
                        RichText(
                            text: TextSpan(children: [
                              const TextSpan(text: 'Họ tên cử tri: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                              TextSpan(text: '${_fillDanhSachBauCuList[index].hoTen ?? 'null' }')
                            ], style: TextStyle(color: TextColorInItem))
                        ),
                        const SizedBox(height: 8,),
                        RichText(
                            text: TextSpan(children: [
                              const TextSpan(text: 'Thời đỉêm bỏ phiếu: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                              TextSpan(text: '${widgetLibraryState.DateTimeFormat(_fillDanhSachBauCuList[index].thoiDiem ?? 'null')}')
                            ], style: TextStyle(color: TextColorInItem))
                        ),
                        const SizedBox(height: 8,),
                        RichText(
                            text: TextSpan(children: [
                              const TextSpan(text: 'Giá trị phiếu bầu: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                              TextSpan(text: '${_fillDanhSachBauCuList[index].giaTriPhieuBau ?? 0}')
                            ], style: TextStyle(color: TextColorInItem))
                        ),

                      ],),
                    ),
                  );
                }
            );
          }
        }
    );
  }

  //Xây dựng thanh kéo
  Widget _buildDraggableSheet() {
    return DraggableScrollableSheet(
      controller: _dragController,
      initialChildSize: 0.1,
      minChildSize: 0.1,
      maxChildSize: 0.9,
      snap: true,
      snapSizes: [0.1, 0.9],
      builder: (context, scrollController) {
        return GestureDetector(
          onVerticalDragEnd: (details) {
            // Xử lý khi người dùng vút xuống
            if (details.primaryVelocity! > 0) { // Vút xuống
              _dragController.animateTo(
                0.1,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: Offset(0, -3),
                ),
              ],
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              physics: ClampingScrollPhysics(), // Thêm physics để kiểm soát scroll behavior
              child: Column(
                children: [
                  // Phần header có thể bấm được
                  GestureDetector(
                    onTap: () {
                      // Kiểm tra vị trí hiện tại để quyết định hướng di chuyển
                      if (_dragController.size < 0.5) {
                        _dragController.animateTo(
                          0.9,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        _dragController.animateTo(
                          0.1,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.fromLTRB(0, 5, 5, 0),
                      width: double.infinity,
                      child: Column(
                        children: [
                          // Thanh kéo
                          Container(
                            width: 40,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.grey[600],
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),

                          const SizedBox(height: 4,),
                          // Tiêu đề
                          Row(
                            children: [
                              Expanded(
                                flex:1,
                                child: Text('Tổng quan',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                flex:1,
                                child: _buildResultNotificationButton(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Nội dung
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: _buildTheContentOfTheOverview()
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  //Xây dựng nút giải mã - mã hóa
  Widget _buildFloatingButton() {
    return Positioned(
      left: 20,
      bottom: 100,
      child: FloatingActionButton.extended(
        onPressed: () => _toggleDisplayMode(),
        backgroundColor: Colors.white,

        label: Column(
          children: [
            Icon(
              _displayMode == VoteDisplayMode.decoded
                  ?CupertinoIcons.lock_open_fill
                  : CupertinoIcons.lock_fill ,
              color: Colors.indigo,
            ),
            FittedBox(
              fit: BoxFit.fitWidth,
                child: Text('${_displayMode.name == 'encoded'? 'Mã hóa':'Giải mã'}', style: TextStyle(color: Colors.indigo),)
            )
          ],
        ),
        tooltip: _displayMode == VoteDisplayMode.decoded
            ? 'Hiển thị phiếu bầu mã hóa'
            : 'Hiển thị phiếu bầu giải mã',
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }

  // Hàm mới để xử lý việc chuyển đổi chế độ hiển thị
  Future<void> _toggleDisplayMode() async {

    if(_fillDanhSachBauCuList.length > 0){
      setState(() {
        _displayMode = _displayMode == VoteDisplayMode.decoded
            ? VoteDisplayMode.encoded
            : VoteDisplayMode.decoded;

        // Clear danh sách hiện tại
        _fillDanhSachBauCuList.clear();
        _danhSachBauCuList.clear();
      });

      try {
        await _loadData();

        // Hiển thị thông báo thành công
        _showDisplayModeChangeMessage();
      } catch (e) {
        // Xử lý lỗi
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Không thể chuyển đổi chế độ hiển thị: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }else{
      QuickAlert.show(
          context: context,
          type: QuickAlertType.warning,
          title: "Không thể mã hóa",
          text: 'Vì số lượng phiếu bầu bằng 0.'
      );
    }

  }

  // Hàm mới để hiển thị thông báo
  void _showDisplayModeChangeMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            _displayMode == VoteDisplayMode.decoded
                ? 'Đang hiển thị phiếu bầu đã giải mã'
                : 'Đang hiển thị phiếu bầu đã mã hóa'
        ),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        action: SnackBarAction(
          label: 'Đóng',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  //Nội dung thanh kéo
  Widget _buildTheContentOfTheOverview(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(children: [
              const TextSpan(text: 'Kỳ bầu cử: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13)),
              TextSpan(text: '${cadreJoinedForElectionModel.tenKyBauCu }')
            ], style: TextStyle(color: BgColorInItem)),
            textAlign: TextAlign.left,
          ),
        ),
        const SizedBox(height: 5),
        Align(
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(children: [
              const TextSpan(text: 'Mô tả: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13)),
              TextSpan(text: '${cadreJoinedForElectionModel.moTa }')
            ], style: TextStyle(color: BgColorInItem)),
            textAlign: TextAlign.left,
          ),
        ),
        const SizedBox(height: 5),
        Align(
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(children: [
              WidgetSpan(
                child: Icon(Icons.date_range, size: 20),
              ),
              const TextSpan(text: 'Thời điểm bắt đầu: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13)),
              TextSpan(text: '${widgetLibraryState.DateTimeFormat(cadreJoinedForElectionModel.ngayBD ?? '') }')
            ], style: TextStyle(color: BgColorInItem)),
            textAlign: TextAlign.left,
          ),
        ),
        const SizedBox(height: 5),
        Align(
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(children: [
              WidgetSpan(
                child: Icon(Icons.date_range, size: 20),
              ),
              const TextSpan(text: 'Thời điểm kết thúc: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13)),
              TextSpan(text: '${widgetLibraryState.DateTimeFormat(cadreJoinedForElectionModel.ngayKT ?? '') }')
            ], style: TextStyle(color: BgColorInItem)),
            textAlign: TextAlign.left,
          ),
        ),
        const SizedBox(height: 5),
        Align(
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(children: [
              const TextSpan(text: 'Công bố kết quả: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13)),
              TextSpan(text: '${cadreJoinedForElectionModel.CongBo == '1'? 'Đã công bố':'Chưa công bố' }')
            ], style: TextStyle(color: BgColorInItem)),
            textAlign: TextAlign.left,
          ),
        ),
        const SizedBox(height: 5),
        Align(
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(children: [
              const TextSpan(text: 'Đơn vị bầu cử: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13)),
              TextSpan(text: '${cadreJoinedForElectionModel.tenDonViBauCu }')
            ], style: TextStyle(color: BgColorInItem)),
            textAlign: TextAlign.left,
          ),
        ),
        const SizedBox(height: 5),
        Align(
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(children: [
              const TextSpan(text: 'Cấp ứng cử: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13)),
              TextSpan(text: '${cadreJoinedForElectionModel.tenCapUngCu}')
            ], style: TextStyle(color: BgColorInItem)),
            textAlign: TextAlign.left,
          ),
        ),
        const SizedBox(height: 5),
        Align(
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(children: [
              const TextSpan(text: 'Số lượng cử tri tối đa: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13)),
              TextSpan(text: '${cadreJoinedForElectionModel.SoLuongToiDaCuTri }')
            ], style: TextStyle(color: BgColorInItem)),
            textAlign: TextAlign.left,
          ),
        ),
        const SizedBox(height: 5),
        Align(
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(children: [
              const TextSpan(text: 'Số lượng ứng cử viên tối đa: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13)),
              TextSpan(text: '${cadreJoinedForElectionModel.SoLuongToiDaUngCuVien }')
            ], style: TextStyle(color: BgColorInItem)),
            textAlign: TextAlign.left,
          ),
        ),
        const SizedBox(height: 5),
        Align(
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(children: [
              const TextSpan(text: 'Số lượt bình chọn tối đa: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13)),
              TextSpan(text: '${cadreJoinedForElectionModel.SoLuotBinhChonToiDa }')
            ], style: TextStyle(color: BgColorInItem)),
            textAlign: TextAlign.left,
          ),
        ),
        const SizedBox(height: 5),
        Align(
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(children: [
              const TextSpan(text: 'Số phiếu bầu hiện có: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13)),
              TextSpan(text: '${_fillDanhSachBauCuList.length }')
            ], style: TextStyle(color: BgColorInItem)),
            textAlign: TextAlign.left,
          ),
        ),
      ],
    );
  }

  //Xây dựng nút công bố
  Widget _buildResultNotificationButton(){
    return ElevatedButton(
        onPressed: () async{
          if(_fillDanhSachBauCuList.length < 1){
            QuickAlert.show(
                context: context,
                type: QuickAlertType.warning,
                title: "Không thể công bố kết quả",
                text: 'Vì số lượng phiếu bầu chua có nên không thể công bố kết quả'
            );
          }else{
            await cadreRepository.AnnounceElectionResults(context, ngayBD, ID_CanBo);
          }
        }, 
        child: Container(
          child: RichText(
              text: const TextSpan(children: [
                WidgetSpan(child: Icon(CupertinoIcons.rectangle_3_offgrid_fill)),
                 TextSpan(
                    text: ' Công bố kết quả ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,fontSize: 15,
                    ),
                ),
              ],),
            textAlign: TextAlign.center,
          ),
        ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.amber[800],
        foregroundColor: Colors.white
      ),
    );
  }
}