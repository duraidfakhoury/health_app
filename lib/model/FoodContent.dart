// ignore_for_file: file_names

class FoodContent {
  final int id;
  final String name;

  FoodContent({required this.id, required this.name});

  factory FoodContent.fromJson(Map<String, dynamic> json) {
    return FoodContent(
      id: json['id'],
      name: json['name'],
    );
  }
}
