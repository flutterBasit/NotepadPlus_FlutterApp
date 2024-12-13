import 'dart:io';

import 'package:flutter/material.dart';
import 'package:note_pad/Database/db_handler.dart';
import 'package:note_pad/Models/model.dart';
import 'package:note_pad/Resources/Constant/constants.dart';
import 'package:note_pad/Utils/Utilities/Routes.dart';
import 'package:note_pad/Utils/Utilities/RoutesName.dart';

class HomeScreen extends StatefulWidget {
  bool? updateScreen;
  HomeScreen({super.key, this.updateScreen});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DBHelper? dbHelper;
  late Future<List<NotesModel>> noteslist;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    loadData();
  }

  loadData() async {
    noteslist = dbHelper!.getNotesList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notes",
          style: App_Basic_Constants.AppBar_Style,
        ),
        centerTitle: true,
        backgroundColor: App_Basic_Constants.App_BarColor,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: App_Basic_Constants.App_ScaffoladColor,
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
                future: noteslist,
                builder: (context, AsyncSnapshot<List<NotesModel>> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        'No Task Found',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w700),
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
                            child: const Icon(Icons.delete_forever),
                          ),
                          onDismissed: (DismissDirection direction) {
                            dbHelper!.Delete(snapshot.data![index].Id!.toInt());
                            setState(() {
                              noteslist = dbHelper!.getNotesList();
                            });
                          },
                          key: ValueKey<int>(snapshot.data![index].Id!.toInt()),
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                RoutesNames.Add_Notes,
                                arguments: UpdateArguments(
                                    Title: snapshot.data![index].Title,
                                    Description:
                                        snapshot.data![index].Description,
                                    Id: snapshot.data![index].Id,
                                    DateAndTime: '2024',
                                    update: true),
                              );
                            },
                            child: Container(
                              decoration:
                                  const BoxDecoration(color: Colors.white70),
                              child: Column(
                                children: [
                                  Card(
                                    color: Colors.white30,
                                    child: ListTile(
                                      contentPadding: EdgeInsets.all(10),
                                      title: Text(snapshot.data![index].Title
                                          .toString()),
                                      subtitle: Text(snapshot
                                          .data![index].Description
                                          .toString()),
                                      trailing: snapshot.data![index].Image !=
                                              null
                                          ? Image.file(
                                              File(
                                                  snapshot.data![index].Image!),
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                            )
                                          : null, // Handle cases where there's no image path
                                    ),
                                  ),
                                  const Divider(
                                    color: Colors.white12,
                                    thickness: 2,
                                  ),
                                  Text(snapshot.data![index].DateAndTime
                                      .toString()),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                }),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            RoutesNames.Add_Notes,
            arguments: UpdateArguments(update: false),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
