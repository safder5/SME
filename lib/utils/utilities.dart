import 'dart:io';
import 'package:ashwani/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: source);
  if (file != null) {
    // img = await file.readAsBytes();
    return File(file.path);
  }
  print('no image selected');
}


class DottedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = blue // Set the color of the dots
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0; // Adjust the border width as needed

    final double dashWidth = 0.5; // Width of each dot
    final double dashSpace = 10.0; // Space between each dot

    double startX = 0.0;
    while (startX < size.width) {
      canvas.drawCircle(
        Offset(startX, 0),
        dashWidth / 2,
        paint,
      );
      startX += dashWidth + dashSpace;
    }

    double startY = 0.0;
    while (startY < size.height) {
      canvas.drawCircle(
        Offset(0, startY),
        dashWidth *0.8,
        paint,
      );
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class DottedBorderContainer extends StatelessWidget {
  final Widget child; // The content of the container

  DottedBorderContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DottedBorderPainter(),
      child: Container(
        child: child,
      ),
    );
  }
}
