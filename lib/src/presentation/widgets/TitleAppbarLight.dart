import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTitleLight extends StatelessWidget implements PreferredSizeWidget {
  final String textTitle;

  const AppTitleLight({super.key, required this.textTitle});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xfff7f8f8), Color(0xffd5d7d8)],
            stops: [0, 1],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.keyboard_arrow_left_sharp,
          color: Colors.indigo,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      title: FittedBox(
        fit:BoxFit.fitWidth,
        child: Align(
          alignment: Alignment.center,
          child: Text(
            '${textTitle}',
            style: GoogleFonts.roboto(
              textStyle: TextStyle(
                color: Colors.indigo,
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