import 'package:flutter/widgets.dart';

class SetupDetails {
  final String name;
  final String dateCreated;

  SetupDetails({
    required this.name,
    required this.dateCreated,
    
  });
}

class SetupProvider with ChangeNotifier {}
