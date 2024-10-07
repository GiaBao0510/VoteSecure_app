import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTitleHomePage extends StatelessWidget implements PreferredSizeWidget {

  const AppTitleHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff3642f2), Color(0xff354cc0)],
            stops: [0.25, 0.75],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      elevation: 0,
      title: FittedBox(
        fit:BoxFit.fitWidth,
        child: Align(
          alignment: Alignment.center,
          child: Text(
            'Trang chủ',
            style: GoogleFonts.roboto(
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}


