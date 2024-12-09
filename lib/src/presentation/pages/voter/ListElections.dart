import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:votesecure/src/core/utils/WidgetLibrary.dart';
import 'package:votesecure/src/data/models/ElectionsUsersHavePaticipated_Model.dart';
import 'package:votesecure/src/domain/repositories/VoterRepository.dart';
import 'package:votesecure/src/presentation/pages/shared/LoadingPage.dart';
import 'package:votesecure/src/presentation/pages/voter/GroupedElectionsList.dart';
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
  late Future<List<ElectionUserHavePaticipanted_Model>> _danhsachbaucuFuture;
  List<ElectionUserHavePaticipanted_Model> _fillDanhSachBauCuList = [];
  List<ElectionUserHavePaticipanted_Model> _danhSachBauCuList = [];

  _ListElectionsScreenState({required this.ID_object});

  //Khởi tạo
  @override
  void initState() {
    super.initState();
    initializeDateFormatting('vi_VN', null);
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
  FutureBuilder<List<ElectionUserHavePaticipanted_Model>> ShowList() {
    return FutureBuilder<List<ElectionUserHavePaticipanted_Model>>(
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

        return GroupedElectionsList(
          elections: _fillDanhSachBauCuList,
          ID_object: ID_object,
          voterRepository: voterRepository,
        );
      },
    );
  }
}