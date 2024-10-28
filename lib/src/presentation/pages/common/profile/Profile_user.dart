import 'package:flutter/material.dart';

class ProfileUserScreen extends StatelessWidget {
  static const routeName= 'profile-user';
  final ID_user;
  ProfileUserScreen({required this.ID_user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Profile"),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue,
                    Colors.lightBlue,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage("assets/images/profile.jpg"), // Thay đổi với ảnh của bạn
                  ),
                  SizedBox(height: 10),
                  Text(
                    "James Martin",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Senior Graphic Designer",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileItem(
                    icon: Icons.email,
                    title: "Email",
                    content: "james012@gmail.com",
                  ),
                  _buildProfileItem(
                    icon: Icons.phone_android,
                    title: "Mobile",
                    content: " 0123456789",
                  ),
                  _buildProfileItem(
                    icon: Icons.location_pin,
                    title: "Address",
                    content: "123 Street, New York, USA",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem({required IconData icon, required String title, required String content}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(content),
    );
  }
}