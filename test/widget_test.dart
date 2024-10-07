import 'package:flutter/material.dart';
import 'package:votesecure/src/presentation/pages/common/ElectionCalender/ElectionCalender.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Page with Navigation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
      routes: {
        ElectioncalenderScreen.routeName: (context) => ElectioncalenderScreen(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      appBar: AppBar(
        title: Text('Home Page'),
      ),
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Get out and about 2', style: TextStyle(fontSize: 24)),
          ),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: [
              _buildMenuItem(context,'Lịch bầu cử', Icons.calendar_month_outlined, ElectioncalenderScreen.routeName),
              // _buildMenuItem('Food', Icons.fastfood),
              // _buildMenuItem('Package', Icons.local_shipping),
              // _buildMenuItem('Reserve', Icons.book_online),
              // _buildMenuItem('Grocery', Icons.local_grocery_store),
              // _buildMenuItem('Transit', Icons.directions_bus),
              // _buildMenuItem('Rent', Icons.home),
              // _buildMenuItem('More', Icons.more_horiz),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Where to?', style: TextStyle(fontSize: 18)),
                SizedBox(height: 10),
                _buildSearchBar(),
                SizedBox(height: 20),
                _buildOption('Choose a saved place'),
                _buildOption('Set destination on map'),
              ],
            ),
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

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search),
        hintText: 'Search',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildOption(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(Icons.place),
          SizedBox(width: 10),
          Text(text),
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
