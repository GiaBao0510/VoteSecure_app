import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:votesecure/src/core/utils/WidgetLibrary.dart';
import 'package:votesecure/src/data/models/CandidateRegistedForElectionsModel.dart';
import 'package:votesecure/src/domain/repositories/CandidateRepository.dart';
import 'package:votesecure/src/presentation/pages/candidate/ListOfCandaitesBasedOnElecionDatePage.dart';
import 'package:votesecure/src/presentation/widgets/TitleAppBar.dart';
import 'package:votesecure/src/presentation/widgets/searchBar.dart';
import 'package:votesecure/src/presentation/pages/shared/LoadingPage.dart';

class ListofRegisteredCandidateScreen extends StatefulWidget {
  static const routeName = 'get-list-registered-candidate';
  final String ID_ucv;
  const ListofRegisteredCandidateScreen({super.key , required this.ID_ucv});

  @override
  State<ListofRegisteredCandidateScreen> createState() => _ListofRegisteredCandidateScreenState(ID_ucv: ID_ucv);
}

class _ListofRegisteredCandidateScreenState extends State<ListofRegisteredCandidateScreen> {
  //Thuộc tinh
  final String ID_ucv;
  final CandidateRepository  candidateRepository = CandidateRepository();
  final TextEditingController _searchController = TextEditingController();
  late Future<List<CandidateRegistedForElectionsModel>> _danhsachbaucuFuture;
  List<CandidateRegistedForElectionsModel> _fillDanhSachBauCuList = [];
  List<CandidateRegistedForElectionsModel> _danhSachBauCuList = [];
  WidgetlibraryState widgetLibraryState = WidgetlibraryState();
  Color TextColorInItem = Colors.white;
  List<Color>  BackGroundColorInItem = [Color(0xff1e3c72), Color(0xff2a5298)];


  _ListofRegisteredCandidateScreenState({
    required this.ID_ucv
  });

  //Hàm khởi tạo
  @override
  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(_fillterElections);
  }

  //haàm hủy
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  //Hàm lấy dữ liệu
  Future<void> _loadData() async{
    final controller = Provider.of<CandidateRepository>(context, listen: false);
    _danhsachbaucuFuture = controller.GetListOfRegisteredCandidate(context,ID_ucv);
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
        return kybaucu.tenCapUngCu!.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppTitle(textTitle: 'Danh sách kỳ bầu cử đã đăng ký'),
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
  FutureBuilder<List<CandidateRegistedForElectionsModel>> ShowList(){
    return FutureBuilder<List<CandidateRegistedForElectionsModel>>
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

                  //Đổi màu chữ và nền dựa trên ngày kết thúc
                  DateTime ngayKT = DateTime.parse(_fillDanhSachBauCuList[index].ngayBD ?? 'null');
                  DateTime current = DateTime.now();
                  if(current.isAfter(ngayKT) == false){
                    print("Ngày hiện tại: $current");
                    print("Ngày kết thúc: $ngayKT");
                    TextColorInItem = Colors.black87;
                    BackGroundColorInItem = [Color(0xffe65c00), Color(0xfff9d423)];
                  }

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
                    child: ElevatedButton(
                      onPressed: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ListOfCandidatesBasedOnElectionDateScreen(ngayBD: _fillDanhSachBauCuList[index].ngayBD ?? '', ))
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(Colors.transparent),
                        shadowColor:
                        MaterialStateProperty.all(Colors.transparent),
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
                                          const TextSpan(text: 'Tên kỳ bầu cử: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                                          TextSpan(text: '${_fillDanhSachBauCuList[index].tenKyBauCu}')
                                        ],
                                          style: TextStyle(color: TextColorInItem,),),
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
                                          style: TextStyle(color: TextColorInItem,),),
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
                              child: RichText(
                                  text: TextSpan(children: [
                                    const TextSpan(text: 'Tên cấp ứng củ: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                                    TextSpan(text: '${_fillDanhSachBauCuList[index].tenCapUngCu ?? 'null' }')
                                  ], style: TextStyle(color: TextColorInItem))
                              ),
                            ),
                            const SizedBox(width: 10,),
                            Expanded(
                              flex: 2,
                              child: RichText(
                                  text: TextSpan(children: [
                                    const TextSpan(text: 'Ngày bắt đầu: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                                    TextSpan(text: '${widgetLibraryState.DateTimeFormat(_fillDanhSachBauCuList[index].ngayBD ?? 'null') }')
                                  ], style: TextStyle(color: TextColorInItem))
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child:Icon(
                                Icons.keyboard_double_arrow_right,
                                size: 55,
                                color: TextColorInItem,  ),
                            ),
                          ],),

                        ],),
                      ),
                    ),
                  );
                }
            );
          }
        }
    );
  }
}
