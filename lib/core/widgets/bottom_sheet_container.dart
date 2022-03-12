import 'package:flutter/material.dart';

class BottomSheetContainer extends StatelessWidget {
  const BottomSheetContainer({
    required this.child,
    this.height = 0,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        color: Colors.white,
      ),
      height: height == 0 ? MediaQuery.of(context).size.height / 2.5 : height,
      width: MediaQuery.of(context).size.width,
      child: child,
    );
  }
}
