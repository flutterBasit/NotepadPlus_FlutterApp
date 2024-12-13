import 'package:flutter/material.dart';

class IconContainer extends StatelessWidget {
  final Icon BottomIcons;
  final VoidCallback onPressed;
  const IconContainer(
      {super.key, required this.BottomIcons, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    //final width = MediaQuery.of(context).size.width * 1;
    // final height = MediaQuery.of(context).size.height * 1;
    return Container(
      width: 80,
      height: 50,
      decoration: BoxDecoration(
          color: Color.fromARGB(118, 255, 255, 255),
          border: Border.all(color: Colors.black45, width: 2),
          borderRadius: BorderRadius.circular(20)),
      child: IconButton(onPressed: onPressed, icon: BottomIcons),
    );
  }
}
