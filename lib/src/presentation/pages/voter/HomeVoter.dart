import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:votesecure/src/config/AppConfig_api.dart';
import 'package:votesecure/src/core/utils/WidgetLibrary.dart';
import 'package:votesecure/src/data/models/ProfileModel.dart';
import 'package:votesecure/src/domain/repositories/UserRepository.dart';
import 'package:votesecure/src/presentation/pages/common/ElectionCalender/ElectionCalender.dart';
import 'package:votesecure/src/presentation/pages/common/ElectionResult/ElectionResultScreen.dart';
import 'package:votesecure/src/presentation/pages/common/Notification/AnnouncemantPage.dart';
import 'package:votesecure/src/presentation/pages/common/SupportInformationSubmission/SupportInformationSubmission_page.dart';
import 'package:votesecure/src/presentation/pages/voter/ListElections.dart';
import 'package:votesecure/src/presentation/widgets/TitleAppBarForHomePage.dart';
import 'package:votesecure/src/presentation/pages/common/account/Account.dart';

class HomeVoter extends StatefulWidget {
  const HomeVoter({
    super.key,
    required this.user
  });
  static const routeName = "/voter";
  final ProfileModel user;

  @override
  State<HomeVoter> createState() => _homeVoterState(user: user);
}

class _homeVoterState extends State<HomeVoter> {
  final ProfileModel user;
  final UserRepository userRepository = UserRepository();
  int _selectedIndex = 0;
  late List<Widget> _pages;
  late String Email;

  _homeVoterState({required this.user});

  @override
  void initState() {
    super.initState();
    _pages = [
      HomeScreen(ID_object: user.ID_Object ?? '',),
      AnnouncementScreen(ID_object: user.ID_Object ?? '',),
      UserAccount(user: user, uri: voterSendContactUs,),
    ];
    Email = user.Email ?? 'null';
  }

  @override
  void dispose() {
    super.dispose();
  }

  //Chuyển sang trang dựa trên index
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await userRepository.GetProfileUserBasedOnUserEmail(context, user, Email);
      },
      child: Scaffold(
        appBar: AppTitleHomePage(user: user),
        body: _pages[_selectedIndex],
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onItemTapped,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Trang chủ',
            ),
            NavigationDestination(
              icon: Icon(Icons.notifications_outlined),
              selectedIcon: Icon(Icons.notifications),
              label: 'Thông báo',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Tài khoản',
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final String ID_object;
  WidgetlibraryState widgetlibraryState = WidgetlibraryState();

  HomeScreen({required this.ID_object});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).primaryColor.withOpacity(0.1),
            Theme.of(context).colorScheme.secondary.withOpacity(0.1),
          ],
        ),
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              _buildWelcomeCard(),
              const SizedBox(height: 24),
              _buildFeatureGrid(context),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFF6190E8), Color(0xFF8677F0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Chào mừng đến với VoteSecure',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Hệ thống bầu cử trực tuyến',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 200,
              child: Lottie.asset(
                'assets/animations/voting.json',
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.1,
      children: [
        _buildFeatureCard(
          context,
          'Lịch bầu cử',
          Icons.calendar_month_outlined,
          const Color(0xFF4CAF50),
              () => Navigator.pushNamed(context, ElectioncalenderScreen.routeName),
        ),
        _buildFeatureCard(
          context,
          'Danh sách \nkỳ bầu cử',
          Icons.list_alt,
          const Color(0xFF2196F3),
              () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ListElectionsScreen(ID_object: ID_object),
            ),
          ), 
        ),
        _buildFeatureCard(
          context,
          'Gửi thông tin \nliên hệ',
          Icons.send_rounded,
          const Color(0xFF9C27B0),
              () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FeedbackPage(
                IDSender: ID_object,
                uri: voterSendContactUs,
              ),
            ),
          ),
        ),
        _buildFeatureCard(
          context,
          'Kết quả \nbầu cử',
          Icons.assessment_outlined,
          const Color(0xFFFF9800),
              () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ElectionResultScreen(ID_obj: ID_object),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureCard(
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
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                color.withOpacity(0.8),
                color,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: Colors.white,
              ),
              const SizedBox(height: 12),
              FittedBox(
                fit: BoxFit.cover,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
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