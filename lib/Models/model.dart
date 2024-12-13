class NotesModel {
  final int? Id;
  final String Title;
  final String Description;
  final String DateAndTime;
  final String? Image;

  NotesModel(
      {this.Id,
      this.Image,
      required this.Title,
      required this.Description,
      required this.DateAndTime});

  NotesModel.fromMap(Map<String, dynamic> res)
      : Id = res['Id'],
        Image = res['Image'],
        Title = res['Title'],
        Description = res['Description'],
        DateAndTime = res['DateAndTime'];

  Map<String, Object?> toMap() {
    return {
      'Id': Id,
      'Image': Image,
      'Title': Title,
      'Description': Description,
      'DateAndTime': DateAndTime,
    };
  }
}
