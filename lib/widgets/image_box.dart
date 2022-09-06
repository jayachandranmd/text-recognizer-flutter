import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class ImageSourceBox extends StatelessWidget {
  final dynamic child;
  const ImageSourceBox({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: DottedBorder(
        dashPattern: const [8, 8],
        strokeWidth: 2,
        borderType: BorderType.RRect,
        radius: const Radius.circular(12),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.40,
          child: child,
        ),
      ),
    );
  }
}
