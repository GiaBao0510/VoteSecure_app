import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:votesecure/src/config/AppConfig_api.dart';
import 'package:votesecure/src/core/utils/WidgetLibrary.dart';
import 'package:votesecure/src/data/models/ProfileModel.dart';
import 'package:votesecure/src/domain/repositories/UserRepository.dart';
import 'package:votesecure/src/presentation/pages/candidate/ListOfRegisteredCandidate.dart';
import 'package:votesecure/src/presentation/pages/common/ElectionCalender/ElectionCalender.dart';
import 'package:votesecure/src/presentation/pages/common/SupportInformationSubmission/SupportInformationSubmission_page.dart';
import 'package:votesecure/src/presentation/pages/common/account/Account.dart';
import 'package:votesecure/src/presentation/widgets/TitleAppBarForHomePage.dart';

class Homecadidate extends StatefulWidget {
  final ProfileModel user;
  static const routeName = "/homecandidate";
  const Homecadidate({
    super.key,
    required this.user
  });

  @override
  State<Homecadidate> createState() => _HomecadidateState(user: user);
}

class _HomecadidateState extends State<Homecadidate> {
  //Thuộc tính
  final UserRepository userRepository = UserRepository();
  int _selectedIndex = 0;
  late List<Widget> _pages;
  late String Email;
  final ProfileModel user;

  _HomecadidateState({required this.user});

  //hàm khởi tạo
  @override
  void initState() {
    super.initState();
    _pages = [
      HomeScreen(ID_object: user.ID_Object ?? '',),
      ActivityScreen(),
      UserAccount(user: user,uri: candidateSendContactUs),
    ];
    Email = user.Email ?? 'null';
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh:  () async{
        print('làm mới nhe: $Email');
        await userRepository.GetProfileUserBasedOnUserEmail(context, user, Email);
      },
      child: SafeArea(
          child: Scaffold(
            appBar: AppTitleHomePage(user: user,),
            body: _pages[_selectedIndex],
            bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Trang chủ',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.notifications),
                  label: 'Thông báo',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle),
                  label: 'Tài khoản',
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.blue,
              onTap: _onItemTapped,
            ),
          )
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final String ID_object;
  WidgetlibraryState widgetlibraryState = WidgetlibraryState();
  
  HomeScreen({
    super.key,
    required this.ID_object,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      widgetlibraryState.buildPageBackgroundGradient2Color(context, '0xff40aae7', '0xff2843e2'),
      builHomeScreenForVoter(context)
    ],);
  }

  Widget builHomeScreenForVoter(BuildContext context){
    return Container(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30,),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    colors: [Color(0xfff3f1f1), Color(0xffffffff)],
                    stops: [0, 1],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: FractionallySizedBox(
                  child: Lottie.asset(
                      'assets/animations/candidate.json',
                      repeat: true,
                      fit: BoxFit.contain,
                      height: 250,
                      width: double.infinity
                  ),
                ),
              ),
              const SizedBox(height: 30,),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    colors: [Color(0xfff3f1f1), Color(0xffffffff)],
                    stops: [0, 1],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                height: 300,
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: widgetlibraryState.buildMenuItem(context,'Lịch bầu cử', Icons.calendar_month_outlined, ElectioncalenderScreen.routeName)
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ListofRegisteredCandidateScreen(ID_ucv: ID_object))
                              );
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [Color(0xff44a4fd), Color(0xff3f5efb)],
                                          stops: [0.25, 0.75],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    height: 50,
                                    width: 50,
                                    child: Icon(Icons.list_alt, size: 40,color: Colors.white,)
                                ),
                                SizedBox(height: 8),
                                FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Text(
                                      'Danh sách \nkỳ bầu cử \nđã ghi danh ', style: TextStyle(fontSize: 15),
                                      textAlign: TextAlign.center,
                                    )
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              print("ID_object: $ID_object - urí: $candidateSendContactUs");
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => FeedbackPage(IDSender: ID_object,uri: candidateSendContactUs,))
                              );
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [Color(0xff44a4fd), Color(0xff3f5efb)],
                                          stops: [0.25, 0.75],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    height: 50,
                                    width: 50,
                                    child: Icon(Icons.send_rounded, size: 40,color: Colors.white,)
                                ),
                                SizedBox(height: 8),
                                FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Text(
                                      'Gửi thông tin \nliên hệ', style: TextStyle(fontSize: 15),
                                      textAlign: TextAlign.center,
                                    )
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15,),
                    Row(
                      children: [
                        Expanded(
                          child: widgetlibraryState.buildMenuItem(context,'Xem kết quả \nbầu cử', Icons.newspaper, ''),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30,),
            ],
          ),
        ),
      ),
    );
  }
}

class ActivityScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Activity Page'),
    );
  }
}

