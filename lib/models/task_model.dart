class TaskModel {
  String id;
  String title;
  DateTime dueDate;
  bool isDone;

  TaskModel({
    required this.id,
    required this.title,
    required this.dueDate,
    required this.isDone,
  });

  // Convert a TaskModel to a map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'dueDate': dueDate.toIso8601String(),
      'isDone': isDone,
    };
  }

  // Convert a map to a TaskModel
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'].toString(),
      title: json['title'],
      dueDate: DateTime.parse(json['dueDate'] ?? DateTime.now().toString()),
      isDone: json['isDone'] ?? json['completed'] ?? false,
    );
  }
}
