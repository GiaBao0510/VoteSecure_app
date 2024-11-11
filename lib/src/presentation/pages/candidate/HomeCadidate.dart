import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:votesecure/src/config/AppConfig_api.dart';
import 'package:votesecure/src/data/models/ProfileModel.dart';
import 'package:votesecure/src/domain/repositories/UserRepository.dart';
import 'package:votesecure/src/presentation/pages/candidate/ListOfRegisteredCandidate.dart';
import 'package:votesecure/src/presentation/pages/common/ElectionCalender/ElectionCalender.dart';
import 'package:votesecure/src/presentation/pages/common/ElectionResult/ElectionResultScreen.dart';
import 'package:votesecure/src/presentation/pages/common/Notification/AnnouncemantPage.dart';
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
  final UserRepository userRepository = UserRepository();
  int _selectedIndex = 0;
  late List<Widget> _pages;
  late String Email;
  final ProfileModel user;

  _HomecadidateState({required this.user});

  @override
  void initState() {
    super.initState();
    _pages = [
      HomeScreen(ID_object: user.ID_Object ?? ''),
      AnnouncementScreen(ID_object: user.ID_Object ?? ''),
      UserAccount(user: user, uri: candidateSendContactUs),
    ];
    Email = user.Email ?? 'null';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await userRepository.GetProfileUserBasedOnUserEmail(context, user, Email);
        },
        child: SafeArea(
          child: Stack(
            children: [
              // Gradient background
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF2196F3),
                      Color(0xFF1565C0),
                    ],
                  ),
                ),
              ),
              Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppTitleHomePage(user: user,),
                body: IndexedStack(
                  index: _selectedIndex,
                  children: _pages,
                ),
                bottomNavigationBar: Theme(
                  data: Theme.of(context).copyWith(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      child: BottomNavigationBar(
                        items: [
                          BottomNavigationBarItem(
                            icon: Icon(Icons.home_outlined),
                            activeIcon: Icon(Icons.home),
                            label: 'Trang chủ',
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(Icons.notifications_outlined),
                            activeIcon: Icon(Icons.notifications),
                            label: 'Thông báo',
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(Icons.person_outline),
                            activeIcon: Icon(Icons.person),
                            label: 'Tài khoản',
                          ),
                        ],
                        currentIndex: _selectedIndex,
                        selectedItemColor: Color(0xFF1565C0),
                        unselectedItemColor: Colors.grey,
                        showUnselectedLabels: true,
                        backgroundColor: Colors.white,
                        elevation: 0,
                        onTap: (index) => setState(() => _selectedIndex = index),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final String ID_object;

  HomeScreen({
    super.key,
    required this.ID_object,
  });

  // Di chuyển menuOptions vào bên trong phương thức build
  @override
  Widget build(BuildContext context) {
    // Khởi tạo menuOptions ở đây để có thể truy cập ID_object
    final List<MenuOption> menuOptions = [
      MenuOption(
        title: 'Lịch bầu cử',
        icon: Icons.calendar_month_outlined,
        route: ElectioncalenderScreen.routeName,
        gradient: [Color(0xFF4CAF50), Color(0xFF388E3C)],
      ),
      MenuOption(
        title: 'Danh sách\nkỳ bầu cử',
        icon: Icons.list_alt,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ListofRegisteredCandidateScreen(ID_ucv: ID_object),
          ),
        ),
        gradient: [Color(0xFFFFA726), Color(0xFFF57C00)],
      ),
      MenuOption(
        title: 'Gửi thông tin\nliên hệ',
        icon: Icons.send_rounded,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FeedbackPage(
              IDSender: ID_object,
              uri: candidateSendContactUs,
            ),
          ),
        ),
        gradient: [Color(0xFF26C6DA), Color(0xFF0097A7)],
      ),
      MenuOption(
        title: 'Kết quả\nbầu cử',
        icon: CupertinoIcons.list_bullet_below_rectangle,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ElectionResultScreen(ID_obj: ID_object),
          ),
        ),
        gradient: [Color(0xFFEC407A), Color(0xFFC2185B)],
      ),
    ];

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            // Welcome Card
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Chào mừng đến với hệ thống',
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Bầu cử điện tử',
                    style: GoogleFonts.roboto(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1565C0),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Animation
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Lottie.asset(
                  'assets/animations/candidate.json',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: 20),
            // Menu Grid
            GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1,
              ),
              itemCount: menuOptions.length,
              itemBuilder: (context, index) {
                final option = menuOptions[index];
                return MenuCard(option: option);
              },
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class MenuOption {
  final String title;
  final IconData icon;
  final String? route;
  final Function()? onTap;  // Thay đổi kiểu của onTap
  final List<Color> gradient;

  MenuOption({
    required this.title,
    required this.icon,
    this.route,
    this.onTap,
    required this.gradient,
  });
}

class MenuCard extends StatelessWidget {
  final MenuOption option;

  const MenuCard({
    super.key,
    required this.option,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (option.route != null) {
          Navigator.pushNamed(context, option.route!);
        } else if (option.onTap != null) {
          option.onTap!();  // Gọi trực tiếp onTap
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: option.gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: option.gradient[0].withOpacity(0.3),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              option.icon,
              size: 40,
              color: Colors.white,
            ),
            SizedBox(height: 12),
            Text(
              option.title,
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}