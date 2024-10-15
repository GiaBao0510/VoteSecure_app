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

  //Màu cho từng mục
  Color TextColorInItem = Colors.white;
  List<Color>  BackGroundColorInItem = [Color(0xff1e3c72), Color(0xff2a5298)];

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
  FutureBuilder<List<ElectionVoterHavePaticipanted_Model>> ShowList(){
    return FutureBuilder<List<ElectionVoterHavePaticipanted_Model>>
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
              //Đổi màu chữ và nền
              if(_fillDanhSachBauCuList[index].ghiNhan == '0'){
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

                    if(_fillDanhSachBauCuList[index].ghiNhan == '0'){
                      print('Đi đến form bỏ phiếu');
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => BallotForm(ngayBD: _fillDanhSachBauCuList[index].ngayBD, electionDetails: _fillDanhSachBauCuList[index],ID_object: ID_object, ))
                      );
                    }else{
                      QuickAlert.show(
                          context: context,
                          type: QuickAlertType.warning,
                          title: "Đã bỏ phiếu",
                          text: "Bạn đã bỏ phiếu ở kỳ này rồi"
                      );
                    }
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
                                const TextSpan(text: 'Bỏ phiếu: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                                TextSpan(text: '${_fillDanhSachBauCuList[index].ghiNhan == '0'? 'Chưa': 'Đã bỏ phiếu'}')
                              ], style: TextStyle(color: TextColorInItem))
                          ),
                        ),
                        const SizedBox(width: 10,),
                        Expanded(
                          flex: 2,
                          child: RichText(
                              text: TextSpan(children: [
                                const TextSpan(text: 'Ngày bắt đầu: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                                TextSpan(text: '${widgetLibraryState.DateTimeFormat(_fillDanhSachBauCuList[index].ngayBD) }')
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