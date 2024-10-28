import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:votesecure/src/core/utils/WidgetLibrary.dart';
import 'package:votesecure/src/data/models/CadreJoinedForElectionModel.dart';
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
  Color TextColorInItem = Colors.white;
  Color BgColorInItem = Colors.indigo;
  List<Color>  BackGroundColorInItem = [Color(0xff1e3c72), Color(0xff2a5298)];

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

                  //Đổi màu chữ và nền dựa trên công bố kq
                  if(_fillDanhSachBauCuList[index].CongBo == "1"){
                    TextColorInItem = Colors.black87;
                    BgColorInItem = Color(0xffe65c00);
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
                              child: Column(
                                children: [
                                  RichText(
                                      text: TextSpan(children: [
                                        const TextSpan(text: 'Tên cấp ứng củ: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                                        TextSpan(text: '${_fillDanhSachBauCuList[index].tenCapUngCu ?? 'null' }')
                                      ], style: TextStyle(color: TextColorInItem))
                                  ),
                                  RichText(
                                      text: TextSpan(children: [
                                        const TextSpan(text: 'Số lượng ứng cử viên: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                                        TextSpan(text: '${_fillDanhSachBauCuList[index].SoLuongToiDaUngCuVien}')
                                      ], style: TextStyle(color: TextColorInItem))
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
                                      ], style: TextStyle(color: TextColorInItem)),
                                    textAlign: TextAlign.left,
                                  ),
                                  RichText(
                                      text: TextSpan(children: [
                                        const TextSpan(text: 'Ngày kết thúc: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                                        TextSpan(text: '${widgetLibraryState.DateTimeFormat(_fillDanhSachBauCuList[index].ngayKT ?? 'null') }')
                                      ], style: TextStyle(color: TextColorInItem)),
                                    textAlign: TextAlign.left,
                                  ),
                                  RichText(
                                      text: TextSpan(children: [
                                        const TextSpan(text: 'Công bố kết quả: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                                        TextSpan(text: '${_fillDanhSachBauCuList[index].CongBo == "1"? 'Rồi':'Chưa ' }')
                                      ], style: TextStyle(color: TextColorInItem)),
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
  Widget _buildNavigationButtonSection(BuildContext content, int index){
    return Row(children: [
      Expanded(
        flex: 1,
        child: ElevatedButton(
            onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListOfCandidatesBasedOnElectionDateScreen(ngayBD: _fillDanhSachBauCuList[index].ngayBD ?? '', ))
              );
            },
            child: RichText(
                text: TextSpan(children: [
                  WidgetSpan(
                    child: Icon(Icons.people_alt_sharp, size: 20),
                  ),
                  const TextSpan(text: ' Danh sách ứng cử viên ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13))
                ], style: TextStyle(color: BgColorInItem)),
              textAlign: TextAlign.center,
            ),
          style: ElevatedButton.styleFrom(
            backgroundColor: TextColorInItem,
            foregroundColor: BgColorInItem,
          ),
        ),
      ),
      const SizedBox(width: 10,),
      Expanded(
        flex: 1,
        child: ElevatedButton(
          onPressed: (){
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DetailedListOfVotesBasedOnTheElection(ngayBD: _fillDanhSachBauCuList[index].ngayBD ?? '',cadreJoinedForElectionModel: _fillDanhSachBauCuList[index], ))
            );
          },
          child: RichText(
            text: TextSpan(children: [
              WidgetSpan(
                child: Icon(Icons.how_to_vote_outlined, size: 20),
              ),
              const TextSpan(text: ' Danh sách phiếu bầu ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13))
            ], style: TextStyle(color: BgColorInItem)),
            textAlign: TextAlign.center,
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: TextColorInItem,
            foregroundColor: BgColorInItem,
          ),
        ),
      ),
    ],);
  }

}
