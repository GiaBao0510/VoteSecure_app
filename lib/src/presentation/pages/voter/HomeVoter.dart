import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:votesecure/src/presentation/pages/common/ElectionCalender/ElectionCalender.dart';
import 'package:votesecure/src/presentation/widgets/TitleAppBarForHomePage.dart';

class homeVoter extends StatefulWidget {
  const homeVoter({super.key});
  static const routeName = "/voter";

  @override
  State<homeVoter> createState() => _homeVoterState();
}

class _homeVoterState extends State<homeVoter> {

  int _selectedIndex = 0;

  List<Widget> _pages = [
    HomeScreen(),
    ActivityScreen(),
    AccountScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTitleHomePage(),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timeline),
            label: 'Activity',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: [
              _buildMenuItem(context,'Lịch bầu cử', Icons.calendar_month_outlined, ElectioncalenderScreen.routeName),
              _buildMenuItem(context,'Danh sách kỳ bầu cử', Icons.list_alt, ElectioncalenderScreen.routeName),
              //_buildMenuItem('Package', Icons.local_shipping),
              // _buildMenuItem('Reserve', Icons.book_online),
              // _buildMenuItem('Grocery', Icons.local_grocery_store),
              // _buildMenuItem('Transit', Icons.directions_bus),
              // _buildMenuItem('Rent', Icons.home),
              // _buildMenuItem('More', Icons.more_horiz),
            ],
          ),

        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context ,String title, IconData icon, String path) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, path);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 36),
          SizedBox(height: 8),
          Text(title, style: TextStyle(fontSize: 12)),
        ],
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

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Account Page'),
    );
  }
}
