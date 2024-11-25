import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:votesecure/src/core/utils/WidgetLibrary.dart';
import 'package:votesecure/src/data/models/VotingHistoryModel.dart';
import 'package:votesecure/src/domain/repositories/VoterRepository.dart';
import 'package:votesecure/src/presentation/pages/shared/LoadingPage.dart';
import 'package:votesecure/src/presentation/widgets/TitleAppBar.dart';
import 'package:votesecure/src/presentation/widgets/searchBar.dart';

class ListOfVotingHistory extends StatefulWidget {
  static const routeName = 'List-Of-Voting-History';
  final String ID_object;
  const ListOfVotingHistory({super.key, required this.ID_object});

  @override
  State<ListOfVotingHistory> createState() => _ListOfVotingHistoryState(ID_object: ID_object);
}

class _ListOfVotingHistoryState extends State<ListOfVotingHistory> {
  //Thuộc tính
  final String ID_object;
  WidgetlibraryState widgetLibraryState = WidgetlibraryState();
  final VoterRepository  voterRepository = VoterRepository();
  final TextEditingController _searchController = TextEditingController();
  late Future<List<VotingHistoryModel>> _danhsachbaucuFuture;
  List<VotingHistoryModel> _fillDanhSachBauCuList = [];
  List<VotingHistoryModel> _danhSachBauCuList = [];
  _ListOfVotingHistoryState({required this.ID_object});

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

  //Load danh sách bầu củ
  Future<void> _loadData() async{
    final controller = Provider.of<VoterRepository>(context, listen: false);
    _danhsachbaucuFuture = controller.GetListOfVotingHistory(context, ID_object);
    _danhsachbaucuFuture.then((kybaucu) {
      setState(() {
        _danhSachBauCuList = kybaucu;
        _fillDanhSachBauCuList = kybaucu;
      });
    });
  }

  //Search
  void _fillterElections(){
    final query = _searchController.text.toLowerCase();
    setState(() {
      _fillDanhSachBauCuList = _danhSachBauCuList.where((DoiTuong){
        return DoiTuong.tenCapUngCu!.toLowerCase().contains(query);
      }).toList();
    });
  }

  //Hiển thị
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppTitle(textTitle: 'Danh sách lích sử bỏ phiếu'),
          body: Stack(children: [
            widgetLibraryState.buildPageBackgroundGradient2Color(context, '0xffd7d5d5','0xffe1e2df'),
            _buildBodyListOfVotingHistory(context)
          ],),
        )
    );
  }

  Widget _buildBodyListOfVotingHistory(BuildContext context){
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
  FutureBuilder<List<VotingHistoryModel>> ShowList() {
    return FutureBuilder<List<VotingHistoryModel>>(
      future: _danhsachbaucuFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 60, color: Colors.red),
                SizedBox(height: 16),
                Text(
                  'Đã có lỗi xảy ra',
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
                  style: TextStyle(fontSize: 16, color: Colors.grey),
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

            return Card(
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: ListTile(
                contentPadding: EdgeInsets.all(12),
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.shade100,
                  child: Icon(Icons.ballot_outlined, color: Colors.blue),
                ),
                title: Flexible(
                  child: Text(
                    election.tenCapUngCu ?? 'Không xác định',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 2,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(
                        'Mã phiếu: ${election.iD_Phieu ?? 'N/A'}',
                        style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 1,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(
                        'Ngày: ${widgetLibraryState.DateTimeFormat(election.ngayBD ?? '')}',
                        style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
