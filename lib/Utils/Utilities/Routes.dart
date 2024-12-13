import 'package:flutter/material.dart';
import 'package:note_pad/Utils/Utilities/RoutesName.dart';
//import 'package:note_pad/Resources/Utilities/RoutesName.dart';
//import 'package:note_pad/Resources/Utilities/RoutesName.dart';
import 'package:note_pad/View/Add_Notes.dart';
import 'package:note_pad/View/Home_Screen.dart';
import 'package:note_pad/View/Updated_HomeScreen.dart';

//class for the constructors
class UpdateArguments {
  String? Title;
  String? Description;
  String? DateAndTime;
  int? Id;
  bool? update;

  UpdateArguments({this.Id, this.Title, this.Description, this.DateAndTime, this.update});
}

// class Updatescreen {
//   bool? updateScreen;
//   Updatescreen({this.updateScreen});
// }

class Routes {
  static MaterialPageRoute generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesNames.Home_Screen:
        // final args1 = settings.arguments as Updatescreen;
        return MaterialPageRoute(
            builder: (BuildContext context) => HomeScreen(
                // updateScreen: args1.updateScreen,
                ));

      case RoutesNames.Add_Notes:
        final args = settings.arguments as UpdateArguments;
        return MaterialPageRoute(
            builder: (BuildContext context) => Add_NotesScreen(
                  noteTitle: args.Title,
                  notesDescription: args.Description,
                  notesDateAndTime: args.DateAndTime,
                  id: args.Id,
                  update: args.update,
                ));

      case RoutesNames.Updated_HomeScreen:
        return MaterialPageRoute(builder: (BuildContext context) => Updated());
      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(
              child: Text('No Routes Defined!'),
            ),
          );
        });
    }
  }
}
