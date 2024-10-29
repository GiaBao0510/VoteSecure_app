import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:votesecure/src/config/AppConfig_api.dart';
import 'package:votesecure/src/core/utils/WidgetLibrary.dart';
import 'package:votesecure/src/data/models/ElectionResultsDetailsModel.dart';
import 'package:votesecure/src/domain/repositories/ElectionResultDetailRepository.dart';
import 'package:votesecure/src/presentation/pages/common/ElectionResult/ListOfCandidatesBasedOnElectionResults.dart';
import 'package:votesecure/src/presentation/pages/shared/LoadingPage.dart';
import 'package:votesecure/src/presentation/pages/shared/login.dart';
import 'package:votesecure/src/presentation/widgets/TitleAppBar.dart';
import 'package:votesecure/src/presentation/widgets/searchBar.dart';

class ElectionResultScreen extends StatefulWidget {
  static const routeName = 'election-results-details';
  final String ID_obj;
  const ElectionResultScreen({super.key, required this.ID_obj});

  @override
  State<ElectionResultScreen> createState() => _ElectionResultScreenState(ID_obj: ID_obj);
}

class _ElectionResultScreenState extends State<ElectionResultScreen> {
  final String ID_obj;
  final ElectionResultDetailRepository electionResultDetailRepository = ElectionResultDetailRepository();
  final TextEditingController _searchController = TextEditingController();
  // Initialize with a loading state
  Future<List<ElectionResultsDetailModel>>? _danhsachbaucuFuture;
  List<ElectionResultsDetailModel> _fillDanhSachBauCuList = [];
  List<ElectionResultsDetailModel> _danhSachBauCuList = [];
  WidgetlibraryState widgetLibraryState = WidgetlibraryState();

  _ElectionResultScreenState({required this.ID_obj});

  //Khởi tạo
  @override
  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(_fillterElections);
  }

  //hủy
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  //Load dữ liệu
  Future<void> _loadData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String Role = pref.getString('UserRole') ?? 'null';
    String uri = 'null';

    if (!mounted) return;

    switch (Role) {
      case "2":
        uri = getDetailedListOfElectionResultForCandidate;
        break;
      case "5":
        uri = getDetailedListOfElectionResultForVoter;
        break;
      case "8":
        uri = getDetailedListOfElectionResultForCandre;
        break;
      default:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const loginPages()));
        return;
    }

    setState(() {
      _danhsachbaucuFuture = electionResultDetailRepository.GetCandidateListBasedOnElectionDate(context, uri,ID_obj);
    });

    try {
      final kybaucu = await _danhsachbaucuFuture!;
      if (mounted) {
        setState(() {
          _danhSachBauCuList = kybaucu;
          _fillDanhSachBauCuList = kybaucu;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Có lỗi khi tải dữ liệu: $e')),
        );
      }
    }
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

  //Hiển thị
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppTitle(textTitle: 'Danh sách kết quả bầu cử được công bố'),
          body: Stack(children: [
            widgetLibraryState.buildPageBackgroundGradient2Color(context, '0xffd7d5d5','0xffe1e2df'),
            _buildBodyListElectionResult(context)
          ],),
        )
    );
  }

  //Hiển thị danh sách các kỳ bầu đã công bố kết qủa
  Widget _buildBodyListElectionResult(BuildContext context){
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
  Widget ShowList() {
    if (_danhsachbaucuFuture == null) {
      return LoadingPage();
    }
    return FutureBuilder<List<ElectionResultsDetailModel>>(
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
            itemBuilder: (BuildContext context, int index) {
              final item = _fillDanhSachBauCuList[index];
              return Card(
                elevation: 2,
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: InkWell(
                  onTap: () {
                    print('Chuyển đến trang chi tiết');
                    Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => ListOfCandidatesBasedOnElectionResultScreen(ngayBD: item.ngayBD ?? '',))
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                              children: [
                                WidgetSpan(child: Icon(
                                  CupertinoIcons.person_crop_square_fill,
                                  size: 30, color: Color.fromARGB( 255, 57, 55, 55)
                                )),
                                TextSpan(text: ' ${item.tenKyBauCu ?? 'Không có tên'}')
                              ],
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
                                  color: Color.fromARGB( 255, 57, 55, 55)),
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 8),
                        RichText(
                          text: TextSpan(
                              children: [
                                TextSpan(text: 'Đơn vị: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(text: '${item.tenDonViBauCu ?? 'Không có đơn vị'}')
                              ],
                              style: TextStyle(fontSize: 14, color: Colors.grey[600])
                          ),
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Vị trí:', style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                                  Text(item.tenCapUngCu ?? 'N/A', style: TextStyle(fontSize: 16)),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('Trạng thái:', style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                                  Text(
                                    item.congBo == "1" ? 'Đã công bố' : 'Chưa công bố',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: item.congBo == "1" ? Colors.green : Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(children: [
                          Expanded(
                            flex: 2,
                            child: Column(children: [
                              RichText(
                                text: TextSpan(
                                    children: [
                                      WidgetSpan(child: Icon(CupertinoIcons.calendar, size: 16, color: Colors.blue)),
                                      TextSpan(text: 'Start: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                      TextSpan(text: '${widgetLibraryState.DateTimeFormat(item.ngayBD ?? 'N/A')}')
                                    ],
                                    style: TextStyle(fontSize: 14, color: Colors.blue)
                                ),
                                textAlign: TextAlign.left,
                              ),
                              RichText(
                                text: TextSpan(
                                    children: [
                                      WidgetSpan(child: Icon(CupertinoIcons.calendar, size: 16, color: Colors.blue)),
                                      TextSpan(text: 'End: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                      TextSpan(text: '${widgetLibraryState.DateTimeFormat(item.ngayKT ?? 'N/A')}')
                                    ],
                                    style: TextStyle(fontSize: 14, color: Colors.blue)
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],),
                          ),
                           Expanded(
                               flex: 1,
                               child: Icon(
                                 CupertinoIcons.arrowshape_turn_up_right,
                                 size: 35,
                                 weight: 800,
                                 color: Colors.blue,
                               )
                           )
                        ],)
                       
                      ],
                    ),
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
