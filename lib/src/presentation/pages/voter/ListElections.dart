import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:votesecure/src/core/utils/WidgetLibrary.dart';
import 'package:votesecure/src/data/models/ElectionsVotersHavePaticipated_Model.dart';
import 'package:votesecure/src/domain/repositories/VoterRepository.dart';
import 'package:votesecure/src/presentation/pages/shared/LoadingPage.dart';
import 'package:votesecure/src/presentation/widgets/TitleAppBar.dart';
import 'package:votesecure/src/presentation/widgets/searchBar.dart';
import 'package:votesecure/src/presentation/pages/voter/BallotForm.dart';

class ListElectionsScreen extends StatefulWidget {
  static const routeName = 'list-election-for-voter-screen';
  final String ID_object;
  const ListElectionsScreen({super.key, required this.ID_object});

  @override
  State<ListElectionsScreen> createState() => _ListElectionsScreenState(ID_object: ID_object);
}

class _ListElectionsScreenState extends State<ListElectionsScreen> {
  //Thuộc tính
  final String ID_object;
  WidgetlibraryState widgetLibraryState = WidgetlibraryState();
  final VoterRepository  voterRepository = VoterRepository();
  final TextEditingController _searchController = TextEditingController();
  late Future<List<ElectionVoterHavePaticipanted_Model>> _danhsachbaucuFuture;
  List<ElectionVoterHavePaticipanted_Model> _fillDanhSachBauCuList = [];
  List<ElectionVoterHavePaticipanted_Model> _danhSachBauCuList = [];

  _ListElectionsScreenState({required this.ID_object});

  //Khởi tạo
  @override
  void initState() {
    super.initState();
    _loadElectionVoterHavePaticipated();
    _searchController.addListener(_fillterElections);
  }

  //Hủy
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  //Load danh sách bầu củ
  Future<void> _loadElectionVoterHavePaticipated() async{
    final controller = Provider.of<VoterRepository>(context, listen: false);
    _danhsachbaucuFuture = controller.ElectionsInWhichVoterAreAlloweddToParticipate(context);
    _danhsachbaucuFuture.then((kybaucu) {
      setState(() {
        _danhSachBauCuList = kybaucu;
        _fillDanhSachBauCuList = kybaucu;
      });
    });
  }

  // Bộ lọc tìm kiếm
  void _fillterElections(){
    final query = _searchController.text.toLowerCase();
    setState(() {
      _fillDanhSachBauCuList = _danhSachBauCuList.where((kybaucu){
        return kybaucu.tenKyBauCu!.toLowerCase().contains(query);
      }).toList();
    });
  }

  //Display
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppTitle(textTitle: 'Danh sách kỳ bầu cử'),
          body: Stack(children: [
            widgetLibraryState.buildPageBackgroundGradient2Color(context, '0xffd7d5d5','0xffe1e2df'),
            _buildBodyListElections(context)
          ],),
        )
    );
  }

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

  //Hiển thị danh sách các kỳ bầu c có thể tham gia
  FutureBuilder<List<ElectionVoterHavePaticipanted_Model>> ShowList() {
    return FutureBuilder<List<ElectionVoterHavePaticipanted_Model>>(
      future: _danhsachbaucuFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingPage();
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 60, color: Colors.red),
                SizedBox(height: 16),
                Text(
                  'Đã có lỗi xảy ra\n${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
        } else if (_fillDanhSachBauCuList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.ballot_outlined, size: 60, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Chưa có kỳ bầu cử nào',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: _fillDanhSachBauCuList.length,
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(vertical: 8),
          itemBuilder: (BuildContext context, int index) {
            final election = _fillDanhSachBauCuList[index];
            final hasVoted = election.ghiNhan != '0';

            // Màu chữ tùy theo trạng thái
            final textColor = hasVoted ? Colors.white : Colors.black87;
            // Màu icon tùy theo trạng thái
            final iconColor = hasVoted ? Colors.white : Colors.black87;
            // Màu nền trong suốt tùy theo trạng thái
            final containerColor = hasVoted
                ? Colors.white.withOpacity(0.2)
                : Colors.black.withOpacity(0.1);

            return Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  if (!hasVoted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BallotForm(
                          ngayBD: election.ngayBD,
                          electionDetails: election,
                          ID_object: ID_object,
                        ),
                      ),
                    );
                  } else {
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.warning,
                      title: "Đã bỏ phiếu",
                      text: "Bạn đã bỏ phiếu ở kỳ này rồi",
                    );
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: hasVoted
                          ? [Color(0xFF1E88E5), Color(0xFF1565C0)]  // Màu xanh cho đã bỏ phiếu
                          : [Color(0xFFFFC107), Color(0xFFFFB300)], // Điều chỉnh màu cam nhẹ hơn
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: containerColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                hasVoted ? Icons.how_to_vote : Icons.ballot_outlined,
                                color: iconColor,
                                size: 28,
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    election.tenKyBauCu ?? '',
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    election.tenDonViBauCu ?? '',
                                    style: TextStyle(
                                      color: textColor.withOpacity(0.9),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: containerColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: iconColor,
                                size: 16,
                              ),
                              SizedBox(width: 8),
                              Text(
                                widgetLibraryState.DateTimeFormat(election.ngayBD),
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 12),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: hasVoted
                                ? Colors.green.withOpacity(0.3)
                                : Colors.black.withOpacity(0.1),  // Màu nền đậm hơn cho status
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                hasVoted ? Icons.check_circle : Icons.pending,
                                color: iconColor,
                                size: 16,
                              ),
                              SizedBox(width: 8),
                              Text(
                                hasVoted ? 'Đã bỏ phiếu' : 'Chưa bỏ phiếu',
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,  // Làm đậm chữ status
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}