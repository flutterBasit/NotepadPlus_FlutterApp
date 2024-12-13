import 'package:flutter/material.dart';
import 'package:note_pad/Database/db_handler.dart';
import 'package:note_pad/Models/model.dart';
import 'package:note_pad/Resources/Constant/constants.dart';
import 'package:note_pad/Utils/Utilities/Routes.dart';
import 'package:note_pad/Utils/Utilities/RoutesName.dart';

class Updated extends StatefulWidget {
  const Updated({super.key});

  @override
  State<Updated> createState() => _UpdatedState();
}

class _UpdatedState extends State<Updated> {
  DBHelper? dbHelper;
  late Future<List<NotesModel>> noteslist;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper = DBHelper();
    loadData();
    //  update();
  }

  loadData() async {
    noteslist = dbHelper!.getNotesList();
    setState(() {
      noteslist = dbHelper!.getNotesList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Notes",
          style: App_Basic_Constants.AppBar_Style,
        ),
        centerTitle: true,
        backgroundColor: App_Basic_Constants.App_BarColor,
      ),
      backgroundColor: App_Basic_Constants.App_ScaffoladColor,
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
                future: noteslist,
                builder: (context, AsyncSnapshot<List<NotesModel>> snapshot) {
                  if (!snapshot.hasData || snapshot == null) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.data!.length == 0) {
                    return Center(
                      child: Text(
                        'No Task Found',
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                      ),
                    );
                  } else {
                    return ListView.builder(
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, index) {
                          return Dismissible(
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: Colors.red,
                              child: Icon(Icons.delete_forever),
                            ),
                            onDismissed: (DismissDirection direction) {
                              dbHelper!.Delete(snapshot.data![index].Id!.toInt());
                              noteslist = dbHelper!.getNotesList();
                              snapshot.data!.remove(snapshot.data![index]);
                            },
                            key: ValueKey<int>(snapshot.data![index].Id!.toInt()),
                            child: InkWell(
                              onTap: () {
                                // dbHelper!.update(NotesModel(
                                //     Id: snapshot.data![index].Id,
                                //     Title: "This is updated",
                                //     Description: "this is also updated",
                                //     DateAndTime: "2024"));
                                // setState(() {
                                //   noteslist = dbHelper!.getNotesList();
                                // });
                                Navigator.pushNamed(context, RoutesNames.Add_Notes,
                                    arguments: UpdateArguments(
                                        Title: snapshot.data![index].Title,
                                        Description: snapshot.data![index].Description,
                                        Id: snapshot.data![index].Id,
                                        DateAndTime: '2024',
                                        update: true));
                                // setState(() {
                                //   noteslist = dbHelper!.getNotesList();
                                // });
                              },
                              child: Container(
                                  decoration: BoxDecoration(color: Colors.white70),
                                  child: Column(
                                    children: [
                                      Card(
                                        child: ListTile(
                                          contentPadding: EdgeInsets.all(10),
                                          title: Text(snapshot.data![index].Title.toString()),
                                          subtitle: Text(snapshot.data![index].Description.toString()),
                                          //  leading: Text(),
                                        ),
                                      ),
                                      Divider(
                                        color: Colors.white12,
                                        thickness: 2,
                                      ),
                                      Text(snapshot.data![index].DateAndTime.toString()),
                                    ],
                                  )),
                            ),
                          );
                        });
                  }
                }),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, RoutesNames.Add_Notes, arguments: UpdateArguments(update: false));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
