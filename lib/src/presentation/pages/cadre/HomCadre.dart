import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:votesecure/src/config/AppConfig_api.dart';
import 'package:votesecure/src/core/utils/WidgetLibrary.dart';
import 'package:votesecure/src/data/models/ProfileModel.dart';
import 'package:votesecure/src/domain/repositories/UserRepository.dart';
import 'package:votesecure/src/presentation/pages/cadre/ListOfCadreJoinedForElection.dart';
import 'package:votesecure/src/presentation/pages/common/ElectionCalender/ElectionCalender.dart';
import 'package:votesecure/src/presentation/pages/common/ElectionResult/ElectionResultScreen.dart';
import 'package:votesecure/src/presentation/pages/common/Notification/AnnouncemantPage.dart';
import 'package:votesecure/src/presentation/pages/common/SupportInformationSubmission/SupportInformationSubmission_page.dart';
import 'package:votesecure/src/presentation/pages/common/account/Account.dart';
import 'package:votesecure/src/presentation/widgets/TitleAppBarForHomePage.dart';

class HomeCadre extends StatefulWidget {
  final ProfileModel user;
  static const routeName = "/homecadre";

  const HomeCadre({
    super.key,
    required this.user
  });

  @override
  State<HomeCadre> createState() => _HomeCadreState(user: user);
}

class _HomeCadreState extends State<HomeCadre> with SingleTickerProviderStateMixin {
  final UserRepository userRepository = UserRepository();
  int _selectedIndex = 0;
  late List<Widget> _pages;
  late String Email;
  final ProfileModel user;
  late AnimationController _animationController;

  _HomeCadreState({required this.user});

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _pages = [
      HomeScreen(ID_object: user.ID_Object ?? ''),
      AnnouncementScreen(ID_object: user.ID_Object ?? ''),
      UserAccount(user: user, uri: candidateSendContactUs),
    ];
    Email = user.Email ?? 'null';
  }

  @override
  void dispose() {
    _animationController.dispose();
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
      onRefresh: () async {
        _animationController.forward(from: 0.0);
        await userRepository.GetProfileUserBasedOnUserEmail(context, user, Email);
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppTitleHomePage(user: user),
        body: _pages[_selectedIndex],
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
            indicatorColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            labelTextStyle: MaterialStateProperty.all(
              GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
          child: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onItemTapped,
            backgroundColor: Theme.of(context).colorScheme.surface,
            elevation: 0,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined, color: Colors.blue),
                selectedIcon: Icon(Icons.home_rounded, color: Colors.blue),
                label: 'Trang chủ',
              ),
              NavigationDestination(
                icon: Icon(Icons.notifications_outlined, color: Colors.blue),
                selectedIcon: Icon(Icons.notifications_rounded,color: Colors.blue),
                label: 'Thông báo',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline, color: Colors.blue),
                selectedIcon: Icon(Icons.person_rounded, color: Colors.blue),
                label: 'Tài khoản',
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

  const HomeScreen({
    super.key,
    required this.ID_object,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Banner with Animation
          Container(
            height: 220,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue[600]!,
                  Colors.blue[200]!,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Lottie.asset(
                    'assets/animations/cadre.json',
                    fit: BoxFit.cover,
                    repeat: true,
                  ),
                ),
              ],
            ),
          ),

          // Quick Actions Section
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.1,
                  children: [
                    _buildActionCard(
                      context,
                      'Lịch bầu cử',
                      Icons.calendar_month_rounded,
                      Colors.blue,
                          () => Navigator.pushNamed(context, ElectioncalenderScreen.routeName),
                    ),
                    _buildActionCard(
                      context,
                      'Danh sách kỳ bầu cử',
                      Icons.people_rounded,
                      Colors.green,
                          () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListOfCadreJoinedForElection(
                            ID_CanBo: ID_object,
                          ),
                        ),
                      ),
                    ),
                    _buildActionCard(
                      context,
                      'Gửi thông tin',
                      Icons.send_rounded,
                      Colors.orange,
                          () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FeedbackPage(
                            IDSender: ID_object,
                            uri: candidateSendContactUs,
                          ),
                        ),
                      ),
                    ),
                    _buildActionCard(
                      context,
                      'Kết quả bầu cử',
                      CupertinoIcons.chart_bar_fill,
                      Colors.purple,
                          () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ElectionResultScreen(
                            ID_obj: ID_object,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
      BuildContext context,
      String title,
      IconData icon,
      Color color,
      VoidCallback onTap,
      ) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: color,
                ),
              ),
              const SizedBox(height: 12),
               FittedBox(
                 fit: BoxFit.cover,
                 child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurface,
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