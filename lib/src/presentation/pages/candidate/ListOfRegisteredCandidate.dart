import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:votesecure/src/core/utils/WidgetLibrary.dart';
import 'package:votesecure/src/data/models/ElectionsUsersHavePaticipated_Model.dart';
import 'package:votesecure/src/domain/repositories/CandidateRepository.dart';
import 'package:votesecure/src/presentation/pages/candidate/ListOfCandaitesBasedOnElecionDatePage.dart';
import 'package:votesecure/src/presentation/widgets/TitleAppBar.dart';
import 'package:votesecure/src/presentation/widgets/searchBar.dart';
import 'package:votesecure/src/presentation/pages/shared/LoadingPage.dart';

class ListofRegisteredCandidateScreen extends StatefulWidget {
  static const routeName = 'get-list-registered-candidate';
  final String ID_ucv;
  const ListofRegisteredCandidateScreen({super.key, required this.ID_ucv});

  @override
  State<ListofRegisteredCandidateScreen> createState() =>
      _ListofRegisteredCandidateScreenState(ID_ucv: ID_ucv);
}

class _ListofRegisteredCandidateScreenState
    extends State<ListofRegisteredCandidateScreen> {
  final String ID_ucv;
  final CandidateRepository candidateRepository = CandidateRepository();
  final TextEditingController _searchController = TextEditingController();
  late Future<List<ElectionUserHavePaticipanted_Model>> _danhsachbaucuFuture;
  List<ElectionUserHavePaticipanted_Model> _fillDanhSachBauCuList = [];
  List<ElectionUserHavePaticipanted_Model> _danhSachBauCuList = [];
  WidgetlibraryState widgetLibraryState = WidgetlibraryState();

  // Định nghĩa các màu sắc cho trạng thái
  final gradientVoted = [Color(0xFF4CAF50), Color(0xFF388E3C)]; // Màu xanh lá - đã bỏ phiếu
  final gradientNotVoted = [Color(0xFF2196F3), Color(0xFF1976D2)]; // Màu xanh dương - chưa bỏ phiếu
  final gradientExpired = [Color(0xFF9E9E9E), Color(0xFF757575)]; // Màu xám - hết hạn

  _ListofRegisteredCandidateScreenState({required this.ID_ucv});

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

  Future<void> _loadData() async {
    final controller = Provider.of<CandidateRepository>(context, listen: false);
    _danhsachbaucuFuture = controller.GetListOfRegisteredCandidate(context, ID_ucv);
    _danhsachbaucuFuture.then((kybaucu) {
      setState(() {
        _danhSachBauCuList = kybaucu;
        _fillDanhSachBauCuList = kybaucu;
      });
    });
  }

  void _fillterElections() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _fillDanhSachBauCuList = _danhSachBauCuList
          .where((kybaucu) {
        return kybaucu.tenKyBauCu!.toLowerCase().contains(query);
      })
          .toList();
    });
  }

  void _showVotedAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 10),
              Text('Đã bỏ phiếu'),
            ],
          ),
          content: Text('Bạn đã hoàn thành bỏ phiếu cho kỳ bầu cử này'),
          actions: [
            TextButton(
              child: Text('Đóng'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppTitle(textTitle: 'Danh sách kỳ bầu cử đã đăng ký'),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFF8F9FA), Color(0xFFE9ECEF)],
            ),
          ),
          child: _buildBodyListElections(context),
        ),
      ),
    );
  }

  Widget _buildBodyListElections(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 20, 16, 20),
      child: Column(
        children: [
          Search_Bar(searchController: _searchController),
          SizedBox(height: 20),
          // Thêm legend để giải thích ý nghĩa màu sắc
          _buildColorLegend(),
          SizedBox(height: 20),
          Expanded(child: ShowList()),
        ],
      ),
    );
  }

  Widget _buildColorLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem('Đã bỏ phiếu', gradientVoted[0]),
        SizedBox(width: 20),
        _buildLegendItem('Chưa bỏ phiếu', gradientNotVoted[0]),
        SizedBox(width: 20),
        _buildLegendItem('Hết hạn', gradientExpired[0]),
      ],
    );
  }

  Widget _buildLegendItem(String text, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(width: 8),
        Text(text, style: TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildElectionCard(ElectionUserHavePaticipanted_Model election) {
    final bool hasVoted = election.ghiNhan == "1";
    final bool isExpired = DateTime.now().isAfter(
      DateTime.parse(election.ngayBD ?? DateTime.now().toString()),
    );

    // Chọn gradient màu dựa trên trạng thái
    final gradient = hasVoted
        ? gradientVoted
        : isExpired
        ? gradientExpired
        : gradientNotVoted;

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: () {
          if (hasVoted) {
            _showVotedAlert();
          } else if (!isExpired) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ListOfCandidatesBasedOnElectionDateScreen(
                  ID_object: ID_ucv,
                  ngayBD: election.ngayBD ?? '',
                  electionDetails: election,
                  CandidateVote: true,
                ),
              ),
            );
          }
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      hasVoted ? Icons.how_to_vote :
                      isExpired ? Icons.timer_off : Icons.how_to_vote,
                      color: gradient[0],
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          election.tenKyBauCu ?? 'Chưa có tên',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          election.tenDonViBauCu ?? 'Chưa có đơn vị',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ngày bắt đầu',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        widgetLibraryState.DateTimeFormat(election.ngayBD ?? 'N/A'),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      hasVoted ? 'Đã bỏ phiếu' :
                      isExpired ? 'Hết hạn' : 'Chưa bỏ phiếu',
                      style: TextStyle(
                        color: gradient[0],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  FutureBuilder<List<ElectionUserHavePaticipanted_Model>> ShowList() {
    return FutureBuilder<List<ElectionUserHavePaticipanted_Model>>(
      future: _danhsachbaucuFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingPage();
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return ListView.builder(
            itemCount: _fillDanhSachBauCuList.length,
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.only(bottom: 20),
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: _buildElectionCard(_fillDanhSachBauCuList[index]),
              );
            },
          );
        }
      },
    );
  }
}