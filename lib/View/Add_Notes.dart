import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:undo/undo.dart';

import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:note_pad/Database/db_handler.dart';
import 'package:note_pad/Models/model.dart';
import 'package:note_pad/Resources/Components/ReUsableFormField.dart';
import 'package:note_pad/Resources/Components/ReUsableIcons.dart';
import 'package:note_pad/Resources/Constant/constants.dart';
import 'package:note_pad/Utils/Utilities/RoutesName.dart';

class Add_NotesScreen extends StatefulWidget {
  final String? noteTitle;
  final String? notesDescription;
  final String? notesDateAndTime;
  final int? id;
  bool? update;

  Add_NotesScreen(
      {super.key,
      this.id,
      this.noteTitle,
      this.notesDescription,
      this.notesDateAndTime,
      this.update});

  @override
  State<Add_NotesScreen> createState() => _Add_NotesScreenState();
}

class _Add_NotesScreenState extends State<Add_NotesScreen> {
  DBHelper? dbHelper;
  late Future<List<NotesModel>> noteslist;
  //using image picker for the use of picking image or taking pic from camera
  final ImagePicker _picker = ImagePicker();
  XFile? pickedImage;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  //global form key
  final _formKey = GlobalKey<FormState>();
  String? title;
  // final QuillController _controller = QuillController.basic();

  //for undo and redo
  final List<String> _history = [];
  final List<String> _redoHistory = [];

  void _updateHistory(String text) {
    // Add the current text to the history if it's a new state
    if (_history.isEmpty || _history.last != text) {
      _history.add(text);
      // Clear redo history when a new change is made
      _redoHistory.clear();
    }
  }

  void _undo() {
    if (_history.isNotEmpty) {
      setState(() {
        _redoHistory
            .add(descriptionController.text); // Push current text to redo stack
        descriptionController.text = _history.removeLast();

        descriptionController.selection = TextSelection.fromPosition(
          TextPosition(offset: descriptionController.text.length),
        );
      });
    }
  }

  void _redo() {
    if (_redoHistory.isNotEmpty) {
      setState(() {
        _history
            .add(descriptionController.text); // Push current text to undo stack
        descriptionController.text = _redoHistory.removeLast();
        descriptionController.selection = TextSelection.fromPosition(
          TextPosition(offset: descriptionController.text.length),
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();

    print('______________________________________');

    if (widget.id != null) {
      print('+++++++++++++++++++++++++++++++++++++++++++');
      print(titleController.text);
      titleController.text = widget.noteTitle!;
      descriptionController.text = widget.notesDescription!;
    }
    loadData();

//listing the value when changed for the undo and redo
  }

  loadData() async {
    noteslist = dbHelper!.getNotesList();
  }

  //for changing the background
  int _currentIndex = 0;
  final List<String> _backgroundImages = [
    'assets/images/1.JPG',
    'assets/images/2.JPG',
    'assets/images/3.JPG',
    'assets/images/4.JPG',
    'assets/images/5.JPG',
    'assets/images/6.JPG'
  ];
  void _changeBackground() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _backgroundImages.length;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    descriptionController.dispose();
    super.dispose();
  }

//check icon with its implementation in action of appbar
  Widget DoneAction_Check() {
    return IconButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            final note = NotesModel(
                Id: widget.id,
                Title: titleController.text,
                Description: descriptionController.text,
                DateAndTime: DateFormat('d/M/y')
                    .add_jm()
                    .format(DateTime.now())
                    .toString(),
                // Image: File(pickedImage!.path).toString(),
                Image: pickedImage?.path);
            final action = widget.id == null
                ? dbHelper!.insert(note)
                : dbHelper!.update(note);
            action.then((value) {
              Navigator.pushNamed(context, RoutesNames.Home_Screen);
            }).onError((error, stackTrace) {
              print(error.toString());
            });
          }
        },
        icon: const Icon(Icons.check));
  }

  //Undo Redo widgets in action of appbar
  Widget UndoRedo_Buttons() {
    return Row(
      children: [
        descriptionController.text.isEmpty
            ? SizedBox()
            : IconButton(
                onPressed: _redo,
                icon: Icon(Icons.redo),
              ),
        descriptionController.text.isEmpty
            ? SizedBox()
            : IconButton(onPressed: _undo, icon: Icon(Icons.undo))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.id == null ? "Add Note" : "Update Note",
          style: App_Basic_Constants.AppBar_Style,
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(_backgroundImages[_currentIndex]),
              fit: BoxFit.cover,
            ),
          ),
        ),
        actions: [
          DoneAction_Check(),
          IconButton(
              onPressed: () {
                _changeBackground();
              },
              icon: const Icon(Icons.screenshot)),
          UndoRedo_Buttons()
        ],
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: App_Basic_Constants.App_ScaffoladColor,
      body: SafeArea(
          child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              _backgroundImages[_currentIndex],
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    ReUsableTextFormField(
                        controller: titleController,
                        HintName: 'Add Title',
                        HintTextStyle: App_Basic_Constants.HintTextStyle),
                    const SizedBox(height: 30),

                    TextFormField(
                      controller: descriptionController,
                      onChanged: (text) {
                        // final words = text.split('');
                        // _history.add(words.last);
                        // Update history with the new state if it changes
                        // Only update the history when a new word is completed (space detected)
                        if (text.endsWith(' ') || text.isEmpty) {
                          _updateHistory(text);
                        }
                        setState(() {});
                      },
                    ),
                    // ReUsableTextFormField(
                    //   controller: descriptionController,
                    //   HintName: 'Note Down Something',
                    //   HintTextStyle: App_Basic_Constants.HintTextStyle2,
                    //   MinLines: 7,
                    // ),
                    const SizedBox(height: 10),

                    // displaying the image from gallery or capture from camera

                    Expanded(
                      child: Container(
                        width: 300,
                        height: 100,
                        decoration: BoxDecoration(
                          image: pickedImage != null
                              ? DecorationImage(
                                  image: FileImage(File(pickedImage!.path)),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                      ),
                    ),
                    // Column(
                    //   children: [
                    //     QuillToolbar.simple(controller: _controller),
                    //     QuillEditor.basic(controller: _controller)
                    //   ],
                    // ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconContainer(
                            BottomIcons: Icon(Icons.image_search),
                            onPressed: () {
                              showMenu(
                                  context: context,
                                  position:
                                      RelativeRect.fromLTRB(100, 500, 800, 0),
                                  items: const [
                                    PopupMenuItem(
                                      child: Text("Take Picture"),
                                      value: 'Take_Picture',
                                    ),
                                    PopupMenuItem(
                                      child: Text("Upload Image"),
                                      value: 'Upload_Image',
                                    )
                                  ]).then((value) {
                                if (value != null) {
                                  _onSelectedMenu(value);
                                }
                              });
                            },
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          IconContainer(
                              BottomIcons: const Icon(Icons.text_format),
                              onPressed: () {}),
                          const SizedBox(
                            width: 5,
                          ),
                          IconContainer(
                              BottomIcons: const Icon(Icons.settings_voice),
                              onPressed: () {})
                        ],
                      ),
                    )
                  ],
                )),
          )
        ],
      )),
    );
  }

  Future<void> pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: source, // or ImageSource.camera
    );
    setState(() {
      pickedImage = pickedFile;
    });
  }

  // function for the icon when pressed
  void _onSelectedMenu(String SelectedValue) {
    switch (SelectedValue) {
      case 'Take_Picture':
        pickImage(ImageSource.camera);
        print('picture taken from the camera');
        break;
      case 'Upload_Image':
        pickImage(ImageSource.gallery);
        print('Image uploaded from gallery');
        break;
    }
  }
}
