import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: UserProfilePage(),
      debugShowCheckedModeBanner: false, // Tắt banner debug
    );
  }
}

class UserProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Xử lý khi nhấn vào biểu tượng cài đặt
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRghxzHtTHtr7yQw54mWQGaWon6cLdMhKGNsA&s'),
              //backgroundImage: , // Hình ảnh avatar
            ),
            SizedBox(height: 10),
            Text(
              'Jhonson King',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'jhonking@gmail.com',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Xử lý khi nhấn vào nút "Edit Profile"
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Text('Edit Profile'),
              ),
            ),
            SizedBox(height: 30),
            _buildProfileOption(
              icon: Icons.favorite_border,
              title: 'Favourites',
              onTap: () {},
            ),
            _buildProfileOption(
              icon: Icons.download_outlined,
              title: 'Downloads',
              onTap: () {},
            ),
            Divider(),
            _buildProfileOption(
              icon: Icons.language,
              title: 'Language',
              onTap: () {},
            ),
            _buildProfileOption(
              icon: Icons.location_on_outlined,
              title: 'Location',
              onTap: () {},
            ),
            _buildProfileOption(
              icon: Icons.display_settings_outlined,
              title: 'Display',
              onTap: () {},
            ),
            _buildProfileOption(
              icon: Icons.feed_outlined,
              title: 'Feed preference',
              onTap: () {},
            ),
            _buildProfileOption(
              icon: Icons.subscriptions_outlined,
              title: 'Subscription',
              onTap: () {},
            ),
            Divider(),
            _buildProfileOption(
              icon: Icons.clear,
              title: 'Clear Cache',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(
      {required IconData icon,
      required String title,
      required Function() onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
