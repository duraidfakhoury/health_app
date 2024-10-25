// ignore_for_file: file_names

class HistoryModel {
  final int id;
  final int userId;
  final int foodId;
  final DateTime confirmedAt;
  final bool result;
  final List<int> sensitiveContents;

  HistoryModel({
    required this.id,
    required this.userId,
    required this.foodId,
    required this.confirmedAt,
    required this.result,
    required this.sensitiveContents,
  });

  // Factory constructor لتحويل البيانات من JSON إلى كائن HistoryModel
  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      id: json['id'],
      userId: json['user'],
      foodId: json['food'],
      confirmedAt: DateTime.parse(json['confirmed_at']),
      result: json['result'],
      sensitiveContents: List<int>.from(json['sensitive_contents']),
    );
  }
}
